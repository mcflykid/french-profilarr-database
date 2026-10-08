// Executes the installed Arr upgrade specification in isolation on a local copy.
// Inputs are API profiles and parser-derived CF lists, never production writes.
using System.Collections;
using System.Reflection;
using System.Runtime.Loader;
using System.Text.Json;

if (args.Length != 4)
    throw new ArgumentException("Usage: NativeUpgrades radarr|sonarr assemblies snapshot.json cases.json");
var app = args[0];
if (app != "radarr" && app != "sonarr") throw new ArgumentException("Unsupported Arr type");
var directory = Path.GetFullPath(args[1]);
AssemblyLoadContext.Default.Resolving += (_, name) => {
    var file = Path.Combine(directory, name.Name + ".dll");
    return File.Exists(file) ? AssemblyLoadContext.Default.LoadFromAssemblyPath(file) : null;
};
var core = AssemblyLoadContext.Default.LoadFromAssemblyPath(Path.Combine(directory, app == "radarr" ? "Radarr.Core.dll" : "Sonarr.Core.dll"));
Type Native(string name) => core.GetType("NzbDrone.Core." + name, throwOnError: true);
object New(Type type) {
    var constructor = type.GetConstructors().OrderBy(c => c.GetParameters().Length).First();
    return constructor.Invoke(constructor.GetParameters().Select(p => p.HasDefaultValue ? p.DefaultValue : p.ParameterType.IsValueType ? Activator.CreateInstance(p.ParameterType) : null).ToArray());
}
void Set(object obj, string name, object value) => obj.GetType().GetProperty(name).SetValue(obj, value);
object Get(object obj, string name) => obj.GetType().GetProperty(name).GetValue(obj);
IList List(Type element) => (IList)Activator.CreateInstance(typeof(List<>).MakeGenericType(element));
var profileType = Native("Profiles.Qualities.QualityProfile");
var itemType = Native("Profiles.Qualities.QualityProfileQualityItem");
var formatType = Native("CustomFormats.CustomFormat");
var formatItemType = profileType.GetProperty("FormatItems").PropertyType.GetGenericArguments()[0];
var qualityType = Native("Qualities.Quality");
var modelType = Native("Qualities.QualityModel");
var configurationType = Native("Configuration.IConfigService");
var configuration = DispatchProxy.Create(configurationType, typeof(ConfigProxy));
var nlog = AssemblyLoadContext.Default.LoadFromAssemblyPath(Path.Combine(directory, "NLog.dll"));
var logger = nlog.GetType("NLog.LogManager").GetMethod("GetLogger", new[] { typeof(string) }).Invoke(null, new object[] { "ProfilarrUpgradeAudit" });
var specification = Activator.CreateInstance(Native("DecisionEngine.Specifications.UpgradableSpecification"), configuration, logger);
var isUpgradable = specification.GetType().GetMethod("IsUpgradable");
using var snapshotDocument = JsonDocument.Parse(File.ReadAllText(args[2]));
using var casesDocument = JsonDocument.Parse(File.ReadAllText(args[3]));
var snapshot = snapshotDocument.RootElement.GetProperty(app);
((ConfigProxy)configuration).ProperPolicy = snapshot.GetProperty("media").GetProperty("downloadPropersAndRepacks").GetString();
var qualityIds = new Dictionary<string, int>();
object Item(JsonElement json) {
    var item = New(itemType);
    Set(item, "Allowed", json.GetProperty("allowed").GetBoolean());
    var children = List(itemType);
    Set(item, "Items", children);
    if (json.TryGetProperty("id", out var id)) Set(item, "Id", id.GetInt32());
    if (json.TryGetProperty("name", out var name)) Set(item, "Name", name.GetString());
    if (json.TryGetProperty("quality", out var quality)) {
        var qualityId = quality.GetProperty("id").GetInt32();
        qualityIds[quality.GetProperty("name").GetString()] = qualityId;
        Set(item, "Quality", qualityType.GetMethod("FindById").Invoke(null, new object[] { qualityId }));
    }
    foreach (var child in json.GetProperty("items").EnumerateArray()) children.Add(Item(child));
    return item;
}
var profiles = new Dictionary<string, object>();
var formatsByProfile = new Dictionary<string, Dictionary<string, object>>();
foreach (var json in snapshot.GetProperty("profiles").EnumerateArray()) {
    var profile = New(profileType);
    var name = json.GetProperty("name").GetString();
    Set(profile, "Name", name);
    Set(profile, "UpgradeAllowed", json.GetProperty("upgradeAllowed").GetBoolean());
    foreach (var property in new[] { "Cutoff", "MinFormatScore", "CutoffFormatScore", "MinUpgradeFormatScore" }) {
        var key = char.ToLowerInvariant(property[0]) + property[1..];
        Set(profile, property, json.GetProperty(key).GetInt32());
    }
    var items = List(itemType);
    foreach (var item in json.GetProperty("items").EnumerateArray()) items.Add(Item(item));
    Set(profile, "Items", items);
    var formatItems = List(formatItemType);
    var formats = new Dictionary<string, object>();
    foreach (var f in json.GetProperty("formatItems").EnumerateArray()) {
        var format = New(formatType);
        var item = New(formatItemType);
        Set(format, "Id", f.GetProperty("format").GetInt32());
        Set(format, "Name", f.GetProperty("name").GetString());
        formats[f.GetProperty("name").GetString()] = format;
        Set(item, "Format", format);
        Set(item, "Score", f.GetProperty("score").GetInt32());
        formatItems.Add(item);
    }
    Set(profile, "FormatItems", formatItems);
    profiles[name] = profile;
    formatsByProfile[name] = formats;
}
object Model(JsonElement release) {
    var model = New(modelType);
    Set(model, "Quality", qualityType.GetMethod("FindById").Invoke(null, new object[] { qualityIds[release.GetProperty("quality").GetString()] }));
    var revision = Get(model, "Revision");
    foreach (var (key, property) in new[] { ("version", "Version"), ("real", "Real") })
        Set(revision, property, release.GetProperty("revision").GetProperty(key).GetInt32());
    Set(revision, "IsRepack", release.GetProperty("revision").GetProperty("isRepack").GetBoolean());
    return model;
}
IList Formats(string profile, JsonElement release) {
    var list = List(formatType);
    foreach (var cf in release.GetProperty("formats").EnumerateArray()) list.Add(formatsByProfile[profile][cf.GetString()]);
    return list;
}
int count = 0, failures = 0;
foreach (var test in casesDocument.RootElement.EnumerateArray().Where(c => c.GetProperty("arr").GetString() == app)) {
    var name = test.GetProperty("profile").GetString();
    var current = test.GetProperty("current");
    var candidate = test.GetProperty("candidate");
    var outcome = isUpgradable.Invoke(specification, new object[] { profiles[name], Model(current), Formats(name,current), Model(candidate), Formats(name,candidate) }).ToString();
    var expected = test.GetProperty("expected").GetString();
    count++;
    if (outcome != expected) { failures++; Console.WriteLine($"FAIL {name}: {test.GetProperty("label").GetString()}: expected={expected}, actual={outcome}"); }
}
if (count == 0) throw new InvalidOperationException("No upgrade cases for the requested Arr application");
Console.WriteLine($"Native upgrades {app} {core.GetName().Version}: {count-failures}/{count} cases, {failures} failures; API profiles and installed assemblies");
Environment.ExitCode = failures == 0 ? 0 : 1;

public class ConfigProxy : DispatchProxy {
    public string ProperPolicy { get; set; }
    protected override object Invoke(MethodInfo target, object[] arguments) {
        if (target.Name == "get_DownloadPropersAndRepacks") return Enum.Parse(target.ReturnType, ProperPolicy, ignoreCase: true);
        throw new InvalidOperationException("Unexpected configuration access: " + target.Name);
    }
}

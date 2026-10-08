# Décisions natives Arr, sans démarrer Arr

Ce programme invoque les bibliothèques **réellement installées**, copiées localement en lecture seule. Il ne lance pas l'application, ne contacte pas son API et ne modifie pas ses fichiers. Testé sur Radarr 6.4.4.10685 et Sonarr 4.0.20.3014 avec un SDK .NET 8.

Conserver hors du dépôt un export API sans secrets et les DLL de chaque application (`Radarr.Core.dll` ou `Sonarr.Core.dll`, avec toutes leurs DLL dépendantes). Ne jamais lancer le binaire principal pour obtenir sa version ; lire `GET /api/v3/system/status`.

```bash
PARSER_URL=http://localhost:5000 python3 scripts/prepare_upgrade_cases.py export.json > cases.json
dotnet build tests/native-upgrades/NativeUpgrades.csproj --artifacts-path /tmp/native-upgrades
dotnet /tmp/native-upgrades/bin/NativeUpgrades/debug/NativeUpgrades.dll radarr /chemin/dll-radarr export.json cases.json
dotnet /tmp/native-upgrades/bin/NativeUpgrades/debug/NativeUpgrades.dll sonarr /chemin/dll-sonarr export.json cases.json
```

L'export doit correspondre aux scores du SQL testé. Un export projeté localement permet une simulation avant déploiement ; il ne constitue jamais une preuve de synchronisation. Après publication, refaire les essais avec l'export réel.

Le résultat attendu est indépendant de la réponse native : promotion/rétrogradation de résolution, bonus REPACK inférieur au seuil, gain langue de 1500, passage SpK79 à QTZ et le cas réel La Momie. Le test refuse tout accès inattendu à la configuration. Limites : seules les décisions de `UpgradableSpecification` sont exécutées ; les CF sont calculés en amont par le parser et les conditions SQL, pas par toute la chaîne Arr.

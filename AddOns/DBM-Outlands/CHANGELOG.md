# <DBM> Outlands

## [2.5.36](https://github.com/DeadlyBossMods/DBM-BCC/tree/2.5.36) (2022-05-17)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-BCC/compare/2.5.35...2.5.36) [Previous Releases](https://github.com/DeadlyBossMods/DBM-BCC/releases)

- prep new retail and tbc tags  
- update luacheck  
- swp/felmyst: NoFilter on vapor & encap Warning (#3)  
- Improve notes  
- Add support for more auto icon localized texts. Renames too so yes every old module is also being updated here in a second.  
- Rename Icon auto local globals  
- Logic fixes to last and fixes to arg differences on SetAlphaIcon compat  
- Cleaned up new icon code and added more functions. DBM now has an auto object that can set icons using following sorted methods: 1. Setting icons on targets prioriizing melee over ranged, and if multiple melee then prioritizing sorting multiple melee alphabetical 2. Setting icons on targets prioriizing melee over ranged, and if multiple melee then prioritizing sorting multiple melee by raid roster numeric index. 3. Setting icons on targets prioritizing ranged over melee, then if multiple ranged then prioritizing sorting multiple ranged alphabetical 4. Setting icons on targets prioritizing ranged over melee, then if multiple ranged then prioritizing sorting multiple ranged by raid roster index. 5. Simply not caring about ranged or melee and just setting icons sorting them alphabetically 6. Simply not caring about ranged or melee and just setting icons by raid roster index. technically 5 and 6 aren't new features. they've been supported for years but code was cleaned up and streamlined so all 6 of above functions use a single prototype  
- Refine comment and code to show intent, but it's still not done.  
- tweak  
- Muru Update  
     - Slight adjustment to human spawn timers to line up better with their spawns  
     - Black hole target is now detectable  
     - Fixed a bug where false add spawn alerts could still fire/start new timers after phase 2 trigger has happened  
     - Tweaks to black hole initial timer (was too long before)  
- Brutallus Update  
     - enabled burn target announce warning, since it now announces BOSSES target only and not spreads.  
     - In addition, if you are the target of the bosses burn, you'll now get a warning that you are target about a full second faster since SUCCESS passes target in classic (when it didn't in original tbc)  
     - Slight timer tweaks (talking .3 seconds here, any timer reports beyond that have been verifeid normal variance and not a DBM issue)  
- Fixes to KJ timers  
- Re update hyjal wave timer localization.kr (#1)  
- Bump alphas  

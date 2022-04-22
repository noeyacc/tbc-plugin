# <DBM> Outlands

## [2.5.34](https://github.com/DeadlyBossMods/DBM-TBC-Classic/tree/2.5.34) (2022-04-12)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-TBC-Classic/compare/2.5.33...2.5.34) [Previous Releases](https://github.com/DeadlyBossMods/DBM-TBC-Classic/releases)

- fixed bug that caused tbc to flag every update as a new patch update (thus causing force update to run every update since patch 2.5.4. It's not intended behavior for the force to run every update, just for major patches. Also prep for new tags  
- Kill off adds timer on Jan'alai, apparently this is health based  
- fix lua error when calling \"whereami\" command in a zone that has no map  
- Peel back some of debug spam  
- Remove this useless variable  
- Add in some core debug  
- Hex Lord Update:  
     - Re-add concecration warning  
     - Added GTFO for concecration and rain of fire  
     - Added whirlwind warning  
     - Improved code readability by removing lazy names and making each object clearer  
- note it so it doesn't happen again  
- Fixed a logic regression that caused all regular announces to have no sounds unless they had voice pack sounds. apparently only one user out of hundreds f thousands noticed this in 3 weeks. 🤷‍♂️  
- Fix something that slipped through last  
- Add support for alternate string for Azgalor  
- Update localization.kr.lua (#113)  
- bump alpha  

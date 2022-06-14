# <DBM> Outlands

## [2.5.37](https://github.com/DeadlyBossMods/DBM-BCC/tree/2.5.37) (2022-06-07)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-BCC/compare/2.5.36...2.5.37) [Previous Releases](https://github.com/DeadlyBossMods/DBM-BCC/releases)

- prep new TBC tag  
- Attempt to fix some bugs with wipe detection not being fast in classic, especialy on twins.  
- GUI: Colorized TColor dropdown (#128) Better UI/UX for TColor dropdown, since the assigned color names are not representative.  
- fix remapping bug  
- swp/kalecgos: add health to custom frame (#5)  
- set new alpha cycle  
- Bump version  
- toc bump  
- Fix https://github.com/DeadlyBossMods/DBM-BCC/issues/4  
- Add proper detection of HoA difficulty indices  
- Fix boss spelling  
- adjust darktouch stack count by feedback.  
- Fixed a bug where the informational nerf was applyed to voice pack sounds even if the setting wasn't enabed Informational nerf now also disables the range checker, since the range checker uses information not normally available to player (it basically exploits a bug blizzard never fixed in item check code). As such, it goes beyond the scope of providing information avaialble to base UI and should be included in the nerf.  
- Update localization.cn.lua (#126)  
- Update zhTW (#125)  
- Update koKR (#124)  
- Update localization.ru.lua (#122)  
- Update localization.ru.lua (#123)  
- Update localization.ru.lua (#121)  
- Also remap adds alerts to only use \"adds are coming\" when in \"informational only\" mode.  
- Fixed a bug where filtered role specla announcements still played voice alerts Fixed a bug where the soak filter type wasn't filtering alerts that contain a soak position Added a new optiont to completely disable instructional alerts/audio. This is WIP (especially on voice pack end) but the goal is to provide ability to make DBM purely informational and do literally zero handholding or instruction what so ever. This will likely become the default (and maybe even mandatory if blizzard wills it) in the future when it's complete and no longer WIP.  
- Missed a line  
- Add combat log redundancy to twins to ensure alerts and timers don't go missing if locales are  
- Update zhTW (#118)  
- Update localization.ru.lua (#120) Translation of some phrases.  
- Update localization.cn.lua (#119)  
- Update koKR (#117)  
- Bump alphas  

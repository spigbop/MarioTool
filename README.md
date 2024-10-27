![Mario Tool](https://i.imgur.com/uQdEY8F.png)

![MarioTool version](https://img.shields.io/badge/version-0.50.1-blue?style=for-the-badge)
![GitHub repo size](https://img.shields.io/github/repo-size/spigbop/MarioTool?style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/spigbop/MarioTool?style=for-the-badge)

The characters and assets (graphics, audio) all belong to and/or are inspired from Nintendo. This is an unofficial fan-game made by someone who grew up on awesome games those people make, so if you like this consider buying official Nintendo games.

[![itch.io](https://img.shields.io/badge/itch.io-%23FF0B34.svg?logo=Itch.io&logoColor=white&style=for-the-badge)](https://xpoxy.itch.io/mariotool)

# Console, Deferation, Total Control! (Changelog - 0.50.1)
- Skipped adding a few updates to bundle up the console in one go.
- Adds Object Deferation (access properties and methods in-game) as a standalone class, generator deferations now rely on it.
- Adds the Console (press ` to open by default), the console can get or set any variable or call any function.
- Adds 3 console contexes, being the game, the level, and the player. (switchable by \ by default)
- Adds the Font Baker to easily create new fonts with atlases. (Yes i did this one by one before.)
- Adds Text Methods with 2 initial naming conventions. Unicode method splits atlas textures and names character files with their unicode. Filename method is the legacy one, it uses the character itself to name files.
- Adds the 'Soap Sans' font with the unicode method to be used in the console.
- The font SMAS Outline now uses the unicode method.
- Fonts now have config files with properties: width and monospaced.
- Adds the TextBox control.
- Adds the Do Timer which applies deferation on the parent on timeout.
- Adds the SMM2 Super Mario Bros. Forest (SNES reimagination) music track.
- Adds a new level: forest_level. (currently only just a duplicate of demo level, only accesible via console)
- Adds free jump cheat to the player. When enabled it forces jumps on 'z' presses.
- Levels bases now have their own Level class.
- Adds spawn methods to the level class. (`spawn`, `spawn_enemy`, `spawn_powerup`)
- Adds console placeholders: %dt and %pdt for deltatime, !adv and !pdv for process events.
- Adds console history.
- Adds the console log method: `println`
- The console log now shows 11 lines.
- The console now only loads when the game is run in debug mode.
- Adds the console help provider method: `help_log`
- Adds the `methods` and `props` commands to the console.
- Disables vsync by default.
- Adds the `set_vsync` method to the main class.
- Adds the `fps` method to the main class.
- Adds the fps counter to the debug menu.
- Adds the `enter_level` method to the main class.
- Loading levels now logs to the console.
- Adds the `safe_convert` method to the mathx class.
- Fixes an issue with the player audios playing on x:0 and y:0
- Fixes a potential issue with content block audios playing on x:0 and y:0


# Roadmap

| |Feature|Plan|Description|
|-|-|-|-|
|**Mechanics**| | | |
||Tiles|✅ Done||
||Objects|✅ Done||
|![img](https://i.imgur.com/qjX1MtK.gif)|Mario|✅ Done|Same old plumber.|
|![img](https://i.imgur.com/R5GySVD.gif)|Luigi|For Release|Same old plumber. Higher jump, less acceleration and friction.|
||Ledge AI|✅ Done|Objects that can turn when met with a ledge|
|![img](https://i.imgur.com/v2XARhq.gif)|Water & Swimming|For Release| |
||Slopes|After 1.0||
|**Enemies**| | | |
||Goomba|✅ Done|Goomba enemy from SMB.|
||Koopa Troopa|✅ Done|Koopa Troopa enemy from SMB.|
||Bullet Bill & Blaster|✅ Done|Bullet Bill enemy from SMB.|
||Piranha Plant|✅ Done|Piranha Plant enemy from SMB.|
|![img](https://i.imgur.com/hd4pyzr.gif)|Buzzy Beetle|✅ Done|Buzzy Beetle enemy from SMB.|
|![img](https://i.imgur.com/36Ln0Dz.gif)|Blooper|For Release|Blooper enemy from SMB.|
|![img](https://i.imgur.com/iX7FJpr.gif)|Cheep Cheep|For Release|I love fish.|
||Paratroopas|For Release|Flying koopas.|
||Lakitu|For Release|Throws spinies.|
||Podoboo|For Release|Podoboo enemy from SMB.|
||Fire Piranha Plant|After 1.0|Fire Piranha Plant enemy from SMB3.|
||Wiggler|After 1.0|Wiggler enemy from SMW.|
||Banzai Bill|After 1.0|Banzai Bill enemy from SMW.|
|**Bosses**| | | |
|![img](https://i.imgur.com/HnjSbn5.gif)|Bowser|For Release|Bowser from SMB.|

# Asset Credits

|Asset|Credits|
|-|-|
|Super Mario World - Valley of Bowser (Restored Version)|[LadiesMan217](https://www.youtube.com/@LadiesMan217)|
|Super Mario Maker 2 - Super Mario Bros. Forest (Snes reimagination)|[Tater-Tot Tunes](https://youtu.be/LWWHX6QPfeA)|
|Yoshi's Island - Game Over (Restored Version)|[michael02022 from Church of Kondo](https://youtu.be/fd936VoGtNo)|
|Super Mario Allstars Super Mario Bros Assets|Nintendo (Ripped by [me](https://github.com/spigbop) and [Spriters Resource](https://www.spriters-resource.com/snes/smassmb1/))|

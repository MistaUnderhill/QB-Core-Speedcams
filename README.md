Speedcams - Need for Speed Style Speed Cameras
Author: MistaUnderhill

This script adds Need for Speed-style speed cameras around the map, with configurable police responses. It also includes a leaderboard for tracking the top speeds of players. The script utilizes QB-Core, OxMySQL, and CritLobby.

TRY IT HERE: cfx.re/join/d4vr33

Features - 
Speed Cameras: Speed cameras are placed around the map to monitor vehicle speed.
Police Response: Optional configurable police response to speeding violations, with multiple options for different levels of police involvement.
Leaderboard: A leaderboard tracks the top speeds achieved by players, allowing for competition and bragging rights.
Customizable Settings: Adjust camera locations, speed limits, and police response behavior in the configuration file.

Requirements - 
qb-core: The core framework for the script.
oxmysql: Database integration.
critLobby: For managing lobby and server functionalities.

Installation - 
Download the Script: Download or clone the repository.
Drag and Drop: Place the Speedcams folder into your resources directory.
Server Configuration: Open your server.cfg file and add the following line: start Speedcams
Restart Server: Restart your server to apply the changes.

Configuration - 
The script is fully configurable. You can modify the speed limits, camera locations, and police responses via options in the client.lua and server.lua

Leaderboard - 
The script tracks the top speeds reached by players across the server.
You can view the leaderboard in-game to see who has the fastest times.
The leaderboard is stored in the database and can be reset if needed via the configuration.

Using the script - 
To open the menu, simply use the command "/speedcams"

Troubleshooting - 
Script not working after installation: Ensure that all dependencies (qb-core, oxmysql, critLobby) are correctly installed and configured.
Police responses not triggering: Check the configuration settings to make sure police response thresholds are set properly.
Leaderboard not displaying: Ensure the database is properly set up and connected. Verify oxmysql configuration for proper data saving.

License - 
This script is free to use and modify. Please credit me! :)

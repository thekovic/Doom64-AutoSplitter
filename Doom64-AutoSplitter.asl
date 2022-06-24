state("DOOM64_x64", "Feb 27 2022 Steam")
{
    int map: 0x7296AC;
    int warpTarget: 0x543428;
    int inGameTimer: 0x75B210;
    int mainMenu: 0x53AC24;
    int pause: 0x66817C;
    int gameState: 0x53FED4;
    int playerHealth: 0x75B270;
}
state("DOOM64_x64", "May 23 2022 GOG")
{
	int map: 0x714F4C;
    int warpTarget: 0x5300D8;
    int inGameTimer: 0x746970;
    int mainMenu: 0x527C04;
    int pause: 0x653B7C;
    int gameState: 0x52CC54;
    int playerHealth: 0x7469D0;
}

startup
{
    vars.gameTimer = 0f;
	
    settings.Add("ILstart", false, "IL Autostart");
}

init
{
    switch (modules.First().ModuleMemorySize)
    {
        case 8409088: // 5.85 MB (6,136,832 bytes)
            version = "Feb 27 2022 Steam";
            break;
        case 8323072: // 5.76 MB (6,047,744 bytes)
            version = "May 23 2022 GOG";
            break;
        default:
            version = "UNKNOWN";
            MessageBox.Show(timer.Form, "Doom 64 autosplitter startup failure. \nCould not recognize what version of the game you are running", "Doom 64 startup failure", MessageBoxButtons.OK, MessageBoxIcon.Error);
            break;
    }
}

start
{
    if ( ( (current.map == 1 || current.map == 34) || (settings["ILstart"] && current.map != 33) ) && current.mainMenu == 0 && current.playerHealth != 0 && current.pause != 1)
    {
        vars.gameTimer = 0f;
        return true;
    }
}

update
{
    int delta = current.inGameTimer - old.inGameTimer;
    if (delta < 0)
    {
        delta = 0;
    }
    vars.gameTimer += delta;
}

gameTime
{
	return TimeSpan.FromSeconds(vars.gameTimer / 30f);
}

split
{
    if ((current.map > old.map) || (current.map == 28 && current.gameState == 4) || (current.warpTarget == 70))
    {
        return true;
    }
}

reset
{
    if (current.warpTarget == 70)
    {
        return false;
    }
    if (current.mainMenu == 1 && current.pause == 1)
    {
        vars.gameTimer = 0f;
        return true;
    }
}

isLoading
{
    return true;
}
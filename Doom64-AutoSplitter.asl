state("DOOM64_x64", "Feb 27 2022")
{
    int map: 0x7296AC;
    int warpTarget: 0x543428;
    int inGameTimer: 0x75B210;
    int mainMenu: 0x53AC24;
    int pause: 0x66817C;
    int gameState: 0x53FED4;
    int playerHealth: 0x75B270;
}

startup
{
    vars.gameTimer = 0f;
}

start
{
    if ((current.map == 1 || current.map == 34) && current.mainMenu == 0 && current.playerHealth != 0)
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
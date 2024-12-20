local player = {
    xMove = 0,
    fallRate = 0,
    isFalling = true,
    canCheckFall = true
}
local xPosMove = 0
local objectsToIgnore = {"sky", "player", "debug"}
local objectsList = {}

function onCreatePost()
    playSound("begin")
    runTimer("infLoopSong", 1.6)

    setProperty("camGame.alpha", 0)
    setProperty("camHUD.alpha", 0)

    makeText('debug', 0, 0, 20)
    setTextAlignment("debug", "right")
    setTextBorder("debug", 2, "000000")
    spriteMake('sky',   0, 0, 1920, 1080, "00AAFF", true)
    spriteMake('player', 600, 300, 48, 48, "FF0000")

    local levelData = {
        {'grass', 0, 640, 1920, 96, "00FF00"},
        {'wall', 0, 385, 48, 256, "FFFF00"},
        {'wall', 800, 200, 48, 256, "FFFF00"},
        {'grass', 1500, 500, 300, 32, "00FF00"},
        {'text', 750, 500, "Level 1: Hell"},
        {'text', 0, 200, "welcome to lua playground :D"},
        {'text', 420, 400, "the s of the f"},
    }

    for i=1,#levelData do
        if stringStartsWith(levelData[i][1], "text") then
            makeText(levelData[i][1]..i, levelData[i][2], levelData[i][3], 40)
            setTextString(levelData[i][1]..i, levelData[i][4])
            setTextBorder(levelData[i][1]..i, 2, "000000")
        else
            spriteMake(levelData[i][1]..i, levelData[i][2], levelData[i][3], levelData[i][4], levelData[i][5], levelData[i][6])
        end
    end
end

function onUpdate(elapsed)
    -- Player
    player.xMove = player.xMove + ((keyboardPressed("Q") or keyboardPressed("A")) and -0.1 or 0)
    player.xMove = player.xMove + (keyboardPressed("D") and 0.1 or 0)
    xPosMove = xPosMove + player.xMove
    setProperty("player.x", 624 + player.xMove*16)

    if player.xMove ~= 0 then
        if not player.isFalling then
            if player.xMove <= 0 then
                player.xMove = player.xMove + 0.05
            else
                player.xMove = player.xMove - 0.05
            end
        end

        if player.xMove <= -5 then
            player.xMove = -5
        end

        if player.xMove >= 5 then
            player.xMove = 5
        end
    end

    if keyJustPressed("space") and not player.isFalling then
        playSound('confirmMenu')
        player.fallRate = -5.5
        player.isFalling = true
        player.canCheckFall = false
    end

    if player.isFalling then
        setProperty("player.y", getProperty("player.y") + player.fallRate)
        player.fallRate = player.fallRate + 0.1
    end

    player.isFalling = true
    for i=1,#objectsList do
        if player.canCheckFall then
            if objectsOverlap("player", objectsList[i][1]) and stringStartsWith(objectsList[i][1], "grass") then
                player.isFalling = false
                player.fallRate = 0
            end
        end
        if objectsOverlap("player", objectsList[i][1]) and stringStartsWith(objectsList[i][1], "wall") then
            if player.xMove <= 0 then
                repeat
                    player.xMove = player.xMove + 1
                    setProperty("player.x", 624 + player.xMove*16)
                until not objectsOverlap("player", objectsList[i][1])
            else
                repeat
                    player.xMove = player.xMove - 1
                    setProperty("player.x", 624 + player.xMove*16)
                until not objectsOverlap("player", objectsList[i][1])
            end
        end
    end

    for i=1,#objectsList do
        setProperty(objectsList[i][1]..".x", objectsList[i][2] - xPosMove)
    end

    player.canCheckFall = true
    player.xMove = string.format("%.2f",player.xMove)

    setTextString("debug", player)
    if keyboardJustPressed("A") then
        restartSong(true)
    end
    if keyboardJustPressed("E") then
        exitSong(true)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "infLoopSong" then
        playSound("game")
        runTimer("infLoopSong", 50.35)
    end
end

function onStartCountdown()
    return Function_Stop
end

function spriteMake(name, x, y, width, height, color, center)
    local noAdd = false
    for i=1,#objectsToIgnore do
        if objectsToIgnore[i] == name then
            noAdd = true
            break
        end
    end
    if not noAdd then
        table.insert(objectsList, {name, x})
    end
    makeLuaSprite(name, "", 0, 0)
    makeGraphic(name, width, height, color)
    addLuaSprite(name)
    setObjectCamera(name, "other")
    setProperty(name..".x", x)
    setProperty(name..".y", y)
    if center then
        screenCenter(name)
        setProperty(name..".y", y)
    end
end

function makeText(name, x, y, size)
    local noAdd = false
    for i=1,#objectsToIgnore do
        if objectsToIgnore[i] == name then
            noAdd = true
            break
        end
    end
    if not noAdd then
        table.insert(objectsList, {name, x})
    end
    makeLuaText(name, name, 1280, x, y)
    setTextSize(name, size)
    setTextAlignment(name, 'CENTER')
    addLuaText(name)
    setObjectCamera(name, 'camOther')
    setTextBorder(name, 0)
end
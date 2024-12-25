-- Made by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)
-- Don't steal this! It's stupid if you did.

-- Session
local xPosMove = 0
local sessionScore = 0
local sessionCombo = 0
local sessionLives = 3
local isInvisible = false
local isGameOver = false

-- To not overuse a lot
local swooshSpawn = 0
local pewSpawn = 0
local enemySpawn = 0
local textSpawn = 0
local opti = ""

-- Kind of getting rid of the lag
local pewRemoved = 1
local enemyRemoved = 1

function onCreatePost()
    -- We don't want that
    setProperty("camHUD.alpha", 0)
    setProperty("camGame.alpha", 0)

    -- Sprite
    spriteMake('shooter', 0, 600, 48, 48, "FF0000", true)
    spriteMake('scoreTween', 0, 0, 0, 0, "000000", true)

    -- Text
    makeText('scorePoints', 10, 10, 28)
    setTextAlignment("scorePoints", "left")

    runTimer("swoosh", 0.03, 0)
    runTimer("enemySpawn", 2, 1)
end

function onUpdate(elapsed)
    if not isGameOver then
        -- Sessions
        setTextString("scorePoints", "Score: "..math.floor(getProperty("scoreTween.x")).."\nLives: "..sessionLives)
        if keyJustPressed("space") then
            pewSpawn = pewSpawn + 1
            opti = "pew"..pewSpawn
            spriteMake(opti, getProperty("shooter.x")+20, getProperty("shooter.y")-25, 4, 64, "FF0000")
            doTweenY(opti, opti, -250, 1.5, "linear")
        end

        -- Enemy Behavior (they hit you)
        for i=enemyRemoved, enemySpawn do
            for ii=pewRemoved, pewSpawn do
                if objectsOverlap("enemy"..i, "pew"..ii) then
                    sessionCombo = sessionCombo + 1
                    incrementScore(10*sessionCombo, {getProperty("enemy"..i..".x"), getProperty("enemy"..i..".y")})
                    removeLuaSprite("enemy"..i)
                    removeLuaSprite("pew"..ii)
                    break
                end
            end
            if objectsOverlap("enemy"..i, "shooter") then
                if isInvisible then break else sessionLives = sessionLives - 1 end
                if sessionLives == 0 then gameOver() break end
                isInvisible = true
                runTimer("backsible", 3)
            end
        end

        -- Player Properties.
        xPosMove = xPosMove - ((keyboardPressed("Q") or keyboardPressed("A")) and 0.1 or 0)
        xPosMove = xPosMove - (keyboardPressed("D") and -0.1 or 0)
        if xPosMove ~= 0 then
            if xPosMove <= 0 then
                xPosMove = xPosMove + 0.05
                if xPosMove <= -5 then
                    xPosMove = -5
                end
            else
                xPosMove = xPosMove - 0.05
                if xPosMove >= 5 then
                    xPosMove = 5
                end
            end
        end
        xPosMove = string.format("%.2f",xPosMove)
        setProperty("shooter.x", getProperty("shooter.x") + xPosMove)
        local playerX = getProperty("shooter.x")
        if playerX <= -100 then setProperty("shooter.x", 1324) end
        if playerX >= 1325 then setProperty("shooter.x", -99) end
        if isInvisible then setProperty("shooter.alpha", 0.5) else setProperty("shooter.alpha", 1) end

        -- Fun things i've included
        doTweenX("twEEEEEn", "scoreTween", sessionScore+0.1, 0.1, "linear")
    else
        if keyJustPressed("accept") then
            restartSong(true)
        end
        if keyJustPressed("reset") then
            exitSong(true)
        end
    end
end

function onStartCountdown()
    return Function_Stop
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "backsible" then isInvisible = false end
    if stringStartsWith(tag, "insER") then enemyRemoved = enemyRemoved + 1 end
    if tag == "swoosh" then
        opti = "woosh"..swooshSpawn
        swooshSpawn = swooshSpawn + 1
        spriteMake(opti, getRandomFloat(-10, 1350), -250, 4, 64, "FFFFFF")
        setProperty(opti..".alpha", getRandomFloat(0.1, 0.5))
        doTweenY(opti, opti, getRandomFloat(800, 1100), getRandomFloat(3, 3.5), "linear")
    end
    if tag == "enemySpawn" then
        enemySpawn = enemySpawn + 1
        opti = 'enemy'..enemySpawn
        local length = getRandomFloat(10, 15)
        spriteMake(opti, getRandomFloat(0, 1232), -100, 48, 48, "676700")
        doTweenY(opti, opti, 1200, length, "linear")
        runTimer("enemySpawn", getRandomFloat(1,2), 1)
        runTimer("insER"..enemySpawn, length)
    end
end

function onTweenCompleted(tag)
    if luaSpriteExists(tag) then
        if stringStartsWith(tag, "pew") then sessionCombo = 0; pewRemoved = pewRemoved + 1 end
        removeLuaSprite(tag)
    elseif luaTextExists(tag) then
        removeLuaText(tag)
    end
end

function gameOver()
    isGameOver = true
    for i=1, pewSpawn do
        if luaSpriteExists("woosh"..i) then removeLuaSprite("woosh"..i) end
        if luaSpriteExists("enemy"..i) then removeLuaSprite("enemy"..i) end
        if luaSpriteExists("pew"..i) then removeLuaSprite("pew"..i) end
    end
    setTextString("scorePoints", "Your Session Score: "..sessionScore)
    removeLuaSprite("shooter")
    cancelTimer("swoosh")
    cancelTimer("enemySpawn")
    makeText('over', 0, 300, 60)
    setTextString("over", "Game Over! Retry?")
    makeText('hint', 0, 375, 16)
    setTextString("hint", "Press ACCEPT to retry, Press RESET to leave.")
end

function makeText(name, x, y, size)
    makeLuaText(name, name, 1280, x, y)
    addLuaText(name)
    setObjectCamera(name, "other")
    setTextBorder(name, 0)
    setTextSize(name, size)
end

function spriteMake(name, x, y, width, height, color, center)
    makeLuaSprite(name, "", x, y)
    makeGraphic(name, width, height, color)
    addLuaSprite(name)
    setObjectCamera(name, "other")
    if center then
        screenCenter(name)
        setProperty(name..".y", y)
    end
end

function incrementScore(points, xy)
    sessionScore = sessionScore + points
    textSpawn = textSpawn + 1
    opti = "popup"..textSpawn
    local y = xy[2]
    makeText(opti, xy[1]-615, y-25, 32)
    setTextString(opti, points)
    doTweenY(opti, opti, y-200, 1, "linear")
    doTweenAlpha(opti.."bye", opti, 0, 1, "linear")
end
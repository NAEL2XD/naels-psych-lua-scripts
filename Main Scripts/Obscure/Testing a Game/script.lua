--[[ 
    GAME WAS MADE BY NAEL2XD!!
    Compatible with Psych 0.6.3!

    CREDITS:
    Nael2xd: i made a game
    You: Playing my script game
]]

-- SETTINGS --

local nextWhenSecHit = 2 --Higher the number, the easy it gets. (DEFAULTS TO 2 IF 0)
local defaultMax = 10 --Higher the number means you have to press more space

--==--==--==--==--==--==--==--==--==--==--== Don't edit any below if you don't know what you are doing!! ==--==--==--==--==--==--==--==--==--==--==--

local nextCurSec = nextWhenSecHit --yeah
local points = 0 -- the points in game
local guess = 0 -- if you press space you increment by 1
local target = math.random(1, defaultMax) -- uhh yeah randomizes letter 1 thru 10
local spaceLetGo = true --just so it doesn't do it every frame
local streak = 0 --Just like a winstreak, but yeah

function onCreatePost()
    if nextWhenSecHit == 0 then
        nextCurSec = 2
    end
    makeText('points')
    makeText('target')
end

function onUpdate(elapsed)
    setProperty('points.text', "Points: " ..points.. " | Guess: " ..guess.. " | Streak: " .. streak)
    setProperty('target.text', target)
    if keyPressed('space') and spaceLetGo == true then -- Detect if the space key is held
        guess = guess + 1
        spaceLetGo = false
    end
    if not keyPressed('space') then -- Detect if the space key is let go
        spaceLetGo = true
    end
end

function onSectionHit()
    if curSection == nextCurSec then
        if target == guess then
            streak = streak + 1
            points = points + (1 * streak)
            debugPrint('+', streak)
            playSound('COPY-FINISH')
        else
            debugPrint('YOU RUINED IT!! | Streak lost: ', streak)
            streak = 0
        end
        guess = 0
        nextCurSec = curSection + nextWhenSecHit
        target = math.random(1, defaultMax)
    end
end

function makeText(name)
    if name == 'target' then
        makeLuaText(name, name, 1280, 0, 500)
        setTextSize(name, 140)
    else
        makeLuaText(name, name, 1280, 0, 650)
        setTextSize(name, 37)
    end
    setTextAlignment(name, 'CENTER')
    addLuaText(name)
    setObjectCamera(name, 'camOther')
end
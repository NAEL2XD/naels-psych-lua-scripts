--
-- What does this script do?
-- 1. Makes it middle scroll
-- 2. Adds a little line above the strums like how some osu skin does
-- 3. Uses background overlay, covering 95% of camGame in blackness, you can change it with the backOverlay value.
-- 4. Adds a osu type key hit in the bottom left corner, you can change this too.
--

-- How opaque you want the overlay to be, Min: 0, Max: 1
local backOverlay = 0.95

-- Key Names? Must be 1 letter or it'll choose the current first letter
local enableKeyHit = true 
local mahKeys = {"L", "D", "U", "R"}

function onCreatePost()
    if not backOverlay == 0 then
        makeLuaSprite("1", "1")
        makeGraphic("1", 1280, 720, '000000')
        addLuaSprite("1", true)
        setProperty("1.scale.x", 999)
        setProperty("1.scale.y", 999)
        screenCenter("1")
        setProperty("1.alpha", backOverlay)
    end

    makeLuaSprite("2", "2")
    makeGraphic("2", 500, 3, 'FFFFFF')
    addLuaSprite("2", true)
    screenCenter("2")
    setProperty("2.alpha", 0.975)
    setObjectCamera("2", "camHUD")
    setProperty("2.y", 53.5)

    if enableKeyHit then
        local x = 235
        local y = 50
        local name = ""
    
        if downscroll then y = 40 else y = 650 end
    
        for i=1, 4, 1 do
            name = "button"..i
            makeLuaSprite(name, "", x, y)
            makeGraphic(name, 64, 64, '707070')
            addLuaSprite(name)
            setObjectCamera(name, "camHUD")
            x = x - 75
        end
    
        x = 600
        for i=1, 4, 1 do
            name = "name"..i
            makeLuaText(name, string.sub(mahKeys[i], 1, 1), 1280, -x, y)
            addLuaText(name)
            setTextSize(name, 50)
            x = x - 75
        end
    end
end

function onBeatHit()
    if not backOverlay == 0 then
        removeLuaSprite("1")

        makeLuaSprite("1", "1")
        makeGraphic("1", 1280, 720, '000000')
        addLuaSprite("1", true)
        setProperty("1.scale.x", 999)
        setProperty("1.scale.y", 999)
        screenCenter("1")
        setProperty("1.alpha", backOverlay)
    end
end

local keyNames = {"right", "up", "down", "left"}

function onUpdate(elapsed)
    setProperty("2.y", 53.5)
    setObjectOrder("1", 1000)
    setObjectOrder("2", 1001)
    setProperty("healthBarBG.visible", false)
    setProperty("healthBar.visible", false)
    setProperty("iconP1.visible", false)
    setProperty("iconP2.visible", false)
    setProperty("timeBarBG.visible", false)
    setProperty("timeBar.visible", false)
    setProperty("timeTxt.y", 20)
    setTextSize("timeTxt", 15)
    setProperty('timeTxt.alpha', 0.5)
    setTextSize('scoreTxt', 18)
    setProperty('scoreTxt.alpha', 0.5)
    setProperty('scoreTxt.y', 0)
    setPropertyFromClass('backend.ClientPrefs', 'data.ghostTapping', true)
    setPropertyFromClass('backend.ClientPrefs', 'data.ratingOffset', 0)
    setPropertyFromClass('ClientPrefs', 'middleScroll', true)
    setProperty('timeTxt.visible', true)
    setProperty('showRating', false)-- js engine moment
    setProperty('showComboNum', false)
    setProperty('showCombo', false)
    setProperty("camHUD.x", 0)
    setProperty("camHUD.y", 0)
    setProperty("camHUD.angle", 0)
    setProperty("camHUD.alpha", 1)
    screenCenter("1")
    setPropertyFromClass('openfl.Lib', 'application.window.x', 320)
    setPropertyFromClass('openfl.Lib', 'application.window.y', 180)

    if enableKeyHit then
        for i=1, 4, 1 do
            if keyPressed(keyNames[i]) then
                name = "button"..i
                randomizer = name.."lit"..math.random(-10000, 10000)
                doTweenColor(randomizer, name, "FFFFFF", 0.001, "linear")
            else
                name = "button"..i
                randomizer = name.."poof"..math.random(-10000, 10000)
                doTweenColor(randomizer, name, "707070", 0.1, "linear")
            end
        end
    end
end

function onGameOver()
    restartSong(true)
end
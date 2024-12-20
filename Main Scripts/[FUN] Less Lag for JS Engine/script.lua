-- place it in your mods/scripts folder

local handyTon = {
    -- Graphics
    {"lowQuality", false},
    {"globalAntialiasing", true},
    {"shaders", true},
    {"cacheOnGPU", false},
    {"dynamicSpawnTime", true},

    -- Gameplay
    {"middleScroll", false},
    {"autoPause", false},
    {"ezSpam", false}, --including it because it breaks the notes

    -- Optimization
    {"charsAndBG", true},
    {"enableGC", false},
    {"opponentLightStrum", false},
    {"botLightStrum", false},
    {"ratingPopups", false},
    {"comboPopups", false},
    {"showMS", false},
    {"songLoading", true},
    {"noSkipFuncs", true},
    {"lessBotLag", true},
    {"fastNoteSpawn", true},

    -- Visuals and UI
    {"noteSplashes", false},
    {"oppNoteSplashes", false},
    {"showNPS", false},
    {"showComboInfo", false},
    {"hideHud", true},
    {"showRendered", false},
    {"botWatermark", false},
    {"missRating", false},
    {"noteColorStyle", "Normal"},
    {"timeBarType", "Disabled"},
    {"watermarkStyle", "Hide"},
    {"ytWatermarkPosition", "Hidden"},
    {"colorRatingHit", false},
    {"smoothHealth", false},
    {"smoothHPBug", false},
    {"noBopLimit", false},
    {"ogHPColor", false},
    {"camZooms", true},
    {"ratingCounter", false},
    {"showNotes", true},
    {"scoreZoom", false},
    {"randomBotplayText", false},
    {"showFPS", false},
    {"comboStacking", false},
    {"showRamUsage", false},
    {"showMaxRamUsage", false},
    {"debugInfo", false},
}

function onCreatePost()
    setProperty("playbackRate", 0.0001)
    setProperty("camHUD.alpha", 0)
    setProperty("camGame.alpha", 0)

    makeLuaSprite("button1", "", 200, 500)
    makeGraphic("button1", 256, 64, 'FF0000')
    addLuaSprite("button1")
    scaleObject("button1", 1.25, 1.25)
    setObjectCamera("button1", "camOther")

    makeLuaSprite("button2", "", 750, 0)
    makeGraphic("button2", 256, 64, 'FF0000')
    addLuaSprite("button2")
    scaleObject("button2", 1.25, 1.25)
    setObjectCamera("button2", "camOther")

    makeLuaText("warn", "e", 1280, 0, 0)
    addLuaText("warn")
    screenCenter("warn")
    setProperty("warn.y", 200)
    setTextSize("warn", 35)
    setTextString("warn", [[Hello there user, and this is a warning for this script.
MOST of the setting will be overwritten for Rendering/Performance Purpose
(hiding text, hud, disabling/enabling options, etc.)

If you want to proceed, click "Yes, Proceed"]])
    setObjectCamera("warn", "camOther")

    makeLuaText("yes", "Yes, Proceed.", 1280, 0, 0)
    addLuaText("yes")
    screenCenter("yes")
    setProperty("yes.y", 512.5)
    setProperty("yes.x", -280)
    setTextSize("yes", 40)
    setObjectCamera("yes", "camOther")

    makeLuaText("no", "No, go back.", 1280, 0, 0)
    addLuaText("no")
    screenCenter("no")
    setProperty("no.y", 512.5)
    setProperty("no.x", 270)
    setTextSize("no", 40)
    setObjectCamera("no", "camOther")

    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true);
end

function onUpdate()
    if mouseOverlaps('button1') and mouseClicked("left") then
        removeLuaText("yes")
        removeLuaText("no")
        removeLuaSprite("button1")
        removeLuaSprite("button2")
        setTextString("warn", "Please wait...")
        for k, v in pairs(handyTon) do
            setPropertyFromClass("ClientPrefs", handyTon[k][1], handyTon[k][2])
        end
        setTextString("warn", [[Done, Pause and Go to Options, then escape to go back
then exit PlayState, then you can remove the script.

Script by nael2xd]])
        runTimer("exit", 5, 1)
    end
    if mouseOverlaps('button2') and mouseClicked("left") then
        removeLuaText("yes")
        removeLuaText("no")
        removeLuaSprite("button1")
        removeLuaSprite("button2")
        setTextString("warn", "You can remove the script.\nScript by Nael2xd")
        runTimer("exit", 5, 1)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    exitSong()
end

function mouseOverlaps(tag) -- https://github.com/ShadowMario/FNF-PsychEngine/issues/12755#issuecomment-1641455548
    addHaxeLibrary('Reflect')
    return runHaxeCode([[
        var obj = game.getLuaObject(']]..tag..[[');
        if (obj == null) obj = Reflect.getProperty(game, ']]..tag..[[');
        if (obj == null) return false;
        return obj.getScreenBounds(null, obj.cameras[0]).containsPoint(FlxG.mouse.getScreenPosition(obj.cameras[0]));
    ]])
end
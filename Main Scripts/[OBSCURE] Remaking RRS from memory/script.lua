local prefs = {
    gotoMenu = true,
    optionPrefs = {
        laneOpacity = 100
    }
}

local luaSetting = {
    optionsMenu = {
        {"Gameplay",    "Enhance gameplay and readability, provided in this script."},
        {"Save & Exit", "Does what the option does, just exits and goes to game!"}
    },
    gameplayMenu = {
        {"Lane Opacity", "laneOpacity", "Set the opacity for the Lane Underlay\n100 = Opaque, 0 = Transparent.", "int"},
        {"Lane Opacity", "laneOpacity", "Set the opacity for the Lane Underlay\n100 = Opaque, 0 = Transparent.", "int"},
        {"Lane Opacity", "laneOpacity", "Set the opacity for the Lane Underlay\n100 = Opaque, 0 = Transparent.", "int"},
        {"Lane Opacity", "laneOpacity", "Set the opacity for the Lane Underlay\n100 = Opaque, 0 = Transparent.", "int"},
    }
}

local optionLength = #luaSetting.optionsMenu
local gmLength = #luaSetting.gameplayMenu
local choice = 1
local optionName = "menu"

-- Noob!!!
--function onStartCountdown() if prefs.gotoMenu then return Function_Stop end end
--function onPause() if prefs.gotoMenu then return Function_Stop end end

function onCreatePost()
    if prefs.gotoMenu then
        --fastMake("image", "menuDesat", 0, 0, false, "other", true, "42B9E0")

        fastMake("text", "blabla", 0, 0, true, "other", true, "FFFFFF")
        setProperty("blabla.y", 64)
        setTextSize("blabla", 32)

        fastMake('text', 'watermark', 4, 698, false, "other", false, "FFFFFF")
        setTextSize("watermark", 18)
        setTextString("watermark", "Nael's MDT Script")
        setTextAlignment("watermark", "left")

        fastMake('text', 'menu', 6, 6, false, "other", false, "FFFFFF")
        setTextSize("menu", 24)
        setTextString("menu", "MDT Menu")
        setTextAlignment("menu", "left")
        setProperty("menu.alpha", 0.6)

        local ypos = 350.5-(38*optionLength)
        for i=1,optionLength do -- woah options! freaky
            local opti = "option"..i
            fastMake('text', opti, 0, 0, nil, 'other', true, nil)
            setProperty(opti..".y", ypos)
            setTextString(opti, luaSetting.optionsMenu[i][1])
            setTextSize(opti, 72)
            ypos = ypos + 76
        end
    end
end

function onUpdate(elapsed)
    if prefs.gotoMenu then
        -- Switches
        if keyboardJustPressed("R") then restartSong(true) end

        if optionName == "menu" then
            if keyboardJustPressed("S") then
                playSound("scrollMenu")
                choice = choice + 1
                if choice == optionLength+1 then choice = 1 end
            elseif keyboardJustPressed("Z") or keyboardJustPressed("W") then
                playSound("scrollMenu")
                choice = choice - 1
                if choice == 0 then choice = optionLength end
            end
            for i=1,optionLength do
                if choice == i then
                    setTextString("blabla", luaSetting.optionsMenu[i][2])
                    setTextBorder("option"..i, 6, "000000")
    
                    if keyboardJustPressed('ENTER') then
                        local name = luaSetting.optionsMenu[i][1]
                        setTextString("menu", name)
                        for ii=1,optionLength+1 do
                            if ii <= optionLength then doTweenY("lmao"..ii, "option"..ii, getProperty("option"..ii..".y")+1280, 1, "circIn")
                            else
                                doTweenSize("zoom", "blabla", {0.65, 0.65}, 1, "circOut")
                                doTweenY("zoomy", "blabla", -25, 1, "circOut")
                            end
                        end
                        if name == "Gameplay" then
                            optionName = "gameplay"
                            makeGameplayMenu()
                        elseif name == "Save & Exit" then
                            prefs.gotoMenu = false
                            restartSong()
                        end
                        playSound("confirmMenu")
                    end
                else setTextBorder("option"..i, 0) end
            end
        else
            if optionName == "gameplay" then
                if keyboardJustPressed("S") then
                    playSound("scrollMenu")
                    choice = choice + 1
                    if choice == gmLength+1 then choice = 1 end
                    doTweenY("wee", "tweener", 300 - (choice*100), 0.5, "circOut")
                elseif keyboardJustPressed("Z") or keyboardJustPressed("W") then
                    playSound("scrollMenu")
                    choice = choice - 1
                    if choice == 0 then choice = gmLength end
                    doTweenY("wee", "tweener", 300 - (choice*100), 0.5, "circOut")
                end

                for i=1,gmLength do
                    local opti1, opti2, opti3 = "setting"..i, "setting"..i.."desc", "setting"..i.."option"
                    setProperty(opti1..".y", getProperty("tweener.y") - 65 + (i*100))
                    setProperty(opti2..".y", getProperty("tweener.y") - 25 + (i*100))
                    setProperty(opti3..".y", getProperty("tweener.y") - 55 + (i*100))
                    setTextString(opti3, prefs.optionPrefs[luaSetting.gameplayMenu[i][2]])
                    if choice == i then
                        setProperty(opti1..".alpha", 1)
                        setProperty(opti2..".alpha", 1)
                        setProperty(opti3..".alpha", 1)
                    else
                        setProperty(opti1..".alpha", 0.33)
                        setProperty(opti2..".alpha", 0.33)
                        setProperty(opti3..".alpha", 0.33)
                    end
                end

                local type = luaSetting.optionsMenu[choice][4]
                local value = prefs.optionPrefs[luaSetting.gameplayMenu[choice][2]]
                debugPrint(type)
                if type == "int" then
                    value = value + (keyboardPressed("D") and 1 or 0)
                    value = value - ((keyboardPressed("Q") or keyboardPressed("A")) and 1 or 0)
                end
                prefs.optionPrefs[luaSetting.gameplayMenu[choice][2]] = value
            end
            if keyJustPressed("back") then
                optionName = "menu"
            end
        end
    end
end

function makeGameplayMenu()
    fastMake('graphic', "tweener", 0, 0, false, "other", false, "000000")
    setProperty("tweener.y", 1000)
    choice = 1

    for i=1,gmLength do
        local opti, opti2, opti3 = "setting"..i, "setting"..i.."desc", "setting"..i.."option"
        fastMake('text', opti, 275, 0, true, "other", false, "FFFFFF")
        setTextString(opti, luaSetting.gameplayMenu[i][1])
        setTextAlignment(opti, "left")
        setTextSize(opti, 40)

        fastMake('text', opti2, 275, 0, true, "other", false, "FFFFFF")
        setTextString(opti2, luaSetting.gameplayMenu[i][3])
        setTextAlignment(opti2, "left")
        setTextSize(opti2, 20)

        fastMake('text', opti3, -300, 0, true, "other", false, "FFFFFF")
        setTextAlignment(opti3, "right")
        setTextSize(opti3, 40)
    end

    doTweenY("wee", "tweener", 300, 1.5, "circOut")
end

-----------------
--- UTILITIES ---
-----------------

function fastMake(make, name, x, y, front, cam, middle, col)
    if name == nil then return nil end -- to not act weird as fuck i use this
    if make == "image" then
        makeLuaSprite(name, name, x, y)
        addLuaSprite(name, front)
        setObjectCamera(name, cam)
        if middle then screenCenter(name) end
        if col ~= nil then setProperty(name..".color", getColorFromHex(col)) end
    elseif make == "text" then
        makeLuaText(name, name, 1280, x, y)
        addLuaText(name)
        setObjectCamera(name, cam)
        if middle then screenCenter(name) end
        if col ~= nil then setTextColor(name, col) end
    elseif make == "graphic" then
        makeLuaSprite(name, "", 0, 0)
        makeGraphic(name, x, y, col)
        addLuaSprite(name, front)
        setObjectCamera(name, cam)
        if middle then screenCenter(name) end
    return nil end
end

function doTweenSize(tag, vars, value, duration, ease)
    doTweenX(tag.."1", vars..".scale", value[1], duration, ease)
    doTweenY(tag.."2", vars..".scale", value[2], duration, ease)
end
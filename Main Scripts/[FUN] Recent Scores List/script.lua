local player = {
    needsLaunch = true,

    -- empty because it needs so
    listHighScores = {}
}
local options = {
    {"Begin Song",       "This will RESTART the song. Press [F1] to go to this menu"},
    {"View High Scores", "View High Scores in this Song"}
}
local lTR = {"!", "?", " "}
local choice = 1
local songNameEdit = nil
local insideHS = false

function onCreate()
    loadPlayerPrefs()

    songNameEdit = songName
    for i=1,#lTR do
        songNameEdit = songNameEdit:gsub("%"..lTR[i], "_")
    end

    if player.listHighScores[songNameEdit] == nil then
        debugPrint("Song Found: "..songNameEdit)
        player.listHighScores[songNameEdit] = {}
    end

    if player.needsLaunch then
        makeSprite('menuBG', 0, 0)
        screenCenter('menuBG')

        makeSprite('menuBGMagenta', 0, 0)
        screenCenter('menuBGMagenta')
        setProperty("menuBGMagenta.alpha", 0)

        setProperty("camHUD.alpha", 0)
        setProperty("camGame.alpha", 0)
    
        local y = 25-(50*#options)
        for i=1,#options do
            local tag = 'option'..i
            makeText(tag, 0, 0, 76)
            screenCenter(tag)
            setProperty(tag..'.y', 334.5+y)
            setTextString(tag, options[i][1])
            setTextBorder(tag, 1, "000000")
            y = y + 100
        end
        graphicMake('desc', 0, 50, 960, 90, '000000', true)
        setProperty("desc.alpha", 0.65)

        makeText('wooPoo', 0, 75, 28)
    end
end

function onEndSong()
    if not botPlay or not practice or 0 <= getProperty('songScore') then
        table.insert(player.listHighScores[songNameEdit], {getProperty('songScore'), misses, string.format("%.2f%%", (rating*100))})
    end
    savePlayerPrefs()
    restartSong()
end

function onUpdate(elapsed)
    if player.needsLaunch and not insideHS then
        if keyboardJustPressed("W") or keyboardJustPressed("Z") or keyboardJustPressed("UP") then
            choice = choice + 1
            if choice == #options + 1 then
                choice = 1
            end
        elseif keyboardJustPressed("S") or keyboardJustPressed("DOWN") then
            choice = choice - 1
            if choice == 0 then
                choice = #options
            end
        end
        for i=1,#options do
            local tag = 'option'..i
            setTextBorder(tag, 2, "000000")
            if i == choice then
                setTextBorder(tag, 6, "000000")
                setTextString("wooPoo", options[i][2])
                if keyboardJustPressed("ENTER") then
                    playSound("confirmMenu")
                    if choice == 1 then
                        player.needsLaunch = false
                        savePlayerPrefs()
                        restartSong()
                    end
                    if choice == 2 then
                        if #player.listHighScores[songNameEdit] == 0 then
                            debugPrint("Can't open because there are 0 songs found.")
                        else
                            insideHS = true
                            removeLuaSprite("desc")
                            removeLuaText("wooPoo")
                            for ii=1,#options do
                                removeLuaText("option"..ii)
                            end
                            createHSMenu()
                        end
                    end
                end
            end
        end
    end
    if keyboardJustPressed("BACKSPACE") and player.needsLaunch then
        restartSong()
    end
    if keyboardJustPressed("F1") and not player.needsLaunch then
        player.needsLaunch = true
        savePlayerPrefs()
        restartSong()
    end
end

function createHSMenu()
    local repeatHowMuch = #player.listHighScores[songNameEdit]

    graphicMake('lookedNeatForEyes', 0, 0, 600, 1500, "222222", true)

    makeText(songName, 0, 12.5, 35)
    setTextString(songName, songName.." - Recent Scores.")

    doTweenAlpha("a", "menuBGMagenta", 1, 1, "linear")
    doTweenAlpha("b", "menuBG", 0, 1, "linear")

    graphicMake('hey2', 0, 0, 1500, 80, getColorFromHex(RGBToHex(getProperty('dad.healthColorArray'))), true)

    graphicMake('hey1', 0, 0, 1500, 75, "000000", true)
    setProperty("hey1.alpha", 0.8)

    local n = {"Score", "Misses", "Accuracy"}

    for i=1,#n do
        makeText('info'..i, 145+(200*i), 77.5, 30)
        setTextAlignment("info"..i, "left")
        setTextString("info"..i, n[i])
        setTextBorder("info"..i, 2, "676767")
    end

    for i=3, 6 do
        graphicMake('hey'..i, 130+(200*(i-2)), 75, 10, 1000, "FFFFFF")
    end

    graphicMake('lbi', 0, 120, 600, 10, "FFFFFF", true)
    local done = 1
    for i=repeatHowMuch+1, 2, -1 do
        done = done + 1
        graphicMake('lb'..done, 0, 70+(50*done), 600, 10, "FFFFFF", true)

        makeText('kool1'..done, 345, 27.5+(50*done), 30)
        setTextAlignment('kool1'..done, "left")
        setTextString('kool1'..done, player.listHighScores[songNameEdit][i-1][1])

        makeText('kool2'..done, 545, 27.5+(50*done), 30)
        setTextAlignment('kool2'..done, "left")
        setTextString('kool2'..done, player.listHighScores[songNameEdit][i-1][2])

        makeText('kool3'..done, 745, 27.5+(50*done), 30)
        setTextAlignment('kool3'..done, "left")
        setTextString('kool3'..done, player.listHighScores[songNameEdit][i-1][3])
    end

    makeText('back', 0, 697, 16)
    setTextAlignment("back", "left")
    setTextString("back", "Press BACKSPACE to go back.")
end

function onStartCountdown()
    if player.needsLaunch then
        return Function_Stop
    else
        allowCountdown = true
    end
end

function makeSprite(name, x, y)
    makeLuaSprite(name, name, 0, 0)
    addLuaSprite(name)
    setObjectCamera(name, "other")
    screenCenter(name)
    setProperty(name..".x", x)
    setProperty(name..".y", y)
end

function makeText(name, x, y, size)
    makeLuaText(name, name, 1280, x, y)
    setTextSize(name, size)
    setTextAlignment(name, 'CENTER')
    addLuaText(name)
    setObjectCamera(name, 'camOther')
    setTextBorder(name, 0)
end

function graphicMake(name, x, y, width, height, color, center)
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

function loadPlayerPrefs()
    initSaveData('HighScoreLists')
    for k, v in pairs(player) do
        player[k] = getDataFromSave('HighScoreLists', k, v)
    end
end

function savePlayerPrefs()
    for k, v in pairs(player) do
        setDataFromSave('HighScoreLists', k, v)
    end
    flushSaveData('HighScoreLists')
end

function RGBToHex(colorArray)
    local hexcode = ''
    for i = 1, #colorArray do
        value1 = math.floor(colorArray[i] / 16)
        value2 = ((colorArray[i] / 16) % 1) * 16
        hexcode = hexcode .. (value1 < 10 and tostring(value1) or tostring(string.char((65 + value1) - 10)))
        hexcode = hexcode .. (value2 < 10 and tostring(value2) or tostring(string.char((65 + value2) - 10)))
    end
    return hexcode
end
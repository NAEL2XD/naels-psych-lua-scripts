-- Made by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)
-- Don't steal this! It's stupid if you did.

local gamePlay = {
    songroom = 0,
    wins = 0,
    losses = 0,
    winstreak = 0,
    maxwinstreak = 0,
    wlratio = 0,
    wlpercent = "",
    hitRoom = 0,
    hitFreeplay = 0,
    hitTotal = 0,
    timePlayed = 0,
    ttp = "",
    songFreeplay = 0,
    songPlays = 0,
    fc = 0,
    pfc = 0,
    fcpfc = "",
    records = {},
    roomData = {},
}
local moveables = {}
local make = {
    {"songroom",     "Total Song Plays (On Room)"},
    {"wins",         "Total Wins"                },
    {"losses",       "Total Losses"              },
    {"winstreak",    "Current Winstreak"         },
    {"maxwinstreak", "Max Winstreak"             },
    {"wlratio",      "Win/Lose Ratio"            },
    {"wlpercent",    "Win/Lose Percentage"       },
    {"hitRoom",      "Total Hits (On Room)"      },
    {"hitFreeplay",  "Total Hits (On Solo)",     true},
    {"hitTotal",     "Total Hits All-Time"       },
    {"ttp",          "Time Played"               },
    {"songFreeplay", "Total Song Plays (On Solo)"},
    {"songPlays",    "Total Song Plays All-Time" },
    {"fcpfc",        "Total FC/PFC"              },
}

local yScroll = 0
local yScrollLimit = 0
local spawny = 0

function onCreatePost()
    initSaveData('POStats')
    for k, v in pairs(gamePlay) do
        gamePlay[k] = getDataFromSave('POStats', k, v)
    end

    if songName == "online-stats" then
        setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
        playMusic("freeplayRandom", 1, true)
        setProperty("camHUD.visible", false)
        setProperty("camGame.visible", false)

        makeLuaSprite("menuBG", "menuDesat")
        addLuaSprite("menuBG")
        setObjectCamera('menuBG', "other")
        setProperty("menuBG.color", getColorFromHex("202020"))
        screenCenter("menuBG")
    
        fastMake('text', 'newhere', nil, nil, 40)
        screenCenter("newhere")
        setTextSize("newhere", 40)
        setTextString("newhere", "Press W/Z/UP or S/DOWN to move and Press E to exit")

        fastMake('text', 'scriptcredit', nil, nil, 80)
        screenCenter("scriptcredit")
        setTextString("scriptcredit", "v2.0.0 - Script by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)\nPress ENTER to open Source Code")
        setTextBorder("scriptcredit", 2, "003300")
        setTextColor("scriptcredit", "00FF00")

        fastMake('text', 'general', nil, nil, 200)
        setTextString("general", "Online Stats")
        setTextSize("general", 48)

        local timePlayed = gamePlay.timePlayed

        local things = {
            {0, 3600, "h "},
            {0, 60, "m "},
            {0, 1, "s"}
        }

        gamePlay.ttp = ""
        for i=1,#things do
            if timePlayed >= things[i][2] then
                repeat
                    things[i][1] = things[i][1] + 1
                    timePlayed = timePlayed - things[i][2]
                until timePlayed <= things[i][2]
            end
            gamePlay.ttp = gamePlay.ttp..things[i][1]..things[i][3]
        end

        local qsdfohi = {"records", "roomData"}
        for i=1, #qsdfohi do
            if #gamePlay[qsdfohi[i]] >= 16 then
                repeat
                    table.remove(gamePlay[qsdfohi[i]], 1)
                until #gamePlay[qsdfohi[i]] <= 16
            end
        end

        gamePlay.fcpfc = gamePlay.fc.."/"..gamePlay.pfc
        gamePlay.wlratio = string.format('%.2f', gamePlay.wins / (gamePlay.losses == 0 and 1 or gamePlay.losses))
        gamePlay.hitTotal = gamePlay.hitRoom + gamePlay.hitFreeplay
        gamePlay.songroom = gamePlay.wins + gamePlay.losses
        gamePlay.songFreeplay = gamePlay.songPlays - gamePlay.songroom
        gamePlay.wlpercent = string.format('%.2f%%', (gamePlay.wins / gamePlay.songroom)*100)

        local o
        local wasPlayer = false
        for i=1,#make do
            local isPlayerRelated = make[i][3]
            if not wasPlayer and isPlayerRelated then
                fastMake('text', 'NotRelated', nil, 0, 240+(75*i))
                setTextSize('NotRelated', 48)
                setTextString('NotRelated', "Offline Stats")
                setProperty(o..".x", 140)

                wasPlayer = true
            end

            o = make[i][1]
            fastMake('text', o, nil, 0, (wasPlayer and 320 or 200)+(75*i))
            setTextSize(o, 32)
            setTextString(o, make[i][2]..": ")
            setTextAlignment(o, "left")
            setProperty(o..".x", 140)

            o = make[i][1].."Current"
            fastMake('text', o, nil, 0, (wasPlayer and 292.5 or 172.5)+(75*i))
            setTextSize(o, 64)
            setTextString(o, gamePlay[make[i][1]])
            setTextAlignment(o, "right")
            setProperty(o..".x", -140)

            for ii=1,33 do
                o = "lengthThingy"..i..ii
                fastMake('graphic', o, nil, 0, (wasPlayer and 355 or 235)+(75*i), 1040+(2.5*ii), 6, "FFFFFF")
                setProperty(o..".alpha", 0.033)
                screenCenter(o)
                if ii == 33 then
                    removeLuaSprite(o)
                end
            end
        end

        spawny = 435+(75*#make)
        yScrollLimit = spawny-550

        fastMake('text', 'nostuff', nil, nil, spawny-25)
        screenCenter("nostuff")
        setTextSize("nostuff", 40)
        if #gamePlay.records == 0 then
            setTextString("nostuff", "Records was not found :(\nPlay with users to track records here.")
        else
            spawny = 515+(78*#make)
            setTextString("nostuff", "Room Player Activity")

            fastMake('text', 'notice', nil, nil, spawny-112.5)
            screenCenter("notice")
            setTextString("notice", "It will get 15 activities max! The oldest one will be removed to prevent lag.\nClick on an activity to see Room Data!")
            setTextSize('notice', 22)

            fastMake('graphic', 'makeRecords', nil, nil, spawny-50, 620, 72, "FF0000")
            screenCenter("makeRecords")

            fastMake('text', 'textMake', nil, 0, spawny-42.5)
            setTextSize("textMake", 32)
            setTextString("textMake", "Get Player Activity (Will Lag)")

            fastMake('text', 'textMaClick', nil, 0, spawny-15)
            setTextSize("textMaClick", 24)
            setTextString("textMaClick", "Click Me!")

            updatePosition()
        end
    end
end

local thing = 0.0
local enteredRoomData = false
local madeFirst = false
local aboutToLeave = false
local whichChosen = 0
function onUpdate(elapsed)
    thing = thing + elapsed
    if songName == "online-stats" then
        if keyboardJustPressed("R") then restartSong(true) end
        if not enteredRoomData then
            if keyboardJustPressed("ENTER") then
                os.execute("start https://github.com/NAEL2XD/naels-psych-lua-scripts/tree/main/Main%20Scripts/Online%20Related/Online%20Statistics")
            end
            if yScroll >= 0 then
                yScroll = 0
            elseif yScroll <= -yScrollLimit then
                yScroll = -yScrollLimit
            end
            if keyboardJustPressed("E") then exitSong(true) end
            if keyboardPressed("W") or keyboardPressed("Z") or keyboardPressed("UP") then
                yScroll = yScroll + (13+(#gamePlay.records/8))/(framerate/60)
            elseif keyboardPressed("S") or keyboardPressed("DOWN") then
                yScroll = yScroll - (13+(#gamePlay.records/8))/(framerate/60)
            end
            if mouseOverlaps("makeRecords") and mouseClicked() then
                createRecords()
                removeLuaSprite("makeRecords")
                removeLuaText("textMake")
                removeLuaText("textMaClick")
            end
            for i=1, 15 do
                if mouseOverlaps("border"..i) and mouseClicked() then
                    enteredRoomData = true
                    madeFirst = false
                    whichChosen = i
                    break
                end
            end
            updatePosition()
        else
            if not madeFirst then
                makeLuaSprite('blackingThem', "", 0, 0)
                makeGraphic('blackingThem', 1920, 1080, "000000")
                addLuaSprite('blackingThem', true)
                setObjectCamera("blackingThem", "other")
                setProperty("blackingThem.alpha", 0)
                doTweenAlpha("shit", "blackingThem", 0.8, 0.5, "linear")

                fastMake('text', 'oppoInfo', nil, 20, 40)
                setTextSize("oppoInfo", 32)
                setTextAlignment("oppoInfo", "left")
                setProperty("oppoInfo.alpha", 0)
                doTweenAlpha("shit2", "oppoInfo", 0.8, 0.5, "linear")

                fastMake('text', 'playerInfo', nil, -20, 40)
                setTextSize("playerInfo", 32)
                setTextAlignment("playerInfo", "right")
                setProperty("playerInfo.alpha", 0)
                doTweenAlpha("shit3", "playerInfo", 0.8, 0.5, "linear")

                fastMake('text', 'roomInfo', nil, 0, 350)
                setTextSize("roomInfo", 32)
                setProperty("roomInfo.alpha", 0)
                doTweenAlpha("shit4", "roomInfo", 0.8, 0.5, "linear")

                makeLuaSprite('leavelol', "", 0, 0)
                makeGraphic('leavelol', 360, 90, "FF0000")
                addLuaSprite('leavelol', true)
                setObjectCamera("leavelol", "other")
                screenCenter("leavelol")
                setProperty("leavelol.y", 625)
                setProperty("leavelol.alpha", 0)
                doTweenAlpha("shit5", "leavelol", 0.8, 0.5, "linear")

                fastMake('text', 'closeButton', nil, 0, 650)
                setTextSize("closeButton", 40)
                setTextString("closeButton", "Close Data")
                setProperty("closeButton.alpha", 0)
                doTweenAlpha("shit6", "closeButton", 0.8, 0.5, "linear")

                local stuffNames = {
                    {
                        "Name",
                        "Score",
                        "Misses",
                        "Accuracy",
                        "Sicks",
                        "Goods",
                        "Bads",
                        "Shits",
                        "Skin Name"
                    },
                    {
                        "Room ID",
                        "Is Room Owner",
                        "Has Perms",
                        "Song Name",
                        "Mod Name",
                        "Mod Link"
                    }
                }
                if gamePlay.roomData[whichChosen] == nil then
                    setTextString("roomInfo", "Sorry, room data was not found!")
                    setTextSize("roomInfo", 52)
                    screenCenter("roomInfo")
                else
                    local isCorrupt = false
                    saveFile("debug.txt", gamePlay.roomData)
                    for i=1, 3 do
                        if gamePlay.roomData[whichChosen][i] == nil then
                            isCorrupt = true
                        end
                    end
                    if not isCorrupt then
                        local wower = {"oppoInfo", 'playerInfo', 'roomInfo'}
                        local things = {"Opponent ", "Player ", ""}
                        for i=1, 3 do
                            local txt = ""
                            for ii=1, #stuffNames[i <= 2 and 1 or 2] do
                                txt = txt..tostring(things[i]..stuffNames[i <= 2 and 1 or 2][ii]..": "..tostring(gamePlay.roomData[whichChosen][i][ii]).."\n")
                            end
                            setTextString(wower[i], txt)
                        end
                    else
                        setTextString('roomInfo', "Room Data is Not Found or is Corrupted.")
                        setTextSize("roomInfo", 52)
                        screenCenter("roomInfo")
                    end
                end

                madeFirst = true
                aboutToLeave = false
            end
            if mouseOverlaps("leavelol") and mouseClicked() and not aboutToLeave then
                local stuffToDel = {"blackingThem", "oppoInfo", "playerInfo", "roomInfo", "leavelol", "closeButton"}
                aboutToLeave = true
                for i=1, #stuffToDel do
                    doTweenAlpha("byeInfo"..i, stuffToDel[i], 0, 0.33, "linear")
                end
            end
        end
    end
end

function onTweenCompleted(tag)
    if tag == "byeInfo1" then
        madeFirst = false
        enteredRoomData = false
        local stuffToDel = {"blackingThem", "oppoInfo", "playerInfo", "roomInfo", "leavelol", "closeButton"}
        for i=1, 6 do
            cancelTween(stuffToDel[i])
            removeLuaSprite(stuffToDel[i])
            removeLuaText(stuffToDel[i])
        end
    end
end

function onEndSong()
    if not botPlay then
        local room = isRoomConnected()
        if room then
            local user, win, accu, own = "", false, 0, hasRoomPerms()
            accu = math.abs(getPlayerAccuracy((own and 1 or 2)) - getPlayerAccuracy((own and 2 or 1)))
            win = getPlayerAccuracy((own and 1 or 2)) - getPlayerAccuracy((own and 2 or 1)) >= 0
            user = getPlayerName((own and 2 or 1)); user = (user == "" and "User Not Found" or user)
            table.insert(gamePlay.records, {user, win, string.format("%.2f%%", accu)})
            local shit = {}
            for i=1, 2 do
                table.insert(shit, {
                    getPlayerName(i),
                    getPlayerScore(i),
                    getPlayerMisses(i),
                    string.format('%.2f%%', getPlayerAccuracy(i)),
                    getPlayerSicks(i),
                    getPlayerGoods(i),
                    getPlayerBads(i),
                    getPlayerShits(i),
                    getPlayerSkinName(i),
                })
            end
            table.insert(shit, {
                gamePlay.wins + gamePlay.losses,
                isRoomOwner(),
                hasRoomPerms(),
                songName.." ("..getStateSong()..")",
                (getStateModDir() == nil and "Vanilla" or getStateModDir()),
                (getStateModURL() == nil and "Vanilla" or getStateModURL()),
            })
            table.insert(gamePlay.roomData, shit)
            if #gamePlay.records == 17 then
                table.remove(gamePlay.records, 1)
            end
            if #gamePlay.roomData == 17 then
                table.remove(gamePlay.roomData, 1)
            end
            if win then
                gamePlay.wins = gamePlay.wins + 1; gamePlay.winstreak = gamePlay.winstreak + 1
            else
                gamePlay.winstreak = 0; gamePlay.losses = gamePlay.losses + 1
            end
            if gamePlay.winstreak >= gamePlay.maxwinstreak then
                gamePlay.maxwinstreak = gamePlay.winstreak
            end
            gamePlay.hitRoom = gamePlay.hitRoom + hits
        else
            gamePlay.hitFreeplay = gamePlay.hitFreeplay + hits
        end
        if rating == 1 then
            gamePlay.pfc = gamePlay.pfc + 1
        elseif misses == 0 then
            gamePlay.fc = gamePlay.fc + 1
        end
        gamePlay.timePlayed = math.floor(gamePlay.timePlayed + thing)
        gamePlay.songPlays = gamePlay.songPlays + 1
        for k, v in pairs(gamePlay) do
            setDataFromSave('POStats', k, v)
        end
        flushSaveData('POStats')
    end
end

function onStartCountdown() if songName == "online-stats" then return Function_Stop end end

function createRecords()
    spawny = 436+(75*(#make+1))

    fastMake('graphic', 'nothingBlack0', nil, nil, spawny, 968, 40, "000000")
    screenCenter("nothingBlack0")

    fastMake('graphic', 'header', nil, nil, spawny+4, 960, 32, "313131")
    screenCenter("header")

    fastMake('text', 'whoWIN', nil, -325, spawny+4)
    setTextString("whoWIN", "PLAYER")
    setTextSize("whoWIN", 28)

    fastMake('text', 'whoJudge', nil, 0, spawny+4)
    setTextString("whoJudge", "WON?")
    setTextSize("whoJudge", 28)

    fastMake('text', 'whoMuch', nil, 325, spawny+4)
    setTextString("whoMuch", "BY %?")
    setTextSize("whoMuch", 28)

    local o
    for i=1,#gamePlay.records do
        o = 'nothingBlack6'..i
        fastMake('graphic', o, nil, nil, spawny+(34*i), 968, 40, "000000")
        screenCenter(o)

        o = 'border'..i
        fastMake('graphic', o, nil, nil, (spawny+4)+(34*i), 960, 32, (i % 2 == 0 and "8e8c8e" or "bdbcbd"))
        screenCenter(o)

        o = 'guy'..i
        fastMake('text', o, nil, 160, (spawny+4)+(34*i))
        setTextAlignment(o, "left")
        setTextString(o, gamePlay.records[i][1])
        setTextSize(o, 32)
        setTextColor(o, "202020")

        o = 'win'..i
        fastMake('text', o, nil, 480, (spawny+4)+(34*i))
        setTextAlignment(o, "left")
        setTextString(o, (gamePlay.records[i][2] and "Yes" or "No"))
        setTextSize(o, 32)
        setTextColor(o, "202020")

        o = 'acc'..i
        fastMake('text', o, nil, 805, (spawny+4)+(34*i))
        setTextAlignment(o, "left")
        setTextString(o, gamePlay.records[i][3])
        setTextSize(o, 32)
        setTextColor(o, "202020")
    end

    spawny = 472+(75*(#make+1))

    fastMake('graphic', 'lengthingTile1', nil, 475, spawny, 4, 34*#gamePlay.records, "202020")
    fastMake('graphic', 'lengthingTile2', nil, 800, spawny, 4, 34*#gamePlay.records, "202020")

    yScrollLimit = 75*(#make-1.75)+(34*#gamePlay.records)

    updatePosition()
end

function updatePosition()
    for i=1,#moveables do
        setProperty(moveables[i][1]..".y", moveables[i][2]+yScroll)
    end
end

function fastMake(which, tag, name, x, y, width, height, color)
    table.insert(moveables, {tag, y})
    if color == nil then color = "FFFFFF" end
    if which == "graphic" then
        makeLuaSprite(tag, "", x, y)
        makeGraphic(tag, width, height, color)
        addLuaSprite(tag)
    elseif which == "image" then
        makeLuaSprite(tag, name, x, y)
        addLuaSprite(tag)
    elseif which == "text" then
        makeLuaText(tag, name, 1280, x, y)
        addLuaText(tag)
        setTextColor(tag, color)
        setTextBorder(tag)
    end
    setObjectCamera(tag, "other")
end

-- https://github.com/ShadowMario/FNF-PsychEngine/issues/12755#issuecomment-1641455548
function mouseOverlaps(tag)
    addHaxeLibrary('Reflect')
    return runHaxeCode([[
        var obj = game.getLuaObject(']]..tag..[[');
        if (obj == null) obj = Reflect.getProperty(game, ']]..tag..[[');
        if (obj == null) return false;
        return obj.getScreenBounds(null, obj.cameras[0]).containsPoint(FlxG.mouse.getScreenPosition(obj.cameras[0]));
    ]])
end
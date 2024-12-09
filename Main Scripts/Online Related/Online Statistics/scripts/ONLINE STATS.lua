local gamePlay = {
    wins = 0,
    losses = 0,
    winstreak = 0,
    maxwinstreak = 0,
    wlratio = 0,
    hitRoom = 0,
    hitFreeplay = 0,
    hitTotal = 0,
    timePlayed = 0,
    ttp = "",
    songPlays = 0,
    fc = 0,
    pfc = 0,
    fcpfc = "",
    records = {}
}
local moveables = {}
local make = {
    {"wins",         "Total Wins"            },
    {"losses",       "Total Losses"          },
    {"winstreak",    "Current Winstreak"     },
    {"maxwinstreak", "Max Winstreak"         },
    {"wlratio",      "Win/Lose Ratio"        },
    {"hitRoom",      "Total Hits (On Room)"  },
    {"hitFreeplay",  "Total Hits (On Solo)",   true},
    {"hitTotal",     "Total Hits All-Time"   },
    {"ttp",          "Time Played"           },
    {"songPlays",    "Total Song Plays"      },
    {"fcpfc",        "Total FC/PFC"          },
}

local yScroll = 0
local yScrollLimit = 0
local spawny = 0

function onCreatePost()
    initSaveData('POnlineStats')
    for k, v in pairs(gamePlay) do
        gamePlay[k] = getDataFromSave('POnlineStats', k, v)
    end

    if songName == "online-stats" then
        setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
        fastMake('graphic', 'pointer', nil, 0, 0, 0, 0)
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
        setTextString("scriptcredit", "Script by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)")
        setTextBorder("scriptcredit", 2, "003300")
        setTextColor("scriptcredit", "00FF00")

        fastMake('text', 'general', nil, nil, 200)
        setTextString("general", "Online Stats")
        setTextSize("general", 48)

        local seconds, minutes, hours = 0,0,0
        local timePlayed = gamePlay.timePlayed
        gamePlay.wlratio = gamePlay.wins / (gamePlay.losses+1)

        if timePlayed >= 3600 then
            repeat
                hours = hours + 1
                timePlayed = timePlayed - 3600
            until timePlayed <= 3600
        end

        if timePlayed >= 60 then
            repeat
                minutes = minutes + 1
                timePlayed = timePlayed - 60
            until timePlayed <= 60
        end
        
        if timePlayed >= 1 then
            repeat
                seconds = seconds + 1
                timePlayed = timePlayed - 1
            until timePlayed <= 0
        end

        gamePlay.ttp = hours.."h "..minutes.."m "..seconds.."s"
        gamePlay.fcpfc = gamePlay.fc.."/"..gamePlay.pfc
        gamePlay.hitTotal = gamePlay.hitRoom + gamePlay.hitFreeplay

        local o
        local wasPlayer = false
        for i=1,#make do
            local isPlayerRelated = make[i][3]
            if not wasPlayer and isPlayerRelated then
                fastMake('text', 'NotRelated', nil, 0, 240+(75*i))
                setTextSize('NotRelated', 48)
                setTextString('NotRelated', "Player Stats")
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
                o = "lengthThing"..i..ii
                fastMake('graphic', o, nil, 0, (wasPlayer and 355 or 235)+(75*i), 1040+(2.5*ii), 6, "FFFFFF")
                setProperty(o..".alpha", 0.033)
                screenCenter(o)
                if ii == 33 then
                    removeLuaSprite(o)
                end
            end
        end

        spawny = 435+(75*#make)
        yScrollLimit = spawny-600

        fastMake('text', 'nostuff', nil, nil, spawny)
        screenCenter("nostuff")
        setTextSize("nostuff", 40)
        if #gamePlay.records == 0 then
            setTextString("nostuff", "Records was not found :(")
        else
            spawny = 515+(78*#make)
            setTextString("nostuff", "Room Player Activity")

            fastMake('graphic', 'makeRecords', nil, nil, spawny-70, 620, 72, "FF0000")
            screenCenter("makeRecords")

            fastMake('text', 'textMake', nil, 0, spawny-75+12.5)
            setTextSize("textMake", 32)
            setTextString("textMake", "Get Player Activity (Will Lag)")

            fastMake('text', 'textMaClick', nil, 0, spawny-75+40)
            setTextSize("textMaClick", 24)
            setTextString("textMaClick", "Click Me!")

            updatePosition()
        end
    end
end

local thing = 0.0
function onUpdate(elapsed)
    thing = thing + elapsed
    if songName == "online-stats" then
        setProperty("pointer.x", getMouseX("other")); setProperty("pointer.y", getMouseY("other"))
        if keyboardJustPressed("E") then exitSong(true) end
        if keyboardJustPressed("R") then restartSong(true) end
        if keyboardPressed("W") or keyboardPressed("Z") or keyboardPressed("UP") then
            yScroll = yScroll + (10+(#gamePlay.records/8))/(framerate/60)
        elseif keyboardPressed("S") or keyboardPressed("DOWN") then
            yScroll = yScroll - (10+(#gamePlay.records/8))/(framerate/60)
        end
        if yScroll >= 0 then
            yScroll = 0
        elseif yScroll <= -yScrollLimit then
            yScroll = -yScrollLimit
        end
        if objectsOverlap("pointer", "makeRecords") and mouseClicked() then
            createRecords()
            removeLuaSprite("makeRecords")
            removeLuaText("textMake")
            removeLuaText("textMaClick")
        end
        updatePosition()
    end
end

function onEndSong()
    if not botPlay then
        local room = isRoomConnected()
        if room then
            local user, win, accu, own = "", false, 0, hasRoomPerms()
            if own then
                accu = math.abs(getPlayerAccuracy(1) - getPlayerAccuracy(2))
                win = getPlayerAccuracy(1) - getPlayerAccuracy(2) >= 0
                user = getPlayerName(2)
            else
                accu = math.abs(getPlayerAccuracy(2) - getPlayerAccuracy(1))
                win = getPlayerAccuracy(2) - getPlayerAccuracy(1) >= 0
                user = getPlayerName(1)
            end
            table.insert(gamePlay.records, {user, win, string.format("%.2f%%", (accu))})
            if #gamePlay.records == 16 then
                gamePlay.records[1] = nil
            end
            if win == 1 then
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
            setDataFromSave('POnlineStats', k, v)
        end
        flushSaveData('POnlineStats')
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
    setTextString("whoJudge", "WAS WON?")
    setTextSize("whoJudge", 28)

    fastMake('text', 'whoMuch', nil, 325, spawny+4)
    setTextString("whoMuch", "BY %?")
    setTextSize("whoMuch", 28)

    local o
    for i=#gamePlay.records,1,-1 do
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
        setTextString(o, gamePlay.records[i][3].."%")
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
local gamePlay = {
    isNew = true,
    wins = 0,
    losses = 0,
    winstreak = 0,
    maxwinstreak = 0,
    wlratio = 0,
    hitRoom = 0,
    hitFreeplay = 0,
    records = {}
}
local moveables = {}

local yScroll = 0
local yScrollLimit = 0

function onCreatePost()
    initSaveData('POnlineStats')
    for k, v in pairs(gamePlay) do
        gamePlay[k] = getDataFromSave('POnlineStats', k, v)
    end

    if songName == "online-stats" then
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
        setTextString("newhere", "Press W/Z/UP or S/DOWN to move.\nPress E to exit")

        fastMake('text', 'general', nil, nil, 200)
        setTextString("general", "Online Player Stats")
        setTextSize("general", 48)

        local make = {
            {"wins", "Total Wins", false},
            {"losses", "Total Losses", false},
            {"winstreak", "Current Winstreak", false},
            {"maxwinstreak", "Max Winstreak", false},
            {"wlratio", "Win/Lose Ratio", false},
            {"hitRoom", "Total Hits (On Room)", false},
            {"hitFreeplay","Total Hits (On Solo)", true}
        }

        local o
        local wasPlayer = false
        for i=1,#make do
            local isPlayerRelated = make[i][3]
            if not wasPlayer and isPlayerRelated then
                fastMake('text', 'NotRelated', nil, 0, 240+(75*i))
                setTextSize('NotRelated', 48)
                setTextString('NotRelated', "Solo Player Stats")
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

            for ii=1,16 do
                o = "lengthThing"..i..ii
                fastMake('graphic', o, nil, 0, (wasPlayer and 355 or 235)+(75*i), 1040+(5*ii), 6, "FFFFFF")
                setProperty(o..".alpha", 0.05)
                screenCenter(o)
            end
        end

        fastMake('text', 'nostuff', nil, nil, 985)
        screenCenter("nostuff")
        setTextSize("nostuff", 40)
        if #gamePlay.records == 0 then
            setTextString("nostuff", "Records was not found :(")
        else
            setTextString("nostuff", "Room Player Activity")
            
            fastMake('graphic', 'nothingBlack0', nil, nil, 1041, 968, 40, "000000")
            screenCenter("nothingBlack0")

            fastMake('graphic', 'header', nil, nil, 1045, 960, 32, "313131")
            screenCenter("header")

            fastMake('text', 'whoWIN', nil, -325, 1045)
            setTextString("whoWIN", "PLAYER")
            setTextSize("whoWIN", 28)

            fastMake('text', 'whoJudge', nil, 0, 1045)
            setTextString("whoJudge", "WAS WON?")
            setTextSize("whoJudge", 28)

            fastMake('text', 'whoMuch', nil, 325, 1045)
            setTextString("whoMuch", "BY %?")
            setTextSize("whoMuch", 28)

            for i=#gamePlay.records,1,-1 do
                o = 'nothingBlack6'..i
                fastMake('graphic', o, nil, nil, 1041+(34*i), 968, 40, "000000")
                screenCenter(o)
        
                o = 'border'..i
                fastMake('graphic', o, nil, nil, 1045+(34*i), 960, 32, (i % 2 == 0 and "8e8c8e" or "bdbcbd"))
                screenCenter(o)
        
                o = 'guy'..i
                fastMake('text', o, nil, 160, 1045+(34*i))
                setTextAlignment(o, "left")
                setTextString(o, gamePlay.records[i][1])
                setTextSize(o, 32)
                setTextColor(o, "202020")
        
                o = 'win'..i
                fastMake('text', o, nil, 480, 1045+(34*i))
                setTextAlignment(o, "left")
                setTextString(o, (gamePlay.records[i][2] and "Yes" or "No"))
                setTextSize(o, 32)
                setTextColor(o, "202020")
        
                o = 'acc'..i
                fastMake('text', o, nil, 805, 1045+(34*i))
                setTextAlignment(o, "left")
                setTextString(o, gamePlay.records[i][3].."%")
                setTextSize(o, 32)
                setTextColor(o, "202020")
            end
        
            yScrollLimit = 409+(34*#gamePlay.records)
        
            fastMake('graphic', 'lengthingTile1', nil, 475, 1077, 4, 34*#gamePlay.records, "202020")
            fastMake('graphic', 'lengthingTile2', nil, 800, 1077, 4, 34*#gamePlay.records, "202020")
        
            for i=1,#moveables do
                setProperty(moveables[i][1]..".y", moveables[i][2])
            end
        end
    end
end

function onUpdate(elapsed)
    if songName == "online-stats" then
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
        for i=1,#moveables do
            doTweenY("thing"..i, moveables[i][1], moveables[i][2]+yScroll, 0.1, "linear")
        end
    end
end

function onEndSong()
    if not botPlay then
        local room = isRoomConnected()
        if room then
            local isbf = playsAsBF()
            local accu
            local win
            local user
            if room then
                accu = math.abs(getPlayerAccuracy((isbf and 2 or 1)) - getPlayerAccuracy((isbf and 1 or 2)))
                win = getPlayerAccuracy((isbf and 2 or 1)) - getPlayerAccuracy((isbf and 1 or 2)) <= 0 and false or true
                user = isbf and getPlayerName(1) or getPlayerName(2)
            else
                accu = math.abs(getPlayerAccuracy((isbf and 1 or 2)) - getPlayerAccuracy((isbf and 2 or 1)))
                win = getPlayerAccuracy((isbf and 1 or 2)) - getPlayerAccuracy((isbf and 2 or 1)) <= 0 and false or true
                user = isbf and getPlayerName(2) or getPlayerName(1)
            end
            table.insert(gamePlay.records, {user, win, accu})
            if win then
                gamePlay.wins = gamePlay.wins + 1; gamePlay.winstreak = gamePlay.winstreak + 1
            else
                gamePlay.winstreak = 0
                gamePlay.losses = gamePlay.losses + 1
            end
            if gamePlay.winstreak >= gamePlay.maxwinstreak then
                gamePlay.maxwinstreak = gamePlay.winstreak
            end
            gamePlay.hitRoom = gamePlay.hitRoom + hits
            gamePlay.wlratio = gamePlay.wins / gamePlay.losses
        else
            gamePlay.hitFreeplay = gamePlay.hitFreeplay + hits
        end
        for k, v in pairs(gamePlay) do
            setDataFromSave('POnlineStats', k, v)
        end
        flushSaveData('POnlineStats')
    end
end

function onStartCountdown() if songName == "online-stats" then return Function_Stop end end

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
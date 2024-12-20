-- SETTINGS!!
local prefs = {
    laneUnderlay    = false,    -- enables focus mode (black overlay) in camHud making you see hud easier. automatically disables if using botplay
    underlayOverlay = 0,       -- 1 = opaque, 0 = transparent
    showPopup       = true,    -- do you want to show the custom popup? if it's disabled, it'll reduce lag.
    showNPS         = false,    -- do you want it to show the NPS?
    useCustom       = false,   -- For estimated difficulty, do you want the text to show you if it's too difficult?
    legacyVer       = false,   -- If you wanna play with the old legacy type of bfnf:r, set to true
    popupDir        = {        -- The direction for rating popup (ODD: X | EVEN: Y) (DEFAULT: 425, 75, 200, 75)
        425, 75, -- Opponent Dir
        200, 75  -- Player Dir
    }
}

-- bfnf:r fanbase are ass but game is cool so i just recreate it
-- thank god stack overflow, ecr and funkyFridayHUD script exists, if it didn't it would take days to figure it out
-- ALSO it doesn't use complex accuracy.

-- MADE BY NAEL2XD
-- Some code was used by ECR and funkyFridayHUD

-- Now Supports PSYCH ONLINE!! yay :D

-- popup shit
local strumTime = 0
local rateType = ''
local okGoodTotalHit = 0
local optN = ""
local posX = 0
local posY = 0
local myCombo = 0
local numCount = 1
local lol = {}

-- camera breaking
local intensity = 0.03
local beatPerBop = 4
local bopDone = 1

-- cool shit bfnf:r includes
local singName = {"singLEFT", "singDOWN", "singUP", "singRIGHT"}
local isPlayer = false
local inMatch = false

-- sone sick options i created
local NPS = 0
local isPixel = false
local created = false
local ownsRoom = false
local coolCombo = 0

function onCreatePost()
    isPlayer = playsAsBF()
    inMatch  = isRoomConnected()
    isPixel  = getPropertyFromClass("states.PlayState", "isPixelStage")
    ownsRoom = isRoomOwner()

    if prefs.laneUnderlay and not botPlay then
        makeLuaSprite("ok", "ok")
        makeGraphic("ok", 480, 720, '000000')
        addLuaSprite("ok")
        screenCenter("ok")
        setObjectCamera("ok", "hud")
        setProperty("ok.alpha", prefs.underlayOverlay)

        if not middlescroll then
            if isPlayer then
                setProperty("ok.x", 762.5)
            else
                setProperty("ok.x", 32.5)
            end
        end
    end

    makeLuaSprite("timerBGyay", "", 0, 0)
    makeGraphic("timerBGyay", 610, 20, '000000')
    addLuaSprite("timerBGyay")
    setObjectCamera("timerBGyay", "hud")
    screenCenter("timerBGyay")

    removeLuaSprite("timerBGyikers")
    makeLuaSprite("timerBGyikers", "", 0, 0)
    makeGraphic("timerBGyikers", 600, 12, '484444')
    addLuaSprite("timerBGyikers")
    setObjectCamera("timerBGyikers", "hud")
    screenCenter("timerBGyikers")
    setProperty("timerBGyikers.x", 340)

    makeLuaText("name", songName, 1280, 0, 0)
    addLuaText("name")
    screenCenter("name")
    setTextSize("name", 25)
    setTextFont("name", "Kalam-Regular.ttf")
    setTextBorder("name", 1, "000000")
    if botPlay then
        setTextString("name", songName.." [BOT]")
    end

    makeLuaText("grrStupidScore", "=", 1280, 0, 0)
    addLuaText("grrStupidScore")
    screenCenter("grrStupidScore")
    setTextSize("grrStupidScore", 20)
    setTextFont("grrStupidScore", "SourceCodePro-Regular.ttf")
    setTextBorder("grrStupidScore", 1, "000000")
    if inMatch then
        makeLuaText("matchScore", "=", 1280, 0, 0)
        addLuaText("matchScore")
        screenCenter("matchScore")
        setTextSize("matchScore", 20)
        setTextFont("matchScore", "SourceCodePro-Regular.ttf")
        setTextBorder("matchScore", 1, "000000")

        if isPlayer then
            setProperty("grrStupidScore.x", 360)
            setProperty("matchScore.x", -360)
        else
            setProperty("grrStupidScore.x", -360)
            setProperty("matchScore.x", 360)
        end
    end

    makeLuaSprite("tweenforcam", "", 0, 0)
    makeGraphic("tweenforcam", 0, 0, '000000')
    addLuaSprite("tweenforcam")
    setProperty("tweenforcam.alpha", 0)

    setProperty("cameraSpeed", 2)

    setPropertyFromClass("ClientPrefs", "hideHud", true) -- oh yes

    if downscroll then
        setProperty("name.y", 678.5)
        setProperty("timerBGyay.y", 689.5)
        setProperty("timerBGyikers.y", 693)
        setProperty("grrStupidScore.y", 0)
        setProperty("matchScore.y", 0)
    else
        setProperty("name.y", 8)
        setProperty("timerBGyay.y", 18)
        setProperty("timerBGyikers.y", 21.5)
        setProperty("grrStupidScore.y", 690)
        setProperty("matchScore.y", 690)
    end
    
    for i = 0, getProperty("unspawnNotes.length")-1 do
        setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true)
		if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
		end
	end
end

function onSongStart()
    -- This gets all unspawnNotes from onSongStart???
    local firstStrumTime = 0
    local lastStrumTime = 0
    lastStrumTime = getPropertyFromGroup('unspawnNotes',getProperty("unspawnNotes.length")-1,'strumTime')
    firstStrumTime = getPropertyFromGroup('unspawnNotes',0,'strumTime')
    local EDDiff = math.floor(math.abs(((getProperty("unspawnNotes.length")+getProperty("notes.length"))/((getProperty('songLength')-(firstStrumTime+(lastStrumTime-getProperty('songLength'))))/1000))))*playbackRate
    local EDNames = {
        -- {Number, "your quote/sentence here"}
        {0, "This is really easy, no one can fail it."},
        {3, "Not a hard chart, really you can fc it."},
        {5, "This isn't really hard."},
        {10, "This difficulty is cranking up, try to FC!"},
        {15, "Only pro players can beat it, ha..."};
        {20, "You must have camellia skills to FC this."},
        {30, "No way you can FC this."},
        {40, "What is this chart bro."},
        {50,  "Are you playing a spam song?"},
        {100, "This is unbeatable, no way you can FC this."},
        {500, "I quit."},
        {10000, "."},
        {69420, "Palk is golden Freddy"},
        {101010, "Freaky Pico is coming for you"}
    }

    local difCount = 0
    for k, v in pairs(EDNames) do
        if EDDiff-1 <= EDNames[k][1] then
            difCount = k
            break
        end
    end

    makeLuaText("estimated", "Estimated Difficulty: "..EDDiff.." ("..EDNames[difCount][2]..")", 1280, 0, 0)
    if not prefs.useCustom then
        setTextString("estimated", "Estimated Difficulty: "..EDDiff)
    end
    addLuaText("estimated")
    screenCenter("estimated")
    setProperty("estimated.y", (downscroll and (inMatch and 10 or 25) or (inMatch and 690 or 670)))
    setTextSize("estimated", 20)
    runTimer("estimated", 5, 1)
end

function onBeatHit()
    if curBeat >= beatPerBop * bopDone then
        bopDone = bopDone + 1
        if curBeat >= beatPerBop * bopDone then
            repeat bopDone = bopDone + 1 until curBeat <= beatPerBop * bopDone
        end
        setProperty("tweenforcam.x", 0)
        setProperty("tweenforcam.x", intensity)
        doTweenX("tweener", "tweenforcam", 0, 0.25, "sineOut")
    end
end

function onUpdate(elapsed)
    -- Hiding things to make it look like the BFNF:R HUD
    created = false
    setProperty("scoreTxt.visible", false)
    setProperty("healthBarBG.visible", false)
    setProperty("healthBar.visible", false)
    setProperty("iconP1.visible", false)
    setProperty("iconP2.visible", false)
    setProperty("timeBar.visible", false)
    setProperty("timeBarBG.visible", false)
    setProperty("timeTxt.visible", false)
    setPropertyFromClass("ClientPrefs", "hideHud", true)
    setPropertyFromClass('backend.ClientPrefs', 'data.ghostTapping', true)

    -- other stuff
    setProperty('camHUD.zoom', 1 + getProperty("tweenforcam.x"))
    setProperty('showRating', false)
    setProperty('showComboNum', false)
    setProperty('showCombo', false)

    -- So the timer would work like in game on bfnf:r
    removeLuaSprite("timerBGholyshit")
    makeLuaSprite("timerBGholyshit", "", 0, 0)
    makeGraphic("timerBGholyshit", (getSongPosition()/getProperty('songLength'))*600, 12, '8aff1c')
    addLuaSprite("timerBGholyshit")
    setObjectCamera("timerBGholyshit", "hud")
    screenCenter("timerBGholyshit")
    setProperty("timerBGholyshit.x", 340)

    if downscroll then
        setProperty("timerBGholyshit.y", 693.5)
    else
        setProperty("timerBGholyshit.y", 21.5)
    end

    if inMatch then
        setProperty("practiceMode", false)
        setTextString("grrStupidScore", "Score: "..getPlayerScore((ownsRoom and 1 or 2)).." | Misses: "..getPlayerMisses((ownsRoom and 1 or 2)).." | Accuracy: "..string.format("%.2f%%", getPlayerAccuracy((ownsRoom and 1 or 2))))
        setTextString("matchScore", "Score: "..getPlayerScore((ownsRoom and 2 or 1)).." | Misses: "..getPlayerMisses((ownsRoom and 2 or 1)).." | Accuracy: "..string.format("%.2f%%", (getPlayerAccuracy((ownsRoom and 2 or 1)))))
    else
        setProperty("practiceMode", true)
        if botPlay then
            if prefs.showNPS then
                setTextString("grrStupidScore", "NPS: "..NPS)
            else
                setTextString("grrStupidScore", "BotPlay!")
            end
        else
            if prefs.showNPS then
                setTextString("grrStupidScore", "Score: "..score - (10 * misses).." | Misses: "..misses.." | Accuracy: "..string.format("%.2f%%", (rating*100)).." | NPS: "..NPS)
            else
                setTextString("grrStupidScore", "Score: "..score - (10 * misses).." | Misses: "..misses.." | Accuracy: "..string.format("%.2f%%", (rating*100)))
            end
        end
    end

    -- just stole from funkyfridayhud
    -- also grr stupid stupiding stupidest but i fixed it yay
    -- i fucking hate pixel
    for ii = 0,7 do 
        setPropertyFromGroup('strumLineNotes', ii, 'alpha', 1)
        if (ii <= 3 and isPlayer) or (ii >= 4 and not isPlayer) then
            setPropertyFromGroup('strumLineNotes', ii, 'scale.x', 0.4 * (isPixel and 8.5 or 1))
            setPropertyFromGroup('strumLineNotes', ii, 'scale.y', 0.4 * (isPixel and 8.5 or 1))
            setPropertyFromGroup('strumLineNotes', ii, 'x', (isPlayer and 105 or 755) + ((ii - 1)*65))
            if downscroll then
                setPropertyFromGroup('strumLineNotes', ii, 'y', 200)
            else
                setPropertyFromGroup('strumLineNotes', ii, 'y', 325)
            end
        else
            if downscroll then
                setPropertyFromGroup('strumLineNotes', ii, 'y', 575)
            else
                setPropertyFromGroup('strumLineNotes', ii, 'y', 55)
            end
            setPropertyFromGroup('strumLineNotes', ii, 'scale.x', 0.625 * (isPixel and 8.5 or 1))
            setPropertyFromGroup('strumLineNotes', ii, 'scale.y', 0.625 * (isPixel and 8.5 or 1))
        end
    end
    if middlescroll then
        for ii = 0, getProperty('notes.length')-1 do
            setPropertyFromGroup('notes', ii, 'scale.x', 0.625 * (isPixel and 8.5 or 1))
            setPropertyFromGroup('notes', ii, 'scale.y', 0.625 * (isPixel and 8.5 or 1))
            if isPlayer then
                if getPropertyFromGroup('notes', ii, 'mustPress') then
                    if getPropertyFromGroup('notes', ii, 'isSustainNote') then
                        setPropertyFromGroup('notes', ii, 'scale.y', (stepCrochet / 100 * 1.05) * getProperty('songSpeed') * (isPixel and 8.5 or 1))
                    end
                else
                    if getPropertyFromGroup('notes', ii, 'isSustainNote') then
                        setPropertyFromGroup('notes', ii, 'scale.y', (stepCrochet / 100 * 1.05) * getProperty('songSpeed') * (isPixel and 8.5 or 1))
                    else
                        setPropertyFromGroup('notes', ii, 'scale.y', 0.4 * (isPixel and 8.5 or 1))
                    end
                    setPropertyFromGroup('notes', ii, 'scale.x', 0.4 * (isPixel and 8.5 or 1))
                end
            else
                if not getPropertyFromGroup('notes', ii, 'mustPress') then
                    if getPropertyFromGroup('notes', ii, 'isSustainNote') then
                        setPropertyFromGroup('notes', ii, 'scale.y', (stepCrochet / 100 * 1.05) * getProperty('songSpeed') * (isPixel and 8.5 or 1))
                    end
                else
                    if getPropertyFromGroup('notes', ii, 'isSustainNote') then
                        setPropertyFromGroup('notes', ii, 'scale.y', (stepCrochet / 100 * 1.05) * getProperty('songSpeed') * (isPixel and 8.5 or 1))
                    else
                        setPropertyFromGroup('notes', ii, 'scale.y', 0.4 * (isPixel and 8.5 or 1))
                    end
                    setPropertyFromGroup('notes', ii, 'scale.x', 0.4 * (isPixel and 8.5 or 1))
                end
            end
        end
    else
        for ii = 0, getProperty('notes.length')-1 do
            setPropertyFromGroup('notes', ii, 'scale.x', 0.625 * (isPixel and 8.5 or 1))
            setPropertyFromGroup('notes', ii, 'scale.y', 0.625 * (isPixel and 8.5 or 1))
            if getPropertyFromGroup('notes', ii, 'isSustainNote') then
                setPropertyFromGroup('notes', ii, 'scale.y', (stepCrochet / 100 * 1.05) * getProperty('songSpeed') * (isPixel and 8.5 or 1))
            end
        end
        for ii=0,7 do
            if ii <= 3 then
                setPropertyFromGroup('strumLineNotes', ii, 'x', 165 + ((ii - 1)*110))
            else
                setPropertyFromGroup('strumLineNotes', ii, 'x', 450 + ((ii - 1)*110))
            end
            if downscroll then
                setPropertyFromGroup('strumLineNotes', ii, 'y', 575)
            else
                setPropertyFromGroup('strumLineNotes', ii, 'y', 55)
            end
            setPropertyFromGroup('strumLineNotes', ii, 'scale.x', 0.625 * (isPixel and 8.5 or 1))
            setPropertyFromGroup('strumLineNotes', ii, 'scale.y', 0.625 * (isPixel and 8.5 or 1))
        end
    end
end

function onEvent(eventName, value1, value2, strumTime)
    if eventName == "Add Camera Zoom" then
        setProperty("tweenforcam.x", 0)
        if value1 == nil then
            setProperty("tweenforcam.x", 0.02)
        else
            setProperty("tweenforcam.x", 0.02*value1)
        end
        doTweenX("tweener", "tweenforcam", 0, 0.25, "sineOut")
    end
    if eventName == "Camera Bopping" then
        if value1 == 0 or value1 == nil then
            beatPerBop = 4
        else
            beatPerBop = value1
        end
        if value2 == 0 or value2 == nil then
            intensity = 0.03
        else
            intensity = value2/33
        end
    end
end

-- This thing below this text took me like an hour, holy shit.
function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if isPlayer then
        if botPlay and not isSustainNote then
            setProperty('playerStrums.members['..noteData..'].resetAnim', 0.05)
        end
        okGoodTotalHit = okGoodTotalHit + 1
        if not isSustainNote then coolCombo = coolCombo + 1 end
        optN = "rating"..okGoodTotalHit
        posX = getProperty("boyfriend.x") - prefs.popupDir[3]
        posY = getProperty("boyfriend.y") + prefs.popupDir[4]
        numCount = 1
        if prefs.showNPS and not isSustainNote then
            NPS = NPS + 1
            runTimer("nps"..okGoodTotalHit, 1, 1)
        end
        if not isSustainNote and prefs.showPopup and not created then
            created = true
            strumTime = getPropertyFromGroup('notes', membersIndex, 'strumTime')
            rateType = getRating((strumTime - getSongPosition() + getPropertyFromClass('ClientPrefs','ratingOffset')) / playbackRate)
            makeLuaSprite(optN, rateType, posX, posY)
            addLuaSprite(optN, true)
            scaleObject(optN, 0.75, 0.75)
            doTweenY(optN.."lol", optN, (posY) - 112.5, 1, "cubeOut")

            myCombo = coolCombo
            lol = {}
            numCount = 3
            table.insert(lol, (math.floor(myCombo % 10)))
            table.insert(lol, (math.floor((myCombo / 10) % 10)))
            table.insert(lol, (math.floor((myCombo / 100) % 10)))
            if myCombo >= 1000 then
                numCount = math.floor(math.log10(myCombo)+1)
                for i=4,numCount do
                    table.insert(lol, (math.floor(myCombo / (10^(i-1))) % 10))
                end
            end
    
            for i=1,numCount,1 do
                posX = getProperty("boyfriend.x") - 310 + (60 * i)
                posY = getProperty("boyfriend.y") + 230
                optN = "popup"..okGoodTotalHit..i
                makeLuaSprite(optN, 'num'..(lol[math.abs(-numCount-1+i)]), posX, posY)
                addLuaSprite(optN, true)
                scaleObject(optN, 0.5825, 0.5825)
                doTweenY(optN.."lol", optN, (posY) - 112.5, 1, "cubeOut")
            end
        end
    else
        if not isSustainNote then
            setProperty('playerStrums.members['..noteData..'].resetAnim', 0.05)
        end
    end
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    setProperty('vocals.volume', 1)
    coolCombo = 0
    if instakillOnMiss and not inMatch then
        restartSong(true)
    end
end

function onGhostTap(key)
    if prefs.legacyVer then
        coolCombo = 0
        addScore(-10)
    end
    if isPlayer then
        if gfSection then
            playAnim("gf", singName[key+1])
        else
            playAnim("boyfriend", singName[key+1])
        end
    else
        if gfSection then
            playAnim("gf", singName[key+1])
        else
            playAnim("dad", singName[key+1])
        end
    end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not isPlayer then
        if botPlay and not isSustainNote then
            setProperty('opponentStrums.members['..noteData..'].resetAnim', 0.05)
        end
        okGoodTotalHit = okGoodTotalHit + 1
        if not isSustainNote then coolCombo = coolCombo + 1 end
        optN = "rating"..okGoodTotalHit
        posX = getProperty("dad.x") + prefs.popupDir[1]
        posY = getProperty("dad.y") + prefs.popupDir[2]
        numCount = 1
        if prefs.showNPS and not isSustainNote then
            NPS = NPS + 1
            runTimer("nps"..okGoodTotalHit, 1, 1)
        end
        if not isSustainNote and prefs.showPopup and not created then
            created = true
            strumTime = getPropertyFromGroup('notes', membersIndex, 'strumTime')
            rateType = getRating((strumTime - getSongPosition() + getPropertyFromClass('ClientPrefs','ratingOffset')) / playbackRate)
            makeLuaSprite(optN, rateType, posX, posY)
            addLuaSprite(optN, true)
            scaleObject(optN, 0.75, 0.75)
            doTweenY(optN.."lol", optN, (posY) - 112.5, 1, "cubeOut")
    
            myCombo = coolCombo
            lol = {}
            numCount = 3
            table.insert(lol, (math.floor(myCombo % 10)))
            table.insert(lol, (math.floor((myCombo / 10) % 10)))
            table.insert(lol, (math.floor((myCombo / 100) % 10)))
            if myCombo >= 1000 then
                numCount = math.floor(math.log10(myCombo)+1)
                for i=4,numCount do
                    table.insert(lol, (math.floor(myCombo / (10^(i-1))) % 10))
                end
            end
    
            for i=1,numCount,1 do
                posX = getProperty("dad.x") + 325 + (60 * i)
                posY = getProperty("dad.y") + 230
                optN = "popup"..okGoodTotalHit..i
                makeLuaSprite(optN, 'num'..(lol[math.abs(-numCount-1+i)]), posX, posY)
                addLuaSprite(optN, true)
                scaleObject(optN, 0.5825, 0.5825)
                doTweenY(optN.."lol", optN, (posY) - 112.5, 1, "cubeOut")
            end
        end
    else
        if not isSustainNote then
            setProperty('opponentStrums.members['..noteData..'].resetAnim', 0.05)
        end
    end
end

function onTweenCompleted(tag)
    if luaSpriteExists(tag) then
        removeLuaSprite(tag)
    end
    if tag == "estimatedBye" then
        removeLuaText("estimated")
    end
    doTweenAlpha(tag:gsub("lol", ""), tag:gsub("lol", ""), 0, 0.35, "linear")
end

function onTimerCompleted(tag, loops, loopsLeft)
    if stringStartsWith(tag, "nps") then
        NPS = NPS - 1
    end
    if tag == "estimated" then
        doTweenAlpha("estimatedBye", "estimated", 0, 1, "linear")
    end
end

function getRating(ms)
	ms = math.abs(ms/playbackRate)
	if ms <= getPropertyFromClass('ClientPrefs', 'badWindow') then
		if ms <= getPropertyFromClass('ClientPrefs', 'goodWindow') then
			if ms <= getPropertyFromClass('ClientPrefs', 'sickWindow') then
				return 'sick'
			end
			return 'good'
		end
		return 'bad'
	end
	return 'shit'
end
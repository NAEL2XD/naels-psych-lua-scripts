-- Made by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)
-- Don't steal this! It's stupid if you did.

-- nael2xd

local imagePath = 'smeg'  -- Found in mods/images
local easeType = 'backOut' -- https://api.haxeflixel.com/flixel/tweens/FlxEase.html
local isBf = true  --playsAsBF()        -- Do you want your image to be bf?

--

local idleDone = 1
local animInProg = false
local dadX = 0
local dadY = 0
local bfX  = 0
local bfY  = 0

function onCreatePost()
    makeLuaSprite("smeg", imagePath, 0, 0)
    addLuaSprite("smeg", true)
    if isBf then
        setProperty("boyfriend.alpha", 0)
        bfX = getProperty("boyfriend.x")
        bfY = getProperty("boyfriend.y")-375
    else
        dadX = getProperty("dad.x") + 75
        dadY = getProperty("dad.y") - 200
        setProperty("dad.alpha", 0)
    end
end

function onUpdate(elapsed)
    if animInProg == false then
        if isBf then
            setProperty("smeg.x", bfX)
            setProperty("smeg.y", bfY + 350)
            setProperty("smeg.scale.x", -1)
        else
            setProperty("smeg.x", dadX)
            setProperty("smeg.y", dadY + 400)
            setProperty("smeg.scale.x", 1)
        end
    end
end

function onBeatHit()
    if curBeat >= 2 * idleDone then
        repeat idleDone = idleDone + 1 until curBeat <= 2 * idleDone -- did it instead of using only 'idleDone = idleDone + 1' as it can not do animation when you lag.
        if animInProg == false then
            animInProg = true
            if isBf then
                setProperty("smeg.scale.x", -1)
                setProperty("smeg.y", bfY + 350 + (100))
                doTweenY("anim2", "smeg", bfY + 350, 90/bpm, easeType)
            else
                setProperty("smeg.scale.x", 1)
                setProperty("smeg.y", dadY + 475 + (25))
                doTweenY("anim2", "smeg", dadY + 400, 90/bpm, easeType)
            end
            setProperty("smeg.scale.y", 0.5)
            doTweenY("a", "smeg.scale", 1, 90/bpm, easeType)
        end
    end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not isBf and not gfSection then
        cancelTween("anim")
        cancelTween("anim2")
        cancelTween("animFlip")
        cancelTween("a")
        cancelTimer("aip")
        animInProg = true
        setProperty("smeg.scale.x", 1)
        setProperty("smeg.scale.y", 1)
        setProperty("smeg.x", dadX)
        setProperty("smeg.y", dadY + 400)
        if noteData == 0 then
            setProperty("smeg.scale.x", -1.5)
            setProperty("smeg.x", dadX - 100)
            doTweenX("animFlip", "smeg.scale", -1, (60/bpm), easeType)
            doTweenX("anim2", "smeg", dadX, (60/bpm), easeType)
        elseif noteData == 1 then
            setProperty("smeg.scale.y", 0.1)
            setProperty("smeg.y", dadY + 580)
            doTweenY("anim", "smeg.scale", 1, (60/bpm), easeType)
            doTweenY("anim2", "smeg", dadY + 400, (60/bpm), easeType)
        elseif noteData == 2 then
            setProperty("smeg.scale.y", 1.5)
            setProperty("smeg.y", dadY +300)
            doTweenY("anim", "smeg.scale", 1, (60/bpm), easeType)
            doTweenY("anim2", "smeg", dadY + 400, (60/bpm), easeType)
        elseif noteData == 3 then
            setProperty("smeg.scale.x", 1.5)
            setProperty("smeg.x", dadX + (100))
            doTweenX("anim", "smeg.scale", 1, (60/bpm), easeType)
            doTweenX("anim2", "smeg", dadX, (60/bpm), easeType)
        end
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if isBf then
        cancelTween("anim")
        cancelTween("animFlip")
        cancelTween("anim2")
        cancelTween("a")
        cancelTimer("aip")
        animInProg = true
        setProperty("smeg.scale.x", -1)
        setProperty("smeg.scale.y", 1)
        setProperty("smeg.x", bfX)
        setProperty("smeg.y", bfY + 350)
        if noteData == 0 then
            setProperty("smeg.scale.x", -1.5)
            setProperty("smeg.x", bfX - 100)
            doTweenX("anim", "smeg.scale", -1, (60/bpm), easeType)
            doTweenX("anim2", "smeg", bfX, (60/bpm), easeType)
        elseif noteData == 1 then
            setProperty("smeg.scale.y", 0.1)
            setProperty("smeg.y", bfY + 530)
            doTweenY("anim", "smeg.scale", 1, (60/bpm), easeType)
            doTweenY("anim2", "smeg", bfY + 350, (60/bpm), easeType)
        elseif noteData == 2 then
            setProperty("smeg.scale.y", 1.5)
            setProperty("smeg.y", bfY + 250)
            doTweenY("anim", "smeg.scale", 1, (60/bpm), easeType)
            doTweenY("anim2", "smeg", bfY + 350, (60/bpm), easeType)
        elseif noteData == 3 then
            setProperty("smeg.scale.x", 1.5)
            setProperty("smeg.x", bfX + 100)
            doTweenX("animFlip", "smeg.scale", 1, (60/bpm), easeType)
            doTweenX("anim2", "smeg", bfX, (60/bpm), easeType)
        end
    end
end

function onTweenCompleted(tag)
    if tag == 'anim' or tag == 'a' then
        animInProg = false
    end
    if tag == 'animFlip' then
        if isBf then
            doTweenX("anim", "smeg.scale", -1, (60/bpm), easeType)
        else
            doTweenX("anim", "smeg.scale", 1, (60/bpm), easeType)
        end
    end
end
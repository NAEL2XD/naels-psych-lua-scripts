-- It's fucking sticker star again!

local stickerCount = 0
local id = 'id'

function onCreatePost()
    repeat stickerCount = stickerCount + 1 until not checkFileExists("images/stickers/"..stickerCount..".png")
    stickerCount = stickerCount - 1
    debugPrint("Found ", stickerCount, " stickers.")
end

function onUpdate(elapsed)
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
    if mouseClicked("left") then
        id = 'id'..math.random(-100000000000000,100000000000000)
        makeLuaSprite(id, 'stickers/'..math.random(1, stickerCount), getMouseX("hud")-150, getMouseY("hud")-125)
        addLuaSprite(id)
        setObjectCamera(id, "hud")
        setProperty(id..'.alpha', 0)
        doTweenAlpha("hi"..id, id, 1, 0.2, "cubeIn")
        doTweenX("scaleX"..id, id..".scale", 0.6, 0.2, "cubeIn")
        doTweenY("scaleY"..id, id..".scale", 0.6, 0.2, "cubeIn")
        runTimer(id, 5, 1)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    doTweenAlpha("bye"..tag, tag, 0, 0.25, "linear")
end
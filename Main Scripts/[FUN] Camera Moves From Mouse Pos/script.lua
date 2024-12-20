local force = 2 -- how much force does it go

function onUpdate(elapsed)
    triggerEvent("Camera Follow Pos", getMouseX("game") * force, getMouseY("game") * force)
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
end
-- Made by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)
-- Don't steal this! It's stupid if you did.

local force = 2 -- how much force does it go

function onUpdate(elapsed)
    triggerEvent("Camera Follow Pos", getMouseX("game") * force, getMouseY("game") * force)
    setPropertyFromClass('flixel.FlxG', 'mouse.visible', true)
end
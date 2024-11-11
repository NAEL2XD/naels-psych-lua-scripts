local isEnabled = false
local myCounter = 1
local style = 0
local mahListo = {}

function table.split(inputstr, sep)
    if sep == nil then
        sep = "%s";
    end
    local t={};
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str);
    end
    return t;
end

function onEvent(eventName, value1, value2, strumTime)
    if eventName == "Rave Party" then
        if tonumber(value1) == 1 then
            isEnabled = true
            if value2 == nil and isEnabled then
                mahListo[1] = 2
                mahListo[2] = 5
            else
                mahListo = table.split(value2,", ");
                mahListo[1] = tonumber(mahListo[1])
                mahListo[2] = tonumber(mahListo[2])
            end
        else
            isEnabled = false
        end
    end
end

function onBeatHit()
    if isEnabled and curBeat >= mahListo[1] * myCounter and flashingLights then
		repeat myCounter = myCounter + 1 until curBeat <= mahListo[1] * myCounter
        for i=1, mahListo[2] do
            local rgb = {}
            for ii=1,3 do
                table.insert(rgb, getRandomInt(0, 255))
            end
            style = style + 1
            makeLuaSprite("rave"..style, "rave", 0, 0)
            addLuaSprite("rave"..style)
            scaleObject("rave"..style, 1, 400)
            screenCenter("rave"..style)
            setProperty("rave"..style..".color", getColorFromHex(rgbToHex(rgb)))
            setProperty("rave"..style..".angle", getRandomFloat(-22.5, 22.5))
            setProperty("rave"..style..".x", getRandomInt(-50, 1275))
            setObjectCamera("rave"..style, "hud")
            doTweenAngle("rave"..style, "rave"..style, getProperty("rave"..style..".angle") + getRandomFloat(-10, 10), (60/bpm)*mahListo[1], "linear")
            doTweenAlpha("bye"..style, "rave"..style, 0, (45/bpm)*mahListo[1], "linear")
        end
	end
end

function rgbToHex(rgb)
    local hexadecimal = ''
    for key, value in pairs(rgb) do
        local hex = ''
        while (value > 0) do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value / 16)
            hex = string.sub('0123456789ABCDEF', index, index) .. hex
        end
        if (string.len(hex) == 0) then
            hex = '00'
        elseif (string.len(hex) == 1) then
            hex = '0' .. hex
        end
        hexadecimal = hexadecimal .. hex
    end
    return hexadecimal
end

function onTweenCompleted(tag)
    if stringStartsWith(tag, "rave") then
        removeLuaSprite(tag)
    end
end
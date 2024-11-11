function onCreate()
    for i=1,4 do
        makeLuaSprite("arm"..i, "", 0, 0)
        makeGraphic("arm"..i, 0, 0, "000000")
        addLuaSprite("arm"..i)
    end
    setProperty("arm4.y", 1)

    local color = {0, 0, 0}

    for i=1,1020 do
        for ii=1,3 do
            color[ii] = getProperty("arm"..ii..".x")
        end
        makeLuaSprite("woah"..i, "", 800, -i+950)
        makeGraphic("woah"..i, 256, 8, rgbToHex(color))
        addLuaSprite("woah"..i, true)
        if i <= 255 then
            setProperty("arm1.x", i)
        end
        if i <= 510 then
            setProperty("arm1.x", getProperty("arm1.x") - 1)
            setProperty("arm2.x", i-255)
        end
        if i <= 765 then
            setProperty("arm2.x", getProperty("arm2.x") - 1)
            setProperty("arm3.x", i-510)
        end
        if i <= 1020 then
            setProperty("arm3.x", getProperty("arm3.x") - 1)
            --setProperty("arm1.x", i-765)
        end
    end
end

function onUpdate(elapsed)
    for i=1,1020 do
        setProperty("woah"..i..".x", 600+(math.sin((getSongPosition()/400)+(i/200))*100))
        setProperty("woah"..i..".y", 500+((-510+i)/getProperty("arm4.y")))
    end
end

function rgbToHex(rgb)         -- https://gist.github.com/marceloCodget/3862929
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
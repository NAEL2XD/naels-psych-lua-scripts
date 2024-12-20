-- Basic stage create by nael2xd
-- MUST HAVE SHADERHANDLER.LUA IN mods/scripts!!!!

local shaderInitialized = false -- required

-- Current functions:
-- addSprite("name", x,y)
-- addShader(shadername, target, isBuiltIn, type, v1, v2)

----------------------------------

function onCreatePost() --needed
    --input code here :)
end

----------------------------------

function addSprite(tag, xy)
    makeLuaSprite(tag, tag, xy)
    addLuaSprite(tag)
end

function addShader(shadername, target, isBuiltIn, type, v1, v2)
    if isBuiltIn then
        if type == chromatic then
            addChromaticAbberationEffect(target, v1, v2)
        end
    else
        if target == camGAME or target == camHUD or target == camOTHER then
            if shaderInitialized == false then
                requireShader()
            end
            addShaderOnCamera(target, shadername)
        else
            if shaderInitialized == false then
                requireShader()
                setSpriteShader(target, shadername)
            end
        end
    end
end

function requireShader()
    require('mods.scripts.ShaderHandler')
    initShaderHandler()
    setProperty('camHUD.bgColor', 0x01000000)
    initLuaShader(shadername)
    local shaderInitialized = true
end
-- Made by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)
-- Don't steal this! It's stupid if you did.

local decimalDigits = 3          -- works best with 3, for spam stuff use 5-6
local optimizeAys   = false       -- do you wanna optimize? or use the Sguiqqyl qdfmj i cant spell
local doBoth        = false       -- converts both optimized and sss ays chart
-- CREATE A FOLDER NAMED "AYS" INSIDE MODS, OR ELSE YOU'LL GET AN ERROR.
-- DO NOT USE 0.7+

local modName = ""
function onCreatePost()
    if stringStartsWith(version, "0.6") then
        modName = tostring(currentModDirectory)
        if doBoth then
            optimizeAys = true
            convert()
            optimizeAys = false
            convert()
        else
            convert()
        end
        saveFile(tostring(currentModDirectory).."\\songs\\"..songPath.."\\".."module.txt", "BPM: "..curBpm.."\nSpeed: "..getProperty('songSpeed'))
        if modName == "" then
            os.execute('explorer ".\\mods\\songs\\'..songPath..'"')
        else
            os.execute('explorer ".\\mods\\'..modName..'\\songs\\'..songPath..'"')
        end
    else
        makeLuaText("ERROR", "DO NOT USE PSYCH ENGINE 0.7+, THIS BREAKS AYS CODE!!\nUSE JS ENGINE/PSYCH ENGINE 0.6.3 INSTEAD.", 1280, 0, 0)
        addLuaText("ERROR")
        screenCenter("ERROR")
        setTextSize("ERROR", 30)
        setTextColor("ERROR", "FF0000")
        setObjectCamera("ERROR", "other")
        doTweenAlpha("a", "ERROR", 0, 20, "linear")
    end
end

function convert()
    local strumTime = 0
    local nData = 0
    local sustainTime = 0
    local result = ""
    saveFile("temp", "")
    for i=0, getProperty('unspawnNotes.length')-1 do
        if not getPropertyFromGroup('unspawnNotes',i,'isSustainNote') then
            strumTime = getPropertyFromGroup('unspawnNotes',i,'strumTime')/1000
            sustainTime = getPropertyFromGroup('unspawnNotes',i,'sustainLength')
            if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                nData = getPropertyFromGroup('unspawnNotes',i,'noteData')+5
            else
                nData = getPropertyFromGroup('unspawnNotes',i,'noteData')+1
            end
            if optimizeAys then
                result = result..string.format("%."..decimalDigits.."f", strumTime)..","..nData.."\n"
            else
                result = result.."{"..string.format("%."..decimalDigits.."f", strumTime).."}: {"..nData.."}: {}: {"..sustainTime.."}\n"
            end
            if #result >= 69420 then
                saveFile("temp", getTextFromFile("temp")..result)
                result = ""
            end
        end
    end
    if modName == "" then
        saveFile("\\songs\\"..songPath.."\\"..songName..(optimizeAys and " optimized ver" or " SSS ver")..".txt", getTextFromFile("temp")..result)
    else
        saveFile(tostring(currentModDirectory).."\\songs\\"..songPath.."\\"..songName..(optimizeAys and " optimized ver" or " SSS ver")..".txt", getTextFromFile("temp")..result)
    end
    deleteFile("temp")
end
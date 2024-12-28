-- Made by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)
-- Don't steal this! It's stupid if you did.

function onCreatePost()
    if stringStartsWith(version, "0.6") then
        convert()
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
    local strumTime, nData
    local result = ''
    local ses = {0, 2, 4, 6}
    saveFile("temp", '[{"type":"s2","dict":{"a":0,"a1":1,"s":2,"s1":3,"d":4,"d1":5,"f":6,"f1":7}}')
    local oldTime = -1
    local spamCheck = {false, false, false, false}
    for i=0, getProperty('unspawnNotes.length')-1 do
        if not getPropertyFromGroup('unspawnNotes',i,'isSustainNote') and getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
            strumTime = string.format("%.3f", getPropertyFromGroup('unspawnNotes',i,'strumTime')/1000)
            nData = getPropertyFromGroup('unspawnNotes',i,'noteData')+1
            if not spamCheck[nData] then
                result = result..","..ses[nData]..","..strumTime
                if #result >= 69420 then
                    saveFile("temp", getTextFromFile("temp")..result)
                    result = ""
                end
                spamCheck[nData] = true
            end
            if strumTime ~= oldTime then
                oldTime = strumTime
                spamCheck = {false, false, false, false}
            end
        end
    end
    result = result.."]"
    saveFile(songName..".gpop", getTextFromFile("temp")..result)
    deleteFile("temp")
end
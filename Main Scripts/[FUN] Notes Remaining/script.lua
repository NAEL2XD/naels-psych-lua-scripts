-- Made by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)
-- Don't steal this! It's stupid if you did.

-- how much notes left

local nC = 0

function onCreatePost()
    for i=0, getProperty('unspawnNotes.length')-1 do
        if (getPropertyFromGroup('unspawnNotes', i, 'mustPress') and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote')) then
            nC = nC + 1
        end
    end

    makeLuaText("a", "", 1280, 0.0, 0.0)
    addLuaText("a")
    screenCenter("a")
    setProperty("a.y", 0)
end

function onUpdate(elapsed)
    setTextString("a", "Player Note Remaining: "..nC-(hits+misses))
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    if isSustainNote then nC = nC + 1 end
end
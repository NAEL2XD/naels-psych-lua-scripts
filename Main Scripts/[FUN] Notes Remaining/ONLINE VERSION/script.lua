-- how much notes left

local nC = 0
local isPlayer = true

function onCreatePost()
    isPlayer = playsAsBF()
    for i=0, getProperty('unspawnNotes.length')-1 do
        if isPlayer then
            if (getPropertyFromGroup('unspawnNotes', i, 'mustPress') and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote')) then
                nC = nC + 1
            end
        else
            if (not getPropertyFromGroup('unspawnNotes', i, 'mustPress') and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote')) then
                nC = nC + 1
            end
        end
    end

    makeLuaText("a", "", 1280, 0.0, 0.0)
    addLuaText("a")
    screenCenter("a")
    setProperty("a.y", 0)
end

--[[function onSongStart()
    for i=0, getProperty('unspawnNotes.length')-1 do
        if (getPropertyFromGroup('unspawnNotes', i, 'mustPress') and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote')) then
            nC = nC + 1
        end
    end
end]]

function onUpdate(elapsed)
    setTextString("a", (isPlayer and "Player's " or "Opponent's ").."Note Remaining: "..nC-(hits+misses).." | Notes Rendered: "..getProperty('notes.length'))
end

---
--- @param membersIndex int
--- @param noteData int
--- @param noteType string
--- @param isSustainNote bool
---
function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    if isSustainNote then nC = nC + 1 end
end
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
    local strumTime = 0
    local nData = 0
    local sustainTime = 0
    local result = "[HitObjects]\n"
    local noteDataArray = {64, 192, 320, 448}
    local isHold = false
    saveFile("temp", [[osu file format v14

[General]
AudioFilename:Inst.ogg
AudioLeadIn:0
PreviewTime:-1
Countdown:0
SampleSet:Normal
StackLeniency:1
Mode:3
LetterboxInBreaks:0
SpecialStyle:0
WidescreenStoryboard:0

[Editor]
DistanceSpacing:0.8
BeatDivisor:1
GridSize:32
TimelineZoom:1

[Metadata]
Title:]]..songName..[[

TitleUnicode:]]..songName..[[

Artist:REPLACE ME!
ArtistUnicode:REPLACE ME!
Creator:Nael's FNF to OSU [LUA SCRIPT]
Version:]]..difficultyName..[[

Source:
Tags:
BeatmapID:0
BeatmapSetID:-1

[Difficulty]
HPDrainRate:5
CircleSize:4
OverallDifficulty:5
ApproachRate:5
SliderMultiplier:1.4
SliderTickRate:1

[Events]
//Background and Video events
//Break Periods
//Storyboard Layer 0 (Background)
//Storyboard Layer 1 (Fail)
//Storyboard Layer 2 (Pass)
//Storyboard Layer 3 (Foreground)
//Storyboard Layer 4 (Overlay)
//Storyboard Sound Samples

[TimingPoints]
0,]]..(60000/curBpm)..[[,4,1,0,100,1,0

]])
    for i=0, getProperty('unspawnNotes.length')-1 do
        if not getPropertyFromGroup('unspawnNotes',i,'isSustainNote') and getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
            strumTime = getPropertyFromGroup('unspawnNotes',i,'strumTime')
            sustainTime = getPropertyFromGroup('unspawnNotes',i,'sustainLength')
            nData = noteDataArray[getPropertyFromGroup('unspawnNotes',i,'noteData')+1]
            if sustainTime >= 1 then
                isHold = true
            else
                isHold = false
            end
            result = result..nData..",192,"..strumTime..","..(isHold and 128 or 1)..",0,"..(isHold and strumTime+sustainTime..":0:0:0:0:" or "0:0:0:0:").."\n"
            if #result >= 69420 then
                saveFile("temp", getTextFromFile("temp")..result)
                result = ""
            end
        end
    end
    saveFile(tostring(currentModDirectory).."\\songs\\"..songPath.."\\".."Friday Night Funkin - "..songName.." (USER HERE) ["..difficultyName.."].osu", getTextFromFile("temp")..result)
    os.execute('explorer ".\\mods\\'..tostring(currentModDirectory)..'\\songs\\'..songPath..'"')
    deleteFile("temp")
end
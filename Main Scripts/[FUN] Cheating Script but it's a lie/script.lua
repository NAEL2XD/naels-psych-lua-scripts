-- Made by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)
-- Don't steal this! It's stupid if you did.

function onCreatePost()
    debugPrint("Cheating Script Activated.")
    runTimer("iSmellSus", 22, 1)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "iSmellSus" then
        makeLuaSprite("gone", "", 10000, 0)
        makeGraphic("gone", 1, 1, "000000")
        addLuaSprite("gone")
        setProperty("gone.alpha", 0)
        doTweenX("CHEATER", "gone", 1, 1, "linear")
    end
    if tag == "muahaha" then
        os.exit()
    end
end

function onTweenCompleted(tag)
    if tag == "CHEATER" then
        makeLuaSprite('flash', '', 0, 0);
        makeGraphic('flash', 1280, 720, '000000')
        addLuaSprite('flash', true);
        setObjectCamera("flash", "other")
        setScrollFactor('flash', 0, 0)
        setProperty('flash.scale.x', 2)
        setProperty('flash.scale.y', 2)
        setProperty('flash.alpha', 0)
        screenCenter("flash")
        doTweenAlpha("grr", "flash", 0.9, 0.00025, "linear")
    end
    if tag == 'grr' then
        makeLuaText("iSmell2", "We have detected that you are cheating in a game\nThis is not allowed and as for cheating, your game will now close. Thank you for using our service.", 1280, 0, 0)
        addLuaText("iSmell2")
        setTextSize("iSmell2", 25)
        setObjectCamera("iSmell2", "other")
        screenCenter("iSmell2")
        setProperty("iSmell2.alpha", 0)
        doTweenAlpha("!!!", "iSmell2", 1, 0.00033, "linear")
        runTimer("muahaha", 5, 1)
    end
end

function onUpdate(elapsed)
    if luaSpriteExists("gone") then
        setProperty("playbackRate", getProperty("gone.x") / 10000)
    end
    runHaxeCode([[
        game.notes.forEach(function(daNote:Note) {
            if(!daNote.blockHit && !daNote.ignoreNote && daNote.mustPress && !game.cpuControlled && daNote.canBeHit) {
                if(daNote.isSustainNote) {
                    if(daNote.canBeHit) {
                        game.goodNoteHit(daNote);
                    }
                } else if(daNote.strumTime <= Conductor.songPosition || daNote.isSustainNote) {
                    game.goodNoteHit(daNote);
                }
            }
        });
    ]])
end

function goodNoteHit(i, d)
    setProperty('playerStrums.members['..d..'].resetAnim', stringEndsWith(getProperty('notes.members['..i..'].animation.curAnim.name'), 'hold') and 0.3 or 0.15)
end
function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    setProperty("camHUD.y", 0)
    setProperty("camHUD.angle", 0)
    cancelTween("piece1")
    cancelTween("piece2")
    if noteData == 0 then
        setProperty("camHUD.angle", -5)
    end
    if noteData == 1 then
        setProperty("camHUD.y", 37.5)
    end
    if noteData == 2 then
        setProperty("camHUD.y", -37.5)
    end
    if noteData == 3 then
        setProperty("camHUD.angle", 5)
    end
    doTweenAngle("piece1", "camHUD", 0, 0.25, "cubeOut")
    doTweenY("piece2", "camHUD", 0, 0.25, "cubeOut")
end
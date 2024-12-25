-- Made by Nael2xd (https://github.com/NAEL2XD/naels-psych-lua-scripts)
-- Don't steal this! It's stupid if you did.

local textSpawn = 0
local line = 0
local colon = 0
local written = 0
local canWrite = false
local whatWritten = {}

function onCreatePost()
    makeLuaSprite("TCP", "", 0, 0)
    makeGraphic("TCP", 1920, 1080, "000000")
    addLuaSprite("TCP")
    setObjectCamera("TCP", "other")
    screenCenter("TCP")

    local quotes = {
        "You think we've been a bit too far?",
        "Microsoft? Nah, Psych Engine? Yeah!",
        "Nael2xd wasn't here, i promise.",
        "Uhm askshually this is a fanmade-",
        "For help, type \"HELP\""
    }
    echo("Command Prompt - Psych Engine Edition. v0.1.0")
    echo(quotes[getRandomInt(1, #quotes)])
    echo("> ", true)
end

function onUpdate(elapsed)
    if canWrite then
        local allKeys = {
            "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "ZERO",
            "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
            "A", "S", "D", "F", "G", "H", "J", "K", "L",
            "Z", "X", "C", "V", "B", "N", "M",
            "MINUS", "SPACE", "SLASH", "BACKSPACE", "ENTER"
        }
        for i=1,#allKeys do
            if keyboardJustPressed(allKeys[i]) then
                local letter = allKeys[i]
                if letter == "ENTER" then
                    canWrite = false
                    local send = ""
                    written = 0
                    for ii=1,#whatWritten do
                        send = send..whatWritten[ii]
                    end
                    whatWritten = {}
                    sendAndReceive(send)
                else
                    if letter == "SIX" then
                        restartSong(true)
                    end
                    if letter == "SPACE" then
                        letter = " "
                    end
                    if letter == "BACKSPACE" then
                        if written == 0 then break end
                        local o = "text"..textSpawn
                        removeLuaText(o)
                        whatWritten[written] = nil
                        written = written - 1
                        textSpawn = textSpawn - 1
                        colon = colon - 1
                        break
                    end
                    written = written + 1
                    colon = colon + 1
                    textSpawn = textSpawn + 1
                    local o = "text"..textSpawn
                    makeLuaText(o, letter, 1920, -15+(15*colon), -22.5+(22.5*line))
                    addLuaText(o)
                    setTextSize(o, 28)
                    setObjectCamera(o, "other")
                    setTextAlignment(o, "left")
                    setTextFont(o, "Console.ttf")
                    table.insert(whatWritten, letter)
                end
            end
        end
    end
end

function onPause()
    return Function_Stop
end

function sendAndReceive(send)
    if stringStartsWith(send, "HELP") then
        echo("Psych Engine CMD Helper:")
        echo("  CLEAR: Clears all text.")
        echo("  ECHO <PROMPT>: Basically repeats what you've requested")
        echo("  END: Exits Song in 1.5 seconds.")
        echo("  GITHUB: Redirects you to the GitHub repo with all my scripts.")
        echo("  GOTO: Goes thorugh of your needs.")
        echo("  PHONE: Bambi reference :bambimad:")
        echo("  TRANSPARENT: Sets black box transparent (50%)")
    elseif stringStartsWith(send, "CLEAR") then
        for i=1,textSpawn do
            removeLuaText("text"..i)
        end
        line = 0
    elseif stringStartsWith(send, "ECHO") then
        echo(string.sub(send, 6, #send))
    elseif stringStartsWith(send, "END") then
        echo("Goodbye")
        runTimer("exitSong", 1.5)
    elseif stringStartsWith(send, "GITHUB") then
        echo("Please star it if you like this already!")
        os.execute('start https://github.com/NAEL2XD/naels-psych-lua-scripts')
    elseif stringStartsWith(send, "GOTO") then
        if stringStartsWith(send, "GOTO SONG") then
            send = string.lower(string.sub(send, 11, #send))
            if #send == 0 then
                echo("[ERROR 1] Input has 0 characters given!", false, "FF0000")
            else
                if checkFileExists("songs/"..send) then
                    loadSong(send, "normal")
                else
                    echo('[ERROR 2] "'..send..'" does not exist!', false, "FF0000")
                end
            end
        else
            echo("Usage for GOTOs:")
            echo("  GOTO SONG <songname>: Goes to a song provided")
        end
    elseif stringStartsWith(send, "PHONE") then
        echo("I'M GONNA SMASH MY FUCKING PHONE!!!")
    elseif stringStartsWith(send, "TRANSPARENT") then
        setProperty("TCP.alpha", 0.33)
    else
        echo('"'..send..'" command was not found.', false, "FF0000")
    end
    if not stringStartsWith(send, "EXIT") then echo('> ', true) end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "exitSong" then exitSong(true) end
end

function echo(text, mustWrite, color)
    line = line + 1
    if color == nil then color = "FFFFFF" end
    if mustWrite then
        colon = #text
        canWrite = true
    end
    for i=1,#text do
        textSpawn = textSpawn + 1
        local o = "text"..textSpawn
        makeLuaText(o, string.sub(text, i, i), 1920, -15+(15*i), -22.5+(22.5*line))
        addLuaText(o)
        setTextSize(o, 28)
        setObjectCamera(o, "other")
        setTextAlignment(o, "left")
        setTextFont(o, "Console.ttf")
        setTextColor(o, color)
    end
end
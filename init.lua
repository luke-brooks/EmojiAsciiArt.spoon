--[[
--------------------------------------------------------
-- Instantiate Spoon
--------------------------------------------------------
]]
local emojiArt = {}
emojiArt.__index = emojiArt

--[[
--------------------------------------------------------
-- Spoon Metadata
--------------------------------------------------------
]]
emojiArt.name = 'Emoji ASCII Art'
emojiArt.version = '1.0'
emojiArt.author = 'Luke Brooks'
emojiArt.license = 'MIT'
emojiArt.homepage = 'https://github.com/luke-brooks/EmojiAsciiArt.spoon'
emojiArt.adaptedFrom = {
    author = 'Nick Ellsworth',
    homepage = 'http://nickmakes.website/slack-emoji-converter/'
}

--[[
--------------------------------------------------------
-- Object Properties & Constants
--------------------------------------------------------
]]

local DEBUG_MODE = false

--[[
--------------------------------------------------------
-- Emoji ASCII Art Converter Setup
--------------------------------------------------------
]]
local asciiMap = {}

-- supported alpha characters
asciiMap['a'] = {'0000', '1111', '1001', '1111', '1001', '1001', '0000'}
asciiMap['b'] = {'0000', '1111', '1001', '1110', '1001', '1111', '0000'}
asciiMap['c'] = {'0000', '0111', '1000', '1000', '1000', '0111', '0000'}
asciiMap['d'] = {'0000', '1110', '1001', '1001', '1001', '1110', '0000'}
asciiMap['e'] = {'0000', '1111', '1000', '1110', '1000', '1111', '0000'}
asciiMap['f'] = {'0000', '1111', '1000', '1110', '1000', '1000', '0000'}
asciiMap['g'] = {'0000', '1111', '1000', '1011', '1001', '1111', '0000'}
asciiMap['h'] = {'0000', '1001', '1001', '1111', '1001', '1001', '0000'}
asciiMap['i'] = {'000', '111', '010', '010', '010', '111', '000'}
asciiMap['j'] = {'0000', '0111', '0010', '0010', '1010', '0110', '0000'}
asciiMap['k'] = {'0000', '1001', '1010', '1100', '1010', '1001', '0000'}
asciiMap['l'] = {'000', '100', '100', '100', '100', '111', '000'}
asciiMap['m'] = {'00000', '10001', '11011', '10101', '10001', '10001', '00000'}
asciiMap['n'] = {'00000', '10001', '11001', '10101', '10011', '10001', '00000'}
asciiMap['o'] = {'0000', '0110', '1001', '1001', '1001', '0110', '0000'}
asciiMap['p'] = {'0000', '1110', '1001', '1110', '1000', '1000', '0000'}
asciiMap['q'] = {'00000', '01100', '10010', '10010', '10010', '01111', '00000'}
asciiMap['r'] = {'0000', '1110', '1001', '1110', '1010', '1001', '0000'}
asciiMap['s'] = {'0000', '0111', '1000', '0110', '0001', '1110', '0000'}
asciiMap['t'] = {'00000', '11111', '00100', '00100', '00100', '00100', '00000'}
asciiMap['u'] = {'00000', '10001', '10001', '10001', '10001', '01110', '00000'}
asciiMap['v'] = {'00000', '10001', '10001', '10001', '01010', '00100', '00000'}
asciiMap['w'] = {'0000000', '1000001', '1000001', '1001001', '1010101', '0100010', '0000000'}
asciiMap['x'] = {'00000', '10001', '01010', '00100', '01010', '10001', '00000'}
asciiMap['y'] = {'00000', '10001', '01010', '00100', '00100', '00100', '00000'}
asciiMap['z'] = {'00000', '11111', '00010', '00100', '01000', '11111', '00000'}

-- supported number characters
asciiMap['0'] = {'0000', '0110', '1001', '1001', '1001', '0110', '0000'} -- equivalent to 'O'
asciiMap['1'] = {'000', '010', '110', '010', '010', '111', '000'}
asciiMap['2'] = {'0000', '0110', '1001', '0010', '0100', '1111', '0000'}
asciiMap['3'] = {'000', '110', '001', '010', '001', '110', '000'}
asciiMap['4'] = {'0000', '1010', '1010', '1111', '0010', '0010', '0000'}
asciiMap['5'] = {'000', '111', '100', '111', '001', '111', '000'}
asciiMap['6'] = {'000', '111', '100', '111', '101', '111', '000'}
asciiMap['7'] = {'000', '111', '001', '001', '001', '001', '000'}
asciiMap['8'] = {'0000', '0110', '1001', '0110', '1001', '0110', '0000'}
asciiMap['9'] = {'000', '111', '101', '111', '001', '001', '000'}

-- other supported characters 
asciiMap[' '] = {'0', '0', '0', '0', '0', '0', '0'}
asciiMap['.'] = {'0', '0', '0', '0', '0', '1', '0'}
asciiMap['!'] = {'0', '1', '1', '1', '0', '1', '0'}
-- asciiMap[':'] = {'00', '11', '011', '00', '11', '11', '00'} -- nope
asciiMap["'"] = {'0', '1', '1', '0', '0', '0', '0'}
asciiMap['"'] = {'000', '101', '101', '000', '000', '000', '000'}
asciiMap['('] = {'00', '01', '10', '10', '10', '01', '00'}
asciiMap[')'] = {'00', '10', '01', '01', '01', '10', '00'}
asciiMap['-'] = {'000', '000', '000', '111', '000', '000', '000'}
asciiMap['+'] = {'000', '000', '010', '111', '010', '000', '000'}
-- asciiMap['?'] = {'0110', '1001', '0001', '0010', '0000', '0010', '0000'} -- this one scrapes the top of output but *shrug*
-- asciiMap['?'] = {'0000','0110', '1001', '0010', '0000', '0010', '0000'}

--[[
--------------------------------------------------------
-- Internal Functions
--------------------------------------------------------
]]
-- Pauses script execution
local clock = os.clock
local function _pause(n) -- 'n' in seconds, can be decimal for partial seconds
    local t0 = clock()
    while clock() - t0 <= n do
    end
end

-- Pirnts info via hs.print when debugging is enabled
local function _printInfo(msg)
    if (DEBUG_MODE == true) then
        hs.printf('Zoom.spoon: ' .. msg)
    end
end

-- Takes a given string and converts it to a table of characters
local function _splitStringToTable (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

-- The brains of our sophisticated emojification algorithm
local function _buildAsciiFromText(text)
    local result = ''
    if (not text) then
        return result
    end
    local spacedText = ' '
    for i = 1, #text do
        local character = text:sub(i, i)
        spacedText = spacedText .. character .. ' '
    end
    for characterLayer = 1, 7 do -- each character has 7 layers of ascii
        for characterOrdinal = 1, #spacedText do -- character's location in the 'spacedText' string
            local character = spacedText:sub(characterOrdinal, characterOrdinal) -- pick character from string using its ordinal
            if character == nil or character == '' then
                character = ' ' -- converts empty strings to usable asciiMap identifier
            end
            result = result .. asciiMap[character][characterLayer]
        end
        result = result .. '\n'
    end
    return result
end

-- Simple wrapper around the brains to hide the ugly gsub thingies from the controller level
local function _convertToEmojiArt(str, textFill, backgroundFill)
    local result = _buildAsciiFromText(str:lower()):gsub(1, textFill):gsub(0, backgroundFill)
    return result
end

--[[
--------------------------------------------------------
-- External API
--------------------------------------------------------
]]
function emojiArt:debug()
    DEBUG_MODE = true
end
function emojiArt:convertToAsciiArt()
    _printInfo("Commencing Emojification Process")
    _pause(.05) -- brief pause to allow unpress of trigger key

    hs.eventtap.keyStroke({'cmd'}, 'a') -- simulate 'select all' shortcut
    hs.eventtap.keyStroke({'cmd'}, 'c') -- simulate 'copy' shortcut

    local emojiPayload = hs.pasteboard.getContents()

    _printInfo("Converting text: " .. emojiPayload)

    -- payload will be in the format:
    -- 'message :text_fill_emoji: :bg_fill_emoji:'
    -- need to add string format validation

    hs.notify.new({
        title = 'Emoji ASCII Art',
        informativeText = emojiPayload
    }):send()

    local split = _splitStringToTable(emojiPayload) -- this currently doesnt allow spaces in the display text
    local slackText = _convertToEmojiArt(split[1], split[2], split[3])

    hs.pasteboard.setContents(slackText) -- set art payload for delivery
    hs.eventtap.keyStroke({'cmd'}, 'v') -- simulate 'paste' shortcut
    hs.pasteboard.setContents(emojiPayload) -- reset pasteboard contents to original input
end

--[[
--------------------------------------------------------
-- Spoon Delivery
--------------------------------------------------------
]]
return emojiArt

-- Made by Artheriax
-- Github: https://github.com/Artheriax/BNHaNA
-- Took inspiration from Gigantix: https://github.com/DavldMA/Gigantix/tree/main

local Banana = {}

-- Notation table for suffixes used in short notation
local NOTATION = require("LUA/NOTATION")

-- Base-90 character set (exactly 90 printable ASCII characters)
local CHARACTERS = {
    "0","1","2","3","4","5","6","7","8","9",
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "!","#","$","%","&","'","(",")","*","+",".","/",":",";","<","=",">","?","@","[","]","^","_","`","{","}","|","~"
}

local MAX_TIER = #NOTATION

-- Performance optimizations: caching built-in functions for faster access.
local math_floor    = math.floor
local math_abs      = math.abs
local math_log10    = math.log10
local string_rep    = string.rep
local string_format = string.format
local string_sub    = string.sub
local string_gsub   = string.gsub
local string_match  = string.match
local string_gmatch = string.gmatch
local table_concat  = table.concat
local table_insert  = table.insert
local table_create  = table.create or function(size) return {} end

local base = #CHARACTERS  -- Base-90 encoding

--------------------------------------------------------------------------------
-- Utility: normalizeNumber
-- Purpose: Normalize a number represented as blocks (groups of up to 3 digits) by 
--          calculating its overall magnitude (number of digits) and ensuring a consistent
--          structure for arithmetic operations.
--
-- Parameters:
--   num - table with the following keys:
--         blocks    : array of numbers (each block represents three digits, least-significant first)
--         sign      : (optional) sign of the number (1 for positive, -1 for negative; default is 1)
--         magnitude : (optional) pre-computed digit count; if not provided, it's computed.
--
-- Example:
--   Input: { sign = 1, blocks = {500, 1} } (which represents 1500)
--   Output: { sign = 1, blocks = {500, 1}, magnitude = 4 }   (since "1500" has 4 digits)
--------------------------------------------------------------------------------
function Banana.normalizeNumber(num)
    local blocks = num.blocks or {}
    local sign = num.sign or 1
    local magnitude = num.magnitude

    if not magnitude then
        local firstNonZero = nil
        for i = #blocks, 1, -1 do
            if blocks[i] ~= 0 then
                firstNonZero = i
                -- Use the sign of the most significant non-zero block
                sign = blocks[i] < 0 and -1 or 1
                break
            end
        end
        
        if not firstNonZero then
            magnitude = 1  -- Represents zero
        else
            magnitude = (firstNonZero - 1) * 3
            for i = firstNonZero, 1, -1 do
                local absVal = math_abs(blocks[i])
                if absVal > 0 then
                    magnitude = magnitude + math_floor(math_log10(absVal)) + 1
                    break
                end
            end
        end
    end

    return {
        sign = sign,
        blocks = blocks,
        magnitude = magnitude
    }
end

--------------------------------------------------------------------------------
-- Comparison: compare
-- Purpose: Compare two normalized numbers and determine their relational order.
--
-- Parameters:
--   a, b - normalized number tables (each with sign and blocks).
--
-- Returns:
--   1 if a > b,
--  -1 if a < b,
--   0 if they are equal.
--
-- Example:
--   a = { sign = 1, blocks = {5, 3} } which represents 3500
--   b = { sign = 1, blocks = {3, 7} } which represents 7300
--   compare(a,b) returns -1 because 3500 < 7300.
--------------------------------------------------------------------------------
function Banana.compare(a, b)
    if a.sign ~= b.sign then
        return a.sign > b.sign and 1 or -1
    end

    local lenA, lenB = #a.blocks, #b.blocks
    if lenA ~= lenB then
        return (lenA > lenB and 1 or -1) * a.sign
    end

    for i = lenA, 1, -1 do
        if a.blocks[i] ~= b.blocks[i] then
            return (a.blocks[i] > b.blocks[i] and 1 or -1) * a.sign
        end
    end

    return 0  -- They are equal.
end

--------------------------------------------------------------------------------
-- Arithmetic: add
-- Purpose: Add two normalized numbers together.
--
-- Parameters:
--   a, b - normalized number tables.
--
-- Returns:
--   A new normalized number representing the sum.
--
-- Example:
--   a = { sign = 1, blocks = {500} } representing 500
--   b = { sign = -1, blocks = {300} } representing -300
--   add(a,b) returns { sign = 1, blocks = {200} } representing 200.
--------------------------------------------------------------------------------
function Banana.add(a, b)
    -- If signs differ, perform subtraction instead.
    if a.sign ~= b.sign then
        -- Create a copy of b with flipped sign to avoid mutating the input.
        local bNeg = { sign = -b.sign, blocks = {} }
        for i = 1, #b.blocks do
            bNeg.blocks[i] = b.blocks[i]
        end
        return Banana.subtract(a, bNeg)
    end

    local result = {}
    local carry = 0
    local maxLen = math.max(#a.blocks, #b.blocks)

    for i = 1, maxLen do
        local sum = (a.blocks[i] or 0) + (b.blocks[i] or 0) + carry
        carry = math_floor(sum / 1000)
        result[i] = sum % 1000
    end

    if carry > 0 then
        result[maxLen + 1] = carry
    end

    return Banana.normalizeNumber({ sign = a.sign, blocks = result })
end

--------------------------------------------------------------------------------
-- Arithmetic: subtract
-- Purpose: Subtract one normalized number from another (a - b).
--
-- Parameters:
--   a, b - normalized number tables.
--
-- Returns:
--   A new normalized number representing the difference.
--
-- Example:
--   a = { sign = 1, blocks = {500} } (500)
--   b = { sign = 1, blocks = {300} } (300)
--   subtract(a, b) returns { sign = 1, blocks = {200} } (200)
--------------------------------------------------------------------------------
function Banana.subtract(a, b)
    if a.sign ~= b.sign then
        -- If signs differ, treat it as addition.
        local bNeg = { sign = -b.sign, blocks = {} }
        for i = 1, #b.blocks do
            bNeg.blocks[i] = b.blocks[i]
        end
        return Banana.add(a, bNeg)
    end

    local absCompare = Banana.compare(
        { sign = 1, blocks = a.blocks },
        { sign = 1, blocks = b.blocks }
    )

    if absCompare < 0 then
        -- If |a| < |b|, swap arguments and flip the sign of the result.
        local result = Banana.subtract(b, a)
        result.sign = -result.sign
        return result
    end

    local result = {}
    local borrow = 0

    for i = 1, #a.blocks do
        local aVal = a.blocks[i]
        local bVal = b.blocks[i] or 0
        local diff = aVal - bVal - borrow

        if diff < 0 then
            diff = diff + 1000
            borrow = 1
        else
            borrow = 0
        end

        result[i] = diff
    end

    return Banana.normalizeNumber({ sign = a.sign, blocks = result })
end

--------------------------------------------------------------------------------
-- Arithmetic: multiply
-- Purpose: Multiply two normalized numbers together.
--
-- Parameters:
--   a, b - normalized number tables (each with sign and blocks).
--
-- Returns:
--   A new normalized number representing the product.
--
-- Example:
--   a = { sign = 1, blocks = {500} }  -- representing 500
--   b = { sign = -1, blocks = {300} } -- representing -300
--   multiply(a, b) returns { sign = -1, blocks = {0, 150} } representing -150000.
--------------------------------------------------------------------------------
function Banana.multiply(a, b)
    local result = {}
    local aLen = #a.blocks
    local bLen = #b.blocks

    -- Multiply each block of a with each block of b.
    for i = 1, aLen do
        for j = 1, bLen do
            local index = i + j - 1
            result[index] = (result[index] or 0) + a.blocks[i] * b.blocks[j]
        end
    end

    -- Propagate carry across blocks.
    local carry = 0
    for k = 1, #result do
        local total = result[k] + carry
        result[k] = total % 1000
        carry = math_floor(total / 1000)
    end
    while carry > 0 do
        table_insert(result, carry % 1000)
        carry = math_floor(carry / 1000)
    end

    -- The resulting sign is the product of the signs.
    local sign = a.sign * b.sign

    -- Normalize the result to update magnitude and ensure consistency.
    return Banana.normalizeNumber({ sign = sign, blocks = result })
end

--------------------------------------------------------------------------------
-- Conversion: stringToNumber
-- Purpose: Convert a decimal string into a normalized number.
--          This also tracks the magnitude (number of digits) accurately.
--
-- Parameters:
--   str - string representing the decimal number (may include commas, spaces, or a decimal point).
--
-- Returns:
--   A normalized number table with sign, blocks, and magnitude.
--
-- Example:
--   Input: "1500000000000000"
--   Output: { sign = 1, blocks = {calculated blocks}, magnitude = 15 }
--------------------------------------------------------------------------------
function Banana.stringToNumber(str)
    str = string_gsub(str, "[%s,]", "")
    local sign = 1

    -- Handle negative sign
    if string_sub(str, 1, 1) == "-" then
        sign = -1
        str = string_sub(str, 2)
    end

    -- Split into whole and optional decimal parts
    local whole, decimal = str:match("^(%d*)%.?(%d*)")
    whole = whole or ""
    decimal = decimal or ""

    -- Combine the parts and remove leading zeros.
    local combined = whole .. decimal
    combined = string_gsub(combined, "^0+", "")
    if combined == "" then combined = "0" end

    -- Calculate the magnitude (number of digits)
    local magnitude = #combined + (#decimal > 0 and #decimal or 0) - 1

    -- Break the number into 3-digit blocks (least-significant first)
    local padded = combined:reverse()
    padded = padded .. string_rep("0", (3 - #padded % 3) % 3)

    local blocks = {}
    for i = 1, #padded, 3 do
        local chunk = string_sub(padded, i, i + 2):reverse()
        table_insert(blocks, tonumber(chunk))
    end

    return Banana.normalizeNumber({ sign = sign, blocks = blocks, magnitude = magnitude })
end

--[[
  Function: Banana.notationToString
  Purpose:  Convert a shorthand number notation into its full string representation.
            For example, "1.5K" becomes "1500", and "-2.3M" becomes "-2300000".
  Parameters:
    str - A shorthand notation string (e.g., "-1.5K").
  
  Returns:
    A string representing the full number in decimal notation.
    If the input format is not as expected or the suffix is unknown, returns the input unmodified.
--]]
function Banana.notationToString(str)
    -- Remove spaces and commas for easy parsing.
    str = str:gsub("[%s,]", "")
    
    -- Check for and extract an optional leading negative sign.
    local sign = ""
    if str:sub(1, 1) == "-" then
        sign = "-"
        str = str:sub(2)
    end
    
    -- Extract the numeric part (which can include a decimal point) and the suffix.
    local numberPart, suffix = str:match("^([%d%.]+)(%a+)$")
    if not numberPart or not suffix then
        -- If the pattern doesn't match, return the original string (with sign reattached).
        return sign .. str
    end

    -- Normalize the suffix to lower-case.
    suffix = suffix:lower()

    -- Find the index of the suffix in the NOTATION table.
    local index
    if NOTATION and type(NOTATION) == "table" then
        for i, s in ipairs(NOTATION) do
            -- Compare case-insensitively.
            if s:lower() == suffix then
                index = i
                break
            end
        end
    end

    -- If suffix not found in NOTATION, return the original string.
    if not index then
        return sign .. str
    end

    -- Each tier (index-1) represents a factor of 10^3 (i.e., three orders of magnitude).
    local exponent = (index - 1) * 3

    -- Separate the number part into integer and fractional components.
    local integerPart, fractionalPart = numberPart:match("^(%d*)%.?(%d*)$")
    fractionalPart = fractionalPart or ""
    
    -- Count the digits after the decimal.
    local fractionalDigits = #fractionalPart

    -- Calculate how many zeros must be appended or adjust decimal placement.
    local effectiveExponent = exponent - fractionalDigits

    -- Combine integer and fractional parts, removing leading zeros.
    local combined = (integerPart or "") .. fractionalPart
    combined = combined:gsub("^0+", "")
    if combined == "" then combined = "0" end

    if effectiveExponent < 0 then
        -- Handle negative effectiveExponent by inserting decimal point
        local totalDigits = #combined
        local decimalPosition = totalDigits + effectiveExponent

        if decimalPosition <= 0 then
            -- Case where we need leading zeros: e.g., "0.00123"
            combined = "0." .. string.rep("0", -decimalPosition) .. combined
        else
            -- Insert decimal point within the combined digits
            combined = combined:sub(1, decimalPosition) .. "." .. combined:sub(decimalPosition + 1)
        end

        -- Trim trailing zeros after decimal
        combined = combined:gsub("%.?0+$", "")
        if combined:sub(-1) == "." then
            combined = combined:sub(1, -2)
        end
    else
        -- Append zeros for positive effectiveExponent
        combined = combined .. string.rep("0", effectiveExponent)
    end

    -- Reattach the negative sign if necessary
    return sign .. combined
end

--------------------------------------------------------------------------------
-- Formatting Helper: getSuffix
-- Purpose: Return the appropriate suffix based on the number of blocks.
--
-- Parameters:
--   blockCount - number of blocks representing the magnitude tier.
--
-- Returns:
--   A string suffix from the NOTATION table.
--
-- Example:
--   If blockCount is 4 and NOTATION[5] is "T", then getSuffix(4) returns "T".
--------------------------------------------------------------------------------
local function getSuffix(blockCount)
    local tier = math.min(blockCount, MAX_TIER)
    return NOTATION[tier] or ""
end

--------------------------------------------------------------------------------
-- Formatting: formatNumber
-- Purpose: Format a normalized number into a string with a suffix,
--          using a tiered notation (each tier corresponds to 10^3).
--
-- Parameters:
--   num      - normalized number table.
--   decimals - number of decimal places to show.
--
-- Returns:
--   A formatted string.
--
-- Example:
--   For a number with magnitude 15 representing 1.5e15, this function could return "1.5Qa" 
--   if NOTATION[6] is "Qa".
--------------------------------------------------------------------------------
local function formatNumber(num, decimals)
    if #num.blocks == 0 or (num.blocks[1] == 0 and #num.blocks == 1) then
        return "0"
    end

    -- Calculate tier based on the magnitude.
    local tier = math.floor(num.magnitude / 3)
    tier = math.min(tier + 1, #NOTATION)  -- Adjust for 1-based index

    -- If the magnitude exceeds our notation definitions, handle overflow.
    if tier > #NOTATION then
        local overflowTier = #NOTATION
        local overflowValue = num.magnitude - (overflowTier - 1) * 3
        return string_format("%.1f%se+%d", 
            10^(overflowValue % 3), 
            NOTATION[overflowTier],
            math_floor(overflowValue / 3) * 3
        )
    end

    local suffix = NOTATION[tier]

    -- Calculate the displayed value starting with the most significant block.
    local value = num.blocks[#num.blocks] or 0
    if num.magnitude % 3 ~= 0 then
        value = value * 10^(3 - (num.magnitude % 3))
    end

    -- Incorporate a sub-block (if available) to show decimals.
    local subBlock = num.blocks[#num.blocks - 1] or 0
    value = value + subBlock / 1000
    if value >= 1000 and tier < #NOTATION then
        tier = tier + 1
        suffix = NOTATION[tier]
        value = value / 1000
    end

    local formatted = string_format("%." .. decimals .. "f", value)
    formatted = string_gsub(formatted, "%.?0+$", "")

    return (num.sign < 0 and "-" or "") .. formatted .. suffix
end

--------------------------------------------------------------------------------
-- Formatting: getShort
-- Purpose: Provides a concise representation of a number.
--
-- Example:
--   Given a normalized number for 1500, getShort returns something like "1.5K".
--------------------------------------------------------------------------------
function Banana.getShort(num)
    return formatNumber(num, 1)
end

--------------------------------------------------------------------------------
-- Formatting: getMedium
-- Purpose: Provides a medium-length representation of a number.
--
-- Example:
--   For 1500, getMedium might return "1.50K" (showing two decimals).
--------------------------------------------------------------------------------
function Banana.getMedium(num)
    return formatNumber(num, 2)
end

--------------------------------------------------------------------------------
-- Formatting: getDetailed
-- Purpose: Provides a detailed representation of a number including more decimal places.
--
-- Example:
--   For 1500, getDetailed might return "1.500K" (showing three decimals).
--------------------------------------------------------------------------------
function Banana.getDetailed(num)
    return formatNumber(num, 3)
end

--------------------------------------------------------------------------------
-- Base Conversion: encodeNumber
-- Purpose: Convert a decimal string into its Base-90 encoded representation.
--
-- Parameters:
--   value - string representing a decimal number.
--
-- Returns:
--   A string representing the encoded number in Base-90.
--
-- Example:
--   Input: "901"
--   Calculation: 901 = 10*90 + 1 
--   Output: "a1" (assuming "a" maps to 10 in the CHARACTERS array).
--------------------------------------------------------------------------------
function Banana.encodeNumber(value)
    local num = Banana.stringToNumber(value)
    if num.blocks[1] == 0 and #num.blocks == 1 then
        return "0"
    end

    local current = num.blocks
    local chars = {}

    while Banana.compare({ sign = 1, blocks = current }, { sign = 1, blocks = {0} }) > 0 do
        local remainder = 0
        local newBlocks = {}

        for i = #current, 1, -1 do
            local val = current[i] + remainder * 1000
            local quotient = math_floor(val / base)
            remainder = val % base

            if #newBlocks > 0 or quotient > 0 then
                table_insert(newBlocks, 1, quotient)
            end
        end

        table_insert(chars, 1, CHARACTERS[remainder + 1])
        current = newBlocks
    end

    return (num.sign < 0 and "-" or "") .. table_concat(chars)
end

function Banana.decodeNumber(encodedStr)
    if encodedStr == "0" then
        return "0"
    end

    local sign = 1
    local str = encodedStr
    if str:sub(1, 1) == "-" then
        sign = -1
        str = str:sub(2)
        if str == "" then
            return "0"
        end
    end

    local blocks = {0}

    for i = 1, #str do
        local c = str:sub(i, i)
        local charIndex
        for idx, ch in ipairs(CHARACTERS) do
            if ch == c then
                charIndex = idx
                break
            end
        end
        if not charIndex then
            error("Invalid character in encoded string: " .. c)
        end
        local value = charIndex - 1

        -- Multiply current blocks by 90
        local newBlocks = {}
        local carry = 0
        for j = 1, #blocks do
            local product = blocks[j] * 90 + carry
            carry = math_floor(product / 1000)
            newBlocks[j] = product % 1000
        end
        local len = #newBlocks
        while carry > 0 do
            len = len + 1
            newBlocks[len] = carry % 1000
            carry = math_floor(carry / 1000)
        end
        blocks = newBlocks

        -- Add value to the first block and handle carry
        if #blocks == 0 then
            blocks[1] = value
        else
            blocks[1] = blocks[1] + value
            carry = math_floor(blocks[1] / 1000)
            blocks[1] = blocks[1] % 1000
            local j = 2
            while carry > 0 and j <= #blocks do
                blocks[j] = blocks[j] + carry
                carry = math_floor(blocks[j] / 1000)
                blocks[j] = blocks[j] % 1000
                j = j + 1
            end
            if carry > 0 then
                blocks[j] = carry
            end
        end
    end

    -- Convert blocks to string
    local reversedBlocks = {}
    for i = #blocks, 1, -1 do
        table_insert(reversedBlocks, blocks[i])
    end

    local parts = {}
    for i, block in ipairs(reversedBlocks) do
        if i == 1 then
            table_insert(parts, string_format("%d", block))
        else
            table_insert(parts, string_format("%03d", block))
        end
    end

    local numberStr = table_concat(parts)
    numberStr = numberStr:gsub("^0+", "")
    if numberStr == "" then
        numberStr = "0"
    end

    if sign == -1 and numberStr ~= "0" then
        numberStr = "-" .. numberStr
    end

    return numberStr
end

--------------------------------------------------------------------------------
-- Setup: configureNotation
-- Purpose: Allow customization of the magnitude suffix notation.
--
-- Parameters:
--   newNotation - array of suffix strings to override the default notation.
--   suffixMap   - (optional) table to remap specific suffix positions.
--
-- Example:
--   Calling Banana.configureNotation({"", "K", "M"}, {[2]=6}) would set up the notation
--   so that the second suffix ("K") corresponds to a magnitude level of 6 instead of 3.
--------------------------------------------------------------------------------
function Banana.configureNotation(newNotation, suffixMap)
    NOTATION = newNotation or NOTATION
    MAX_TIER = #NOTATION

    -- Rebuild suffix lookup (useful for possible future extensions)
    local suffixLookup = {}
    for i, v in ipairs(NOTATION) do
        if v ~= "" then
            suffixLookup[v:lower()] = suffixMap and suffixMap[i] or (i - 1) * 3
        end
    end
end

--------------------------------------------------------------------------------
-- Comparison: IsGreater
-- Purpose: Check if the first number is greater than the second.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a > b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsGreater(a, b)
    return Banana.compare(a, b) == 1
end

--------------------------------------------------------------------------------
-- Comparison: IsLesser
-- Purpose: Check if the first number is less than the second.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a < b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsLesser(a, b)
    return Banana.compare(a, b) == -1
end

--------------------------------------------------------------------------------
-- Comparison: IsEqual
-- Purpose: Check if two numbers are equal.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a == b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsEqual(a, b)
    return Banana.compare(a, b) == 0
end

--------------------------------------------------------------------------------
-- Comparison: IsGreaterThanOrEqual
-- Purpose: Check if the first number is greater than or equal to the second.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a >= b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsGreaterThanOrEqual(a, b)
    return Banana.compare(a, b) >= 0
end

--------------------------------------------------------------------------------
-- Comparison: IsLesserThanOrEqual
-- Purpose: Check if the first number is less than or equal to the second.
-- Parameters:
--   a, b - normalized number tables.
-- Returns: true if a <= b, false otherwise.
--------------------------------------------------------------------------------
function Banana.IsLesserThanOrEqual(a, b)
    return Banana.compare(a, b) <= 0
end

return Banana
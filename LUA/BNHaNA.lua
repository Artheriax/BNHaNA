-- Made by Artheriax
-- Github: https://github.com/Artheriax/BNHaNA
-- Took inspiration from Gigantix: https://github.com/DavldMA/Gigantix/tree/main

local Banana = {}

-- Notation table for suffixes used in short notation
local NOTATION = require("LUA.NOTATION")

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

function Banana.toNumber(num)
	local str = Banana.toDecimalString(num)
	return tonumber(str) or 0
end

function Banana.toDecimalString(num)
	if #num.blocks == 0 then
		return "0"
	end

	local parts = {}
	for i = #num.blocks, 1, -1 do
		if i == #num.blocks then
			table_insert(parts, tostring(num.blocks[i]))
		else
			table_insert(parts, string_format("%03d", num.blocks[i]))
		end
	end

	local str = table_concat(parts)
	str = string_gsub(str, "^0+", "")
	if str == "" then
		return "0"
	end
	if num.sign < 0 and str ~= "0" then
		str = "-" .. str
	end
	return str
end

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
				break
			end
		end

		if not firstNonZero then
			magnitude = 1  -- Represents zero
		else
			magnitude = (firstNonZero - 1) * 3
			local absVal = math_abs(blocks[firstNonZero])
			magnitude = magnitude + math_floor(math_log10(absVal)) + 1
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
	if a.sign ~= b.sign then
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

	for i = 1, aLen do
		for j = 1, bLen do
			local index = i + j - 1
			result[index] = (result[index] or 0) + a.blocks[i] * b.blocks[j]
		end
	end

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

	local sign = a.sign * b.sign
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

	if string_sub(str, 1, 1) == "-" then
		sign = -1
		str = string_sub(str, 2)
	end

	local whole, decimal = str:match("^(%d*)%.?(%d*)")
	whole = whole or ""
	decimal = decimal or ""

	local combined = whole .. decimal
	combined = string_gsub(combined, "^0+", "")
	if combined == "" then
		return Banana.normalizeNumber({ sign = 1, blocks = {0} })
	end

	local padded = combined:reverse()
	padded = padded .. string_rep("0", (3 - #padded % 3) % 3)

	local blocks = {}
	for i = 1, #padded, 3 do
		local chunk = string_sub(padded, i, i + 2):reverse()
		table_insert(blocks, tonumber(chunk))
	end

	return Banana.normalizeNumber({ sign = sign, blocks = blocks })
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
	str = str:gsub("[%s,]", "")
	local sign = ""
	if str:sub(1, 1) == "-" then
		sign = "-"
		str = str:sub(2)
		if str == "" then
			return "0"
		end
	end

	local numberPart, suffix = str:match("^([%d%.]+)(%a+)$")
	if not numberPart or not suffix then
		return sign .. str
	end

	suffix = suffix:lower()
	local index
	if NOTATION and type(NOTATION) == "table" then
		for i, s in ipairs(NOTATION) do
			if s:lower() == suffix then
				index = i
				break
			end
		end
	end

	if not index then
		return sign .. str
	end

	local exponent = (index - 1) * 3
	local integerPart, fractionalPart = numberPart:match("^(%d*)%.?(%d*)$")
	fractionalPart = fractionalPart or ""
	local fractionalDigits = #fractionalPart
	local effectiveExponent = exponent - fractionalDigits

	local combined = (integerPart or "") .. fractionalPart
	combined = combined:gsub("^0+", "")
	if combined == "" then
		return "0"
	end

	if effectiveExponent < 0 then
		local totalDigits = #combined
		local decimalPosition = totalDigits + effectiveExponent
		if decimalPosition <= 0 then
			combined = "0." .. string.rep("0", -decimalPosition) .. combined
		else
			combined = combined:sub(1, decimalPosition) .. "." .. combined:sub(decimalPosition + 1)
		end
		combined = combined:gsub("%.?0+$", "")
		if combined:sub(-1) == "." then
			combined = combined:sub(1, -2)
		end
	else
		combined = combined .. string.rep("0", effectiveExponent)
	end

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

	local tier = math.floor((num.magnitude - 1) / 3) + 1
	tier = math.min(tier, #NOTATION)

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
	local most = num.blocks[#num.blocks] or 0
	local next = #num.blocks >= 2 and num.blocks[#num.blocks-1] or 0
	local value = (most * 1000 + next) / 1000

	if value >= 1000 and tier < #NOTATION then
		tier = tier + 1
		suffix = NOTATION[tier]
		value = value / 1000
	end

	local formatted = string_format("%." .. decimals .. "f", value)
	formatted = string_gsub(formatted, "%.?0+$", "")
	formatted = string_gsub(formatted, "%.$", "")  -- Remove trailing decimal point

	return (num.sign < 0 and "-" or "") .. formatted .. (suffix or "")
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
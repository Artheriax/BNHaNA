-- Made by Artheriax (Enhanced)
-- Github: https://github.com/Artheriax/BNHaNA
-- Took inspiration from Gigantix: https://github.com/DavldMA/Gigantix/tree/main
-- Handles numbers up to 10^3003 with improved infinity handling

local Banana = {}

-- Notation table for suffixes used in short notation
local NOTATION = require('LUA.BNHaNA')

local POS_INF = { sign = 1, blocks = {}, magnitude = math.huge, isInf = true }
local NEG_INF = { sign = -1, blocks = {}, magnitude = math.huge, isInf = true }

-- Base-90 character set (exactly 90 printable ASCII characters)
local CHARACTERS = {
	"0","1","2","3","4","5","6","7","8","9",
	"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
	"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"!","#","$","%","&","'","(",")","*","+",".","/",":",";","<","=",">","?","@","[","]","^","_","`","{","}","|","~"
}

local MAX_TIER = #NOTATION
local MAX_SUPPORTED_MAGNITUDE = 3003 -- Maximum supported magnitude before infinity

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
	if num.isInf then
		return num.sign > 0 and "Infinity" or "-Infinity"
	end

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
--          structure for arithmetic operations. Now checks for infinity threshold.
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

	-- Remove leading zeros
	while #blocks > 1 and blocks[#blocks] == 0 do
		table.remove(blocks)
	end

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

	-- Check if magnitude exceeds maximum supported range
	if magnitude > MAX_SUPPORTED_MAGNITUDE then
		return sign > 0 and POS_INF or NEG_INF
	end

	return {
		sign = sign,
		blocks = blocks,
		magnitude = magnitude,
		isInf = false
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
	if a.isInf or b.isInf then
		if a.isInf and b.isInf then
			return a.sign == b.sign and 0 or (a.sign > b.sign and 1 or -1)
		end
		return a.isInf and (a.sign > 0 and 1 or -1) or (b.sign > 0 and -1 or 1)
	end

	if a.sign ~= b.sign then
		return a.sign > b.sign and 1 or -1
	end

	-- Compare magnitudes first for efficiency
	if a.magnitude ~= b.magnitude then
		return (a.magnitude > b.magnitude and 1 or -1) * a.sign
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
	if a.isInf or b.isInf then
		if a.isInf and b.isInf then
			if a.sign == b.sign then
				return a
			else
				error("Undefined: ∞ + -∞")
			end
		end
		return a.isInf and a or b
	end

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
	if a.isInf or b.isInf then
		if a.isInf and b.isInf then
			if a.sign == b.sign then
				error("Undefined: ∞ - ∞")
			else
				return a
			end
		end
		return a.isInf and a or { sign = -b.sign, blocks = {}, magnitude = math.huge, isInf = true }
	end

	if a.sign ~= b.sign then
		local bNeg = { sign = -b.sign, blocks = {} }
		for i = 1, #b.blocks do
			bNeg.blocks[i] = b.blocks[i]
		end
		return Banana.add(a, bNeg)
	end

	local absCompare = Banana.compare(
		{ sign = 1, blocks = a.blocks, magnitude = a.magnitude },
		{ sign = 1, blocks = b.blocks, magnitude = b.magnitude }
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
	if a.isInf or b.isInf then
		-- Check for 0 * infinity
		local aIsZero = not a.isInf and #a.blocks == 1 and a.blocks[1] == 0
		local bIsZero = not b.isInf and #b.blocks == 1 and b.blocks[1] == 0

		if aIsZero or bIsZero then
			error("Undefined: 0 * ∞")
		end

		local sign = a.sign * b.sign
		return sign > 0 and POS_INF or NEG_INF
	end

	-- Check for zero multiplication
	if (#a.blocks == 1 and a.blocks[1] == 0) or (#b.blocks == 1 and b.blocks[1] == 0) then
		return Banana.normalizeNumber({ sign = 1, blocks = {0} })
	end

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

function Banana.divide(a, b)
	-- Handle division by zero
	if #b.blocks == 1 and b.blocks[1] == 0 then
		error("Division by zero")
	end

	if b.isInf then
		return Banana.normalizeNumber({ sign = 1, blocks = {0} })
	end
	if a.isInf then
		local sign = a.sign * b.sign
		return sign > 0 and POS_INF or NEG_INF
	end

	-- Handle zero dividend
	if #a.blocks == 1 and a.blocks[1] == 0 then
		return Banana.normalizeNumber({ sign = 1, blocks = {0} })
	end

	local sign = a.sign * b.sign
	local absA = { sign = 1, blocks = a.blocks, magnitude = a.magnitude }
	local absB = { sign = 1, blocks = b.blocks, magnitude = b.magnitude }

	-- Fast path for |a| < |b|
	if Banana.IsLesser(absA, absB) then
		if sign == 1 then
			return Banana.normalizeNumber({ sign = 1, blocks = {0} })
		else
			if not Banana.IsEqual(a, Banana.normalizeNumber({ sign = 1, blocks = {0} })) then
				return Banana.normalizeNumber({ sign = -1, blocks = {1} }) -- -1
			else
				return Banana.normalizeNumber({ sign = 1, blocks = {0} })
			end
		end
	end

	-- Convert to most-significant-first order
	local A = {}
	for i = #absA.blocks, 1, -1 do
		table.insert(A, absA.blocks[i])
	end

	local R = Banana.normalizeNumber({ sign = 1, blocks = {0} }) -- Remainder
	local Q = {} -- Quotient digits (most-significant first)

	for i = 1, #A do
		-- Multiply remainder by 1000 and add next digit
		R = Banana.multiply(R, Banana.normalizeNumber({ sign = 1, blocks = {1000} }))
		R = Banana.add(R, Banana.normalizeNumber({ sign = 1, blocks = {A[i]} }))

		if Banana.IsGreaterThanOrEqual(R, absB) then
			-- Binary search for quotient digit (0-999)
			local low, high = 0, 999
			while low < high do
				local mid = math.floor((low + high + 1) / 2)
				local midBN = Banana.normalizeNumber({ sign = 1, blocks = {mid} })
				local test = Banana.multiply(absB, midBN)

				if Banana.IsGreater(test, R) then
					high = mid - 1
				else
					low = mid
				end
			end

			local q = low
			local qBN = Banana.normalizeNumber({ sign = 1, blocks = {q} })
			local product = Banana.multiply(absB, qBN)
			R = Banana.subtract(R, product)
			table.insert(Q, q)
		else
			table.insert(Q, 0)
		end
	end

	-- Convert to least-significant-first blocks
	local quotientBlocks = {}
	for i = #Q, 1, -1 do
		table.insert(quotientBlocks, Q[i])
	end

	-- Trim trailing zeros (most-significant end)
	while #quotientBlocks > 1 and quotientBlocks[#quotientBlocks] == 0 do
		table.remove(quotientBlocks)
	end

	local absQ = Banana.normalizeNumber({ sign = 1, blocks = quotientBlocks })

	-- Apply sign and adjust for negative division
	if sign == 1 then
		return absQ
	else
		if Banana.IsEqual(R, Banana.normalizeNumber({ sign = 1, blocks = {0} })) then
			return Banana.normalizeNumber({ sign = -1, blocks = absQ.blocks })
		else
			local one = Banana.normalizeNumber({ sign = 1, blocks = {1} })
			local qValue = Banana.add(absQ, one)
			qValue.sign = -1
			return qValue
		end
	end
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

	-- Handle infinity explicitly
	if str:lower() == "inf" or str:lower() == "infinity" then
		return sign > 0 and POS_INF or NEG_INF
	end

	-- Helper function to convert a digit string to normalized number
	local function digitsStringToNormalized(s, sgn)
		s = string_gsub(s, "^0+", "")
		if s == "" then
			return Banana.normalizeNumber({ sign = 1, blocks = {0} })
		end

		-- Check if the string length exceeds our maximum supported magnitude
		if #s > MAX_SUPPORTED_MAGNITUDE then
			return sgn > 0 and POS_INF or NEG_INF
		end

		local padded = s:reverse()
		padded = padded .. string_rep("0", (3 - #padded % 3) % 3)

		local blocks = {}
		for i = 1, #padded, 3 do
			local chunk = string_sub(padded, i, i + 2):reverse()
			table_insert(blocks, tonumber(chunk))
		end

		return Banana.normalizeNumber({ sign = sgn, blocks = blocks })
	end

	-- Check for scientific notation (e or E)
	local e_index = string.find(str, "[eE]")
	if e_index then
		local base_part = string_sub(str, 1, e_index - 1)
		local exp_part = string_sub(str, e_index + 1)

		-- Parse base part: whole and fractional digits
		local whole, fractional = base_part:match("^(%d*)%.?(%d*)$")
		whole = whole or ""
		fractional = fractional or ""
		local combined = whole .. fractional
		local fractional_digits = #fractional

		-- Parse exponent part
		local exponent_value = tonumber(exp_part)
		if not exponent_value then
			exponent_value = 0
		end

		local total_exponent = exponent_value - fractional_digits
		if total_exponent < 0 then
			error("BNHaNA: Negative total exponent in scientific notation is not supported for integers: " .. str)
		end

		-- Check if the resulting magnitude would exceed our limit
		local result_magnitude = #combined + total_exponent
		if result_magnitude > MAX_SUPPORTED_MAGNITUDE then
			return sign > 0 and POS_INF or NEG_INF
		end

		local total_str = combined .. string_rep('0', total_exponent)
		return digitsStringToNormalized(total_str, sign)
	else
		-- Non-scientific notation
		local whole, fractional = str:match("^(%d*)%.?(%d*)$")
		whole = whole or ""
		fractional = fractional or ""
		local combined = whole .. fractional
		return digitsStringToNormalized(combined, sign)
	end
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
--          Now returns "Infinity" when past the last available notation.
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
	if num.isInf then
		return num.sign > 0 and "Infinity" or "-Infinity"
	end

	if #num.blocks == 0 or (num.blocks[1] == 0 and #num.blocks == 1) then
		return "0"
	end

	local tier = math.floor((num.magnitude - 1) / 3) + 1

	-- If tier exceeds available notation, return infinity
	if tier > #NOTATION then
		return num.sign > 0 and "Infinity" or "-Infinity"
	end

	local suffix = NOTATION[tier]
	local most = num.blocks[#num.blocks] or 0
	local next = #num.blocks >= 2 and num.blocks[#num.blocks-1] or 0
	local value = (most * 1000 + next) / 1000

	if value >= 1000 and tier < #NOTATION then
		tier = tier + 1
		suffix = NOTATION[tier]
		value = value / 1000

		-- Check again if we've exceeded notation
		if tier > #NOTATION then
			return num.sign > 0 and "Infinity" or "-Infinity"
		end
	end

	local formatted = string_format("%." .. decimals .. "f", value)
	formatted = string_gsub(formatted, "%.?0+$", "")
	formatted = string_gsub(formatted, "%.$", "")  -- Remove trailing decimal point

	return (num.sign < 0 and "-" or "") .. formatted .. (suffix or "")
end

--------------------------------------------------------------------------------
-- Formatting: getScientific
-- Purpose: Returns extremely large numbers in scientific notation format (e.g., "1e+3003")
--
-- Parameters:
--   num - normalized number table
--
-- Returns:
--   A string in scientific notation format
--
-- Example:
--   For a number with magnitude 3003, returns "1e+3003"
--------------------------------------------------------------------------------
function Banana.getScientific(num)
	if num.isInf then
		return num.sign > 0 and "Infinity" or "-Infinity"
	end

	if #num.blocks == 0 or (num.blocks[1] == 0 and #num.blocks == 1) then
		return "0"
	end

	local magnitude = num.magnitude
	local mostSignificantBlock = num.blocks[#num.blocks] or 0
	local nextBlock = #num.blocks >= 2 and num.blocks[#num.blocks-1] or 0

	-- Calculate the leading digits
	local leadingValue = mostSignificantBlock
	if nextBlock > 0 then
		leadingValue = leadingValue + nextBlock / 1000
	end

	-- Adjust for the actual position of the leading digit
	local leadingDigits = math_floor(math_log10(mostSignificantBlock)) + 1
	local exponent = magnitude - 1

	-- Format the mantissa
	local mantissa = leadingValue / (10 ^ (leadingDigits - 1))

	-- Format the result
	local sign = num.sign < 0 and "-" or ""
	local formatted = string_format("%.3f", mantissa)
	formatted = string_gsub(formatted, "%.?0+$", "")
	formatted = string_gsub(formatted, "%.$", "")

	if exponent == 0 then
		return sign .. formatted
	else
		return sign .. formatted .. "e" .. (exponent >= 0 and "+" or "") .. tostring(exponent)
	end
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
-- Optimized encodeNumber function
function Banana.encodeNumber(value)
	local num = Banana.stringToNumber(value)

	-- Handle special cases
	if num.isInf then
		return num.sign > 0 and "∞" or "-∞"
	end

	if #num.blocks == 0 or (num.blocks[1] == 0 and #num.blocks == 1) then
		return "0"
	end

	-- Pre-allocate result table for better performance
	local chars = table_create(math.ceil(num.magnitude * 0.7)) -- Rough estimate
	local current = {}

	-- Copy blocks to avoid modifying original
	for i = 1, #num.blocks do
		current[i] = num.blocks[i]
	end

	-- Optimized division by base using cached calculations
	local base_cache = {}
	for i = 0, 999 do
		base_cache[i] = { quotient = math_floor(i / base), remainder = i % base }
	end

	while #current > 0 and not (current[1] == 0 and #current == 1) do
		local remainder = 0
		local newBlocks = {}
		local hasNonZero = false

		-- Process from most significant to least significant
		for i = #current, 1, -1 do
			local val = current[i] + remainder * 1000
			local quotient, new_remainder

			if val < 1000 and base_cache[val] then
				-- Use cached division for small values
				quotient = base_cache[val].quotient
				new_remainder = base_cache[val].remainder
			else
				quotient = math_floor(val / base)
				new_remainder = val % base
			end

			remainder = new_remainder

			if quotient > 0 or hasNonZero then
				newBlocks[#newBlocks + 1] = quotient
				hasNonZero = true
			end
		end

		-- Reverse newBlocks to maintain correct order
		local temp = {}
		for i = #newBlocks, 1, -1 do
			temp[#temp + 1] = newBlocks[i]
		end

		chars[#chars + 1] = CHARACTERS[remainder + 1]
		current = temp
	end

	-- Reverse chars to get correct order
	local result = {}
	for i = #chars, 1, -1 do
		result[#result + 1] = chars[i]
	end

	return (num.sign < 0 and "-" or "") .. table_concat(result)
end

-- Optimized decodeNumber function
function Banana.decodeNumber(encodedStr)
	if encodedStr == "0" then
		return "0"
	end

	-- Handle infinity
	if encodedStr == "∞" then
		return "Infinity"
	elseif encodedStr == "-∞" then
		return "-Infinity"
	end

	local sign = 1
	local str = encodedStr
	if string_sub(str, 1, 1) == "-" then
		sign = -1
		str = string_sub(str, 2)
		if str == "" then
			return "0"
		end
	end

	-- Pre-compute character lookup table for O(1) access
	local char_lookup = {}
	for idx, ch in ipairs(CHARACTERS) do
		char_lookup[ch] = idx - 1
	end

	local blocks = {0}
	local str_len = #str

	for i = 1, str_len do
		local c = string_sub(str, i, i)
		local value = char_lookup[c]
		if not value then
			error("Invalid character in encoded string: " .. c)
		end

		-- Multiply existing blocks by base
		local carry = 0
		for j = 1, #blocks do
			local product = blocks[j] * base + carry
			blocks[j] = product % 1000
			carry = math_floor(product / 1000)
		end

		-- Add remaining carry
		while carry > 0 do
			blocks[#blocks + 1] = carry % 1000
			carry = math_floor(carry / 1000)
		end

		-- Add the current digit value
		carry = value
		local j = 1
		while carry > 0 and j <= #blocks do
			local sum = blocks[j] + carry
			blocks[j] = sum % 1000
			carry = math_floor(sum / 1000)
			j = j + 1
		end
		if carry > 0 then
			blocks[j] = carry
		end
	end

	-- Convert blocks to string representation
	local parts = table_create(#blocks)
	for i = #blocks, 1, -1 do
		if i == #blocks then
			parts[#parts + 1] = tostring(blocks[i])
		else
			parts[#parts + 1] = string_format("%03d", blocks[i])
		end
	end

	local numberStr = table_concat(parts)
	numberStr = string_gsub(numberStr, "^0+", "")
	if numberStr == "" then
		numberStr = "0"
	end

	return sign == -1 and numberStr ~= "0" and "-" .. numberStr or numberStr
end

-- Optimized power function for integer exponents
function Banana.power(base, exponent)
	local baseNum = type(base) == "string" and Banana.stringToNumber(base) or base
	local expNum = type(exponent) == "string" and Banana.stringToNumber(exponent) or exponent

	-- Handle special cases
	if baseNum.isInf then
		if expNum.isInf then
			error("Undefined: ∞^∞")
		end
		local isExpZero = #expNum.blocks == 1 and expNum.blocks[1] == 0
		if isExpZero then
			error("Undefined: ∞^0")
		end
		return expNum.sign > 0 and baseNum or Banana.normalizeNumber({ sign = 1, blocks = {0} })
	end

	if expNum.isInf then
		local isBaseZero = #baseNum.blocks == 1 and baseNum.blocks[1] == 0
		local isBaseOne = #baseNum.blocks == 1 and baseNum.blocks[1] == 1 and baseNum.sign == 1

		if isBaseZero then
			return expNum.sign > 0 and baseNum or POS_INF
		elseif isBaseOne then
			error("Undefined: 1^∞")
		else
			return expNum.sign > 0 and POS_INF or Banana.normalizeNumber({ sign = 1, blocks = {0} })
		end
	end

	-- Handle zero exponent
	if #expNum.blocks == 1 and expNum.blocks[1] == 0 then
		return Banana.normalizeNumber({ sign = 1, blocks = {1} })
	end

	-- Handle zero base
	if #baseNum.blocks == 1 and baseNum.blocks[1] == 0 then
		return expNum.sign > 0 and baseNum or error("Division by zero in 0^(-n)")
	end

	-- Handle negative exponent (not supported for integers)
	if expNum.sign < 0 then
		error("Negative exponents not supported for integer arithmetic")
	end

	-- Convert exponent to regular number for iteration
	local exp_str = Banana.toDecimalString(expNum)
	local exp_val = tonumber(exp_str)

	-- For very large exponents, return infinity
	if not exp_val or exp_val > 10000 then
		return POS_INF
	end

	-- Fast exponentiation by squaring
	local result = Banana.normalizeNumber({ sign = 1, blocks = {1} })
	local current_base = baseNum

	while exp_val > 0 do
		if exp_val % 2 == 1 then
			result = Banana.multiply(result, current_base)
			if result.isInf then
				return result
			end
		end
		current_base = Banana.multiply(current_base, current_base)
		if current_base.isInf then
			return current_base
		end
		exp_val = math_floor(exp_val / 2)
	end

	return result
end

-- Optimized modulo function
function Banana.modulo(a, b)
	if b.isInf then
		return a.isInf and error("Undefined: ∞ mod ∞") or a
	end
	if a.isInf then
		error("Undefined: ∞ mod finite")
	end

	-- Handle zero divisor
	if #b.blocks == 1 and b.blocks[1] == 0 then
		error("Modulo by zero")
	end

	-- Handle zero dividend
	if #a.blocks == 1 and a.blocks[1] == 0 then
		return a
	end

	local quotient = Banana.divide(a, b)
	local product = Banana.multiply(quotient, b)
	return Banana.subtract(a, product)
end

-- Optimized absolute value function
function Banana.abs(num)
	if num.isInf then
		return { sign = 1, blocks = {}, magnitude = math.huge, isInf = true }
	end

	if num.sign >= 0 then
		return num
	end

	return {
		sign = 1,
		blocks = num.blocks,
		magnitude = num.magnitude,
		isInf = false
	}
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

-- Optimized square root function (integer square root)
function Banana.sqrt(num)
	if num.isInf then
		return num.sign > 0 and num or error("Square root of negative infinity")
	end

	if num.sign < 0 then
		error("Square root of negative number")
	end

	if #num.blocks == 1 and num.blocks[1] == 0 then
		return num
	end

	-- Newton's method for integer square root
	local x = num
	local one = Banana.normalizeNumber({ sign = 1, blocks = {1} })
	local two = Banana.normalizeNumber({ sign = 1, blocks = {2} })

	-- Initial guess - use magnitude to get closer
	local guess_magnitude = math.ceil(num.magnitude / 2)
	local initial_guess = Banana.normalizeNumber({ 
		sign = 1, 
		blocks = {1, 0, 0} -- Start with 1000 and adjust
	})

	-- Adjust initial guess based on magnitude
	for i = 4, guess_magnitude do
		initial_guess.blocks[i] = 0
	end
	initial_guess.blocks[guess_magnitude] = 1
	initial_guess = Banana.normalizeNumber(initial_guess)

	x = initial_guess

	for i = 1, 100 do -- Limit iterations
		local quotient = Banana.divide(num, x)
		local sum = Banana.add(x, quotient)
		local new_x = Banana.divide(sum, two)

		if Banana.IsEqual(new_x, x) then
			break
		end

		x = new_x
	end

	return x
end

-- Optimized factorial function (with overflow protection)
function Banana.factorial(num)
	if num.isInf then
		return POS_INF
	end

	if num.sign < 0 then
		error("Factorial of negative number")
	end

	local n_str = Banana.toDecimalString(num)
	local n = tonumber(n_str)

	if not n or n > 1000 then -- Prevent excessive computation
		return POS_INF
	end

	if n == 0 or n == 1 then
		return Banana.normalizeNumber({ sign = 1, blocks = {1} })
	end

	local result = Banana.normalizeNumber({ sign = 1, blocks = {1} })
	local current = Banana.normalizeNumber({ sign = 1, blocks = {2} })

	for i = 2, n do
		result = Banana.multiply(result, current)
		if result.isInf then
			return result
		end
		current = Banana.add(current, Banana.normalizeNumber({ sign = 1, blocks = {1} }))
	end

	return result
end

-- Optimized GCD function using Euclidean algorithm
function Banana.gcd(a, b)
	local absA = Banana.abs(a)
	local absB = Banana.abs(b)

	while not (absB.isInf or (#absB.blocks == 1 and absB.blocks[1] == 0)) do
		local temp = absB
		absB = Banana.modulo(absA, absB)
		absA = temp
	end

	return absA
end

-- Optimized LCM function
function Banana.lcm(a, b)
	local gcd_val = Banana.gcd(a, b)
	local product = Banana.multiply(Banana.abs(a), Banana.abs(b))
	return Banana.divide(product, gcd_val)
end

-- Optimized string validation
function Banana.isValidNumber(str)
	if type(str) ~= "string" then
		return false
	end

	-- Remove whitespace and commas
	str = string_gsub(str, "[%s,]", "")

	-- Check for empty string
	if str == "" then
		return false
	end

	-- Check for infinity
	if str:lower() == "inf" or str:lower() == "infinity" or str == "∞" then
		return true
	end

	-- Handle negative sign
	if string_sub(str, 1, 1) == "-" then
		str = string_sub(str, 2)
		if str == "" then
			return false
		end
	end

	-- Check for scientific notation
	local e_index = string.find(str, "[eE]")
	if e_index then
		local base_part = string_sub(str, 1, e_index - 1)
		local exp_part = string_sub(str, e_index + 1)

		-- Validate base part
		if not string_match(base_part, "^%d*%.?%d*$") or base_part == "" or base_part == "." then
			return false
		end

		-- Validate exponent part
		local exp_sign = string_sub(exp_part, 1, 1)
		if exp_sign == "+" or exp_sign == "-" then
			exp_part = string_sub(exp_part, 2)
		end

		return string_match(exp_part, "^%d+$") ~= nil
	else
		-- Regular decimal notation
		return string_match(str, "^%d*%.?%d*$") ~= nil and str ~= "" and str ~= "."
	end
end

-- Batch operations for better performance
function Banana.batchAdd(numbers)
	if not numbers or #numbers == 0 then
		return Banana.normalizeNumber({ sign = 1, blocks = {0} })
	end

	local result = numbers[1]
	for i = 2, #numbers do
		result = Banana.add(result, numbers[i])
		if result.isInf then
			return result
		end
	end

	return result
end

function Banana.batchMultiply(numbers)
	if not numbers or #numbers == 0 then
		return Banana.normalizeNumber({ sign = 1, blocks = {1} })
	end

	local result = numbers[1]
	for i = 2, #numbers do
		result = Banana.multiply(result, numbers[i])
		if result.isInf then
			return result
		end
	end

	return result
end

return Banana
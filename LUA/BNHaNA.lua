-- Made by Artheriax
-- Github: https://github.com/Artheriax/BNHaNA
-- Took inspiration from Gigantix: https://github.com/DavldMA/Gigantix/tree/main
-- Handles numbers up to 10^3003 with infinity handling

local Banana = {}

-- Notation table for suffixes used in short notation
local NOTATION = require("LUA.NOTATION")

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

-- Performance optimizations
local math_floor    = math.floor
local math_abs      = math.abs
local math_log10    = math.log10
local string_rep    = string.rep
local string_format = string.format
local string_sub    = string.sub
local string_gsub   = string.gsub
local string_match  = string.match
local table_concat  = table.concat
local table_insert  = table.insert
local table_create  = table.create or function(size) return {} end

local base = #CHARACTERS

--- Converts a Banana number to a standard Lua number.
--- Warning: Precision may be lost for values > 10^308 (Lua double limit).
--- @param num table The Banana number object.
--- @return number The Lua number representation.
function Banana.toNumber(num)
	local str = Banana.toDecimalString(num)
	return tonumber(str) or 0
end

--- Converts a Banana number to a plain decimal string.
--- @param num table The Banana number object.
--- @return string The decimal string (e.g., "1500").
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

--- Internal utility to clean up blocks, recalculate magnitude, and check infinity thresholds.
--- @param num table A raw number table containing blocks and sign.
--- @return table A normalized Banana number object.
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
			magnitude = 1
		else
			magnitude = (firstNonZero - 1) * 3
			local absVal = math_abs(blocks[firstNonZero])
			magnitude = magnitude + math_floor(math_log10(absVal)) + 1
		end
	end

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

--- Compares two Banana numbers.
--- @param a table The first number.
--- @param b table The second number.
--- @return number 1 if a > b, -1 if a < b, 0 if a == b.
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

	return 0
end

--- Adds two Banana numbers.
--- @param a table The first number.
--- @param b table The second number.
--- @return table A new Banana number representing the sum.
function Banana.add(a, b)
	if a.isInf or b.isInf then
		if a.isInf and b.isInf then
			if a.sign == b.sign then return a else error("Undefined: ∞ + -∞") end
		end
		return a.isInf and a or b
	end

	if a.sign ~= b.sign then
		-- FIX: Copy magnitude to avoid nil error in compare()
		local bNeg = { sign = -b.sign, blocks = {}, magnitude = b.magnitude }
		for i = 1, #b.blocks do bNeg.blocks[i] = b.blocks[i] end
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

--- Subtracts number b from number a.
--- @param a table The minuend.
--- @param b table The subtrahend.
--- @return table A new Banana number representing the difference.
function Banana.subtract(a, b)
	if a.isInf or b.isInf then
		if a.isInf and b.isInf then
			if a.sign == b.sign then error("Undefined: ∞ - ∞") else return a end
		end
		return a.isInf and a or { sign = -b.sign, blocks = {}, magnitude = math.huge, isInf = true }
	end

	if a.sign ~= b.sign then
		local bNeg = { sign = -b.sign, blocks = {}, magnitude = b.magnitude }
		for i = 1, #b.blocks do bNeg.blocks[i] = b.blocks[i] end
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

--- Multiplies two Banana numbers.
--- @param a table The first number.
--- @param b table The second number.
--- @return table A new Banana number representing the product.
function Banana.multiply(a, b)
	if a.isInf or b.isInf then
		local aIsZero = not a.isInf and #a.blocks == 1 and a.blocks[1] == 0
		local bIsZero = not b.isInf and #b.blocks == 1 and b.blocks[1] == 0
		if aIsZero or bIsZero then error("Undefined: 0 * ∞") end
		local sign = a.sign * b.sign
		return sign > 0 and POS_INF or NEG_INF
	end

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

--- Performs integer division of a by b.
--- @param a table The dividend.
--- @param b table The divisor.
--- @return table The quotient (integer).
function Banana.divide(a, b)
	if #b.blocks == 1 and b.blocks[1] == 0 then error("Division by zero") end
	if b.isInf then return Banana.normalizeNumber({ sign = 1, blocks = {0} }) end
	if a.isInf then
		local sign = a.sign * b.sign
		return sign > 0 and POS_INF or NEG_INF
	end

	if #a.blocks == 1 and a.blocks[1] == 0 then
		return Banana.normalizeNumber({ sign = 1, blocks = {0} })
	end

	local sign = a.sign * b.sign
	local absA = { sign = 1, blocks = a.blocks, magnitude = a.magnitude }
	local absB = { sign = 1, blocks = b.blocks, magnitude = b.magnitude }

	if Banana.isLesser(absA, absB) then
		if sign == 1 then
			return Banana.normalizeNumber({ sign = 1, blocks = {0} })
		else
			if not Banana.isEqual(a, Banana.normalizeNumber({ sign = 1, blocks = {0} })) then
				return Banana.normalizeNumber({ sign = -1, blocks = {1} })
			else
				return Banana.normalizeNumber({ sign = 1, blocks = {0} })
			end
		end
	end

	local A = {}
	for i = #absA.blocks, 1, -1 do table.insert(A, absA.blocks[i]) end
	local R = Banana.normalizeNumber({ sign = 1, blocks = {0} })
	local Q = {}

	for i = 1, #A do
		R = Banana.multiply(R, Banana.normalizeNumber({ sign = 1, blocks = {1000} }))
		R = Banana.add(R, Banana.normalizeNumber({ sign = 1, blocks = {A[i]} }))

		if Banana.isGreaterThanOrEqual(R, absB) then
			local low, high = 0, 999
			while low < high do
				local mid = math.floor((low + high + 1) / 2)
				local midBN = Banana.normalizeNumber({ sign = 1, blocks = {mid} })
				local test = Banana.multiply(absB, midBN)
				if Banana.isGreater(test, R) then high = mid - 1 else low = mid end
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

	local quotientBlocks = {}
	for i = #Q, 1, -1 do table.insert(quotientBlocks, Q[i]) end
	while #quotientBlocks > 1 and quotientBlocks[#quotientBlocks] == 0 do
		table.remove(quotientBlocks)
	end
	local absQ = Banana.normalizeNumber({ sign = 1, blocks = quotientBlocks })

	if sign == 1 then
		return absQ
	else
		if Banana.isEqual(R, Banana.normalizeNumber({ sign = 1, blocks = {0} })) then
			return Banana.normalizeNumber({ sign = -1, blocks = absQ.blocks })
		else
			local one = Banana.normalizeNumber({ sign = 1, blocks = {1} })
			local qValue = Banana.add(absQ, one)
			qValue.sign = -1
			return qValue
		end
	end
end

--- Converts a decimal string (or scientific notation string) into a Banana number.
--- Note: Decimal inputs are floored to integers (e.g. "1.5" becomes 1).
--- @param str string The input string (e.g., "1.5e3", "123").
--- @return table The Banana number.
function Banana.stringToNumber(str)
	str = string_gsub(str, "[%s,]", "")
	local sign = 1

	if string_sub(str, 1, 1) == "-" then
		sign = -1
		str = string_sub(str, 2)
	end

	if str:lower() == "inf" or str:lower() == "infinity" then
		return sign > 0 and POS_INF or NEG_INF
	end

	local function digitsStringToNormalized(s, sgn)
		s = string_gsub(s, "^0+", "")
		if s == "" then return Banana.normalizeNumber({ sign = 1, blocks = {0} }) end
		if #s > MAX_SUPPORTED_MAGNITUDE then return sgn > 0 and POS_INF or NEG_INF end

		local padded = s:reverse()
		padded = padded .. string_rep("0", (3 - #padded % 3) % 3)
		local blocks = {}
		for i = 1, #padded, 3 do
			local chunk = string_sub(padded, i, i + 2):reverse()
			table_insert(blocks, tonumber(chunk))
		end
		return Banana.normalizeNumber({ sign = sgn, blocks = blocks })
	end

	local e_index = string.find(str, "[eE]")
	if e_index then
		local base_part = string_sub(str, 1, e_index - 1)
		local exp_part = string_sub(str, e_index + 1)
		local whole, fractional = base_part:match("^(%d*)%.?(%d*)$")
		whole = whole or ""; fractional = fractional or ""
		local combined = whole .. fractional
		local fractional_digits = #fractional

		local exponent_value = tonumber(exp_part) or 0
		local total_exponent = exponent_value - fractional_digits

		if total_exponent < 0 then
			local trim_amount = -total_exponent
			if trim_amount >= #combined then
				return Banana.normalizeNumber({ sign = 1, blocks = {0} })
			end
			local total_str = combined:sub(1, #combined - trim_amount)
			return digitsStringToNormalized(total_str, sign)
		end

		local result_magnitude = #combined + total_exponent
		if result_magnitude > MAX_SUPPORTED_MAGNITUDE then
			return sign > 0 and POS_INF or NEG_INF
		end

		local total_str = combined .. string_rep('0', total_exponent)
		return digitsStringToNormalized(total_str, sign)
	else
		-- Non-scientific notation
		local whole = str:match("^(%d*)%.?%d*$")
		whole = whole or ""
		return digitsStringToNormalized(whole, sign)
	end
end

--- Expands a shorthand notation string (e.g., "1.5K") into a full decimal string (e.g., "1500").
--- If no suffix is found, strips decimal points (integer floor behavior).
--- @param str string The shorthand string.
--- @return string The full decimal string.
function Banana.notationToString(str)
	str = str:gsub("[%s,]", "")
	local sign = ""
	if str:sub(1, 1) == "-" then
		sign = "-"
		str = str:sub(2)
		if str == "" then return "0" end
	end

	local numberPart, suffix = str:match("^([%d%.]+)(%a+)$")
	
	if not numberPart or not suffix then
		return sign .. str:gsub("%.", "")
	end

	suffix = suffix:lower()
	local index
	if NOTATION and type(NOTATION) == "table" then
		for i, s in ipairs(NOTATION) do
			if s:lower() == suffix then index = i; break end
		end
	end

	if not index then return sign .. str:gsub("%.", "") end

	local exponent = (index - 1) * 3
	local integerPart, fractionalPart = numberPart:match("^(%d*)%.?(%d*)$")
	fractionalPart = fractionalPart or ""
	local effectiveExponent = exponent - #fractionalPart
	local combined = (integerPart or "") .. fractionalPart
	combined = combined:gsub("^0+", "")
	if combined == "" then return "0" end

	if effectiveExponent < 0 then
		local decimalPosition = #combined + effectiveExponent
		if decimalPosition <= 0 then
			combined = "0." .. string.rep("0", -decimalPosition) .. combined
		else
			combined = combined:sub(1, decimalPosition) .. "." .. combined:sub(decimalPosition + 1)
		end
		combined = combined:gsub("%.?0+$", "")
		if combined:sub(-1) == "." then combined = combined:sub(1, -2) end
	else
		combined = combined .. string.rep("0", effectiveExponent)
	end

	return sign .. combined
end

--- Formats a number with a specific suffix tier. (Internal)
--- @param num table The number to format.
--- @param decimals number The number of decimal places.
--- @return string The formatted string (e.g., "1.50K").
local function formatNumber(num, decimals)
	if num.isInf then return num.sign > 0 and "Infinity" or "-Infinity" end
	if #num.blocks == 0 or (num.blocks[1] == 0 and #num.blocks == 1) then return "0" end

	local tier = math.floor((num.magnitude - 1) / 3) + 1
	if tier > #NOTATION then return num.sign > 0 and "Infinity" or "-Infinity" end

	local most = num.blocks[#num.blocks] or 0
	local next = #num.blocks >= 2 and num.blocks[#num.blocks-1] or 0
	local afterNext = #num.blocks >= 3 and num.blocks[#num.blocks-2] or 0
	
	local value = most + (next / 1000) + (afterNext / 1000000)

	if value >= 1000 and tier < #NOTATION then
		tier = tier + 1
		value = value / 1000
		if tier > #NOTATION then return num.sign > 0 and "Infinity" or "-Infinity" end
	end

	local suffix = NOTATION[tier]
	local formatted = string_format("%." .. decimals .. "f", value)
	formatted = string_gsub(formatted, "%.?0+$", "")
	formatted = string_gsub(formatted, "%.$", "")

	return (num.sign < 0 and "-" or "") .. formatted .. (suffix or "")
end

--- Formats the number in scientific notation (e.g., "1.234e+50").
--- @param num table The Banana number.
--- @return string Scientific notation string.
function Banana.getScientific(num)
	if num.isInf then return num.sign > 0 and "Infinity" or "-Infinity" end
	if #num.blocks == 0 or (num.blocks[1] == 0 and #num.blocks == 1) then return "0" end

	local magnitude = num.magnitude
	local most = num.blocks[#num.blocks] or 0
	local next = #num.blocks >= 2 and num.blocks[#num.blocks-1] or 0
	local leadingValue = most + (next / 1000)
	local leadingDigits = math_floor(math_log10(most)) + 1
	local exponent = magnitude - 1
	local mantissa = leadingValue / (10 ^ (leadingDigits - 1))
	local sign = num.sign < 0 and "-" or ""
	local formatted = string_format("%.3f", mantissa)
	formatted = string_gsub(formatted, "%.?0+$", "")
	formatted = string_gsub(formatted, "%.$", "")

	if exponent == 0 then return sign .. formatted else
		return sign .. formatted .. "e" .. (exponent >= 0 and "+" or "") .. tostring(exponent)
	end
end

--- Formats the number with 1 decimal place and a suffix (e.g. "1.5K").
function Banana.getShort(num) return formatNumber(num, 1) end

--- Formats the number with 2 decimal places and a suffix (e.g. "1.50K").
function Banana.getMedium(num) return formatNumber(num, 2) end

--- Formats the number with 3 decimal places and a suffix (e.g. "1.500K").
function Banana.getDetailed(num) return formatNumber(num, 3) end

--- Encodes a decimal string into a compact Base-90 string.
--- @param value string A string representing a decimal number.
--- @return string The encoded string.
function Banana.encodeNumber(value)
	local num = Banana.stringToNumber(value)
	if num.isInf then return num.sign > 0 and "∞" or "-∞" end
	if #num.blocks == 0 or (num.blocks[1] == 0 and #num.blocks == 1) then return "0" end

	local chars = table_create(math.ceil(num.magnitude * 0.7))
	local current = {}; for i=1,#num.blocks do current[i] = num.blocks[i] end
	local base_cache = {}; for i=0,999 do base_cache[i] = {q=math_floor(i/base), r=i%base} end

	while #current > 0 and not (current[1] == 0 and #current == 1) do
		local remainder = 0
		local newBlocks = {}
		local hasNonZero = false
		for i = #current, 1, -1 do
			local val = current[i] + remainder * 1000
			local q, r
			if val < 1000 and base_cache[val] then q=base_cache[val].q; r=base_cache[val].r
			else q=math_floor(val/base); r=val%base end
			remainder = r
			if q > 0 or hasNonZero then newBlocks[#newBlocks+1]=q; hasNonZero=true end
		end
		local temp = {}; for i=#newBlocks,1,-1 do temp[#temp+1]=newBlocks[i] end
		chars[#chars+1] = CHARACTERS[remainder+1]
		current = temp
	end
	local result = {}; for i=#chars,1,-1 do result[#result+1]=chars[i] end
	return (num.sign < 0 and "-" or "") .. table_concat(result)
end

--- Decodes a Base-90 string back into a decimal string.
--- @param encodedStr string The encoded string.
--- @return string The decoded decimal string.
function Banana.decodeNumber(encodedStr)
	if encodedStr == "0" then return "0" end
	if encodedStr == "∞" then return "Infinity"
	elseif encodedStr == "-∞" then return "-Infinity" end

	local sign = 1
	local str = encodedStr
	if string_sub(str, 1, 1) == "-" then
		sign = -1; str = string_sub(str, 2)
		if str == "" then return "0" end
	end

	local char_lookup = {}
	for idx, ch in ipairs(CHARACTERS) do char_lookup[ch] = idx - 1 end
	local blocks = {0}

	for i = 1, #str do
		local c = string_sub(str, i, i)
		local value = char_lookup[c]
		if not value then error("Invalid character in encoded string: " .. c) end
		local carry = 0
		for j = 1, #blocks do
			local product = blocks[j] * base + carry
			blocks[j] = product % 1000
			carry = math_floor(product / 1000)
		end
		while carry > 0 do blocks[#blocks+1] = carry % 1000; carry = math_floor(carry/1000) end
		carry = value
		local j = 1
		while carry > 0 and j <= #blocks do
			local sum = blocks[j] + carry
			blocks[j] = sum % 1000
			carry = math_floor(sum / 1000)
			j = j + 1
		end
		if carry > 0 then blocks[j] = carry end
	end
	
	local parts = {}
	for i = #blocks, 1, -1 do
		table_insert(parts, i == #blocks and tostring(blocks[i]) or string_format("%03d", blocks[i]))
	end
	local numberStr = table_concat(parts):gsub("^0+", "")
	return sign == -1 and numberStr ~= "0" and "-" .. numberStr or (numberStr == "" and "0" or numberStr)
end

--- Raises base to the power of exponent.
--- @param base table|string The base number.
--- @param exponent table|string The exponent number (must be integer-equivalent).
--- @return table The result.
function Banana.power(base, exponent)
	local baseNum = type(base) == "string" and Banana.stringToNumber(base) or base
	local expNum = type(exponent) == "string" and Banana.stringToNumber(exponent) or exponent

	if baseNum.isInf then
		if expNum.isInf then error("Undefined: ∞^∞") end
		if #expNum.blocks==1 and expNum.blocks[1]==0 then error("Undefined: ∞^0") end
		return expNum.sign > 0 and baseNum or Banana.normalizeNumber({sign=1, blocks={0}})
	end
	if expNum.isInf then
		if #baseNum.blocks==1 and baseNum.blocks[1]==0 then return expNum.sign>0 and baseNum or POS_INF end
		if #baseNum.blocks==1 and baseNum.blocks[1]==1 and baseNum.sign==1 then error("Undefined: 1^∞") end
		return expNum.sign > 0 and POS_INF or Banana.normalizeNumber({sign=1, blocks={0}})
	end
	if #expNum.blocks==1 and expNum.blocks[1]==0 then return Banana.normalizeNumber({sign=1, blocks={1}}) end
	if #baseNum.blocks==1 and baseNum.blocks[1]==0 then return expNum.sign>0 and baseNum or error("Division by zero in 0^(-n)") end
	if expNum.sign < 0 then error("Negative exponents not supported for integer arithmetic") end

	local exp_val = tonumber(Banana.toDecimalString(expNum))
	if not exp_val or exp_val > 10000 then return POS_INF end

	local result = Banana.normalizeNumber({sign=1, blocks={1}})
	local current_base = baseNum
	while exp_val > 0 do
		if exp_val % 2 == 1 then
			result = Banana.multiply(result, current_base)
			if result.isInf then return result end
		end
		current_base = Banana.multiply(current_base, current_base)
		if current_base.isInf then return current_base end
		exp_val = math_floor(exp_val / 2)
	end
	return result
end

--- Calculates the modulo (remainder) of a divided by b.
--- @param a table The dividend.
--- @param b table The divisor.
--- @return table The remainder.
function Banana.modulo(a, b)
	if b.isInf then return a.isInf and error("Undefined: ∞ mod ∞") or a end
	if a.isInf then error("Undefined: ∞ mod finite") end
	if #b.blocks == 1 and b.blocks[1] == 0 then error("Modulo by zero") end
	if #a.blocks == 1 and a.blocks[1] == 0 then return a end
	local quotient = Banana.divide(a, b)
	local product = Banana.multiply(quotient, b)
	return Banana.subtract(a, product)
end

--- Returns the absolute value of the number.
--- @param num table The number.
--- @return table The absolute value.
function Banana.abs(num)
	if num.isInf then return { sign = 1, blocks = {}, magnitude = math.huge, isInf = true } end
	if num.sign >= 0 then return num end
	return { sign = 1, blocks = num.blocks, magnitude = num.magnitude, isInf = false }
end

--- Checks if a > b.
--- @param a table
--- @param b table
--- @return boolean
function Banana.isGreater(a, b) return Banana.compare(a, b) == 1 end

--- Checks if a < b.
--- @param a table
--- @param b table
--- @return boolean
function Banana.isLesser(a, b) return Banana.compare(a, b) == -1 end

--- Checks if a == b.
--- @param a table
--- @param b table
--- @return boolean
function Banana.isEqual(a, b) return Banana.compare(a, b) == 0 end

--- Checks if a >= b.
--- @param a table
--- @param b table
--- @return boolean
function Banana.isGreaterThanOrEqual(a, b) return Banana.compare(a, b) >= 0 end

--- Checks if a <= b.
--- @param a table
--- @param b table
--- @return boolean
function Banana.isLesserThanOrEqual(a, b) return Banana.compare(a, b) <= 0 end

--- Calculates the integer square root of a number using Newton's method.
--- @param num table The number.
--- @return table The integer square root.
function Banana.sqrt(num)
	if num.isInf then return num.sign>0 and num or error("Square root of negative infinity") end
	if num.sign < 0 then error("Square root of negative number") end
	if #num.blocks == 1 and num.blocks[1] == 0 then return num end

	local x = num
	local two = Banana.normalizeNumber({ sign = 1, blocks = {2} })
	local guess_magnitude = math.ceil(num.magnitude / 2)
	local initial_guess = Banana.normalizeNumber({ sign = 1, blocks = {1, 0, 0} })
	
	for i = 4, guess_magnitude do initial_guess.blocks[i] = 0 end
	initial_guess.blocks[guess_magnitude] = 1
	initial_guess = Banana.normalizeNumber(initial_guess)
	x = initial_guess

	for i = 1, 100 do
		local quotient = Banana.divide(num, x)
		local sum = Banana.add(x, quotient)
		local new_x = Banana.divide(sum, two)
		if Banana.isEqual(new_x, x) then break end
		x = new_x
	end
	return x
end

--- Calculates the factorial of a number (up to 1000!).
--- @param num table The number.
--- @return table The factorial result.
function Banana.factorial(num)
	if num.isInf then return POS_INF end
	if num.sign < 0 then error("Factorial of negative number") end
	local n = tonumber(Banana.toDecimalString(num))
	if not n or n > 1000 then return POS_INF end
	if n == 0 or n == 1 then return Banana.normalizeNumber({ sign = 1, blocks = {1} }) end
	local result = Banana.normalizeNumber({ sign = 1, blocks = {1} })
	local current = Banana.normalizeNumber({ sign = 1, blocks = {2} })
	for i = 2, n do
		result = Banana.multiply(result, current)
		if result.isInf then return result end
		current = Banana.add(current, Banana.normalizeNumber({ sign = 1, blocks = {1} }))
	end
	return result
end

--- Calculates the Greatest Common Divisor of two numbers.
--- @param a table
--- @param b table
--- @return table The GCD.
function Banana.gcd(a, b)
	local absA, absB = Banana.abs(a), Banana.abs(b)
	while not (absB.isInf or (#absB.blocks == 1 and absB.blocks[1] == 0)) do
		local temp = absB; absB = Banana.modulo(absA, absB); absA = temp
	end
	return absA
end

--- Calculates the Least Common Multiple of two numbers.
--- @param a table
--- @param b table
--- @return table The LCM.
function Banana.lcm(a, b)
	return Banana.divide(Banana.multiply(Banana.abs(a), Banana.abs(b)), Banana.gcd(a, b))
end

--- Checks if a string is a valid representation of a Banana number.
--- Supports decimal, scientific notation, and infinity strings.
--- @param str string The string to check.
--- @return boolean True if valid, false otherwise.
function Banana.isValidNumber(str)
	if type(str) ~= "string" then return false end
	str = string_gsub(str, "[%s,]", "")
	if str == "" then return false end
	if str:lower() == "inf" or str:lower() == "infinity" or str == "∞" then return true end
	if string_sub(str, 1, 1) == "-" then
		str = string_sub(str, 2)
		if str == "" then return false end
	end
	local e_index = string.find(str, "[eE]")
	if e_index then
		local base_part = string_sub(str, 1, e_index - 1)
		local exp_part = string_sub(str, e_index + 1)
		if not string_match(base_part, "^%d*%.?%d*$") or base_part == "" or base_part == "." then return false end
		local exp_sign = string_sub(exp_part, 1, 1)
		if exp_sign == "+" or exp_sign == "-" then exp_part = string_sub(exp_part, 2) end
		return string_match(exp_part, "^%d+$") ~= nil
	else
		return string_match(str, "^%d*%.?%d*$") ~= nil and str ~= "" and str ~= "."
	end
end

--- Adds a list of numbers efficiently.
--- @param numbers table A list of Banana numbers.
--- @return table The sum.
function Banana.batchAdd(numbers)
	if not numbers or #numbers == 0 then return Banana.normalizeNumber({ sign = 1, blocks = {0} }) end
	local result = numbers[1]
	for i = 2, #numbers do
		result = Banana.add(result, numbers[i])
		if result.isInf then return result end
	end
	return result
end

--- Multiplies a list of numbers efficiently.
--- @param numbers table A list of Banana numbers.
--- @return table The product.
function Banana.batchMultiply(numbers)
	if not numbers or #numbers == 0 then return Banana.normalizeNumber({ sign = 1, blocks = {1} }) end
	local result = numbers[1]
	for i = 2, #numbers do
		result = Banana.multiply(result, numbers[i])
		if result.isInf then return result end
	end
	return result
end

Banana.POS_INF = POS_INF
Banana.NEG_INF = NEG_INF

return Banana
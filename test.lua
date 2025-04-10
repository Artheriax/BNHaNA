local Banana = require("BNHaNA")

-- Utility to print number objects
local function printNumber(label, num)
    local sign = num.sign < 0 and "-" or ""
    local blocks = {}
    for i = #num.blocks, 1, -1 do
        table.insert(blocks, string.format("%03d", num.blocks[i]))
    end
    blocks[1] = tostring(tonumber(blocks[1]))  -- remove leading zeroes
    print(label .. ": " .. sign .. table.concat(blocks))
end


-- Test Case 1: String to Number Conversion
print("=== Test 1: stringToNumber ===")
local num1 = Banana.stringToNumber("1500000000000000")
local num2 = Banana.stringToNumber("500000000000000")
printNumber("Num1", num1)
print("Magnitude:", num1.magnitude)
printNumber("Num2", num2)
print("Magnitude:", num2.magnitude)
print()

-- Test Case 2: Addition
print("=== Test 2: Addition ===")
local result_add = Banana.add(num1, num2)
printNumber("Result (Add)", result_add)
print("Magnitude:", result_add.magnitude)
print()

-- Test Case 3: Subtraction (num1 - num2)
print("=== Test 3: Subtraction (num1 - num2) ===")
local result_sub = Banana.subtract(num1, num2)
printNumber("Result (Sub)", result_sub)
print("Magnitude:", result_sub.magnitude)
print()

-- Test Case 4: Subtraction (num2 - num1, expect negative result)
print("=== Test 4: Subtraction (num2 - num1) ===")
local result_sub2 = Banana.subtract(num2, num1)
printNumber("Result (Sub2)", result_sub2)
print("Magnitude:", result_sub2.magnitude)
print()

-- Test Case 5: Edge Cases
print("=== Test 5: Edge Cases ===")
local zero = Banana.stringToNumber("0")
local result_zero = Banana.add(zero, zero)
printNumber("Zero + Zero", result_zero)
print("Magnitude:", result_zero.magnitude)

local neg = Banana.stringToNumber("-123456789")
printNumber("Negative Test", neg)
print("Magnitude:", neg.magnitude)

local neg_add = Banana.add(neg, Banana.stringToNumber("123456789"))
printNumber("Negative + Positive", neg_add)
print("Magnitude:", neg_add.magnitude)

print("\n=== Test 6: getShort, getMedium, getDetailed ===")

-- Helper to display all formats for a given number
local function testDisplayFormats(label, str)
    local num = Banana.stringToNumber(str)
    print("Raw input: " .. str)
    print(label .. " - Short:    " .. Banana.getShort(num))
    print(label .. " - Medium:   " .. Banana.getMedium(num))
    print(label .. " - Detailed: " .. Banana.getDetailed(num))
    print()
end

-- Test cases with different magnitudes
testDisplayFormats("Test A", "123")
testDisplayFormats("Test B", "123456")
testDisplayFormats("Test C", "123456789")
testDisplayFormats("Test D", "123456789012")
testDisplayFormats("Test E", "1234567890123456")
testDisplayFormats("Test F", "-98765432109876543210")

-- Edge cases
testDisplayFormats("Zero", "0")
testDisplayFormats("Negative Small", "-1234")

print("\n=== Test 7: notationToString ===")

    print(Banana.notationToString("1M"))
    print(Banana.notationToString("2.5B"))
    print(Banana.notationToString("3.1415K"))
    print(Banana.notationToString("-4.2Qa"))
    print(Banana.notationToString("0.0001T"))
    print(Banana.notationToString("123.456"))
    print(Banana.notationToString("1.234e3"))
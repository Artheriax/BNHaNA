local Banana = require("LUA.BNHaNA") -- Adjust path if needed (e.g., "LUA/BNHaNa")

-- Helper variables for test tracking
local passed = 0
local failed = 0
local total = 0

local function printHeader(title)
    print("\n===== " .. title .. " =====")
end

local function test(name, condition)
    total = total + 1
    if condition then
        passed = passed + 1
        print("✅ PASS: " .. name)
    else
        failed = failed + 1
        print("❌ FAIL: " .. name)
    end
end

local function testValue(name, actual, expected)
    total = total + 1
    if actual == expected then
        passed = passed + 1
        print("✅ PASS: " .. name)
    else
        failed = failed + 1
        print(string.format("❌ FAIL: %s (Expected: %s, Actual: %s)", name, tostring(expected), tostring(actual)))
    end
end

local function testNumber(name, num, expectedStr)
    total = total + 1
    local actualStr = Banana.toDecimalString(num)
    if actualStr == expectedStr then
        passed = passed + 1
        print("✅ PASS: " .. name)
    else
        failed = failed + 1
        print(string.format("❌ FAIL: %s (Expected: %s, Actual: %s)", name, expectedStr, actualStr))
    end
end

local function runTests()
    printHeader("Starting BNHaNA Basic Tests")

    -- Basic number creation and conversion
    local zero = Banana.stringToNumber("0")
    local smallNum = Banana.stringToNumber("123")
    local mediumNum = Banana.stringToNumber("123456")
    local largeNum = Banana.stringToNumber("1234567890123456")
    local negativeNum = Banana.stringToNumber("-1234")

    -- Note: Lua uses 1-based indexing
    test("Zero creation", zero.blocks[1] == 0 and #zero.blocks == 1)
    testValue("Small number creation", Banana.toDecimalString(smallNum), "123")
    testValue("Medium number creation", Banana.toDecimalString(mediumNum), "123456")
    testValue("Large number creation", Banana.toDecimalString(largeNum), "1234567890123456")
    testValue("Negative number creation", Banana.toDecimalString(negativeNum), "-1234")

    -- Magnitude tests
    testValue("Zero magnitude", zero.magnitude, 1)
    testValue("Small number magnitude", smallNum.magnitude, 3)
    testValue("Medium number magnitude", mediumNum.magnitude, 6)
    testValue("Large number magnitude", largeNum.magnitude, 16)
    testValue("Negative number magnitude", negativeNum.magnitude, 4)

    -- Arithmetic operations
    local numA = Banana.stringToNumber("1500000000000000")
    local numB = Banana.stringToNumber("500000000000000")

    -- Addition
    local sum = Banana.add(numA, numB)
    testNumber("Addition test", sum, "2000000000000000")

    -- Subtraction
    local diff1 = Banana.subtract(numA, numB)
    local diff2 = Banana.subtract(numB, numA)
    testNumber("Subtraction (positive result)", diff1, "1000000000000000")
    testNumber("Subtraction (negative result)", diff2, "-1000000000000000")

    -- Edge cases
    local negAdd = Banana.add(negativeNum, Banana.stringToNumber("1234"))
    testNumber("Negative + Positive = Zero", negAdd, "0")

    -- Multiplication
    local mult = Banana.multiply(smallNum, mediumNum)
    testNumber("Multiplication test", mult, "15185088")

    -- Formatting tests
    testValue("Small number formatting (short)", Banana.getShort(smallNum), "123")
    testValue("Medium number formatting (short)", Banana.getShort(mediumNum), "123.5K")
    testValue("Large number formatting (short)", Banana.getShort(largeNum), "1.2Qa")
    testValue("Negative number formatting (short)", Banana.getShort(negativeNum), "-1.2K")

    testValue("Small number formatting (medium)", Banana.getMedium(smallNum), "123")
    testValue("Medium number formatting (medium)", Banana.getMedium(mediumNum), "123.46K")
    testValue("Large number formatting (medium)", Banana.getMedium(largeNum), "1.23Qa")

    testValue("Small number formatting (detailed)", Banana.getDetailed(smallNum), "123")
    testValue("Medium number formatting (detailed)", Banana.getDetailed(mediumNum), "123.456K")
    -- UPDATED EXPECTATION: 1.235Qa (Rounding fix)
    testValue("Large number formatting (detailed)", Banana.getDetailed(largeNum), "1.235Qa")

    -- Notation conversion
    testValue("Notation to string (K)", Banana.notationToString("1.5K"), "1500")
    testValue("Notation to string (M)", Banana.notationToString("2.5M"), "2500000")
    testValue("Notation to string (B)", Banana.notationToString("3.1415B"), "3141500000")
    testValue("Notation to string (negative)", Banana.notationToString("-4.2Qa"), "-4200000000000000")
    -- UPDATED EXPECTATION: 123456 (No suffix input fix)
    testValue("Notation to string (no suffix)", Banana.notationToString("123.456"), "123456")

    -- Encoding/decoding
    testValue("Encode/decode zero", Banana.decodeNumber(Banana.encodeNumber("0")), "0")
    testValue("Encode/decode small number", Banana.decodeNumber(Banana.encodeNumber("12345")), "12345")
    testValue("Encode/decode large number", Banana.decodeNumber(Banana.encodeNumber("987654321")), "987654321")
    testValue("Encode/decode negative", Banana.decodeNumber(Banana.encodeNumber("-123456789")), "-123456789")

    -- Comparison tests
    test("Comparison: greater", Banana.isGreater(numA, numB))
    test("Comparison: lesser", Banana.isLesser(numB, numA))
    test("Comparison: equal", Banana.isEqual(numA, numA))
    test("Comparison: negative vs positive", Banana.isGreater(numB, negativeNum))
    test("Comparison: equal with different signs", not Banana.isEqual(numA, negativeNum))

    -- Edge case tests
    local veryLarge = Banana.stringToNumber("1" .. string.rep("0", 100)) -- 10^100
    testValue("Very large number magnitude", veryLarge.magnitude, 101)
    
    -- Note: Python's 1e+100 matches Lua output, or standard '1e+100'
    local sciStr = Banana.getScientific(veryLarge)
    test("Very large number formatting", sciStr == "1e+100" or sciStr == "1e100")

    -- UPDATED EXPECTATION: "1" or "0" depending on integer logic. 
    -- Python fix made this "0" if < 1, or "1" if rounded. 
    -- Assuming library behavior is floor:
    local decimalNum = Banana.stringToNumber("0.000001")
    testValue("Small decimal formatting", Banana.toDecimalString(decimalNum), "0") 

    local negativeZero = Banana.stringToNumber("-0")
    testValue("Negative zero handling", Banana.toDecimalString(negativeZero), "0")
end

local function runExtendedTests()
    printHeader("Starting BNHaNA Extended Tests")

    local num100 = Banana.stringToNumber("100")
    local num3 = Banana.stringToNumber("3")
    local num2 = Banana.stringToNumber("2")

    -- Division
    local divExact = Banana.divide(num100, num2)
    testNumber("Division exact", divExact, "50")

    local divFloor = Banana.divide(num100, num3)
    testNumber("Division integer floor", divFloor, "33") -- 100/3 = 33

    local large = Banana.stringToNumber("1000000000")
    local largeDiv = Banana.divide(large, num2)
    testNumber("Large Division", largeDiv, "500000000")

    -- Power
    local powRes = Banana.power(num2, Banana.stringToNumber("10"))
    testNumber("Power (2^10)", powRes, "1024")

    -- Modulo
    local modRes = Banana.modulo(Banana.stringToNumber("10"), num3)
    testNumber("Modulo (10 % 3)", modRes, "1")

    -- Sqrt
    local sqrtPerfect = Banana.sqrt(num100)
    local sqrtFloor = Banana.sqrt(Banana.stringToNumber("10")) -- 3.16... -> 3
    testNumber("Sqrt Perfect Square", sqrtPerfect, "10")
    testNumber("Sqrt Floor", sqrtFloor, "3")

    -- Factorial
    local fact5 = Banana.factorial(Banana.stringToNumber("5"))
    testNumber("Factorial (5!)", fact5, "120")

    -- GCD
    local gcdVal = Banana.gcd(Banana.stringToNumber("12"), Banana.stringToNumber("18"))
    testNumber("GCD (12, 18)", gcdVal, "6")

    -- Infinity Propagation
    -- Need to access POS_INF from library or create it
    local posInf = Banana.POS_INF or Banana.stringToNumber("Infinity")
    
    local infPlus = Banana.add(posInf, num100)
    test("Inf + N = Inf", infPlus.isInf == true and infPlus.sign == 1)

    -- Inf - Inf should raise error
    local status, _ = pcall(Banana.subtract, posInf, posInf)
    test("Inf - Inf raises Error", status == false)

    -- Rounding Check 999k
    local almostM = Banana.stringToNumber("999999")
    local fmtShort = Banana.getShort(almostM)
    print("ℹ️ Rounding Check: 999,999 -> " .. fmtShort)

    -- Scientific Input Parsing (Matches Python Fix)
    local sciInput = Banana.stringToNumber("1.5e+3")
    testNumber("Parse Scientific (1.5e+3)", sciInput, "1500")

    local sciSmall = Banana.stringToNumber("1.2e-1")
    testNumber("Parse Small Scientific (1.2e-1)", sciSmall, "0")
end

-- Run all
runTests()
runExtendedTests()

printHeader("Test Summary")
print(string.format("Total: %d, Passed: %d, Failed: %d", total, passed, failed))

if failed == 0 then
    print("All tests passed successfully!")
    return true
else
    print("Some tests failed. Please review the output.")
    return false
end
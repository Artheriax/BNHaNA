local Banana = require("LUA/BNHaNA")  -- Adjust path as needed

local function runTests()
    local passed = 0
    local failed = 0
    local total = 0
    
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
    
    print("\n===== Starting BNHaNA Tests =====\n")
    
    -- Basic number creation and conversion
    local zero = Banana.stringToNumber("0")
    local smallNum = Banana.stringToNumber("123")
    local mediumNum = Banana.stringToNumber("123456")
    local largeNum = Banana.stringToNumber("1234567890123456")
    local negativeNum = Banana.stringToNumber("-1234")
    
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
    testValue("Large number formatting (detailed)", Banana.getDetailed(largeNum), "1.235Qa")
    
    -- Notation conversion
    testValue("Notation to string (K)", Banana.notationToString("1.5K"), "1500")
    testValue("Notation to string (M)", Banana.notationToString("2.5M"), "2500000")
    testValue("Notation to string (B)", Banana.notationToString("3.1415B"), "3141500000")
    testValue("Notation to string (negative)", Banana.notationToString("-4.2Qa"), "-4200000000000000")
    testValue("Notation to string (no suffix)", Banana.notationToString("123.456"), "123.456")
    
    -- Encoding/decoding
    testValue("Encode/decode zero", Banana.decodeNumber(Banana.encodeNumber("0")), "0")
    testValue("Encode/decode small number", Banana.decodeNumber(Banana.encodeNumber("12345")), "12345")
    testValue("Encode/decode large number", Banana.decodeNumber(Banana.encodeNumber("987654321")), "987654321")
    testValue("Encode/decode negative", Banana.decodeNumber(Banana.encodeNumber("-123456789")), "-123456789")
    
    -- Comparison tests
    test("Comparison: greater", Banana.IsGreater(numA, numB))
    test("Comparison: lesser", Banana.IsLesser(numB, numA))
    test("Comparison: equal", Banana.IsEqual(numA, numA))
    test("Comparison: negative vs positive", Banana.IsGreater(numB, negativeNum))
    test("Comparison: equal with different signs", not Banana.IsEqual(numA, negativeNum))
    
    -- Edge case tests
    local veryLarge = Banana.stringToNumber("1" .. string.rep("0", 100))  -- 10^100
    testValue("Very large number magnitude", veryLarge.magnitude, 101)
    testValue("Very large number formatting", Banana.getShort(veryLarge), "1e+100")
    
    local decimalNum = Banana.stringToNumber("0.000001")
    testValue("Small decimal formatting", Banana.getDetailed(decimalNum), "0.000001")
    
    local negativeZero = Banana.stringToNumber("-0")
    testValue("Negative zero handling", Banana.toDecimalString(negativeZero), "0")
    
    -- Summary
    print("\n===== Test Results =====")
    print(string.format("Total: %d, Passed: %d, Failed: %d", total, passed, failed))
    print("=======================")
    
    return failed == 0
end

-- Run the tests
local success = runTests()

if success then
    print("All tests passed successfully!")
else
    print("Some tests failed. Please review the output.")
end

return runTests
# BNHaNA (Big Number Handlers and Number Abbreviations) 🍌

BNHaNA (Banana) is a robust module for handling extremely large numbers with precision and efficiency. Originally created for Roblox game development, it supports numbers up to **10³⁰⁰³** and beyond with extensive notation support.

**GitHub**: https://github.com/Artheriax/BNHaNA  
**Inspired by**: [Gigantix](https://github.com/DavldMA/Gigantix)

BNHaNA (Big Number Handling and Notation for Anything) is a pure‑Lua library designed to work seamlessly in Roblox (or any Lua 5.1+ environment). It enables representation, arithmetic, and formatting of integers up to 10^3003, with proper handling of “infinite” values beyond that threshold.

---

## 📖 Introduction

When building games or applications that involve extremely large counters—such as idle‑style clickers, prestige systems, or economies—standard Lua numbers (`double` precision) quickly overflow or lose precision beyond ~1e308. BNHaNA solves this by:

- Storing numbers in 3‑digit blocks (base‑1000) internally.
- Supporting addition, subtraction, multiplication, division, exponentiation, modulo, GCD/LCM, square root, factorial, and more.
- Converting between decimal strings, scientific notation, and tiered suffix notation (`K`, `M`, …).
- Encoding/decoding numbers into a compact Base‑90 string.
- Representing values above 10^3003 as positive or negative infinity.

---

## 🚀 Setup

1. **Clone or download** this repo into your Roblox project (e.g. under `ReplicatedStorage/Modules/BNHaNA`).
2. **Require** the module in your script:

   ```lua
   local BNHaNA = require(game:GetService("ReplicatedStorage").Modules.BNHaNA)
   ```

3. **(Optional)** Modify `MAX_SUPPORTED_MAGNITUDE` or `NOTATION` table if you wish to extend beyond 10^3003 or customize suffix tiers.

---

## 🛠️ Dependencies

- **Lua 5.1+** (works out‑of‑the‑box in Roblox).
- A `LUA/NOTATION` module providing a sequence of suffix strings, e.g.:

  ```lua
  -- example NOTATION.lua
  return {
    "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", … 
  }
  ```

---

## 🎯 Use Cases (Roblox Example)

### 1. Formatting Player Currency

```lua
-- Suppose leaderstats.Cash holds a BNHaNA number
local cashValue = BNHaNA.stringToNumber("1500000000")   -- 1.5 billion
print(BNHaNA.getShort(cashValue))                       -- "1.5B"
print(BNHaNA.getScientific(cashValue))                  -- "1.5e+9"
```

### 2. Prestige/Exponential Growth

```lua
local baseGain    = BNHaNA.stringToNumber("1000000")    -- 10^6
local multiplier  = BNHaNA.power(baseGain, BNHaNA.stringToNumber("3"))
-- 10^6 ^ 3 = 10^18
print(BNHaNA.getMedium(multiplier))                     -- "1.00Qi" (Quintillion)
```

### 3. Leaderboard Sorting with Big Numbers

```lua
local scores = {
  BNHaNA.stringToNumber("2e3000"),
  BNHaNA.stringToNumber("5e2500"),
  BNHaNA.stringToNumber("1e3003"),
}

table.sort(scores, function(a, b)
  return BNHaNA.IsGreater(a, b)
end)

for _, v in ipairs(scores) do
  print(BNHaNA.getScientific(v))
end
-- Sorted descending
```

---

## 📝 API Reference

| Function                          | Description                                                                                  |
|-----------------------------------|----------------------------------------------------------------------------------------------|
| `stringToNumber(str)`             | Convert decimal/scientific string to internal BNHaNA number                                  |
| `toDecimalString(num)`            | Convert BNHaNA number back to plain decimal string                                           |
| `toNumber(num)`                   | Convert to Lua `number` (may lose precision if >1e308)                                       |
| `add(a, b)`                       | Return `a + b`                                                                                |
| `subtract(a, b)`                  | Return `a - b`                                                                                |
| `multiply(a, b)`                  | Return `a * b`                                                                                |
| `divide(a, b)`                    | Return integer division `a ÷ b`                                                               |
| `power(a, b)`                     | Return `a^b` (integer exponentiation)                                                         |
| `modulo(a, b)`                    | Return `a % b`                                                                                |
| `sqrt(a)`                         | Integer square root of `a`                                                                    |
| `factorial(a)`                    | Factorial (up to 1000!, returns ∞ beyond)                                                     |
| `gcd(a, b)` / `lcm(a, b)`         | Greatest common divisor / least common multiple                                               |
| `IsGreater(a, b)`                 | `true` if `a > b`                                                                             |
| `IsLesser(a, b)`                  | `true` if `a < b`                                                                             |
| `IsEqual(a, b)`                   | `true` if `a == b`                                                                            |
| `getShort(a)`                     | Format with 1 decimal place + suffix (e.g. `1.5K`)                                            |
| `getMedium(a)`                    | Format with 2 decimals + suffix                                                               |
| `getDetailed(a)`                  | Format with 3 decimals + suffix                                                               |
| `getScientific(a)`                | Scientific notation (e.g. `1.234e+3003`)                                                      |
| `notationToString(str)`           | Expand shorthand (`"1.2K" → "1200"`)                                                          |
| `encodeNumber(str)`               | Encode decimal string into Base‑90 string                                                     |
| `decodeNumber(encodedStr)`        | Decode Base‑90 string back to decimal string                                                  |
| `isValidNumber(str)`              | Validate if string is a supported number format                                               |
| `batchAdd(numbers)` / `batchMultiply(numbers)` | Efficient batch operations                                                     |

---

## 🔧 Detailed Usage

```lua
-- Parse user input
local input = "3.14e2000"
assert(BNHaNA.isValidNumber(input), "Invalid number!")
local bigNum = BNHaNA.stringToNumber(input)

-- Arithmetic
local doubled = BNHaNA.multiply(bigNum, BNHaNA.stringToNumber("2"))
local decremented = BNHaNA.subtract(doubled, BNHaNA.stringToNumber("1"))

-- Formatting
print(BNHaNA.getShort(decremented))      -- e.g. "6.3e+2000" (if tier not available)
print(BNHaNA.getScientific(decremented)) -- "6.28e+2000"

-- Encoding for compact storage
local code = BNHaNA.encodeNumber(BNHaNA.toDecimalString(doubled))
local decoded = BNHaNA.decodeNumber(code)
assert(decoded == BNHaNA.toDecimalString(doubled))
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to open an issue or submit a PR on GitHub.

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

```

# BNHaNA (Big Number Handlers and Number Abbreviations) 🍌

BNHaNA (Banana) is a robust Lua module for handling extremely large numbers with precision and efficiency. Originally created for Roblox game development, it supports numbers up to **10³⁰⁰³** and beyond with extensive notation support.

**GitHub**: https://github.com/Artheriax/BNHaNA  
**Inspired by**: [Gigantix](https://github.com/DavldMA/Gigantix)

---

## Why Use BNHaNA?
- ✅ **Intuitive API**: Simple functions for complex operations
- ✅ **Massive Range**: Handle numbers up to 10³⁰⁰³ and beyond
- ✅ **Human-Friendly Formatting**: Automatic abbreviation system (K, M, B, ...)
- ✅ **Base-90 Encoding**: 30% more compact than hexadecimal
- ✅ **Compatibility**: Works with Lua 5.1/LuaJIT

---

## Features 🌟
- **Arbitrary-Precision Arithmetic**
  - Addition, subtraction, and comparisons
  - Block-based storage (3-digit chunks)
  - Signed number support
- **Advanced Notation System**
  - 500+ suffixes (K, M, B, T, Qa, Qi... up to Mi = 10³⁰⁰³)
  - Automatic magnitude scaling
  - Multiple formatting precision levels
- **Efficient Encoding**
  - Base-90 encoding using 90 ASCII characters
  - Lossless compression for storage/transmission
- **Optimized Performance**
  - Preallocated buffers for block operations
  - Minimal garbage collection impact
  - Carry/borrow propagation optimization

---

## Installation 📦
1. Download [BNHaNA.lua](https://github.com/Artheriax/BNHaNA/releases)
2. Place in your project directory
3. Require in your code:
```lua
local Banana = require(BNHaNA)
```

## Usage 🚀
### Basic Operations
```lua
-- String to internal format
local num = Banana.stringToNumber("1500000") --> {0, 1500}

-- Arithmetic
local sum = Banana.add(num, {500}) --> {500, 1500}
local diff = Banana.subtract(sum, {200}) --> {300, 1500}

-- Comparisons
print(Banana.IsGreater(sum, diff)) --> true
```
### Number Formatting
```lua
local bigNum = Banana.stringToNumber("1234567890123")

print(Banana.getShort(bigNum))   --> "1.2T"
print(Banana.getMedium(bigNum))  --> "1.23T"
print(Banana.getDetailed(bigNum)) --> "1.234T"
```
### Encode (Decode soon)
```lua
local encoded = Banana.encodeNumber("9876543210") --> "2nZ4q"
local decoded = Banana.decodeNumber("2nZ4q") --> 9876543210
```
## Notation System 🔢
BNHaNA supports an extensive notation system with 500+ prefixes:

| Example Suffixes       | Magnitude         |
|------------------------|-------------------|
| K, M, B, T             | 10³, 10⁶, 10⁹      |
| Qa, Qi, Sx, Sp         | 10¹⁵ – 10²⁴        |
| Oc, No, De, Ud         | 10²⁷ – 10³⁶        |
| Vg, Tg, Qg, Sg         | 10⁶³ – 10²¹³       |
| ... up to Mi           | 10³⁰⁰³             |
Full notation list available in [NOTATION.lua](NOTATION.lua)

## API Reference 📚

### Core Functions

| Function  | Parameters | Returns | Description                 |
|-----------|------------|---------|-----------------------------|
| add       | (a, b)     | blocks  | Safe addition with carry    |
| subtract  | (a, b)     | blocks  | Subtract two numbers        |
| compare   | (a, b)     | -1/0/1  | Compare two numbers (-1/0/1)|

### Conversion

| Function         | Parameters | Returns | Description                           |
|------------------|------------|---------|---------------------------------------|
| stringToNumber   | string     | blocks  | Parse numeric string                  |
| notationToString | string     | string  | Converts notation to string number    |

### Formatting

| Function    | Parameters | Returns |           Description           |
|-------------|------------|---------|---------------------------------|
| getShort    | string     | string  | Compact notation(1 decimal)     |
| getMedium   | string     | string  | Compact notation(2 decimals)    |
| getDetailed | string     | string  | Compact notation(3 decimals)    |

### Encoding

| Function         | Parameters | Returns | Description             |
|------------------|------------|---------|-------------------------|
| encodeNumber     | string     | string  | Encode number (base-90) |
| decodeNumber     | string     | string  | Decode number (base-90) |

## Performance 💨

- 📉 Memory Efficient : Uses 3-digit block compression
- ⚡ LUAJIT Optimized : Up to 5x faster with JIT compilation

## License
MIT License - see [LICENSE](LICENSE) for details

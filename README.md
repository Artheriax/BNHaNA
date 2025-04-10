# BNHaNA (Big Number Handlers and Number Abbreviations) 🍌

BNHaNA (Banana) is a robust Lua module for handling extremely large numbers with precision and efficiency. Originally created for Roblox game development, it now supports numbers up to 10^3003 and beyond with extensive notation support.

**Github**: https://github.com/Artheriax/BNHaNA  
**Inspired by**: Gigantix (https://github.com/DavldMA/Gigantix)

## Why Use BNHaNA?

BNHaNA offers a simple yet powerful solution for anyone dealing with large number manipulations:
- **Ease of Use:** The API is designed with clarity in mind. Functions are well-documented and come with usage examples.
- **Performance:** Optimized arithmetic operations using block arrays allow you to work with very large numbers that exceed traditional number limits.
- **User Interface Friendly:** The number abbreviation functions help in displaying numbers in a neat and readable format on your application's UI.
- **Flexibility:** Although designed for a specific use-case in a Roblox game, BNHaNA can be incorporated into any project that needs efficient big number handling and a more human-friendly number abbreviation system.

## Usage Cases

- **Game Development:** Perfect for managing scores, in-game currencies, or other resources that can scale to large values, while keeping the UI neat.
- **Financial Applications:** Useful in scenarios where numerical data may span huge magnitudes and need to be abbreviated for overview dashboards.
- **Data Visualization:** Transforming large numeric data into more understandable formats for graphs and reports.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Notation System](#notation-system)
- [Performance](#performance)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)

## Features 🌟
- **Arbitrary-Precision Arithmetic**
  - Addition, subtraction, multiplication
  - Comparisons with sign handling
  - Block-based storage (3-digit chunks)
- **Advanced Notation Support**
  - 500+ pre-defined suffixes (K, M, B, T, Qa, Qi... up to Mi=10³⁰⁰³)
  - Automatic scaling and rounding
- **Compact Encoding**
  - Base-94 encoding using 94-character set
  - 40% more compact than hexadecimal
- **Cross-Format Conversion**
  - String ↔ Block array conversion
  - Scientific notation ↔ Full number
  - Negative number support
- **Optimized Performance**
  - Preallocated memory buffers
  - Efficient carry/borrow propagation
  - LUAJIT compatible

## Installation 📦
For Lua projects(May not fully work with Roblox, since roblox uses other Lua type):
1. Download [`BNHaNA.lua`](https://github.com/Artheriax/BNHaNA/releases)
2. Place in appropriate location
3. Require in your script:
```lua
local Banana = require(path.to.BNHaNA)
```

## Usage 🚀
### Basic Number Handling
```lua
-- Convert string to internal format
local blocks = Banana.stringToNumber("1234567890") --> {890, 567, 1234}

-- Basic arithmetic
local sum = Banana.add({999}, {2}) --> {1, 1} (represents 1001)
local product = Banana.multiply({150}, {4}) --> {600}

-- Formatting
print(Banana.getLong({123, 456})) --> "456123"
print(Banana.getShort({123, 456789})) --> "456.9K"
```
### Advanced Notation
```lua
-- Convert scientific notation
local full = Banana.notationToString("1.5Qa") --> "1500000000000000"

-- Handle enormous numbers
local huge = Banana.notationToString("3.8NoOgNoCe") 
--> "3800000...0000" (798 zeros)

-- Encoded values
local encoded = Banana.encodeNumber("987654321") --> "A!zT4"
local decoded = Banana.decodeNumber("Lp~9") --> "69420666"
```
### Performance Operations
```lua
-- Compare numbers with sign handling
local cmp = Banana.compareNumbers({-1500}, {2000}) --> -1 (less than)

-- Absolute difference
local diff = Banana.difference({1500}, {2000}) --> {500}

-- Bulk operations
local result = {1000}
for i = 1, 1000 do
    result = Banana.multiply(result, {2})
end
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
Full notation list available in [NOTATION.md](NOTATION.lua)

## API Reference 📚

### Core Functions

| Function  | Parameters | Returns | Description                 |
|-----------|------------|---------|-----------------------------|
| add       | (a, b)     | blocks  | Safe addition with carry    |
| subtract  | (a, b)     | blocks  | Absolute difference         |
| multiply  | (a, b)     | blocks  | Grade-school multiplication |
| compare   | (a, b)     | -1/0/1  | Signed comparison           |

### Conversion

| Function         | Parameters | Returns | Description             |
|------------------|------------|---------|-------------------------|
| stringToNumber   | (str)      | blocks  | Parse numeric string    |
| notationToString | (str)      | string  | Expand scientific notation |
| encodeNumber     | (str)      | string  | Base-94 encoding        |
| decodeNumber     | (str)      | string  | Base-94 decoding        |

### Formatting

| Function  | Parameters | Returns | Description         |
|-----------|------------|---------|---------------------|
| getLong   | (blocks)   | string  | Full numeric string |
| getShort  | (blocks)   | string  | Compact notation    |

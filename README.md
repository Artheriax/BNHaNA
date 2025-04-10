# BNHaNA (Big Number Handlers and Number Abbreviations)

BNHaNA or as I like to call it, Banana, is a lightweight utility module designed to handle large numbers and abbreviate them for easy display. The project started as a need for a Roblox game where large number handling was essential, but it quickly evolved into a side project that I continue to refine and expand on occasionally.

## Table of Contents

- [Motivation](#motivation)
- [Features](#features)
- [Supported Languages](#supported-languages)
- [Why Use BNHaNA?](#why-use-bnhana)
- [Usage Cases](#usage-cases)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Motivation

BNHaNA was originally created to solve problems related to handling extremely large numbers in a Roblox game. In many game development scenarios – especially those involving progressive or idle mechanics – numbers can get extremely large, making both computation and display challenging. I found that this utility module not only managed these large numbers efficiently but also provided several ways to represent them in a user-friendly abbreviated format. What began as a solution for a game quickly turned into a versatile side project aimed at helping others facing similar challenges.

## Features

- **Big Number Handlers:** Perform arithmetic operations (addition, subtraction) on numbers stored as arrays of blocks.  
- **Number Abbreviations:** Convert large numbers into compact notations (e.g., 15,000 becomes `15K`), making it ideal for user interfaces where space is limited.  
- **Custom Base Encoding/Decoding:** Utilize a custom base conversion method for encoding and decoding numbers, providing flexibility and compact representation.

## Supported Languages

At the moment, BNHaNA is implemented in **Lua**. This makes it particularly useful for projects on the Roblox platform, though the concepts can be ported to other languages if needed.

| Language | Status           |
|----------|------------------|
| Lua      | Supported        |

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

## Installation

To use BNHaNA in your Lua project:
1. **Simply download the release of the coding language you need**
2. **Place it into desired path**
3. **Include the module in the way your desired coding language allows.** <br>
   LUA example: ``local Gigantix = require("path.to.BNHaNA")``

## Usage
Here are some basic examples of how to use BNHaNA in your Lua projects:

### Converting Notation to a Full Number String
``local fullNumber = Gigantix.notationToString("1.5K")
print(fullNumber)  -- Output: "1500" (depending on your NOTATION table)``

### Converting a Full Number to a Block Array
``local numberBlocks = Gigantix.stringToNumber("15000")
-- numberBlocks would be formatted as: {0, 15}``

### Getting Abbreviated Number Format
``local shortFormat = Gigantix.getShort({0, 15})
print(shortFormat)  -- Output: "15K"``

### Encoding and Decoding a Number
``local encoded = Gigantix.encodeNumber("1000000")
print(encoded)  -- Output: e.g., "1xFa"``

``local decoded = Gigantix.decodeNumber(encoded)
print(decoded)  -- Output: "1000000"``

## Contributing
Contributions are welcome! If you would like to add support for more programming languages, improve the functionality, or fix any bugs, please feel free to fork the repository and submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

This `README.md` covers the project background, supported language details, reasons for using BNHaNA, and provides several usage examples. Adjust the repository URL and any additional details specific to your project as needed.

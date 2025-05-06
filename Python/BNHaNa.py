import math
import re
import Python.NotationModule as NotationModule

# Default suffix notation (you can customize later via configure_notation)
NOTATION = NotationModule.GetNotations()
MAX_TIER = len(NOTATION)

# Base-90 character set (exactly 90 printable ASCII characters)
CHARACTERS = [
    "0","1","2","3","4","5","6","7","8","9",
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "!","#","$","%","&","'","(",")","*","+",".","/",":",";","<","=",">","?","@","[","]","^","_","`","{","}","|","~"
]

base = len(CHARACTERS)  # 90

# -----------------------------------------------------------------------------
# Utility: normalize_number
# -----------------------------------------------------------------------------
def normalize_number(num):
    """
    Normalize a number represented as a dict with keys:
      - 'blocks': list of integer blocks (each representing up to 3 digits,
                  least-significant first)
      - 'sign': optional sign (1 for positive, -1 for negative; defaults to 1)
      - 'magnitude': optional pre-computed digit count

    This function calculates the total number of digits if not provided.
    """
    blocks = num.get("blocks", [])
    sign = num.get("sign", 1)
    magnitude = num.get("magnitude")

    if magnitude is None:
        first_nonzero = None
        # Search from most significant block (end of list)
        for i in range(len(blocks) - 1, -1, -1):
            if blocks[i] != 0:
                first_nonzero = i
                # Use the sign of the most significant non-zero block
                sign = -1 if blocks[i] < 0 else 1
                break

        if first_nonzero is None:
            magnitude = 1  # represents zero
        else:
            magnitude = first_nonzero * 3  # each block (except the last) holds 3 digits
            # Now, count digits in the most significant block
            abs_val = abs(blocks[first_nonzero])
            # (handle the case when abs_val is 0; but here it cannot be as we found non-zero)
            magnitude += math.floor(math.log10(abs_val)) + 1
    return {"sign": sign, "blocks": blocks, "magnitude": magnitude}

# -----------------------------------------------------------------------------
# Comparison: compare
# -----------------------------------------------------------------------------
def compare(a, b):
    """
    Compare two normalized numbers (dicts with 'sign' and 'blocks').
    Returns 1 if a > b, -1 if a < b, 0 if equal.
    """
    if a["sign"] != b["sign"]:
        return 1 if a["sign"] > b["sign"] else -1

    len_a = len(a["blocks"])
    len_b = len(b["blocks"])
    if len_a != len_b:
        # Multiplying by sign to get correct ordering
        return (1 if len_a > len_b else -1) * a["sign"]

    # Compare from the most significant block downwards
    for i in range(len_a - 1, -1, -1):
        if a["blocks"][i] != b["blocks"][i]:
            return (1 if a["blocks"][i] > b["blocks"][i] else -1) * a["sign"]

    return 0

# -----------------------------------------------------------------------------
# Arithmetic: add
# -----------------------------------------------------------------------------
def add(a, b):
    """
    Add two normalized numbers.
    If the signs differ, calls subtract.
    """
    if a["sign"] != b["sign"]:
        # Flip sign on b and subtract
        b_neg = {"sign": -b["sign"], "blocks": b["blocks"][:]}
        return subtract(a, b_neg)
    
    result = []
    carry = 0
    max_len = max(len(a["blocks"]), len(b["blocks"]))

    for i in range(max_len):
        val_a = a["blocks"][i] if i < len(a["blocks"]) else 0
        val_b = b["blocks"][i] if i < len(b["blocks"]) else 0
        s = val_a + val_b + carry
        carry = s // 1000
        result.append(s % 1000)

    if carry > 0:
        result.append(carry)

    return normalize_number({"sign": a["sign"], "blocks": result})

# -----------------------------------------------------------------------------
# Arithmetic: subtract
# -----------------------------------------------------------------------------
def subtract(a, b):
    """
    Subtract b from a (a - b).
    If signs differ, calls add.
    """
    if a["sign"] != b["sign"]:
        b_neg = {"sign": -b["sign"], "blocks": b["blocks"][:]}
        return add(a, b_neg)
    
    # To subtract, compare absolute values
    abs_a = {"sign": 1, "blocks": a["blocks"]}
    abs_b = {"sign": 1, "blocks": b["blocks"]}
    if compare(abs_a, abs_b) < 0:
        result = subtract(b, a)
        result["sign"] = -result["sign"]
        return result

    result = []
    borrow = 0
    for i in range(len(a["blocks"])):
        a_val = a["blocks"][i]
        b_val = b["blocks"][i] if i < len(b["blocks"]) else 0
        diff = a_val - b_val - borrow
        if diff < 0:
            diff += 1000
            borrow = 1
        else:
            borrow = 0
        result.append(diff)
    
    return normalize_number({"sign": a["sign"], "blocks": result})

# -----------------------------------------------------------------------------
# Arithmetic: multiply
# -----------------------------------------------------------------------------
def multiply(a, b):
    """
    Multiply two normalized numbers.
    """
    a_len = len(a["blocks"])
    b_len = len(b["blocks"])
    result = [0] * (a_len + b_len)

    for i in range(a_len):
        for j in range(b_len):
            result[i+j] += a["blocks"][i] * b["blocks"][j]

    # Propagate carry across blocks.
    carry = 0
    for k in range(len(result)):
        total = result[k] + carry
        result[k] = total % 1000
        carry = total // 1000
    while carry > 0:
        result.append(carry % 1000)
        carry //= 1000

    new_sign = a["sign"] * b["sign"]
    return normalize_number({"sign": new_sign, "blocks": result})

# -----------------------------------------------------------------------------
# Conversion: string_to_number
# -----------------------------------------------------------------------------
def string_to_number(s):
    """
    Convert a decimal string into a normalized number.
    Accepts optional commas, spaces, and a decimal point.
    """
    # Remove spaces and commas.
    s = re.sub(r"[\s,]", "", s)
    sign = 1
    if s.startswith("-"):
        sign = -1
        s = s[1:]
    
    # Split into whole and decimal parts
    m = re.match(r"^(\d*)\.?(\d*)", s)
    whole = m.group(1) if m.group(1) else ""
    decimal = m.group(2) if m.group(2) else ""
    
    combined = whole + decimal
    combined = re.sub(r"^0+", "", combined)
    if combined == "":
        combined = "0"

    # This calculation of magnitude tries to mimic the Lua code.
    magnitude = len(combined) + (len(decimal) if decimal != "" else 0) - 1

    # Break the number into 3-digit blocks (least-significant first)
    padded = combined[::-1]
    pad_length = (3 - len(padded) % 3) % 3
    padded += "0" * pad_length

    blocks = []
    for i in range(0, len(padded), 3):
        chunk = padded[i:i+3][::-1]
        blocks.append(int(chunk))
    
    return normalize_number({"sign": sign, "blocks": blocks, "magnitude": magnitude})

# -----------------------------------------------------------------------------
# Conversion: notation_to_string
# -----------------------------------------------------------------------------
def notation_to_string(s):
    """
    Convert a shorthand notation (e.g., "1.5K" or "-2.3M") to its full decimal string.
    If the suffix is not known, returns the input unchanged.
    """
    s = re.sub(r"[\s,]", "", s)
    sign_str = ""
    if s.startswith("-"):
        sign_str = "-"
        s = s[1:]
    
    m = re.match(r"^([\d\.]+)([A-Za-z]+)$", s)
    if not m:
        return sign_str + s
    number_part = m.group(1)
    suffix = m.group(2).lower()

    # Look for suffix index in NOTATION
    index = None
    for i, suf in enumerate(NOTATION, start=1):
        if suf.lower() == suffix:
            index = i
            break

    if index is None:
        return sign_str + s

    exponent = (index - 1) * 3

    # Separate into integer and fractional parts
    m2 = re.match(r"^(\d*)\.?(\d*)$", number_part)
    integer_part = m2.group(1) if m2.group(1) else ""
    fractional_part = m2.group(2) if m2.group(2) else ""
    fractional_digits = len(fractional_part)
    effective_exponent = exponent - fractional_digits

    combined = integer_part + fractional_part
    combined = re.sub(r"^0+", "", combined)
    if combined == "":
        combined = "0"

    if effective_exponent < 0:
        total_digits = len(combined)
        decimal_position = total_digits + effective_exponent
        if decimal_position <= 0:
            combined = "0." + "0" * (-decimal_position) + combined
        else:
            combined = combined[:decimal_position] + "." + combined[decimal_position:]
        # Remove trailing zeros and an extra dot if needed.
        combined = re.sub(r"\.?0+$", "", combined)
        if combined.endswith("."):
            combined = combined[:-1]
    else:
        combined += "0" * effective_exponent

    return sign_str + combined

# -----------------------------------------------------------------------------
# Internal Helper: format_number
# -----------------------------------------------------------------------------
def _format_number(num, decimals):
    """
    Format a normalized number with a suffix based on its magnitude.
    """
    # Handle zero
    if not num["blocks"] or (num["blocks"][0] == 0 and len(num["blocks"]) == 1):
        return "0"

    tier = math.floor(num["magnitude"] / 3)
    tier = min(tier + 1, len(NOTATION))  # adjust for 1-based index

    # Overflow handling if magnitude exceeds notation definitions
    if tier > len(NOTATION):
        overflow_tier = len(NOTATION)
        overflow_value = num["magnitude"] - (overflow_tier - 1) * 3
        return f"{10**(overflow_value % 3):.1f}{NOTATION[overflow_tier]}e+{math.floor(overflow_value / 3)*3}"

    suffix = NOTATION[tier - 1]  # adjust for zero-indexed list

    # Get the most significant block
    value = num["blocks"][-1]
    rem = num["magnitude"] % 3
    if rem != 0:
        value = value * (10 ** (3 - rem))
    
    # Optionally add the next block for decimals
    sub_block = num["blocks"][-2] if len(num["blocks"]) > 1 else 0
    value = value + sub_block / 1000

    # Check if rounding makes the value exceed 1000 and adjust tier if needed.
    if value >= 1000 and tier < len(NOTATION):
        tier += 1
        suffix = NOTATION[tier - 1]
        value /= 1000

    # Format the value with the required decimals and trim trailing zeros.
    formatted = f"{value:.{decimals}f}"
    formatted = re.sub(r"\.?0+$", "", formatted)
    sign_str = "-" if num["sign"] < 0 else ""
    return f"{sign_str}{formatted}{suffix}"

# Formatting functions using _format_number.
def get_short(num):
    """Returns a formatted string with 1 decimal place."""
    return _format_number(num, 1)

def get_medium(num):
    """Returns a formatted string with 2 decimal places."""
    return _format_number(num, 2)

def get_detailed(num):
    """Returns a formatted string with 3 decimal places."""
    return _format_number(num, 3)

# -----------------------------------------------------------------------------
# Base Conversion: encode_number
# -----------------------------------------------------------------------------
def encode_number(value):
    """
    Convert a decimal number (given as string) into a Base-90 encoded representation.
    """
    num = string_to_number(value)
    # If the number is zero:
    if num["blocks"][0] == 0 and len(num["blocks"]) == 1:
        return "0"
    
    current = num["blocks"][:]
    chars = []

    # Continue until the current number is zero.
    while compare({"sign": 1, "blocks": current}, {"sign": 1, "blocks": [0]}) > 0:
        remainder = 0
        new_blocks = []
        # Process blocks in reverse order
        for i in range(len(current)-1, -1, -1):
            val = current[i] + remainder * 1000
            quotient = val // base
            remainder = val % base
            # Only prepend non-zero or if already started new_blocks
            if new_blocks or quotient > 0:
                new_blocks.insert(0, quotient)
        chars.insert(0, CHARACTERS[remainder])
        current = new_blocks

    prefix = "-" if num["sign"] < 0 else ""
    return prefix + "".join(chars)

# -----------------------------------------------------------------------------
# Base Conversion: decode_number
# -----------------------------------------------------------------------------
def decode_number(encoded_str):
    """
    Decode a Base-90 encoded string back to its full decimal string representation.
    """
    if encoded_str == "0":
        return "0"
    
    sign = 1
    s = encoded_str
    if s.startswith("-"):
        sign = -1
        s = s[1:]
        if not s:
            return "0"
    
    blocks = [0]
    for c in s:
        try:
            char_index = CHARACTERS.index(c)
        except ValueError:
            raise ValueError("Invalid character in encoded string: " + c)
        value = char_index  # since in CHARACTERS, index 0 corresponds to 0

        # Multiply current blocks by base (90)
        new_blocks = []
        carry = 0
        for j in range(len(blocks)):
            product = blocks[j] * base + carry
            carry = product // 1000
            new_blocks.append(product % 1000)
        while carry > 0:
            new_blocks.append(carry % 1000)
            carry //= 1000
        blocks = new_blocks

        # Add the current value to the least significant block
        blocks[0] += value
        carry = blocks[0] // 1000
        blocks[0] %= 1000
        j = 1
        while carry > 0:
            if j < len(blocks):
                blocks[j] += carry
                carry = blocks[j] // 1000
                blocks[j] %= 1000
            else:
                blocks.append(carry)
                carry = 0
            j += 1

    # Convert blocks to string
    reversed_blocks = blocks[::-1]
    parts = []
    for i, block in enumerate(reversed_blocks):
        if i == 0:
            parts.append(str(block))
        else:
            parts.append(f"{block:03d}")  # pad blocks with leading zeros
    number_str = "".join(parts)
    number_str = re.sub(r"^0+", "", number_str)
    if number_str == "":
        number_str = "0"
    if sign < 0 and number_str != "0":
        number_str = "-" + number_str
    return number_str

# -----------------------------------------------------------------------------
# Setup: configure_notation
# -----------------------------------------------------------------------------
def configure_notation(new_notation, suffix_map=None):
    """
    Allows customization of the magnitude suffix notation.
    
    new_notation: list of suffix strings to override the default NOTATION.
    suffix_map: optional dict mapping positions (1-indexed) to specific magnitudes.
    """
    global NOTATION, MAX_TIER
    NOTATION = new_notation or NOTATION
    MAX_TIER = len(NOTATION)
    # Rebuild suffix lookup if needed.
    suffix_lookup = {}
    for i, v in enumerate(NOTATION, start=1):
        if v != "":
            suffix_lookup[v.lower()] = suffix_map[i] if (suffix_map and i in suffix_map) else (i - 1) * 3
    return suffix_lookup  # In case the caller wants the lookup.

# -----------------------------------------------------------------------------
# Comparison Helpers
# -----------------------------------------------------------------------------
def is_greater(a, b):
    return compare(a, b) == 1

def is_lesser(a, b):
    return compare(a, b) == -1

def is_equal(a, b):
    return compare(a, b) == 0

def is_greater_or_equal(a, b):
    return compare(a, b) >= 0

def is_lesser_or_equal(a, b):
    return compare(a, b) <= 0
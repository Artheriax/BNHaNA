import math
import re

# Notation table for suffixes used in short notation
from NotationModule import NOTATION
# up to MAX_TIER suffixes for tiers up to 10^{3003}. Define or load the full list from the repository.

POS_INF = {'sign': 1, 'blocks': [], 'magnitude': float('inf'), 'isInf': True}
NEG_INF = {'sign': -1, 'blocks': [], 'magnitude': float('inf'), 'isInf': True}

# Base-90 character set (exactly 90 printable ASCII characters)
CHARACTERS = [
    "0","1","2","3","4","5","6","7","8","9",
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
    "!","#","$","%","&","'","(",")","*","+",".","/",":",";","<","=",">","?","@","[","]","^","_","`","{","}","|","~"
]

MAX_TIER = len(NOTATION)
MAX_SUPPORTED_MAGNITUDE = 3003  # Maximum supported magnitude before infinity

# Performance optimizations: caching built-in functions for faster access (not necessary in Python, but kept for similarity)
math_floor = math.floor
math_abs = math.fabs
math_log10 = math.log10

base = len(CHARACTERS)  # Base-90 encoding

def to_number(num):
    str_ = to_decimal_string(num)
    try:
        return int(str_)
    except ValueError:
        return 0

def to_decimal_string(num):
    if num['isInf']:
        return "Infinity" if num['sign'] > 0 else "-Infinity"
    if len(num['blocks']) == 0:
        return "0"
    parts = []
    for i in range(len(num['blocks']) - 1, -1, -1):
        if i == len(num['blocks']) - 1:
            parts.append(str(num['blocks'][i]))
        else:
            parts.append(f"{num['blocks'][i]:03d}")
    str_ = ''.join(parts)
    str_ = re.sub(r'^0+', '', str_)
    if str_ == '':
        return "0"
    if num['sign'] < 0 and str_ != "0":
        str_ = "-" + str_
    return str_

def normalize_number(num):
    blocks = list(num.get('blocks', []))  # Copy to avoid modifying original
    sign = num.get('sign', 1)
    magnitude = num.get('magnitude')
    # Remove leading zeros
    while len(blocks) > 1 and blocks[-1] == 0:
        blocks.pop()
    if magnitude is None:
        first_non_zero = None
        for i in range(len(blocks) - 1, -1, -1):
            if blocks[i] != 0:
                first_non_zero = i
                break
        if first_non_zero is None:
            magnitude = 1  # Represents zero
        else:
            magnitude = first_non_zero * 3
            abs_val = math_abs(blocks[first_non_zero])
            magnitude += math_floor(math_log10(abs_val)) + 1
    # Check if magnitude exceeds maximum supported range
    if magnitude > MAX_SUPPORTED_MAGNITUDE:
        return POS_INF if sign > 0 else NEG_INF
    return {
        'sign': sign,
        'blocks': blocks,
        'magnitude': magnitude,
        'isInf': False
    }

def compare(a, b):
    if a['isInf'] or b['isInf']:
        if a['isInf'] and b['isInf']:
            return 0 if a['sign'] == b['sign'] else (1 if a['sign'] > b['sign'] else -1)
        return (1 if a['sign'] > 0 else -1) if a['isInf'] else (-1 if b['sign'] > 0 else 1)
    if a['sign'] != b['sign']:
        return 1 if a['sign'] > b['sign'] else -1
    # Compare magnitudes first for efficiency
    if a['magnitude'] != b['magnitude']:
        return (1 if a['magnitude'] > b['magnitude'] else -1) * a['sign']
    len_a, len_b = len(a['blocks']), len(b['blocks'])
    if len_a != len_b:
        return (1 if len_a > len_b else -1) * a['sign']
    for i in range(len_a - 1, -1, -1):
        if a['blocks'][i] != b['blocks'][i]:
            return (1 if a['blocks'][i] > b['blocks'][i] else -1) * a['sign']
    return 0  # They are equal.

def add(a, b):
    # Ensure inputs are normalized
    a = normalize_number(a)
    b = normalize_number(b)
    
    if a['isInf'] or b['isInf']:
        if a['isInf'] and b['isInf']:
            if a['sign'] == b['sign']:
                return a
            else:
                raise ValueError("Undefined: ∞ + -∞")
        return a if a['isInf'] else b
    if a['sign'] != b['sign']:
        b_neg = {'sign': -b['sign'], 'blocks': list(b['blocks']), 'isInf': False}
        return subtract(a, b_neg)
    result = []
    carry = 0
    max_len = max(len(a['blocks']), len(b['blocks']))
    for i in range(max_len):
        sum_ = (a['blocks'][i] if i < len(a['blocks']) else 0) + \
               (b['blocks'][i] if i < len(b['blocks']) else 0) + carry
        carry = math_floor(sum_ / 1000)
        result.append(sum_ % 1000)
    if carry > 0:
        result.append(carry)
    return normalize_number({'sign': a['sign'], 'blocks': result})

def subtract(a, b):
    # Ensure inputs are normalized
    a = normalize_number(a)
    b = normalize_number(b)
    
    if a['isInf'] or b['isInf']:
        if a['isInf'] and b['isInf']:
            if a['sign'] == b['sign']:
                raise ValueError("Undefined: ∞ - ∞")
            else:
                return a
        return a if a['isInf'] else {'sign': -b['sign'], 'blocks': [], 'magnitude': float('inf'), 'isInf': True}
    if a['sign'] != b['sign']:
        b_neg = {'sign': -b['sign'], 'blocks': list(b['blocks']), 'isInf': False}
        return add(a, b_neg)
    abs_a = {'sign': 1, 'blocks': a['blocks'], 'magnitude': a['magnitude'], 'isInf': False}
    abs_b = {'sign': 1, 'blocks': b['blocks'], 'magnitude': b['magnitude'], 'isInf': False}
    abs_compare = compare(abs_a, abs_b)
    if abs_compare < 0:
        result = subtract(b, a)
        result['sign'] = -result['sign']
        return result
    result = []
    borrow = 0
    for i in range(len(a['blocks'])):
        a_val = a['blocks'][i]
        b_val = b['blocks'][i] if i < len(b['blocks']) else 0
        diff = a_val - b_val - borrow
        if diff < 0:
            diff += 1000
            borrow = 1
        else:
            borrow = 0
        result.append(diff)
    return normalize_number({'sign': a['sign'], 'blocks': result})

def multiply(a, b):
    if a['isInf'] or b['isInf']:
        a_is_zero = not a['isInf'] and len(a['blocks']) == 1 and a['blocks'][0] == 0
        b_is_zero = not b['isInf'] and len(b['blocks']) == 1 and b['blocks'][0] == 0
        if a_is_zero or b_is_zero:
            raise ValueError("Undefined: 0 * ∞")
        sign = a['sign'] * b['sign']
        return POS_INF if sign > 0 else NEG_INF
    if (len(a['blocks']) == 1 and a['blocks'][0] == 0) or (len(b['blocks']) == 1 and b['blocks'][0] == 0):
        return normalize_number({'sign': 1, 'blocks': [0]})
    a_len = len(a['blocks'])
    b_len = len(b['blocks'])
    result = [0] * (a_len + b_len)
    for i in range(a_len):
        for j in range(b_len):
            index = i + j
            result[index] += a['blocks'][i] * b['blocks'][j]
    carry = 0
    for k in range(len(result)):
        total = result[k] + carry
        result[k] = total % 1000
        carry = math_floor(total / 1000)
    while carry > 0:
        result.append(carry % 1000)
        carry = math_floor(carry / 1000)
    sign = a['sign'] * b['sign']
    return normalize_number({'sign': sign, 'blocks': result})

def divide(a, b):
    # Handle division by zero
    if len(b['blocks']) == 1 and b['blocks'][0] == 0:
        raise ValueError("Division by zero")
    if b['isInf']:
        return normalize_number({'sign': 1, 'blocks': [0]})
    if a['isInf']:
        sign = a['sign'] * b['sign']
        return POS_INF if sign > 0 else NEG_INF
    # Handle zero dividend
    if len(a['blocks']) == 1 and a['blocks'][0] == 0:
        return normalize_number({'sign': 1, 'blocks': [0]})
    sign = a['sign'] * b['sign']
    abs_a = {'sign': 1, 'blocks': a['blocks'], 'magnitude': a['magnitude'], 'isInf': False}
    abs_b = {'sign': 1, 'blocks': b['blocks'], 'magnitude': b['magnitude'], 'isInf': False}
    # Fast path for |a| < |b|
    if is_lesser(abs_a, abs_b):
        if sign == 1:
            return normalize_number({'sign': 1, 'blocks': [0]})
        else:
            if not is_equal(a, normalize_number({'sign': 1, 'blocks': [0]})):
                return normalize_number({'sign': -1, 'blocks': [1]})  # -1
            else:
                return normalize_number({'sign': 1, 'blocks': [0]})
    # Convert to most-significant-first order
    A = [abs_a['blocks'][i] for i in range(len(abs_a['blocks']) - 1, -1, -1)]
    R = normalize_number({'sign': 1, 'blocks': [0]})  # Remainder
    Q = []  # Quotient digits (most-significant first)
    for i in range(len(A)):
        # Multiply remainder by 1000 and add next digit
        R = multiply(R, normalize_number({'sign': 1, 'blocks': [1000]}))
        R = add(R, normalize_number({'sign': 1, 'blocks': [A[i]]}))
        if is_greater_than_or_equal(R, abs_b):
            # Binary search for quotient digit (0-999)
            low, high = 0, 999
            while low < high:
                mid = math_floor((low + high + 1) / 2)
                mid_bn = normalize_number({'sign': 1, 'blocks': [mid]})
                test = multiply(abs_b, mid_bn)
                if is_greater(test, R):
                    high = mid - 1
                else:
                    low = mid
            q = low
            q_bn = normalize_number({'sign': 1, 'blocks': [q]})
            product = multiply(abs_b, q_bn)
            R = subtract(R, product)
            Q.append(q)
        else:
            Q.append(0)
    # Convert to least-significant-first blocks
    quotient_blocks = [Q[i] for i in range(len(Q) - 1, -1, -1)]
    # Trim trailing zeros (most-significant end)
    while len(quotient_blocks) > 1 and quotient_blocks[-1] == 0:
        quotient_blocks.pop()
    abs_q = normalize_number({'sign': 1, 'blocks': quotient_blocks})
    # Apply sign and adjust for negative division
    if sign == 1:
        return abs_q
    else:
        zero = normalize_number({'sign': 1, 'blocks': [0]})
        if is_equal(R, zero):
            return normalize_number({'sign': -1, 'blocks': abs_q['blocks']})
        else:
            one = normalize_number({'sign': 1, 'blocks': [1]})
            q_value = add(abs_q, one)
            q_value['sign'] = -1
            return q_value

def string_to_number(str_):
    str_ = re.sub(r'[\s,]', '', str_)
    sign = 1
    if str_[0:1] == '-':
        sign = -1
        str_ = str_[1:]
    # Handle infinity explicitly
    if str_.lower() == 'inf' or str_.lower() == 'infinity':
        return POS_INF if sign > 0 else NEG_INF
    # Helper function to convert a digit string to normalized number
    def digits_string_to_normalized(s, sgn):
        s = re.sub(r'^0+', '', s)
        if s == '':
            return normalize_number({'sign': 1, 'blocks': [0]})
        # Check if the string length exceeds our maximum supported magnitude
        if len(s) > MAX_SUPPORTED_MAGNITUDE:
            return POS_INF if sgn > 0 else NEG_INF
        padded = s[::-1]
        padded += '0' * ((3 - len(padded) % 3) % 3)
        blocks = []
        for i in range(0, len(padded), 3):
            chunk = padded[i:i+3][::-1]
            blocks.append(int(chunk))
        return normalize_number({'sign': sgn, 'blocks': blocks})
    # Check for scientific notation (e or E)
    e_match = re.search(r'[eE]', str_)
    if e_match:
        e_index = e_match.start()
        base_part = str_[0:e_index]
        exp_part = str_[e_index + 1:]
        
        match = re.match(r'^(\d*)\.?(\d*)$', base_part)
        if match:
            whole, fractional = match.groups()
        else:
            whole, fractional = '', ''
            
        whole = whole or ''
        fractional = fractional or ''
        combined = whole + fractional
        fractional_digits = len(fractional)
        
        try:
            exponent_value = int(exp_part)
        except ValueError:
            exponent_value = 0
            
        total_exponent = exponent_value - fractional_digits

        # FIX: Handle negative exponents by truncating instead of crashing
        if total_exponent < 0:
            trim_amount = -total_exponent
            if trim_amount >= len(combined):
                return normalize_number({'sign': 1, 'blocks': [0]})
            total_str = combined[:-trim_amount]
        else:
            # Check magnitude limit
            result_magnitude = len(combined) + total_exponent
            if result_magnitude > MAX_SUPPORTED_MAGNITUDE:
                return POS_INF if sign > 0 else NEG_INF
            total_str = combined + '0' * total_exponent
            
        return digits_string_to_normalized(total_str, sign)
    else:
        # Non-scientific notation
        match = re.match(r'^(\d*)\.?(\d*)$', str_)
        if match:
            whole, fractional = match.groups()
        else:
            whole, fractional = '', ''
        whole = whole or ''
        fractional = fractional or ''
        combined = whole + fractional
        return digits_string_to_normalized(combined, sign)

def notation_to_string(str_):
    str_ = re.sub(r'[\s,]', '', str_)
    if not str_: return "0"
    
    sign = '-' if str_[0] == '-' else ''
    if sign: str_ = str_[1:]
        
    # Regex to check for suffix
    match = re.match(r'^([\d\.]+)([a-zA-Z]*)$', str_)
    if not match:
        return sign + str_
    
    number_part, suffix = match.groups()
    
    # If no suffix, treat as a standard number string and remove decimals (integer library)
    if not suffix:
        return sign + number_part.replace('.', '')
    
    suffix = suffix.lower()
    index = None
    for i, s in enumerate(NOTATION):
        if s.lower() == suffix:
            index = i
            break
    if index is None:
        return sign + str_
    exponent = (index) * 3  # Note: Lua is (index - 1) * 3, but if NOTATION[1] = '', index=0 in Python
    match = re.match(r'^(\d*)\.?(\d*)$', number_part)
    if match:
        integer_part, fractional_part = match.groups()
    else:
        integer_part, fractional_part = '', ''
    fractional_part = fractional_part or ''
    fractional_digits = len(fractional_part)
    effective_exponent = exponent - fractional_digits
    combined = (integer_part or '') + fractional_part
    combined = re.sub(r'^0+', '', combined)
    if combined == '':
        return '0'
    if effective_exponent < 0:
        total_digits = len(combined)
        decimal_position = total_digits + effective_exponent
        if decimal_position <= 0:
            combined = '0.' + '0' * (-decimal_position) + combined
        else:
            combined = combined[0:decimal_position] + '.' + combined[decimal_position:]
        combined = re.sub(r'\.?0+$', '', combined)
        if combined[-1:] == '.':
            combined = combined[:-1]
    else:
        combined += '0' * effective_exponent
    return sign + combined

def get_suffix(block_count):
    tier = min(block_count, MAX_TIER)
    return NOTATION[tier - 1] if tier > 0 else ''  # Adjust for 0-index

def format_number(num, decimals):
    if num['isInf']:
        return "Infinity" if num['sign'] > 0 else "-Infinity"
    if len(num['blocks']) == 0 or (num['blocks'][0] == 0 and len(num['blocks']) == 1):
        return "0"
    
    tier = math_floor((num['magnitude'] - 1) / 3) + 1
    if tier > MAX_TIER:
        return "Infinity" if num['sign'] > 0 else "-Infinity"
    
    # Improved precision: Use up to 3 blocks for calculation
    blocks = num['blocks']
    most = blocks[-1]
    next_ = blocks[-2] if len(blocks) >= 2 else 0
    after_next = blocks[-3] if len(blocks) >= 3 else 0
    
    # Combine blocks into a single float for rounding
    value = most + (next_ / 1000) + (after_next / 1000000)
    
    if value >= 1000 and tier < MAX_TIER:
        tier += 1
        value /= 1000
        if tier > MAX_TIER:
            return "Infinity" if num['sign'] > 0 else "-Infinity"

    suffix = NOTATION[tier - 1]
    formatted = f"{value:.{decimals}f}"
    formatted = re.sub(r'\.?0+$', '', formatted)
    formatted = re.sub(r'\.$', '', formatted) 
    return ("-" if num['sign'] < 0 else "") + formatted + (suffix or "")

def get_scientific(num):
    if num['isInf']:
        return "Infinity" if num['sign'] > 0 else "-Infinity"
    if len(num['blocks']) == 0 or (num['blocks'][0] == 0 and len(num['blocks']) == 1):
        return "0"
    magnitude = num['magnitude']
    most_significant_block = num['blocks'][-1] if num['blocks'] else 0
    next_block = num['blocks'][-2] if len(num['blocks']) >= 2 else 0
    # Calculate the leading digits
    leading_value = most_significant_block
    if next_block > 0:
        leading_value += next_block / 1000
    # Adjust for the actual position of the leading digit
    leading_digits = math_floor(math_log10(most_significant_block)) + 1 if most_significant_block > 0 else 1
    exponent = magnitude - 1
    # Format the mantissa
    mantissa = leading_value / (10 ** (leading_digits - 1))
    # Format the result
    sign_str = "-" if num['sign'] < 0 else ""
    formatted = f"{mantissa:.3f}"
    formatted = re.sub(r'\.?0+$', '', formatted)
    formatted = re.sub(r'\.$', '', formatted)
    if exponent == 0:
        return sign_str + formatted
    else:
        return sign_str + formatted + "e" + ("+" if exponent >= 0 else "") + str(exponent)

def get_short(num):
    return format_number(num, 1)

def get_medium(num):
    return format_number(num, 2)

def get_detailed(num):
    return format_number(num, 3)

def encode_number(value):
    num = string_to_number(value)
    # Handle special cases
    if num['isInf']:
        return "∞" if num['sign'] > 0 else "-∞"
    if len(num['blocks']) == 0 or (num['blocks'][0] == 0 and len(num['blocks']) == 1):
        return "0"
    # Pre-allocate result list for better performance
    chars = []
    current = list(num['blocks'])
    # Optimized division by base using cached calculations
    base_cache = {i: {'quotient': math_floor(i / base), 'remainder': i % base} for i in range(1000)}
    while len(current) > 0 and not (len(current) == 1 and current[0] == 0):
        remainder = 0
        new_blocks = []
        has_non_zero = False
        # Process from most significant to least significant
        for i in range(len(current) - 1, -1, -1):
            val = current[i] + remainder * 1000
            if val < 1000 and val in base_cache:
                # Use cached division for small values
                quotient = base_cache[val]['quotient']
                new_remainder = base_cache[val]['remainder']
            else:
                quotient = math_floor(val / base)
                new_remainder = val % base
            remainder = new_remainder
            if quotient > 0 or has_non_zero:
                new_blocks.append(quotient)
                has_non_zero = True
        # Reverse new_blocks to maintain correct order (least to most significant)
        current = new_blocks[::-1]
        chars.append(CHARACTERS[remainder])
    # Reverse chars to get correct order
    result = chars[::-1]
    return ("-" if num['sign'] < 0 else "") + ''.join(result)

def decode_number(encoded_str):
    if encoded_str == "0":
        return "0"
    # Handle infinity
    if encoded_str == "∞":
        return "Infinity"
    elif encoded_str == "-∞":
        return "-Infinity"
    sign = 1
    str_ = encoded_str
    if str_[0:1] == "-":
        sign = -1
        str_ = str_[1:]
        if str_ == "":
            return "0"
    # Pre-compute character lookup dict for O(1) access
    char_lookup = {ch: i for i, ch in enumerate(CHARACTERS)}
    blocks = [0]
    str_len = len(str_)
    for i in range(str_len):
        c = str_[i:i+1]
        value = char_lookup.get(c)
        if value is None:
            raise ValueError(f"Invalid character in encoded string: {c}")
        # Multiply existing blocks by base
        carry = 0
        for j in range(len(blocks)):
            product = blocks[j] * base + carry
            blocks[j] = product % 1000
            carry = math_floor(product / 1000)
        # Add remaining carry
        while carry > 0:
            blocks.append(carry % 1000)
            carry = math_floor(carry / 1000)
        # Add the current digit value
        carry = value
        j = 0
        while carry > 0 and j < len(blocks):
            sum_ = blocks[j] + carry
            blocks[j] = sum_ % 1000
            carry = math_floor(sum_ / 1000)
            j += 1
        if carry > 0:
            blocks.append(carry)
    # Convert blocks to string representation
    parts = []
    for i in range(len(blocks) - 1, -1, -1):
        if i == len(blocks) - 1:
            parts.append(str(blocks[i]))
        else:
            parts.append(f"{blocks[i]:03d}")
    number_str = ''.join(parts)
    number_str = re.sub(r'^0+', '', number_str)
    if number_str == "":
        number_str = "0"
    return ("-" if sign == -1 and number_str != "0" else "") + number_str

def power(base_, exponent):
    base_num = string_to_number(base_) if isinstance(base_, str) else base_
    exp_num = string_to_number(exponent) if isinstance(exponent, str) else exponent
    # Handle special cases
    if base_num['isInf']:
        if exp_num['isInf']:
            raise ValueError("Undefined: ∞^∞")
        is_exp_zero = len(exp_num['blocks']) == 1 and exp_num['blocks'][0] == 0
        if is_exp_zero:
            raise ValueError("Undefined: ∞^0")
        return base_num if exp_num['sign'] > 0 else normalize_number({'sign': 1, 'blocks': [0]})
    if exp_num['isInf']:
        is_base_zero = len(base_num['blocks']) == 1 and base_num['blocks'][0] == 0
        is_base_one = len(base_num['blocks']) == 1 and base_num['blocks'][0] == 1 and base_num['sign'] == 1
        if is_base_zero:
            return base_num if exp_num['sign'] > 0 else POS_INF
        elif is_base_one:
            raise ValueError("Undefined: 1^∞")
        else:
            return POS_INF if exp_num['sign'] > 0 else normalize_number({'sign': 1, 'blocks': [0]})
    # Handle zero exponent
    if len(exp_num['blocks']) == 1 and exp_num['blocks'][0] == 0:
        return normalize_number({'sign': 1, 'blocks': [1]})
    # Handle zero base
    if len(base_num['blocks']) == 1 and base_num['blocks'][0] == 0:
        if exp_num['sign'] > 0:
            return base_num
        else:
            raise ValueError("Division by zero in 0^(-n)")
    # Handle negative exponent (not supported for integers)
    if exp_num['sign'] < 0:
        raise ValueError("Negative exponents not supported for integer arithmetic")
    # Convert exponent to regular number for iteration
    exp_str = to_decimal_string(exp_num)
    try:
        exp_val = int(exp_str)
    except ValueError:
        exp_val = None
    # For very large exponents, return infinity
    if exp_val is None or exp_val > 10000:
        return POS_INF
    # Fast exponentiation by squaring
    result = normalize_number({'sign': 1, 'blocks': [1]})
    current_base = base_num
    while exp_val > 0:
        if exp_val % 2 == 1:
            result = multiply(result, current_base)
            if result['isInf']:
                return result
        current_base = multiply(current_base, current_base)
        if current_base['isInf']:
            return current_base
        exp_val = math_floor(exp_val / 2)
    return result

def modulo(a, b):
    if b['isInf']:
        return a if a['isInf'] else a  # Note: Lua errors on ∞ mod ∞, but simplified here
    if a['isInf']:
        raise ValueError("Undefined: ∞ mod finite")
    # Handle zero divisor
    if len(b['blocks']) == 1 and b['blocks'][0] == 0:
        raise ValueError("Modulo by zero")
    # Handle zero dividend
    if len(a['blocks']) == 1 and a['blocks'][0] == 0:
        return a
    quotient = divide(a, b)
    product = multiply(quotient, b)
    return subtract(a, product)

def abs_(num):
    if num['isInf']:
        return {'sign': 1, 'blocks': [], 'magnitude': float('inf'), 'isInf': True}
    if num['sign'] >= 0:
        return num
    return {
        'sign': 1,
        'blocks': num['blocks'],
        'magnitude': num['magnitude'],
        'isInf': False
    }

def is_greater(a, b):
    return compare(a, b) == 1

def is_lesser(a, b):
    return compare(a, b) == -1

def is_equal(a, b):
    return compare(a, b) == 0

def is_greater_than_or_equal(a, b):
    return compare(a, b) >= 0

def is_lesser_than_or_equal(a, b):
    return compare(a, b) <= 0

def sqrt(num):
    if num['isInf']:
        if num['sign'] > 0:
            return num
        else:
            raise ValueError("Square root of negative infinity")
    if num['sign'] < 0:
        raise ValueError("Square root of negative number")
    if len(num['blocks']) == 1 and num['blocks'][0] == 0:
        return num
    # Newton's method for integer square root
    x = num
    one = normalize_number({'sign': 1, 'blocks': [1]})
    two = normalize_number({'sign': 1, 'blocks': [2]})
    # Initial guess - use magnitude to get closer
    guess_magnitude = math.ceil(num['magnitude'] / 2)
    initial_guess = normalize_number({
        'sign': 1,
        'blocks': [1, 0, 0]  # Start with 1000 and adjust
    })
    # Adjust initial guess based on magnitude
    initial_guess_blocks = initial_guess['blocks']
    for i in range(4, guess_magnitude + 1):
        if len(initial_guess_blocks) < i:
            initial_guess_blocks += [0] * (i - len(initial_guess_blocks))
        initial_guess_blocks[i - 1] = 0
    if len(initial_guess_blocks) < guess_magnitude:
        initial_guess_blocks += [0] * (guess_magnitude - len(initial_guess_blocks))
    initial_guess_blocks[guess_magnitude - 1] = 1
    initial_guess = normalize_number({'sign': 1, 'blocks': initial_guess_blocks})
    x = initial_guess
    for _ in range(100):  # Limit iterations
        quotient = divide(num, x)
        sum_ = add(x, quotient)
        new_x = divide(sum_, two)
        if is_equal(new_x, x):
            break
        x = new_x
    return x

def factorial(num):
    if num['isInf']:
        return POS_INF
    if num['sign'] < 0:
        raise ValueError("Factorial of negative number")
    n_str = to_decimal_string(num)
    try:
        n = int(n_str)
    except ValueError:
        n = None
    if n is None or n > 1000:  # Prevent excessive computation
        return POS_INF
    if n == 0 or n == 1:
        return normalize_number({'sign': 1, 'blocks': [1]})
    result = normalize_number({'sign': 1, 'blocks': [1]})
    current = normalize_number({'sign': 1, 'blocks': [2]})
    for i in range(2, n + 1):
        result = multiply(result, current)
        if result['isInf']:
            return result
        current = add(current, normalize_number({'sign': 1, 'blocks': [1]}))
    return result

def gcd(a, b):
    abs_a = abs_(a)
    abs_b = abs_(b)
    while not (abs_b['isInf'] or (len(abs_b['blocks']) == 1 and abs_b['blocks'][0] == 0)):
        temp = abs_b
        abs_b = modulo(abs_a, abs_b)
        abs_a = temp
    return abs_a

def lcm(a, b):
    gcd_val = gcd(a, b)
    product = multiply(abs_(a), abs_(b))
    return divide(product, gcd_val)

def is_valid_number(str_):
    if not isinstance(str_, str):
        return False
    # Remove whitespace and commas
    str_ = re.sub(r'[\s,]', '', str_)
    # Check for empty string
    if str_ == '':
        return False
    # Check for infinity
    if str_.lower() == 'inf' or str_.lower() == 'infinity' or str_ == '∞':
        return True
    # Handle negative sign
    if str_[0:1] == '-':
        str_ = str_[1:]
        if str_ == '':
            return False
    # Check for scientific notation
    e_match = re.search(r'[eE]', str_)
    if e_match:
        e_index = e_match.start()
        base_part = str_[0:e_index]
        exp_part = str_[e_index + 1:]
        # Validate base part
        if not re.match(r'^\d*\.?\d*$', base_part) or base_part == '' or base_part == '.':
            return False
        # Validate exponent part
        exp_sign = exp_part[0:1]
        if exp_sign in ('+', '-'):
            exp_part = exp_part[1:]
        return re.match(r'^\d+$', exp_part) is not None
    else:
        # Regular decimal notation
        return re.match(r'^\d*\.?\d*$', str_) is not None and str_ != '' and str_ != '.'

def batch_add(numbers):
    if not numbers or len(numbers) == 0:
        return normalize_number({'sign': 1, 'blocks': [0]})
    result = numbers[0]
    for i in range(1, len(numbers)):
        result = add(result, numbers[i])
        if result['isInf']:
            return result
    return result

def batch_multiply(numbers):
    if not numbers or len(numbers) == 0:
        return normalize_number({'sign': 1, 'blocks': [1]})
    result = numbers[0]
    for i in range(1, len(numbers)):
        result = multiply(result, numbers[i])
        if result['isInf']:
            return result
    return result
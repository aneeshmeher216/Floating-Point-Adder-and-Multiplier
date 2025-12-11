# Overview
## Common features (both modules)
* Inputs/outputs follow a simple API: input [31:0] a, input [31:0] b, output [31:0] result.
* IEEE-754 single precision layout used: sign = bit 31, exponent = bits 30:23, fraction = bits 22:0.
* Implicit leading 1 of normalized numbers is added: mantissa = {1'b1, a[22:0]} (24 bits).
* Exponent bias handling: bias = 127 (exp_result = exp_a + exp_b - 127 for multiply).
* Combinational implementation (always @(*)) — outputs computed without clock (zero latency).

**Use of wider intermediate mantissa widths:**
Multiplier: 24 × 24 → 48-bit product.
Adder: 24 + 24 → use 25-bit result to detect carry and normalize.

**Normalization after arithmetic:**
Multiplier: shift right by 1 if MSB=1 then increment exponent.
Adder: shift right on overflow (MSB set) then increment exponent; left-shift for normalization after subtraction (leading zero normalization loop).
Result packing: assign result = {sign_result, exp_result, mantissa_result[<:>]}.

### Multiplier
Computes sign as XOR of inputs.
Computes exponent as sum minus bias.
Multiplies 24-bit mantissas, normalizes if product MSB is at position 47.
Truncates normalized 48-bit mantissa to 23 fraction bits by taking mantissa_result[45:23].

### Adder
Aligns mantissas by right-shifting the smaller exponent mantissa by exponent difference.
Adds or subtracts mantissas depending on sign bits.
Handles equal mantissa cancellation (result zero).
Contains a for-loop to left-shift the mantissa until MSB=1 (normalize) and decrement exponent.
Detects overflow after add and normalizes right shift if needed.


# References
* https://youtu.be/e_J9lXnU_vs?si=0EhrQPXYfjckR96P
* https://digitalsystemdesign.in/floating-point-multiplication/
* https://digitalsystemdesign.in/floating-point-addition-and-subtraction/


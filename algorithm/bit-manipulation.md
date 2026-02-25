## Bit Manipulation

### 1. Single Number & XOR

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0136 | [Single Number](./problems/0136-single-number.md) | [Go](./golang/0136_single_number.go) | _O(n)_       | _O(1)_          | Easy         |||
| 0137 | [Single Number II](./problems/0137-single-number-ii.md) | [Go](./golang/0137_single_number_ii.go) | _O(n)_ | _O(1)_          | Medium         |||
| 0260 | [Single Number III](./problems/0260-single-number-iii.md) | [Go](./golang/0260_single_number_iii.go) | _O(n)_ | _O(1)_          | Medium         ||
| 0371 | [Sum of Two Integers](./problems/0371-sum-of-two-integers.md) | [Go](./golang/0371_sum_of_two_integers.go) | _O(1)_ | _O(1)_ | Easy | LintCode |
| 0389 | [Find the Difference](./problems/0389-find-the-difference.md) | [Go](./golang/0389_find_the_difference.go) | _O(n)_ | _O(1)_ | Easy | |

---

### 2. Power of 2/4 & Bit Check

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0231 | [Power of Two](./problems/0231-power-of-two.md) | [Go](./golang/0231_power_of_two.go) | _O(1)_ | _O(1)_ | Easy | LintCode |
| 0342 | [Power of Four](./problems/0342-power-of-four.md) | [Go](./golang/0342_power_of_four.go) | _O(1)_ | _O(1)_ | Easy | |
| 0693 | [Binary Number with Alternating Bits](./problems/0693-binary-number-with-alternating-bits.md) | [Go](./golang/0693_binary_number_with_alternating_bits.go) | _O(1)_ | _O(1)_ | Easy ||

---

### 3. Count Bits & Hamming

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0191 | [Number of 1 Bits](./problems/0191-number-of-1-bits.md) | [Go](./golang/0191_number_of_1_bits.go) | _O(1)_ | _O(1)_          | Easy           |||
| 0461 | [Hamming Distance](./problems/0461-hamming-distance.md) | [Go](./golang/0461_hamming_distance.go) | _O(1)_ | _O(1)_ | Easy ||
| 0476 | [Number Complement](./problems/0476-number-complement.md) | [Go](./golang/0476_number_complement.go) | _O(1)_       | _O(1)_          | Easy         || Bit Manipulation |
| 0477 | [Total Hamming Distance](./problems/0477-total-hamming-distance.md) | [Go](./golang/0477_total_hamming_distance.go) | _O(n)_ | _O(1)_ | Medium ||
| 0762 | [Prime Number of Set Bits in Binary Representation](./problems/0762-prime-number-of-set-bits-in-binary-representation.md) | [Go](./golang/0762_prime_number_of_set_bits_in_binary_representation.go) | _O(1)_ | _O(1)_ | Easy ||

---

### 4. Range & AND/OR

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0201 | [Bitwise AND of Numbers Range](./problems/0201-bitwise-and-of-numbers-range.md) | [Go](./golang/0201_bitwise_and_of_numbers_range.go) | _O(1)_ | _O(1)_ | Medium ||
| 0898 | [Bitwise ORs of Subarrays](./problems/0898-bitwise-ors-of-subarrays.md) | [Go](./golang/0898_bitwise_ors_of_subarrays.go) | _O(n)_ | _O(1)_ | Medium ||

---

### 5. Reverse & Manipulate Bits

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0190 | [Reverse Bits](./problems/0190-reverse-bits.md) | [Go](./golang/0190_reverse_bits.go) | _O(1)_        | _O(1)_          | Easy           |||

---

### 6. Missing / Mismatch

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0268 | [Missing Number](./problems/0268-missing-number.md) | [Go](./golang/0268_missing_number.go)  | _O(n)_ |  _O(1)_ | Medium         | LintCode ||
| 0645 | [Set Mismatch](./problems/0645-set-mismatch.md) | [Go](./golang/0645_set_mismatch.go) | _O(n)_ | _O(1)_ | Easy ||

---

### 7. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0318 | [Maximum Product of Word Lengths](./problems/0318-maximum-product-of-word-lengths.md) | [Go](./golang/0318_maximum_product_of_word_lengths.go)  | _O(n)_ ~ _O(n^2)_ |  _O(n)_ | Medium         || Bit Manipulation, Counting Sort, Pruning|
| 0393 | [UTF-8 Validation](./problems/0393-utf-8-validation.md) | [Go](./golang/0393_utf_8_validation.go) | _O(n)_ | _O(1)_ | Medium | |
| 0401 | [Binary Watch](./problems/0401-binary-watch.md) | [Go](./golang/0401_binary_watch.go) | _O(1)_ | _O(1)_ | Easy | |
| 0411 | [Minimum Unique Word Abbreviation](./problems/0411-minimum-unique-word-abbreviation.md) | [Go](./golang/0411_minimum_unique_word_abbreviation.go) | _O((d + n) * 2^n)_ | _O(d)_ | Hard | 🔒 |
| 0421 | [Maximum XOR of Two Numbers in an Array](./problems/0421-maximum-xor-of-two-numbers-in-an-array.md) | [Go](./golang/0421_maximum_xor_of_two_numbers_in_an_array.go) | _O(nlogr)_ | _O(t)_ | Medium || Greedy, Trie
| 0868 | [Binary Gap](./problems/0868-binary-gap.md) | [Go](./golang/0868_binary_gap.go) | _O(1)_ | _O(1)_ | Easy ||
| 1310 | [XOR Queries of a Subarray](./problems/1310-xor-queries-of-a-subarray.md) | [Go](./golang/1310_xor_queries_of_a_subarray.go) | _O(n)_ | _O(1)_ | Medium ||
| 1318 | [Minimum Flips to Make a OR b Equal to c](./problems/1318-minimum-flips-to-make-a-or-b-equal-to-c.md) | [Go](./golang/1318_minimum_flips_to_make_a_or_b_equal_to_c.go) | _O(1)_ | _O(1)_ | Medium ||
| 1342 | [Number of Steps to Reduce a Number to Zero](./problems/1342-number-of-steps-to-reduce-a-number-to-zero.md) | [Go](./golang/1342_number_of_steps_to_reduce_a_number_to_zero.go) | _O(logn)_ | _O(1)_ | Easy ||
| 1558 | [Minimum Numbers of Function Calls to Make Target Array](./problems/1558-minimum-numbers-of-function-calls-to-make-target-array.md) | [Go](./golang/1558_minimum_numbers_of_function_calls_to_make_target_array.go) | _O(nlogn)_ | _O(1)_ | Medium || Greedy
| 1707 | [Maximum XOR With an Element From Array](./problems/1707-maximum-xor-with-an-element-from-array.md) | [Go](./golang/1707_maximum_xor_with_an_element_from_array.go) | _O(nlogn + mlogm + nlogk + mlogk)_ | _O(nlogk)_ | Hard | variant of [Maximum XOR of Two Numbers in an Array](https://leetcode.com/problems/maximum-xor-of-two-numbers-in-an-array/) | Greedy, Trie
| 1720 | [Decode XORed Array](./problems/1720-decode-xored-array.md) | [Go](./golang/1720_decode_xored_array.go) | _O(n)_ | _O(1)_ | Easy ||
| 1734 | [Decode XORed Permutation](./problems/1734-decode-xored-permutation.md) | [Go](./golang/1734_decode_xored_permutation.go) | _O(n)_ | _O(1)_ | Medium ||
| 1829 | [Maximum XOR for Each Query](./problems/1829-maximum-xor-for-each-query.md) | [Go](./golang/1829_maximum_xor_for_each_query.go) | _O(n)_ | _O(1)_ | Medium ||
| 2151 | [Maximum Good People Based on Statements](./problems/2151-maximum-good-people-based-on-statements.md) | [Go](./golang/2151_maximum_good_people_based_on_statements.go) | _O(n^2 * 2^n)_ | _O(1)_ | Hard || Bitmasks, Brute Force
| 2212 | [Maximum Points in an Archery Competition](./problems/2212-maximum-points-in-an-archery-competition.md) | [Go](./golang/2212_maximum_points_in_an_archery_competition.go) | _O(n * 2^n)_ | _O(n)_ | Medium || Bitmasks, Brute Force
| 2220 | [Minimum Bit Flips to Convert Number](./problems/2220-minimum-bit-flips-to-convert-number.md) | [Go](./golang/2220_minimum_bit_flips_to_convert_number.go) | _O(logn)_ | _O(1)_ | Easy || Bit Manipulation
| 2275 | [Largest Combination With Bitwise AND Greater Than Zero](./problems/2275-largest-combination-with-bitwise-and-greater-than-zero.md) | [Go](./golang/2275_largest_combination_with_bitwise_and_greater_than_zero.go) | _O(nlogr)_ | _O(logr)_ | Medium || Bit Manipulation, Freq Table
| 2317 | [Maximum XOR After Operations](./problems/2317-maximum-xor-after-operations.md) | [Go](./golang/2317_maximum_xor_after_operations.go) | _O(n)_ | _O(1)_ | Medium || Bit Manipulation, Greedy
| 2397 | [Maximum Rows Covered by Columns](./problems/2397-maximum-rows-covered-by-columns.md) | [Go](./golang/2397_maximum_rows_covered_by_columns.go) | _O(m * n + m * C(n, k))_ | _O(m)_ | Medium || Bitmasks, `Hakmem Item 175`
| 2411 | [Smallest Subarrays With Maximum Bitwise OR](./problems/2411-smallest-subarrays-with-maximum-bitwise-or.md) | [Go](./golang/2411_smallest_subarrays_with_maximum_bitwise_or.go) | _O(n)_ | _O(1)_ | Medium || Bitmasks, Hash Table
| 2419 | [Longest Subarray With Maximum Bitwise AND](./problems/2419-longest-subarray-with-maximum-bitwise-and.md) | [Go](./golang/2419_longest_subarray_with_maximum_bitwise_and.go) | _O(n)_ | _O(1)_ | Medium || Bit Manipulation
| 2425 | [Bitwise XOR of All Pairings](./problems/2425-bitwise-xor-of-all-pairings.md) | [Go](./golang/2425_bitwise_xor_of_all_pairings.go) | _O(n)_ | _O(1)_ | Medium || Bit Manipulation
| 2429 | [Minimize XOR](./problems/2429-minimize-xor.md) | [Go](./golang/2429_minimize_xor.go) | _O(logn)_ | _O(1)_ | Medium || Bit Manipulation, Greedy
| 2505 | [Bitwise OR of All Subsequence Sums](./problems/2505-bitwise-or-of-all-subsequence-sums.md) | [Go](./golang/2505_bitwise_or_of_all_subsequence_sums.go) | _O(n)_ | _O(1)_ | Medium |🔒| Bit Manipulation
| 2527 | [Find Xor-Beauty of Array](./problems/2527-find-xor-beauty-of-array.md) | [Go](./golang/2527_find_xor_beauty_of_array.go) | _O(n)_ | _O(1)_ | Medium | | Bit Manipulation, Math
| 2595 | [Number of Even and Odd Bits](./problems/2595-number-of-even-and-odd-bits.md) | [Go](./golang/2595_number_of_even_and_odd_bits.go) | _O(1)_ | _O(1)_ | Easy | | Bit Manipulation
| 2859 | [Sum of Values at Indices With K Set Bits](./problems/2859-sum-of-values-at-indices-with-k-set-bits.md) | [Go](./golang/2859_sum_of_values_at_indices_with_k_set_bits.go) | _O(C(ceil(log2(n)), k))_ | _O(1)_ | Easy | | Bitmasks, `Hakmem Item 175`
| 2917 | [Find the K-or of an Array](./problems/2917-find-the-k-or-of-an-array.md) | [Go](./golang/2917_find_the_k_or_of_an_array.go) | _O(nlogr)_ | _O(1)_ | Easy | | Bit Manipulation
| 2932 | [Maximum Strong Pair XOR I](./problems/2932-maximum-strong-pair-xor-i.md) | [Go](./golang/2932_maximum_strong_pair_xor_i.go) | _O(nlogr)_ | _O(t)_ | Easy | variant of [Maximum XOR of Two Numbers in an Array](https://leetcode.com/problems/maximum-xor-of-two-numbers-in-an-array/) | Bit Manipulation, Greedy, Trie, DP, Sort, Two Pointers, Brute Force
| 2935 | [Maximum Strong Pair XOR II](./problems/2935-maximum-strong-pair-xor-ii.md) | [Go](./golang/2935_maximum_strong_pair_xor_ii.go) | _O(nlogr)_ | _O(t)_ | Hard | variant of [Maximum XOR of Two Numbers in an Array](https://leetcode.com/problems/maximum-xor-of-two-numbers-in-an-array/) | Bit Manipulation, Greedy, Trie, DP, Sort, Two Pointers
| 2980 | [Check if Bitwise OR Has Trailing Zeros](./problems/2980-check-if-bitwise-or-has-trailing-zeros.md) | [Go](./golang/2980_check_if_bitwise_or_has_trailing_zeros.go) | _O(n)_ | _O(1)_ | Easy | | Bit Manipulation
| 2997 | [Minimum Number of Operations to Make Array XOR Equal to K](./problems/2997-minimum-number-of-operations-to-make-array-xor-equal-to-k.md) | [Go](./golang/2997_minimum_number_of_operations_to_make_array_xor_equal_to_k.go) | _O(n)_ | _O(1)_ | Medium | | Bit Manipulation

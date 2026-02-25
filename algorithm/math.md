## Math

### 1. Integer / Digit

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0007 | [Reverse Integer](./problems/0007-reverse-integer.md) | [Go](./golang/0007_reverse_integer.go) | _O(1)_ | _O(1)_         | Easy           ||
| 0009 | [Palindrome Number](./problems/0009-palindrome-number.md) | [Go](./golang/0009_palindrome_number.go) | _O(1)_ | _O(1)_        | Easy           ||
| 0258 | [Add Digits](./problems/0258-add-digits.md) | [Go](./golang/0258_add_digits.go)  | _O(1)_ | _O(1)_ | Easy         |||
| 0400 | [Nth Digit](./problems/0400-nth-digit.md) | [Go](./golang/0400_nth_digit.go) | _O(logn)_ | _O(1)_ | Easy |||

---

### 2. Roman / Conversion

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0012 | [Integer to Roman](./problems/0012-integer-to-roman.md) | [Go](./golang/0012_integer_to_roman.go) | _O(n)_ | _O(1)_          | Medium         ||
| 0013 | [Roman to Integer](./problems/0013-roman-to-integer.md) | [Go](./golang/0013_roman_to_integer.go) | _O(n)_ | _O(1)_          | Easy           ||
| 0168 | [Excel Sheet Column Title](./problems/0168-excel-sheet-column-title.md) | [Go](./golang/0168_excel_sheet_column_title.go) | _O(logn)_ | _O(1)_ | Easy ||
| 0171 | [Excel Sheet Column Number](./problems/0171-excel-sheet-column-number.md) | [Go](./golang/0171_excel_sheet_column_number.go) | _O(n)_ | _O(1)_ | Easy  ||
| 0504 | [Base 7](./problems/0504-base-7.md) | [Go](./golang/0504_base_7.go) | _O(n1)_       | _O(1)_          | Easy         || Math |
| 1317 | [Convert Integer to the Sum of Two No-Zero Integers](./problems/1317-convert-integer-to-the-sum-of-two-no-zero-integers.md) | [Go](./golang/1317_convert_integer_to_the_sum_of_two_no_zero_integers.go)  | _O(logn)_        | _O(1)_          | Easy         | |

---

### 3. Power / Sqrt

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0050 | [Pow(x, n)](./problems/0050-powx-n.md) | [Go](./golang/0050_powx_n.go)     | _O(logn)_       | _O(1)_       | Medium         ||
| 0326 | [Power of Three](./problems/0326-power-of-three.md) | [Go](./golang/0326_power_of_three.go) | _O(1)_ | _O(1)_ | Easy |||
| 0372 | [Super Pow](./problems/0372-super-pow.md) | [Go](./golang/0372_super_pow.go) | _O(n)_ | _O(1)_ | Medium |||
| 0507 | [Perfect Number](./problems/0507-perfect-number.md) | [Go](./golang/0507_perfect_number.go) | _O(sqrt(n))_       | _O(1)_          | Easy         || Math |
| 0633 | [Sum of Square Numbers](./problems/0633-sum-of-square-numbers.md) | [Go](./golang/0633_sum_of_square_numbers.go) | _O(sqrt(c) * logc)_ | _O(1)_ | Easy |||
| 0829 | [Consecutive Numbers Sum](./problems/0829-consecutive-numbers-sum.md) | [Go](./golang/0829_consecutive_numbers_sum.go) | _O(sqrt(n))_ | _O(1)_ | Hard || Factorization |
| 0970 | [Powerful Integers](./problems/0970-powerful-integers.md) | [Go](./golang/0970_powerful_integers.go) | _O((logn)^2)_ | _O(r)_      | Easy         ||
| 1362 | [Closest Divisors](./problems/1362-closest-divisors.md) | [Go](./golang/1362_closest_divisors.go) | _O(sqrt(n))_ | _O(1)_ |  Medium | |
| 1390 | [Four Divisors](./problems/1390-four-divisors.md) | [Go](./golang/1390_four_divisors.go) | _O(n * sqrt(n))_ | _O(1)_ |  Medium | |
| 1492 | [The kth Factor of n](./problems/1492-the-kth-factor-of-n.md) | [Go](./golang/1492_the_kth_factor_of_n.go) | _O(sqrt(n))_ | _O(1)_ |  Medium | |
| 1735 | [Count Ways to Make Array With Product](./problems/1735-count-ways-to-make-array-with-product.md) | [Go](./golang/1735_count_ways_to_make_array_with_product.go) | _O(sqrt(m) + n + q * (logm + sqrt(m)/log(sqrt(m))))_    | _O(sqrt(m) + n + logm)_ |  Hard | | `Linear Sieve of Eratosthenes`, Factorization, Combinatorics
| 1780 | [Check if Number is a Sum of Powers of Three](./problems/1780-check-if-number-is-a-sum-of-powers-of-three.md) | [Go](./golang/1780_check_if_number_is_a_sum_of_powers_of_three.go) | _O(logn)_ | _O(1)_ |  Medium | |
| 1806 | [Minimum Number of Operations to Reinitialize a Permutation](./problems/1806-minimum-number-of-operations-to-reinitialize-a-permutation.md) | [Go](./golang/1806_minimum_number_of_operations_to_reinitialize_a_permutation.go) | _O(sqrt(n))_ | _O(sqrt(n))_ |  Medium | | Discrete Logarithm, Multiplicative Order
| 1952 | [Three Divisors](./problems/1952-three-divisors.md) | [Go](./golang/1952_three_divisors.go) | _O(sqrt(n))_ | _O(1)_ |  Easy |  | |
| 2176 | [Count Equal and Divisible Pairs in an Array](./problems/2176-count-equal-and-divisible-pairs-in-an-array.md) |[Go](./golang/2176_count_equal_and_divisible_pairs_in_an_array.go)| _O(nlogk + n * sqrt(k))_     | _O(n + sqrt(k))_         | Easy         | | Math
| 2183 | [Count Array Pairs Divisible by K](./problems/2183-count-array-pairs-divisible-by-k.md) |[Go](./golang/2183_count_array_pairs_divisible_by_k.go)| _O(nlogk + k)_     | _O(sqrt(k))_         | Hard         | variant of [Count Equal and Divisible Pairs in an Array](https://leetcode.com/problems/count-equal-and-divisible-pairs-in-an-array/) | Math
| 2240 | [Number of Ways to Buy Pens and Pencils](./problems/2240-number-of-ways-to-buy-pens-and-pencils.md) |[Go](./golang/2240_number_of_ways_to_buy_pens_and_pencils.go)| _O(sqrt(t))_     | _O(1)_         | Medium         || Math
| 2338 | [Count the Number of Ideal Arrays](./problems/2338-count-the-number-of-ideal-arrays.md) | [Go](./golang/2338_count_the_number_of_ideal_arrays.go) | _O(sqrt(m) + n + m * (logm + sqrt(m)/log(sqrt(m))))_    | _O(sqrt(m) + n + logm)_          | Hard           | variant of [Count Ways to Make Array With Product](https://leetcode.com/problems/count-ways-to-make-array-with-product/) | DP, `Linear Sieve of Eratosthenes`, Factorization, Combinatorics
| 2427 | [Number of Common Factors](./problems/2427-number-of-common-factors.md) | [Go](./golang/2427_number_of_common_factors.go) | _O(log(min(a, b)) + sqrt(gcd))_   | _O(1)_        | Easy         | | Math
| 2521 | [Distinct Prime Factors of Product of Array](./problems/2521-distinct-prime-factors-of-product-of-array.md) | [Go](./golang/2521_distinct_prime_factors_of_product_of_array.go) | precompute: _O(sqrt(MAX_N))_<br>runtime: _O(m + nlog(logn))_   | _O(sqrt(MAX_N))_        | Medium         | | Number Theory, `Linear Sieve of Eratosthenes`
| 2584 | [Split the Array to Make Coprime Products](./problems/2584-split-the-array-to-make-coprime-products.md) | [Go](./golang/2584_split_the_array_to_make_coprime_products.go) | _O(n * sqrt(r))_   | _O(sqrt(r))_        | Hard         | | Math, Number Theory
| 2778 | [Sum of Squares of Special Elements](./problems/2778-sum-of-squares-of-special-elements.md) | [Go](./golang/2778_sum_of_squares_of_special_elements.go)| _O(sqrt(n))_ | _O(1)_ | Easy | | Number Theory |
| 2999 | [Count the Number of Powerful Integers](./problems/2999-count-the-number-of-powerful-integers.md) | [Go](./golang/2999_count_the_number_of_powerful_integers.go) | _O(logf)_ | _O(1)_ | Hard || Math, Combinatorics |

---

### 4. Geometry / Rectangle

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0223 | [Rectangle Area](./problems/0223-rectangle-area.md) | [Go](./golang/0223_rectangle_area.go)  | _O(1)_ | _O(1)_ | Easy         ||
| 0391 | [Perfect Rectangle](./problems/0391-perfect-rectangle.md) | [Go](./golang/0391_perfect_rectangle.go) | _O(n)_ | _O(n)_ | Hard | |
| 0492 | [Construct the Rectangle](./problems/0492-construct-the-rectangle.md) | [Go](./golang/0492_construct_the_rectangle.go) | _O(1)_       | _O(1)_          | Easy         || Math |
| 0497 | [Random Point in Non-overlapping Rectangles](./problems/0497-random-point-in-non-overlapping-rectangles.md) | [Go](./golang/0497_random_point_in_non_overlapping_rectangles.go) | ctor: _O(n)_ <br> pick: _O(logn)_ | _O(n)_ | Medium |||
| 0812 | [Largest Triangle Area](./problems/0812-largest-triangle-area.md) | [Go](./golang/0812_largest_triangle_area.go) | _O(n^3)_ | _O(1)_ | Easy |||
| 0836 | [Rectangle Overlap](./problems/0836-rectangle-overlap.md) | [Go](./golang/0836_rectangle_overlap.go) | _O(1)_ | _O(1)_ | Easy |||
| 0883 | [Projection Area of 3D Shapes](./problems/0883-projection-area-of-3d-shapes.md) | [Go](./golang/0883_projection_area_of_3d_shapes.go) | _O(n^2)_ | _O(1)_ | Easy |||
| 0963 | [Minimum Area Rectangle II](./problems/0963-minimum-area-rectangle-ii.md) | [Go](./golang/0963_minimum_area_rectangle_ii.go) | _O(n^2)_ ~ _O(n^3)_ | _O(n^2)_      | Medium         ||
| 1401 | [Circle and Rectangle Overlapping](./problems/1401-circle-and-rectangle-overlapping.md) | [Go](./golang/1401_circle_and_rectangle_overlapping.go) | _O(1)_ | _O(1)_ |  Medium | |
| 2001 | [Number of Pairs of Interchangeable Rectangles](./problems/2001-number-of-pairs-of-interchangeable-rectangles.md) |[Go](./golang/2001_number_of_pairs_of_interchangeable_rectangles.go)| _O(n)_     | _O(n)_         | Medium         | | Math |

---

### 5. Random / Probability

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0382 | [Linked List Random Node](./problems/0382-linked-list-random-node.md) | [Go](./golang/0382_linked_list_random_node.go) | ctor: _O(n)_<br>getRandom: _O(1)_ | _O(n)_ | Medium || `Reservoir Sampling` |
| 0398 | [Random Pick Index](./problems/0398-random-pick-index.md) | [Go](./golang/0398_random_pick_index.go) | ctor: _O(n)_<br>pick: _O(1)_ | _O(n)_ | Medium || `Reservoir Sampling`, Hash Table |
| 0470 | [Implement Rand10() Using Rand7()](./problems/0470-implement-rand10-using-rand7.md) | [Go](./golang/0470_implement_rand10_using_rand7.go) | _O(1)_ | _O(1)_ | Medium |||
| 0478 | [Generate Random Point in a Circle](./problems/0478-generate-random-point-in-a-circle.md) | [Go](./golang/0478_generate_random_point_in_a_circle.go) | _O(1)_ | _O(1)_ | Medium |||
| 0519 | [Random Flip Matrix](./problems/0519-random-flip-matrix.md) | [Go](./golang/0519_random_flip_matrix.go) | ctor: _O(1)_ <br> pick: _O(1)_ reset: _O(n)_ | _O(n)_ | Medium |||
| 0528 | [Random Pick with Weight](./problems/0528-random-pick-with-weight.md) | [Go](./golang/0528_random_pick_with_weight.go) | ctor: _O(n)_ <br> pick: _O(logn)_ | _O(n)_ | Medium |||
| 1227 | [Airplane Seat Assignment Probability](./problems/1227-airplane-seat-assignment-probability.md) | [Go](./golang/1227_airplane_seat_assignment_probability.go) | _O(1)_ | _O(1)_ | Medium |||

---

### 6. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0029 | [Divide Two Integers](./problems/0029-divide-two-integers.md) | [Go](./golang/0029_divide_two_integers.go)    | _O(1)_       | _O(1)_         | Medium         ||
| 0060 | [Permutation Sequence](./problems/0060-permutation-sequence.md) | [Go](./golang/0060_permutation_sequence.go) | _O(n^2)_ | _O(n)_  | Medium         || `Cantor Ordering`
| 0065 | [Valid Number](./problems/0065-valid-number.md) | [Go](./golang/0065_valid_number.go) | _O(n)_         | _O(1)_          | Hard           || `Automata`
| 0089 | [Gray Code](./problems/0089-gray-code.md) | [Go](./golang/0089_gray_code.go)  | _O(2^n)_        | _O(1)_          | Medium         ||
| 0166 | [Fraction to Recurring Decimal](./problems/0166-fraction-to-recurring-decimal.md) | [Go](./golang/0166_fraction_to_recurring_decimal.go)  | _O(logn)_ | _O(1)_ | Medium         ||
| 0172 | [Factorial Trailing Zeroes](./problems/0172-factorial-trailing-zeroes.md) | [Go](./golang/0172_factorial_trailing_zeroes.go)  | _O(1)_ | _O(1)_ | Easy         ||
| 0233 | [Number of Digit One](./problems/0233-number-of-digit-one.md) | [Go](./golang/0233_number_of_digit_one.go)  | _O(1)_ | _O(1)_ | Hard        | CTCI, LintCode|
| 0248 | [Strobogrammatic Number III](./problems/0248-strobogrammatic-number-iii.md) | [Go](./golang/0248_strobogrammatic_number_iii.go)  | _O(5^(n/2))_ | _O(n)_ | Hard         |🔒||
| 0263 | [Ugly Number](./problems/0263-ugly-number.md) | [Go](./golang/0263_ugly_number.go)  | _O(1)_ | _O(1)_ | Easy         |||
| 0292 | [Nim Game](./problems/0292-nim-game.md) | [Go](./golang/0292_nim_game.go)  | _O(1)_ | _O(1)_ | Easy         | LintCode ||
| 0319 | [Bulb Switcher](./problems/0319-bulb-switcher.md) | [Go](./golang/0319_bulb_switcher.go) | _O(1)_ | _O(1)_ | Medium |||
| 0335 | [Self Crossing](./problems/0335-self-crossing.md) | [Go](./golang/0335_self_crossing.go) | _O(n)_ | _O(1)_ | Hard |||
| 0338 | [Counting Bits](./problems/0338-counting-bits.md) | [Go](./golang/0338_counting_bits.go) | _O(n)_ | _O(n)_ | Medium |||
| 0343 | [Integer Break](./problems/0343-integer-break.md) | [Go](./golang/0343_integer_break.go) | _O(logn)_ | _O(1)_ | Medium || Tricky, DP |
| 0365 | [Water and Jug Problem](./problems/0365-water-and-jug-problem.md) | [Go](./golang/0365_water_and_jug_problem.go) | _O(logn)_ | _O(1)_ | Medium || `Bézout's identity` |
| 0386 | [Lexicographical Numbers](./problems/0386-lexicographical-numbers.md) | [Go](./golang/0386_lexicographical_numbers.go) | _O(n)_ | _O(1)_ | Medium |||
| 0390 | [Elimination Game](./problems/0390-elimination-game.md) | [Go](./golang/0390_elimination_game.go) | _O(logn)_ | _O(1)_ | Medium ||
| 0413 | [Arithmetic Slices](./problems/0413-arithmetic-slices.md) | [Go](./golang/0413_arithmetic_slices.go) | _O(n)_ | _O(1)_ | Medium |||
| 0423 | [Reconstruct Original Digits from English](./problems/0423-reconstruct-original-digits-from-english.md) | [Go](./golang/0423_reconstruct_original_digits_from_english.go) | _O(n)_ | _O(1)_ | Medium | [GCJ2016 - Round 1B](https://code.google.com/codejam/contest/11254486/dashboard#s=p0)||
| 0441 | [Arranging Coins](./problems/0441-arranging-coins.md) | [Go](./golang/0441_arranging_coins.go) | _O(nlogn)_ | _O(1)_ | Easy || Binary Search|
| 0453 | [Minimum Moves to Equal Array Elements](./problems/0453-minimum-moves-to-equal-array-elements.md) | [Go](./golang/0453_minimum_moves_to_equal_array_elements.go) | _O(n)_ | _O(1)_ | Easy |||
| 0458 | [Poor Pigs](./problems/0458-poor-pigs.md) | [Go](./golang/0458_poor_pigs.go) | _O(n)_ | _O(1)_ | Easy |||
| 0469 | [Convex Polygon](./problems/0469-convex-polygon.md) | [Go](./golang/0469_convex_polygon.go) | _O(n)_ | _O(1)_ | Medium |🔒||
| 0479 | [Largest Palindrome Product](./problems/0479-largest-palindrome-product.md) | [Go](./golang/0479_largest_palindrome_product.go) | _O(n * 10^N)_       | _O(n)_          | Hard         || Math |
| 0483 | [Smallest Good Base](./problems/0483-smallest-good-base.md) | [Go](./golang/0483_smallest_good_base.go) | _O(logn * log(logn))_       | _O(1)_          | Hard         || Math |
| 0517 | [Super Washing Machines](./problems/0517-super-washing-machines.md) | [Go](./golang/0517_super_washing_machines.go) | _O(n)_ | _O(1)_ | Hard |||
| 0537 | [Complex Number Multiplication](./problems/0537-complex-number-multiplication.md) | [Go](./golang/0537_complex_number_multiplication.go) | _O(1)_ | _O(1)_ | Medium |||
| 0553 | [Optimal Division](./problems/0553-optimal-division.md) | [Go](./golang/0553_optimal_division.go) | _O(n)_ | _O(1)_ | Medium |||
| 0573 | [Squirrel Simulation](./problems/0573-squirrel-simulation.md) | [Go](./golang/0573_squirrel_simulation.go) | _O(n)_ | _O(1)_ | Medium |🔒||
| 0592 | [Fraction Addition and Subtraction](./problems/0592-fraction-addition-and-subtraction.md) | [Go](./golang/0592_fraction_addition_and_subtraction.go) | _O(nlogx)_ | _O(n)_ | Medium |||
| 0593 | [Valid Square](./problems/0593-valid-square.md) | [Go](./golang/0593_valid_square.go) | _O(1)_ | _O(1)_ | Medium |||
| 0598 | [Range Addition II](./problems/0598-range-addition-ii.md) | [Go](./golang/0598_range_addition_ii.go) | _O(p)_ | _O(1)_ | Easy |||
| 0625 | [Minimum Factorization](./problems/0625-minimum-factorization.md) | [Go](./golang/0625_minimum_factorization.go) | _O(loga)_ | _O(1)_ | Medium |🔒||
| 0628 | [Maximum Product of Three Numbers](./problems/0628-maximum-product-of-three-numbers.md) | [Go](./golang/0628_maximum_product_of_three_numbers.go) | _O(n)_ | _O(1)_ | Easy |||
| 0634 | [Find the Derangement of An Array](./problems/0634-find-the-derangement-of-an-array.md) | [Go](./golang/0634_find_the_derangement_of_an_array.go) | _O(n)_ | _O(1)_ | Medium |🔒||
| 0640 | [Solve the Equation](./problems/0640-solve-the-equation.md) | [Go](./golang/0640_solve_the_equation.go) | _O(n)_ | _O(n)_ | Medium || |
| 0651 | [4 Keys Keyboard](./problems/0651-4-keys-keyboard.md) | [Go](./golang/0651_4_keys_keyboard.go) | _O(1)_ | _O(1)_ | Medium |🔒| Math, DP |
| 0660 | [Remove 9](./problems/0660-remove-9.md) | [Go](./golang/0660_remove_9.go) | _O(logn)_ | _O(1)_ | Hard |🔒||
| 0672 | [Bulb Switcher II](./problems/0672-bulb-switcher-ii.md) | [Go](./golang/0672_bulb_switcher_ii.go) | _O(1)_ | _O(1)_ | Medium |||
| 0728 | [Self Dividing Numbers](./problems/0728-self-dividing-numbers.md) | [Go](./golang/0728_self_dividing_numbers.go) | _O(n)_ | _O(1)_ | Medium |||
| 0754 | [Reach a Number](./problems/0754-reach-a-number.md) | [Go](./golang/0754_reach_a_number.go) | _O(logn)_ | _O(1)_ | Medium |||
| 0775 | [Global and Local Inversions](./problems/0775-global-and-local-inversions.md) | [Go](./golang/0775_global_and_local_inversions.go) | _O(n)_ | _O(1)_ | Medium |||
| 0779 | [K-th Symbol in Grammar](./problems/0779-k-th-symbol-in-grammar.md) | [Go](./golang/0779_k_th_symbol_in_grammar.go) | _O(1)_ | _O(1)_ | Medium ||
| 0780 | [Reaching Points](./problems/0780-reaching-points.md) | [Go](./golang/0780_reaching_points.go) | _O(log(max(m, n)))_ | _O(1)_ | Hard ||
| 0781 | [Rabbits in Forest](./problems/0781-rabbits-in-forest.md) | [Go](./golang/0781_rabbits_in_forest.go) | _O(n)_ | _O(n)_ | Medium ||
| 0782 | [Transform to Chessboard](./problems/0782-transform-to-chessboard.md) | [Go](./golang/0782_transform_to_chessboard.go) | _O(n^2)_ | _O(n)_ | Hard ||
| 0789 | [Escape The Ghosts](./problems/0789-escape-the-ghosts.md) | [Go](./golang/0789_escape_the_ghosts.go) | _O(n)_ | _O(1)_ | Medium ||
| 0800 | [Similar RGB Color](./problems/0800-similar-rgb-color.md) | [Go](./golang/0800_similar_rgb_color.go) | _O(1)_ | _O(1)_ | Easy |🔒||
| 0810 | [Chalkboard XOR Game](./problems/0810-chalkboard-xor-game.md) | [Go](./golang/0810_chalkboard_xor_game.go) | _O(1)_ | _O(1)_ | Hard |||
| 0858 | [Mirror Reflection](./problems/0858-mirror-reflection.md) | [Go](./golang/0858_mirror_reflection.go) | _O(1)_ | _O(1)_ | Medium |||
| 0866 | [Prime Palindrome](./problems/0866-prime-palindrome.md) | [Go](./golang/0866_prime_palindrome.go) | _O(n^(1/2) * (logn + n^(1/2)))_ | _O(logn)_ | Medium |||
| 0887 | [Super Egg Drop](./problems/0887-super-egg-drop.md) | [Go](./golang/0887_super_egg_drop.go) | _O(klogn)_ | _O(1)_ | Hard |||
| 0891 | [Sum of Subsequence Widths](./problems/0891-sum-of-subsequence-widths.md) | [Go](./golang/0891_sum_of_subsequence_widths.go) | _O(n)_ | _O(1)_ | Hard |||
| 0899 | [Orderly Queue](./problems/0899-orderly-queues.md) | [Go](./golang/0899_orderly_queues.go) | _O(n^2)_ | _O(n)_ | Hard |||
| 0902 | [Numbers At Most N Given Digit Set](./problems/0902-numbers-at-most-n-given-digit-set.md) | [Go](./golang/0902_numbers_at_most_n_given_digit_set.go) | _O(logn)_ | _O(logn)_ | Hard |||
| 0906 | [Super Palindromes](./problems/0906-super-palindromes.md) | [Go](./golang/0906_super_palindromes.go) | _O(n^0.25 * logn)_ | _O(logn)_ | Hard |||
| 0907 | [Sum of Subarray Minimums](./problems/0907-sum-of-subarray-minimums.md) | [Go](./golang/0907_sum_of_subarray_minimums.go) | _O(n)_ | _O(n)_ | Medium || Mono Stack |
| 0908 | [Smallest Range I](./problems/0908-smallest-range-i.md) | [Go](./golang/0908_smallest_range_i.go) | _O(n)_ | _O(1)_      | Easy         ||
| 0910 | [Smallest Range II](./problems/0910-smallest-range-ii.md) | [Go](./golang/0910_smallest_range_ii.go) | _O(nlogn)_ | _O(1)_      | Medium         ||
| 0914 | [X of a Kind in a Deck of Cards](./problems/0914-x-of-a-kind-in-a-deck-of-cards.md) | [Go](./golang/0914_x_of_a_kind_in_a_deck_of_cards.go) | _O(n * (logn)^2)_ | _O(n)_      | Easy         ||
| 0972 | [Equal Rational Numbers](./problems/0972-equal-rational-numbers.md) | [Go](./golang/0972_equal_rational_numbers.go) | _O(1)_ | _O(1)_      | Hard         ||
| 1006 | [Clumsy Factorial](./problems/1006-clumsy-factorial.md) | [Go](./golang/1006_clumsy_factorial.go) | _O(1)_ | _O(1)_      | Medium         ||
| 1009 | [Complement of Base 10 Integer](./problems/1009-complement-of-base-10-integer.md) | [Go](./golang/1009_complement_of_base_10_integer.go) | _O(logn)_ | _O(1)_      | Easy         ||
| 1012 | [Numbers With Repeated Digits](./problems/1012-numbers-with-repeated-digits.md) | [Go](./golang/1012_numbers_with_repeated_digits.go) | _O(logn)_ | _O(logn)_      | Hard         ||
| 1015 | [Smallest Integer Divisible by K](./problems/1015-smallest-integer-divisible-by-k.md) | [Go](./golang/1015_smallest_integer_divisible_by_k.go) | _O(k)_ | _O(1)_      | Medium         ||
| 1017 | [Convert to Base -2](./problems/1017-convert-to-base-2.md) | [Go](./golang/1017_convert_to_base_2.go) | _O(logn)_ | _O(1)_      | Medium         ||
| 1025 | [Divisor Game](./problems/1025-divisor-game.md) | [Go](./golang/1025_divisor_game.go) | _O(1)_ | _O(1)_      | Easy         || DP
| 1037 | [Valid Boomerang](./problems/1037-valid-boomerang.md) | [Go](./golang/1037_valid_boomerang.go) | _O(1)_ | _O(1)_      | Easy         ||
| 1041 | [Robot Bounded In Circle](./problems/1041-robot-bounded-in-circle.md) | [Go](./golang/1041_robot_bounded_in_circle.go) | _O(n)_ | _O(1)_      | Medium         ||
| 1067 | [Digit Count in Range](./problems/1067-digit-count-in-range.md) | [Go](./golang/1067_digit_count_in_range.go)  | _O(logn)_ | _O(1)_ | Hard        | 🔒, variant of [Number of Digit One](https://leetcode.com/problems/number-of-digit-one/) |
| 1073 | [Adding Two Negabinary Numbers](./problems/1073-adding-two-negabinary-numbers.md) | [Go](./golang/1073_adding_two_negabinary_numbers.go) | _O(n)_ | _O(n)_      | Medium         ||
| 1079 | [Letter Tile Possibilities](./problems/1079-letter-tile-possibilities.md) | [Go](./golang/1079_letter_tile_possibilities.go) | _O(n^2)_ | _O(n)_      | Medium         || Generating Function, Backtracking
| 1088 | [Confusing Number II](./problems/1088-confusing-number-ii.md) | [Go](./golang/1088_confusing_number_ii.go) | _O(logn)_ | _O(logn)_ |  Hard | 🔒 |
| 1103 | [Distribute Candies to People](./problems/1103-distribute-candies-to-people.md) | [Go](./golang/1103_distribute_candies_to_people.go) | _O(n + logc)_ | _O(1)_ |  Easy | | Binary Search
| 1118 | [Number of Days in a Month](./problems/1118-number-of-days-in-a-month.md) | [Go](./golang/1118_number_of_days_in_a_month.go) | _O(1)_ | _O(1)_ |  Easy | 🔒 |
| 1121 | [Divide Array Into Increasing Sequences](./problems/1121-divide-array-into-increasing-sequences.md) | [Go](./golang/1121_divide_array_into_increasing_sequences.go) | _O(n)_ | _O(1)_ |  Hard | 🔒 |
| 1128 | [Number of Equivalent Domino Pairs](./problems/1128-number-of-equivalent-domino-pairs.md) | [Go](./golang/1128_number_of_equivalent_domino_pairs.go) | _O(n)_ | _O(n)_ |  Easy ||
| 1131 | [Maximum of Absolute Value Expression](./problems/1131-maximum-of-absolute-value-expression.md) | [Go](./golang/1131_maximum_of_absolute_value_expression.go) | _O(n)_ | _O(1)_ |  Medium ||
| 1134 | [Armstrong Number](./problems/1134-armstrong-number.md) | [Go](./golang/1134_armstrong_number.go) | _O(klogk)_ | _O(k)_ |  Easy | 🔒 |
| 1150 | [Check If a Number Is Majority Element in a Sorted Array](./problems/1150-check-if-a-number-is-majority-element-in-a-sorted-array.md) | [Go](./golang/1150_check_if_a_number_is_majority_element_in_a_sorted_array.go) | _O(nlogn)_ | _O(1)_ |  Easy |🔒| Binary Search
| 1154 | [Day of the Year](./problems/1154-day-of-the-year.md) | [Go](./golang/1154_day_of_the_year.go) | _O(1)_ | _O(1)_ |  Easy ||
| 1157 | [Online Majority Element In Subarray](./problems/1157-online-majority-element-in-subarray.md) | [Go](./golang/1157_online_majority_element_in_subarray.go) | ctor: _O(n)_<br>query: _O(klogn)_ | _O(n)_ |  Hard || Binary Search, Segment Tree, `Boyer–Moore Majority Vote Algorithm`
| 1175 | [Prime Arrangements](./problems/1175-prime-arrangements.md) | [Go](./golang/1175_prime_arrangements.go) | _O(nlog(logn))_ | _O(n)_ |  Easy || `Sieve of Eratosthenes`
| 1185 | [Day of the Week](./problems/1185-day-of-the-week.md) | [Go](./golang/1185_day_of_the_week.go) | _O(1)_ | _O(1)_ |  Easy || `Zeller Formula`
| 1197 | [Minimum Knight Moves](./problems/1197-minimum-knight-moves.md) | [Go](./golang/1197_minimum_knight_moves.go) | _O(1)_ | _O(1)_ | Medium |🔒| DP, Math |
| 1217 | [Play with Chips](./problems/1217-play-with-chips.md) | [Go](./golang/1217_play_with_chips.go) | _O(n)_ | _O(1)_ | Medium |||
| 1232 | [Check If It Is a Straight Line](./problems/1232-check-if-it-is-a-straight-line.md) | [Go](./golang/1232_check_if_it_is_a_straight_line.go) | _O(1)_ | _O(1)_ | Easy |||
| 1237 | [Find Positive Integer Solution for a Given Equation](./problems/1237-find-positive-integer-solution-for-a-given-equation.md) | [Go](./golang/1237_find_positive_integer_solution_for_a_given_equation.go) | _O(n)_ | _O(1)_ | Easy |||
| 1238 | [Circular Permutation in Binary Representation](./problems/1238-circular-permutation-in-binary-representation.md) | [Go](./golang/1238_circular_permutation_in_binary_representation.go)  | _O(2^n)_        | _O(1)_          | Medium         | variant of [Gray Code](https://leetcode.com/problems/gray-code/) |
| 1250 | [Check If It Is a Good Array](./problems/1250-check-if-it-is-a-good-array.md) | [Go](./golang/1250_check_if_it_is_a_good_array.go) | _O(n)_ | _O(1)_ | Hard || `Bézout's identity` |
| 1256 | [Encode Number](./problems/1256-encode-number.md) | [Go](./golang/1256_encode_number.go)  | _O(logn)_        | _O(1)_          | Medium         | |
| 1259 | [Handshakes That Don't Cross](./problems/1259-handshakes-that-dont-cross.md) | [Go](./golang/1259_handshakes_that_dont_cross.go)  | _O(n)_        | _O(1)_          | Hard         | | `Catalan Number`, DP
| 1266 | [Minimum Time Visiting All Points](./problems/1266-minimum-time-visiting-all-points.md) | [Go](./golang/1266_minimum_time_visiting_all_points.go)  | _O(n)_        | _O(1)_          | Easy         | |
| 1276 | [Number of Burgers with No Waste of Ingredients](./problems/1276-number-of-burgers-with-no-waste-of-ingredients.md) | [Go](./golang/1276_number_of_burgers_with_no_waste_of_ingredients.go)  | _O(1)_        | _O(1)_          | Medium         | |
| 1281 | [Subtract the Product and Sum of Digits of an Integer](./problems/1281-subtract-the-product-and-sum-of-digits-of-an-integer.md) | [Go](./golang/1281_subtract_the_product_and_sum_of_digits_of_an_integer.go)  | _O(logn)_        | _O(1)_          | Easy         | |
| 1300 | [Sum of Mutated Array Closest to Target](./problems/1300-sum-of-mutated-array-closest-to-target.md) | [Go](./golang/1300_sum_of_mutated_array_closest_to_target.go)  | _O(nlogn)_        | _O(1)_          | Medium         | | Binary Search
| 1323 | [Maximum 69 Number](./problems/1323-maximum-69-number.md) | [Go](./golang/1323_maximum_69_number.go)  | _O(logn)_        | _O(1)_          | Easy         | |
| 1330 | [Reverse Subarray To Maximize Array Value](./problems/1330-reverse-subarray-to-maximize-array-value.md) | [Go](./golang/1330_reverse_subarray_to_maximize_array_value.go)  | _O(n)_        | _O(1)_          | Hard         | |
| 1344 | [Angle Between Hands of a Clock](./problems/1344-angle-between-hands-of-a-clock.md) | [Go](./golang/1344_angle_between_hands_of_a_clock.go)  | _O(1)_        | _O(1)_          | Medium         | |
| 1359 | [Count All Valid Pickup and Delivery Options](./problems/1359-count-all-valid-pickup-and-delivery-options.md) | [Go](./golang/1359_count_all_valid_pickup_and_delivery_options.go)  | _O(n)_        | _O(1)_          | Hard         | |
| 1360 | [Number of Days Between Two Dates](./problems/1360-number-of-days-between-two-dates.md) | [Go](./golang/1360_number_of_days_between_two_dates.go) | _O(1)_ | _O(1)_ |  Easy | variant of [Day of the Year](https://leetcode.com/problems/day-of-the-year/) |
| 1363 | [Largest Multiple of Three](./problems/1363-largest-multiple-of-three.md) | [Go](./golang/1363_largest_multiple_of_three.go) | _O(n)_ | _O(1)_ |  Hard | |
| 1415 | [The k-th Lexicographical String of All Happy Strings of Length n](./problems/1415-the-k-th-lexicographical-string-of-all-happy-strings-of-length-n.md) | [Go](./golang/1415_the_k_th_lexicographical_string_of_all_happy_strings_of_length_n.go) | _O(n)_ | _O(1)_ |  Medium | |
| 1442 | [Count Triplets That Can Form Two Arrays of Equal XOR](./problems/1442-count-triplets-that-can-form-two-arrays-of-equal-xor.md) | [Go](./golang/1442_count_triplets_that_can_form_two_arrays_of_equal_xor.go) | _O(n)_ | _O(n)_ |  Medium | |
| 1447 | [Simplified Fractions](./problems/1447-simplified-fractions.md) | [Go](./golang/1447_simplified_fractions.go) | _O(n^2 * logn)_ | _O(n^2)_ |  Medium | |
| 1486 | [XOR Operation in an Array](./problems/1486-xor-operation-in-an-array.md) | [Go](./golang/1486_xor_operation_in_an_array.go) | _O(1)_ | _O(1)_ |  Easy | |
| 1497 | [Check If Array Pairs Are Divisible by k](./problems/1497-check-if-array-pairs-are-divisible-by-k.md) | [Go](./golang/1497_check_if_array_pairs_are_divisible_by_k.go) | _O(n)_ | _O(k)_ |  Medium | |
| 1512 | [Number of Good Pairs](./problems/1512-number-of-good-pairs.md) | [Go](./golang/1512_number_of_good_pairs.go) | _O(n)_ | _O(1)_ |  Easy | |
| 1513 | [Number of Substrings With Only 1s](./problems/1513-number-of-substrings-with-only-1s.md) | [Go](./golang/1513_number_of_substrings_with_only_1s.go) | _O(n)_ | _O(1)_ |  Medium | |
| 1525 | [Number of Good Ways to Split a String](./problems/1525-number-of-good-ways-to-split-a-string.md) | [Go](./golang/1525_number_of_good_ways_to_split_a_string.go) | _O(n)_ | _O(1)_ |  Medium | |
| 1537 | [Get the Maximum Score](./problems/1537-get-the-maximum-score.md) | [Go](./golang/1537_get_the_maximum_score.go) | _O(m + n)_ | _O(1)_ |  Hard | |
| 1551 | [Minimum Operations to Make Array Equal](./problems/1551-minimum-operations-to-make-array-equal.md) | [Go](./golang/1551_minimum_operations_to_make_array_equal.go) | _O(1)_ | _O(1)_ |  Medium | |
| 1611 | [Minimum One Bit Operations to Make Integers Zero](./problems/1611-minimum-one-bit-operations-to-make-integers-zero.md) | [Go](./golang/1611_minimum_one_bit_operations_to_make_integers_zero.go)  | _O(logn)_        | _O(1)_          | Hard         | variant of [Gray Code](https://leetcode.com/problems/gray-code/) |
| 1641 | [Count Sorted Vowel Strings](./problems/1641-count-sorted-vowel-strings.md) | [Go](./golang/1641_count_sorted_vowel_strings.go) | _O(1)_ | _O(1)_ |  Medium | | Binomial Coefficients
| 1643 | [Kth Smallest Instructions](./problems/1643-kth-smallest-instructions.md) | [Go](./golang/1643_kth_smallest_instructions.go) | _O((m + n)^2)_ | _O(1)_ |  Hard | | Binomial Coefficients
| 1739 | [Building Boxes](./problems/1739-building-boxes.md) | [Go](./golang/1739_building_boxes.go) | _O(1)_ | _O(1)_ |  Hard | |
| 1744 | [Can You Eat Your Favorite Candy on Your Favorite Day?](./problems/1744-can-you-eat-your-favorite-candy-on-your-favorite-day.md) | [Go](./golang/1744_can_you_eat_your_favorite_candy_on_your_favorite_day.go) | _O(n)_ | _O(n)_ |  Medium | | Prefix Sum
| 1753 | [Maximum Score From Removing Stones](./problems/1753-maximum-score-from-removing-stones.md) | [Go](./golang/1753_maximum_score_from_removing_stones.go) | _O(1)_ | _O(1)_ |  Medium | |
| 1776 | [Car Fleet II](./problems/1776-car-fleet-ii.md) | [Go](./golang/1776_car_fleet_ii.go) | _O(n)_ | _O(n)_ |  Hard | | Mono Stack
| 1808 | [Maximize Number of Nice Divisors](./problems/1808-maximize-number-of-nice-divisors.md) | [Go](./golang/1808_maximize_number_of_nice_divisors.go) | _O(logn)_ | _O(1)_ |  Medium | variant of [Integer Break](https://leetcode.com/problems/integer-break/)  |
| 1812 | [Determine Color of a Chessboard Square](./problems/1812-determine-color-of-a-chessboard-square.md) | [Go](./golang/1812_determine_color_of_a_chessboard_square.go) | _O(1)_ | _O(1)_ |  Easy |  |
| 1819 | [Number of Different Subsequences GCDs](./problems/1819-number-of-different-subsequences-gcds.md) | [Go](./golang/1819_number_of_different_subsequences_gcds.go) | _O(n + mlogm)_ | _O(n)_ |  Hard |  |
| 1822 | [Sign of the Product of an Array](./problems/1822-sign-of-the-product-of-an-array.md) | [Go](./golang/1822_sign_of_the_product_of_an_array.go) | _O(n)_ | _O(1)_ |  Easy |  |
| 1823 | [Find the Winner of the Circular Game](./problems/1823-find-the-winner-of-the-circular-game.md) | [Go](./golang/1823_find_the_winner_of_the_circular_game.go) | _O(n)_ | _O(1)_ |  Medium |  |
| 1828 | [Queries on Number of Points Inside a Circle](./problems/1828-queries-on-number-of-points-inside-a-circle.md) | [Go](./golang/1828_queries_on_number_of_points_inside_a_circle.go) | _O(q * n)_ | _O(1)_ |  Medium |  |
| 1830 | [Minimum Number of Operations to Make String Sorted](./problems/1830-minimum-number-of-operations-to-make-string-sorted.md) | [Go](./golang/1830_minimum_number_of_operations_to_make_string_sorted.go) | _O(n)_ | _O(max_n)_ |  Hard |  | Modular Inverse |
| 1835 | [Find XOR Sum of All Pairs Bitwise AND](./problems/1835-find-xor-sum-of-all-pairs-bitwise-and.md) | [Go](./golang/1835_find_xor_sum_of_all_pairs_bitwise_and.go) | _O(n)_ | _O(1)_ |  Hard |  | |
| 1837 | [Sum of Digits in Base K](./problems/1837-sum-of-digits-in-base-k.md) | [Go](./golang/1837_sum_of_digits_in_base_k.go) | _O(logn)_ | _O(1)_ |  Easy |  | |
| 1860 | [Incremental Memory Leak](./problems/1860-incremental-memory-leak.md) | [Go](./golang/1860_incremental_memory_leak.go) | _O(1)_ | _O(1)_ |  Medium | [GCJ2020 - Round 2](https://codingcompetitions.withgoogle.com/codejam/round/000000000019ffb9/00000000003384ea) | |
| 1862 | [Sum of Floored Pairs](./problems/1862-sum-of-floored-pairs.md) | [Go](./golang/1862_sum_of_floored_pairs.go) | _O(nlogn)_ | _O(n)_ |  Hard |  | |
| 1863 | [Sum of All Subset XOR Totals](./problems/1863-sum-of-all-subset-xor-totals.md) | [Go](./golang/1863_sum_of_all_subset_xor_totals.go) | _O(n)_ | _O(1)_ |  Easy |  | |
| 1884 | [Egg Drop With 2 Eggs and N Floors](./problems/1884-egg-drop-with-2-eggs-and-n-floors.md) | [Go](./golang/1884_egg_drop_with_2_eggs_and_n_floors.go) | _O(1)_ | _O(1)_ |  Medium |  | DP |
| 1904 | [The Number of Full Rounds You Have Played](./problems/1904-the-number-of-full-rounds-you-have-played.md) | [Go](./golang/1904_the_number_of_full_rounds_you_have_played.go) | _O(1)_ | _O(1)_ |  Medium |  | |
| 1916 | [Count Ways to Build Rooms in an Ant Colony](./problems/1916-count-ways-to-build-rooms-in-an-ant-colony.md) | [Go](./golang/1916_count_ways_to_build_rooms_in_an_ant_colony.go) | _O(n)_ | _O(n)_ |  Hard |  | DFS, Tree |
| 1922 | [Count Good Numbers](./problems/1922-count-good-numbers.md) | [Go](./golang/1922_count_good_numbers.go) | _O(logn)_ | _O(1)_ |  Medium |  | |
| 1945 | [Sum of Digits of String After Convert](./problems/1945-sum-of-digits-of-string-after-convert.md) | [Go](./golang/1945_sum_of_digits_of_string_after_convert.go) | _O(n)_ | _O(1)_ |  Easy |  | |
| 1954 | [Minimum Garden Perimeter to Collect Enough Apples](./problems/1954-minimum-garden-perimeter-to-collect-enough-apples.md) | [Go](./golang/1954_minimum_garden_perimeter_to_collect_enough_apples.go) | _O(1)_ | _O(1)_ |  Medium |  | Binary Search, `Cardano's Formula` |
| 1969 | [Minimum Non-Zero Product of the Array Elements](./problems/1969-minimum-non-zero-product-of-the-array-elements.md) | [Go](./golang/1969_minimum_non_zero_product_of_the_array_elements.go) | _O(min(p, logM))_ | _O(1)_ |  Medium |  | |
| 1979 | [Find Greatest Common Divisor of Array](./problems/1979-find-greatest-common-divisor-of-array.md) | [Go](./golang/1979_find_greatest_common_divisor_of_array.go) | _O(n)_ | _O(1)_ |  Easy |  | |
| 1980 | [Find Unique Binary String](./problems/1980-find-unique-binary-string.md) | [Go](./golang/1980_find_unique_binary_string.go) | _O(n)_ | _O(1)_ |  Medium |  | `Cantor Diagonalization` |
| 1982 | [Find Array Given Subset Sums](./problems/1982-find-array-given-subset-sums.md) |[Go](./golang/1982_find_array_given_subset_sums.go)| _O(n * 2^n)_     | _O(1)_         | Hard         | | Math, DP, OrderedDict |
| 2005 | [Subtree Removal Game with Fibonacci Tree](./problems/2005-subtree-removal-game-with-fibonacci-tree.md) |[Go](./golang/2005_subtree_removal_game_with_fibonacci_tree.go)| _O(1)_     | _O(1)_         | Hard         |🔒| Math, `Sprague-Grundy Theorem`, `Colon Principle` |
| 2028 | [Find Missing Observations](./problems/2028-find-missing-observations.md) |[Go](./golang/2028_find_missing_observations.go)| _O(n)_     | _O(1)_         | Medium         | | |
| 2029 | [Stone Game IX](./problems/2029-stone-game-ix.md) |[Go](./golang/2029_stone_game_ix.go)| _O(n)_     | _O(1)_         | Medium         | |
| 2063 | [Vowels of All Substrings](./problems/2063-vowels-of-all-substrings.md) |[Go](./golang/2063_vowels_of_all_substrings.go)| _O(n)_     | _O(1)_         | Medium         | | Combinatorics
| 2073 | [Time Needed to Buy Tickets](./problems/2073-time-needed-to-buy-tickets.md) |[Go](./golang/2073_time_needed_to_buy_tickets.go)| _O(n)_     | _O(1)_         | Easy         | | Simulation, Math
| 2083 | [Substrings That Begin and End With the Same Letter](./problems/2083-substrings-that-begin-and-end-with-the-same-letter.md) |[Go](./golang/2083_substrings_that_begin_and_end_with_the_same_letter.go)| _O(n)_     | _O(1)_         | Medium         | 🔒 | Combinatorics
| 2091 | [Removing Minimum and Maximum From Array](./problems/2091-removing-minimum-and-maximum-from-array.md) |[Go](./golang/2091_removing_minimum_and_maximum_from_array.go)| _O(n)_     | _O(1)_         | Medium         | | Math
| 2110 | [Number of Smooth Descent Periods of a Stock](./problems/2110-number-of-smooth-descent-periods-of-a-stock.md) |[Go](./golang/2110_number_of_smooth_descent_periods_of_a_stock.go)| _O(n)_     | _O(1)_         | Medium         | | Math, Combinatorics
| 2117 | [Abbreviating the Product of a Range](./problems/2117-abbreviating-the-product-of-a-range.md) |[Go](./golang/2117_abbreviating_the_product_of_a_range.go)| _O(r - l)_     | _O(1)_         | Hard         | | Math
| 2119 | [A Number After a Double Reversal](./problems/2119-a-number-after-a-double-reversal.md) |[Go](./golang/2119_a_number_after_a_double_reversal.go)| _O(1)_     | _O(1)_         | Easy         | | Math
| 2125 | [Number of Laser Beams in a Bank](./problems/2125-number-of-laser-beams-in-a-bank.md) |[Go](./golang/2125_number_of_laser_beams_in_a_bank.go)| _O(m * n)_     | _O(1)_         | Medium         | | Math
| 2133 | [Check if Every Row and Column Contains All Numbers](./problems/2133-check-if-every-row-and-column-contains-all-numbers.md) |[Go](./golang/2133_check_if_every_row_and_column_contains_all_numbers.go)| _O(n^2)_     | _O(n)_         | Easy         | | Math
| 2145 | [Count the Hidden Sequences](./problems/2145-count-the-hidden-sequences.md) |[Go](./golang/2145_count_the_hidden_sequences.go)| _O(n)_     | _O(1)_         | Medium         | | Math
| 2148 | [Count Elements With Strictly Smaller and Greater Elements](./problems/2148-count-elements-with-strictly-smaller-and-greater-elements.md) |[Go](./golang/2148_count_elements_with_strictly_smaller_and_greater_elements.go)| _O(n)_     | _O(1)_         | Easy         | | Math
| 2152 | [Minimum Number of Lines to Cover Points](./problems/2152-minimum-number-of-lines-to-cover-points.md) |[Go](./golang/2152_minimum_number_of_lines_to_cover_points.go)| _O(n * 2^n)_     | _O(n^2)_         | Medium         | 🔒 | Math, Hash Table, Bitmasks
| 2169 | [Count Operations to Obtain Zero](./problems/2169-count-operations-to-obtain-zero.md) |[Go](./golang/2169_count_operations_to_obtain_zero.go)| _O(log(min(m, n)))_     | _O(1)_         | Easy         | | Math, `Euclidean Algorithm`
| 2171 | [Removing Minimum Number of Magic Beans](./problems/2171-removing-minimum-number-of-magic-beans.md) |[Go](./golang/2171_removing_minimum_number_of_magic_beans.go)| _O(nlogn)_     | _O(1)_         | Medium         | | Math, Sort
| 2177 | [Find Three Consecutive Integers That Sum to a Given Number](./problems/2177-find-three-consecutive-integers-that-sum-to-a-given-number.md) |[Go](./golang/2177_find_three_consecutive_integers_that_sum_to_a_given_number.go)| _O(1)_     | _O(1)_         | Medium         | | Math
| 2180 | [Count Integers With Even Digit Sum](./problems/2180-count-integers-with-even-digit-sum.md) |[Go](./golang/2180_count_integers_with_even_digit_sum.go)| _O(logn)_     | _O(1)_         | Easy         | | Math
| 2198 | [Number of Single Divisor Triplets](./problems/2198-number-of-single-divisor-triplets.md) |[Go](./golang/2198_number_of_single_divisor_triplets.go)| _O(d^3)_     | _O(d)_         | Medium         | 🔒 | Math, Combinatorics
| 2217 | [Find Palindrome With Fixed Length](./problems/2217-find-palindrome-with-fixed-length.md) |[Go](./golang/2217_find_palindrome_with_fixed_length.go)| _O(n * l)_     | _O(1)_         | Medium         || Math
| 2221 | [Find Triangular Sum of an Array](./problems/2221-find-triangular-sum-of-an-array.md) |[Go](./golang/2221_find_triangular_sum_of_an_array.go)| _O(n)_     | _O(1)_         | Medium         || Simulation, Combinatorics, Number Thoery
| 2235 | [Add Two Integers](./problems/2235-add-two-integers.md) |[Go](./golang/2235_add_two_integers.go)| _O(1)_     | _O(1)_         | Easy         || Math
| 2244 | [Minimum Rounds to Complete All Tasks](./problems/2244-minimum-rounds-to-complete-all-tasks.md) |[Go](./golang/2244_minimum_rounds_to_complete_all_tasks.go)| _O(n)_     | _O(n)_         | Medium         || Math, Freq Table
| 2249 | [Count Lattice Points Inside a Circle](./problems/2249-count-lattice-points-inside-a-circle.md) |[Go](./golang/2249_count_lattice_points_inside_a_circle.go)| _O(n * r^2)_     | _O(min(n * r^2, max_x * max_y))_         | Medium         || Math, Hash Table
| 2262 | [Total Appeal of A String](./problems/2262-total-appeal-of-a-string.md) |[Go](./golang/2262_total_appeal_of_a_string.go)| _O(n)_     | _O(26)_         | Hard         | variant of [Count Unique Characters of All Substrings of a Given String](https://leetcode.com/problems/count-unique-characters-of-all-substrings-of-a-given-string/) | Combinatorics
| 2280 | [Minimum Lines to Represent a Line Chart](./problems/2280-minimum-lines-to-represent-a-line-chart.md) |[Go](./golang/2280_minimum_lines_to_represent_a_line_chart.go)| _O(nlogn)_     | _O(1)_         | Medium         | | Sort, Math, GCD
| 2310 | [Sum of Numbers With Units Digit K](./problems/2310-sum-of-numbers-with-units-digit-k.md) |[Go](./golang/2310_sum_of_numbers_with_units_digit_k.go)| _O(1)_     | _O(1)_         | Medium         | | Math
| 2344 | [Minimum Deletions to Make Array Divisible](./problems/2344-minimum-deletions-to-make-array-divisible.md) |[Go](./golang/2344_minimum_deletions_to_make_array_divisible.go)| _O(n + m + logr)_     | _O(1)_         | Hard         | | Math, GCD
| 2345 | [Finding the Number of Visible Mountains](./problems/2345-finding-the-number-of-visible-mountains.md) |[Go](./golang/2345_finding_the_number_of_visible_mountains.go)| _O(nlogn)_     | _O(1)_         | Medium         | 🔒 | Math, Sort, Mono Stack
| 2376 | [Count Special Integers](./problems/2376-count-special-integers.md) |[Go](./golang/2376_count_special_integers.go)| _O(logn)_     | _O(logn)_         | Hard         | variant of [Numbers With Repeated Digits](https://leetcode.com/problems/numbers-with-repeated-digits/) | Combinatorics
| 2396 | [Strictly Palindromic Number](./problems/2396-strictly-palindromic-number.md) |[Go](./golang/2396_strictly_palindromic_number.go)| _O(1)_     | _O(1)_         | Medium         || Math
| 2400 | [Number of Ways to Reach a Position After Exactly k Steps](./problems/2400-number-of-ways-to-reach-a-position-after-exactly-k-steps.md) |[Go](./golang/2400_number_of_ways_to_reach_a_position_after_exactly_k_steps.go)| _O(k)_     | _O(k)_         | Medium         || Combinatorics
| 2409 | [Count Days Spent Together](./problems/2409-count-days-spent-together.md) | [Go](./golang/2409_count_days_spent_together.go) | _O(1)_   | _O(1)_        | Easy         | | String, Math, Prefix Sum
| 2413 | [Smallest Even Multiple](./problems/2413-smallest-even-multiple.md) | [Go](./golang/2413_smallest_even_multiple.go) | _O(1)_   | _O(1)_        | Easy         | | Math, Bit Manipulation
| 2437 | [Number of Valid Clock Times](./problems/2437-number-of-valid-clock-times.md) | [Go](./golang/2437_number_of_valid_clock_times.go) | _O(1)_   | _O(1)_        | Easy         | | Combinatorics
| 2450 | [Number of Distinct Binary Strings After Applying Operations](./problems/2450-number-of-distinct-binary-strings-after-applying-operations.md) | [Go](./golang/2450_number_of_distinct_binary_strings_after_applying_operations.go) | _O(logn)_   | _O(1)_        | Medium         | 🔒 | Combinatorics
| 2455 | [Average Value of Even Numbers That Are Divisible by Three](./problems/2455-average-value-of-even-numbers-that-are-divisible-by-three.md) | [Go](./golang/2455_average_value_of_even_numbers_that_are_divisible_by_three.go) | _O(n)_   | _O(1)_        | Easy         | | Math
| 2468 | [Split Message Based on Limit](./problems/2468-split-message-based-on-limit.md) | [Go](./golang/2468_split_message_based_on_limit.go) | _O(n + rlogr)_   | _O(1)_        | Hard         | | Brute Force, Math
| 2469 | [Convert the Temperature](./problems/2469-convert-the-temperature.md) | [Go](./golang/2469_convert_the_temperature.go) | _O(1)_   | _O(1)_        | Easy         | | Math
| 2481 | [Minimum Cuts to Divide a Circle](./problems/2481-minimum-cuts-to-divide-a-circle.md) | [Go](./golang/2481_minimum_cuts_to_divide_a_circle.go) | _O(1)_   | _O(1)_        | Easy         | | Math
| 2485 | [Find the Pivot Integer](./problems/2485-find-the-pivot-integer.md) | [Go](./golang/2485_find_the_pivot_integer.go) | _O(1)_   | _O(1)_        | Easy         | | Math
| 2514 | [Count Anagrams](./problems/2514-count-anagrams.md) | [Go](./golang/2514_count_anagrams.go) | _O(n)_   | _O(n)_        | Hard         | | Math, Combinatorics
| 2520 | [Count the Digits That Divide a Number](./problems/2520-count-the-digits-that-divide-a-number.md) | [Go](./golang/2520_count_the_digits_that_divide_a_number.go) | _O(logn)_   | _O(1)_        | Easy         | | Math
| 2523 | [Closest Prime Numbers in Range](./problems/2523-closest-prime-numbers-in-range.md) | [Go](./golang/2523_closest_prime_numbers_in_range.go) | precompute: _O(MAX_N * log(MAX_N))_<br>runtime: _O(log(MAX_N))_   | _O(MAX_N)_        | Medium         | | Number Theory, `Linear Sieve of Eratosthenes`, Segment Tree
| 2525 | [Categorize Box According to Criteria](./problems/2525-categorize-box-according-to-criteria.md) | [Go](./golang/2525_categorize_box_according_to_criteria.go) | _O(1)_   | _O(1)_        | Easy         | | Math
| 2539 | [Count the Number of Good Subsequences](./problems/2539-count-the-number-of-good-subsequences.md) | [Go](./golang/2539_count_the_number_of_good_subsequences.go) | _O(26 * n)_   | _O(n)_        | Medium         | 🔒 | Combinatorics
| 2543 | [Check if Point Is Reachable](./problems/2543-check-if-point-is-reachable.md) | [Go](./golang/2543_check_if_point_is_reachable.go) | _O(log(min(a, b)))_   | _O(1)_        | Hard         | | Number Theory
| 2544 | [Alternating Digit Sum](./problems/2544-alternating-digit-sum.md) | [Go](./golang/2544_alternating_digit_sum.go) | _O(logn)_   | _O(1)_        | Easy         | | Math
| 2549 | [Count Distinct Numbers on Board](./problems/2549-count-distinct-numbers-on-board.md) | [Go](./golang/2549_count_distinct_numbers_on_board.go) | _O(1)_   | _O(1)_        | Easy         | | Math
| 2550 | [Count Collisions of Monkeys on a Polygon](./problems/2550-count-collisions-of-monkeys-on-a-polygon.md) | [Go](./golang/2550_count_collisions_of_monkeys_on_a_polygon.go) | _O(logn)_   | _O(1)_        | Medium         | | Combinatorics, Fast Exponentiation
| 2562 | [Find the Array Concatenation Value](./problems/2562-find-the-array-concatenation-value.md) | [Go](./golang/2562_find_the_array_concatenation_value.go) | _O(nlogr)_   | _O(1)_        | Easy         | | Math
| 2568 | [Minimum Impossible OR](./problems/2568-minimum-impossible-or.md) | [Go](./golang/2568_minimum_impossible_or.go) | _O(logr)_   | _O(1)_        | Medium         | | Math, Hash Table, Bit Manipulations
| 2579 | [Count Total Number of Colored Cells](./problems/2579-count-total-number-of-colored-cells.md) | [Go](./golang/2579_count_total_number_of_colored_cells.go) | _O(1)_   | _O(1)_        | Medium         | | Math
| 2582 | [Pass the Pillow](./problems/2582-pass-the-pillow.md) | [Go](./golang/2582_pass_the_pillow.go) | _O(1)_   | _O(1)_        | Medium         | | Math
| 2614 | [Prime In Diagonal](./problems/2614-prime-in-diagonal.md) | [Go](./golang/2614_prime_in_diagonal.go)| precompute: _O(MAX_N)_<br>runtime: _O(n)_ | _O(MAX_N)_ | Easy | | Number Theory, `Linear Sieve of Eratosthenes` |
| 2651 | [Calculate Delayed Arrival Time](./problems/2651-calculate-delayed-arrival-time.md) | [Go](./golang/2651_calculate_delayed_arrival_time.go) | _O(1)_   | _O(1)_        | Easy         | | Math
| 2652 | [Sum Multiples](./problems/2652-sum-multiples.md) | [Go](./golang/2652_sum_multiples.go) | _O(1)_   | _O(1)_        | Easy         | | Math, Principle of Inclusion and Exclusion
| 2656 | [Maximum Sum With Exactly K Elements](./problems/2656-maximum-sum-with-exactly-k-elements.md) | [Go](./golang/2656_maximum_sum_with_exactly_k_elements.go) | _O(n)_   | _O(1)_        | Easy         | | Math
| 2731 | [Movement of Robots](./problems/2731-movement-of-robots.md) | [Go](./golang/2731_movement_of_robots.go) | _O(nlogn)_   | _O(1)_        | Medium         | | Sort, Math
| 2739 | [Total Distance Traveled](./problems/2739-total-distance-traveled.md) | [Go](./golang/2739_total_distance_traveled.go) | _O(1)_   | _O(1)_        | Easy         | | Math
| 2749 | [Minimum Operations to Make the Integer Zero](./problems/2749-minimum-operations-to-make-the-integer-zero.md) | [Go](./golang/2749_minimum_operations_to_make_the_integer_zero.go) | _O(1)_   | _O(1)_        | Medium         | | Linear Search, Bit Manipulations, Math
| 2750 | [Ways to Split Array Into Good Subarrays](./problems/2750-ways-to-split-array-into-good-subarrays.md) | [Go](./golang/2750_ways_to_split_array_into_good_subarrays.go) | _O(n)_   | _O(1)_        | Medium         | | Combinatorics
| 2761 | [Prime Pairs With Target Sum](./problems/2761-prime-pairs-with-target-sum.md) | [Go](./golang/2761_prime_pairs_with_target_sum.go)| _O(n)_ | _O(n)_ | Medium | | Number Theory, `Linear Sieve of Eratosthenes` |
| 2780 | [Minimum Index of a Valid Split](./problems/2780-minimum-index-of-a-valid-split.md) | [Go](./golang/2780_minimum_index_of_a_valid_split.go)| _O(n)_ | _O(1)_ | Medium | | `Boyer–Moore Majority Vote Algorithm`, Linear Search |
| 2802 | [Find The K-th Lucky Number](./problems/2802-find-the-k-th-lucky-number.md) | [Go](./golang/2802_find_the_k_th_lucky_number.go)| _O(logn)_ | _O(1)_ | Medium | 🔒 | Math, Bitmasks |
| 2806 | [Account Balance After Rounded Purchase](./problems/2806-account-balance-after-rounded-purchase.md) | [Go](./golang/2806_account_balance_after_rounded_purchase.go)| _O(1)_ | _O(1)_ | Easy | | Math |
| 2833 | [Furthest Point From Origin](./problems/2833-furthest-point-from-origin.md) | [Go](./golang/2833_furthest_point_from_origin.go)| _O(1)_ | _O(1)_ | Easy | | Math |
| 2861 | [Maximum Number of Alloys](./problems/2861-maximum-number-of-alloys.md) | [Go](./golang/2861_maximum_number_of_alloys.go) | _O(k * nlogn)_ | _O(n)_ | Medium | | Binary Search, Sort, Math |
| 2862 | [Maximum Element-Sum of a Complete Subset of Indices](./problems/2862-maximum-element-sum-of-a-complete-subset-of-indices.md) | [Go](./golang/2862_maximum_element_sum_of_a_complete_subset_of_indices.go)| _O(n)_ | _O(n)_ | Hard | | Number Theory, `Basel Problem` |
| 2894 | [Divisible and Non-divisible Sums Difference](./problems/2894-divisible-and-non-divisible-sums-difference.md) | [Go](./golang/2894_divisible_and_non_divisible_sums_difference.go) | _O(1)_ | _O(1)_ | Easy | | Math |
| 2898 | [Maximum Linear Stock Score](./problems/2898-maximum-linear-stock-score.md) | [Go](./golang/2898_maximum_linear_stock_score.go) | _O(n)_ | _O(n)_ | Medium | 🔒 | Math, Freq Table |
| 2927 | [Distribute Candies Among Children III](./problems/2927-distribute-candies-among-children-iii.md) | [Go](./golang/2927_distribute_candies_among_children_iii.go) | _O(1)_ | _O(1)_ | Hard | 🔒 | Stars and Bars, Combinatorics, Principle of Inclusion and Exclusion |
| 2928 | [Distribute Candies Among Children I](./problems/2928-distribute-candies-among-children-i.md) | [Go](./golang/2928_distribute_candies_among_children_i.go) | _O(1)_ | _O(1)_ | Easy | | Stars and Bars, Combinatorics, Principle of Inclusion and Exclusion, Brute Force |
| 2929 | [Distribute Candies Among Children II](./problems/2929-distribute-candies-among-children-ii.md) | [Go](./golang/2929_distribute_candies_among_children_ii.go) | _O(1)_ | _O(1)_ | Medium | | Stars and Bars, Combinatorics, Principle of Inclusion and Exclusion, Brute Force |
| 2930 | [Number of Strings Which Can Be Rearranged to Contain Substring](./problems/2930-number-of-strings-which-can-be-rearranged-to-contain-substring.md) | [Go](./golang/2930_number_of_strings_which_can_be_rearranged_to_contain_substring.go) | _O(1)_ | _O(1)_ | Medium | | Combinatorics, Principle of Inclusion and Exclusion, Bitmasks, DP |
| 2954 | [Count the Number of Infection Sequences](./problems/2954-count-the-number-of-infection-sequences.md) | [Go](./golang/2954_count_the_number_of_infection_sequences.go) | precompute: _O(max_n)_<br>runtime: _O(s + logn)_ | _O(max_n)_ | Hard | | Combinatorics |
| 2961 | [Double Modular Exponentiation](./problems/2961-double-modular-exponentiation.md) | [Go](./golang/2961_double_modular_exponentiation.go) | _O(n * (logb + logc))_ | _O(1)_ | Medium | | Fast Exponentiation |
| 2963 | [Count the Number of Good Partitions](./problems/2963-count-the-number-of-good-partitions.md) | [Go](./golang/2963_count_the_number_of_good_partitions.go) | _O(n)_ | _O(n)_ | Hard | | Hash Table, Combinatorics |
| 2979 | [Most Expensive Item That Can Not Be Bought](./problems/2979-most-expensive-item-that-can-not-be-bought.md) | [Go](./golang/2979_most_expensive_item_that_can_not_be_bought.go) | _O(1)_ | _O(1)_ | Medium | 🔒 | `Frobenius Coin Problem`, `Chicken McNugget Theorem`, DP |

## Backtracking

### 1. Combination / Subset

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0017 | [Letter Combinations of a Phone Number](./problems/0017-letter-combinations-of-a-phone-number.md) | [Go](./golang/0017_letter_combinations_of_a_phone_number.go) | _O(n * 4^n)_ | _O(1)_ | Medium ||
| 0039 | [Combination Sum](./problems/0039-combination-sum.md) |  [Go](./golang/0039_combination_sum.go)| _O(k * n^k)_    | _O(k)_          | Medium         ||
| 0040 | [Combination Sum II](./problems/0040-combination-sum-ii.md) |  [Go](./golang/0040_combination_sum_ii.go)| _O(k * C(n, k))_| _O(k)_         | Medium         ||
| 0046 | [Permutations](./problems/0046-permutations.md) |  [Go](./golang/0046_permutations.go)| _O(n * n!)_         | _O(n)_          | Medium         ||
| 0047 | [Permutations II](./problems/0047-permutations-ii.md) |  [Go](./golang/0047_permutations_ii.go)| _O(n * n!)_   | _O(n)_          | Medium           ||
| 0077 | [Combinations](./problems/0077-combinations.md) | [Go](./golang/0077_combinations.go) | _O(O(k * C(n, k)))_ | _O(k)_           | Medium         ||
| 0078 | [Subsets](./problems/0078-subsets.md) | [Go](./golang/0078_subsets.go)    | _O(n * 2^n)_    | _O(1)_          | Medium         ||
| 0090 | [Subsets II](./problems/0090-subsets-ii.md) | [Go](./golang/0090_subsets_ii.go) | _O(n * 2^n)_    | _O(1)_          | Medium         ||
| 0216 | [Combination Sum III](./problems/0216-combination-sum-iii.md) | [Go](./golang/0216_combination_sum_iii.go) | _O(k * C(n, k))_    | _O(k)_          | Medium         ||
| 0254 | [Factor Combinations](./problems/0254-factor-combinations.md) | [Go](./golang/0254_factor_combinations.go)  | _O(nlogn)_ | _O(logn)_ | Medium         |🔒||
| 0267 | [Palindrome Permutation II](./problems/0267-palindrome-permutation-ii.md) | [Go](./golang/0267_palindrome_permutation_ii.go)  | _O(n * n!)_ |  _O(n)_ | Medium         |🔒||
| 0698 | [Partition to K Equal Sum Subsets](./problems/0698-partition-to-k-equal-sum-subsets.md) | [Go](./golang/0698_partition_to_k_equal_sum_subsets.go) | _O(n * 2^n)_ | _O(2^n)_ | Medium || DFS, DP, Memoization
| 0784 | [Letter Case Permutation](./problems/0784-letter-case-permutation.md) | [Go](./golang/0784_letter_case_permutation.go) | _O(n * 2^n)_    | _O(1)_          | Easy         ||
| 2056 | [Number of Valid Move Combinations On Chessboard](./problems/2056-number-of-valid-move-combinations-on-chessboard.md) | [Go](./golang/2056_number_of_valid_move_combinations_on_chessboard.go) | _O(1)_ | _O(1)_      | Hard         | | |
| 2741 | [Special Permutations](./problems/2741-special-permutations.md) | [Go](./golang/2741_special_permutations.go) | _O(n^2 * 2^n)_   | _O(n * 2^n)_        | Medium         | | Backtracking, Memoization

---

### 2. Word Search / Break

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0079 | [Word Search](./problems/0079-word-search.md) | [Go](./golang/0079_word_search.go) | _O(m * n * 3^l)_ | _O(l)_ | Medium         ||
| 0131 | [Palindrome Partitioning](./problems/0131-palindrome-partitioning.md) |  [Go](./golang/0131_palindrome_partitioning.go)| _O(n^2)_ ~ _O(2^n)_ | _O(n^2)_ | Medium ||
| 0140 | [Word Break II](./problems/0140-word-break-ii.md) | [Go](./golang/0140_word_break_ii.go) |  _O(n * l^2 + n * r)_      | _O(n^2)_       | Hard           ||
| 0212 | [Word Search II](./problems/0212-word-search-ii.md) | [Go](./golang/0212_word_search_ii.go) | _O(m * n * 3^h)_ | _O(t)_  | Hard         | LintCode | Trie, DFS

---

### 3. N-Queens / Sudoku

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0037 | [Sudoku Solver](./problems/0037-sudoku-solver.md) |  [Go](./golang/0037_sudoku_solver.go)| _O((9!)^9)_  | _O(1)_          | Hard           ||
| 0051 | [N-Queens](./problems/0051-n-queens.md) |  [Go](./golang/0051_n_queens.go)| _O(n^2 * n!)_         | _O(n)_          | Hard           ||
| 0052 | [N-Queens-II](./problems/0052-n-queens-ii.md) |  [Go](./golang/0052_n_queens_ii.go)| _O(n!)_        | _O(n)_          | Hard           ||

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0022 | [Generate Parentheses](./problems/0022-generate-parentheses.md) | [Go](./golang/0022_generate_parentheses.go)| _O(4^n / n^(3/2))_ | _O(n)_   | Medium         ||
| 0093 | [Restore IP Addresses](./problems/0093-restore-ip-addresses.md) |  [Go](./golang/0093_restore_ip_addresses.go)| _O(1)_ | _O(1)_ | Medium         ||
| 0126 | [Word Ladder II](./problems/0126-word-ladder-ii.md) |[Go](./golang/0126_word_ladder_ii.go) | _O(b^(d/2))_ | _O(w * l)_         | Hard         | CTCI | Bi-BFS
| 0291 | [Word Pattern II](./problems/0291-word-pattern-ii.md) | [Go](./golang/0291_word_pattern_ii.go)  | _O(n * C(n - 1, c - 1))_ | _O(n + c)_ | Hard         |🔒||
| 0294 | [Flip Game II](./problems/0294-flip-game-ii.md) | [Go](./golang/0294_flip_game_ii.go)  | _O(n + c^2)_ | _O(c)_ | Medium         |🔒| DP, Hash, `Sprague-Grundy Theorem` |
| 0320 | [Generalized Abbreviation](./problems/0320-generalized-abbreviation.md) | [Go](./golang/0320_generalized_abbreviation.go)  | _O(n * 2^n)_ | _O(n)_ | Medium         |🔒||
| 0425 | [Word Squares](./problems/0425-word-squares.md) | [Go](./golang/0425_word_squares.go)  | _O(n^2 * n!)_ | _O(n^2)_ | Hard         |🔒||
| 0488 | [Zuma Game](./problems/0488-zuma-game.md) | [Go](./golang/0488_zuma_game.go) | _O((b+h) * h!*(b+h-1)!/(b-1)!)_       | _O((b+h) * h!*(b+h-1)!/(b-1)!)_          | Hard         || Backtracking |
| 0491 | [Increasing Subsequences](./problems/0491-increasing-subsequences.md) | [Go](./golang/0491_increasing_subsequences.go) | _O(n * 2^n)_       | _O(n)_          | Medium         || Backtracking |
| 0526 | [Beautiful Arrangement](./problems/0526-beautiful-arrangement.md) | [Go](./golang/0526_beautiful_arrangement.go) | _O(n!)_ | _O(n)_  | Medium       ||
| 0676 | [Implement Magic Dictionary](./problems/0676-implement-magic-dictionary.md) | [Go](./golang/0676_implement_magic_dictionary.go) | _O(n)_ | _O(d)_  | Medium       || Trie, DFS
| 0679 | [24 Game](./problems/0679-24-game.md) | [Go](./golang/0679_24_game.go) | _O(1)_ | _O(1)_  | Hard       || DFS
| 0718 | [Maximum Length of Repeated Subarray](./problems/0718-maximum-length-of-repeated-subarray.md) | [Go](./golang/0718_maximum_length_of_repeated_subarray.go) | _O(m * n)_ | _O(min(m, n))_ | Medium || DP, Hash, Binary Search
| 0996 | [Number of Squareful Arrays](./problems/0996-number-of-squareful-arrays.md) | [Go](./golang/0996_number_of_squareful_arrays.go) | _O(n!)_    | _O(n^2)_          | Hard         ||
| 1087 | [Brace Expansion](./problems/1087-brace-expansion.md) | [Go](./golang/1087_brace_expansion.go)  | _O(p * l * log(p * l))_ | _O(p * l)_ | Medium         |🔒||
| 1096 | [Brace Expansion II](./problems/1096-brace-expansion-ii.md) | [Go](./golang/1096_brace_expansion_ii.go)  | _O(p * l * log(p * l))_ | _O(p * l)_ | Hard         |||
| 1219 | [Path with Maximum Gold](./problems/1219-path-with-maximum-gold.md) | [Go](./golang/1219_path_with_maximum_gold.go)  | _O(m^2 * n^2)_ | _O(m * n)_ | Medium         |||
| 1240 | [Tiling a Rectangle with the Fewest Squares](./problems/1240-tiling-a-rectangle-with-the-fewest-squares.md) | [Go](./golang/1240_tiling_a_rectangle_with_the_fewest_squares.go)  | _O(n^2 * m^2 * m^(n * m))_ | _O(n * m)_ | Hard         |||
| 1255 | [Maximum Score Words Formed by Letters](./problems/1255-maximum-score-words-formed-by-letters.md) | [Go](./golang/1255_maximum_score_words_formed_by_letters.go)  | _O(n * 2^n)_ | _O(n)_ | Hard         |||
| 1258 | [Synonymous Sentences](./problems/1258-synonymous-sentences.md) | [Go](./golang/1258_synonymous_sentences.go)  | _O(p * l * log(p * l))_ | _O(p * l)_ | Medium         || Union Find |
| 1307 | [Verbal Arithmetic Puzzle](./problems/1307-verbal-arithmetic-puzzle.md) | [Go](./golang/1307_verbal_arithmetic_puzzle.go)  | _O(10! * n * l)_ | _O(n * l)_ | Hard         |||
| 1379 | [Find a Corresponding Node of a Binary Tree in a Clone of That Tree](./problems/1379-find-a-corresponding-node-of-a-binary-tree-in-a-clone-of-that-tree.md) | [Go](./golang/1379_find_a_corresponding_node_of_a_binary_tree_in_a_clone_of_that_tree.go) | _O(n)_ | _O(h)_      | Medium         || Stack |
| 1593 | [Split a String Into the Max Number of Unique Substrings](./problems/1593-split-a-string-into-the-max-number-of-unique-substrings.md) | [Go](./golang/1593_split_a_string_into_the_max_number_of_unique_substrings.go) | _O(n * 2^(n - 1))_ | _O(n)_      | Medium         |||
| 1659 | [Maximize Grid Happiness](./problems/1659-maximize-grid-happiness.md) | [Go](./golang/1659_maximize_grid_happiness.go) | _O(C(m * n, i) * C(m * n - i, e))_ | _O(min(m * n, i + e))_      | Hard         || Pruning |
| 1718 | [Construct the Lexicographically Largest Valid Sequence](./problems/1718-construct-the-lexicographically-largest-valid-sequence.md) | [Go](./golang/1718_construct_the_lexicographically_largest_valid_sequence.go) | _O(n!)_ | _O(b)_      | Medium         || Backtracking |
| 1723 | [Find Minimum Time to Finish All Jobs](./problems/1723-find-minimum-time-to-finish-all-jobs.md) | [Go](./golang/1723_find_minimum_time_to_finish_all_jobs.go) | _O(k^n * logr)_ | _O(n + k)_      | Hard         || Backtracking, Pruning, Binary Search |
| 1849 | [Splitting a String Into Descending Consecutive Values](./problems/1849-splitting-a-string-into-descending-consecutive-values.md) | [Go](./golang/1849_splitting_a_string_into_descending_consecutive_values.go) | _O(n^2)_ | _O(n)_      | Medium         || |
| 1999 | [Smallest Greater Multiple Made of Two Digits](./problems/1999-smallest-greater-multiple-made-of-two-digits.md) | [Go](./golang/1999_smallest_greater_multiple_made_of_two_digits.go) | _O(1)_ | _O(1)_      | Medium         |🔒| Backtracking, Bit Manipulation |
| 2014 | [Longest Subsequence Repeated k Times](./problems/2014-longest-subsequence-repeated-k-times.md) | [Go](./golang/2014_longest_subsequence_repeated_k_times.go) | _O(n * (n/k)!)_ | _O(n/k)_      | Hard         | | |
| 2094 | [Finding 3-Digit Even Numbers](./problems/2094-finding-3-digit-even-numbers.md) | [Go](./golang/2094_finding_3_digit_even_numbers.go) | _O(n)_ | _O(1)_      | Easy         | | |
| 2443 | [Sum of Number and Its Reverse](./problems/2443-sum-of-number-and-its-reverse.md) | [Go](./golang/2443_sum_of_number_and_its_reverse.go) | _O(n^(1/(2*log2(10))))_   | _O(log10(n)/2)_        | Medium         | | Brute Force, Backtracking
| 2664 | [The Knight’s Tour](./problems/2664-the-knights-tour.md) | [Go](./golang/2664_the_knights_tour.go) | _O(m * n)_   | _O(1)_        | Medium         | 🔒 | Backtracking, Greedy, `Warnsdorff's Rule`
| 2698 | [Find the Punishment Number of an Integer](./problems/2698-find-the-punishment-number-of-an-integer.md) | [Go](./golang/2698_find_the_punishment_number_of_an_integer.go) | _O(n * (logn)^(2*logn))_   | _O(logn)_        | Medium         | | Backtracking

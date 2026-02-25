## Dynamic Programming

### 1. 1D / Linear

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0053 | [Maximum Subarray](./problems/0053-maximum-subarray.md) |[Go](./golang/0053_maximum_subarray.go)| _O(n)_     | _O(1)_         | Easy         ||
| 0070 | [Climbing Stairs](./problems/0070-climbing-stairs.md) | [Go](./golang/0070_climbing_stairs.go) | _O(logn)_    | _O(1)_          | Easy           || Matrix Exponentiation
| 0198 | [House Robber](./problems/0198-house-robber.md) | [Go](./golang/0198_house_robber.go) | _O(n)_          | _O(1)_          | Easy           ||
| 0213 | [House Robber II](./problems/0213-house-robber-ii.md) | [Go](./golang/0213_house_robber_ii.go) | _O(n)_          | _O(1)_          | Medium           ||
| 0322 | [Coin Change](./problems/0322-coin-change.md) | [Go](./golang/0322_coin_change.go) | _O(n * k)_ | _O(k)_ | Medium ||
| 0509 | [Fibonacci Number](./problems/0509-fibonacci-number.md) | [Go](./golang/0509_fibonacci_number.go) | _O(logn)_    | _O(1)_          | Easy           | variant of [Climbing Stairs](https://leetcode.com/problems/climbing-stairs/) | Matrix Exponentiation
| 0518 | [Coin Change 2](./problems/0518-coin-change-2.md) | [Go](./golang/0518_coin_change_2.go) | _O(n * m)_       | _O(m)_          | Medium         || DP |
| 0746 | [Min Cost Climbing Stairs](./problems/0746-min-cost-climbing-stairs.md) | [Go](./golang/0746_min_cost_climbing_stairs.go) | _O(n)_ | _O(1)_ | Easy ||
| 1186 | [Maximum Subarray Sum with One Deletion](./problems/1186-maximum-subarray-sum-with-one-deletion.md) |[Go](./golang/1186_maximum_subarray_sum_with_one_deletion.go)| _O(n)_     | _O(1)_         | Medium         ||
| 1388 | [Pizza With 3n Slices](./problems/1388-pizza-with-3n-slices.md) | [Go](./golang/1388_pizza_with_3n_slices.go) | _O(n^2)_          | _O(n)_          | Hard           | variant of [House Robber II](https://leetcode.com/problems/house-robber-ii/) |
| 1746 | [Maximum Subarray Sum After One Operation](./problems/1746-maximum-subarray-sum-after-one-operation.md) |[Go](./golang/1746_maximum_subarray_sum_after_one_operation.go)| _O(n)_     | _O(1)_         | Medium         | variant of [Maximum Subarray](https://leetcode.com/problems/maximum-subarray/), 🔒 |

---

### 2. 2D / Grid

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0062 | [Unique Paths](./problems/0062-unique-paths.md) |  [Go](./golang/0062_unique_paths.go)| _O(m + n)_      | _O(1)_   | Medium         || Combinatorics
| 0063 | [Unique Paths II](./problems/0063-unique-paths-ii.md) |  [Go](./golang/0063_unique_paths_ii.go)|  _O(m * n)_ | _O(m + n)_   | Medium         ||
| 0064 | [Minimum Path Sum](./problems/0064-minimum-path-sum.md) |  [Go](./golang/0064_minimum_path_sum.go)| _O(m * n)_ | _O(m + n)_     | Medium         ||
| 0174 | [Dungeon Game](./problems/0174-dungeon-game.md) |  [Go](./golang/0174_dungeon_game.go)| _O(m * n)_     | _O(m + n)_      | Hard           ||
| 0221 | [Maximal Square](./problems/0221-maximal-square.md) | [Go](./golang/0221_maximal_square.go) | _O(n^2)_         | _O(n)_          | Medium           | EPI |
| 0980 | [Unique Paths III](./problems/0980-unique-paths-iii.md) | [Go](./golang/0980_unique_paths_iii.go) |  _O((m * n) * 2^(m * n))_ | _O((m * n) * 2^(m * n))_   | Hard         ||
| 2304 | [Minimum Path Cost in a Grid](./problems/2304-minimum-path-cost-in-a-grid.md) | [Go](./golang/2304_minimum_path_cost_in_a_grid.go) | _O(m * n^2)_ | _O(n)_ | Medium | | DP

---

### 3. String DP

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0072 | [Edit Distance](./problems/0072-edit-distance.md) || _O(m * n)_      | _O(m + n)_      | Hard           ||
| 0097 | [Interleaving String](./problems/0097-interleaving-string.md) || _O(m * n)_ | _O(m + n)_ | Hard         ||
| 0139 | [Word Break](./problems/0139-word-break.md) | [Go](./golang/0139_word_break.go) |  _O(n * l^2)_         | _O(n)_       | Medium         ||
| 0516 | [Longest Palindromic Subsequence](./problems/0516-longest-palindromic-subsequence.md) | [Go](./golang/0516_longest_palindromic_subsequence.go) | _O(n^2)_ | _O(n)_ | Medium |||
| 1216 | [Valid Palindrome III](./problems/1216-valid-palindrome-iii.md) | [Go](./golang/1216_valid_palindrome_iii.go) | _O(n^2)_ | _O(n)_ | Hard | 🔒, variant of [Longest Palindromic Subsequence](https://leetcode.com/problems/longest-palindromic-subsequence/) ||
| 1682 | [Longest Palindromic Subsequence II](./problems/1682-longest-palindromic-subsequence-ii.md) | [Go](./golang/1682_longest_palindromic_subsequence_ii.go) | _O(n^2)_ | _O(n)_ | Medium |🔒||

---

### 4. Stock / Buy Sell

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0123 | [Best Time to Buy and Sell Stock III](./problems/0123-best-time-to-buy-and-sell-stock-iii.md) |  [Go](./golang/0123_best_time_to_buy_and_sell_stock_iii.go)| _O(n)_ | _O(1)_ | Hard ||
| 0188 | [Best Time to Buy and Sell Stock IV](./problems/0188-best-time-to-buy-and-sell-stock-iv.md) | [Go](./golang/0188_best_time_to_buy_and_sell_stock_iv.go) | _O(n)_ | _O(n)_ | Hard || Quick Select, Mono Stack
| 0309 | [Best Time to Buy and Sell Stock with Cooldown](./problems/0309-best-time-to-buy-and-sell-stock-with-cooldown.md) | [Go](./golang/0309_best_time_to_buy_and_sell_stock_with_cooldown.go) | _O(n)_ | _O(1)_ | Medium ||
| 0714 | [Best Time to Buy and Sell Stock with Transaction Fee](./problems/0714-best-time-to-buy-and-sell-stock-with-transaction-fee.md) | [Go](./golang/0714_best_time_to_buy_and_sell_stock_with_transaction_fee.go) | _O(n)_ | _O(1)_ | Medium ||
| 2291 | [Maximum Profit From Trading Stocks](./problems/2291-maximum-profit-from-trading-stocks.md) | [Go](./golang/2291_maximum_profit_from_trading_stocks.go) | _O(n * b)_ | _O(b)_ | Medium | 🔒 | DP
| 2312 | [Selling Pieces of Wood](./problems/2312-selling-pieces-of-wood.md) | [Go](./golang/2312_selling_pieces_of_wood.go) | _O(m * n * (m + n))_ | _O(m + n)_ | Hard | | DP

---

### 5. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0010 | [Regular Expression Matching](./problems/0010-regular-expression-matching.md) |  [Go](./golang/0010_regular_expression_matching.go)| _O(m * n)_ | _O(n)_ | Hard ||
| 0044 | [Wildcard Matching](./problems/0044-wildcard-matching.md) |  [Go](./golang/0044_wildcard_matching.go)| _O(m * n)_ | _O(1)_    | Hard           || Greedy
| 0087 | [Scramble String](./problems/0087-scramble-string.md) |  [Go](./golang/0087_scramble_string.go)| _O(n^4)_ | _O(n^3)_        | Hard           ||
| 0091 | [Decode Ways](./problems/0091-decode-ways.md) | [Go](./golang/0091_decode_ways.go)| _O(n)_          | _O(1)_          | Medium         ||
| 0096 | [Unique Binary Search Trees](./problems/0096-unique-binary-search-trees.md) |  [Go](./golang/0096_unique_binary_search_trees.go)| _O(n)_      | _O(1)_         | Medium         || Math
| 0115 | [Distinct Subsequences](./problems/0115-distinct-subsequences.md) || _O(n^2)_ | _O(n)_ | Hard           ||
| 0120 | [Triangle](./problems/0120-triangle.md) |  [Go](./golang/0120_triangle.go)| _O(m * n)_      | _O(n)_         | Medium         ||
| 0132 | [Palindrome Partitioning II](./problems/0132-palindrome-partitioning-ii.md) |  [Go](./golang/0132_palindrome_partitioning_ii.go)| _O(n^2)_ | _O(n^2)_ | Hard ||
| 0152 | [Maximum Product Subarray](./problems/0152-maximum-product-subarray.md) |[Go](./golang/0152_maximum_product_subarray.go)| _O(n)_ | _O(1)_ | Medium     ||
| 0256 | [Paint House](./problems/0256-paint-house.md) | [Go](./golang/0256_paint_house.go) | _O(n)_| _O(1)_| Medium |🔒||
| 0265 | [Paint House II](./problems/0265-paint-house-ii.md) | [Go](./golang/0265_paint_house_ii.go) | _O(n * k)_| _O(k)_| Hard |🔒||
| 0276 | [Paint Fence](./problems/0276-paint-fence.md) | [Go](./golang/0276_paint_fence.go) | _O(n)_| _O(1)_| Easy |🔒||
| 0279 | [Perfect Squares](./problems/0279-perfect-squares.md) | [Go](./golang/0279_perfect_squares.go) | _O(n * sqrt(n))_         | _O(n)_          | Medium           ||  Hash |
| 0303 | [Range Sum Query - Immutable](./problems/0303-range-sum-query-immutable.md) | [Go](./golang/0303_range_sum_query_immutable.go) | ctor: _O(n)_, lookup: _O(1)_          | _O(n)_          | Easy           ||
| 0304 | [Range Sum Query 2D - Immutable](./problems/0304-range-sum-query-2d-immutable.md) | [Go](./golang/0304_range_sum_query_2d_immutable.go) | ctor: _O(m * n)_, lookup: _O(1)_          | _O(m * n)_          | Medium           ||
| 0312 | [Burst Balloons](./problems/0312-burst-balloons.md) | [Go](./golang/0312_burst_balloons.go) | _O(n^3)_ | _O(n^2)_ | Hard ||
| 0351 | [Android Unlock Patterns](./problems/0351-android-unlock-patterns.md) | [Go](./golang/0351_android_unlock_patterns.go) | _O(9^2 * 2^9)_ | _O(9 * 2^9)_ | Medium | 🔒 | Backtracking |
| 0357 | [Count Numbers with Unique Digits](./problems/0357-count-numbers-with-unique-digits.md) | [Go](./golang/0357_count_numbers_with_unique_digits.go) | _O(n)_ | _O(1)_ | Medium || Backtracking, Math |
| 0361 | [Bomb Enemy](./problems/0361-bomb-enemy.md) | [Go](./golang/0361_bomb_enemy.go) | _O(m * n)_ | _O(m * n)_ | Medium | 🔒 | |
| 0368 | [Largest Divisible Subset](./problems/0368-largest-divisible-subset.md) | [Go](./golang/0368_largest_divisible_subset.go) | _O(n^2)_ | _O(n)_ | Medium | | |
| 0375 | [Guess Number Higher or Lower II](./problems/0375-guess-number-higher-or-lower-ii.md) | [Go](./golang/0375_guess_number_higher_or_lower_ii.go)   | _O(n^3)_          | _O(n^2)_          | Medium         | |
| 0377 | [Combination Sum IV](./problems/0377-combination-sum-iv.md) | [Go](./golang/0377_combination_sum_iv.go)   | _O(nlogn + n * t)_          | _O(t)_          | Medium         | |
| 0403 | [Frog Jump](./problems/0403-frog-jump.md) | [Go](./golang/0403_frog_jump.go) | _O(n^2)_ | _O(n^2)_ | Hard ||
| 0416 | [Partition Equal Subset Sum](./problems/0416-partition-equal-subset-sum.md) | [Go](./golang/0416_partition_equal_subset_sum.go) | _O(n * s)_ | _O(s)_ | Medium ||
| 0418 | [Sentence Screen Fitting](./problems/0418-sentence-screen-fitting.md) | [Go](./golang/0418_sentence_screen_fitting.go) | _O(r + n * c)_ | _O(n)_ | Medium |🔒|
| 0446 | [Arithmetic Slices II - Subsequence](./problems/0446-arithmetic-slices-ii-subsequence.md) | [Go](./golang/0446_arithmetic_slices_ii_subsequence.go) | _O(n^2)_ | _O(n * d)_ | Hard ||
| 0465 | [Optimal Account Balancing](./problems/0465-optimal-account-balancing.md) | [Go](./golang/0465_optimal_account_balancing.go) | _O(n * 2^n)_ | _O(2^n)_ | Hard |🔒|
| 0466 | [Count The Repetitions](./problems/0466-count-the-repetitions.md) | [Go](./golang/0466_count_the_repetitions.go) | _O(s1 * min(s2, n1))_ | _O(s2)_ | Hard ||
| 0467 | [Unique Substrings in Wraparound String](./problems/0467-unique-substrings-in-wraparound-string.md) | [Go](./golang/0467_unique_substrings_in_wraparound_string.go) | _O(n)_ | _O(1)_ | Medium ||
| 0471 | [Encode String with Shortest Length](./problems/0471-encode-string-with-shortest-length.md) | [Go](./golang/0471_encode_string_with_shortest_length.go) | _O(n^3)_ on average | _O(n^2)_ | Medium |🔒|
| 0472 | [Concatenated Words](./problems/0472-concatenated-words.md) | [Go](./golang/0472_concatenated_words.go) | _O(n * l^2)_ | _O(n * l)_ | Medium ||
| 0474 | [Ones and Zeroes](./problems/0474-ones-and-zeroes.md) | [Go](./golang/0474_ones_and_zeroes.go) | _O(s * m * n)_ | _O(m * n)_ | Medium ||
| 0486 | [Predict the Winner](./problems/0486-predict-the-winner.md) | [Go](./golang/0486_predict_the_winner.go) | _O(n^2)_ | _O(n)_ | Medium | | |
| 0494 | [Target Sum](./problems/0494-target-sum.md) | [Go](./golang/0494_target_sum.go) | _O(n * S)_       | _O(S)_          | Medium         || DP |
| 0514 | [Freedom Trail](./problems/0514-freedom-trail.md) | [Go](./golang/0514_freedom_trail.go) | _O(k)_ ~ _O(k * r^2)_ | _O(r)_ | Hard |||
| 0546 | [Remove Boxes](./problems/0546-remove-boxes.md) | [Go](./golang/0546_remove_boxes.go) | _O(n^3)_ ~ _O(n^4)_ | _O(n^3)_ | Hard |||
| 0552 | [Student Attendance Record II](./problems/0552-student-attendance-record-ii.md) | [Go](./golang/0552_student_attendance_record_ii.go) | _O(n)_ | _O(1)_ | Hard |||
| 0562 | [Longest Line of Consecutive One in Matrix](./problems/0562-longest-line-of-consecutive-one-in-matrix.md) | [Go](./golang/0562_longest_line_of_consecutive_one_in_matrix.go) | _O(m * n)_ | _O(n)_ | Medium |🔒||
| 0568 | [Maximum Vacation Days](./problems/0568-maximum-vacation-days.md) | [Go](./golang/0568_maximum_vacation_days.go) | _O(n^2 * k)_ | _O(k)_ | Hard |🔒||
| 0576 | [Out of Boundary Paths](./problems/0576-out-of-boundary-paths.md) | [Go](./golang/0576_out_of_boundary_paths.go) | _O(N * m * n)_ | _O(m * n)_ | Medium |||
| 0583 | [Delete Operation for Two Strings](./problems/0583-delete-operation-for-two-strings.md) | [Go](./golang/0583_delete_operation_for_two_strings.go) | _O(m * n)_ | _O(n)_ | Medium |||
| 0600 | [Non-negative Integers without Consecutive Ones](./problems/0600-non-negative-integers-without-consecutive-ones.md) | [Go](./golang/0600_non_negative_integers_without_consecutive_ones.go) | _O(1)_ | _O(1)_ | Hard |||
| 0629 | [K Inverse Pairs Array](./problems/0629-k-inverse-pairs-array.md) | [Go](./golang/0629_k_inverse_pairs_array.go) | _O(n * k)_ | _O(k)_ | Hard |||
| 0639 | [Decode Ways II](./problems/0639-decode-ways-ii.md) | [Go](./golang/0639_decode_ways_ii.go) | _O(n)_ | _O(1)_ | Hard |||
| 0650 | [2 Keys Keyboard](./problems/0650-2-keys-keyboard.md) | [Go](./golang/0650_2_keys_keyboard.go) | _O(sqrt(n))_ | _O(1)_ | Medium |||
| 0656 | [Coin Path](./problems/0656-coin-path.md) | [Go](./golang/0656_coin_path.go) | _O(n * B)_ | _O(n)_ | Hard |🔒|
| 0664 | [Strange Printer](./problems/0664-strange-printer.md) | [Go](./golang/0664_strange_printer.go) | _O(n^3)_ | _O(n^2)_ | Hard ||
| 0673 | [Number of Longest Increasing Subsequence](./problems/0673-number-of-longest-increasing-subsequence.md) | [Go](./golang/0673_number_of_longest_increasing_subsequence.go) | _O(n^2)_ | _O(n)_ | Medium ||
| 0688 | [Knight Probability in Chessboard](./problems/0688-knight-probability-in-chessboard.md) | [Go](./golang/0688_knight_probability_in_chessboard.go) | _O(k * n^2)_ | _O(n^2)_ | Medium ||
| 0689 | [Maximum Sum of 3 Non-Overlapping Subarrays](./problems/0689-maximum-sum-of-3-non-overlapping-subarrays.md) | [Go](./golang/0689_maximum_sum_of_3_non_overlapping_subarrays.go) | _O(n)_ | _O(n)_ | Hard ||
| 0691 | [Stickers to Spell Word](./problems/0691-stickers-to-spell-word.md) | [Go](./golang/0691_stickers_to_spell_word.go) | _O(T * S^T)_ | _O(T * S^T)_ | Hard || Backtracking, Memoization
| 0712 | [Minimum ASCII Delete Sum for Two Strings](./problems/0712-minimum-ascii-delete-sum-for-two-strings.md) | [Go](./golang/0712_minimum_ascii_delete_sum_for_two_strings.go) | _O(m * n)_ | _O(n)_ | Medium ||
| 0727 | [Minimum Window Subsequence](./problems/0727-minimum-window-subsequence.md) | [Go](./golang/0727_minimum_window_subsequence.go) | _O(s * t)_ | _O(s)_ | Hard |🔒|
| 0730 | [Count Different Palindromic Subsequences](./problems/0730-count-different-palindromic-subsequences.md) | [Go](./golang/0730_count_different_palindromic_subsequences.go) | _O(n^2)_ | _O(n)_ | Hard ||
| 0740 | [Delete and Earn](./problems/0740-delete-and-earn.md) | [Go](./golang/0740_delete_and_earn.go) | _O(n)_ | _O(1)_ | Medium ||
| 0741 | [Cherry Pickup](./problems/0741-cherry-pickup.md) | [Go](./golang/0741_cherry_pickup.go) | _O(n^3)_ | _O(n^2)_ | Hard ||
| 0750 | [Number Of Corner Rectangles](./problems/0750-number-of-corner-rectangles.md) | [Go](./golang/0750_number_of_corner_rectangles.go) | _O(n * m^2)_ | _O(n * m)_ | Medium ||
| 0764 | [Largest Plus Sign](./problems/0764-largest-plus-sign.md) | [Go](./golang/0764_largest_plus_sign.go) | _O(n^2)_ | _O(n^2)_ | Medium ||
| 0788 | [Rotated Digits](./problems/0788-rotated-digits.md) | [Go](./golang/0788_rotated_digits.go) | _O(logn)_ | _O(logn)_ | Easy || Memoization |
| 0790 | [Domino and Tromino Tiling](./problems/0790-domino-and-tromino-tiling.md) | [Go](./golang/0790_domino_and_tromino_tiling.go) | _O(logn)_ | _O(1)_ | Medium || Matrix Exponentiation |
| 0799 | [Champagne Tower](./problems/0799-champagne-tower.md) | [Go](./golang/0799_champagne_tower.go) | _O(n^2)_ | _O(n)_ | Medium |||
| 0801 | [Minimum Swaps To Make Sequences Increasing](./problems/0801-minimum-swaps-to-make-sequences-increasing.md) | [Go](./golang/0801_minimum_swaps_to_make_sequences_increasing.go) | _O(n)_ | _O(1)_ | Medium |||
| 0805 | [Split Array With Same Average](./problems/0805-split-array-with-same-average.md) | [Go](./golang/0805_split_array_with_same_average.go) | _O(n^4)_ | _O(n^3)_ | Hard |||
| 0808 | [Soup Servings](./problems/0808-soup-servings.md) | [Go](./golang/0808_soup_servings.go) | _O(1)_ | _O(1)_ | Medium || Memoization |
| 0813 | [Largest Sum of Averages](./problems/0813-largest-sum-of-averages.md) | [Go](./golang/0813_largest_sum_of_averages.go) | _O(k * n^2)_ | _O(n)_ | Medium || |
| 0818 | [Race Car](./problems/0818-race-car.md) | [Go](./golang/0818_race_car.go) | _O(nlogn)_ | _O(n)_ | Hard || |
| 0823 | [Binary Trees With Factors](./problems/0823-binary-trees-with-factors.md) | [Go](./golang/0823_binary_trees_with_factors.go) | _O(n^2)_ | _O(n)_ | Medium || |
| 0837 | [New 21 Game](./problems/0837-new-21-game.md) | [Go](./golang/0837_new_21_game.go) | _O(n)_ | _O(n)_ | Medium || |
| 0838 | [Push Dominoes](./problems/0838-push-dominoes.md) | [Go](./golang/0838_push_dominoes.go) | _O(n)_ | _O(n)_ | Medium || |
| 0847 | [Shortest Path Visiting All Nodes](./problems/0847-shortest-path-visiting-all-nodes.md) | [Go](./golang/0847_shortest_path_visiting_all_nodes.go) | _O(n *2^n)_ | _O(n * 2^n)_ | Hard || BFS |
| 0877 | [Stone Game](./problems/0877-stone-game.md) | [Go](./golang/0877_stone_game.go) | _O(n^2)_ | _O(n)_ | Medium | variant of [Predict the Winner](https://leetcode.com/problems/predict-the-winner/) | |
| 0879 | [Profitable Schemes](./problems/0879-profitable-schemes.md) | [Go](./golang/0879_profitable_schemes.go) | _O(n * p * g)_ | _O(p * g)_ | Hard || |
| 0903 | [Valid Permutations for DI Sequence](./problems/0903-valid-permutations-for-di-sequence.md) | [Go](./golang/0903_valid_permutations_for_di_sequence.go) | _O(n^2)_ | _O(n)_ | Hard || |
| 0920 | [Number of Music Playlists](./problems/0920-number-of-music-playlists.md) | [Go](./golang/0920_number_of_music_playlists.go) | _O(n * l)_ | _O(l)_ | Hard || |
| 0926 | [Flip String to Monotone Increasing](./problems/0926-flip-string-to-monotone-increasing.md) | [Go](./golang/0926_flip_string_to_monotone_increasing.go) | _O(n)_ | _O(1)_ | Medium ||
| 0931 | [Minimum Falling Path Sum](./problems/0931-minimum-falling-path-sum.md) | [Go](./golang/0931_minimum_falling_path_sum.go) | _O(n^2)_ | _O(1)_ | Medium ||
| 0935 | [Knight Dialer](./problems/0935-knight-dialer.md) | [Go](./golang/0935_knight_dialer.go) | _O(logn)_ | _O(1)_ | Medium || Matrix Exponentiation |
| 0940 | [Distinct Subsequences II](./problems/0940-distinct-subsequences-ii.md) | [Go](./golang/0940_distinct_subsequences_ii.go) | _O(n)_ | _O(1)_ | Hard |||
| 0943 | [Find the Shortest Superstring](./problems/0943-find-the-shortest-superstring.md) | [Go](./golang/0943_find_the_shortest_superstring.go) | _O(n^2 * (l^2 + 2^n))_ | _O(n^2)_ | Hard |||
| 0956 | [Tallest Billboard](./problems/0956-tallest-billboard.md) | [Go](./golang/0956_tallest_billboard.go) | _O(n * 3^(n/2))_ | _O(3^(n/2))_ | Hard |||
| 0960 | [Delete Columns to Make Sorted III](./problems/0960-delete-columns-to-make-sorted-iii.md) | [Go](./golang/0960_delete_columns_to_make_sorted_iii.go) | _O(n * l^2)_ | _O(l)_ | Hard||
| 0964 | [Least Operators to Express Number](./problems/0964-least-operators-to-express-number.md) | [Go](./golang/0964_least_operators_to_express_number.go) | _O(logn / logx)_ | _O(logn)_ | Hard|| Math
| 0975 | [Odd Even Jump](./problems/0975-odd-even-jump.md) | [Go](./golang/0975_odd_even_jump.go) | _O(nlogn)_ | _O(n)_ | Hard|| Mono Stack, BST
| 0983 | [Minimum Cost For Tickets](./problems/0983-minimum-cost-for-tickets.md) | [Go](./golang/0983_minimum_cost_for_tickets.go) |  _O(n)_ | _O(1)_   | Medium         ||
| 1000 | [Minimum Cost to Merge Stones](./problems/1000-minimum-cost-to-merge-stones.md) | [Go](./golang/1000_minimum_cost_to_merge_stones.go) |  _O(n^3 / k)_ | _O(n^2)_   | Hard         |||
| 1027 | [Longest Arithmetic Sequence](./problems/1027-longest-arithmetic-sequence.md) | [Go](./golang/1027_longest_arithmetic_sequence.go) |  _O(n^2)_ | _O(n^2)_   | Medium         |||
| 1035 | [Uncrossed Lines](./problems/1035-uncrossed-lines.md) | [Go](./golang/1035_uncrossed_lines.go) |  _O(m * n)_ | _O(min(m, n))_   | Medium         |||
| 1039 | [Minimum Score Triangulation of Polygon](./problems/1039-minimum-score-triangulation-of-polygon.md) | [Go](./golang/1039_minimum_score_triangulation_of_polygon.go) |  _O(n^3)_ | _O(n^2)_   | Medium         |||
| 1043 | [Partition Array for Maximum Sum](./problems/1043-partition-array-for-maximum-sum.md) | [Go](./golang/1043_partition_array_for_maximum_sum.go) |  _O(n * k)_ | _O(k)_   | Medium         |||
| 1048 | [Longest String Chain](./problems/1048-longest-string-chain.md) | [Go](./golang/1048_longest_string_chain.go) |  _O(n * l^2)_ | _O(n * l)_   | Medium         |||
| 1049 | [Last Stone Weight II](./problems/1049-last-stone-weight-ii.md) | [Go](./golang/1049_last_stone_weight_ii.go) |  _O(2^n)_ | _O(2^n)_   | Medium         |||
| 1066 | [Campus Bikes II](./problems/1066-campus-bikes-ii.md) | [Go](./golang/1066_campus_bikes_ii.go) |  _O(w * b * 2^b)_ | _O(w * b * 2^b)_   | Medium         |🔒||
| 1092 | [Shortest Common Supersequence](./problems/1092-shortest-common-supersequence.md) | [Go](./golang/1092_shortest_common_supersequence.go) |  _O(m * n)_ | _O(m * n)_   | Hard         |||
| 1105 | [Filling Bookcase Shelves](./problems/1105-filling-bookcase-shelves.md) | [Go](./golang/1105_filling_bookcase_shelves.go) |  _O(n^2)_ | _O(n)_   | Medium         |||
| 1125 | [Smallest Sufficient Team](./problems/1125-smallest-sufficient-team.md) | [Go](./golang/1125_smallest_sufficient_team.go) |  _O(m * 2^n)_ | _O(2^n)_   | Hard         |||
| 1137 | [N-th Tribonacci Number](./problems/1137-n-th-tribonacci-number.md) | [Go](./golang/1137_n_th_tribonacci_number.go) | _O(logn)_    | _O(1)_          | Easy           | variant of [Fibonacci Number](https://leetcode.com/problems/fibonacci-number/) | Matrix Exponentiation
| 1139 | [Largest 1-Bordered Square](./problems/1139-largest-1-bordered-square.md) | [Go](./golang/1139_largest_1_bordered_square.go) | _O(n^3)_    | _O(n^2)_          | Medium           | |
| 1140 | [Stone Game II](./problems/1140-stone-game-ii.md) | [Go](./golang/1140_stone_game_ii.go) | _O(n*(logn)^2)_ | _O(nlogn)_ | Medium || |
| 1143 | [Longest Common Subsequence](./problems/1143-longest-common-subsequence.md) | [Go](./golang/1143_longest_common_subsequence.go) | _O(m * n)_ | _O(min(m, n))_ | Medium || |
| 1155 | [Number of Dice Rolls With Target Sum](./problems/1155-number-of-dice-rolls-with-target-sum.md) | [Go](./golang/1155_number_of_dice_rolls_with_target_sum.go) | _O(d * f * t)_ | _O(t)_ | Medium || |
| 1182 | [Shortest Distance to Target Color](./problems/1182-shortest-distance-to-target-color.md) | [Go](./golang/1182_shortest_distance_to_target_color.go) | _O(n)_ | _O(n)_ | Medium |🔒| |
| 1187 | [Make Array Strictly Increasing](./problems/1187-make-array-strictly-increasing.md) | [Go](./golang/1187_make_array_strictly_increasing.go) | _O(n^2 * logn)_ | _O(n)_ | Hard || |
| 1191 | [K-Concatenation Maximum Sum](./problems/1191-k-concatenation-maximum-sum.md) | [Go](./golang/1191_k_concatenation_maximum_sum.go) | _O(n)_ | _O(1)_ | Medium || |
| 1218 | [Longest Arithmetic Subsequence of Given Difference](./problems/1218-longest-arithmetic-subsequence-of-given-difference.md) | [Go](./golang/1218_longest_arithmetic_subsequence_of_given_difference.go) | _O(n)_ | _O(n)_ | Medium | ||
| 1220 | [Count Vowels Permutation](./problems/1220-count-vowels-permutation.md) | [Go](./golang/1220_count_vowels_permutation.go) | _O(logn)_ | _O(1)_ | Hard || Matrix Exponentiation |
| 1223 | [Dice Roll Simulation](./problems/1223-dice-roll-simulation.md) | [Go](./golang/1223_dice_roll_simulation.go) | _O(m * n)_ | _O(m)_ | Medium | ||
| 1230 | [Toss Strange Coins](./problems/1230-toss-strange-coins.md) | [Go](./golang/1230_toss_strange_coins.go) | _O(n^2)_ | _O(n)_ | Medium | ||
| 1235 | [Maximum Profit in Job Scheduling](./problems/1235-maximum-profit-in-job-scheduling.md) | [Go](./golang/1235_maximum_profit_in_job_scheduling.go) | _O(nlogn)_ | _O(n)_ | Hard | | DP, Heap |
| 1239 | [Maximum Length of a Concatenated String with Unique Characters](./problems/1239-maximum-length-of-a-concatenated-string-with-unique-characters.md) | [Go](./golang/1239_maximum_length_of_a_concatenated_string_with_unique_characters.go) | _O(n)_ ~ _O(2^n)_ | _O(1)_ ~ _O(2^n)_ | Medium | | DP, Bit Manipulation |
| 1246 | [Palindrome Removal](./problems/1246-palindrome-removal.md) | [Go](./golang/1246_palindrome_removal.go) | _O(n^3)_ | _O(n^2)_ | Hard | | |
| 1262 | [Greatest Sum Divisible by Three](./problems/1262-greatest-sum-divisible-by-three.md) | [Go](./golang/1262_greatest_sum_divisible_by_three.go) | _O(n)_ | _O(1)_ | Medium | | |
| 1269 | [Number of Ways to Stay in the Same Place After Some Steps](./problems/1269-number-of-ways-to-stay-in-the-same-place-after-some-steps.md) | [Go](./golang/1269_number_of_ways_to_stay_in_the_same_place_after_some_steps.go) | _O(n^2)_ | _O(n)_ | Hard | | |
| 1277 | [Count Square Submatrices with All Ones](./problems/1277-count-square-submatrices-with-all-ones.md) | [Go](./golang/1277_count_square_submatrices_with_all_ones.go) | _O(m * n)_ | _O(1)_ | Medium | | |
| 1278 | [Palindrome Partitioning III](./problems/1278-palindrome-partitioning-iii.md) | [Go](./golang/1278_palindrome_partitioning_iii.go) | _O(k * n^2)_ | _O(n^2)_ | Hard | | |
| 1289 | [Minimum Falling Path Sum II](./problems/1289-minimum-falling-path-sum-ii.md) | [Go](./golang/1289_minimum_falling_path_sum_ii.go) | _O(m * n)_ | _O(1)_ | Hard | | |
| 1292 | [Maximum Side Length of a Square with Sum Less than or Equal to Threshold](./problems/1292-maximum-side-length-of-a-square-with-sum-less-than-or-equal-to-threshold.md) | [Go](./golang/1292_maximum_side_length_of_a_square_with_sum_less_than_or_equal_to_threshold.go) | _O(m * n * log(min(m, n)))_ | _O(m * n)_ | Medium | | Binary Search |
| 1301 | [Number of Paths with Max Score](./problems/1301-number-of-paths-with-max-score.md) | [Go](./golang/1301_number_of_paths_with_max_score.go) | _O(n^2)_ | _O(n)_ | Hard | | |
| 1312 | [Minimum Insertion Steps to Make a String Palindrome](./problems/1312-minimum-insertion-steps-to-make-a-string-palindrome.md) | [Go](./golang/1312_minimum_insertion_steps_to_make_a_string_palindrome.go) | _O(n^2)_ | _O(n)_ | Hard | variant of [Longest Common Subsequence](https://leetcode.com/problems/longest-common-subsequence/) | |
| 1314 | [Matrix Block Sum](./problems/1314-matrix-block-sum.md) | [Go](./golang/1314_matrix_block_sum.go) | _O(m * n)_ | _O(m * n)_ | Medium | variant of [Range Sum Query 2D - Immutable](https://leetcode.com/problems/range-sum-query-2d-immutable/) | |
| 1320 | [Minimum Distance to Type a Word Using Two Fingers](./problems/1320-minimum-distance-to-type-a-word-using-two-fingers.md) | [Go](./golang/1320_minimum_distance_to_type_a_word_using_two_fingers.go) | _O(n)_ | _O(1)_ | Hard | | |
| 1335 | [Minimum Difficulty of a Job Schedule](./problems/1335-minimum-difficulty-of-a-job-schedule.md) | [Go](./golang/1335_minimum_difficulty_of_a_job_schedule.go) | _O(d * n^2)_ | _O(d * n)_ | Hard | | |
| 1340 | [Jump Game V](./problems/1340-jump-game-v.md) | [Go](./golang/1340_jump_game_v.go) | _O(n)_ | _O(n)_ | Hard | | Sliding Window, Mono Stack, Segment Tree |
| 1387 | [Sort Integers by The Power Value](./problems/1387-sort-integers-by-the-power-value.md) | [Go](./golang/1387_sort_integers_by_the_power_value.go) | _O(n)_ on average| _O(n)_ | Medium | | Quick Select |
| 1395 | [Count Number of Teams](./problems/1395-count-number-of-teams.md) | [Go](./golang/1395_count_number_of_teams.go) | _O(n^2)_          | _O(1)_          | Medium           ||
| 1397 | [Find All Good Strings](./problems/1397-find-all-good-strings.md) | [Go](./golang/1397_find_all_good_strings.go) | _O(m * n)_          | _O(m)_          | Hard           || `KMP Algorithm`
| 1406 | [Stone Game III](./problems/1406-stone-game-iii.md) | [Go](./golang/1406_stone_game_iii.go) | _O(n)_          | _O(1)_          | Hard           ||
| 1411 | [Number of Ways to Paint N × 3 Grid](./problems/1411-number-of-ways-to-paint-n-3-grid.md) | [Go](./golang/1411_number_of_ways_to_paint_n_3_grid.go) | _O(logn)_    | _O(1)_          | Hard           || Matrix Exponentiation
| 1416 | [Restore The Array](./problems/1416-restore-the-array.md) | [Go](./golang/1416_restore_the_array.go) | _O(nlogk)_    | _O(logk)_          | Hard           ||
| 1420 | [Build Array Where You Can Find The Maximum Exactly K Comparisons](./problems/1420-build-array-where-you-can-find-the-maximum-exactly-k-comparisons.md) | [Go](./golang/1420_build_array_where_you_can_find_the_maximum_exactly_k_comparisons.go) | _O(n * m * k)_    | _O(m * k)_          | Hard           ||
| 1434 | [Number of Ways to Wear Different Hats to Each Other](./problems/1434-number-of-ways-to-wear-different-hats-to-each-other.md) | [Go](./golang/1434_number_of_ways_to_wear_different_hats_to_each_other.go) | _O(h * 2^n)_    | _O(2^n)_          | Hard           ||
| 1444 | [Number of Ways of Cutting a Pizza](./problems/1444-number-of-ways-of-cutting-a-pizza.md) | [Go](./golang/1444_number_of_ways_of_cutting_a_pizza.go) | _O(m * n * k * (m + n))_    | _O(m * n * k)_          | Hard           ||
| 1449 | [Form Largest Integer With Digits That Add up to Target](./problems/1449-form-largest-integer-with-digits-that-add-up-to-target.md) | [Go](./golang/1449_form_largest_integer_with_digits_that_add_up_to_target.go) | _O(t)_    | _O(t)_          | Hard           ||
| 1458 | [Max Dot Product of Two Subsequences](./problems/1458-max-dot-product-of-two-subsequences.md) | [Go](./golang/1458_max_dot_product_of_two_subsequences.go) | _O(m * n)_    | _O(min(m, n))_          | Hard           ||
| 1463 | [Cherry Pickup II](./problems/1463-cherry-pickup-ii.md) | [Go](./golang/1463_cherry_pickup_ii.go) | _O(m * n^2)_    | _O(n^2)_          | Hard           ||
| 1467 | [Probability of a Two Boxes Having The Same Number of Distinct Balls](./problems/1467-probability-of-a-two-boxes-having-the-same-number-of-distinct-balls.md) | [Go](./golang/1467_probability_of_a_two_boxes_having_the_same_number_of_distinct_balls.go) | _O(k^3 * n^2)_    | _O(k^2 * n)_          | Hard           || Binomial Coefficients
| 1473 | [Paint House III](./problems/1473-paint-house-iii.md) | [Go](./golang/1473_paint_house_iii.go) | _O(m * t * n^2)_    | _O(t * n)_          | Hard           ||
| 1477 | [Find Two Non-overlapping Sub-arrays Each With Target Sum](./problems/1477-find-two-non-overlapping-sub-arrays-each-with-target-sum.md) | [Go](./golang/1477_find_two_non_overlapping_sub_arrays_each_with_target_sum.go) | _O(n)_    | _O(n)_          | Medium           ||
| 1478 | [Allocate Mailboxes](./problems/1478-allocate-mailboxes.md) | [Go](./golang/1478_allocate_mailboxes.go) | _O(m * n^2)_    | _O(n)_          | Hard           || DP, Math, Median
| 1494 | [Parallel Courses II](./problems/1494-parallel-courses-ii.md) | [Go](./golang/1494_parallel_courses_ii.go) | _O((n * C(c, min(c, k))) * 2^n)_    | _O(2^n)_          | Hard           || Combinations
| 1504 | [Count Submatrices With All Ones](./problems/1504-count-submatrices-with-all-ones.md) | [Go](./golang/1504_count_submatrices_with_all_ones.go) | _O(m * n)_ | _O(n)_ | Medium | | Mono Stack
| 1510 | [Stone Game IV](./problems/1510-stone-game-iv.md) | [Go](./golang/1510_stone_game_iv.go) | _O(n * sqrt(n))_    | _O(n)_          | Hard           ||
| 1524 | [Number of Sub-arrays With Odd Sum](./problems/1524-number-of-sub-arrays-with-odd-sum.md) | [Go](./golang/1524_number_of_sub_arrays_with_odd_sum.go) | _O(n)_    | _O(1)_          | Medium           ||
| 1531 | [String Compression II](./problems/1531-string-compression-ii.md) | [Go](./golang/1531_string_compression_ii.go) | _O(n^2 * k)_    | _O(n * k)_          | Hard           ||
| 1547 | [Minimum Cost to Cut a Stick](./problems/1547-minimum-cost-to-cut-a-stick.md) | [Go](./golang/1547_minimum_cost_to_cut_a_stick.go) | _O(n^3)_    | _O(n^2)_          | Hard           ||
| 1548 | [The Most Similar Path in a Graph](./problems/1548-the-most-similar-path-in-a-graph.md) | [Go](./golang/1548_the_most_similar_path_in_a_graph.go) | _O(n^ * m)_    | _O(n * m)_          | Hard           | 🔒 |
| 1553 | [Minimum Number of Days to Eat N Oranges](./problems/1553-minimum-number-of-days-to-eat-n-oranges.md) | [Go](./golang/1553_minimum_number_of_days_to_eat_n_oranges.go) | _O((logn)^2)_    | _O((logn)^2)_          | Hard           ||
| 1563 | [Stone Game V](./problems/1563-stone-game-v.md) | [Go](./golang/1563_stone_game_v.go) | _O(n^2)_    | _O(n^2)_          | Hard           ||
| 1569 | [Number of Ways to Reorder Array to Get Same BST](./problems/1569-detect-pattern-of-length-m-repeated-k-or-more-times.md) | [Go](./golang/1569_detect_pattern_of_length_m_repeated_k_or_more_times.go) | _O(n^2)_    | _O(n^2)_          | Hard           || DFS
| 1575 | [Count All Possible Routes](./problems/1575-count-all-possible-routes.md) | [Go](./golang/1575_count_all_possible_routes.go) | _O(nlogn + n * f)_    | _O(n * f)_          | Hard           || Math
| 1594 | [Maximum Non Negative Product in a Matrix](./problems/1594-maximum-non-negative-product-in-a-matrix.md) | [Go](./golang/1594_maximum_non_negative_product_in_a_matrix.go) | _O(m * n)_    | _O(n)_          | Medium           || 
| 1595 | [Minimum Cost to Connect Two Groups of Points](./problems/1595-minimum-cost-to-connect-two-groups-of-points.md) | [Go](./golang/1595_minimum_cost_to_connect_two_groups_of_points.go) | _O(m * n * 2^n)_    | _O(2^n)_          | Hard           ||
| 1617 | [Count Subtrees With Max Distance Between Cities](./problems/1617-count-subtrees-with-max-distance-between-cities.md) | [Go](./golang/1617_count_subtrees_with_max_distance_between_cities.go) | _O(n^6)_    | _O(n^3)_          | Hard           || Backtracking, Graph
| 1626 | [Best Team With No Conflicts](./problems/1626-best-team-with-no-conflicts.md) | [Go](./golang/1626_best_team_with_no_conflicts.go) | _O(nloga)_    | _O(n)_          | Medium           | variant of [Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/) | Sort, DP, Segment Tree
| 1639 | [Number of Ways to Form a Target String Given a Dictionary](./problems/1639-number-of-ways-to-form-a-target-string-given-a-dictionary.md) | [Go](./golang/1639_number_of_ways_to_form_a_target_string_given_a_dictionary.go) | _O(l * (w + n))_    | _O(n)_          | Hard           | | 
| 1655 | [Distribute Repeating Integers](./problems/1655-distribute-repeating-integers.md) | [Go](./golang/1655_distribute_repeating_integers.go) | _O(n + m * 3^m)_    | _O(n + 2^m)_          | Hard           | | Submask Enumeration
| 1664 | [Ways to Make a Fair Array](./problems/1664-ways-to-make-a-fair-array.md) | [Go](./golang/1664_ways_to_make_a_fair_array.go) | _O(n)_    | _O(1)_          | Medium           | | Prefix Sum
| 1681 | [Minimum Incompatibility](./problems/1681-minimum-incompatibility.md) | [Go](./golang/1681_minimum_incompatibility.go) | _O(max(n * 2^n, 3^n))_    | _O(2^n)_          | Hard           | | Combinations, Backtracking, Submask Enumeration
| 1690 | [Stone Game VII](./problems/1690-stone-game-vii.md) | [Go](./golang/1690_stone_game_vii.go) | _O(n^2)_ | _O(n)_ | Medium |||
| 1691 | [Maximum Height by Stacking Cuboids](./problems/1691-maximum-height-by-stacking-cuboids.md) | [Go](./golang/1691_maximum_height_by_stacking_cuboids.go) | _O(n^2)_ | _O(n)_ | Hard |||
| 1692 | [Count Ways to Distribute Candies](./problems/1692-count-ways-to-distribute-candies.md) | [Go](./golang/1692_count_ways_to_distribute_candies.go) | _O(n * k)_ | _O(k)_ | Hard |🔒||
| 1745 | [Palindrome Partitioning IV](./problems/1745-palindrome-partitioning-iv.md) | [Go](./golang/1745_palindrome_partitioning_iv.go) | _O(n^2)_ | _O(n)_ | Hard | | DP, `Manacher's Algorithm` |
| 1751 | [Maximum Number of Events That Can Be Attended II](./problems/1751-maximum-number-of-events-that-can-be-attended-ii.md) |[Go](./golang/1751_maximum_number_of_events_that_can_be_attended_ii.go)| _O(nlogn + n * k)_     | _O(n * k)_         | Hard         | | Binary Search
| 1770 | [Maximum Score from Performing Multiplication Operations](./problems/1770-maximum-score-from-performing-multiplication-operations.md) |[Go](./golang/1770_maximum_score_from_performing_multiplication_operations.go)| _O(m^2)_     | _O(m)_         | Medium         | |
| 1771 | [Maximize Palindrome Length From Subsequences](./problems/1771-maximize-palindrome-length-from-subsequences.md) |[Go](./golang/1771_maximize_palindrome_length_from_subsequences.go)| _O((m + n)^2)_     | _O((m + n)^2)_         | Hard         | |
| 1774 | [Closest Dessert Cost](./problems/1774-closest-dessert-cost.md) |[Go](./golang/1774_closest_dessert_cost.go)| _O(m * t)_     | _O(t)_         | Medium         | |
| 1787 | [Make the XOR of All Segments Equal to Zero](./problems/1787-make-the-xor-of-all-segments-equal-to-zero.md) |[Go](./golang/1787_make_the_xor_of_all_segments_equal_to_zero.go)| _O(n + k * m)_     | _O(min(k * m, n))_         | Hard         | |
| 1799 | [Maximize Score After N Operations](./problems/1799-maximize-score-after-n-operations.md) |[Go](./golang/1799_maximize_score_after_n_operations.go)| _O(n^2 * 2^n)_     | _O(2^n)_         | Hard         | |
| 1803 | [Count Pairs With XOR in a Range](./problems/1803-count-pairs-with-xor-in-a-range.md) |[Go](./golang/1803_count_pairs_with_xor_in_a_range.go)| _O(n)_     | _O(n)_         | Hard         | | DP, Trie
| 1857 | [Largest Color Value in a Directed Graph](./problems/1857-largest-color-value-in-a-directed-graph.md) |[Go](./golang/1857_largest_color_value_in_a_directed_graph.go)| _O(n + m)_     | _O(n + m)_         | Hard         | | DP, Topological Sort
| 1866 | [Number of Ways to Rearrange Sticks With K Sticks Visible](./problems/1866-number-of-ways-to-rearrange-sticks-with-k-sticks-visible.md) |[Go](./golang/1866_number_of_ways_to_rearrange_sticks_with_k_sticks_visible.go)| _O(n * k)_     | _O(k)_         | Hard         | | 
| 1871 | [Jump Game VII](./problems/1871-jump-game-vii.md) |[Go](./golang/1871_jump_game_vii.go)| _O(n)_     | _O(n)_         | Medium         | | Line Sweep, DP, BFS
| 1872 | [Stone Game VIII](./problems/1872-stone-game-viii.md) |[Go](./golang/1872_stone_game_viii.go)| _O(n)_     | _O(1)_         | Hard         | |
| 1883 | [Minimum Skips to Arrive at Meeting On Time](./problems/1883-minimum-skips-to-arrive-at-meeting-on-time.md) |[Go](./golang/1883_minimum_skips_to_arrive_at_meeting_on_time.go)| _O(n^2)_     | _O(n)_         | Hard         | |
| 1896 | [Minimum Cost to Change the Final Value of Expression](./problems/1896-minimum-cost-to-change-the-final-value-of-expression.md) |[Go](./golang/1896_minimum_cost_to_change_the_final_value_of_expression.go)| _O(n)_     | _O(n)_         | Hard         | | Stack, DP |
| 1900 | [The Earliest and Latest Rounds Where Players Compete](./problems/1900-the-earliest-and-latest-rounds-where-players-compete.md) |[Go](./golang/1900_the_earliest_and_latest_rounds_where_players_compete.go)| _O(n^4)_     | _O(n^2)_         | Hard         | | |
| 1908 | [Game of Nim](./problems/1908-game-of-nim.md) |[Go](./golang/1908_game_of_nim.go)| _O(n)_     | _O(1)_         | Medium         | 🔒 | |
| 1931 | [Painting a Grid With Three Different Colors](./problems/1931-painting-a-grid-with-three-different-colors.md) |[Go](./golang/1931_painting_a_grid_with_three_different_colors.go)| _O(2^(3 * m) * logn)_     | _O(2^(2 * m))_         | Hard         | variant of [Number of Ways to Paint N × 3 Grid](https://leetcode.com/problems/number-of-ways-to-paint-n-3-grid/) | DP, Backtracking, Matrix Exponentiation, State Compression |
| 1937 | [Maximum Number of Points with Cost](./problems/1937-maximum-number-of-points-with-cost.md) |[Go](./golang/1937_maximum_number_of_points_with_cost.go)| _O(m * n)_     | _O(n)_         | Medium         | | Prefix Sum |
| 1955 | [Count Number of Special Subsequences](./problems/1955-count-number-of-special-subsequences.md) |[Go](./golang/1955_count_number_of_special_subsequences.go)| _O(n)_     | _O(1)_         | Hard         | | |
| 1959 | [Minimum Total Space Wasted With K Resizing Operations](./problems/1959-minimum-total-space-wasted-with-k-resizing-operations.md) |[Go](./golang/1959_minimum_total_space_wasted_with_k_resizing_operations.go)| _O(k * n^2)_     | _O(k * n)_         | Medium         | | |
| 1960 | [Maximum Product of the Length of Two Palindromic Substrings](./problems/1960-maximum-product-of-the-length-of-two-palindromic-substrings.md) |[Go](./golang/1960_maximum_product_of_the_length_of_two_palindromic_substrings.go)| _O(n)_     | _O(n)_         | Hard         | | `Manacher's Algorithm`, DP |
| 1977 | [Number of Ways to Separate Numbers](./problems/1977-number-of-ways-to-separate-numbers.md) |[Go](./golang/1977_number_of_ways_to_separate_numbers.go)| _O(n^2)_     | _O(n^2)_         | Hard         | | DP |
| 1981 | [Minimize the Difference Between Target and Chosen Elements](./problems/1981-minimize-the-difference-between-target-and-chosen-elements.md) |[Go](./golang/1981_minimize_the_difference_between_target_and_chosen_elements.go)| _O(t * m * n)_     | _O(t)_         | Medium         | | DP, Pruning |
| 1986 | [Minimum Number of Work Sessions to Finish the Tasks](./problems/1986-minimum-number-of-work-sessions-to-finish-the-tasks.md) |[Go](./golang/1986_minimum_number_of_work_sessions_to_finish_the_tasks.go)| _O(n * 2^n)_     | _O(2^n)_         | Medium         | | DP |
| 1987 | [Number of Unique Good Subsequences](./problems/1987-number-of-unique-good-subsequences.md) |[Go](./golang/1987_number_of_unique_good_subsequences.go)| _O(n)_     | _O(1)_         | Hard         | variant of [Distinct Subsequences II](https://leetcode.com/problems/distinct-subsequences-ii/) | DP |
| 1994 | [The Number of Good Subsets](./problems/1994-the-number-of-good-subsets.md) |[Go](./golang/1994_the_number_of_good_subsets.go)| _O(n * 2^p)_     | _O(2^p)_         | Hard         |  | DP, `Sieve of Eratosthenes` |
| 1997 | [First Day Where You Have Been in All the Rooms](./problems/1997-first-day-where-you-have-been-in-all-the-rooms.md) |[Go](./golang/1997_first_day_where_you_have_been_in_all_the_rooms.go)| _O(n)_     | _O(n)_         | Medium         |  | DP |
| 2002 | [Maximum Product of the Length of Two Palindromic Subsequences](./problems/2002-maximum-product-of-the-length-of-two-palindromic-subsequences.md) | [Go](./golang/2002_maximum_product_of_the_length_of_two_palindromic_subsequences.go) | _O(3^n)_    | _O(2^n)_          | Medium           | | DP, Submask Enumeration
| 2008 | [Maximum Earnings From Taxi](./problems/2008-maximum-earnings-from-taxi.md) | [Go](./golang/2008_maximum_earnings_from_taxi.go) | _O(n + mlogm)_    | _O(n)_          | Medium           | | DP
| 2019 | [The Score of Students Solving Math Expression](./problems/2019-the-score-of-students-solving-math-expression.md) | [Go](./golang/2019_the_score_of_students_solving_math_expression.go) | _O(n^3 * a^2)_ | _O(n^2)_ | Hard | variant of [Burst Balloons](https://leetcode.com/problems/burst-balloons/) |
| 2031 | [Count Subarrays With More Ones Than Zeros](./problems/2031-count-subarrays-with-more-ones-than-zeros.md) | [Go](./golang/2031_count_subarrays_with_more_ones_than_zeros.go) | _O(n)_ | _O(n)_ | Medium | 🔒 | Prefix Sum, DP
| 2044 | [Count Number of Maximum Bitwise-OR Subsets](./problems/2044-count-number-of-maximum-bitwise-or-subsets.md) | [Go](./golang/2044_count_number_of_maximum_bitwise_or_subsets.go) | _O(min(2^n, m * n))_ | _O(min(2^n, m))_ | Medium | | DP
| 2052 | [Minimum Cost to Separate Sentence Into Rows](./problems/2052-minimum-cost-to-separate-sentence-into-rows.md) | [Go](./golang/2052_minimum_cost_to_separate_sentence_into_rows.go) | _O(s + n * k)_ | _O(k)_ | Medium | 🔒 | DP
| 2060 | [Check if an Original String Exists Given Two Encoded Strings](./problems/2060-check-if-an-original-string-exists-given-two-encoded-strings.md) | [Go](./golang/2060_check_if_an_original_string_exists_given_two_encoded_strings.go) | _O(m * n * k)_ | _O(min(m, n) * k)_ | Hard | | DP, Memoization
| 2088 | [Count Fertile Pyramids in a Land](./problems/2088-count-fertile-pyramids-in-a-land.md) | [Go](./golang/2088_count_fertile_pyramids_in_a_land.go) | _O(m * n)_ | _O(n)_ | Hard | | DP
| 2140 | [Solving Questions With Brainpower](./problems/2140-solving-questions-with-brainpower.md) | [Go](./golang/2140_solving_questions_with_brainpower.go) | _O(n)_ | _O(n)_ | Medium | | DP
| 2143 | [Choose Numbers From Two Arrays in Range](./problems/2143-choose-numbers-from-two-arrays-in-range.md) | [Go](./golang/2143_choose_numbers_from_two_arrays_in_range.go) | _O(n^2 * v)_ | _O(n * v)_ | Hard | 🔒 | DP
| 2167 | [Minimum Time to Remove All Cars Containing Illegal Goods](./problems/2167-minimum-time-to-remove-all-cars-containing-illegal-goods.md) | [Go](./golang/2167_minimum_time_to_remove_all_cars_containing_illegal_goods.go) | _O(n)_ | _O(1)_ | Hard || DP
| 2174 | [Remove All Ones With Row and Column Flips II](./problems/2174-remove-all-ones-with-row-and-column-flips-ii.md) | [Go](./golang/2174_remove_all_ones_with_row_and_column_flips_ii.go) | _O((m * n) * 2^(m * n))_ | _O(2^(m * n))_ | Medium | 🔒 | DP, Bitmasks
| 2184 | [Number of Ways to Build Sturdy Brick Wall](./problems/2184-number-of-ways-to-build-sturdy-brick-wall.md) |[Go](./golang/2184_number_of_ways_to_build_sturdy_brick_wall.go)| _O(h * p^2)_     | _O(p^2)_         | Medium         | 🔒, variant of [Painting a Grid With Three Different Colors](https://leetcode.com/problems/painting-a-grid-with-three-different-colors/) | DP, Backtracking, Matrix Exponentiation |
| 2188 | [Minimum Time to Finish the Race](./problems/2188-minimum-time-to-finish-the-race.md) | [Go](./golang/2188_minimum_time_to_finish_the_race.go) | _O((n + l) * logc)_ | _O(n + l + logc)_ | Hard || Greedy, DP
| 2189 | [Number of Ways to Build House of Cards](./problems/2189-number-of-ways-to-build-house-of-cards.md) | [Go](./golang/2189_number_of_ways_to_build_house_of_cards.go) | _O(n^2)_ | _O(n)_ | Medium | 🔒 | DP
| 2209 | [Minimum White Tiles After Covering With Carpets](./problems/2209-minimum-white-tiles-after-covering-with-carpets.md) | [Go](./golang/2209_minimum_white_tiles_after_covering_with_carpets.go) | _O(m * n)_ | _O(m * n)_ | Hard || DP
| 2218 | [Maximum Value of K Coins From Piles](./problems/2218-maximum-value-of-k-coins-from-piles.md) | [Go](./golang/2218_maximum_value_of_k_coins_from_piles.go) | _O(min(n * k^2, m * k)))_ | _O(k)_ | Hard || DP
| 2222 | [Number of Ways to Select Buildings](./problems/2222-number-of-ways-to-select-buildings.md) | [Go](./golang/2222_number_of_ways_to_select_buildings.go) | _O(n)_ | _O(1)_ | Medium || DP
| 2247 | [Maximum Cost of Trip With K Highways](./problems/2247-maximum-cost-of-trip-with-k-highways.md) | [Go](./golang/2247_maximum_cost_of_trip_with_k_highways.go) | _O(n^2 * 2^n)_ | _O(n * 2^n)_ | Hard | 🔒 | DP, Bitmasks, BFS
| 2266 | [Count Number of Texts](./problems/2266-count-number-of-texts.md) | [Go](./golang/2266_count_number_of_texts.go) | _O(n)_ | _O(1)_ | Medium | | DP
| 2267 | [Check if There Is a Valid Parentheses String Path](./problems/2267-check-if-there-is-a-valid-parentheses-string-path.md) | [Go](./golang/2267_check_if_there_is_a_valid_parentheses_string_path.go) | _O(m * n * (m + n) / 32)_ | _O(n * (m + n) / 32)_ | Hard | variant of [Codeforces Round #801 C](https://codeforces.com/contest/1695/problem/C)| DP, Bitsets
| 2289 | [Steps to Make Array Non-decreasing](./problems/2289-steps-to-make-array-non-decreasing.md) | [Go](./golang/2289_steps_to_make_array_non_decreasing.go) | _O(n)_ | _O(n)_ | Hard | | DP, Mono Stack
| 2297 | [Jump Game VIII](./problems/2297-jump-game-viii.md) | [Go](./golang/2297_jump_game_viii.go) | _O(n)_ | _O(1)_ | Medium | 🔒 | DP, Mono Stack
| 2305 | [Fair Distribution of Cookies](./problems/2305-fair-distribution-of-cookies.md) | [Go](./golang/2305_fair_distribution_of_cookies.go) | _O(k * 3^n)_ | _O(2^n)_ | Medium | | DP, Submask Enumeration
| 2313 | [Minimum Flips in Binary Tree to Get Result](./problems/2313-minimum-flips-in-binary-tree-to-get-result.md) | [Go](./golang/2313_minimum_flips_in_binary_tree_to_get_result.go) | _O(n)_ | _O(h)_ | Hard | 🔒 | Tree DP
| 2318 | [Number of Distinct Roll Sequences](./problems/2318-number-of-distinct-roll-sequences.md) | [Go](./golang/2318_number_of_distinct_roll_sequences.go) | _O(6^3 * n)_ | _O(6^2)_ | Hard | | DP
| 2320 | [Count Number of Ways to Place Houses](./problems/2320-count-number-of-ways-to-place-houses.md) | [Go](./golang/2320_count_number_of_ways_to_place_houses.go) | _O(logn)_    | _O(1)_          | Medium           | variant of [Fibonacci Number](https://leetcode.com/problems/fibonacci-number/) | Matrix Exponentiation
| 2327 | [Number of People Aware of a Secret](./problems/2327-number-of-people-aware-of-a-secret.md) | [Go](./golang/2327_number_of_people_aware_of_a_secret.go) | _O(n)_    | _O(f)_          | Medium           | | DP
| 2328 | [Number of Increasing Paths in a Grid](./problems/2328-number-of-increasing-paths-in-a-grid.md) | [Go](./golang/2328_number_of_increasing_paths_in_a_grid.go) | _O(m * n)_    | _O(m * n)_          | Hard           | | Memoization, Topological Sort, DP
| 2361 | [Minimum Costs Using the Train Line](./problems/2361-minimum-costs-using-the-train-line.md) | [Go](./golang/2361_minimum_costs_using_the_train_line.go) | _O(n)_    | _O(1)_          | Hard           | 🔒 | DP
| 2369 | [Check if There is a Valid Partition For The Array](./problems/2369-check-if-there-is-a-valid-partition-for-the-array.md) | [Go](./golang/2369_check_if_there_is_a_valid_partition_for_the_array.go) | _O(n)_    | _O(1)_          | Medium           | | DP
| 2370 | [Longest Ideal Subsequence](./problems/2370-longest-ideal-subsequence.md) | [Go](./golang/2370_longest_ideal_subsequence.go) | _O(n)_    | _O(1)_          | Medium           | | DP
| 2378 | [Choose Edges to Maximize Score in a Tree](./problems/2378-choose-edges-to-maximize-score-in-a-tree.md) | [Go](./golang/2378_choose_edges_to_maximize_score_in_a_tree.go) | _O(n)_          | _O(n)_          | Medium           |🔒| DFS, Stack, Tree DP |
| 2380 | [Time Needed to Rearrange a Binary String](./problems/2380-time-needed-to-rearrange-a-binary-string.md) | [Go](./golang/2380_time_needed_to_rearrange_a_binary_string.go) | _O(n)_    | _O(1)_          | Medium           | | DP
| 2403 | [Minimum Time to Kill All Monsters](./problems/2403-minimum-time-to-kill-all-monsters.md) | [Go](./golang/2403_minimum_time_to_kill_all_monsters.go) | _O(n * 2^n)_    | _O(2^n)_          | Hard           |🔒| Bitmasks, DP
| 2420 | [Find All Good Indices](./problems/2420-find-all-good-indices.md) | [Go](./golang/2420_find_all_good_indices.go) | _O(n)_    | _O(n)_          | Medium           | | Prefix Sum
| 2430 | [Maximum Deletions on a String](./problems/2430-maximum-deletions-on-a-string.md) | [Go](./golang/2430_maximum_deletions_on_a_string.go) | _O(n^2)_    | _O(n)_          | Hard           | | DP, `Rabin-Karp Algorithm`, Rolling Hash, Longest Prefix Suffix, `KMP Algorithm`
| 2431 | [Maximize Total Tastiness of Purchased Fruits](./problems/2431-maximize-total-tastiness-of-purchased-fruits.md) | [Go](./golang/2431_maximize_total_tastiness_of_purchased_fruits.go) | _O(n * a * c)_    | _O(a * c)_          | Medium           |🔒| DP
| 2435 | [Paths in Matrix Whose Sum Is Divisible by K](./problems/2435-paths-in-matrix-whose-sum-is-divisible-by-k.md) | [Go](./golang/2435_paths_in_matrix_whose_sum_is_divisible_by_k.go) | _O(m * n * k)_    | _O(n * k)_          | Hard           || DP
| 2447 | [Number of Subarrays With GCD Equal to K](./problems/2447-number-of-subarrays-with-gcd-equal-to-k.md) | [Go](./golang/2447_number_of_subarrays_with_gcd_equal_to_k.go) | _O(nlogr)_    | _O(logr)_          | Medium           || DP
| 2463 | [Minimum Total Distance Traveled](./problems/2463-minimum-total-distance-traveled.md) | [Go](./golang/2463_minimum_total_distance_traveled.go) | _O(mlogm + nlogn + m * n)_    | _O(n)_          | Hard           || Sort, DP, Prefix Sum, Mono Deque
| 2464 | [Minimum Subarrays in a Valid Split](./problems/2464-minimum-subarrays-in-a-valid-split.md) | [Go](./golang/2464_minimum_subarrays_in_a_valid_split.go) | _O(n^2 * logr)_    | _O(n)_          | Medium           | 🔒 | DP
| 2466 | [Count Ways To Build Good Strings](./problems/2466-count-ways-to-build-good-strings.md) | [Go](./golang/2466_count_ways_to_build_good_strings.go) | _O(n)_    | _O(n)_          | Medium           | | DP
| 2470 | [Number of Subarrays With LCM Equal to K](./problems/2470-number-of-subarrays-with-lcm-equal-to-k.md) | [Go](./golang/2470_number_of_subarrays_with_lcm_equal_to_k.go) | _O(n * sqrt(k) * logk)_    | _O(sqrt(k))_          | Medium           | variant of [Number of Subarrays With GCD Equal to K](https://leetcode.com/problems/number-of-subarrays-with-gcd-equal-to-k/) | DP
| 2470 | [Number of Subarrays With LCM Equal to K](./problems/2470-number-of-subarrays-with-lcm-equal-to-k.md) | [Go](./golang/2470_number_of_subarrays_with_lcm_equal_to_k.go) | _O(n * sqrt(k) * logk)_    | _O(sqrt(k))_          | Medium           | variant of [Number of Subarrays With GCD Equal to K](https://leetcode.com/problems/number-of-subarrays-with-gcd-equal-to-k/) | DP
| 2475 | [Number of Unequal Triplets in Array](./problems/2475-number-of-unequal-triplets-in-array.md) | [Go](./golang/2475_number_of_unequal_triplets_in_array.go) | _O(n)_    | _O(n)_          | Easy           | | DP, Freq Table, Math
| 2478 | [Number of Beautiful Partitions](./problems/2478-number-of-beautiful-partitions.md) | [Go](./golang/2478_number_of_beautiful_partitions.go) | _O(n * k)_    | _O(n)_          | Hard           | | DP
| 2495 | [Number of Subarrays Having Even Product](./problems/2495-number-of-subarrays-having-even-product.md) | [Go](./golang/2495_number_of_subarrays_having_even_product.go) | _O(n)_    | _O(1)_          | Medium           | 🔒 | DP, Math
| 2510 | [Check if There is a Path With Equal Number of 0's And 1's](./problems/2510-check-if-there-is-a-path-with-equal-number-of-0s-and-1s.md) | [Go](./golang/2510_check_if_there_is_a_path_with_equal_number_of_0s_and_1s.go) | _O(m * n)_    | _O(n)_          | Medium           | 🔒 | DP
| 2518 | [Number of Great Partitions](./problems/2518-number-of-great-partitions.md) | [Go](./golang/2518_number_of_great_partitions.go) | _O(n * k)_    | _O(k)_          | Hard           | | Knapsack DP
| 2533 | [Number of Good Binary Strings](./problems/2533-number-of-good-binary-strings.md) | [Go](./golang/2533_number_of_good_binary_strings.go) | _O(n)_    | _O(w)_          | Medium           | 🔒 | DP
| 2538 | [Difference Between Maximum and Minimum Price Sum](./problems/2538-difference-between-maximum-and-minimum-price-sum.md) | [Go](./golang/2538_difference_between_maximum_and_minimum_price_sum.go) | _O(n)_    | _O(n)_          | Hard           | | DFS, Tree DP
| 2547 | [Minimum Cost to Split an Array](./problems/2547-minimum-cost-to-split-an-array.md) | [Go](./golang/2547_minimum_cost_to_split_an_array.go) | _O(n^2)_    | _O(n)_          | Hard           | | DP
| 2552 | [Count Increasing Quadruplets](./problems/2552-count-increasing-quadruplets.md) | [Go](./golang/2552_count_increasing_quadruplets.go) | _O(n^2)_    | _O(n)_          | Hard           | variant of [132 Pattern](https://leetcode.com/problems/132-pattern/) | DP, Prefix Sum
| 2556 | [Disconnect Path in a Binary Matrix by at Most One Flip](./problems/2556-disconnect-path-in-a-binary-matrix-by-at-most-one-flip.md) | [Go](./golang/2556_disconnect_path_in_a_binary_matrix_by_at_most_one_flip.go) | _O(m * n)_    | _O(m + n)_          | Medium           | | DP, DFS
| 2565 | [Subsequence With the Minimum Score](./problems/2565-subsequence-with-the-minimum-score.md) | [Go](./golang/2565_subsequence_with_the_minimum_score.go) | _O(n)_    | _O(n)_          | Hard           | | Two Pointers, DP
| 2572 | [Count the Number of Square-Free Subsets](./problems/2572-count-the-number-of-square-free-subsets.md) | [Go](./golang/2572_count_the_number_of_square_free_subsets.go) | _O(n + m * 2^p)_   | _O(m * 2^p)_        | Medium         | | Number Theory, Combinatorics, Bitmasks, Memoization, DP
| 2585 | [Number of Ways to Earn Points](./problems/2585-number-of-ways-to-earn-points.md) | [Go](./golang/2585_number_of_ways_to_earn_points.go) | _O(n * t * c)_   | _O(t)_        | Hard         | | Knapsack DP
| 2597 | [The Number of Beautiful Subsets](./problems/2597-the-number-of-beautiful-subsets.md) | [Go](./golang/2597_the_number_of_beautiful_subsets.go) | _O(n)_   | _O(n)_        | Medium         | | Combinatorics, DP
| 2638 | [Count the Number of K-Free Subsets](./problems/2638-count-the-number-of-k-free-subsets.md) | [Go](./golang/2638_count_the_number_of_k_free_subsets.go) | _O(n)_   | _O(n)_        | Medium         | 🔒, variant of [The Number of Beautiful Subsets](https://leetcode.com/problems/the-number-of-beautiful-subsets/) | Combinatorics, DP
| 2646 | [Minimize the Total Price of the Trips](./problems/2646-minimize-the-total-price-of-the-trips.md) | [Go](./golang/2646_minimize_the_total_price_of_the_trips.go) | _O(t * n)_   | _O(n)_        | Hard         | | DFS, Tree DP
| 2681 | [Power of Heroes](./problems/2681-power-of-heroes.md) | [Go](./golang/2681_power_of_heroes.go) | _O(nlogn)_   | _O(1)_        | Hard         | | Sort, Combinatorics, DP
| 2684 | [Maximum Number of Moves in a Grid](./problems/2684-maximum-number-of-moves-in-a-grid.md) | [Go](./golang/2684_maximum_number_of_moves_in_a_grid.go) | _O(m * n)_   | _O(m)_        | Medium         | | DP, BFS
| 2707 | [Extra Characters in a String](./problems/2707-extra-characters-in-a-string.md) | [Go](./golang/2707_extra_characters_in_a_string.go) | _O(n * l)_   | _O(n + t)_        | Medium         | | DP, Trie
| 2713 | [Maximum Strictly Increasing Cells in a Matrix](./problems/2713-maximum-strictly-increasing-cells-in-a-matrix.md) | [Go](./golang/2713_maximum_strictly_increasing_cells_in_a_matrix.go) | _O(m * n * log(m * n))_   | _O(m * n)_        | Hard         | | Sort, DP
| 2719 | [Count of Integers](./problems/2719-count-of-integers.md) | [Go](./golang/2719_count_of_integers.go) | _O(m * n)_   | _O(m + n)_        | Hard         | | Combinatorics, DP
| 2742 | [Painting the Walls](./problems/2742-painting-the-walls.md) | [Go](./golang/2742_painting_the_walls.go) | _O(n^2)_   | _O(n)_        | Hard         | | Knapsack DP
| 2746 | [Decremental String Concatenation](./problems/2746-decremental-string-concatenation.md) | [Go](./golang/2746_decremental_string_concatenation.go) | _O(n)_   | _O(1)_        | Medium         | | DP
| 2767 | [Partition String Into Minimum Beautiful Substrings](./problems/2767-partition-string-into-minimum-beautiful-substrings.md) | [Go](./golang/2767_partition_string_into_minimum_beautiful_substrings.go) | _O(n^2)_   | _O(n)_        | Medium         | | DP
| 2770 | [Maximum Number of Jumps to Reach the Last Index](./problems/2770-maximum-number-of-jumps-to-reach-the-last-index.md) | [Go](./golang/2770_maximum_number_of_jumps_to_reach_the_last_index.go) | _O(n^2)_   | _O(n)_        | Medium         | | DP
| 2771 | [Longest Non-decreasing Subarray From Two Arrays](./problems/2771-longest-non-decreasing-subarray-from-two-arrays.md) | [Go](./golang/2771_longest_non_decreasing_subarray_from_two_arrays.go) | _O(n)_   | _O(1)_        | Medium         | | DP
| 2786 | [Visit Array Positions to Maximize Score](./problems/2786-visit-array-positions-to-maximize-score.md) | [Go](./golang/2786_visit_array_positions_to_maximize_score.go) | _O(n)_   | _O(1)_        | Medium         | | DP
| 2787 | [Ways to Express an Integer as Sum of Powers](./problems/2787-ways-to-express-an-integer-as-sum-of-powers.md) | [Go](./golang/2787_ways_to_express_an_integer_as_sum_of_powers.go) | _O(nlogn)_   | _O(n)_        | Medium         | | Knapsack DP
| 2801 | [Count Stepping Numbers in Range](./problems/2801-count-stepping-numbers-in-range.md) | [Go](./golang/2801_count_stepping_numbers_in_range.go) | _O(n)_   | _O(1)_        | Hard         | | DP
| 2809 | [Minimum Time to Make Array Sum At Most x](./problems/2809-minimum-time-to-make-array-sum-at-most-x.md) | [Go](./golang/2809_minimum_time_to_make_array_sum_at_most_x.go) | _O(n^2)_   | _O(n)_        | Hard         | | Sort, Greedy, DP, Linear Search
| 2826 | [Sorting Three Groups](./problems/2826-sorting-three-groups.md) | [Go](./golang/2826_sorting_three_groups.go) | _O(n)_   | _O(1)_        | Medium         | | DP
| 2827 | [Number of Beautiful Integers in the Range](./problems/2827-number-of-beautiful-integers-in-the-range.md) | [Go](./golang/2827_number_of_beautiful_integers_in_the_range.go) | _O(n^2 * k)_   | _O(n * k)_        | Hard         | | DP, Memoization
| 2830 | [Maximize the Profit as the Salesman](./problems/2830-maximize-the-profit-as-the-salesman.md) | [Go](./golang/2830_maximize_the_profit_as_the_salesman.go) | _O(n + m)_   | _O(n + m)_        | Medium         | | DP
| 2858 | [Minimum Edge Reversals So Every Node Is Reachable](./problems/2858-minimum-edge-reversals-so-every-node-is-reachable.md) | [Go](./golang/2858_minimum_edge_reversals_so_every_node_is_reachable.go) | _O(n)_   | _O(n)_        | Hard         | | DFS, Tree DP
| 2867 | [Count Valid Paths in a Tree](./problems/2867-count-valid-paths-in-a-tree.md) | [Go](./golang/2867_count_valid_paths_in_a_tree.go) | _O(n)_   | _O(n)_        | Hard         | | Number Theory, `Linear Sieve of Eratosthenes`, DFS, Tree DP, Union Find
| 2896 | [Apply Operations to Make Two Strings Equal](./problems/2896-apply-operations-to-make-two-strings-equal.md) | [Go](./golang/2896_apply_operations_to_make_two_strings_equal.go) | _O(n)_   | _O(1)_        | Medium         | | DP
| 2901 | [Longest Unequal Adjacent Groups Subsequence II](./problems/2901-longest-unequal-adjacent-groups-subsequence-ii.md) | [Go](./golang/2901_longest_unequal_adjacent_groups_subsequence_ii.go) | _O(n^2)_ | _O(n)_ | Medium |  | DP, Backtracing, LIS DP
| 2902 | [Count of Sub-Multisets With Bounded Sum](./problems/2902-count-of-sub-multisets-with-bounded-sum.md) | [Go](./golang/2902_count_of_sub_multisets_with_bounded_sum.go) | _O(n + d * r)_ | _O(d + r)_ | Hard |  | Freq Table, DP, Sliding Window, Combinatorics
| 2911 | [Minimum Changes to Make K Semi-palindromes](./problems/2911-minimum-changes-to-make-k-semi-palindromes.md) | [Go](./golang/2911_minimum_changes_to_make_k_semi_palindromes.go) | _O(n^3)_ | _O(n^2 * logn)_ | Hard |  | Number Theory, DP
| 2912 | [Number of Ways to Reach Destination in the Grid](./problems/2912-number-of-ways-to-reach-destination-in-the-grid.md) | [Go](./golang/2912_number_of_ways_to_reach_destination_in_the_grid.go) | _O(logn)_ | _O(1)_ | Hard | 🔒 | DP, Matrix Exponentiation
| 2913 | [Subarrays Distinct Element Sum of Squares I](./problems/2913-subarrays-distinct-element-sum-of-squares-i.md) | [Go](./golang/2913_subarrays_distinct_element_sum_of_squares_i.go) | _O(nlogn)_ | _O(n)_ | Easy | | DP, Segment Tree, BIT, Fenwick Tree, Ordered Set, Sorted List, Math, Hash Table
| 2915 | [Length of the Longest Subsequence That Sums to Target](./problems/2915-length-of-the-longest-subsequence-that-sums-to-target.md) | [Go](./golang/2915_length_of_the_longest_subsequence_that_sums_to_target.go) | _O(n * t)_ | _O(t)_ | Medium | | Knapsack DP
| 2916 | [Subarrays Distinct Element Sum of Squares II](./problems/2916-subarrays-distinct-element-sum-of-squares-ii.md) | [Go](./golang/2916_subarrays_distinct_element_sum_of_squares_ii.go) | _O(nlogn)_ | _O(n)_ | Easy | | DP, Segment Tree, BIT, Fenwick Tree, Ordered Set, Sorted List, Math
| 2919 | [Minimum Increment Operations to Make Array Beautiful](./problems/2919-minimum-increment-operations-to-make-array-beautiful.md) | [Go](./golang/2919_minimum_increment_operations_to_make_array_beautiful.go) | _O(n)_ | _O(1)_ | Medium | | DP
| 2920 | [Maximum Points After Collecting Coins From All Nodes](./problems/2920-maximum-points-after-collecting-coins-from-all-nodes.md) | [Go](./golang/2920_maximum_points_after_collecting_coins_from_all_nodes.go) | _O(nlogr)_ | _O(n)_ | Hard | | Tree DP, Memoization, DFS, Pruning
| 2925 | [Maximum Score After Applying Operations on a Tree](./problems/2925-maximum-score-after-applying-operations-on-a-tree.md) | [Go](./golang/2925_maximum_score_after_applying_operations_on_a_tree.go) | _O(n)_ | _O(n)_ | Medium | | DFS, Tree DP
| 2941 | [Maximum GCD-Sum of a Subarray](./problems/2941-maximum-gcd-sum-of-a-subarray.md) | [Go](./golang/2941_maximum_gcd_sum_of_a_subarray.go) | _O(nlogr)_ | _O(logr)_ | Hard | 🔒 | Number Theory, DP, Prefix Sum, Binary Search, RMQ, Sparse Table
| 2944 | [Minimum Number of Coins for Fruits](./problems/2944-minimum-number-of-coins-for-fruits.md) | [Go](./golang/2944_minimum_number_of_coins_for_fruits.go) | _O(n)_ | _O(n)_ | Medium | | DP, Sorted List, BST, Mono Deque
| 2945 | [Find Maximum Non-decreasing Array Length](./problems/2945-find-maximum-non-decreasing-array-length.md) | [Go](./golang/2945_find_maximum_non_decreasing_array_length.go) | _O(n)_ | _O(n)_ | Hard | | DP, Greedy, Prefix Sum, Binary Search, Mono Stack, Mono Deque, Two Pointers
| 2969 | [Minimum Number of Coins for Fruits II](./problems/2969-minimum-number-of-coins-for-fruits-ii.md) | [Go](./golang/2969_minimum_number_of_coins_for_fruits_ii.go) | _O(n)_ | _O(n)_ | Hard | 🔒 | DP, Sorted List, BST, Mono Deque
| 2976 | [Minimum Cost to Convert String I](./problems/2976-minimum-cost-to-convert-string-i.md) | [Go](./golang/2976_minimum_cost_to_convert_string_i.go) | _O(o + k * eloge + n)_ | _O(o + k * v)_ | Medium | | `Dijkstra's Algorithm`, `Floyd-Warshall Algorithm`, DP, Memoization
| 2977 | [Minimum Cost to Convert String II](./problems/2977-minimum-cost-to-convert-string-ii.md) | [Go](./golang/2977_minimum_cost_to_convert_string_ii.go) | _O(o * l + k * eloge + n * l)_ | _O(t + k * v + l)_ | Hard | | `Dijkstra's Algorithm`, `Floyd-Warshall Algorithm`, DP, Memoization, Trie
| 2992 | [Number of Self-Divisible Permutations](./problems/2992-number-of-self-divisible-permutations.md) | [Go](./golang/2992_number_of_self_divisible_permutations.go) | _O(n * 2^n)_ | _O(2^n)_ | Medium | 🔒 | Bitmasks, DP
| 2998 | [Minimum Number of Operations to Make X and Y Equal](./problems/2998-minimum-number-of-operations-to-make-x-and-y-equal.md) | [Go](./golang/2998_minimum_number_of_operations_to_make_x_and_y_equal.go) | _O(x)_ | _O(x)_ | Medium | | Memoization, BFS

## Binary Search

### 1. Sorted Array

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0004 | [Median of Two Sorted Arrays](./problems/0004-median-of-two-sorted-arrays.md) | [Go](./golang/0004_median_of_two_sorted_arrays.go) | _O(log(min(m, n)))_ | _O(1)_ | Hard         ||
| 0033 | [Search in Rotated Sorted Array](./problems/0033-search-in-rotated-sorted-array.md) | [Go](./golang/0033_search_in_rotated_sorted_array.go) | _O(logn)_ | _O(1)_   | Medium         | CTCI |
| 0034 | [Find First and Last Position of Element in Sorted Array](./problems/0034-find-first-and-last-position-of-element-in-sorted-array.md) | [Go](./golang/0034_find_first_and_last_position_of_element_in_sorted_array.go) | _O(logn)_ | _O(1)_   | Medium         ||
| 0035 | [Search Insert Position](./problems/0035-search-insert-position.md) | [Go](./golang/0035_search_insert_position.go) | _O(logn)_ | _O(1)_   | Medium         ||
| 0081 | [Search in Rotated Sorted Array II](./problems/0081-search-in-rotated-sorted-array-ii.md) | [Go](./golang/0081_search_in_rotated_sorted_array_ii.go) | _O(logn)_ ~ _O(n)_ | _O(1)_   | Medium         | CTCI |
| 0153 | [Find Minimum in Rotated Sorted Array](./problems/0153-find-minimum-in-rotated-sorted-array.md) | [Go](./golang/0153_find_minimum_in_rotated_sorted_array.go)       | _O(logn)_        | _O(1)_          | Medium         ||
| 0154 | [Find Minimum in Rotated Sorted Array II](./problems/0154-find-minimum-in-rotated-sorted-array-ii.md) | [Go](./golang/0154_find_minimum_in_rotated_sorted_array_ii.go)       | _O(logn)_ ~ _O(n)_        | _O(1)_          | Hard         ||
| 0278 | [First Bad Version](./problems/0278-first-bad-version.md) | [Go](./golang/0278_first_bad_version.go)  | _O(logn)_ | _O(1)_ | Easy         | LintCode ||
| 0540 | [Single Element in a Sorted Array](./problems/0540-dsingle-element-in-a-sorted-array.md) | [Go](./golang/0540_dsingle_element_in_a_sorted_array.go)| _O(logn)_ | _O(1)_ | Medium | |
| 0702 | [Search in a Sorted Array of Unknown Size](./problems/0702-search-in-a-sorted-array-of-unknown-size.md) | [Go](./golang/0702_search_in_a_sorted_array_of_unknown_size.go) | _O(logn)_       | _O(1)_          | Medium         |🔒| Binary Search |
| 1060 | [Missing Element in Sorted Array](./problems/1060-missing-element-in-sorted-array.md) | [Go](./golang/1060_missing_element_in_sorted_array.go) | _O(logn)_ | _O(1)_ | Medium |🔒| |
| 1287 | [Element Appearing More Than 25% In Sorted Array](./problems/1287-element-appearing-more-than-25-in-sorted-array.md) | [Go](./golang/1287_element_appearing_more_than_25_in_sorted_array.go) | _O(logn)_ | _O(1)_ | Easy | |

---

### 2. Matrix / 2D

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0074 | [Search a 2D Matrix](./problems/0074-search-a-2d-matrix.md) | [Go](./golang/0074_search_a_2d_matrix.go) | _O(logm + logn)_ | _O(1)_ | Medium   ||
| 0363 | [Max Sum of Rectangle No Larger Than K](./problems/0363-max-sum-of-sub-matrix-no-larger-than-k.md) | [Go](./golang/0363_max_sum_of_sub_matrix_no_larger_than_k.go)  | _O(min(m, n)^2 * max(m, n) * logn(max(m, n)))_ | _O(max(m, n))_ | Hard         |||
| 2387 | [Median of a Row Wise Sorted Matrix](./problems/2387-median-of-a-row-wise-sorted-matrix.md) | [Go](./golang/2387_median_of_a_row_wise_sorted_matrix.go) | _O(logr * mlogn)_ | _O(1)_ | Medium | 🔒 | Binary Search |

---

### 3. Answer on Value

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0410 | [Split Array Largest Sum](./problems/0410-split-array-largest-sum.md) | [Go](./golang/0410_split_array_largest_sum.go)   | _O(nlogs)_          | _O(1)_          | Hard         | |
| 0475 | [Heaters](./problems/0475-heaters.md) | [Go](./golang/0475_heaters.go) | _O((m + n) * logn)_ | _O(1)_ | Easy | |
| 0774 | [Minimize Max Distance to Gas Station](./problems/0774-minimize-max-distance-to-gas-station.md) | [Go](./golang/0774_minimize_max_distance_to_gas_station.go) | _O(nlogr)_ | _O(1)_ | Hard | |
| 0875 | [Koko Eating Bananas](./problems/0875-koko-eating-bananas.md) | [Go](./golang/0875_koko_eating_bananas.go) | _O(nlogr)_ | _O(1)_ | Medium | |

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0069 | [Sqrt(x)](./problems/0069-sqrtx.md) | [Go](./golang/0069_sqrtx.go)      | _O(logn)_        | _O(1)_         | Medium         ||
| 0162 | [Find Peak Element](./problems/0162-find-peak-element.md) | [Go](./golang/0162_find_peak_element.go)        | _O(logn)_       | _O(1)_          | Medium         ||
| 0222 | [Count Complete Tree Nodes](./problems/0222-count-complete-tree-nodes.md) | [Go](./golang/0222_count_complete_tree_nodes.go) | _O((logn)^2)_       | _O(1)_          | Medium         ||
| 0275 | [H-Index II](./problems/0275-h-index-ii.md) | [Go](./golang/0275_h_index_ii.go)  | _O(logn)_ | _O(1)_ | Medium         || Binary Search |
| 0300 | [Longest Increasing Subsequence](./problems/0300-longest-increasing-subsequence.md) | [Go](./golang/0300_longest_increasing_subsequence.go)  | _O(nlogn)_ | _O(n)_ | Medium         | CTCI, LintCode | Binary Search, BIT, Fenwick Tree, Segment Tree, DP|
| 0302 | [Smallest Rectangle Enclosing Black Pixels](./problems/0302-smallest-rectangle-enclosing-black-pixels.md) | [Go](./golang/0302_smallest_rectangle_enclosing_black_pixels.go)   | _O(nlogn)_          | _O(1)_          | Hard         | 🔒 |
| 0354 | [Russian Doll Envelopes](./problems/0354-russian-doll-envelopes.md) | [Go](./golang/0354_russian_doll_envelopes.go)  | _O(nlogn)_ | _O(1)_ | Hard         |||
| 0367 | [Valid Perfect Square](./problems/0367-valid-perfect-square.md) | [Go](./golang/0367_valid_perfect_square.go)   | _O(logn)_          | _O(1)_          | Medium         | |
| 0374 | [Guess Number Higher or Lower](./problems/0374-guess-number-higher-or-lower.md) | [Go](./golang/0374_guess_number_higher_or_lower.go)   | _O(logn)_          | _O(1)_          | Easy         | |
| 0436 | [Find Right Interval](./problems/0436-find-right-interval.md) | [Go](./golang/0436_find_right_interval.go) | _O(nlogn)_ | _O(n)_ | Medium | |
| 0658 | [Find K Closest Elements](./problems/0658-find-k-closest-elements.md) | [Go](./golang/0658_find_k_closest_elements.go) | _O(logn + k)_ | _O(1)_ | Medium | |
| 0668 | [Kth Smallest Number in Multiplication Table](./problems/0668-kth-smallest-number-in-multiplication-table.md) | [Go](./golang/0668_kth_smallest_number_in_multiplication_table.go) | _O(m * log(m * n))_ | _O(1)_ | Hard | |
| 0704 | [Binary Search](./problems/0704-binary-search.md) | [Go](./golang/0704_binary_search.go) | _O(logn)_       | _O(1)_          | Easy         || Binary Search |
| 0710 | [Random Pick with Blacklist](./problems/0710-random-pick-with-blacklist.md) | [Go](./golang/0710_random_pick_with_blacklist.go) | ctor: _O(b)_ <br> pick: _O(1)_ | _O(b)_ | Hard | |
| 0719 | [Find K-th Smallest Pair Distance](./problems/0719-find-k-th-smallest-pair-distance.md) | [Go](./golang/0719_find_k_th_smallest_pair_distance.go) | _O(nlogn + nlogw)_ | _O(1)_ | Hard | |
| 0744 | [Find Smallest Letter Greater Than Target](./problems/0744-find-smallest-letter-greater-than-target.md) | [Go](./golang/0744_find_smallest_letter_greater_than_target.go) | _O(logn)_ | _O(1)_ | Easy | |
| 0786 | [K-th Smallest Prime Fraction](./problems/0786-k-th-smallest-prime-fraction.md) | [Go](./golang/0786_k_th_smallest_prime_fraction.go) | _O(nlogr)_ | _O(1)_ | Hard | |
| 0793 | [Preimage Size of Factorial Zeroes Function](./problems/0793-preimage-size-of-factorial-zeroes-function.md) | [Go](./golang/0793_preimage_size_of_factorial_zeroes_function.go) | _O((logn)^2)_ | _O(1)_ | Hard | |
| 0852 | [Peak Index in a Mountain Array](./problems/0852-peak-index-in-a-mountain-array.md) | [Go](./golang/0852_peak_index_in_a_mountain_array.go) | _O(logn)_ | _O(1)_ | Easy | |
| 0878 | [Nth Magical Number](./problems/0878-nth-magical-number.md) | [Go](./golang/0878_nth_magical_number.go) | _O(logn)_ | _O(1)_ | Hard | |
| 0894 | [All Possible Full Binary Trees](./problems/0894-all-possible-full-binary-trees.md) | [Go](./golang/0894_all_possible_full_binary_trees.go) | _O(n * 4^n / n^(3/2))_ | _O(n * 4^n / n^(3/2))_ | Medium    || 
| 0911 | [Online Election](./problems/0911-online-election.md) | [Go](./golang/0911_online_election.go) | ctor: _O(n)_<br> query : _O(logn)_ | _O(n)_ | Medium    || 
| 0981 | [Time Based Key-Value Store](./problems/0981-time-based-key-value-store.md) | [Go](./golang/0981_time_based_key_value_store.go) | set: _O(1)_<br> get : _O(logn)_ | _O(n)_ | Medium    || 
| 1011 | [Capacity To Ship Packages Within D Days](./problems/1011-capacity-to-ship-packages-within-d-days.md) | [Go](./golang/1011_capacity_to_ship_packages_within_d_days.go) | _O(nlogr)_ | _O(1)_ | Medium | |
| 1044 | [Longest Duplicate Substring](./problems/1044-longest-duplicate-substring.md) | [Go](./golang/1044_longest_duplicate_substring.go) | _O(nlogn)_ | _O(n)_ | Hard | | `Rabin-Karp Algorithm`, Suffix Tree, `Ukkonen's Algorithm`
| 1062 | [Longest Repeating Substring](./problems/1062-longest-repeating-substring.md) | [Go](./golang/1062_longest_repeating_substring.go) | _O(nlogn)_ | _O(n)_ | Medium |🔒| `Rabin-Karp Algorithm`
| 1064 | [Fixed Point](./problems/1064-fixed-point.md) | [Go](./golang/1064_fixed_point.go) | _O(logn)_ | _O(1)_ | Easy |🔒| |
| 1095 | [Find in Mountain Array](./problems/1095-find-in-mountain-array.md) | [Go](./golang/1095_find_in_mountain_array.go) | _O(logn)_ | _O(1)_ | Hard | | |
| 1110 | [Delete Nodes And Return Forest](./problems/1110-delete-nodes-and-return-forest.md) | [Go](./golang/1110_delete_nodes_and_return_forest.go) | _O(n)_ | _O(h + d)_ | Medium | |
| 1170 | [Compare Strings by Frequency of the Smallest Character](./problems/1170-compare-strings-by-frequency-of-the-smallest-character.md) | [Go](./golang/1170_compare_strings_by_frequency_of_the_smallest_character.go) | _O((m + n)logn)_ | _O(n)_ | Easy | |
| 1201 | [Ugly Number III](./problems/1201-ugly-number-iii.md) | [Go](./golang/1201_ugly_number_iii.go) | _O(logn)_ | _O(1)_ | Medium | | Inclusion-Exclusion Principle
| 1228 | [Missing Number In Arithmetic Progression](./problems/1228-missing-number-in-arithmetic-progression.md) | [Go](./golang/1228_missing_number_in_arithmetic_progression.go) | _O(logn)_ | _O(1)_ | Easy | |
| 1231 | [Divide Chocolate](./problems/1231-divide-chocolate.md) | [Go](./golang/1231_divide_chocolate.go) | _O(nlogn)_ | _O(1)_ | Hard | |
| 1274 | [Number of Ships in a Rectangle](./problems/1274-number-of-ships-in-a-rectangle.md) | [Go](./golang/1274_number_of_ships_in_a_rectangle.go) | _O(log(m * n))_ | _O(log(m * n))_ | Hard | | Divide and Conquer
| 1283 | [Find the Smallest Divisor Given a Threshold](./problems/1283-find-the-smallest-divisor-given-a-threshold.md) | [Go](./golang/1283_find_the_smallest_divisor_given_a_threshold.go) | _O(logn)_ | _O(1)_ | Medium | |
| 1385 | [Find the Distance Value Between Two Arrays](./problems/1385-find-the-distance-value-between-two-arrays.md) | [Go](./golang/1385_find_the_distance_value_between_two_arrays.go) | _O((n + m) * logm)_ | _O(1)_ | Easy | | Binary Search, Two Pointers
| 1482 | [Minimum Number of Days to Make m Bouquets](./problems/1482-minimum-number-of-days-to-make-m-bouquets.md) | [Go](./golang/1482_minimum_number_of_days_to_make_m_bouquets.go) | _O(nlogd)_ | _O(1)_ | Medium | |
| 1533 | [Find the Index of the Large Integer](./problems/1533-find-the-index-of-the-large-integer.md) | [Go](./golang/1533_find_the_index_of_the_large_integer.go) | _O(logn)_ | _O(1)_ | Medium | 🔒 |
| 1539 | [Kth Missing Positive Number](./problems/1539-kth-missing-positive-number.md) | [Go](./golang/1539_kth_missing_positive_number.go) | _O(logn)_ | _O(1)_ | Easy | |
| 1552 | [Magnetic Force Between Two Balls](./problems/1552-magnetic-force-between-two-balls.md) | [Go](./golang/1552_magnetic_force_between_two_balls.go) | _O(nlogn + nlogr)_ | _O(1)_ | Medium | |
| 1618 | [Maximum Font to Fit a Sentence in a Screen](./problems/1618-maximum-font-to-fit-a-sentence-in-a-screen.md) | [Go](./golang/1618_maximum_font_to_fit_a_sentence_in_a_screen.go) | _O(n + logm)_ | _O(1)_ | Medium |🔒|
| 1648 | [Sell Diminishing-Valued Colored Balls](./problems/1648-sell-diminishing-valued-colored-balls.md) | [Go](./golang/1648_sell_diminishing_valued_colored_balls.go) | _O(nlogm)_ | _O(1)_ | Medium | |
| 1671 | [Minimum Number of Removals to Make Mountain Array](./problems/1671-minimum-number-of-removals-to-make-mountain-array.md) | [Go](./golang/1671_minimum_number_of_removals_to_make_mountain_array.go)  | _O(nlogn)_ | _O(n)_ | Medium         | variant of [Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/) | Binary Search, DP|
| 1713 | [Minimum Operations to Make a Subsequence](./problems/1713-minimum-operations-to-make-a-subsequence.md) | [Go](./golang/1713_minimum_operations_to_make_a_subsequence.go)  | _O(nlogn)_ | _O(n)_ | Hard         | variant of [Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/) | Binary Search, Segment Tree |
| 1760 | [Minimum Limit of Balls in a Bag](./problems/1760-minimum-limit-of-balls-in-a-bag.md) | [Go](./golang/1760_minimum_limit_of_balls_in_a_bag.go) | _O(nlogm)_ | _O(1)_ | Medium | |
| 1802 | [Maximum Value at a Given Index in a Bounded Array](./problems/1802-maximum-value-at-a-given-index-in-a-bounded-array.md) | [Go](./golang/1802_maximum_value_at_a_given_index_in_a_bounded_array.go) | _O(logm)_ | _O(1)_ | Medium | |
| 1818 | [Minimum Absolute Sum Difference](./problems/1818-minimum-absolute-sum-difference.md) | [Go](./golang/1818_minimum_absolute_sum_difference.go) | _O(nlogn)_ | _O(n)_ | Medium | |
| 1870 | [Minimum Speed to Arrive on Time](./problems/1870-minimum-speed-to-arrive-on-time.md) | [Go](./golang/1870_minimum_speed_to_arrive_on_time.go) | _O(nlogr)_ | _O(1)_ | Medium | |
| 1889 | [Minimum Space Wasted From Packaging](./problems/1889-minimum-space-wasted-from-packaging.md) | [Go](./golang/1889_minimum_space_wasted_from_packaging.go) | _O(mlogm + nlogn + mlogn)_ | _O(1)_ | Hard | |
| 1891 | [Cutting Ribbons](./problems/1891-cutting-ribbons.md) | [Go](./golang/1891_cutting_ribbons.go) | _O(nlogr)_ | _O(1)_ | Medium | 🔒 |
| 1898 | [Maximum Number of Removable Characters](./problems/1898-maximum-number-of-removable-characters.md) | [Go](./golang/1898_maximum_number_of_removable_characters.go) | _O(rlogn)_ | _O(r)_ | Medium | |
| 1901 | [Find a Peak Element II](./problems/1901-find-a-peak-element-ii.md) | [Go](./golang/1901_find_a_peak_element_ii.go) | _O(min(n, m) * log(max(n, m)))_ | _O(1)_ | Medium | |
| 1918 | [Kth Smallest Subarray Sum](./problems/1918-kth-smallest-subarray-sum.md) | [Go](./golang/1918_kth_smallest_subarray_sum.go) | _O(nlogr)_ | _O(1)_ | Medium | 🔒 |
| 1964 | [Find the Longest Valid Obstacle Course at Each Position](./problems/1964-find-the-longest-valid-obstacle-course-at-each-position.md) | [Go](./golang/1964_find_the_longest_valid_obstacle_course_at_each_position.go)  | _O(nlogn)_ | _O(n)_ | Hard         | variant of [Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/) | Binary Search, Segment Tree, DP|
| 2064 | [Minimized Maximum of Products Distributed to Any Store](./problems/2064-minimized-maximum-of-products-distributed-to-any-store.md) | [Go](./golang/2064_minimized_maximum_of_products_distributed_to_any_store.go) | _O(nlogm)_ | _O(1)_ | Medium | variant of [Minimum Limit of Balls in a Bag](https://leetcode.com/problems/minimum-limit-of-balls-in-a-bag/) |
| 2111 | [Minimum Operations to Make the Array K-Increasing](./problems/2111-minimum-operations-to-make-the-array-k-increasing.md) | [Go](./golang/2111_minimum_operations_to_make_the_array_k_increasing.go) | _O(nlog(n/k))_ | _O(n/k)_ | Hard | variant of [Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/) |
| 2137 | [Pour Water Between Buckets to Make Water Levels Equal](./problems/2137-pour-water-between-buckets-to-make-water-levels-equal.md) | [Go](./golang/2137_pour_water_between_buckets_to_make_water_levels_equal.go) | _O(nlogr)_ | _O(1)_ | Medium | 🔒 |
| 2187 | [Minimum Time to Complete Trips](./problems/2187-minimum-time-to-complete-trips.md) | [Go](./golang/2187_minimum_time_to_complete_trips.go) | _O(nlogr)_ | _O(1)_ | Medium | |
| 2226 | [Maximum Candies Allocated to K Children](./problems/2226-maximum-candies-allocated-to-k-children.md) | [Go](./golang/2226_maximum_candies_allocated_to_k_children.go) | _O(nlogr)_ | _O(1)_ | Medium | | Binary Search
| 2250 | [Count Number of Rectangles Containing Each Point](./problems/2250-count-number-of-rectangles-containing-each-point.md) | [Go](./golang/2250_count_number_of_rectangles_containing_each_point.go) | _O(nlogn + m * max_y * logn)_ | _O(n)_ | Medium | | Bucket Sort, Binary Search
| 2300 | [Successful Pairs of Spells and Potions](./problems/2300-successful-pairs-of-spells-and-potions.md) | [Go](./golang/2300_successful_pairs_of_spells_and_potions.go) | _O(mlogm + nlogm)_ | _O(1)_ | Medium | | Binary Search
| 2333 | [Minimum Sum of Squared Difference](./problems/2333-minimum-sum-of-squared-difference.md) | [Go](./golang/2333_minimum_sum_of_squared_difference.go) | _O(nlogn + nlogr)_ | _O(1)_ | Medium | | Binary Search
| 2389 | [Longest Subsequence With Limited Sum](./problems/2389-longest-subsequence-with-limited-sum.md) | [Go](./golang/2389_longest_subsequence_with_limited_sum.go) | _O(nlogn + qlogn)_ | _O(1)_ | Easy | | Greedy, Sort, Binary Search |
| 2448 | [Minimum Cost to Make Array Equal](./problems/2448-minimum-cost-to-make-array-equal.md) | [Go](./golang/2448_minimum_cost_to_make_array_equal.go) | _O(nlogn)_ | _O(n)_ | Hard | | Math, Binary Search, Prefix Sum |
| 2476 | [Closest Nodes Queries in a Binary Search Tree](./problems/2476-closest-nodes-queries-in-a-binary-search-tree.md) | [Go](./golang/2476_closest_nodes_queries_in_a_binary_search_tree.go) | _O(n + qlogn)_ | _O(n)_ | Hard | | DFS, Binary Search |
| 2513 | [Minimize the Maximum of Two Arrays](./problems/2513-minimize-the-maximum-of-two-arrays.md) | [Go](./golang/2513_minimize_the_maximum_of_two_arrays.go) | _O(log(min(d1, d2)))_ | _O(1)_ | Medium | | Number Theory, Binary Search |
| 2517 | [Maximum Tastiness of Candy Basket](./problems/2517-maximum-tastiness-of-candy-basket.md) | [Go](./golang/2517_maximum_tastiness_of_candy_basket.go) | _O(nlogr)_ | _O(1)_ | Medium | | Binary Search, Greedy |
| 2528 | [Maximize the Minimum Powered City](./problems/2528-maximize-the-minimum-powered-city.md) | [Go](./golang/2528_maximize_the_minimum_powered_city.go) | _O(nlogk)_ | _O(n)_ | Hard | | Binary Search, Sliding Window, Greedy |
| 2529 | [Maximum Count of Positive Integer and Negative Integer](./problems/2529-maximum-count-of-positive-integer-and-negative-integer.md) | [Go](./golang/2529_maximum_count_of_positive_integer_and_negative_integer.go) | _O(logn)_ | _O(1)_ | Easy | | Binary Search |
| 2554 | [Maximum Number of Integers to Choose From a Range I](./problems/2554-maximum-number-of-integers-to-choose-from-a-range-i.md) | [Go](./golang/2554_maximum_number_of_integers_to_choose_from_a_range_i.go) | _O(b)_ | _O(b)_ | Medium | | Math, Binary Search, Prefix Sum, Greedy |
| 2557 | [Maximum Number of Integers to Choose From a Range II](./problems/2557-maximum-number-of-integers-to-choose-from-a-range-ii.md) | [Go](./golang/2557_maximum_number_of_integers_to_choose_from_a_range_ii.go) | _O(b)_ | _O(b)_ | Medium | 🔒 | Math, Binary Search, Prefix Sum |
| 2560 | [House Robber IV](./problems/2560-house-robber-iv.md) | [Go](./golang/2560_house_robber_iv.go) | _O(nlogn)_ | _O(n)_ | Medium | | Binary Search, Greedy |
| 2594 | [Minimum Time to Repair Cars](./problems/2594-minimum-time-to-repair-cars.md) | [Go](./golang/2594_minimum_time_to_repair_cars.go) | _O(mx * (logc + log(mn)))_ | _O(mx)_ | Medium | | Freq Table, Binary Search, Heap, Simulation |
| 2602 | [Minimum Operations to Make All Array Elements Equal](./problems/2602-minimum-operations-to-make-all-array-elements-equal.md) | [Go](./golang/2602_minimum_operations_to_make_all_array_elements_equal.go) | _O(nlogn + qlogn)_ | _O(n)_ | Medium | | Sort, Binary Search, Prefix Sum |
| 2616 | [Minimize the Maximum Difference of Pairs](./problems/2616-minimize-the-maximum-difference-of-pairs.md) | [Go](./golang/2616_minimize_the_maximum_difference_of_pairs.go) | _O(nlogn + nlogr)_ | _O(1)_ | Medium | | Sort, Binary Search, Greedy |
| 2702 | [Minimum Operations to Make Numbers Non-positive](./problems/2702-minimum-operations-to-make-numbers-non-positive.md) | [Go](./golang/2702_minimum_operations_to_make_numbers_non_positive.go) | _O(nlogr)_ | _O(1)_ | Hard | 🔒 | Binary Search, Greedy |
| 2936 | [Number of Equal Numbers Blocks](./problems/2936-number-of-equal-numbers-blocks.md) | [Go](./golang/2936_number_of_equal_numbers_blocks.go) | _O(klogn)_ | _O(1)_ | Medium | 🔒 | Binary Search |
| 2940 | [Find Building Where Alice and Bob Can Meet](./problems/2940-find-building-where-alice-and-bob-can-meet.md) | [Go](./golang/2940_find_building_where_alice_and_bob_can_meet.go) | _O(n + qlogn)_ | _O(n)_ | Hard | | Heap,  Mono Stack, Binary Search, Online Solution, Segment Tree |

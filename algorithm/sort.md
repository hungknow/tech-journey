## Sort

### 1. Merge / Interval

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0056 | [Merge Intervals](./problems/0056-merge-intervals.md) | [Go](./golang/0056_merge_intervals.go) | _O(nlogn)_  | _O(1)_        | Hard           ||
| 0057 | [Insert Interval](./problems/0057-insert-interval.md) | [Go](./golang/0057_insert_interval.go) | _O(n)_    | _O(1)_          | Hard           ||

---

### 2. Partition / QuickSelect

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0075 | [Sort Colors](./problems/0075-sort-colors.md) | [Go](./golang/0075_sort_colors.go) | _O(n)_         | _O(1)_          | Medium         || Tri Partition
| 0280 | [Wiggle Sort](./problems/0280-wiggle-sort.md) | [Go](./golang/0280_wiggle_sort.go) | _O(n)_   | _O(1)_        | Medium         |🔒| |
| 0324 | [Wiggle Sort II](./problems/0324-wiggle-sort-ii.md) | [Go](./golang/0324_wiggle_sort_ii.go) | _O(n)_  on average | _O(1)_        | Medium         | variant of [Sort Colors](https://leetcode.com/problems/sort-colors/) | Quick Select, Tri Partition |
| 1968 | [Array With Elements Not Equal to Average of Neighbors](./problems/1968-array-with-elements-not-equal-to-average-of-neighbors.md) | [Go](./golang/1968_array_with_elements_not_equal_to_average_of_neighbors.go) | _O(n)_  on average | _O(1)_        | Medium         | variant of [Wiggle Sort II](https://leetcode.com/problems/wiggle-sort-ii/) | Quick Select, Tri Partition |

---

### 3. Top K / Frequency

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0347 | [Top K Frequent Elements](./problems/0347-top-k-frequent-elements.md) | [Go](./golang/0347_top_k_frequent_elements.go) | _O(n)_ | _O(n)_        | Medium         | | Quick Select, Heap, Bucket Sort |
| 0692 | [Top K Frequent Words](./problems/0692-top-k-frequent-words.md) | [Go](./golang/0692_top_k_frequent_words.go) | _O(n + klogk)_ on average | _O(n)_        | Medium         | | Quick Select, Heap, Bucket Sort |
| 0973 | [K Closest Points to Origin](./problems/0973-k-closest-points-to-origin.md) | [Go](./golang/0973_k_closest_points_to_origin.go) | _O(n)_ on average | _O(1)_        | Easy         | | Quick Select, Heap|
| 2512 | [Reward Top K Students](./problems/2512-reward-top-k-students.md) | [Go](./golang/2512_reward_top_k_students.go) | _O(pf * l + nf * l + n * l + klogk)_   | _O(pf * l + nf * l + n)_        | Medium         | | Partial Sort, Quick Select

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0088 | [Merge Sorted Array](./problems/0088-merge-sorted-array.md) | [Go](./golang/0088_merge_sorted_array.go) | _O(n)_ | _O(1)_       | Easy           ||
| 0147 | [Insertion Sort List](./problems/0147-insertion-sort-list.md) |[Go](./golang/0147_insertion_sort_list.go) | _O(n^2)_ | _O(1)_    | Medium         ||
| 0148 | [Sort List](./problems/0148-sort-list.md) | [Go](./golang/0148_sort_list.go)  | _O(nlogn)_      | _O(logn)_       | Medium         ||
| 0164 | [Maximum Gap](./problems/0164-maximum-gap.md) | [Go](./golang/0164_maximum_gap.go)| _O(n)_          | _O(n)_          | Hard           || Tricky 
| 0179 | [Largest Number](./problems/0179-largest-number.md) | [Go](./golang/0179_largest_number.go) | _O(nlogn)_   | _O(1)_        | Medium         ||
| 0218 | [The Skyline Problem](./problems/0218-the-skyline-problem.md) | [Go](./golang/0218_the_skyline_problem.go) | _O(nlogn)_   | _O(n)_        | Hard         || Sort, BST|
| 0252 | [Meeting Rooms](./problems/0252-meeting-rooms.md) | [Go](./golang/0252_meeting_rooms.go) | _O(nlogn)_   | _O(n)_        | Easy         |🔒| |
| 0253 | [Meeting Rooms II](./problems/0253-meeting-rooms-ii.md) | [Go](./golang/0253_meeting_rooms_ii.go) | _O(nlogn)_   | _O(n)_        | Medium         |🔒| |
| 0274 | [H-Index](./problems/0274-h-index.md) | [Go](./golang/0274_h_index.go)  | _O(n)_ | _O(n)_ | Medium         || Counting Sort |
| 0406 | [Queue Reconstruction by Height](./problems/0406-queue-reconstruction-by-height.md) | [Go](./golang/0406_queue_reconstruction_by_height.go) | _O(n * sqrt(n))_ | _O(n)_        | Medium         | | Tricky |
| 0451 | [Sort Characters By Frequency](./problems/0451-sort-characters-by-frequency.md) | [Go](./golang/0451_sort_characters_by_frequency.go) | _O(n)_ | _O(n)_        | Medium         | | |
| 0493 | [Reverse Pairs](./problems/0493-reverse-pairs.md) |  [Go](./golang/0493_reverse_pairs.go)| _O(nlogn)_       | _O(n)_          | Hard         || Sort |
| 0912 | [Sort an Array](./problems/0912-sort-an-array.md) | [Go](./golang/0912_sort_an_array.go) | _O(nlogn)_ | _O(n)_        | Medium         | | Merge Sort, Quick Sort |
| 0937 | [Reorder Log Files](./problems/0937-reorder-log-files.md) | [Go](./golang/0937_reorder_log_files.go) | _O(nlogn * l)_ | _O(l)_        | Easy         | | |
| 0969 | [Pancake Sorting](./problems/0969-pancake-sorting.md) | [Go](./golang/0969_pancake_sorting.go) | _O(nlogn)_ | _O(n)_        | Medium         | variant of [Count of Smaller Numbers After Self](https://leetcode.com/problems/count-of-smaller-numbers-after-self/) | BIT, Fenwick Tree, Merge Sort |
| 0976 | [Largest Perimeter Triangle](./problems/0976-largest-perimeter-triangle.md) | [Go](./golang/0976_largest_perimeter_triangle.go) | _O(nlogn)_ | _O(1)_        | Easy         | | |
| 1054 | [Distant Barcodes](./problems/1054-distant-barcodes.md) | [Go](./golang/1054_distant_barcodes.go) | _O(n)_ | _O(k)_ | Medium |  variant of [Rearrange String k Distance Apart](https://leetcode.com/problems/rearrange-string-k-distance-apart/) ||
| 1086 | [High Five](./problems/1086-high-five.md) | [Go](./golang/1086_high_five.go) | _O(nlogn)_ | _O(n)_ | Easy | 🔒||
| 1094 | [Car Pooling](./problems/1094-car-pooling.md) | [Go](./golang/1094_car_pooling.go) | _O(nlogn)_   | _O(n)_        | Medium         | variant of [Meeting Rooms II](https://leetcode.com/problems/meeting-rooms-ii/) | |
| 1122 | [Relative Sort Array](./problems/1122-relative-sort-array.md) | [Go](./golang/1122_relative_sort_array.go) | _O(nlogn)_   | _O(n)_        | Easy         ||
| 1229 | [Meeting Scheduler](./problems/1229-meeting-scheduler.md) | [Go](./golang/1229_meeting_scheduler.go) | _O(nlogn)_   | _O(n)_        | Medium         || Line Sweep, Heap
| 1356 | [Sort Integers by The Number of 1 Bits](./problems/1356-sort-integers-by-the-number-of-1-bits.md) | [Go](./golang/1356_sort_integers_by_the_number_of_1_bits.go) | _O(nlogn)_   | _O(1)_        | Easy         || Bit Manipulation
| 1365 | [How Many Numbers Are Smaller Than the Current Number](./problems/1365-how-many-numbers-are-smaller-than-the-current-number.md) | [Go](./golang/1365_how_many_numbers_are_smaller_than_the_current_number.go) | _O(n + m)_   | _O(m)_        | Easy         || Counting Sort
| 1366 | [Rank Teams by Votes](./problems/1366-rank-teams-by-votes.md) | [Go](./golang/1366_rank_teams_by_votes.go) | _O(m * (n + mlogm))_   | _O(m^2)_        | Medium         ||
| 1451 | [Rearrange Words in a Sentence](./problems/1451-rearrange-words-in-a-sentence.md) | [Go](./golang/1451_rearrange_words_in_a_sentence.go) | _O(nlogn)_   | _O(n)_        | Medium         || String
| 1481 | [Least Number of Unique Integers after K Removals](./problems/1481-least-number-of-unique-integers-after-k-removals.md) | [Go](./golang/1481_least_number_of_unique_integers_after_k_removals.go) | _O(n)_   | _O(n)_        | Medium         || Counting Sort
| 1509 | [Minimum Difference Between Largest and Smallest Value in Three Moves](./problems/1509-minimum-difference-between-largest-and-smallest-value-in-three-moves.md) | [Go](./golang/1509_minimum_difference_between_largest_and_smallest_value_in_three_moves.go) | _O(n + klogk)_   | _O(1)_        | Medium         || Quick Select
| 1523 | [Count Odd Numbers in an Interval Range](./problems/1523-count-odd-numbers-in-an-interval-range.md) | [Go](./golang/1523_count_odd_numbers_in_an_interval_range.go) | _O(1)_   | _O(1)_        | Easy         ||
| 1561 | [Maximum Number of Coins You Can Get](./problems/1561-maximum-number-of-coins-you-can-get.md) | [Go](./golang/1561_maximum_number_of_coins_you_can_get.go) | _O(nlogn)_   | _O(1)_        | Medium         ||
| 1588 | [Sum of All Odd Length Subarrays](./problems/1588-sum-of-all-odd-length-subarrays.md) | [Go](./golang/1588_sum_of_all_odd_length_subarrays.go) | _O(n)_   | _O(1)_        | Easy         ||
| 1608 | [Special Array With X Elements Greater Than or Equal X](./problems/1608-special-array-with-x-elements-greater-than-or-equal-x.md) | [Go](./golang/1608_special_array_with_x_elements_greater_than_or_equal_x.go) | _O(n)_   | _O(1)_        | Easy         | variant of [H-Index](https://leetcode.com/problems/h-index/) | Counting Sort, Binary Search
| 1620 | [Coordinate With Maximum Network Quality](./problems/1620-coordinate-with-maximum-network-quality.md) | [Go](./golang/1620_coordinate_with_maximum_network_quality.go) | _O(n^2)_ | _O(1)_| Medium | |
| 1621 | [Number of Sets of K Non-Overlapping Line Segments](./problems/1621-number-of-sets-of-k-non-overlapping-line-segments.md) | [Go](./golang/1621_number_of_sets_of_k_non_overlapping_line_segments.go) | _O(1)_ | _O(n)_| Medium | |  Binomial Coefficients, `Euler's Theorem`
| 1630 | [Arithmetic Subarrays](./problems/1630-arithmetic-subarrays.md) | [Go](./golang/1630_arithmetic_subarrays.go) | _O(n * q)_ | _O(n)_| Medium | | Arithmetic Series
| 1636 | [Sort Array by Increasing Frequency](./problems/1636-sort-array-by-increasing-frequency.md) | [Go](./golang/1636_sort_array_by_increasing_frequency.go) | _O(nlogn)_ | _O(n)_| Easy | |
| 1637 | [Widest Vertical Area Between Two Points Containing No Points](./problems/1637-widest-vertical-area-between-two-points-containing-no-points.md) | [Go](./golang/1637_widest_vertical_area_between_two_points_containing_no_points.go) | _O(nlogn)_ | _O(n)_| Medium | |
| 1680 | [Concatenation of Consecutive Binary Numbers](./problems/1680-concatenation-of-consecutive-binary-numbers.md) | [Go](./golang/1680_concatenation_of_consecutive_binary_numbers.go) | _O(n)_ | _O(1)_| Medium | |
| 1685 | [Sum of Absolute Differences in a Sorted Array](./problems/1685-sum-of-absolute-differences-in-a-sorted-array.md) | [Go](./golang/1685_sum_of_absolute_differences_in_a_sorted_array.go) | _O(n)_ | _O(1)_| Medium | |
| 1688 | [Count of Matches in Tournament](./problems/1688-count-of-matches-in-tournament.md) | [Go](./golang/1688_count_of_matches_in_tournament.go) | _O(1)_ | _O(1)_| Easy | |
| 1703 | [Minimum Adjacent Swaps for K Consecutive Ones](./problems/1703-minimum-adjacent-swaps-for-k-consecutive-ones.md) | [Go](./golang/1703_minimum_adjacent_swaps_for_k_consecutive_ones.go) | _O(n)_ | _O(n)_| Hard | | Math, Median, Prefix Sum
| 1716 | [Calculate Money in Leetcode Bank](./problems/1716-calculate-money-in-leetcode-bank.md) | [Go](./golang/1716_calculate_money_in_leetcode_bank.go) | _O(1)_ | _O(1)_| Easy | | Arithmetic Sequence
| 1772 | [Sort Features by Popularity](./problems/1772-sort-features-by-popularity.md) | [Go](./golang/1772_sort_features_by_popularity.go) | _O(n)_ | _O(1)_ | Medium | 🔒 ||
| 1847 | [Closest Room](./problems/1847-closest-room.md) | [Go](./golang/1847_closest_room.go) | _O(nlogn + klogk + klogn)_ | _O(n + k)_ | Hard | | Sort, Binary Search
| 1851 | [Minimum Interval to Include Each Query](./problems/1851-minimum-interval-to-include-each-query.md) | [Go](./golang/1851_minimum_interval_to_include_each_query.go) | _O(nlogn + klogk + klogn)_ | _O(n + k)_ | Hard | | Sort, Heap, Line Sweep
| 1859 | [Sorting the Sentence](./problems/1859-sorting-the-sentence.md) | [Go](./golang/1859_sorting_the_sentence.go) | _O(n)_ | _O(n)_ | Easy | | Sort, String
| 1942 | [The Number of the Smallest Unoccupied Chair](./problems/1942-the-number-of-the-smallest-unoccupied-chair.md) | [Go](./golang/1942_the_number_of_the_smallest_unoccupied_chair.go) | _O(nlogn)_   | _O(n)_        | Medium         || Line Sweep, Heap
| 1943 | [Describe the Painting](./problems/1943-describe-the-painting.md) | [Go](./golang/1943_describe_the_painting.go) | _O(nlogn)_   | _O(n)_        | Medium         || Line Sweep
| 1985 | [Find the Kth Largest Integer in the Array](./problems/1985-find-the-kth-largest-integer-in-the-array.md) | [Go](./golang/1985_find_the_kth_largest_integer_in_the_array.go) | _O(n)_ on average| _O(n)_ | Medium | | Quick Select |
| 1996 | [The Number of Weak Characters in the Game](./problems/1996-the-number-of-weak-characters-in-the-game.md) | [Go](./golang/1996_the_number_of_weak_characters_in_the_game.go) | _O(nlogn)_ | _O(1)_ | Medium | | |
| 2015 | [Average Height of Buildings in Each Segment](./problems/2015-average-height-of-buildings-in-each-segment.md) | [Go](./golang/2015_average_height_of_buildings_in_each_segment.go) | _O(nlogn)_   | _O(n)_        | Medium         | 🔒 | Line Sweep
| 2021 | [Brightest Position on Street](./problems/2021-brightest-position-on-street.md) | [Go](./golang/2021_brightest_position_on_street.go) | _O(nlogn)_   | _O(n)_        | Medium         | 🔒 | Line Sweep
| 2070 | [Most Beautiful Item for Each Query](./problems/2070-most-beautiful-item-for-each-query.md) | [Go](./golang/2070_most_beautiful_item_for_each_query.go) | _O(nlogn + qlogn)_ | _O(1)_ | Medium | | Sort, Binary Search |
| 2089 | [Find Target Indices After Sorting Array](./problems/2089-find-target-indices-after-sorting-array.md) | [Go](./golang/2089_find_target_indices_after_sorting_array.go) | _O(n)_ | _O(1)_ | Easy | | Counting Sort |
| 2158 | [Amount of New Area Painted Each Day](./problems/2158-amount-of-new-area-painted-each-day.md) | [Go](./golang/2158_amount_of_new_area_painted_each_day.go) | _O(nlogr)_   | _O(r)_        | Hard         | 🔒 | Line Sweep, Sorted List, Heap, Segment Tree
| 2164 | [Sort Even and Odd Indices Independently](./problems/2164-sort-even-and-odd-indices-independently.md) | [Go](./golang/2164_sort_even_and_odd_indices_independently.go) | _O(n)_ | _O(c)_ | Easy | | Counting Sort, Inplace |
| 2191 | [Sort the Jumbled Numbers](./problems/2191-sort-the-jumbled-numbers.md) | [Go](./golang/2191_sort_the_jumbled_numbers.go) | _O(nlogm + nlogn)_ | _O(n)_ | Medium | | Sort |
| 2231 | [Largest Number After Digit Swaps by Parity](./problems/2231-largest-number-after-digit-swaps-by-parity.md) | [Go](./golang/2231_largest_number_after_digit_swaps_by_parity.go) | _O(logn)_ | _O(1)_ | Easy | | Counting Sort |
| 2233 | [Maximum Product After K Increments](./problems/2233-maximum-product-after-k-increments.md) |[Go](./golang/2233_maximum_product_after_k_increments.go)| _O(n + k)_     | _O(n)_         | Medium         || Heap, Freq Table, Sort, Math
| 2248 | [Intersection of Multiple Arrays](./problems/2248-intersection-of-multiple-arrays.md) |[Go](./golang/2248_intersection_of_multiple_arrays.go)| _O(n * l + r)_     | _O(l)_         | Easy         || Hash Table, Counting Sort
| 2251 | [Number of Flowers in Full Bloom](./problems/2251-number-of-flowers-in-full-bloom.md) | [Go](./golang/2251_number_of_flowers_in_full_bloom.go) | _O(nlogn + mlogn)_   | _O(n)_        | Hard         | | Line Sweep, Binary Search
| 2343 | [Query Kth Smallest Trimmed Number](./problems/2343-query-kth-smallest-trimmed-number.md) | [Go](./golang/2343_query_kth_smallest_trimmed_number.go) | _O(q + n * t)_   | _O(t + n + q)_        | Medium         | | Sort, Quick Select, Radix Sort
| 2418 | [Sort the People](./problems/2418-sort-the-people.md) | [Go](./golang/2418_sort_the_people.go) | _O(nlogn)_   | _O(n)_        | Easy         | | Sort
| 2497 | [Maximum Star Sum of a Graph](./problems/2497-maximum-star-sum-of-a-graph.md) | [Go](./golang/2497_maximum_star_sum_of_a_graph.go) | _O(n)_   | _O(n)_        | Medium         | | Sort, Quick Select
| 2545 | [Sort the Students by Their Kth Score](./problems/2545-sort-the-students-by-their-kth-score.md) | [Go](./golang/2545_sort_the_students_by_their_kth_score.go) | _O(mlogm)_   | _O(1)_        | Medium         | | Sort
| 2659 | [Make Array Empty](./problems/2659-make-array-empty.md) | [Go](./golang/2659_make_array_empty.go) | _O(nlogn)_   | _O(n)_        | Hard         | | Sort, BIT, Fenwick Tree
| 2679 | [Sum in a Matrix](./problems/2679-sum-in-a-matrix.md) | [Go](./golang/2679_sum_in_a_matrix.go) | _O(m * nlogn)_   | _O(1)_        | Medium         | | Sort
| 2740 | [Find the Value of the Partition](./problems/2740-find-the-value-of-the-partition.md) | [Go](./golang/2740_find_the_value_of_the_partition.go) | _O(nlogn)_   | _O(1)_        | Medium         | | Sort
| 2785 | [Sort Vowels in a String](./problems/2785-sort-vowels-in-a-string.md) | [Go](./golang/2785_sort_vowels_in_a_string.go) | _O(n)_   | _O(1)_        | Medium         | | Counting Sort
| 2792 | [Count Nodes That Are Great Enough](./problems/2792-count-nodes-that-are-great-enough.md) | [Go](./golang/2792_count_nodes_that_are_great_enough.go) | _O(k * h)_   | _O(k + h)_        | Hard         | 🔒 | Merge Sort
| 2948 | [Make Lexicographically Smallest Array by Swapping Elements](./problems/2948-make-lexicographically-smallest-array-by-swapping-elements.md) | [Go](./golang/2948_make_lexicographically_smallest_array_by_swapping_elements.go) | _O(nlogn)_   | _O(n)_        | Medium         | | Sort
| 2974 | [Minimum Number Game](./problems/2974-minimum-number-game.md) | [Go](./golang/2974_minimum_number_game.go) | _O(nlogn)_   | _O(1)_        | Easy         | | Sort

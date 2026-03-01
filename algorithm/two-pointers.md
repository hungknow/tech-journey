## Two Pointers

### 1. 3Sum / 4Sum / NSum

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0015 | [3 Sum](./problems/0015-3sum.md) | [Go](./golang/0015_3sum.go)       | _O(n^2)_        | _O(1)_          | Medium         || Two Pointers
| 0016 | [3 Sum Closest](./problems/0016-3sum-closest.md) | [Go](./golang/0016_3sum_closest.go) | _O(n^2)_       | _O(1)_          | Medium         || Two Pointers
| 0018 | [4 Sum](./problems/0018-4sum.md) | [Go](./golang/0018_4sum.go)        | _O(n^3)_    | _O(1)_    | Medium         || Two Pointers
| 0259 | [3Sum Smaller](./problems/0259-3sum-smaller.md) | [Go](./golang/0259_3sum_smaller.go) | _O(n^2)_ | _O(1)_          | Medium         | 🔒, LintCode |

---

### 2. Sliding Window

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0209 | [Minimum Size Subarray Sum](./problems/0209-minimum-size-subarray-sum.md) | [Go](./golang/0209_minimum_size_subarray_sum.go) | _O(n)_ | _O(1)_ |  Medium | | Binary Search, Sliding Window
| 0424 | [Longest Repeating Character Replacement](./problems/0424-longest-repeating-character-replacement.md) | [Go](./golang/0424_longest_repeating_character_replacement.go) | _O(n)_| _O(1)_| Medium || Sliding Window |
| 0862 | [Shortest Subarray with Sum at Least K](./problems/0862-shortest-subarray-with-sum-at-least-k.md) | [Go](./golang/0862_shortest_subarray_with_sum_at_least_k.go) | _O(n)_        | _O(n)_          | Hard           || Mono Deque, Sliding Window |
| 0904 | [Fruit Into Baskets](./problems/0904-fruit-into-baskets.md) | [Go](./golang/0904_fruit_into_baskets.go) | _O(n)_ | _O(1)_ | Medium || Sliding Window
| 0930 | [Binary Subarrays With Sum](./problems/0930-binary-subarrays-with-sum.md) | [Go](./golang/0930_binary_subarrays_with_sum.go) | _O(n)_ | _O(1)_ | Medium || Sliding Window
| 0992 | [Subarrays with K Different Integers](./problems/0992-subarrays-with-k-different-integers.md) |[Go](./golang/0992_subarrays_with_k_different_integers.go) | _O(n)_ | _O(k)_ | Hard         || Two Pointers, Sliding Window
| 1004 | [Max Consecutive Ones III](./problems/1004-max-consecutive-ones-iii.md) | [Go](./golang/1004_max_consecutive_ones_iii.go) | _O(n)_ | _O(1)_ | Medium || Sliding Window
| 1151 | [Minimum Swaps to Group All 1's Together](./problems/1151-minimum-swaps-to-group-all-1s-together.md) | [Go](./golang/1151_minimum_swaps_to_group_all_1s_together.go) | _O(n)_ | _O(1)_ | Medium |🔒| Sliding Window
| 1156 | [Swap For Longest Repeated Character Substring](./problems/1156-swap-for-longest-repeated-character-substring.md) | [Go](./golang/1156_swap_for_longest_repeated_character_substring.go) | _O(n)_ | _O(1)_ | Medium | | Sliding Window
| 1169 | [Invalid Transactions](./problems/1169-invalid-transactions.md) | [Go](./golang/1169_invalid_transactions.go) | _O(nlogn)_ | _O(n)_      | Medium         || Sliding Window, Line Sweep
| 1176 | [Diet Plan Performance](./problems/1176-diet-plan-performance.md) | [Go](./golang/1176_diet_plan_performance.go) | _O(n)_ | _O(1)_      | Easy         || Sliding Window
| 1208 | [Get Equal Substrings Within Budget](./problems/1208-get-equal-substrings-within-budget.md) | [Go](./golang/1208_get_equal_substrings_within_budget.go) | _O(n)_ | _O(1)_      | Medium         || Sliding Window
| 1234 | [Replace the Substring for Balanced String](./problems/1234-replace-the-substring-for-balanced-string.md) | [Go](./golang/1234_replace_the_substring_for_balanced_string.go) | _O(n)_ | _O(t)_ | Medium | | Two Pointers, Sliding Window
| 1248 | [Count Number of Nice Subarrays](./problems/1248-count-number-of-nice-subarrays.md) |[Go](./golang/1248_count_number_of_nice_subarrays.go) | _O(n)_ | _O(k)_ | Medium         | variant of [Subarrays with K Different Integers](https://leetcode.com/problems/subarrays-with-k-different-integers/) | Two Pointers, Sliding Window
| 1297 | [Maximum Number of Occurrences of a Substring](./problems/1297-maximum-number-of-occurrences-of-a-substring.md) | [Go](./golang/1297_maximum_number_of_occurrences_of_a_substring.go) | _O(n)_ | _O(n)_ | Medium | | Sliding Window, `Rabin-Karp Algorithm`
| 1316 | [Distinct Echo Substrings](./problems/1316-distinct-echo-substrings.md) | [Go](./golang/1316_distinct_echo_substrings.go) | _O(n^2 + d)_ | _O(r)_      | Hard         || `KMP Algorithm`, Sliding Window, `Rabin-Karp Algorithm`
| 1358 | [Number of Substrings Containing All Three Characters](./problems/1358-number-of-substrings-containing-all-three-characters.md) | [Go](./golang/1358_number_of_substrings_containing_all_three_characters.go) | _O(n)_ | _O(1)_ | Medium | | Sliding Window
| 1423 | [Maximum Points You Can Obtain from Cards](./problems/1423-maximum-points-you-can-obtain-from-cards.md) | [Go](./golang/1423_maximum_points_you_can_obtain_from_cards.go) | _O(n)_ | _O(1)_      | Medium         || Sliding Window
| 1425 | [Constrained Subset Sum](./problems/1425-constrained-subset-sum.md) | [Go](./golang/1425_constrained_subset_sum.go) | _O(n)_        | _O(k)_          | Hard           | variant of [Sliding Window Maximum](https://leetcode.com/problems/sliding-window-maximum/) | Mono Deque, Sliding Window |
| 1456 | [Maximum Number of Vowels in a Substring of Given Length](./problems/1456-maximum-number-of-vowels-in-a-substring-of-given-length.md) | [Go](./golang/1456_maximum_number_of_vowels_in_a_substring_of_given_length.go) | _O(n)_ | _O(1)_ | Medium || Sliding Window |
| 1493 | [Longest Subarray of 1's After Deleting One Element](./problems/1493-longest-subarray-of-1s-after-deleting-one-element.md) | [Go](./golang/1493_longest_subarray_of_1s_after_deleting_one_element.go) | _O(n)_ | _O(1)_ |  Medium | | Sliding Window
| 1508 | [Range Sum of Sorted Subarray Sums](./problems/1508-range-sum-of-sorted-subarray-sums.md) |[Go](./golang/1508_range_sum_of_sorted_subarray_sums.go) | _O(nlog(sum(nums)))_ | _O(n)_ | Medium         | | Binary Search, Two Pointers, Sliding Window
| 1521 | [Find a Value of a Mysterious Function Closest to Target](./problems/1521-find-a-value-of-a-mysterious-function-closest-to-target.md) | [Go](./golang/1521_find_a_value_of_a_mysterious_function_closest_to_target.go) | _O(nlogm)_    | _O(logm)_          | Hard           || DP, Two Pointers, Sliding Window
| 1604 | [Alert Using Same Key-Card Three or More Times in a One Hour Period](./problems/1604-alert-using-same-key-card-three-or-more-times-in-a-one-hour-period.md) | [Go](./golang/1604_alert_using_same_key_card_three_or_more_times_in_a_one_hour_period.go) | _O(nlogn)_ | _O(n)_ | Medium | | Two Pointers, Sliding Window |
| 1687 | [Delivering Boxes from Storage to Ports](./problems/1687-delivering-boxes-from-storage-to-ports.md) | [Go](./golang/1687_delivering_boxes_from_storage_to_ports.go) | _O(nlogn)_ | _O(n)_ | Hard | | Two Pointers, Sliding Window |
| 1695 | [Maximum Erasure Value](./problems/1695-maximum-erasure-value.md) | [Go](./golang/1695_maximum_erasure_value.go) | _O(n)_ | _O(n)_ | Medium | | Two Pointers, Sliding Window |
| 1838 | [Frequency of the Most Frequent Element](./problems/1838-frequency-of-the-most-frequent-element.md) | [Go](./golang/1838_frequency_of_the_most_frequent_element.go) | _O(nlogn)_ | _O(n)_ | Medium | | Two Pointers, Sliding Window |
| 1852 | [Distinct Numbers in Each Subarray](./problems/1852-distinct-numbers-in-each-subarray.md) | [Go](./golang/1852_distinct_numbers_in_each_subarray.go) | _O(n)_ | _O(k)_ | Medium | 🔒 | Two Pointers, Sliding Window |
| 1888 | [Minimum Number of Flips to Make the Binary String Alternatings](./problems/1888-minimum-number-of-flips-to-make-the-binary-string-alternating.md) | [Go](./golang/1888_minimum_number_of_flips_to_make_the_binary_string_alternating.go) | _O(n)_ | _O(1)_ | Medium | | Two Pointers, Sliding Window |
| 1984 | [Minimum Difference Between Highest and Lowest of K Scores](./problems/1984-minimum-difference-between-highest-and-lowest-of-k-scores.md) | [Go](./golang/1984_minimum_difference_between_highest_and_lowest_of_k_scores.go) | _O(nlogn)_ | _O(1)_ | Easy | | Two Pointers, Sliding Window |
| 1989 | [Maximum Number of People That Can Be Caught in Tag](./problems/1989-maximum-number-of-people-that-can-be-caught-in-tag.md) | [Go](./golang/1989_maximum_number_of_people_that_can_be_caught_in_tag.go) | _O(n)_ | _O(1)_ | Medium | 🔒 | Greedy, Two Pointers, Sliding Window
| 2009 | [Minimum Number of Operations to Make Array Continuous](./problems/2009-minimum-number-of-operations-to-make-array-continuous.md) | [Go](./golang/2009_minimum_number_of_operations_to_make_array_continuous.go) | _O(nlogn)_ | _O(1)_ | Hard || Two Pointers, Sliding Window
| 2024 | [Maximize the Confusion of an Exam](./problems/2024-maximize-the-confusion-of-an-exam.md) | [Go](./golang/2024_maximize_the_confusion_of_an_exam.go) | _O(n)_| _O(1)_| Medium | variant of [Longest Repeating Character Replacement](https://leetcode.com/problems/longest-repeating-character-replacement/) | Sliding Window |
| 2062 | [Count Vowel Substrings of a String](./problems/2062-count-vowel-substrings-of-a-string.md) | [Go](./golang/2062_count_vowel_substrings_of_a_string.go) | _O(n)_ | _O(1)_ | Easy | variant of [Count Number of Nice Subarrays](https://leetcode.com/problems/count-number-of-nice-subarrays/) | Sliding Window
| 2067 | [Number of Equal Count Substrings](./problems/2067-number-of-equal-count-substrings.md) | [Go](./golang/2067_number_of_equal_count_substrings.go) | _O(n)_ | _O(1)_ | Medium | 🔒 | Sliding Window
| 2090 | [K Radius Subarray Averages](./problems/2090-k-radius-subarray-averages.md) | [Go](./golang/2090_k_radius_subarray_averages.go) | _O(n)_ | _O(1)_ | Medium || Sliding Window
| 2107 | [Number of Unique Flavors After Sharing K Candies](./problems/2107-number-of-unique-flavors-after-sharing-k-candies.md) | [Go](./golang/2107_number_of_unique_flavors_after_sharing_k_candies.go) | _O(n)_ | _O(n)_ | Medium | 🔒 | Sliding Window
| 2134 | [Minimum Swaps to Group All 1's Together II](./problems/2134-minimum-swaps-to-group-all-1s-together-ii.md) | [Go](./golang/2134_minimum_swaps_to_group_all_1s_together_ii.go) | _O(n)_ | _O(1)_ | Medium | | Sliding Window
| 2302 | [Count Subarrays With Score Less Than K](./problems/2302-count-subarrays-with-score-less-than-k.md) | [Go](./golang/2302_count_subarrays_with_score_less_than_k.go) | _O(n)_ | _O(1)_ | Hard | | Two Pointers, Sliding Window
| 2379 | [Minimum Recolors to Get K Consecutive Black Blocks](./problems/2379-minimum-recolors-to-get-k-consecutive-black-blocks.md) | [Go](./golang/2379_minimum_recolors_to_get_k_consecutive_black_blocks.go) | _O(n)_ | _O(1)_ | Easy | | Sliding Window
| 2401 | [Longest Nice Subarray](./problems/2401-longest-nice-subarray.md) | [Go](./golang/2401_longest_nice_subarray.go) | _O(n)_ | _O(1)_ | Medium | | Sliding Window, Two Pointers |
| 2516 | [Take K of Each Character From Left and Right](./problems/2516-take-k-of-each-character-from-left-and-right.md) | [Go](./golang/2516_take_k_of_each_character_from_left_and_right.go) | _O(n)_ | _O(1)_ | Medium | | Sliding Window, Two Pointers |
| 2524 | [Maximum Frequency Score of a Subarray](./problems/2524-maximum-frequency-score-of-a-subarray.md) | [Go](./golang/2524_maximum_frequency_score_of_a_subarray.go) | _O(n)_ | _O(n)_ | Hard | 🔒 | Sliding Window, Two Pointers, Freq Table, Hash Table |
| 2537 | [Count the Number of Good Subarrays](./problems/2537-count-the-number-of-good-subarrays.md) | [Go](./golang/2537_count_the_number_of_good_subarrays.go) | _O(n)_ | _O(n)_ | Medium | | Sliding Window, Two Pointers |
| 2555 | [Maximize Win From Two Segments](./problems/2555-maximize-win-from-two-segments.md) | [Go](./golang/2555_maximize_win_from_two_segments.go) | _O(n)_ | _O(n)_ | Medium | | Two Pointers, Sliding Window, DP |
| 2743 | [Count Substrings Without Repeating Character](./problems/2743-count-substrings-without-repeating-character.md) | [Go](./golang/2743_count_substrings_without_repeating_character.go) | _O(n)_ | _O(1)_ | Medium | 🔒, variant of [Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/) | Two Pointers, Sliding Window
| 2762 | [Continuous Subarrays](./problems/2762-continuous-subarrays.md) | [Go](./golang/2762_continuous_subarrays.go) | _O(n)_ | _O(1)_ | Medium | | Mono Deque, BST, Ordered Dict, Two Pointers, Sliding Window
| 2763 | [Sum of Imbalance Numbers of All Subarrays](./problems/2763-sum-of-imbalance-numbers-of-all-subarrays.md) | [Go](./golang/2763_sum_of_imbalance_numbers_of_all_subarrays.go) | _O(n)_ | _O(n)_ | Hard | | Two Pointers, Sliding Window, Hash Table, Combinatorics
| 2779 | [Maximum Beauty of an Array After Applying Operation](./problems/2779-maximum-beauty-of-an-array-after-applying-operation.md) | [Go](./golang/2779_maximum_beauty_of_an_array_after_applying_operation.go) | _O(nlogn)_ | _O(1)_ | Medium | | Sort, Two Pointers, Sliding Window
| 2781 | [Length of the Longest Valid Substring](./problems/2781-length-of-the-longest-valid-substring.md) | [Go](./golang/2781_length_of_the_longest_valid_substring.go) | _O((m + n) * l)_ | _O(t)_ | Hard | | Two Pointers, Sliding Window, Trie
| 2799 | [Count Complete Subarrays in an Array](./problems/2799-count-complete-subarrays-in-an-array.md) | [Go](./golang/2799_count_complete_subarrays_in_an_array.go) | _O(n)_ | _O(n)_ | Medium | | Freq Table, Two Pointers, Sliding Window
| 2831 | [Find the Longest Equal Subarray](./problems/2831-find-the-longest-equal-subarray.md) | [Go](./golang/2831_find_the_longest_equal_subarray.go) | _O(n)_ | _O(n)_ | Medium | | Freq Table, Two Pointers, Sliding Window
| 2841 | [Maximum Sum of Almost Unique Subarray](./problems/2841-maximum-sum-of-almost-unique-subarray.md) | [Go](./golang/2841_maximum_sum_of_almost_unique_subarray.go) | _O(n)_ | _O(n)_ | Medium | | Freq Table, Two Pointers, Sliding Window
| 2875 | [Minimum Size Subarray in Infinite Array](./problems/2875-minimum-size-subarray-in-infinite-array.md) | [Go](./golang/2875_minimum_size_subarray_in_infinite_array.go) | _O(n)_ | _O(1)_ | Medium | | Prefix Sum, Hash Table, Two Pointers, Sliding Window
| 2904 | [Shortest and Lexicographically Smallest Beautiful String](./problems/2904-shortest-and-lexicographically-smallest-beautiful-string.md) | [Go](./golang/2904_shortest_and_lexicographically_smallest_beautiful_string.go) | _O(n^2)_ | _O(1)_ | Medium | | Two Pointers, Sliding Window
| 2933 | [High-Access Employees](./problems/2933-high-access-employees.md) | [Go](./golang/2933_high_access_employees.go) | _O(nlogn)_ | _O(n)_ | Medium | | Sort, Two Pointers, Sliding Window
| 2953 | [Count Complete Substrings](./problems/2953-count-complete-substrings.md) | [Go](./golang/2953_count_complete_substrings.go) | _O(26 + d * n)_ | _O(26)_ | Medium | | Freq Table, Two Pointers, Sliding Window
| 2958 | [Length of Longest Subarray With at Most K Frequency](./problems/2958-length-of-longest-subarray-with-at-most-k-frequency.md) | [Go](./golang/2958_length_of_longest_subarray_with_at_most_k_frequency.go) | _O(n)_ | _O(n)_ | Medium | | Freq Table, Two Pointers, Sliding Window
| 2962 | [Count Subarrays Where Max Element Appears at Least K Times](./problems/2962-count-subarrays-where-max-element-appears-at-least-k-times.md) | [Go](./golang/2962_count_subarrays_where_max_element_appears_at_least_k_times.go) | _O(n)_ | _O(1)_ | Medium | | Two Pointers, Sliding Window
| 2968 | [Apply Operations to Maximize Frequency Score](./problems/2968-apply-operations-to-maximize-frequency-score.md) | [Go](./golang/2968_apply_operations_to_maximize_frequency_score.go) | _O(nlogn)_ | _O(1)_ | Hard | | Sort, Two Pointers, Sliding Window, Prefix Sum, Binary Search

---

### 3. Linked List

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0019 | [Remove Nth Node From End of List](./problems/0019-remove-nth-node-from-end-of-list.md) | [Go](./golang/0019_remove_nth_node_from_end_of_list.go) | _O(n)_       | _O(1)_         | Medium         || 
| 0141 | [Linked List Cycle](./problems/0141-linked-list-cycle.md) | [Go](./golang/0141_linked_list_cycle.go) | _O(n)_ | _O(1)_         | Easy         || 
| 0142 | [Linked List Cycle II](./problems/0142-linked-list-cycle-ii.md) | [Go](./golang/0142_linked_list_cycle_ii.go) | _O(n)_ | _O(1)_   | Medium         ||
| 0876 | [Middle of the Linked List](./problems/0876-middle-of-the-linked-list.md) | [Go](./golang/0876_middle_of_the_linked_list.go) | _O(n)_ | _O(1)_ | Easy ||
| 2046 | [Sort Linked List Already Sorted Using Absolute Values](./problems/2046-sort-linked-list-already-sorted-using-absolute-values.md) | [Go](./golang/2046_sort_linked_list_already_sorted_using_absolute_values.go) | _O(n)_ | _O(1)_         | Medium           | 🔒 | Linked List

---

### 4. Reverse / Two Arrays

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0344 | [Reverse String](./problems/0344-reverse-string.md) | [Go](./golang/0344_reverse_string.go) | _O(n)_ | _O(1)_ | Easy         | |
| 0345 | [Reverse Vowels of a String](./problems/0345-reverse-vowels-of-a-string.md) | [Go](./golang/0345_reverse_vowels_of_a_string.go) | _O(n)_ | _O(1)_ | Easy         | |
| 0349 | [Intersection of Two Arrays](./problems/0349-intersection-of-two-arrays.md) | [Go](./golang/0349_intersection_of_two_arrays.go) | _O(m + n)_ | _O(min(m, n))_ | Easy         | EPI | Hash, Binary Search
| 0350 | [Intersection of Two Arrays II](./problems/0350-intersection-of-two-arrays-ii.md) | [Go](./golang/0350_intersection_of_two_arrays_ii.go) | _O(m + n)_ | _O(1)_ | Easy         | EPI | Hash, Binary Search
| 0844 | [Backspace String Compare](./problems/0844-backspace-string-compare.md) | [Go](./golang/0844_backspace_string_compare.go) | _O(m + n)_ | _O(1)_ | Easy ||
| 1213 | [Intersection of Three Sorted Arrays](./problems/1213-intersection-of-three-sorted-arrays.md) | [Go](./golang/1213_intersection_of_three_sorted_arrays.go) | _O(n)_ | _O(1)_      | Easy         |🔒|

---

### 5. Partition & Rearrangement

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0086 | [Partition List](./problems/0086-partition-list.md) | [Go](./golang/0086_partition_list.go) | _O(n)_       | _O(1)_         | Medium         ||
| 0143 | [Reorder List](./problems/0143-reorder-list.md) | [Go](./golang/0143_reorder_list.go) | _O(n)_          |  _O(1)_         | Medium         ||
| 0283 | [Move Zeroes](./problems/0283-move-zeroes.md) | [Go](./golang/0283_move_zeroes.go) | _O(n)_ | _O(1)_          | Easy         | |
| 0360 | [Sort Transformed Array](./problems/0360-sort-transformed-array.md) | [Go](./golang/0360_sort_transformed_array.go) | _O(n)_ | _O(1)_ | Medium         |🔒|
| 0457 | [Circular Array Loop](./problems/0457-circular-array-loop.md) | [Go](./golang/0457_circular_array_loop.go) | _O(n)_ | _O(1)_ | Medium         ||
| 0777 | [Swap Adjacent in LR String](./problems/0777-swap-adjacent-in-lr-string.md) | [Go](./golang/0777_swap_adjacent_in_lr_string.go) | _O(n)_ | _O(1)_ | Medium         ||
| 2149 | [Rearrange Array Elements by Sign](./problems/2149-rearrange-array-elements-by-sign.md) | [Go](./golang/2149_rearrange_array_elements_by_sign.go) | _O(n)_ | _O(1)_ | Medium | | Two Pointers
| 2161 | [Partition Array According to Given Pivot](./problems/2161-partition-array-according-to-given-pivot.md) | [Go](./golang/2161_partition_array_according_to_given_pivot.go) | _O(n)_ | _O(n)_ | Medium | | Two Pointers
| 2938 | [Separate Black and White Balls](./problems/2938-separate-black-and-white-balls.md) | [Go](./golang/2938_separate_black_and_white_balls.go) | _O(n)_ | _O(1)_ | Medium | | Two Pointers

---

### 6. String Manipulation

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0567 | [Permutation in String](./problems/0567-permutation-in-string.md) | [Go](./golang/0567_permutation_in_string.go) | _O(n)_ | _O(1)_ | Medium         ||
| 1750 | [Minimum Length of String After Deleting Similar Ends](./problems/1750-minimum-length-of-string-after-deleting-similar-ends.md) | [Go](./golang/1750_minimum_length_of_string_after_deleting_similar_ends.go) | _O(n)_ | _O(1)_ | Medium | | Two Pointers |
| 2330 | [Valid Palindrome IV](./problems/2330-valid-palindrome-iv.md) | [Go](./golang/2330_valid_palindrome_iv.go) | _O(n)_ | _O(1)_ | Medium | 🔒 | String, Two Pointers |
| 2337 | [Move Pieces to Obtain a String](./problems/2337-move-pieces-to-obtain-a-string.md) | [Go](./golang/2337_move_pieces_to_obtain_a_string.go) | _O(n + m)_ | _O(1)_ | Medium | | String, Two Pointers |
| 2609 | [Find the Longest Balanced Substring of a Binary String](./problems/2609-find-the-longest-balanced-substring-of-a-binary-string.md) | [Go](./golang/2609_find_the_longest_balanced_substring_of_a_binary_string.go) | _O(n)_ | _O(1)_ | Easy | | String, Two Pointers
| 2730 | [Find the Longest Semi-Repetitive Substring](./problems/2730-find-the-longest-semi-repetitive-substring.md) | [Go](./golang/2730_find_the_longest_semi_repetitive_substring.go) | _O(n)_ | _O(1)_ | Medium | | Two Pointers

---

### 7. Array/Array Operations

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0167 | [Two Sum II - Input array is sorted](./problems/0167-two-sum-ii-input-array-is-sorted.md) | [Go](./golang/0167_two_sum_ii_input_array_is_sorted.go) | _O(n)_   | _O(1)_         | Medium         | |
| 0977 | [Squares of a Sorted Array](./problems/0977-squares-of-a-sorted-array.md) | [Go](./golang/0977_squares_of_a_sorted_array.go) | _O(n)_ | _O(1)_ | Easy ||
| 1214 | [Two Sum BSTs](./problems/1214-two-sum-bsts.md) | [Go](./golang/1214_two_sum_bsts.go) | _O(n)_ | _O(n)_      | Medium         |🔒| Stack |
| 1305 | [All Elements in Two Binary Search Trees](./problems/1305-all-elements-in-two-binary-search-trees.md) | [Go](./golang/1305_all_elements_in_two_binary_search_trees.go) | _O(n)_ | _O(h)_ | Medium || Stack |
| 1658 | [Minimum Operations to Reduce X to Zero](./problems/1658-minimum-operations-to-reduce-x-to-zero.md) | [Go](./golang/1658_minimum_operations_to_reduce_x_to_zero.go) | _O(n)_ | _O(1)_ |  Medium | | Two Pointers |
| 1855 | [Maximum Distance Between a Pair of Values](./problems/1855-maximum-distance-between-a-pair-of-values.md) | [Go](./golang/1855_maximum_distance_between_a_pair_of_values.go) | _O(n + m)_ | _O(1)_ | Medium | | Two Pointers |
| 1868 | [Product of Two Run-Length Encoded Arrays](./problems/1868-product-of-two-run-length-encoded-arrays.md) | [Go](./golang/1868_product_of_two_run_length_encoded_arrays.go) | _O(m + n)_ | _O(1)_ | Medium | 🔒 | Two Pointers |
| 1885 | [Count Pairs in Two Arrays](./problems/1885-count-pairs-in-two-arrays.md) | [Go](./golang/1885_count_pairs_in_two_arrays.go) | _O(nlogn)_ | _O(1)_ | Medium | 🔒 | Two Pointers |
| 2040 | [Kth Smallest Product of Two Sorted Arrays](./problems/2040-kth-smallest-product-of-two-sorted-arrays.md) | [Go](./golang/2040_kth_smallest_product_of_two_sorted_arrays.go) | _O((m + n) * logr)_| _O(1)_| Hard | | Binary Search, Two Pointers |
| 2105 | [Watering Plants II](./problems/2105-watering-plants-ii.md) | [Go](./golang/2105_watering_plants_ii.go) | _O(n)_ | _O(1)_ | Medium || Simulation
| 2200 | [Find All K-Distant Indices in an Array](./problems/2200-find-all-k-distant-indices-in-an-array.md) | [Go](./golang/2200_find_all_k_distant_indices_in_an_array.go) | _O(n)_ | _O(1)_ | Easy | | Two Pointers
| 2332 | [The Latest Time to Catch a Bus](./problems/2332-the-latest-time-to-catch-a-bus.md) | [Go](./golang/2332_the_latest_time_to_catch_a_bus.go) | _O(nlogn + mlogm)_ | _O(1)_ | Medium | | String, Two Pointers |
| 2465 | [Number of Distinct Averages](./problems/2465-number-of-distinct-averages.md) | [Go](./golang/2465_number_of_distinct_averages.go) | _O(nlogn)_ | _O(n)_ | Easy | | Two Pointers, Hash Table |
| 2511 | [Maximum Enemy Forts That Can Be Captured](./problems/2511-maximum-enemy-forts-that-can-be-captured.md) | [Go](./golang/2511_maximum_enemy_forts_that_can_be_captured.go) | _O(n)_ | _O(1)_ | Easy | | Array, Two Pointers |
| 2540 | [Minimum Common Value](./problems/2540-minimum-common-value.md) | [Go](./golang/2540_minimum_common_value.go) | _O(n)_ | _O(1)_ | Easy | | Two Pointers |
| 2563 | [Count the Number of Fair Pairs](./problems/2563-count-the-number-of-fair-pairs.md) | [Go](./golang/2563_count_the_number_of_fair_pairs.go) | _O(nlogn)_ | _O(1)_ | Medium | | Sort, Two Pointers
| 2570 | [Merge Two 2D Arrays by Summing Values](./problems/2570-merge-two-2d-arrays-by-summing-values.md) | [Go](./golang/2570_merge_two_2d_arrays_by_summing_values.go) | _O(n)_ | _O(1)_ | Easy | | Two Pointers
| 2653 | [Sliding Subarray Beauty](./problems/2653-sliding-subarray-beauty.md) | [Go](./golang/2653_sliding_subarray_beauty.go) | _O(nlogk)_ | _O(k)_ | Medium | | Sorted List, Ordered Set, Two Pointers
| 2747 | [Count Zero Request Servers](./problems/2747-count-zero-request-servers.md) | [Go](./golang/2747_count_zero_request_servers.go) | _O(nlogn + mlogm)_ | _O(n + m)_ | Hard | | Sort, Two Pointers, Line Sweep
| 2824 | [Count Pairs Whose Sum is Less than Target](./problems/2824-count-pairs-whose-sum-is-less-than-target.md) | [Go](./golang/2824_count_pairs_whose_sum_is_less_than_target.go) | _O(nlogn)_ | _O(1)_ | Easy | | Sort, Two Pointers
| 2838 | [Maximum Coins Heroes Can Collect](./problems/2838-maximum-coins-heroes-can-collect.md) | [Go](./golang/2838_maximum_coins_heroes_can_collect.go) | _O(nlogn + mlogm)_ | _O(n + m)_ | Medium | 🔒 | Sort, Two Pointers

---

### 8. Subarray Counting

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0828 | [Count Unique Characters of All Substrings of a Given String](./problems/0828-count-unique-characters-of-all-substrings-of-a-given-string.md) | [Go](./golang/0828_count_unique_characters_of_all_substrings_of_a_given_string.go) | _O(n)_ | _O(1)_ | Hard         ||
| 1712 | [Ways to Split Array Into Three Subarrays](./problems/1712-ways-to-split-array-into-three-subarrays.md) | [Go](./golang/1712_ways_to_split_array_into_three_subarrays.go) | _O(n)_ | _O(n)_ | Medium | | Two Pointers, Prefix Sum |
| 2348 | [Number of Zero-Filled Subarrays](./problems/2348-number-of-zero-filled-subarrays.md) | [Go](./golang/2348_number_of_zero_filled_subarrays.go) | _O(n)_ | _O(1)_ | Medium | | Two Pointers, Combinatorics |
| 2393 | [Count Strictly Increasing Subarrays](./problems/2393-count-strictly-increasing-subarrays.md) | [Go](./golang/2393_count_strictly_increasing_subarrays.go) | _O(n)_ | _O(1)_ | Medium | 🔒 | Two Pointers |
| 2444 | [Count Subarrays With Fixed Bounds](./problems/2444-count-subarrays-with-fixed-bounds.md) | [Go](./golang/2444_count_subarrays_with_fixed_bounds.go) | _O(n)_ | _O(1)_ | Hard | variant of [Number of Substrings Containing All Three Characters](https://leetcode.com/problems/number-of-substrings-containing-all-three-characters/) | Two Pointers |
| 2461 | [Maximum Sum of Distinct Subarrays With Length K](./problems/2461-maximum-sum-of-distinct-subarrays-with-length-k.md) | [Go](./golang/2461_maximum_sum_of_distinct_subarrays_with_length_k.go) | _O(n)_ | _O(k)_ | Medium | | Two Pointers |
| 2970 | [Count the Number of Incremovable Subarrays I](./problems/2970-count-the-number-of-incremovable-subarrays-i.md) | [Go](./golang/2970_count_the_number_of_incremovable_subarrays_i.go) | _O(n)_ | _O(1)_ | Easy | | Two Pointers, Brute Force
| 2972 | [Count the Number of Incremovable Subarrays II](./problems/2972-count-the-number-of-incremovable-subarrays-ii.md) | [Go](./golang/2972_count_the_number_of_incremovable_subarrays_ii.go) | _O(n)_ | _O(1)_ | Hard | | Two Pointers

---

### 9. Math & Geometry

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0287 | [Find the Duplicate Number](./problems/0287-find-the-duplicate-number.md) | [Go](./golang/0287_find_the_duplicate_number.go)   | _O(n)_          | _O(1)_          | Hard       | | Binary Search, Two Pointers |
| 0611 | [Valid Triangle Number](./problems/0611-valid-triangle-number.md) | [Go](./golang/0611_valid_triangle_number.go) | _O(n^2)_ | _O(1)_ | Medium         ||
| 0826 | [Most Profit Assigning Work](./problems/0826-most-profit-assigning-work.md) | [Go](./golang/0826_most_profit_assigning_work.go) | _O(mlogm + nlogn)_ | _O(n)_ | Medium         ||
| 1033 | [Moving Stones Until Consecutive](./problems/1033-moving-stones-until-consecutive.md) | [Go](./golang/1033_moving_stones_until_consecutive.go) | _O(1)_ | _O(1)_      | Easy         ||
| 1040 | [Moving Stones Until Consecutive II](./problems/1040-moving-stones-until-consecutive-ii.md) | [Go](./golang/1040_moving_stones_until_consecutive_ii.go) | _O(nlogn)_ | _O(1)_      | Medium         ||
| 2234 | [Maximum Total Beauty of the Gardens](./problems/2234-maximum-total-beauty-of-the-gardens.md) | [Go](./golang/2234_maximum_total_beauty_of_the_gardens.go) | _O(nlogn)_ | _O(1)_ | Hard | | Sort, Prefix Sum, Greedy, Binary Search, Two Pointers

## Binary Heap

### 1. K-th / Median

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0295 | [Find Median from Data Stream](./problems/0295-find-median-from-data-stream.md) | [Go](./golang/0295_find_median_from_data_stream.go)  | _O(nlogn)_ | _O(n)_ | Hard         | EPI, LintCode | BST, Heap |
| 0373 | [Find K Pairs with Smallest Sums](./problems/0373-find-k-pairs-with-smallest-sums.md) | [Go](./golang/0373_find_k_pairs_with_smallest_sums.go) | _O(k * log(min(n, m, k)))_ | _O(min(n, m, k))_ | Medium |||
| 0378 | [Kth Smallest Element in a Sorted Matrix](./problems/0378-kth-smallest-element-in-a-sorted-matrix.md) | [Go](./golang/0378_kth_smallest_element_in_a_sorted_matrix.go) | _O(k * log(min(n, m, k)))_ | _O(min(n, m, k))_ | Medium | LintCode ||
| 0480 | [Sliding Window Median](./problems/0480-sliding-window-median.md) | [Go](./golang/0480_sliding_window_median.go) | _O(nlogk)_       | _O(k)_          | Hard         || BST, Heap |
| 0632 | [Smallest Range](./problems/0632-smallest-range.md) | [Go](./golang/0632_smallest_range.go) | _O(nlogk)_ | _O(k)_ | Hard |||
| 0703 | [Kth Largest Element in a Stream](./problems/0703-kth-largest-element-in-a-stream.md) | [Go](./golang/0703_kth_largest_element_in_a_stream.go) | _O(nlogk)_ | _O(k)_ | Easy |||
| 1439 | [Find the Kth Smallest Sum of a Matrix With Sorted Rows](./problems/1439-find-the-kth-smallest-sum-of-a-matrix-with-sorted-rows.md) | [Go](./golang/1439_find_the_kth_smallest_sum_of_a_matrix_with_sorted_rows.go) | _O(m * klogk)_ | _O(k)_ | Hard || Binary Search |

---

### 3. Scheduling / Greedy

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0358 | [Rearrange String k Distance Apart](./problems/0358-rearrange-string-k-distance-apart.md) | [Go](./golang/0358_rearrange_string_k_distance_apart.go) | _O(n)_        | _O(c)_          | Hard           |🔒| Greedy, Heap |
| 0502 | [IPO](./problems/0502-ipo.md) | [Go](./golang/0502_ipo.go) | _O(nlogn)_       | _O(n)_          | Hard         || Heap |
| 0871 | [Minimum Number of Refueling Stops](./problems/0871-minimum-number-of-refueling-stops.md) | [Go](./golang/0871_minimum_number_of_refueling_stops.go) | _O(nlogn)_ | _O(n)_ | Hard || Sort |

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0264 | [Ugly Number II](./problems/0264-ugly-number-ii.md) | [Go](./golang/0264_ugly_number_ii.go)  | _O(n)_ | _O(1)_ | Medium         | CTCI, LintCode | BST, Heap |
| 0313 | [Super Ugly Number](./problems/0313-super-ugly-number.md) | [Go](./golang/0313_super_ugly_number.go)  | _O(n * k)_ | _O(n + k)_ | Medium         || BST, Heap |
| 0407 | [Trapping Rain Water II](./problems/0407-trapping-rain-water-ii.md) | [Go](./golang/0407_trapping_rain_water_ii.go) | _O(m * n * (logm + logn))_ | _O(m * n)_ | Hard | LintCode ||
| 0846 | [Hand of Straights](./problems/0846-hand-of-straights.md) | [Go](./golang/0846_hand_of_straights.go) | _O(nlogn)_ | _O(n)_ | Medium |||
| 0855 | [Exam Room](./problems/0855-exam-room.md) | [Go](./golang/0855_exam_room.go) | seat: _O(logn)_ <br> leave: _O(logn)_ | _O(n)_ | Medium || BST, Hash |
| 0857 | [Minimum Cost to Hire K Workers](./problems/0857-minimum-cost-to-hire-k-workers.md) | [Go](./golang/0857_minimum_cost_to_hire_k_workers.go) | _O(nlogn)_ | _O(n)_ | Hard || Sort |
| 1046 | [Last Stone Weight](./problems/1046-last-stone-weight.md) | [Go](./golang/1046_last_stone_weight.go) | _O(nlogn)_ | _O(n)_ | Easy |||
| 1057 | [Campus Bikes](./problems/1057-campus-bikes.md) | [Go](./golang/1057_campus_bikes.go) |  _O((w * b) * log(w * b))_ | _O(w * b)_   | Medium |🔒||
| 1606 | [Find Servers That Handled Most Number of Requests](./problems/1606-find-servers-that-handled-most-number-of-requests.md) | [Go](./golang/1606_find_servers_that_handled_most_number_of_requests.go) | _O(nlogk)_ | _O(k)_ | Hard | | Sorted List |
| 1642 | [Furthest Building You Can Reach](./problems/1642-furthest-building-you-can-reach.md) | [Go](./golang/1642_furthest_building_you_can_reach.go) | _O(nlogk)_ | _O(k)_ | Medium | | |
| 1675 | [Minimize Deviation in Array](./problems/1675-minimize-deviation-in-array.md) | [Go](./golang/1675_minimize_deviation_in_array.go) | _O((n * log(max_num)) * logn)_ | _O(n)_ | Hard | | |
| 1792 | [Maximum Average Pass Ratio](./problems/1792-maximum-average-pass-ratio.md) | [Go](./golang/1792_maximum_average_pass_ratio.go) | _O(n + mlogn)_ | _O(n)_ | Medium | | |
| 1882 | [Process Tasks Using Servers](./problems/1882-process-tasks-using-servers.md) | [Go](./golang/1882_process_tasks_using_servers.go) | _O(n + mlogn)_ | _O(n)_ | Medium | | |
| 1962 | [Remove Stones to Minimize the Total](./problems/1962-remove-stones-to-minimize-the-total.md) | [Go](./golang/1962_remove_stones_to_minimize_the_total.go) | _O(n + klogn)_ | _O(1)_ | Medium | | |
| 2054 | [Two Best Non-Overlapping Events](./problems/2054-two-best-non-overlapping-events.md) | [Go](./golang/2054_two_best_non_overlapping_events.go) | _O(nlogn)_ | _O(n)_ | Medium | | Line Sweep, Heap |
| 2163 | [Minimum Difference in Sums After Removal of Elements](./problems/2163-minimum-difference-in-sums-after-removal-of-elements.md) | [Go](./golang/2163_minimum_difference_in_sums_after_removal_of_elements.go) | _O(nlogn)_ | _O(n)_ | Hard | | Heap, Prefix Sum |
| 2208 | [Minimum Operations to Halve Array Sum](./problems/2208-minimum-operations-to-halve-array-sum.md) | [Go](./golang/2208_minimum_operations_to_halve_array_sum.go) | _O(nlogn)_ | _O(n)_ | Medium | | Heap |
| 2386 | [Find the K-Sum of an Array](./problems/2386-find-the-k-sum-of-an-array.md) | [Go](./golang/2386_find_the_k_sum_of_an_array.go) | _O(nlogn + klogk)_ | _O(n + k)_ | Hard | | BFS, Heap |
| 2402 | [Meeting Rooms III](./problems/2402-meeting-rooms-iii.md) | [Go](./golang/2402_meeting_rooms_iii.go) | _O(mlogm + n + mlogn)_ | _O(n)_ | Hard | | Heap |
| 2462 | [Total Cost to Hire K Workers](./problems/2462-total-cost-to-hire-k-workers.md) | [Go](./golang/2462_total_cost_to_hire_k_workers.go) | _O(c + klogc)_ | _O(c)_ | Medium | | Heap, Two Pointers |
| 2519 | [Count the Number of K-Big Indices](./problems/2519-count-the-number-of-k-big-indices.md) | [Go](./golang/2519_count_the_number_of_k_big_indices.go) | _O(nlogk)_ | _O(n)_ | Hard | 🔒 | Heap, Ordered Set, Sorted List |
| 2530 | [Maximal Score After Applying K Operations](./problems/2530-maximal-score-after-applying-k-operations.md) | [Go](./golang/2530_maximal_score_after_applying_k_operations.go) | _O(n + klogn)_ | _O(1)_ | Medium | | Heap, Simulation |
| 2558 | [Take Gifts From the Richest Pile](./problems/2558-take-gifts-from-the-richest-pile.md) | [Go](./golang/2558_take_gifts_from_the_richest_pile.go) | _O(n + klogn)_ | _O(1)_ | Easy | | Heap, Simulation |
| 2818 | [Apply Operations to Maximize Score](./problems/2818-apply-operations-to-maximize-score.md) | [Go](./golang/2818_apply_operations_to_maximize_score.go) | _O(sqrt(r) + n * (logr + sqrt(r)/log(sqrt(r))) + klogn)_ | _O(sqrt(r) + n)_ | Hard | | Number Theory, `Linear Sieve of Eratosthenes`, Mono Stack, Greedy, Sort, Heap |

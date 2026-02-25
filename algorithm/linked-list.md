## Linked List

### 1. Merge & Sort

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0021 | [Merge Two Sorted Lists](./problems/0021-merge-two-sorted-lists.md) | [Go](./golang/0021_merge_two_sorted_lists.go) | _O(n)_ | _O(1)_ | Easy         ||
| 0023 | [Merge k Sorted Lists](./problems/0023-merge-k-sorted-lists.md) | [Go](./golang/0023_merge_k_sorted_lists.go) | _O(nlogk)_| _O(1)_| Hard          | | Heap, Divide and Conquer
| 0082 | [Remove Duplicates from Sorted List II](./problems/0082-remove-duplicates-from-sorted-list-ii.md) | [Go](./golang/0082_remove_duplicates_from_sorted_list_ii.go) | _O(n)_       | _O(1)_         | Medium         ||
| 0083 | [Remove Duplicates from Sorted List](./problems/0083-remove-duplicates-from-sorted-list.md) | [Go](./golang/0083_remove_duplicates_from_sorted_list.go) | _O(n)_       | _O(1)_         | Easy           ||
| 0708 | [Insert into a Sorted Circular Linked List](./problems/0708-insert-into-a-sorted-circular-linked-list.md) | [Go](./golang/0708_insert_into_a_sorted_circular_linked_list.go) | _O(n)_       | _O(1)_          | Medium         |🔒| Linked List |
| 1669 | [Merge In Between Linked Lists](./problems/1669-merge-in-between-linked-lists.md) | [Go](./golang/1669_merge_in_between_linked_lists.go) | _O(m + n)_ | _O(1)_         | Medium           ||
| 1836 | [Remove Duplicates From an Unsorted Linked List](./problems/1836-remove-duplicates-from-an-unsorted-linked-list.md) | [Go](./golang/1836_remove_duplicates_from_an_unsorted_linked_list.go) | _O(n)_ | _O(n)_         | Medium           | 🔒 |
| 2181 | [Merge Nodes in Between Zeros](./problems/2181-merge-nodes-in-between-zeros.md) | [Go](./golang/2181_merge_nodes_in_between_zeros.go) | _O(n)_  | _O(1)_         | Medium           | | Two Pointers

---

### 2. Reverse & Reorder

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0025 | [Reverse Nodes in k-Group](./problems/0025-reverse-nodes-in-k-group.md) | [Go](./golang/0025_reverse_nodes_in_k_group.go) | _O(n)_       | _O(1)_         | Hard         ||
| 0092 | [Reverse Linked List II](./problems/0092-reverse-linked-list-ii.md) | [Go](./golang/0092_reverse_linked_list_ii.go) | _O(n)_       | _O(1)_         | Medium         || 
| 0206 | [Reverse Linked List](./problems/0206-reverse-linked-list.md) | [Go](./golang/0206_reverse_linked_list.go) | _O(n)_       | _O(1)_         | Easy         || 
| 1265 | [Print Immutable Linked List in Reverse](./problems/1265-print-immutable-linked-list-in-reverse.md) | [Go](./golang/1265_print_immutable_linked_list_in_reverse.go) | _O(n)_       | _O(sqrt(n))_         | Medium         | 🔒 ||
| 2074 | [Reverse Nodes in Even Length Groups](./problems/2074-reverse-nodes-in-even-length-groups.md) | [Go](./golang/2074_reverse_nodes_in_even_length_groups.go) | _O(n)_  | _O(1)_         | Medium           | |

---

### 3. Two Pointers / Cycle

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0160 | [Intersection of Two Linked Lists](./problems/0160-intersection-of-two-linked-lists.md) | [Go](./golang/0160_intersection_of_two_linked_lists.go) | _O(m + n)_ | _O(1)_         | Easy           ||
| 0986 | [Interval List Intersections](./problems/0986-interval-list-intersections.md) | [Go](./golang/0986_interval_list_intersections.go) | _O(m + n)_ | _O(1)_ | Medium ||
| 1650 | [Lowest Common Ancestor of a Binary Tree III](./problems/1650-lowest-common-ancestor-of-a-binary-tree-iii.md) | [Go](./golang/1650_lowest_common_ancestor_of_a_binary_tree_iii.go) | _O(h)_ | _O(1)_         | Medium           |🔒, variant of [Intersection of Two Linked Lists](https://leetcode.com/problems/intersection-of-two-linked-lists/) |
| 2095 | [Delete the Middle Node of a Linked List](./problems/2095-delete-the-middle-node-of-a-linked-list.md) | [Go](./golang/2095_delete_the_middle_node_of_a_linked_list.go) | _O(n)_  | _O(1)_         | Medium           | | Two Pointers

---

### 4. Add / Remove

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0002 | [Add Two Numbers](./problems/0002-add-two-numbers.md) | [Go](./golang/0002_add_two_numbers.go) | _O(n)_   | _O(1)_          | Medium         ||
| 0203 | [Remove Linked List Elements](./problems/0203-remove-linked-list-elements.md) | [Go](./golang/0203_remove_linked_list_elements.go) | _O(n)_       | _O(1)_         | Easy         || 
| 0237 | [Delete Node in a Linked List](./problems/0237-delete-node-in-a-linked-list.md) | [Go](./golang/0237_delete_node_in_a_linked_list.go) | _O(1)_       | _O(1)_         | Easy         | LintCode |
| 0445 | [Add Two Numbers II](./problems/0445-add-two-numbers-ii.md) | [Go](./golang/0445_add_two_numbers_ii.go) | _O(m + n)_       | _O(m + n)_         | Medium         |||
| 1171 | [Remove Zero Sum Consecutive Nodes from Linked List](./problems/1171-remove-zero-sum-consecutive-nodes-from-linked-list.md) | [Go](./golang/1171_remove_zero_sum_consecutive_nodes_from_linked_list.go) | _O(n)_ | _O(n)_ | Medium || OrderedDict, Hash
| 1474 | [Delete N Nodes After M Nodes of a Linked List](./problems/1474-delete-n-nodes-after-m-nodes-of-a-linked-list.md) | [Go](./golang/1474_delete_n_nodes_after_m_nodes_of_a_linked_list.go) | _O(n)_       | _O(1)_         | Easy         | 🔒 ||
| 1634 | [Add Two Polynomials Represented as Linked Lists](./problems/1634-add-two-polynomials-represented-as-linked-lists.md) | [Go](./golang/1634_add_two_polynomials_represented_as_linked_lists.go) | _O(m + n)_       | _O(1)_         | Medium         | 🔒 ||
| 2487 | [Remove Nodes From Linked List](./problems/2487-remove-nodes-from-linked-list.md) | [Go](./golang/2487_remove_nodes_from_linked_list.go) | _O(n)_  | _O(n)_         | Medium           | | Mono Stack

---

### 5. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0024 | [Swap Nodes in Pairs](./problems/0024-swap-nodes-in-pairs.md) | [Go](./golang/0024_swap_nodes_in_pairs.go)   | _O(n)_          | _O(1)_          | Easy         ||
| 0061 | [Rotate List](./problems/0061-rotate-list.md) | [Go](./golang/0061_rotate_list.go)   | _O(n)_          | _O(1)_          | Medium         ||  
| 0138 | [Copy List with Random Pointer](./problems/0138-copy-list-with-random-pointer.md) | [Go](./golang/0138_copy_list_with_random_pointer.go) | _O(n)_   | _O(1)_          | Medium         ||
| 0234 | [Palindrome Linked List](./problems/0234-palindrome-linked-list.md) | [Go](./golang/0234_palindrome_linked_list.go) | _O(n)_       | _O(1)_         | Easy         ||
| 0328 | [Odd Even Linked List](./problems/0328-odd-even-linked-list.md) | [Go](./golang/0328_odd_even_linked_list.go) | _O(n)_       | _O(1)_         | Medium         | |
| 0369 | [Plus One Linked List](./problems/0369-plus-one-linked-list.md) | [Go](./golang/0369_plus_one_linked_list.go) | _O(n)_       | _O(1)_         | Medium         | 🔒 | Two Pointers |
| 0725 | [Split Linked List in Parts](./problems/0725-split-linked-list-in-parts.md) | [Go](./golang/0725_split_linked_list_in_parts.go) | _O(n + k)_ | _O(1)_ | Medium ||
| 0817 | [Linked List Components](./problems/0817-linked-list-components.md) | [Go](./golang/0817_linked_list_components.go) | _O(m + n)_ | _O(m)_ | Medium ||
| 1180 | [Count Substrings with Only One Distinct Letter](./problems/1180-count-substrings-with-only-one-distinct-letter.md) | [Go](./golang/1180_count_substrings_with_only_one_distinct_letter.go) | _O(n)_       | _O(1)_         | Easy         | 🔒 ||
| 1181 | [Before and After Puzzle](./problems/1181-before-and-after-puzzle.md) | [Go](./golang/1181_before_and_after_puzzle.go) | _O(l * rlogr)_       | _O(l * (n + r))_         | Medium         | 🔒 | Hash |
| 1290 | [Convert Binary Number in a Linked List to Integer](./problems/1290-convert-binary-number-in-a-linked-list-to-integer.md) | [Go](./golang/1290_convert_binary_number_in_a_linked_list_to_integer.go) | _O(n)_       | _O(1)_         | Easy         |||
| 1721 | [Swapping Nodes in a Linked List](./problems/1721-swapping-nodes-in-a-linked-list.md) | [Go](./golang/1721_swapping_nodes_in_a_linked_list.go) | _O(n)_ | _O(1)_         | Medium           ||
| 2058 | [Find the Minimum and Maximum Number of Nodes Between Critical Points](./problems/2058-find-the-minimum-and-maximum-number-of-nodes-between-critical-points.md) | [Go](./golang/2058_find_the_minimum_and_maximum_number_of_nodes_between_critical_points.go) | _O(n)_ | _O(1)_         | Medium           ||
| 2130 | [Maximum Twin Sum of a Linked List](./problems/2130-maximum-twin-sum-of-a-linked-list.md) | [Go](./golang/2130_maximum_twin_sum_of_a_linked_list.go) | _O(n)_  | _O(1)_         | Medium           | | Two Pointers
| 2674 | [Split a Circular Linked List](./problems/2674-split-a-circular-linked-list.md) | [Go](./golang/2674_split_a_circular_linked_list.go) | _O(n)_  | _O(1)_         | Medium           |🔒| Two Pointers, Slow and Fast Pointers
| 2807 | [Insert Greatest Common Divisors in Linked List](./problems/2807-insert-greatest-common-divisors-in-linked-list.md) | [Go](./golang/2807_insert_greatest_common_divisors_in_linked_list.go) | _O(n)_ | _O(1)_ | Medium | | Linked List
| 2816 | [Double a Number Represented as a Linked List](./problems/2816-double-a-number-represented-as-a-linked-list.md) | [Go](./golang/2816_double_a_number_represented_as_a_linked_list.go) | _O(n)_ | _O(1)_ | Medium | | Linked List

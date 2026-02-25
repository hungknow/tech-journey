## Binary Search Tree

### 1. Kth / Order

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0230 | [Kth Smallest Element in a BST](./problems/0230-kth-smallest-element-in-a-bst.md) | [Go](./golang/0230_kth_smallest_element_in_a_bst.go) | _O(max(h, k))_ | _O(min(h, k))_ | Medium ||
| 0285 | [Inorder Successor in BST](./problems/0285-inorder-successor-in-bst.md) | [Go](./golang/0285_inorder_successor_in_bst.go)   | _O(h)_          | _O(1)_          | Medium         | 🔒 |
| 0510 | [Inorder Successor in BST II](./problems/0510-inorder-successor-in-bst-ii.md) | [Go](./golang/0510_inorder_successor_in_bst_ii.go)   | _O(h)_          | _O(1)_          | Medium         | 🔒 | |

---

### 2. LCA / Closest

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0235 | [Lowest Common Ancestor of a Binary Search Tree](./problems/0235-lowest-common-ancestor-of-a-binary-search-tree.md) | [Go](./golang/0235_lowest_common_ancestor_of_a_binary_search_tree.go) | _O(h)_ | _O(1)_ | Easy | EPI |
| 0270 | [Closest Binary Search Tree Value](./problems/0270-closest-binary-search-tree-value.md) | [Go](./golang/0270_closest_binary_search_tree_value.go)   | _O(h)_          | _O(1)_          | Easy         | 🔒 |

---

### 3. Serialize / Interval

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0352 | [Data Stream as Disjoint Intervals](./problems/0352-data-stream-as-disjoint-intervals.md) | [Go](./golang/0352_data_stream_as_disjoint_intervals.go) | _O(logn)_ | _O(n)_ | Hard | |
| 0449 | [Serialize and Deserialize BST](./problems/0449-serialize-and-deserialize-bst.md) | [Go](./golang/0449_serialize_and_deserialize_bst.go)| _O(n)_ | _O(h)_ | Medium | | |

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0220 | [Contains Duplicate III](./problems/0220-contains-duplicate-iii.md) | [Go](./golang/0220_contains_duplicate_iii.go) | _O(nlogk)_        | _O(k)_          | Medium           ||
| 0450 | [Delete Node in a BST](./problems/0450-delete-node-in-a-bst.md) | [Go](./golang/0450_delete_node_in_a_bst.go)| _O(h)_ | _O(h)_ | Medium | | |
| 0530 | [Minimum Absolute Difference in BST](./problems/0530-minimum-absolute-difference-in-bst.md) | [Go](./golang/0530_minimum_absolute_difference_in_bst.go)| _O(n)_ | _O(h)_ | Easy | | |
| 0776 | [Split BST](./problems/0776-split-bst.md) | [Go](./golang/0776_split_bst.go)| _O(n)_ | _O(h)_ | Medium | 🔒 | |
| 0783 | [Minimum Distance Between BST Nodes](./problems/0783-minimum-distance-between-bst-nodes.md) | [Go](./golang/0783_minimum_distance_between_bst_nodes.go)| _O(n)_ | _O(h)_ | Easy | | |
| 1373 | [Maximum Sum BST in Binary Tree](./problems/1373-maximum-sum-bst-in-binary-tree.md) | [Go](./golang/1373_maximum_sum_bst_in_binary_tree.go) | _O(n)_          | _O(h)_          | Hard           || DFS, Stack |
| 1382 | [Balance a Binary Search Tree](./problems/1382-balance-a-binary-search-tree.md) | [Go](./golang/1382_balance_a_binary_search_tree.go) | _O(n)_          | _O(h)_          | Medium           || DFS, Stack |
| 1932 | [Merge BSTs to Create Single BST](./problems/1932-merge-bsts-to-create-single-bst.md) |[Go](./golang/1932_merge_bsts_to_create_single_bst.go) | _O(n)_      | _O(n)_          | Hard         | | BST, BFS
| 2426 | [Number of Pairs Satisfying Inequality](./problems/2426-number-of-pairs-satisfying-inequality.md) |[Go](./golang/2426_number_of_pairs_satisfying_inequality.go) | _O(nlogn)_      | _O(n)_          | Hard         | | Merge Sort, Two Pointers, BIT, Fenwick Tree, Coordinate Compression, Sorted List, Ordered Set, Binary Search
| 2689 | [Extract Kth Character From The Rope Tree](./problems/2689-extract-kth-character-from-the-rope-tree.md) |[Go](./golang/2689_extract_kth_character_from_the_rope_tree.go) | _O(h)_      | _O(1)_          | Medium         | 🔒 | BST
| 2817 | [Minimum Absolute Difference Between Elements With Constraint](./problems/2817-minimum-absolute-difference-between-elements-with-constraint.md) | [Go](./golang/2817_minimum_absolute_difference_between_elements_with_constraint.go) | _O(nlogn)_ | _O(n)_ | Medium | | Sorted List, BST, Binary Search |
| 2907 | [Maximum Profitable Triplets With Increasing Prices I](./problems/2907-maximum-profitable-triplets-with-increasing-prices-i.md) | [Go](./golang/2907_maximum_profitable_triplets_with_increasing_prices_i.go) | _O(nlogn)_ | _O(n)_ | Medium | 🔒 | Prefix Sum, Sorted List, BST, Binary Search, Mono Stack, BIT, Fenwick Tree, Segment Tree |
| 2921 | [Maximum Profitable Triplets With Increasing Prices II](./problems/2921-maximum-profitable-triplets-with-increasing-prices-ii.md) | [Go](./golang/2921_maximum_profitable_triplets_with_increasing_prices_ii.go) | _O(nlogn)_ | _O(n)_ | Hard | 🔒 | Prefix Sum, Sorted List, BST, Binary Search, Mono Stack, BIT, Fenwick Tree, Segment Tree |
| 2926 | [Maximum Balanced Subsequence Sum](./problems/2926-maximum-balanced-subsequence-sum.md) | [Go](./golang/2926_maximum_balanced_subsequence_sum.go) | _O(nlogn)_ | _O(n)_ | Hard | | Sorted List, BST, Binary Search, Mono Stack, BIT, Fenwick Tree, Segment Tree |

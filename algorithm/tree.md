## Tree

### 1. Traversal (Inorder/Pre/Post)

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0094 | [Binary Tree Inorder Traversal](./problems/0094-binary-tree-inorder-traversal.md) | [Go](./golang/0094_binary_tree_inorder_traversal.go) | _O(n)_| _O(1)_| Medium           || `Morris Traversal` | 
| 0099 | [Recover Binary Search Tree](./problems/0099-recover-binary-search-tree.md) | [Go](./golang/0099_recover_binary_search_tree.go) | _O(n)_| _O(1)_| Hard  || `Morris Traversal` 
| 0144 | [Binary Tree Preorder Traversal](./problems/0144-binary-tree-preorder-traversal.md) | [Go](./golang/0144_binary_tree_preorder_traversal.go) | _O(n)_| _O(1)_| Medium || `Morris Traversal` 
| 0145 | [Binary Tree Postorder Traversal](./problems/0145-binary-tree-postorder-traversal.md) | [Go](./golang/0145_binary_tree_postorder_traversal.go) | _O(n)_| _O(1)_| Hard  || `Morris Traversal` 
| 0429 | [N-ary Tree Level Order Traversal](./problems/0429-n-ary-tree-level-order-traversal.md) | [Go](./golang/0429_n_ary_tree_level_order_traversal.go)| _O(n)_ | _O(w)_ | Medium | | |
| 0501 | [Find Mode in Binary Search Tree](./problems/0501-find-mode-in-binary-search-tree.md) | [Go](./golang/0501_find_mode_in_binary_search_tree.go) | _O(n)_       | _O(1)_          | Easy         || Tree, Inorder Traversal |
| 0589 | [N-ary Tree Preorder Traversal](./problems/0589-n-ary-tree-preorder-traversal.md) | [Go](./golang/0589_n_ary_tree_preorder_traversal.go) | _O(n)_       | _O(h)_          | Easy         || Tree, Preorder Traversal |
| 0590 | [N-ary Tree Postorder Traversal](./problems/0590-n-ary-tree-postorder-traversal.md) | [Go](./golang/0590_n_ary_tree_postorder_traversal.go) | _O(n)_       | _O(h)_          | Medium         || Tree, Preorder Traversal |
| 0889 | [Construct Binary Tree from Preorder and Postorder Traversal](./problems/0889-construct-binary-tree-from-preorder-and-postorder-traversal.md) | [Go](./golang/0889_construct_binary_tree_from_preorder_and_postorder_traversal.go) | _O(n)_ | _O(h)_ | Medium || DFS, Stack |
| 0971 | [Flip Binary Tree To Match Preorder Traversal](./problems/0971-flip-binary-tree-to-match-preorder-traversal.md) | [Go](./golang/0971_flip_binary_tree_to_match_preorder_traversal.go) | _O(n)_          | _O(h)_          | Medium           || DFS |
| 0987 | [Vertical Order Traversal of a Binary Tree](./problems/0987-vertical-order-traversal-of-a-binary-tree.md) | [Go](./golang/0987_vertical_order_traversal_of_a_binary_tree.go) | _O(nlogn)_          | _O(n)_          | Medium           || DFS |
| 1008 | [Construct Binary Search Tree from Preorder Traversal](./problems/1008-construct-binary-search-tree-from-preorder-traversal.md) | [Go](./golang/1008_construct_binary_search_tree_from_preorder_traversal.go)| _O(n)_ | _O(h)_ | Medium |||
| 1028 | [Recover a Tree From Preorder Traversal](./problems/1028-recover-a-tree-from-preorder-traversal.md) | [Go](./golang/1028_recover_a_tree_from_preorder_traversal.go)| _O(n)_ | _O(h)_ | Hard || DFS |
| 0559 | [Maximum Depth of N-ary Tree](./problems/0559-maximum-depth-of-n-ary-tree.md) | [Go](./golang/0559_maximum_depth_of_n_ary_tree.go) | _O(n)_       | _O(h)_          | Easy         | | Tree, DFS |
| 0652 | [Find Duplicate Subtrees](./problems/0652-find-duplicate-subtrees.md) | [Go](./golang/0652_find_duplicate_subtrees.go)| _O(n)_ | _O(n)_ | Medium | | DFS, Hash |
| 0863 | [All Nodes Distance K in Binary Tree](./problems/0863-all-nodes-distance-k-in-binary-tree.md) | [Go](./golang/0863_all_nodes_distance_k_in_binary_tree.go) | _O(n)_ | _O(n)_ | Medium || DFS + BFS |
| 0958 | [Check Completeness of a Binary Tree](./problems/0958-check-completeness-of-a-binary-tree.md) | [Go](./golang/0958_check_completeness_of_a_binary_tree.go) | _O(n)_          | _O(w)_          | Medium           || BFS |
| 0993 | [Cousins in Binary Tree](./problems/0993-cousins-in-binary-tree.md) | [Go](./golang/0993_cousins_in_binary_tree.go) | _O(n)_          | _O(h)_          | Easy           || DFS |
| 1430 | [Check If a String Is a Valid Sequence from Root to Leaves Path in a Binary Tree](./problems/1430-check-if-a-string-is-a-valid-sequence-from-root-to-leaves-path-in-a-binary-tree.md) | [Go](./golang/1430_check_if_a_string_is_a_valid_sequence_from_root_to_leaves_path_in_a_binary_tree.go) | _O(n)_ | _O(h)_ | Medium | 🔒 |  BFS, DFS, Stack |
| 1448 | [Count Good Nodes in Binary Tree](./problems/1448-count-good-nodes-in-binary-tree.md) | [Go](./golang/1448_count_good_nodes_in_binary_tree.go) | _O(n)_ | _O(h)_ | Medium | | DFS, Stack |
| 1457 | [Pseudo-Palindromic Paths in a Binary Tree](./problems/1457-pseudo-palindromic-paths-in-a-binary-tree.md) | [Go](./golang/1457_pseudo_palindromic_paths_in_a_binary_tree.go) | _O(n)_ | _O(h)_ | Medium | | DFS, Stack |
| 1469 | [Find All The Lonely Nodes](./problems/1469-find-all-the-lonely-nodes.md) | [Go](./golang/1469_find_all_the_lonely_nodes.go) | _O(n)_ | _O(h)_ | Easy | 🔒 | DFS, Stack |
| 1490 | [Clone N-ary Tree](./problems/1490-clone-n-ary-tree.md) | [Go](./golang/1490_clone_n_ary_tree.go) | _O(n)_          | _O(h)_          | Medium           |🔒| DFS, Stack |
| 1519 | [Number of Nodes in the Sub-Tree With the Same Label](./problems/1519-number-of-nodes-in-the-sub-tree-with-the-same-label.md) | [Go](./golang/1519_number_of_nodes_in_the_sub_tree_with_the_same_label.go) | _O(n)_          | _O(h)_          | Medium           || DFS, Stack |
| 1530 | [Number of Good Leaf Nodes Pairs](./problems/1530-number-of-good-leaf-nodes-pairs.md) | [Go](./golang/1530_number_of_good_leaf_nodes_pairs.go) | _O(n)_ | _O(h)_ | Medium | | DFS, Stack |
| 2003 | [Smallest Missing Genetic Value in Each Subtree](./problems/2003-smallest-missing-genetic-value-in-each-subtree.md) |[Go](./golang/2003_smallest_missing_genetic_value_in_each_subtree.go) | _O(n)_ | _O(n)_ | Hard         | | DFS, Stack |
| 2096 | [Step-By-Step Directions From a Binary Tree Node to Another](./problems/2096-step-by-step-directions-from-a-binary-tree-node-to-another.md) |[Go](./golang/2096_step_by_step_directions_from_a_binary_tree_node_to_another.go) | _O(n)_ | _O(h)_ | Medium         | | DFS, Stack |
| 2196 | [Create Binary Tree From Descriptions](./problems/2196-create-binary-tree-from-descriptions.md) | [Go](./golang/2196_create_binary_tree_from_descriptions.go)| _O(n)_ | _O(n)_ | Medium | | |
| 1612 | [Check If Two Expression Trees are Equivalent](./problems/1612-check-if-two-expression-trees-are-equivalent.md) | [Go](./golang/1612_check_if_two_expression_trees_are_equivalent.go) | _O(n)_| _O(1)_| Medium           |🔒| `Morris Traversal`, Inorder Traversal, Stack, Hash Table | 

---

### 2. BST & Search

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0315 | [Count of Smaller Numbers After Self](./problems/0315-count-of-smaller-numbers-after-self.md) | [Go](./golang/0315_count_of_smaller_numbers_after_self.go)| _O(nlogn)_ | _O(n)_ | Hard | LintCode | BST, BIT, Fenwick Tree, Divide and Conquer, Merge Sort |
| 0426 | [Convert Binary Search Tree to Sorted Doubly Linked List](./problems/0426-convert-binary-search-tree-to-sorted-doubly-linked-list.md) | [Go](./golang/0426_convert_binary_search_tree_to_sorted_doubly_linked_list.go)| _O(n)_ | _O(h)_ | Medium | 🔒 | |
| 0538 | [Convert BST to Greater Tree](./problems/0538-convert-bst-to-greater-tree.md) | [Go](./golang/0538_convert_bst_to_greater_tree.go) | _O(n)_ | _O(h)_ | Easy    || 
| 0653 | [Two Sum IV - Input is a BST](./problems/0653-two-sum-iv-input-is-a-bst.md) | [Go](./golang/0653_two_sum_iv_input_is_a_bst.go)| _O(n)_ | _O(h)_ | Easy | | Two Pointers |
| 0700 | [Search in a Binary Search Tree](./problems/0700-search-in-a-binary-search-tree.md) | [Go](./golang/0700_search_in_a_binary_search_tree.go) | _O(h)_       | _O(1)_          | Easy         || Tree |
| 0701 | [Insert into a Binary Search Tree](./problems/0701-insert-into-a-binary-search-tree.md) | [Go](./golang/0701_insert_into_a_binary_search_tree.go) | _O(h)_       | _O(1)_          | Medium         || Tree |
| 0897 | [Increasing Order Search Tree](./problems/0897-increasing-order-search-tree.md) | [Go](./golang/0897_increasing_order_search_tree.go) | _O(n)_          | _O(h)_          | Easy           || DFS |
| 0919 | [Complete Binary Tree Inserter](./problems/0919-complete-binary-tree-inserter.md) | [Go](./golang/0919_complete_binary_tree_inserter.go) | ctor: _O(n)_ <br> insert: _O(1)_ <br> get_root: _O(1)_      | _O(n)_          | Medium           |||
| 0938 | [Range Sum of BST](./problems/0938-range-sum-of-bst.md) | [Go](./golang/0938_range_sum_of_bst.go) | _O(n)_          | _O(h)_          | Medium           || DFS |
| 1038 | [Binary Search Tree to Greater Sum Tree](./problems/1038-binary-search-tree-to-greater-sum-tree.md) | [Go](./golang/1038_binary_search_tree_to_greater_sum_tree.go)| _O(n)_ | _O(h)_ | Medium || DFS |
| 1325 | [Delete Leaves With a Given Value](./problems/1325-delete-leaves-with-a-given-value.md) | [Go](./golang/1325_delete_leaves_with_a_given_value.go) | _O(n)_ | _O(h)_ | Medium || DFS|
| 1948 | [Delete Duplicate Folders in System](./problems/1948-delete-duplicate-folders-in-system.md) |[Go](./golang/1948_delete_duplicate_folders_in_system.go) | _O(n * m * l + tlogt + l * t)_ | _O(l * t)_ | Hard         | variant of [Find Duplicate Subtrees](https://leetcode.com/problems/find-duplicate-subtrees/) | Trie, DFS, Hash |

---

### 3. Serialize / Deserialize

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0297 | [Serialize and Deserialize Binary Tree](./problems/0297-serialize-and-deserialize-binary-tree.md) | [Go](./golang/0297_serialize_and_deserialize_binary_tree.go) | _O(n)_ | _O(h)_ | Hard | LintCode | DFS
| 0428 | [Serialize and Deserialize N-ary Tree](./problems/0428-serialize-and-deserialize-n-ary-tree.md) | [Go](./golang/0428_serialize_and_deserialize_n_ary_tree.go)| _O(n)_ | _O(h)_ | Hard | 🔒 | |
| 0431 | [Encode N-ary Tree to Binary Tree](./problems/0431-encode-n-ary-tree-to-binary-tree.md) | [Go](./golang/0431_encode_n_ary_tree_to_binary_tree.go)| _O(n)_ | _O(h)_ | Hard | 🔒 | |

---

### 4. Path & Sum

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0543 | [Diameter of Binary Tree](./problems/0543-diameter-of-binary-tree.md) | [Go](./golang/0543_diameter_of_binary_tree.go) | _O(n)_ | _O(h)_ | Easy    || 
| 0563 | [Binary Tree Tilt](./problems/0563-binary-tree-tilt.md) | [Go](./golang/0563_binary_tree_tilt.go)| _O(n)_ | _O(n)_ | Easy | | |
| 0508 | [Most Frequent Subtree Sum](./problems/0508-most-frequent-subtree-sum.md) | [Go](./golang/0508_most_frequent_subtree_sum.go) | _O(n)_       | _O(n)_          | Medium         || Tree, DFS, Hash |
| 0687 | [Longest Univalue Path](./problems/0687-longest-univalue-path.md) | [Go](./golang/0687_longest_univalue_path.go) | _O(n)_ | _O(h)_ | Easy ||
| 1022 | [Sum of Root To Leaf Binary Numbers](./problems/1022-sum-of-root-to-leaf-binary-numbers.md) | [Go](./golang/1022_sum_of_root_to_leaf_binary_numbers.go)| _O(n)_ | _O(h)_ | Easy |||
| 1080 | [Insufficient Nodes in Root to Leaf Paths](./problems/1080-insufficient-nodes-in-root-to-leaf-paths.md) | [Go](./golang/1080_insufficient_nodes_in_root_to_leaf_paths.go)| _O(n)_ | _O(h)_ | Medium || DFS |
| 1120 | [Maximum Average Subtree](./problems/1120-maximum-average-subtree.md) | [Go](./golang/1120_maximum_average_subtree.go) | _O(n)_ | _O(h)_ | Easy |🔒| DFS |
| 1339 | [Maximum Product of Splitted Binary Tree](./problems/1339-maximum-product-of-splitted-binary-tree.md) | [Go](./golang/1339_maximum_product_of_splitted_binary_tree.go) | _O(n)_ | _O(h)_ | Medium || DFS|
| 1443 | [Minimum Time to Collect All Apples in a Tree](./problems/1443-minimum-time-to-collect-all-apples-in-a-tree.md) | [Go](./golang/1443_minimum_time_to_collect_all_apples_in_a_tree.go) | _O(n)_          | _O(n)_          | Medium           || DFS, Stack |
| 1522 | [Diameter of N-Ary Tree](./problems/1522-diameter-of-n-ary-tree.md) | [Go](./golang/1522_diameter_of_n_ary_tree.go) | _O(n)_          | _O(h)_          | Medium           |🔒, variant of [Tree Diameter](https://leetcode.com/problems/tree-diameter/) | DFS, Stack |

---

### 5. Construction

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0427 | [Construct Quad Tree](./problems/0427-construct-quad-tree.md) | [Go](./golang/0427_construct_quad_tree.go)| _O(n)_ | _O(h)_ | Medium | | |
| 0536 | [Construct Binary Tree from String](./problems/0536-construct-binary-tree-from-string.md) | [Go](./golang/0536_construct_binary_tree_from_string.go) | _O(n)_ | _O(h)_ | Medium    | 🔒 |
| 0606 | [Construct String from Binary Tree](./problems/0606-construct-string-from-binary-tree.md) | [Go](./golang/0606_construct_string_from_binary_tree.go)| _O(n)_ | _O(h)_ | Easy | | |
| 0654 | [Maximum Binary Tree](./problems/0654-maximum-binary-tree.md) | [Go](./golang/0654_maximum_binary_tree.go)| _O(n)_ | _O(n)_ | Medium | LintCode | Mono Stack,  Cartesian Tree |
| 0998 | [Maximum Binary Tree II](./problems/0998-maximum-binary-tree-ii.md) | [Go](./golang/0998_maximum_binary_tree_ii.go)| _O(h)_ | _O(1)_ | Medium ||  Cartesian Tree |

---

### 6. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0226 | [Invert Binary Tree](./problems/0226-invert-binary-tree.md) | [Go](./golang/0226_invert_binary_tree.go) | _O(n)_ | _O(h)_, _O(w)_ | Easy ||
| 0513 | [Find Bottom Left Tree Value](./problems/0513-find-bottom-left-tree-value.md) | [Go](./golang/0513_find_bottom_left_tree_value.go) | _O(n)_       | _O(h)_          | Medium         || Tree, DFS, BFS |
| 0545 | [Boundary of Binary Tree](./problems/0545-boundary-of-binary-tree.md) | [Go](./golang/0545_boundary_of_binary_tree.go) | _O(n)_ | _O(h)_ | Medium    |🔒|
| 0558 | [Logical OR of Two Binary Grids Represented as Quad-Trees](./problems/0558-logical-or-of-two-binary-grids-represented-as-quad-trees.md) | [Go](./golang/0558_logical_or_of_two_binary_grids_represented_as_quad_trees.go) | _O(n)_       | _O(h)_          | Medium         | | Tree, Divide and Conquer |
| 0572 | [Subtree of Another Tree](./problems/0572-subtree-of-another-tree.md) | | _O(m * n)_ | _O(h)_ | Easy | | |
| 0617 | [Merge Two Binary Trees](./problems/0617-merge-two-binary-trees.md) | [Go](./golang/0617_merge_two_binary_trees.go)| _O(n)_ | _O(h)_ | Easy | | |
| 0623 | [Add One Row to Tree](./problems/0623-add-one-row-to-tree.md) | [Go](./golang/0623_add_one_row_to_tree.go)| _O(n)_ | _O(h)_ | Medium | | |
| 0637 | [Average of Levels in Binary Tree](./problems/0637-average-of-levels-in-binary-tree.md) | [Go](./golang/0637_average_of_levels_in_binary_tree.go)| _O(n)_ | _O(h)_ | Easy | | |
| 0655 | [Print Binary Tree](./problems/0655-print-binary-tree.md) | [Go](./golang/0655_print_binary_tree.go) | _O(n)_ | _O(h)_ | Medium | |
| 0662 | [Maximum Width of Binary Tree](./problems/0662-maximum-width-of-binary-tree.md) | [Go](./golang/0662_maximum_width_of_binary_tree.go) | _O(n)_ | _O(h)_ | Medium | | DFS
| 0663 | [Equal Tree Partition](./problems/0663-equal-tree-partition.md) | | _O(n)_ | _O(n)_ | Medium | 🔒 | Hash
| 0814 | [Binary Tree Pruning](./problems/0814-binary-tree-pruning.md) | [Go](./golang/0814_binary_tree_pruning.go) | _O(n)_ | _O(h)_ | Medium || DFS |
| 0865 | [Smallest Subtree with all the Deepest Nodes](./problems/0865-smallest-subtree-with-all-the-deepest-nodes.md) | [Go](./golang/0865_smallest_subtree_with_all_the_deepest_nodes.go) | _O(n)_ | _O(h)_ | Medium || DFS |
| 0951 | [Flip Equivalent Binary Trees](./problems/0951-flip-equivalent-binary-trees.md) | [Go](./golang/0951_flip_equivalent_binary_trees.go) | _O(n)_          | _O(h)_          | Medium           || DFS |
| 0965 | [Univalued Binary Tree](./problems/0965-univalued-binary-tree.md) | [Go](./golang/0965_univalued_binary_tree.go) | _O(n)_          | _O(h)_          | Easy           || DFS |
| 0979 | [Distribute Coins in Binary Tree](./problems/0979-distribute-coins-in-binary-tree.md) | [Go](./golang/0979_distribute_coins_in_binary_tree.go) | _O(n)_          | _O(h)_          | Medium           || DFS |
| 0988 | [Smallest String Starting From Leaf](./problems/0988-smallest-string-starting-from-leaf.md) | [Go](./golang/0988_smallest_string_starting_from_leaf.go) | _O(n + l * h)_          | _O(h)_          | Medium           || DFS |
| 1026 | [Maximum Difference Between Node and Ancestor](./problems/1026-maximum-difference-between-node-and-ancestor.md) | [Go](./golang/1026_maximum_difference_between_node_and_ancestor.go)| _O(n)_ | _O(h)_ | Medium || DFS |
| 1104 | [Path In Zigzag Labelled Binary Tree](./problems/1104-path-in-zigzag-labelled-binary-tree.md) | [Go](./golang/1104_path_in_zigzag_labelled_binary_tree.go)| _O(logn)_ | _O(logn)_ | Easy || Math |
| 1123 | [Lowest Common Ancestor of Deepest Leaves](./problems/1123-lowest-common-ancestor-of-deepest-leaves.md) | [Go](./golang/1123_lowest_common_ancestor_of_deepest_leaves.go) | _O(n)_ | _O(h)_ | Medium || DFS |
| 1145 | [Binary Tree Coloring Game](./problems/1145-binary-tree-coloring-game.md) | [Go](./golang/1145_binary_tree_coloring_game.go) | _O(n)_ | _O(h)_ | Medium || DFS |
| 1257 | [Smallest Common Region](./problems/1257-smallest-common-region.md) | [Go](./golang/1257_smallest_common_region.go) | _O(m * n)_ | _O(n)_ | Medium |||
| 1261 | [Find Elements in a Contaminated Binary Tree](./problems/1261-find-elements-in-a-contaminated-binary-tree.md) | [Go](./golang/1261_find_elements_in_a_contaminated_binary_tree.go) | _O(n)_ | _O(h)_ | Medium || DFS|
| 1506 | [Find Root of N-Ary Tree](./problems/1506-find-root-of-n-ary-tree.md) | [Go](./golang/1506_find_root_of_n_ary_tree.go) | _O(n)_ | _O(1)_ | Medium | 🔒 | Bit Manipulation
| 1516 | [Move Sub-Tree of N-Ary Tree](./problems/1516-move-sub-tree-of-n-ary-tree.md) | [Go](./golang/1516_move_sub_tree_of_n_ary_tree.go) | _O(n)_ | _O(h)_ | Hard | 🔒 | DFS, Stack
| 1666 | [Change the Root of a Binary Tree](./problems/1666-change-the-root-of-a-binary-tree.md) | [Go](./golang/1666_change_the_root_of_a_binary_tree.go) | _O(h)_| _O(1)_| Medium           |🔒| | 
| 2236 | [Root Equals Sum of Children](./problems/2236-root-equals-sum-of-children.md) | [Go](./golang/2236_root_equals_sum_of_children.go)| _O(1)_ | _O(1)_ | Easy | | Tree |
| 2277 | [Closest Node to Path in Tree](./problems/2277-closest-node-to-path-in-tree.md) | [Go](./golang/2277_closest_node_to_path_in_tree.go)| _O(n + q)_ | _O(n + q)_ | Hard | 🔒 | Tree, BFS, Binary Lifting, `Tarjan's Offline LCA Algorithm` |
| 2509 | [Cycle Length Queries in a Tree](./problems/2509-cycle-length-queries-in-a-tree.md) | [Go](./golang/2509_cycle_length_queries_in_a_tree.go)| _O(q * n)_ | _O(1)_ | Hard | | Tree, LCA |
| 2846 | [Minimum Edge Weight Equilibrium Queries in a Tree](./problems/2846-minimum-edge-weight-equilibrium-queries-in-a-tree.md) | [Go](./golang/2846_minimum_edge_weight_equilibrium_queries_in_a_tree.go)| _O(r * (n + q))_ | _O(r * n + q)_ | Hard | | Tree, Binary Lifting, `Tarjan's Offline LCA Algorithm` |

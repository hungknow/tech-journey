## Depth-First Search

### 1. Path / Sum

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0112 | [Path Sum](./problems/0112-path-sum.md) |  [Go](./golang/0112_path_sum.go)| _O(n)_          | _O(h)_          | Easy           ||
| 0113 | [Path Sum II](./problems/0113-path-sum-ii.md) |  [Go](./golang/0113_path_sum_ii.go)| _O(n)_         | _O(h)_          | Medium         ||
| 0257 | [Binary Tree Paths](./problems/0257-binary-tree-paths.md) | [Go](./golang/0257_binary_tree_paths.go)  | _O(n * h)_ | _O(h)_ | Easy         |||

---

### 2. Islands / Grid

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0200 | [Number of Islands](./problems/0200-number-of-islands.md) | [Go](./golang/0200_number_of_islands.go) | _O(m * n)_ | _O(m * n)_| Medium         || BFS, DFS, Union Find
| 0694 | [Number of Distinct Islands](./problems/0694-number-of-distinct-islands.md) | [Go](./golang/0694_number_of_distinct_islands.go) | _O(m * n)_          | _O(m * n)_          | Medium           |🔒||
| 0695 | [Max Area of Island](./problems/0695-max-area-of-island.md) | [Go](./golang/0695_max_area_of_island.go) | _O(m * n)_          | _O(m * n)_          | Easy           ||
| 0711 | [Number of Distinct Islands II](./problems/0711-number-of-distinct-islands-ii.md) | [Go](./golang/0711_number_of_distinct_islands_ii.go) | _O((m * n) * log(m * n))_          | _O(m * n)_          | Hard           |🔒| Hash |
| 0733 | [Max Area of Island](./problems/0733-flood-fill.md) | [Go](./golang/0733_flood_fill.go) | _O(m * n)_          | _O(m * n)_          | Easy           ||
| 1254 | [Number of Closed Islands](./problems/1254-number-of-closed-islands.md) | [Go](./golang/1254_number_of_closed_islands.go) | _O(m * n)_          | _O(1)_          | Medium           |||
| 1722 | [Minimize Hamming Distance After Swap Operations](./problems/1722-minimize-hamming-distance-after-swap-operations.md) | [Go](./golang/1722_minimize_hamming_distance_after_swap_operations.go) | _O(n)_          | _O(n)_          | Medium           || Flood Fill, Union Find |
| 0130 | [Surrounded Regions](./problems/0130-surrounded-regions.md) |[Go](./golang/0130_surrounded_regions.go)| _O(m * n)_ | _O(m + n)_ | Medium         ||
| 1905 | [Count Sub Islands](./problems/1905-count-sub-islands.md) | [Go](./golang/1905_count_sub_islands.go) | _O(m * n)_ | _O(1)_ | Medium | | Flood Fill |

---

### 3. Graph / Cycle

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0785 | [Is Graph Bipartite?](./problems/0785-is-graph-bipartite.md) | [Go](./golang/0785_is_graph_bipartite.go) | _O(\|V\| + \|E\|)_          | _O(\|V\|)_          | Medium           |||
| 0802 | [Find Eventual Safe States](./problems/0802-find-eventual-safe-states.md) | [Go](./golang/0802_find_eventual_safe_states.go) | _O(\|V\| + \|E\|)_          | _O(\|V\|)_ | Medium           |||

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0199 | [Binary Tree Right Side View](./problems/0199-binary-tree-right-side-view.md) |  [Go](./golang/0199_binary_tree_right_side_view.go)| _O(n)_     | _O(h)_ | Medium  ||
| 0236 | [Lowest Common Ancestor of a Binary Tree](./problems/0236-lowest-common-ancestor-of-a-binary-tree.md) | [Go](./golang/0236_lowest_common_ancestor_of_a_binary_tree.go) | _O(n)_ | _O(h)_ | Medium | EPI |
| 0247 | [Strobogrammatic Number II](./problems/0247-strobogrammatic-number-ii.md) | [Go](./golang/0247_strobogrammatic_number_ii.go)  | _O(n * 5^(n/2))_ | _O(n)_ | Medium         |🔒||
| 0282 | [Expression Add Operators](./problems/0282-expression-add-operators.md) | [Go](./golang/0282_expression_add_operators.go)  | _O(4^n)_ | _O(n)_ | Hard         |||
| 0301 | [Remove Invalid Parentheses](./problems/0301-remove-invalid-parentheses.md) | [Go](./golang/0301_remove_invalid_parentheses.go)  | _O(C(n, c))_ | _O(c)_ | Hard         |||
| 0329 | [Longest Increasing Path in a Matrix](./problems/0329-longest-increasing-path-in-a-matrix.md) | [Go](./golang/0329_longest_increasing_path_in_a_matrix.go)  | _O(m * n)_ | _O(m * n)_ | Hard         || DFS, Topological Sort |
| 0339 | [Nested List Weight Sum](./problems/0339-nested-list-weight-sum.md) | [Go](./golang/0339_nested_list_weight_sum.go)  | _O(n)_ | _O(h)_ | Easy         |🔒||
| 0364 | [Nested List Weight Sum II](./problems/0364-nested-list-weight-sum-ii.md) | [Go](./golang/0364_nested_list_weight_sum_ii.go)  | _O(n)_ | _O(h)_ | Medium         |🔒||
| 0366 | [Find Leaves of Binary Tree](./problems/0366-find-leaves-of-binary-tree.md) | [Go](./golang/0366_find_leaves_of_binary_tree.go)  | _O(n)_ | _O(h)_ | Medium         |🔒||
| 0417 | [Pacific Atlantic Water Flow](./problems/0417-pacific-atlantic-water-flow.md) | [Go](./golang/0417_pacific_atlantic_water_flow.go) | _O(m * n)_ | _O(m * n)_ | Medium ||
| 0440 | [K-th Smallest in Lexicographical Order](./problems/0440-k-th-smallest-in-lexicographical-order.md) | [Go](./golang/0440_k_th_smallest_in_lexicographical_order.go) | _O(logn)_          | _O(logn)_          | Hard           ||
| 0464 | [Can I Win](./problems/0464-can-i-win.md) | [Go](./golang/0464_can_i_win.go) | _O(n!)_          | _O(n)_          | Medium           ||
| 0515 | [Find Largest Value in Each Tree Row](./problems/0515-find-largest-value-in-each-tree-row.md) | [Go](./golang/0515_find_largest_value_in_each_tree_row.go) | _O(n)_          | _O(h)_          | Medium           |||
| 0547 | [Friend Circles](./problems/0547-friend-circles.md) | [Go](./golang/0547_friend_circles.go) | _O(n^2)_          | _O(n)_          | Medium           || Union Find |
| 0582 | [Kill Process](./problems/0582-kill-process.md) | [Go](./golang/0582_kill_process.go) | _O(n)_          | _O(n)_          | Medium           |🔒| DFS, BFS |
| 0638 | [Shopping Offers](./problems/0638-shopping-offers.md) | [Go](./golang/0638_shopping_offers.go) | _O(n * 2^n)_          | _O(n)_          | Medium           ||
| 0690 | [Employee Importance](./problems/0690-employee-importance.md) | [Go](./golang/0690_employee_importance.go) | _O(n)_          | _O(h)_          | Easy           || DFS, BFS
| 0749 | [Contain Virus](./problems/0749-contain-virus.md) | [Go](./golang/0749_contain_virus.go) | _O((m * n)^(4/3))_          | _O(m * n)_          | Hard           || Simulation|
| 0753 | [Cracking the Safe](./problems/0753-cracking-the-safe.md) | [Go](./golang/0753_cracking_the_safe.go) | _O(k^n)_          | _O(k^n)_          | Hard           || `de Bruijn sequences`, `Lyndon word`, Rolling Hash, Backtracking, Greedy |
| 0756 | [Pyramid Transition Matrix](./problems/0756-pyramid-transition-matrix.md) | [Go](./golang/0756_pyramid_transition_matrix.go) | _O(a^b)_          | _O(a^b)_          | Medium           |||
| 0797 | [All Paths From Source to Target](./problems/0797-all-paths-from-source-to-target.md) | [Go](./golang/0797_all_paths_from_source_to_target.go) | _O(p + r * n)_          | _O(n)_          | Medium           |||
| 0827 | [Making A Large Island](./problems/0827-making-a-large-island.md) | [Go](./golang/0827_making_a_large_island.go) | _O(n^2)_          | _O(n^2)_          | Hard           |||
| 0834 | [Sum of Distances in Tree](./problems/0834-sum-of-distances-in-tree.md) | [Go](./golang/0834_sum_of_distances_in_tree.go) | _O(n)_          | _O(n)_          | Hard           |||
| 0841 | [Keys and Rooms](./problems/0841-keys-and-rooms.md) | [Go](./golang/0841_keys_and_rooms.go) | _O(n!)_          | _O(n)_          | Medium           |||
| 0851 | [Loud and Rich](./problems/0851-loud-and-rich.md) | [Go](./golang/0851_loud_and_rich.go) | _O(q + r)_          | _O(q + r)_          | Medium           |||
| 1020 | [Number of Enclaves](./problems/1020-number-of-enclaves.md) | [Go](./golang/1020_number_of_enclaves.go) | _O(m * n)_          | _O(m * n)_          | Medium           |||
| 1059 | [All Paths from Source Lead to Destination](./problems/1059-all-paths-from-source-lead-to-destination.md) | [Go](./golang/1059_all_paths_from_source_lead_to_destination.go) | _O(n + e)_          | _O(n + e)_          | Medium           |🔒||
| 1192 | [Critical Connections in a Network](./problems/1192-critical-connections-in-a-network.md) | [Go](./golang/1192_critical_connections_in_a_network.go) | _O(\|V\| + \|E\|)_           | _O(\|V\| + \|E\|)_          | Hard           || `Tarjan's Algorithm`, `Bridge Finding Algorithm` |
| 1202 | [Smallest String With Swaps](./problems/1202-smallest-string-with-swaps.md) | [Go](./golang/1202_smallest_string_with_swaps.go) | _O(nlogn)_          | _O(n)_          | Medium           || Union Find |
| 1273 | [Delete Tree Nodes](./problems/1273-delete-tree-nodes.md) | [Go](./golang/1273_delete_tree_nodes.go) | _O(n)_          | _O(n)_          | Medium           || DFS, DP |
| 1315 | [Sum of Nodes with Even-Valued Grandparent](./problems/1315-sum-of-nodes-with-even-valued-grandparent.md) | [Go](./golang/1315_sum_of_nodes_with_even_valued_grandparent.go) | _O(n)_          | _O(h)_          | Medium           |||
| 1319 | [Number of Operations to Make Network Connected](./problems/1319-number-of-operations-to-make-network-connected.md) | [Go](./golang/1319_number_of_operations_to_make_network_connected.go) | _O(\|E\| + \|V\|)_          | _O(\|V\|)_          | Medium           || Union Find|
| 1367 | [Linked List in Binary Tree](./problems/1367-linked-list-in-binary-tree.md) | [Go](./golang/1367_linked_list_in_binary_tree.go) | _O(n + l)_          | _O(h + l)_          | Medium           || `KMP Algorithm` |
| 1372 | [Longest ZigZag Path in a Binary Tree](./problems/1372-longest-zigzag-path-in-a-binary-tree.md) | [Go](./golang/1372_longest_zigzag_path_in_a_binary_tree.go) | _O(n)_          | _O(h)_          | Medium           |||
| 1376 | [Time Needed to Inform All Employees](./problems/1376-time-needed-to-inform-all-employees.md) | [Go](./golang/1376_time_needed_to_inform_all_employees.go) | _O(n)_          | _O(n)_          | Medium           |||
| 1377 | [Frog Position After T Seconds](./problems/1377-frog-position-after-t-seconds.md) | [Go](./golang/1377_frog_position_after_t_seconds.go) | _O(n)_          | _O(n)_          | Hard           || DFS, Stack, BFS|
| 1391 | [Check if There is a Valid Path in a Grid](./problems/1391-check-if-there-is-a-valid-path-in-a-grid.md) | [Go](./golang/1391_check_if_there_is_a_valid_path_in_a_grid.go) | _O(m * n)_          | _O(1)_          | Medium           || Simulation |
| 1466 | [Reorder Routes to Make All Paths Lead to the City Zero](./problems/1466-reorder-routes-to-make-all-paths-lead-to-the-city-zero.md) | [Go](./golang/1466_reorder_routes_to_make_all_paths_lead_to_the_city_zero.go) | _O(n)_          | _O(n)_          | Medium           || DFS, Stack |
| 1485 | [Clone Binary Tree With Random Pointer](./problems/1485-clone-binary-tree-with-random-pointer.md) | [Go](./golang/1485_clone_binary_tree_with_random_pointer.go) | _O(n)_          | _O(h)_          | Medium           |🔒| DFS, Stack |
| 1644 | [Lowest Common Ancestor of a Binary Tree II](./problems/1644-lowest-common-ancestor-of-a-binary-tree-ii.md) | [Go](./golang/1644_lowest_common_ancestor_of_a_binary_tree_ii.go) | _O(n)_          | _O(h)_          | Medium           |🔒| DFS, Stack |
| 1676 | [Lowest Common Ancestor of a Binary Tree IV](./problems/1676-lowest-common-ancestor-of-a-binary-tree-iv.md) | [Go](./golang/1676_lowest_common_ancestor_of_a_binary_tree_iv.go) | _O(n)_          | _O(h)_          | Medium           |🔒| DFS, Stack |
| 1740 | [Find Distance in a Binary Tree](./problems/1740-find-distance-in-a-binary-tree.md) | [Go](./golang/1740_find_distance_in_a_binary_tree.go) | _O(n)_ | _O(h)_ | Medium | variant of [Lowest Common Ancestor of a Binary Tree](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/), 🔒 | |
| 1766 | [Tree of Coprimes](./problems/1766-tree-of-coprimes.md) | [Go](./golang/1766_tree_of_coprimes.go) | _O(n)_ | _O(n)_ | Hard | | |
| 1973 | [Count Nodes Equal to Sum of Descendants](./problems/1973-count-nodes-equal-to-sum-of-descendants.md) | [Go](./golang/1973_count_nodes_equal_to_sum_of_descendants.go) | _O(n)_ | _O(h)_ | Medium | 🔒 | |
| 2049 | [Count Nodes With the Highest Score](./problems/2049-count-nodes-with-the-highest-score.md) | [Go](./golang/2049_count_nodes_with_the_highest_score.go) | _O(n)_ | _O(n)_ | Medium | | |
| 2065 | [Maximum Path Quality of a Graph](./problems/2065-maximum-path-quality-of-a-graph.md) | [Go](./golang/2065_maximum_path_quality_of_a_graph.go) | _O(\|V\| + \|E\| + 4^10)_ | _O(\|V\| + \|E\| )_ | Hard | | Pruning |
| 2192 | [All Ancestors of a Node in a Directed Acyclic Graph](./problems/2192-all-ancestors-of-a-node-in-a-directed-acyclic-graph.md) | [Go](./golang/2192_all_ancestors_of_a_node_in_a_directed_acyclic_graph.go) | _O(\|V\| * \|E\|)_ | _O(\|V\| + \|E\|)_ | Medium | | DFS, BFS, Topological Sort |
| 2246 | [Longest Path With Different Adjacent Characters](./problems/2246-longest-path-with-different-adjacent-characters.md) | [Go](./golang/2246_longest_path_with_different_adjacent_characters.go) | _O(n)_ | _O(h)_ | Hard | | DFS, BFS, Topological Sort |
| 2265 | [Count Nodes Equal to Average of Subtree](./problems/2265-count-nodes-equal-to-average-of-subtree.md) | [Go](./golang/2265_count_nodes_equal_to_average_of_subtree.go) | _O(n)_ | _O(h)_ | Medium | | DFS, Tree |
| 2322 | [Minimum Score After Removals on a Tree](./problems/2322-minimum-score-after-removals-on-a-tree.md) | [Go](./golang/2322_minimum_score_after_removals_on_a_tree.go) | _O(n^2)_ | _O(n)_ | Hard | | DFS, Tree |
| 2331 | [Evaluate Boolean Binary Tree](./problems/2331-evaluate-boolean-binary-tree.md) | [Go](./golang/2331_evaluate_boolean_binary_tree.go) | _O(n)_ | _O(h)_ | Easy | | DFS |
| 2385 | [Amount of Time for Binary Tree to Be Infected](./problems/2385-amount-of-time-for-binary-tree-to-be-infected.md) | [Go](./golang/2385_amount_of_time_for_binary_tree_to_be_infected.go) | _O(n)_ | _O(h)_ | Medium | | BFS, DFS, Tree DP |
| 2445 | [Number of Nodes With Value One](./problems/2445-number-of-nodes-with-value-one.md) | [Go](./golang/2445_number_of_nodes_with_value_one.go)| _O(q + h)_ | _O(q + h)_ | Medium | 🔒 | Tree, DFS, BFS |
| 2458 | [Height of Binary Tree After Subtree Removal Queries](./problems/2458-height-of-binary-tree-after-subtree-removal-queries.md) | [Go](./golang/2458_height_of_binary_tree_after_subtree_removal_queries.go)| _O(n)_ | _O(n)_ | Hard | | Tree, DFS |
| 2467 | [Most Profitable Path in a Tree](./problems/2467-most-profitable-path-in-a-tree.md) | [Go](./golang/2467_most_profitable_path_in_a_tree.go)| _O(n)_ | _O(n)_ | Medium | | Tree, DFS |
| 2477 | [Minimum Fuel Cost to Report to the Capital](./problems/2477-minimum-fuel-cost-to-report-to-the-capital.md) | [Go](./golang/2477_minimum_fuel_cost_to_report_to_the_capital.go)| _O(n)_ | _O(h)_ | Medium | | Tree, DFS |
| 2581 | [Count Number of Possible Root Nodes](./problems/2581-count-number-of-possible-root-nodes.md) | [Go](./golang/2581_count_number_of_possible_root_nodes.go)| _O(n)_ | _O(h)_ | Hard | | Tree, DFS |
| 2773 | [Height of Special Binary Tree](./problems/2773-height-of-special-binary-tree.md) | [Go](./golang/2773_height_of_special_binary_tree.go)| _O(n)_ | _O(h)_ | Medium | 🔒 | Tree, DFS, BFS |
| 2791 | [Count Paths That Can Form a Palindrome in a Tree](./problems/2791-count-paths-that-can-form-a-palindrome-in-a-tree.md) | [Go](./golang/2791_count_paths_that_can_form_a_palindrome_in_a_tree.go)| _O(n)_ | _O(n)_ | Hard | | Tree, DFS, Freq Table |
| 2973 | [Find Number of Coins to Place in Tree Nodes](./problems/2973-find-number-of-coins-to-place-in-tree-nodes.md) | [Go](./golang/2973_find_number_of_coins_to_place_in_tree_nodes.go)| _O(n)_ | _O(n)_ | Hard | | DFS |

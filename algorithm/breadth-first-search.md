## Breadth-First Search

### 1. Tree Level

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0102 | [Binary Tree Level Order Traversal](./problems/0102-binary-tree-level-order-traversal.md) | [Go](./golang/0102_binary_tree_level_order_traversal.go)| _O(n)_| _O(n)_| Easy  || 
| 0103 | [Binary Tree Zigzag Level Order Traversal](./problems/0103-binary-tree-zigzag-level-order-traversal.md) |  [Go](./golang/0103_binary_tree_zigzag_level_order_traversal.go)| _O(n)_| _O(n)_| Medium  ||  
| 0107 | [Binary Tree Level Order Traversal II](./problems/0107-binary-tree-level-order-traversal-ii.md) | [Go](./golang/0107_binary_tree_level_order_traversal_ii.go) | _O(n)_| _O(n)_| Easy  ||

---

### 2. Graph / Shortest Path

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0127 | [Word Ladder](./problems/0127-word-ladder.md) |[Go](./golang/0127_word_ladder.go) | _O(b^(d/2))_      | _O(w * l)_          | Medium         | CTCI | Bi-BFS

---

### 3. Grid / Matrix

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0934 | [Shortest Bridge](./problems/0934-shortest-bridge.md) | [Go](./golang/0934_shortest_bridge.go)| _O(n^2)_ | _O(n^2)_ | Medium | | BFS, DFS |
| 0994 | [Rotting Oranges](./problems/0994-rotting-oranges.md) | [Go](./golang/0994_rotting_oranges.go)| _O(m * n)_ | _O(m * n)_ | Easy | | |
| 1926 | [Nearest Exit from Entrance in Maze](./problems/1926-nearest-exit-from-entrance-in-maze.md) |[Go](./golang/1926_nearest_exit_from_entrance_in_maze.go) | _O(m * n)_      | _O(m + n)_          | Medium         | | Bi-BFS

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0133 | [Clone Graph](./problems/0133-clone-graph.md) |  [Go](./golang/0133_clone_graph.go)| _O(n)_          | _O(n)_          | Medium         ||
| 1625 | [Lexicographically Smallest String After Applying Operations](./problems/1625-lexicographically-smallest-string-after-applying-operations.md) | [Go](./golang/1625_lexicographically_smallest_string_after_applying_operations.go)| _O(n^2)_ | _O(1)_ | Medium || BFS, String
| 1654 | [Minimum Jumps to Reach Home](./problems/1654-minimum-jumps-to-reach-home.md) | [Go](./golang/1654_minimum_jumps_to_reach_home.go)| _O(max(x, max(forbidden)) + a + b)_ | _O(max(x, max(forbidden)) + a + b)_ | Medium || BFS
| 1660 | [Correct a Binary Tree](./problems/1660-correct-a-binary-tree.md) | [Go](./golang/1660_correct_a_binary_tree.go)| _O(n)_ | _O(w)_ | Medium |🔒| BFS
| 1730 | [Shortest Path to Get Food](./problems/1730-shortest-path-to-get-food.md) | [Go](./golang/1730_shortest_path_to_get_food.go)| _O(m * n)_ | _O(m + n)_ | Medium |🔒| BFS
| 1765 | [Map of Highest Peak](./problems/1765-map-of-highest-peak.md) | [Go](./golang/1765_map_of_highest_peak.go)| _O(m * n)_ | _O(m * n)_ | Medium | | BFS
| 2039 | [The Time When the Network Becomes Idle](./problems/2039-the-time-when-the-network-becomes-idle.md) | [Go](./golang/2039_the_time_when_the_network_becomes_idle.go)| _O(\|E\|)_ | _O(\|E\|)_ | Medium | | Math |
| 2045 | [Second Minimum Time to Reach Destination](./problems/2045-second-minimum-time-to-reach-destination.md) | [Go](./golang/2045_second_minimum_time_to_reach_destination.go)| _O(\|E\|)_ | _O(\|E\|)_ | Hard | | Bi-BFS |
| 2059 | [Minimum Operations to Convert Number](./problems/2059-minimum-operations-to-convert-number.md) | [Go](./golang/2059_minimum_operations_to_convert_number.go)| _O(m * n)_ | _O(m)_ | Medium | | |
| 2146 | [K Highest Ranked Items Within a Price Range](./problems/2146-k-highest-ranked-items-within-a-price-range.md) | [Go](./golang/2146_k_highest_ranked_items_within_a_price_range.go)   | _O(m * n + klogk)_         | _O(m * n)_          | Medium         | | BFS, Quick Select, Sort |
| 2258 | [Escape the Spreading Fire](./problems/2258-escape-the-spreading-fire.md) | [Go](./golang/2258_escape_the_spreading_fire.go)   | _O(m * n)_         | _O(m * n)_          | Hard         | | BFS |
| 2290 | [Minimum Obstacle Removal to Reach Corner](./problems/2290-minimum-obstacle-removal-to-reach-corner.md) | [Go](./golang/2290_minimum_obstacle_removal_to_reach_corner.go)| _O(m * n)_ | _O(m * n)_ | Hard | variant of [Minimum Cost to Make at Least One Valid Path in a Grid](https://leetcode.com/problems/minimum-cost-to-make-at-least-one-valid-path-in-a-grid/) | `A* Search Algorithm`, 0-1 BFS, Deque |
| 2316 | [Count Unreachable Pairs of Nodes in an Undirected Graph](./problems/2316-count-unreachable-pairs-of-nodes-in-an-undirected-graph.md) | [Go](./golang/2316_count_unreachable_pairs_of_nodes_in_an_undirected_graph.go)| _O(n)_ | _O(n)_ | Medium | | Flood Fill, BFS, Math |
| 2368 | [Reachable Nodes With Restrictions](./problems/2368-reachable-nodes-with-restrictions.md) | [Go](./golang/2368_reachable_nodes_with_restrictions.go)| _O(n)_ | _O(n)_ | Medium | | BFS |
| 2415 | [Reverse Odd Levels of Binary Tree](./problems/2415-reverse-odd-levels-of-binary-tree.md) | [Go](./golang/2415_reverse_odd_levels_of_binary_tree.go)| _O(n)_ | _O(n)_ | Medium | | BFS |
| 2471 | [Minimum Number of Operations to Sort a Binary Tree by Level](./problems/2471-minimum-number-of-operations-to-sort-a-binary-tree-by-level.md) | [Go](./golang/2471_minimum_number_of_operations_to_sort_a_binary_tree_by_level.go)| _O(nlogn)_ | _O(w)_ | Medium | | Sort, BFS |
| 2492 | [Minimum Score of a Path Between Two Cities](./problems/2492-minimum-score-of-a-path-between-two-cities.md) | [Go](./golang/2492_minimum_score_of_a_path_between_two_cities.go)| _O(n + m)_ | _O(n + m)_ | Medium | | BFS |
| 2493 | [Divide Nodes Into the Maximum Number of Groups](./problems/2493-divide-nodes-into-the-maximum-number-of-groups.md) | [Go](./golang/2493_divide_nodes_into_the_maximum_number_of_groups.go)| _O(n^2)_ | _O(n)_ | Medium | variant of [Is Graph Bipartite?](https://leetcode.com/problems/is-graph-bipartite/) | BFS, DFS |
| 2503 | [Maximum Number of Points From Grid Queries](./problems/2503-maximum-number-of-points-from-grid-queries.md) | [Go](./golang/2503_maximum_number_of_points_from_grid_queries.go)| _O((m * n + q) * log(m * n))_ | _O(m * n)_ | Hard || BFS, Heap, Prefix Sum, Binary Search |
| 2583 | [Kth Largest Sum in a Binary Tree](./problems/2583-kth-largest-sum-in-a-binary-tree.md) | [Go](./golang/2583_kth_largest_sum_in_a_binary_tree.go)| _O(n)_ | _O(n)_ | Medium | | BFS, Quick Select |
| 2603 | [Collect Coins in a Tree](./problems/2603-collect-coins-in-a-tree.md) | [Go](./golang/2603_collect_coins_in_a_tree.go) | _O(n)_ | _O(n)_| Hard           || Tree, BFS |
| 2612 | [Minimum Reverse Operations](./problems/2612-minimum-reverse-operations.md) | [Go](./golang/2612_minimum_reverse_operations.go) | _O(n)_ | _O(n)_| Hard           || BFS, Union Find, BST, Sorted List |
| 2617 | [Minimum Number of Visited Cells in a Grid](./problems/2617-minimum-number-of-visited-cells-in-a-grid.md) | [Go](./golang/2617_minimum_number_of_visited_cells_in_a_grid.go) | _O(m * n)_ | _O(m * n)_| Hard           | variant of [Minimum Reverse Operations](https://leetcode.com/problems/minimum-reverse-operations/) | BFS, Union Find, BST, Sorted List |
| 2641 | [Cousins in Binary Tree II](./problems/2641-cousins-in-binary-tree-ii.md) | [Go](./golang/2641_cousins_in_binary_tree_ii.go) | _O(n)_ | _O(w)_| Medium           || BFS |
| 2658 | [Maximum Number of Fish in a Grid](./problems/2658-maximum-number-of-fish-in-a-grid.md) | [Go](./golang/2658_maximum_number_of_fish_in_a_grid.go) | _O(m * n)_ | _O(m + n)_| Medium           || BFS, DFS |
| 2685 | [Count the Number of Complete Components](./problems/2685-count-the-number-of-complete-components.md) | [Go](./golang/2685_count_the_number_of_complete_components.go) | _O(n)_ | _O(n)_| Medium           || BFS |
| 2709 | [Greatest Common Divisor Traversal](./problems/2709-greatest-common-divisor-traversal.md) | [Go](./golang/2709_greatest_common_divisor_traversal.go) | precompute: _O(sqrt(r))_<br>runtime: _O(n * (logr + sqrt(r)/log(sqrt(r))))_ | _O(sqrt(r) + nlogr)_| Hard           || `Linear Sieve of Eratosthenes`, Factorization, BFS |
| 2814 | [Minimum Time Takes to Reach Destination Without Drowning](./problems/2814-minimum-time-takes-to-reach-destination-without-drowning.md) | [Go](./golang/2814_minimum_time_takes_to_reach_destination_without_drowning.go) | _O(m * n)_ | _O(m * n)_| Hard           | 🔒 | Simulation, BFS |
| 2852 | [Sum of Remoteness of All Cells](./problems/2852-sum-of-remoteness-of-all-cells.md) | [Go](./golang/2852_sum_of_remoteness_of_all_cells.go)| _O(n^2)_ | _O(n^2)_ | Medium | 🔒 | Flood Fill, BFS, Math |

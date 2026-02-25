## Breadth-First Search

### 1. Tree Level

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0102 | [Binary Tree Level Order Traversal](./problems/0102-binary-tree-level-order-traversal.md) | [Go](./golang/0102_binary_tree_level_order_traversal.go)| _O(n)_| _O(n)_| Easy  || 
| 0103 | [Binary Tree Zigzag Level Order Traversal](./problems/0103-binary-tree-zigzag-level-order-traversal.md) |  [Go](./golang/0103_binary_tree_zigzag_level_order_traversal.go)| _O(n)_| _O(n)_| Medium  ||  
| 0107 | [Binary Tree Level Order Traversal II](./problems/0107-binary-tree-level-order-traversal-ii.md) | [Go](./golang/0107_binary_tree_level_order_traversal_ii.go) | _O(n)_| _O(n)_| Easy  ||
| 0117 | [Populating Next Right Pointers in Each Node II](./problems/0117-populating-next-right-pointers-in-each-node-ii.md) || _O(n)_ | _O(1)_ | Hard ||

---

### 2. Graph / Shortest Path

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0127 | [Word Ladder](./problems/0127-word-ladder.md) |[Go](./golang/0127_word_ladder.go) | _O(b^(d/2))_      | _O(w * l)_          | Medium         | CTCI | Bi-BFS
| 0207 | [Course Schedule](./problems/0207-course-schedule.md) | [Go](./golang/0207_course_schedule.go)   | _O(\|V\| + \|E\|)_          | _O(\|E\|)_          | Medium         || Topological Sort, `Kahn’s Algorithm` |
| 0210 | [Course Schedule II](./problems/0210-course-schedule-ii.md) | [Go](./golang/0210_course_schedule_ii.go)   | _O(\|V\| + \|E\|)_          | _O(\|E\|)_          | Medium         || Topological Sort, `Kahn’s Algorithm` |
| 0743 | [Network Delay Time](./problems/0743-network-delay-time.md) | [Go](./golang/0743_network_delay_time.go)| _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Medium | | `Dijkstra's Algorithm` |
| 0787 | [Cheapest Flights Within K Stops](./problems/0787-cheapest-flights-within-k-stops.md) | [Go](./golang/0787_cheapest_flights_within_k_stops.go)| _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Medium | | `Dijkstra's Algorithm` |
| 0864 | [Shortest Path to Get All Keys](./problems/0864-shortest-path-to-get-all-keys.md) | [Go](./golang/0864_shortest_path_to_get_all_keys.go)| _O(k * r * c + k^3*2^k)_ | _O(k*2^k)_ | Hard | | `Dijkstra's Algorithm` |
| 0882 | [Reachable Nodes In Subdivided Graph](./problems/0882-reachable-nodes-in-subdivided-graph.md) | [Go](./golang/0882_reachable_nodes_in_subdivided_graph.go)| _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Hard | | `Dijkstra's Algorithm` |
| 1102 | [Path With Maximum Minimum Value](./problems/1102-path-with-maximum-minimum-value.md) | [Go](./golang/1102_path_with_maximum_minimum_value.go)| _O((m * n) * log(m * n))_ | _O(m * n)_ | Medium | 🔒 | Binary Search, DFS, `Dijkstra's Algorithm` |
| 1514 | [Path with Maximum Probability](./problems/1514-path-with-maximum-probability.md) | [Go](./golang/1514_path_with_maximum_probability.go)| _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Medium | | `Dijkstra's Algorithm` |
| 1928 | [Minimum Cost to Reach Destination in Time](./problems/1928-minimum-cost-to-reach-destination-in-time.md) | [Go](./golang/1928_minimum_cost_to_reach_destination_in_time.go)| _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Hard | variant of [Cheapest Flights Within K Stops](https://leetcode.com/problems/cheapest-flights-within-k-stops/) | `Dijkstra's Algorithm` |
| 2577 | [Minimum Time to Visit a Cell In a Grid](./problems/2577-minimum-time-to-visit-a-cell-in-a-grid.md) | [Go](./golang/2577_minimum_time_to_visit_a_cell_in_a_grid.go)| _O(m * n * log\(m * n\))_ | _O(m * n)_ | Hard | | `Dijkstra's Algorithm` |
| 2812 | [Find the Safest Path in a Grid](./problems/2812-find-the-safest-path-in-a-grid.md) | [Go](./golang/2812_find_the_safest_path_in_a_grid.go) | _O(n^2)_ | _O(n^2)_| Medium           || BFS, Bucket Sort, Union Find, `Dijkstra's Algorithm`, Binary Search | 

---

### 3. Grid / Matrix

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0130 | [Surrounded Regions](./problems/0130-surrounded-regions.md) |[Go](./golang/0130_surrounded_regions.go)| _O(m * n)_ | _O(m + n)_ | Medium         ||
| 0490 | [The Maze](./problems/0490-the-maze.md) | [Go](./golang/0490_the_maze.go) | _O(max(r, c) * w)_ | _O(w)_ | Medium | | |
| 0499 | [The Maze III](./problems/0499-the-maze-iii.md) | [Go](./golang/0499_the_maze_iii.go) | _O(max(r, c) * wlogw)_ | _O(w^2)_ | Hard | | |
| 0505 | [The Maze II](./problems/0505-the-maze-ii.md) | [Go](./golang/0505_the_maze_ii.go) | _O(max(r, c) * wlogw)_ | _O(w)_ | Medium | | |
| 0542 | [01 Matrix](./problems/0542-01-matrix.md) | [Go](./golang/0542_01_matrix.go)   | _O(m * n)_          | _O(1)_          | Medium         || DP
| 0934 | [Shortest Bridge](./problems/0934-shortest-bridge.md) | [Go](./golang/0934_shortest_bridge.go)| _O(n^2)_ | _O(n^2)_ | Medium | | BFS, DFS |
| 0994 | [Rotting Oranges](./problems/0994-rotting-oranges.md) | [Go](./golang/0994_rotting_oranges.go)| _O(m * n)_ | _O(m * n)_ | Easy | | |
| 1036 | [Escape a Large Maze](./problems/1036-escape-a-large-maze.md) | [Go](./golang/1036_escape_a_large_maze.go)| _O(n^2)_ | _O(n)_ | Hard | | |
| 1926 | [Nearest Exit from Entrance in Maze](./problems/1926-nearest-exit-from-entrance-in-maze.md) |[Go](./golang/1926_nearest_exit_from_entrance_in_maze.go) | _O(m * n)_      | _O(m + n)_          | Medium         | | Bi-BFS

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0133 | [Clone Graph](./problems/0133-clone-graph.md) |  [Go](./golang/0133_clone_graph.go)| _O(n)_          | _O(n)_          | Medium         ||
| 0261 | [Graph Valid Tree](./problems/0261-graph-valid-tree.md) | [Go](./golang/0261_graph_valid_tree.go)   | _O(\|V\| + \|E\|)_          | _O(\|V\| + \|E\|)_          | Medium         | 🔒 |
| 0269 | [Alien Dictionary](./problems/0269-alien-dictionary.md) | [Go](./golang/0269_alien_dictionary.go)  | _O(n)_ | _O(1)_ | Hard         |🔒| Topological Sort, BFS, DFS |
| 0286 | [Walls and Gates](./problems/0286-walls-and-gates.md) | [Go](./golang/0286_walls_and_gates.go)   | _O(m * n)_          | _O(g)_          | Medium         | 🔒 |
| 0310 | [Minimum Height Trees](./problems/0310-minimum-height-trees.md) | [Go](./golang/0310_minimum_height_trees.go)   | _O(n)_          | _O(n)_          | Medium         ||
| 0317 | [Shortest Distance from All Buildings](./problems/0317-shortest-distance-from-all-buildings.md) | [Go](./golang/0317_shortest_distance_from_all_buildings.go)   | _O(k * m * n)_          | _O(m * n)_          | Hard         | 🔒 |
| 0433 | [Minimum Genetic Mutation](./problems/0433-minimum-genetic-mutation.md) | [Go](./golang/0433_minimum_genetic_mutation.go)   | _O(n * b)_          | _O(b)_          | Medium         ||
| 0444 | [Sequence Reconstruction](./problems/0444-sequence-reconstruction.md) | [Go](./golang/0444_sequence_reconstruction.go)   | _O(n * s)_          | _O(n)_          | Medium         |🔒| Topological Sort |
| 0666 | [Path Sum IV](./problems/0666-path-sum-iv.md) | [Go](./golang/0666_path_sum_iv.go)   | _O(n)_          | _O(w)_          | Medium         |🔒| Topological Sort |
| 0675 | [Cut Off Trees for Golf Event](./problems/0675-cut-off-trees-for-golf-event.md) | [Go](./golang/0675_cut_off_trees_for_golf_event.go)| _O(t * m * n)_ | _O(m * n)_ | Hard | | `A* Search Algorithm` |
| 0742 | [Closest Leaf in a Binary Tree](./problems/0742-closest-leaf-in-a-binary-tree.md) | [Go](./golang/0742_closest_leaf_in_a_binary_tree.go)| _O(n)_ | _O(n)_ | Medium | | |
| 0752 | [Open the Lock](./problems/0752-open-the-lock.md) | [Go](./golang/0752_open_the_lock.go)| _O(k * n^k + d)_ | _O(k * n^k + d)_ | Medium | | |
| 0773 | [Sliding Puzzle](./problems/0773-sliding-puzzle.md) | [Go](./golang/0773_sliding_puzzle.go)| _O((m * n) * (m * n)!)_ | _O((m * n) * (m * n)!)_ | Hard | | `A* Search Algorithm` |
| 0815 | [Bus Routes](./problems/0815-bus-routes.md) | [Go](./golang/0815_bus_routes.go)| _O(\|E\| + \|V\|)_ | _O(\|E\| + \|V\|)_ | Hard | | |
| 0854 | [K-Similar Strings](./problems/0854-k-similar-strings.md) | [Go](./golang/0854_k_similar_strings.go)| _O(n * n!/(c_a!*...*c_z!))_ | _O(n * n!/(c_a!*...*c_z!))_ | Hard | | |
| 0886 | [Possible Bipartition](./problems/0886-possible-bipartition.md) | [Go](./golang/0886_possible_bipartition.go)| _O(\|V\| + \|E\|)_ | _O(\|V\| + \|E\|)_ | Medium | | |
| 0913 | [Cat and Mouse](./problems/0913-cat-and-mouse.md) | [Go](./golang/0913_cat_and_mouse.go) | _O(n^3)_          | _O(n^2)_          | Hard           || MiniMax, Topological Sort |
| 0967 | [Numbers With Same Consecutive Differences](./problems/0967-numbers-with-same-consecutive-differences.md) | [Go](./golang/0967_numbers_with_same_consecutive_differences.go)| _O(2^n)_ | _O(2^n)_ | Medium | | |
| 1034 | [Coloring A Border](./problems/1034-coloring-a-border.md) | [Go](./golang/1034_coloring_a_border.go)| _O(m * n)_ | _O(m + n)_ | Medium | | |
| 1091 | [Shortest Path in Binary Matrix](./problems/1091-shortest-path-in-binary-matrix.md) | [Go](./golang/1091_shortest_path_in_binary_matrix.go)| _O(n^2)_ | _O(n)_ | Medium | | |
| 1129 | [Shortest Path with Alternating Colors](./problems/1129-shortest-path-with-alternating-colors.md) | [Go](./golang/1129_shortest_path_with_alternating_colors.go)| _O(n + e)_ | _O(n + e)_ | Medium |||
| 1136 | [Parallel Courses](./problems/1136-parallel-courses.md) | [Go](./golang/1136_parallel_courses.go)   | _O(\|V\| + \|E\|)_         | _O(\|E\|)_          | Hard         |🔒| Topological Sort |
| 1161 | [Maximum Level Sum of a Binary Tree](./problems/1161-maximum-level-sum-of-a-binary-tree.md) | [Go](./golang/1161_maximum_level_sum_of_a_binary_tree.go)| _O(n)_ | _O(w)_ | Medium | | DFS |
| 1162 | [As Far from Land as Possible](./problems/1162-as-far-from-land-as-possible.md) | [Go](./golang/1162_as_far_from_land_as_possible.go)| _O(m * n)_ | _O(m * n)_ | Medium | | |
| 1203 | [Sort Items by Groups Respecting Dependencies](./problems/1203-sort-items-by-groups-respecting-dependencies.md) | [Go](./golang/1203_sort_items_by_groups_respecting_dependencies.go)   | _O(n + e)_          | _O(n + e)_          | Hard         || Topological Sort |
| 1210 | [Minimum Moves to Reach Target with Rotations](./problems/1210-minimum-moves-to-reach-target-with-rotations.md) | [Go](./golang/1210_minimum_moves_to_reach_target_with_rotations.go)   | _O(n)_          | _O(n)_          | Hard         |||
| 1215 | [Stepping Numbers](./problems/1215-stepping-numbers.md) | [Go](./golang/1215_stepping_numbers.go)   | _O(logk + r)_          | _O(k)_          | Medium         |🔒| Precompute, Binary Search |
| 1245 | [Tree Diameter](./problems/1245-tree-diameter.md) | [Go](./golang/1245_tree_diameter.go)   | _O(\|V\| + \|E\|)_         | _O(\|E\|)_          | Medium         | variant of [Diameter of Binary Tree](https://leetcode.com/problems/diameter-of-binary-tree/) ||
| 1263 | [Minimum Moves to Move a Box to Their Target Location](./problems/1263-minimum-moves-to-move-a-box-to-their-target-location.md) | [Go](./golang/1263_minimum_moves_to_move_a_box_to_their_target_location.go)| _O(m^2 * n^2)_ | _O(m^2 * n^2)_ | Hard | | `A* Search Algorithm` |
| 1284 | [Minimum Number of Flips to Convert Binary Matrix to Zero Matrix](./problems/1284-minimum-number-of-flips-to-convert-binary-matrix-to-zero-matrix.md) | [Go](./golang/1284_minimum_number_of_flips_to_convert_binary_matrix_to_zero_matrix.go)   | _O((m * n) * 2^(m * n))_         | _O((m * n) * 2^(m * n))_          | Hard         |||
| 1291 | [Sequential Digits](./problems/1291-sequential-digits.md) | [Go](./golang/1291_sequential_digits.go)| _O(1)_ | _O(1)_ | Medium | | |
| 1293 | [Shortest Path in a Grid with Obstacles Elimination](./problems/1293-shortest-path-in-a-grid-with-obstacles-elimination.md) | [Go](./golang/1293_shortest_path_in_a_grid_with_obstacles_elimination.go)| _O(m * n * k)_ | _O(m * n)_ | Hard | | `A* Search Algorithm` |
| 1298 | [Maximum Candies You Can Get from Boxes](./problems/1298-maximum-candies-you-can-get-from-boxes.md) | [Go](./golang/1298_maximum_candies_you_can_get_from_boxes.go)| _O(n^2)_ | _O(n)_ | Hard | | |
| 1302 | [Deepest Leaves Sum](./problems/1302-deepest-leaves-sum.md) | [Go](./golang/1302_deepest_leaves_sum.go)| _O(n)_ | _O(w)_ | Medium | | |
| 1306 | [Jump Game III](./problems/1306-jump-game-iii.md) | [Go](./golang/1306_jump_game_iii.go)| _O(n)_ | _O(n)_ | Medium | | |
| 1311 | [Get Watched Videos by Your Friends](./problems/1311-get-watched-videos-by-your-friends.md) | [Go](./golang/1311_get_watched_videos_by_your_friends.go)| _O(n + vlogv)_ | _O(w)_ | Medium | | |
| 1345 | [Jump Game IV](./problems/1345-jump-game-iv.md) | [Go](./golang/1345_jump_game_iv.go)| _O(n)_ | _O(n)_ | Hard | | |
| 1368 | [Minimum Cost to Make at Least One Valid Path in a Grid](./problems/1368-minimum-cost-to-make-at-least-one-valid-path-in-a-grid.md) | [Go](./golang/1368_minimum_cost_to_make_at_least_one_valid_path_in_a_grid.go)| _O(m * n)_ | _O(m * n)_ | Hard | | `A* Search Algorithm`, 0-1 BFS, Deque |
| 1602 | [Find Nearest Right Node in Binary Tree](./problems/1602-find-nearest-right-node-in-binary-tree.md) | [Go](./golang/1602_find_nearest_right_node_in_binary_tree.go)| _O(n)_ | _O(w)_ | Medium |🔒| 
| 1609 | [Even Odd Tree](./problems/1609-even-odd-tree.md) | [Go](./golang/1609_even_odd_tree.go)| _O(n)_ | _O(w)_ | Medium || 
| 1625 | [Lexicographically Smallest String After Applying Operations](./problems/1625-lexicographically-smallest-string-after-applying-operations.md) | [Go](./golang/1625_lexicographically_smallest_string_after_applying_operations.go)| _O(n^2)_ | _O(1)_ | Medium || BFS, String 
| 1654 | [Minimum Jumps to Reach Home](./problems/1654-minimum-jumps-to-reach-home.md) | [Go](./golang/1654_minimum_jumps_to_reach_home.go)| _O(max(x, max(forbidden)) + a + b)_ | _O(max(x, max(forbidden)) + a + b)_ | Medium || BFS 
| 1660 | [Correct a Binary Tree](./problems/1660-correct-a-binary-tree.md) | [Go](./golang/1660_correct_a_binary_tree.go)| _O(n)_ | _O(w)_ | Medium |🔒| BFS 
| 1728 | [Cat and Mouse II](./problems/1728-cat-and-mouse-ii.md) | [Go](./golang/1728_cat_and_mouse_ii.go) | _O((m * n)^2 * (m + n))_          | _O((m * n)^2)_          | Hard           | variant of [Cat and Mouse](https://leetcode.com/problems/cat-and-mouse/) | MiniMax, Topological Sort |
| 1730 | [Shortest Path to Get Food](./problems/1730-shortest-path-to-get-food.md) | [Go](./golang/1730_shortest_path_to_get_food.go)| _O(m * n)_ | _O(m + n)_ | Medium |🔒| BFS 
| 1765 | [Map of Highest Peak](./problems/1765-map-of-highest-peak.md) | [Go](./golang/1765_map_of_highest_peak.go)| _O(m * n)_ | _O(m * n)_ | Medium | | BFS 
| 2039 | [The Time When the Network Becomes Idle](./problems/2039-the-time-when-the-network-becomes-idle.md) | [Go](./golang/2039_the_time_when_the_network_becomes_idle.go)| _O(\|E\|)_ | _O(\|E\|)_ | Medium | | Math |
| 2045 | [Second Minimum Time to Reach Destination](./problems/2045-second-minimum-time-to-reach-destination.md) | [Go](./golang/2045_second_minimum_time_to_reach_destination.go)| _O(\|E\|)_ | _O(\|E\|)_ | Hard | | Bi-BFS |
| 2050 | [Parallel Courses III](./problems/2050-parallel-courses-iii.md) | [Go](./golang/2050_parallel_courses_iii.go)   | _O(\|V\| + \|E\|)_         | _O(\|E\|)_          | Hard         | variant of [Parallel Courses](https://leetcode.com/problems/parallel-courses/) | Topological Sort |
| 2059 | [Minimum Operations to Convert Number](./problems/2059-minimum-operations-to-convert-number.md) | [Go](./golang/2059_minimum_operations_to_convert_number.go)| _O(m * n)_ | _O(m)_ | Medium | | |
| 2115 | [Find All Possible Recipes from Given Supplies](./problems/2115-find-all-possible-recipes-from-given-supplies.md) | [Go](./golang/2115_find_all_possible_recipes_from_given_supplies.go)   | _O(\|E\|)_         | _O(\|E\|)_          | Medium         | | Topological Sort |
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

## Graph

### 1. Union Find

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0399 | [Evaluate Division](./problems/0399-evaluate-division.md) | [Go](./golang/0399_evaluate_division.go)  | _O(e + q)_ | _O(n)_ | Medium         || `Floyd-Warshall Algorithm`, BFS, Union Find|
| 0924 | [Minimize Malware Spread](./problems/0924-minimize-malware-spread.md) | [Go](./golang/0924_minimize_malware_spread.go) | _O(n^2)_| _O(n)_| Hard           || Union Find | 
| 0928 | [Minimize Malware Spread II](./problems/0928-minimize-malware-spread-ii.md) | [Go](./golang/0928_minimize_malware_spread_ii.go) | _O(n^2)_| _O(n)_| Hard           || Union Find | 
| 0959 | [Regions Cut By Slashes](./problems/0959-regions-cut-by-slashes.md) | [Go](./golang/0959_regions_cut_by_slashes.go) | _O(n^2)_| _O(n^2)_| Medium           || Union Find | 
| 0990 | [Satisfiability of Equality Equations](./problems/0990-satisfiability-of-equality-equations.md) | [Go](./golang/0990_satisfiability_of_equality_equations.go) | _O(n)_ | _O(1)_ | Medium           || Union Find |
| 1101 | [The Earliest Moment When Everyone Become Friends](./problems/1101-the-earliest-moment-when-everyone-become-friends.md) | [Go](./golang/1101_the_earliest_moment_when_everyone_become_friends.go) | _O(nlogn)_ | _O(n)_ | Medium           |🔒| Union Find |
| 1135 | [Connecting Cities With Minimum Cost](./problems/1135-connecting-cities-with-minimum-cost.md) | [Go](./golang/1135_connecting_cities_with_minimum_cost.go) | _O(nlogn)_ | _O(n)_ | Medium           |🔒| Union Find, `Kruskal's Algorithm`, MST |
| 1168 | [Optimize Water Distribution in a Village](./problems/1168-optimize-water-distribution-in-a-village.md) | [Go](./golang/1168_optimize_water_distribution_in_a_village.go) | _O(nlogn)_ | _O(n)_ | Hard           |🔒| Union Find |
| 1568 | [Minimum Number of Days to Disconnect Island](./problems/1568-minimum-number-of-days-to-disconnect-island.md) | [Go](./golang/1568_minimum_number_of_days_to_disconnect_island.go) | _O(m * n)_    | _O(m * n)_          | Medium           || DFS, Persistent Union Find, `Tarjan's Algorithm`, Articulation Points
| 1579 | [Remove Max Number of Edges to Keep Graph Fully Traversable](./problems/1579-remove-max-number-of-edges-to-keep-graph-fully-traversable.md) | [Go](./golang/1579_remove_max_number_of_edges_to_keep_graph_fully_traversable.go) | _O(n + m)_| _O(n)_| Hard           || Union Find | 
| 1584 | [Min Cost to Connect All Points](./problems/1584-min-cost-to-connect-all-points.md) | [Go](./golang/1584_min_cost_to_connect_all_points.go) | _O(n^2)_| _O(n)_| Medium           || Union Find, `Kruskal's Algorithm`, MST | 
| 1627 | [Graph Connectivity With Threshold](./problems/1627-graph-connectivity-with-threshold.md) | [Go](./golang/1627_graph_connectivity_with_threshold.go) | _O(nlogn + q)_| _O(n)_| Hard           || Union Find, Math | 
| 1631 | [Path With Minimum Effort](./problems/1631-path-with-minimum-effort.md) | [Go](./golang/1631_path_with_minimum_effort.go) | _O(m * n * log(m * n))_| _O(m * n)_| Medium           || Binary Search, DFS, BFS, Bi-BFS, Union Find, `Dijkstra's Algorithm` | 
| 1697 | [Checking Existence of Edge Length Limited Paths](./problems/1697-checking-existence-of-edge-length-limited-paths.md) | [Go](./golang/1697_checking_existence_of_edge_length_limited_paths.go) | _O(nlogn + mlogm)_| _O(n)_| Hard           || Union Find | 
| 1724 | [Checking Existence of Edge Length Limited Paths II](./problems/1724-checking-existence-of-edge-length-limited-paths-ii.md) | [Go](./golang/1724_checking_existence_of_edge_length_limited_paths_ii.go) | ctor: _O(nlogn + mlogm)_<br>query: _O(logn)_ | _O(nlogn + m)_| Hard           |🔒| Versioned Union Find, Binary Lifting | 
| 2076 | [Process Restricted Friend Requests](./problems/2076-process-restricted-friend-requests.md) | [Go](./golang/2076_process_restricted_friend_requests.go) | _O(n * r)_ | _O(n)_ | Hard | | Union Find |
| 2092 | [Find All People With Secret](./problems/2092-find-all-people-with-secret.md) | [Go](./golang/2092_find_all_people_with_secret.go) | _O(nlogn)_ | _O(nlogn)_ | Hard | | BFS, DFS, Union Find |
| 2307 | [Check for Contradictions in Equations](./problems/2307-check-for-contradictions-in-equations.md) | [Go](./golang/2307_check_for_contradictions_in_equations.go)  | _O(e + q)_ | _O(n)_ | Hard         | 🔒, variant of [Evaluate Division](https://leetcode.com/problems/evaluate-division/) | DFS, Union Find|

---

### 2. Path / Euler

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0332 | [Reconstruct Itinerary](./problems/0332-reconstruct-itinerary.md) | [Go](./golang/0332_reconstruct_itinerary.go)  | _O(\|V\| + \|E\|log\|V\|)_ | _O(\|V\| + \|E\|)_ | Medium         || `Hierholzer's Algorithm`, Eulerian Path |
| 2097 | [Valid Arrangement of Pairs](./problems/2097-valid-arrangement-of-pairs.md) | [Go](./golang/2097_valid_arrangement_of_pairs.go)  |  _O(\|V\| + \|E\|)_ | _O(\|V\| + \|E\|)_ | Hard | variant of [Reconstruct Itinerary](https://leetcode.com/problems/reconstruct-itinerary/) | `Hierholzer's Algorithm`, Eulerian Path |

---

### 3. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0765 | [Couples Holding Hands](./problems/0765-couples-holding-hands.md) | [Go](./golang/0765_couples_holding_hands.go) | _O(n)_| _O(n)_| Hard           ||| 
| 1042 | [Flower Planting With No Adjacent](./problems/1042-flower-planting-with-no-adjacent.md) | [Go](./golang/1042_flower_planting_with_no_adjacent.go) | _O(n)_ | _O(n)_ | Easy           |||
| 1334 | [Find the City With the Smallest Number of Neighbors at a Threshold Distance](./problems/1334-find-the-city-with-the-smallest-number-of-neighbors-at-a-threshold-distance.md) | [Go](./golang/1334_find_the_city_with_the_smallest_number_of_neighbors_at_a_threshold_distance.go) | _O(n^3)_ | _O(n^2)_ | Medium           || `Floyd-Warshall Algorithm`|
| 1349 | [Maximum Students Taking Exam](./problems/1349-maximum-students-taking-exam.md) | [Go](./golang/1349_maximum_students_taking_exam.go) | _O(m * n * sqrt(m * n))_ | _O(m + n)_ | Hard | [GCJ2008 - Round 3](https://codingcompetitions.withgoogle.com/codejam/round/00000000004329f5/000000000043314f) | `Hopcroft-Karp Bipartite Matching`, `Hungarian Bipartite Matching`, Maximum Independent Set |
| 1361 | [Validate Binary Tree Nodes](./problems/1361-validate-binary-tree-nodes.md) | [Go](./golang/1361_validate_binary_tree_nodes.go) | _O(n)_| _O(n)_| Medium           || DFS, Tree | 
| 1462 | [Course Schedule IV](./problems/1462-course-schedule-iv.md) | [Go](./golang/1462_course_schedule_iv.go) | _O(n^3)_| _O(n^2)_| Medium           || `Floyd-Warshall Algorithm` |
| 1489 | [Find Critical and Pseudo-Critical Edges in Minimum Spanning Tree](./problems/1489-find-critical-and-pseudo-critical-edges-in-minimum-spanning-tree.md) | [Go](./golang/1489_find_critical_and_pseudo_critical_edges_in_minimum_spanning_tree.go) | _O(nlogn)_| _O(n)_| Hard           || `Kruskal Algorithm` |
| 1557 | [Minimum Number of Vertices to Reach All Nodes](./problems/1557-minimum-number-of-vertices-to-reach-all-nodes.md) | [Go](./golang/1557_minimum_number_of_vertices_to_reach_all_nodes.go) | _O(e)_| _O(n)_| Medium           ||| 
| 1601 | [Maximum Number of Achievable Transfer Requests](./problems/1601-maximum-number-of-achievable-transfer-requests.md) | [Go](./golang/1601_maximum_number_of_achievable_transfer_requests.go) | _O((n + r) * 2^r)_| _O(n + r)_| Hard           || Combinations, Backtracking | 
| 1615 | [Maximal Network Rank](./problems/1615-maximal-network-rank.md) | [Go](./golang/1615_maximal_network_rank.go) | _O(m + n + k^2)_ | _O(m + n)_ | Medium           || Counting Sort | 
| 1719 | [Number Of Ways To Reconstruct A Tree](./problems/1719-number-of-ways-to-reconstruct-a-tree.md) | [Go](./golang/1719_number_of_ways_to_reconstruct_a_tree.go) | _O(nlogn)_| _O(n)_| Hard           ||| 
| 1743 | [Restore the Array From Adjacent Pairs](./problems/1743-restore-the-array-from-adjacent-pairs.md) | [Go](./golang/1743_restore_the_array_from_adjacent_pairs.go) | _O(n)_| _O(n)_| Medium           ||| 
| 1761 | [Minimum Degree of a Connected Trio in a Graph](./problems/1761-minimum-degree-of-a-connected-trio-in-a-graph.md) | [Go](./golang/1761_minimum_degree_of_a_connected_trio_in_a_graph.go) | _O(n^3)_| _O(n^2)_| Hard           ||| 
| 1778 | [Shortest Path in a Hidden Grid](./problems/1778-shortest-path-in-a-hidden-grid.md) | [Go](./golang/1778_shortest_path_in_a_hidden_grid.go) | _O(m * n)_ | _O(m * n)_| Medium           |🔒| DFS, BFS, Bi-BFS | 
| 1782 | [Count Pairs Of Nodes](./problems/1782-count-pairs-of-nodes.md) | [Go](./golang/1782_count_pairs_of_nodes.go) | _O(n + e + q)_ | _O(n + e)_| Hard           || Counting, Two Pointers | 
| 1786 | [Number of Restricted Paths From First to Last Node](./problems/1786-number-of-restricted-paths-from-first-to-last-node.md) | [Go](./golang/1786_number_of_restricted_paths_from_first_to_last_node.go) | _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Medium | | `Dijkstra's Algorithm`, DP |
| 1791 | [Find Center of Star Graph](./problems/1791-find-center-of-star-graph.md) | [Go](./golang/1791_find_center_of_star_graph.go) | _O(n)_| _O(n)_| Medium           ||| 
| 1810 | [Minimum Path Cost in a Hidden Grid](./problems/1810-minimum-path-cost-in-a-hidden-grid.md) | [Go](./golang/1810_minimum_path_cost_in_a_hidden_grid.go) | _O(m * n * log(m * n))_ | _O(m * n)_| Medium           |🔒| DFS, `Dijkstra's Algorithm`| 
| 1820 | [Maximum Number of Accepted Invitations](./problems/1820-maximum-number-of-accepted-invitations.md) | [Go](./golang/1820_maximum_number_of_accepted_invitations.go) | _O(m * n * sqrt(m + n))_ | _O(m + n)_ | Medium | 🔒 | `Hopcroft-Karp Bipartite Matching`, `Hungarian Bipartite Matching` |
| 1879 | [Minimum XOR Sum of Two Arrays](./problems/1879-minimum-xor-sum-of-two-arrays.md) | [Go](./golang/1879_minimum_xor_sum_of_two_arrays.go) | _O(n^3)_ | _O(n^2)_ | Hard | | DP, `Hungarian Weighted Bipartite Matching` |
| 1947 | [Maximum Compatibility Score Sum](./problems/1947-maximum-compatibility-score-sum.md) | [Go](./golang/1947_maximum_compatibility_score_sum.go) | _O(m^2 * (n + m))_ | _O(m^2)_ | Medium | variant of [Minimum XOR Sum of Two Arrays](https://leetcode.com/problems/minimum-xor-sum-of-two-arrays/) | DP, `Hungarian Weighted Bipartite Matching` |
| 1971 | [Find if Path Exists in Graph](./problems/1971-find-if-path-exists-in-graph.md) | [Go](./golang/1971_find_if_path_exists_in_graph.go) | _O(\|V\| + \|E\|)_| _O(\|V\| + \|E\|)_| Easy           || DFS, BFS, Bi-BFS| 
| 1976 | [Number of Ways to Arrive at Destination](./problems/1976-number-of-ways-to-arrive-at-destination.md) | [Go](./golang/1976_number_of_ways_to_arrive_at_destination.go) | _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Medium | | `Dijkstra's Algorithm` |
| 2077 | [Paths in Maze That Lead to Same Room](./problems/2077-paths-in-maze-that-lead-to-same-room.md) | [Go](./golang/2077_paths_in_maze_that_lead_to_same_room.go) | _O(\|V\|^3)_ | _O(\|E\|)_ | Medium | 🔒 | |
| 2093 | [Minimum Path Cost in a Hidden Grid](./problems/2093-minimum-cost-to-reach-city-with-discounts.md) | [Go](./golang/2093_minimum_cost_to_reach_city_with_discounts.go) | _O(\|E\| * log\|V\|)_ | _O(\|V\| + \|E\|)_ | Medium           | variant of [Cheapest Flights Within K Stops](https://leetcode.com/problems/cheapest-flights-within-k-stops/), 🔒 | `Dijkstra's Algorithm`, DP | 
| 2123 | [Minimum Operations to Remove Adjacent Ones in Matrix](./problems/2123-minimum-operations-to-remove-adjacent-ones-in-matrix.md) | [Go](./golang/2123_minimum_operations_to_remove_adjacent_ones_in_matrix.go) | _O(m * n * sqrt(m * n))_ | _O(m + n)_ | Hard | variant of [Maximum Students Taking Exam](https://leetcode.com/problems/maximum-students-taking-exam/), 🔒 | `Hopcroft-Karp Bipartite Matching`, Maximum Independent Set |
| 2127 | [Maximum Employees to Be Invited to a Meeting](./problems/2127-maximum-employees-to-be-invited-to-a-meeting.md) | [Go](./golang/2127_maximum_employees_to_be_invited_to_a_meeting.go) | _O(n)_ | _O(n)_ | Hard |  |  |
| 2172 | [Maximum AND Sum of Array](./problems/2172-maximum-and-sum-of-array.md) | [Go](./golang/2172_maximum_and_sum_of_array.go) | _O(n^3)_ | _O(n^2)_ | Hard | variant of [Maximum Compatibility Score Sum](https://leetcode.com/problems/maximum-compatibility-score-sum/) | DP, `Hungarian Weighted Bipartite Matching` |
| 2203 | [Minimum Weighted Subgraph With the Required Paths](./problems/2203-minimum-weighted-subgraph-with-the-required-paths.md) | [Go](./golang/2203_minimum_weighted_subgraph_with_the_required_paths.go)| _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Hard | | `Dijkstra's Algorithm` |
| 2204 | [Distance to a Cycle in Undirected Graph](./problems/2204-distance-to-a-cycle-in-undirected-graph.md) | [Go](./golang/2204_distance_to_a_cycle_in_undirected_graph.go) | _O(\|V\| + \|E\|)_ | _O(\|V\| + \|E\|)_ | Hard | 🔒 | Graph, DFS, BFS |
| 2242 | [Maximum Score of a Node Sequence](./problems/2242-maximum-score-of-a-node-sequence.md) | [Go](./golang/2242_maximum_score_of_a_node_sequence.go) | _O(\|V\| + \|E\|)_ | _O(\|V\|)_ | Hard | | Graph |
| 2359 | [Find Closest Node to Given Two Nodes](./problems/2359-find-closest-node-to-given-two-nodes.md) | [Go](./golang/2359_find_closest_node_to_given_two_nodes.go)  | _O(n)_ | _O(n)_ | Medium         | | Graph, Hash Table, DFS |
| 2360 | [Longest Cycle in a Graph](./problems/2360-longest-cycle-in-a-graph.md) | [Go](./golang/2360_longest_cycle_in_a_graph.go)  | _O(n)_ | _O(n)_ | Hard         | | Graph, Hash Table, DFS |
| 2392 | [Build a Matrix With Conditions](./problems/2392-build-a-matrix-with-conditions.md) | [Go](./golang/2392_build_a_matrix_with_conditions.go)  | _O(k^2 + r + c)_ | _O(k + r + c)_ | Hard         | | Graph, Topological Sort |
| 2473 | [Minimum Cost to Buy Apples](./problems/2473-minimum-cost-to-buy-apples.md) | [Go](./golang/2473_minimum_cost_to_buy_apples.go) | _O(n * rlogn)_ | _O(n)_| Medium           |🔒| `Dijkstra's Algorithm`| 
| 2508 | [Add Edges to Make Degrees of All Nodes Even](./problems/2508-add-edges-to-make-degrees-of-all-nodes-even.md) | [Go](./golang/2508_add_edges_to_make_degrees_of_all_nodes_even.go) | _O(n)_ | _O(n)_| Hard           || Graph | 
| 2608 | [Shortest Cycle in a Graph](./problems/2608-shortest-cycle-in-a-graph.md) | [Go](./golang/2608_shortest_cycle_in_a_graph.go) | _O(n^2)_ | _O(n + e)_| Hard           || Graph, BFS |
| 2662 | [Minimum Cost of a Path With Special Roads](./problems/2662-minimum-cost-of-a-path-with-special-roads.md) | [Go](./golang/2662_minimum_cost_of_a_path_with_special_roads.go) | _O(n^2)_ | _O(n^2)_| Medium           || Graph, `Dijkstra's Algorithm` |
| 2699 | [Modify Graph Edge Weights](./problems/2699-modify-graph-edge-weights.md) | [Go](./golang/2699_modify_graph_edge_weights.go) |  _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Hard           || Graph, `Dijkstra's Algorithm` |
| 2714 | [Find Shortest Path with K Hops](./problems/2714-find-shortest-path-with-k-hops.md) | [Go](./golang/2714_find_shortest_path_with_k_hops.go) |  _O(n * k + (k * e) * log(n * k))_ | _O(n * k + e)_ | Hard           |🔒| Graph, `Dijkstra's Algorithm` |
| 2737 | [Find the Closest Marked Node](./problems/2737-find-the-closest-marked-node.md) | [Go](./golang/2737_find_the_closest_marked_node.go) |  _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Medium           |🔒| Graph, `Dijkstra's Algorithm` |
| 2836 | [Maximize Value of Function in a Ball Passing Game](./problems/2836-maximize-value-of-function-in-a-ball-passing-game.md) | [Go](./golang/2836_maximize_value_of_function_in_a_ball_passing_game.go) | _O(n)_ | _O(n)_| Hard           || Graph, Prefix Sum, Two Pointers, Sliding Window, Binary Lifting |
| 2850 | [Minimum Moves to Spread Stones Over Grid](./problems/2850-minimum-moves-to-spread-stones-over-grid.md) | [Go](./golang/2850_minimum_moves_to_spread_stones_over_grid.go) | _O(n^3)_ | _O(n^2)_ | Medium | | Backtracking, `Hungarian Weighted Bipartite Matching` |
| 2876 | [Count Visited Nodes in a Directed Graph](./problems/2876-count-visited-nodes-in-a-directed-graph.md) | [Go](./golang/2876_count_visited_nodes_in_a_directed_graph.go) | _O(n)_ | _O(n)_ | Hard | | Graph, Hash Table, Stack |
| 2924 | [Find Champion II](./problems/2924-find-champion-ii.md) | [Go](./golang/2924_find_champion_ii.go) | _O(n)_ | _O(n)_ | Medium | | Graph, Hash Table
| 2959 | [Number of Possible Sets of Closing Branches](./problems/2959-number-of-possible-sets-of-closing-branches.md) | [Go](./golang/2959_number_of_possible_sets_of_closing_branches.go) | _O(r + 2^n * n^2)_ | _O(n^3)_ | Medium | | Graph, Bitmasks, `Floyd-Warshall Algorithm`, Backtracking

## Stack

### 1. Parentheses & Valid

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0020 | [Valid Parentheses](./problems/0020-valid-parentheses.md) | [Go](./golang/0020_valid_parentheses.go) | _O(n)_        | _O(n)_          | Easy           ||
| 0032 | [Longest Valid Parentheses](./problems/0032-longest-valid-parentheses.md) | [Go](./golang/0032_longest_valid_parentheses.go) | _O(n)_ | _O(1)_ | Hard   ||
| 0394 | [Decode String](./problems/0394-decode-string.md) | [Go](./golang/0394_decode_string.go) | _O(n)_        | _O(n)_          | Medium           |||
| 0856 | [Score of Parentheses](./problems/0856-score-of-parentheses.md) | [Go](./golang/0856_score_of_parentheses.go) | _O(n)_  | _O(1)_         | Medium           ||
| 0921 | [Minimum Add to Make Parentheses Valid](./problems/0921-minimum-add-to-make-parentheses-valid.md) | [Go](./golang/0921_minimum_add_to_make_parentheses_valid.go) | _O(n)_ | _O(1)_      | Medium         ||
| 1021 | [Remove Outermost Parentheses](./problems/1021-remove-outermost-parentheses.md) | [Go](./golang/1021_remove_outermost_parentheses.go) | _O(n)_ | _O(1)_      | Easy         ||
| 1190 | [Reverse Substrings Between Each Pair of Parentheses](./problems/1190-reverse-substrings-between-each-pair-of-parentheses.md) | [Go](./golang/1190_reverse_substrings_between_each_pair_of_parentheses.go)| _O(n)_ | _O(n)_         | Medium           ||
| 1541 | [Minimum Insertions to Balance a Parentheses String](./problems/1541-minimum-insertions-to-balance-a-parentheses-string.md) | [Go](./golang/1541_minimum_insertions_to_balance_a_parentheses_string.go) | _O(n)_ | _O(1)_      | Medium         ||

---

### 2. Monotonic Stack

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0084 | [Largest Rectangle in Histogram](./problems/0084-largest-rectangle-in-histogram.md) | [Go](./golang/0084_largest_rectangle_in_histogram.go) | _O(n)_ | _O(n)_ | Hard || Mono Stack, DP
| 0085 | [Maximal Rectangle](./problems/0085-maximal-rectangle.md) | [Go](./golang/0085_maximal_rectangle.go)| _O(m * n)_ | _O(n)_         | Hard           | EPI | Mono Stack
| 0496 | [Next Greater Element I](./problems/0496-next-greater-element-i.md) | [Go](./golang/0496_next_greater_element_i.go) | _O(m + n)_       | _O(m + n)_          | Easy         || Mono Stack |
| 0739 | [Daily Temperatures](./problems/0739-daily-temperatures.md) | [Go](./golang/0739_daily_temperatures.go) | _O(n)_  | _O(n)_         | Medium           ||
| 1019 | [Next Greater Node In Linked List](./problems/1019-next-greater-node-in-linked-list.md) | [Go](./golang/1019_next_greater_node_in_linked_list.go) | _O(n)_  | _O(n)_         | Medium           || Mono Stack
| 1063 | [Number of Valid Subarrays](./problems/1063-number-of-valid-subarrays.md) | [Go](./golang/1063_number_of_valid_subarrays.go)| _O(n)_ | _O(n)_         | Hard           | 🔒 | Mono Stack
| 1130 | [Minimum Cost Tree From Leaf Values](./problems/1130-minimum-cost-tree-from-leaf-values.md) | [Go](./golang/1130_minimum_cost_tree_from_leaf_values.go)| _O(n)_ | _O(n)_         | Medium           || Mono Stack
| 1856 | [Maximum Subarray Min-Product](./problems/1856-maximum-subarray-min-product.md) | [Go](./golang/1856_maximum_subarray_min_product.go) | _O(n)_ | _O(n)_ | Medium | variant of [Largest Rectangle in Histogram](https://leetcode.com/problems/largest-rectangle-in-histogram/) | Mono Stack, Prefix Sum
| 1944 | [Number of Visible People in a Queue](./problems/1944-number-of-visible-people-in-a-queue.md) | [Go](./golang/1944_number_of_visible_people_in_a_queue.go) | _O(n)_  | _O(n)_         | Hard           | variant of [Buildings With an Ocean View](https://leetcode.com/problems/buildings-with-an-ocean-view/) | Mono Stack
| 1950 | [Maximum of Minimum Values in All Subarrays](./problems/1950-maximum-of-minimum-values-in-all-subarrays.md) | [Go](./golang/1950_maximum_of_minimum_values_in_all_subarrays.go) | _O(n)_  | _O(n)_         | Medium           | 🔒 | Mono Stack
| 2104 | [Sum of Subarray Ranges](./problems/2104-sum-of-subarray-ranges.md) | [Go](./golang/2104_sum_of_subarray_ranges.go) | _O(n)_ | _O(n)_ | Medium | | Mono Stack
| 2281 | [Sum of Total Strength of Wizards](./problems/2281-sum-of-total-strength-of-wizards.md) | [Go](./golang/2281_sum_of_total_strength_of_wizards.go) | _O(n)_ | _O(n)_ | Hard | variant of [Largest Rectangle in Histogram](https://leetcode.com/problems/largest-rectangle-in-histogram/) | Mono Stack, Prefix Sum
| 2282 | [Number of People That Can Be Seen in a Grid](./problems/2282-number-of-people-that-can-be-seen-in-a-grid.md) | [Go](./golang/2282_number_of_people_that_can_be_seen_in_a_grid.go) | _O(m * n)_  | _O(m + n)_         | Medium           | 🔒, variant of [Number of Visible People in a Queue](https://leetcode.com/problems/number-of-visible-people-in-a-queue/) | Mono Stack
| 2334 | [Subarray With Elements Greater Than Varying Threshold](./problems/2334-subarray-with-elements-greater-than-varying-threshold.md) | [Go](./golang/2334_subarray_with_elements_greater_than_varying_threshold.go) | _O(n)_ | _O(n)_ | Hard | variant of [Maximum Subarray Min-Product](https://leetcode.com/problems/maximum-subarray-min-product/) | Mono Stack
| 2355 | [Maximum Number of Books You Can Take](./problems/2355-maximum-number-of-books-you-can-take.md) | [Go](./golang/2355_maximum_number_of_books_you_can_take.go) | _O(n)_  | _O(n)_         | Hard           | 🔒 | Mono Stack, Math
| 2454 | [Next Greater Element IV](./problems/2454-next-greater-element-iv.md) | [Go](./golang/2454_next_greater_element_iv.go) | _O(n)_ | _O(n)_ | Hard | | Mono Stack
| 2735 | [Collecting Chocolates](./problems/2735-collecting-chocolates.md) | [Go](./golang/2735_collecting_chocolates.go) | _O(n)_ | _O(n)_ | Medium | | Mono Stack, Difference Array, Prefix Sum, Binary Search, Mono Deque, Brute Force
| 2736 | [Maximum Sum Queries](./problems/2736-maximum-sum-queries.md) | [Go](./golang/2736_maximum_sum_queries.go) | _O(nlogn + mlogm + mlogn)_ | _O(n + m)_ | Hard | | Sort, Mono Stack, Binary Search
| 2832 | [Maximal Range That Each Element Is Maximum in It](./problems/2832-maximal-range-that-each-element-is-maximum-in-it.md) | [Go](./golang/2832_maximal_range_that_each_element_is_maximum_in_it.go) | _O(n)_ | _O(n)_ | Medium | 🔒 | Mono Stack
| 2863 | [Maximum Length of Semi-Decreasing Subarrays](./problems/2863-maximum-length-of-semi-decreasing-subarrays.md) | [Go](./golang/2863_maximum_length_of_semi_decreasing_subarrays.go) | _O(n)_ | _O(n)_ | Medium | 🔒 | Sort, Mono Stack
| 2865 | [Beautiful Towers I](./problems/2865-beautiful-towers-i.md) | [Go](./golang/2865_beautiful_towers_i.go) | _O(n)_ | _O(n)_ | Medium | | Mono Stack
| 2866 | [Beautiful Towers II](./problems/2866-beautiful-towers-ii.md) | [Go](./golang/2866_beautiful_towers_ii.go) | _O(n)_ | _O(n)_ | Medium | | Mono Stack

---

### 3. Calculator & Eval

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0150 | [Evaluate Reverse Polish Notation](./problems/0150-evaluate-reverse-polish-notation.md) | [Go](./golang/0150_evaluate_reverse_polish_notation.go)| _O(n)_| _O(n)_| Medium          ||
| 0224 | [Basic Calculator](./problems/0224-basic-calculator.md) | [Go](./golang/0224_basic_calculator.go) | _O(n)_| _O(n)_| Hard || 
| 0227 | [Basic Calculator II](./problems/0227-basic-calculator-ii.md) | [Go](./golang/0227_basic_calculator_ii.go) | _O(n)_| _O(n)_| Medium || 
| 0770 | [Basic Calculator IV](./problems/0770-basic-calculator-iv.md) | [Go](./golang/0770_basic_calculator_iv.go) | add: _O(d * t)_<br> sub: _O(d * t)_<br> mul: _O(d * t^2)_<br> eval: _O(d * t)_ <br> to_list: _O(d * tlogt)_  | _O(e + d * t)_ | Hard           ||
| 0772 | [Basic Calculator III](./problems/0772-basic-calculator-iii.md) | [Go](./golang/0772_basic_calculator_iii.go) | _O(n)_  | _O(n)_         | Hard           ||
| 1597 | [Build Binary Expression Tree From Infix Expression](./problems/1597-build-binary-expression-tree-from-infix-expression.md) | [Go](./golang/1597_build_binary_expression_tree_from_infix_expression.go) | _O(n)_  | _O(n)_         | Medium           | 🔒, variant of [Basic Calculator III](https://leetcode.com/problems/basic-calculator-iii/) |

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0071 | [Simplify Path](./problems/0071-simplify-path.md) | [Go](./golang/0071_simplify_path.go) | _O(n)_        | _O(n)_          | Medium         ||
| 0101 | [Symmetric Tree](./problems/0101-symmetric-tree.md) | [Go](./golang/0101_symmetric_tree.go) | _O(n)_      | _O(h)_          | Easy           ||
| 0155 | [Min Stack](./problems/0155-min-stack.md) | [Go](./golang/0155_min_stack.go)  | _O(n)_          | _O(1)_          | Easy           ||
| 0232 | [Implement Queue using Stacks](./problems/0232-implement-queue-using-stacks.md) | [Go](./golang/0232_implement_queue_using_stacks.go) | _O(1), amortized_| _O(n)_| Easy | EPI, LintCode | 
| 0255 | [Verify Preorder Sequence in Binary Search Tree](./problems/0255-verify-preorder-sequence-in-binary-search-tree.md) | [Go](./golang/0255_verify_preorder_sequence_in_binary_search_tree.go) | _O(n)_| _O(1)_| Medium |🔒||
| 0272 | [Closest Binary Search Tree Value II](./problems/0272-closest-binary-search-tree-value-ii.md) | [Go](./golang/0272_closest_binary_search_tree_value_ii.go) | _O(h + k)_| _O(h)_| Hard |🔒||
| 0331 | [Verify Preorder Serialization of a Binary Tree](./problems/0331-verify-preorder-serialization-of-a-binary-tree.md) | [Go](./golang/0331_verify_preorder_serialization_of_a_binary_tree.go) | _O(n)_| _O(1)_| Medium |||
| 0341 | [Flatten Nested List Iterator](./problems/0341-flatten-nested-list-iterator.md) | [Go](./golang/0341_flatten_nested_list_iterator.go) | _O(n)_        | _O(h)_          | Medium           |🔒| Iterator |
| 0385 | [Mini Parser](./problems/0385-mini-parser.md) | [Go](./golang/0385_mini_parser.go) | _O(n)_        | _O(h)_          | Medium           |||
| 0439 | [Ternary Expression Parser](./problems/0439-ternary-expression-parser.md) | [Go](./golang/0439_ternary_expression_parser.go) | _O(n)_          | _O(1)_          | Medium           |🔒|
| 0456 | [132 Pattern](./problems/0456-132-pattern.md) | [Go](./golang/0456_132_pattern.go) | _O(n)_          | _O(n)_          | Medium           ||
| 0636 | [Exclusive Time of Functions](./problems/0636-exclusive-time-of-functions.md) | [Go](./golang/0636_exclusive_time_of_functions.go) | _O(n)_  | _O(n)_         | Medium           ||
| 0682 | [Baseball Game](./problems/0682-baseball-game.md) | [Go](./golang/0682_baseball_game.go) | _O(n)_  | _O(n)_         | Easy           ||
| 0726 | [Number of Atoms](./problems/0726-number-of-atoms.md) | [Go](./golang/0726_number_of_atoms.go) | _O(n)_  | _O(n)_         | Hard           ||
| 0735 | [Asteroid Collision](./problems/0735-asteroid-collision.md) | [Go](./golang/0735_asteroid_collision.go) | _O(n)_  | _O(n)_         | Medium           ||
| 0736 | [Parse Lisp Expression](./problems/0736-parse-lisp-expression.md) | [Go](./golang/0736_parse_lisp_expression.go) | _O(n^2)_  | _O(n^2)_         | Hard           ||
| 0853 | [Car Fleet](./problems/0853-car-fleet.md) | [Go](./golang/0853_car_fleet.go) | _O(nlogn)_  | _O(n)_         | Medium           ||
| 0872 | [Leaf-Similar Trees](./problems/0872-leaf-similar-trees.md) | [Go](./golang/0872_leaf_similar_trees.go) | _O(n)_  | _O(h)_         | Easy           ||
| 0895 | [Maximum Frequency Stack](./problems/0895-maximum-frequency-stack.md) | [Go](./golang/0895_maximum_frequency_stack.go) | _O(1)_  | _O(n)_         | Hard           || Hash
| 0901 | [Online Stock Span](./problems/0901-online-stock-span.md) | [Go](./golang/0901_online_stock_span.go) | _O(n)_  | _O(n)_         | Medium           ||
| 0946 | [Validate Stack Sequences](./problems/0946-validate-stack-sequences.md) | [Go](./golang/0946_validate_stack_sequences.go) | _O(n)_  | _O(n)_         | Medium           ||
| 1003 | [Check If Word Is Valid After Substitutions](./problems/1003-check-if-word-is-valid-after-substitutions.md) | [Go](./golang/1003_check_if_word_is_valid_after_substitutions.go) | _O(n)_  | _O(n)_         | Medium           ||
| 1047 | [Remove All Adjacent Duplicates In String](./problems/1047-remove-all-adjacent-duplicates-in-string.md) | [Go](./golang/1047_remove_all_adjacent_duplicates_in_string.go) | _O(n)_ | _O(n)_      | Easy         ||
| 1209 | [Remove All Adjacent Duplicates in String II](./problems/1209-remove-all-adjacent-duplicates-in-string-ii.md) | [Go](./golang/1209_remove_all_adjacent_duplicates_in_string_ii.go) | _O(n)_ | _O(n)_      | Medium         ||
| 1441 | [Build an Array With Stack Operations](./problems/1441-build-an-array-with-stack-operations.md) | [Go](./golang/1441_build_an_array_with_stack_operations.go) | _O(n)_ | _O(1)_      | Easy         ||
| 2197 | [Replace Non-Coprime Numbers in Array](./problems/2197-replace-non-coprime-numbers-in-array.md) | [Go](./golang/2197_replace_non_coprime_numbers_in_array.go) | _O(nlogm)_ | _O(1)_ | Hard | | Stack, Math
| 2696 | [Minimum String Length After Removing Substrings](./problems/2696-minimum-string-length-after-removing-substrings.md) | [Go](./golang/2696_minimum_string_length_after_removing_substrings.go) | _O(n)_ | _O(n)_ | Easy | | Stack
| 2764 | [is Array a Preorder of Some ‌Binary Tree](./problems/2764-is-array-a-preorder-of-some-binary-tree.md) | [Go](./golang/2764_is_array_a_preorder_of_some_binary_tree.go) | _O(n)_ | _O(n)_ | Medium | 🔒 | Stack
| 2899 | [Last Visited Integers](./problems/2899-last-visited-integers.md) | [Go](./golang/2899_last_visited_integers.go) | _O(n)_ | _O(n)_ | Easy | | Stack

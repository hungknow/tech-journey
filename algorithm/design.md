## Design

### 1. Cache

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0146 | [LRU Cache](./problems/0146-lru-cache.md) | [Go](./golang/0146_lru_cache.go)  | _O(1)_ | _O(k)_ | Hard || OrderedDict
| 0460 | [LFU Cache](./problems/0460-lfu-cache.md) | [Go](./golang/0460_lfu_cache.go) | _O(1)_ | _O(k)_ | Hard || |

---

### 2. Stack / Queue

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0225 | [Implement Stack using Queues](./problems/0225-implement-stack-using-queues.md) | [Go](./golang/0225_implement_stack_using_queues.go)  | push: _O(n)_, pop: _O(1)_, top: _O(1)_ | _O(n)_ | Easy ||
| 0353 | [Design Snake Game](./problems/0353-design-snake-game.md) | [Go](./golang/0353_design_snake_game.go) | _O(1)_ | _O(s)_ | Medium |🔒| Deque |
| 0359 | [Logger Rate Limiter](./problems/0359-logger-rate-limiter.md) | [Go](./golang/0359_logger_rate_limiter.go) | _O(1), amortized_ | _O(k)_ | Easy |🔒| Deque |
| 0362 | [Design Hit Counter](./problems/0362-design-hit-counter.md) | [Go](./golang/0362_design_hit_counter.go) | _O(1), amortized_ | _O(k)_ | Medium |🔒| Deque |
| 0622 | [Design Circular Queue](./problems/0622-design-circular-queue.md) | [Go](./golang/0622_design_circular_queue.go) | _O(1)_       | _O(k)_          | Medium         || Design |
| 0641 | [Design Circular Deque](./problems/0641-design-circular-deque.md) | [Go](./golang/0641_design_circular_deque.go) | _O(1)_       | _O(1)_          | Medium         || Design |
| 0716 | [Max Stack](./problems/0716-max-stack.md) | [Go](./golang/0716_max_stack.go) | push: _O(logn)_<br> pop: _O(logn)_<br> popMax: _O(logn)_<br> top: _O(1)_<br> peekMax: _O(1)_ | _O(n)_ | Easy || |
| 1172 | [Dinner Plate Stacks](./problems/1172-dinner-plate-stacks.md) | [Go](./golang/1172_dinner_plate_stacks.go) | push: _O(logn)_<br>pop: _O(1)_, amortized<br>popAtStack: _(logn)_ | _O(n * c)_ | Hard | | |
| 1286 | [Iterator for Combination](./problems/1286-iterator-for-combination.md) | [Go](./golang/1286_iterator_for_combination.go) | _O(k)_ | _O(k)_ | Medium ||  Stack |
| 1381 | [Design a Stack With Increment Operation](./problems/1381-design-a-stack-with-increment-operation.md) | [Go](./golang/1381_design_a_stack_with_increment_operation.go) | ctor: _O(1)_<br>push: _O(1)_<br>pop: _O(1)_<br>increment: _O(1)_ | _O(n)_ | Medium |||
| 1670 | [Design Front Middle Back Queue](./problems/1670-design-front-middle-back-queue.md) | [Go](./golang/1670_design_front_middle_back_queue.go) | _O(1)_ | _O(n)_| Medium | |
| 1756 | [Design Most Recently Used Queue](./problems/1756-design-most-recently-used-queue.md) | [Go](./golang/1756_design_most_recently_used_queue.go) | ctor: _O(nlogn)_<br>fetch: _O(logn)_ | _O(n)_| Medium | 🔒 | Sorted List, BIT, Fenwick Tree, Square Root Decomposition
| 2296 | [Design a Text Editor](./problems/2296-design-a-text-editor.md) | [Go](./golang/2296_design_a_text_editor.go) | ctor: _O(1)_<br>addText: _O(l)_<br>deleteText: _O(k)_<br>cursorLeft: _O(k)_<br>cursorRight: _O(k)_ | _O(n)_ | Hard | | Stack

---

### 3. Hash / Set

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0705 | [Design HashSet](./problems/0705-design-hashset.md) | [Go](./golang/0705_design_hashset.go) | _O(1)_       | _O(n)_          | Easy         || Design |
| 0706 | [Design HashMap](./problems/0706-design-hashmap.md) | [Go](./golang/0706_design_hashmap.go) | _O(1)_       | _O(n)_          | Easy         || Design |
| 1429 | [First Unique Number](./problems/1429-first-unique-number.md) | [Go](./golang/1429_first_unique_number.go) | ctor: _O(k)_<br>add: _O(1)_<br>showFirstUnique: _O(1)_ | _O(n)_ | Medium | 🔒 | LinkedHashSet 

---

### 4. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0173 | [Binary Search Tree Iterator](./problems/0173-binary-search-tree-iterator.md) | [Go](./golang/0173_binary_search_tree_iterator.go) | _O(1)_, amortized | _O(h)_| Medium ||   
| 0284 | [Peeking Iterator](./problems/0284-peeking-iterator.md) | [Go](./golang/0284_peeking_iterator.go) | _O(1)_ | _O(1)_ | Medium ||
| 0348 | [Design Tic-Tac-Toe](./problems/0348-design-tic-tac-toe.md) | [Go](./golang/0348_design_tic_tac_toe.go) | _O(1)_ | _O(n^2)_ | Medium |🔒||
| 0355 | [Design Twitter](./problems/0355-design-twitter.md) | [Go](./golang/0355_design_twitter.go) | _O(u + klogk)_ | _O(t + f)_ | Medium | LintCode | Heap |
| 0379 | [Design Phone Directory](./problems/0379-design-phone-directory.md) | [Go](./golang/0379_design_phone_directory.go) | _O(1)_ | _O(n)_ | Medium |🔒| |
| 0380 | [Insert Delete GetRandom O(1)](./problems/0380-insert-delete-getrandom-o1.md) | [Go](./golang/0380_insert_delete_getrandom_o1.go) | _O(1)_ | _O(n)_| Hard || |
| 0381 | [Insert Delete GetRandom O(1) - Duplicates allowed](./problems/0381-insert-delete-getrandom-o1-duplicates-allowed.md) | [Go](./golang/0381_insert_delete_getrandom_o1_duplicates_allowed.go) | _O(1)_ | _O(n)_ | Hard || |
| 0432 | [All O\`one Data Structure](./problems/0432-all-oone-data-structure.md) | [Go](./golang/0432_all_oone_data_structure.go) | _O(1)_ | _O(n)_| Hard || |
| 0489 | [Robot Room Cleaner](./problems/0489-robot-room-cleaner.md) | [Go](./golang/0489_robot_room_cleaner.go) | _O(n)_ | _O(n)_ | Hard |🔒| |
| 0535 | [Encode and Decode TinyURL](./problems/0535-encode-and-decode-tinyurl.md) | [Go](./golang/0535_encode_and_decode_tinyurl.go) | _O(1)_ | _O(n)_ | Medium || |
| 0588 | [Design In-Memory File System](./problems/0588-design-in-memory-file-system.md) | [Go](./golang/0588_design_in_memory_file_system.go) | ls: _O(l + klogk)_<br> mkdir: _O(l)_<br> addContentToFile: _O(l + c)_<br> readContentFromFile: _O(l + c)_ | _O(n + s)_ | Hard |🔒| |
| 0604 | [Design Compressed String Iterator](./problems/0604-design-compressed-string-iterator.md) | [Go](./golang/0604_design_compressed_string_iterator.go) | _O(1)_ | _O(1)_ | Easy |🔒| |
| 0631 | [Design Excel Sum Formula](./problems/0631-design-excel-sum-formula.md) | [Go](./golang/0631_design_excel_sum_formula.go) | set: _O((r * c)^2)_<br>get: _O(1)_<br>sum: _O((r * c)^2)_ | _O(r * c)_ | Hard |🔒| |
| 0635 | [Design Log Storage System](./problems/0635-design-log-storage-system.md) | [Go](./golang/0635_design_log_storage_system.go) | put: _O(1)_<br> retrieve: _O(n + dlogd)_ | _O(n)_ | Medium |🔒| |
| 0642 | [Design Search Autocomplete System](./problems/0642-design-search-autocomplete-system.md) | [Go](./golang/0642_design_search_autocomplete_system.go) | _O(p^2)_ | _O(p * t + s)_ | Hard |🔒| |
| 0707 | [Design Linked List](./problems/0707-design-linked-list.md) | [Go](./golang/0707_design_linked_list.go) | _O(n)_       | _O(n)_          | Medium         || Design |
| 0715 | [Range Module](./problems/0715-range-module.md) | [Go](./golang/0715_range_module.go) | add: _O(n)_<br> remove: _O(n)_<br> query: _O(logn)_ | _O(n)_ | Hard || |
| 0745 | [Prefix and Suffix Search](./problems/0745-prefix-and-suffix-search.md) | [Go](./golang/0745_prefix_and_suffix_search.go) | ctor: _O(w * l^2)_<br> search : _O(p + s)_ | _O(t)_ | Hard || Trie |
| 0900 | [RLE Iterator](./problems/0900-rle-iterator.md) | [Go](./golang/0900_rle_iterator.go) | _O(n)_ | _O(1)_ | Medium |||
| 1146 | [Snapshot Array](./problems/1146-snapshot-array.md) | [Go](./golang/1146_snapshot_array.go) | set: _O(1)_<br> get: _O(logn)_ | _O(n)_ | Medium |||
| 1166 | [Design File System](./problems/1166-design-file-system.md) | [Go](./golang/1166_design_file_system.go) | create: _O(n)_<br>get: _O(n)_ | _O(n)_ | Medium |🔒| |
| 1206 | [Design Skiplist](./problems/1206-design-skiplist.md) | [Go](./golang/1206_design_skiplist.go) | _O(logn)_, on average | _O(n)_ | Hard | | |
| 1236 | [Web Crawler](./problems/1236-web-crawler.md) | [Go](./golang/1236_web_crawler.go) | _O(\|V\| + \|E\|)_ | _O(\|V\|)_ | Medium |🔒| BFS, DFS |
| 1244 | [Design A Leaderboard](./problems/1244-design-a-leaderboard.md) | [Go](./golang/1244_design_a_leaderboard.go) | ctor: _O(1)_<br> add: _O(1)_<br> top: _O(n)_<br> reset: _O(1)_ | _O(n)_ | Medium | | |
| 1268 | [Search Suggestions System](./problems/1268-search-suggestions-system.md) | [Go](./golang/1268_search_suggestions_system.go) | ctor: _O(n * l)_<br> suggest: _O(l^2)_ | _O(t)_ | Medium ||  Trie |
| 1348 | [Tweet Counts Per Frequency](./problems/1348-tweet-counts-per-frequency.md) | [Go](./golang/1348_tweet_counts_per_frequency.go) | add: _O(logn)_<br>query: _O(c)_ | _O(n)_ | Medium |||
| 1352 | [Product of the Last K Numbers](./problems/1352-product-of-the-last-k-numbers.md) | [Go](./golang/1352_product_of_the_last_k_numbers.go) | ctor: _O(1)_<br>add: _O(1)_<br>get: _O(1)_ | _O(n)_ | Medium |||
| 1357 | [Apply Discount Every n Orders](./problems/1357-apply-discount-every-n-orders.md) | [Go](./golang/1357_apply_discount_every_n_orders.go) | ctor: _O(m)_<br>getBill: _O(p)_ | _O(m)_ | Medium |||
| 1396 | [Design Underground System](./problems/1396-design-underground-system.md) | [Go](./golang/1396_design_underground_system.go) | ctor: _O(1)_<br>checkin: _O(1)_<br>checkout: _O(1)_<br>getaverage: _O(1)_ | _O(n)_ | Medium |||
| 1472 | [Design Browser History](./problems/1472-design-browser-history.md) | [Go](./golang/1472_design_browser_history.go) | ctor: _O(1)_<br>visit: _O(1)_<br>back: _O(1)_<br>forward: _O(1)_ | _O(n)_ | Medium |||
| 1476 | [Subrectangle Queries](./problems/1476-subrectangle-queries.md) | [Go](./golang/1476_subrectangle_queries.go) | ctor: _O(1)_<br>update: _O(1)_<br>get: _O(u)_ | _O(u)_ | Medium |||
| 1483 | [Kth Ancestor of a Tree Node](./problems/1483-kth-ancestor-of-a-tree-node.md) | [Go](./golang/1483_kth_ancestor_of_a_tree_node.go) | ctor: _O(n * logh)_<br>get: _O(logh)_ | _O(n * logh)_ | Hard || DP, Binary Lifting |
| 1500 | [Design a File Sharing System](./problems/1500-design-a-file-sharing-system.md) | [Go](./golang/1500_design_a_file_sharing_system.go) | ctor: _O(1)_<br>join: _O(logu + c)_<br>leave: _O(logu + c)_<br>request: _O(u)_ | _O(u * c)_ | Medium | 🔒 | |
| 1570 | [Dot Product of Two Sparse Vectors](./problems/1570-dot-product-of-two-sparse-vectors.md) | [Go](./golang/1570_dot_product_of_two_sparse_vectors.go) | ctor: _O(n)_<br>dot_product: _O(min(n, m))_ | _O(n)_ | Medium | 🔒 | |
| 1586 | [Binary Search Tree Iterator II](./problems/1586-binary-search-tree-iterator-ii.md) | [Go](./golang/1586_binary_search_tree_iterator_ii.go) | _O(1)_, amortized | _O(h)_| Medium | 🔒 |   
| 1600 | [Throne Inheritance](./problems/1600-throne-inheritance.md) | [Go](./golang/1600_throne_inheritance.go) | ctor: _O(1)_<br>birth: _O(1)_<br>death: _O(1)_<br>inherit: _O(n)_ | _O(n)_| Medium | |  
| 1603 | [Design Parking System](./problems/1603-design-parking-system.md) | [Go](./golang/1603_design_parking_system.go) | _O(1)_ | _O(1)_| Easy | | 
| 1622 | [Fancy Sequence](./problems/1622-fancy-sequence.md) | [Go](./golang/1622_fancy_sequence.go) | _O(1)_ | _O(n)_| Hard | |  `Euler's Theorem`
| 1628 | [Design an Expression Tree With Evaluate Function](./problems/1628-design-an-expression-tree-with-evaluate-function.md) | [Go](./golang/1628_design_an_expression_tree_with_evaluate_function.go) | _O(n)_ | _O(h)_| Medium | 🔒 |
| 1656 | [Design an Ordered Stream](./problems/1656-design-an-ordered-stream.md) | [Go](./golang/1656_design_an_ordered_stream.go) | _O(1)_, amortized | _O(n)_| Easy | |
| 1797 | [Design Authentication Manager](./problems/1797-design-authentication-manager.md) | [Go](./golang/1797_design_authentication_manager.go) | ctor: _O(1)_<br>generate: _O(1)_, amortized<br>renew: _O(1)_, amortized<br>count: _O(1)_, amortized | _O(n)_| Medium | | OrderedDict
| 1804 | [Implement Trie II (Prefix Tree)](./problems/1804-implement-trie-ii-prefix-tree.md) | [Go](./golang/1804_implement_trie_ii_prefix_tree.go) | ctor: _O(1)_<br>insert: _O(n)_<br>count_word: _O(n)_<br>count_prefix: _O(n)_<br>erase: _O(n)_ | _O(t)_| Medium | 🔒 | Trie
| 1825 | [Finding MK Average](./problems/1825-finding-mk-average.md) | [Go](./golang/1825_finding_mk_average.go) | ctor: _O(1)_<br>add_element: _O(logn)_<br>calc_mkaverge: _O(1)_ | _O(m)_| Hard | | Sorted List
| 1845 | [Seat Reservation Manager](./problems/1845-seat-reservation-manager.md) | [Go](./golang/1845_seat_reservation_manager.go) | ctor: _O(n)_<br>reserve: _O(logn)_<br>unreserve: _O(logn)_ | _O(n)_| Medium | | Heap
| 1865 | [Finding Pairs With a Certain Sum](./problems/1865-finding-pairs-with-a-certain-sum.md) | [Go](./golang/1865_finding_pairs_with_a_certain_sum.go) | ctor: _O(n1 + n2)_<br>add: _O(1)_<br>count: _O(n1)_ | _O(n1 + n2)_| Medium | | Hash Table
| 1912 | [Design Movie Rental System](./problems/1912-design-movie-rental-system.md) | [Go](./golang/1912_design_movie_rental_system.go) | ctor: _O(nlogn)_<br>search: _O(logn)_<br>rent: _O(logn)_<br>drop: _O(logn)_<br>report: _O(logn)_ | _O(n)_| Hard | | Ordered List
| 1993 | [Operations on Tree](./problems/1993-operations-on-tree.md) | [Go](./golang/1993_operations_on_tree.go) | ctor: _O(n)_<br>lock: _O(1)_<br>unlock: _O(1)_<br>upgrade: _O(n)_ | _O(n)_| Medium | |
| 2013 | [Detect Squares](./problems/2013-detect-squares.md) | [Go](./golang/2013_detect_squares.go) | ctor: _O(1)_<br>add: _O(1)_<br>count: _O(n)_ | _O(n)_| Medium | |
| 2034 | [Stock Price Fluctuation](./problems/2034-stock-price-fluctuation.md) | [Go](./golang/2034_stock_price_fluctuation.go) | ctor: _O(1)_<br>update: _O(logn)_<br>current: _O(1)_<br>max: _O(1)_<br>min: _O(1)_ | _O(n)_ | Medium | | Sorted List, Heap
| 2043 | [Simple Bank System](./problems/2043-simple-bank-system.md) | [Go](./golang/2043_simple_bank_system.go) | ctor: _O(1)_<br>transer: _O(1)_<br>deposit: _O(1)_<br>withdraw: _O(1)_ | _O(1)_ | Medium | |
| 2069 | [Walking Robot Simulation II](./problems/2069-walking-robot-simulation-ii.md) | [Go](./golang/2069_walking_robot_simulation_ii.go) | _O(1)_ | _O(1)_ | Medium | | Simulation, Math
| 2080 | [Range Frequency Queries](./problems/2080-range-frequency-queries.md) | [Go](./golang/2080_range_frequency_queries.go) | ctor: _O(n)_<br>query: _O(logn)_ | _O(n)_ | Medium | | Binary Search
| 2102 | [Sequentially Ordinal Rank Tracker](./problems/2102-sequentially-ordinal-rank-tracker.md) | [Go](./golang/2102_sequentially_ordinal_rank_tracker.go) | add: _O(logn)_<br>get: _O(logn)_ | _O(n)_ | Hard | | Sorted List
| 2166 | [Design Bitset](./problems/2166-design-bitset.md) | [Go](./golang/2166_design_bitset.go) | ctor: _O(n)_<br>fix: _O(1)_<br>fix: _O(1)_<br>unfix: _O(1)_<br>flip: _O(1)_<br>all: _O(1)_<br>one: _O(1)_<br>count: _O(1)_<br>toString: _O(n)_ | _O(n)_ | Medium | |
| 2227 | [Encrypt and Decrypt Strings](./problems/2227-encrypt-and-decrypt-strings.md) | [Go](./golang/2227_encrypt_and_decrypt_strings.go) | ctor: _O(m + d)_<br>encrypt: _O(n)_<br>decrypt: _O(n)_ | _O(n)_ | Hard | | Freq Table
| 2241 | [Design an ATM Machine](./problems/2241-design-an-atm-machine.md) | [Go](./golang/2241_design_an_atm_machine.go) | ctor: _O(1)_<br>deposit: _O(1)_<br>withdraw: _O(1)_ | _O(1)_ | Medium | | Greedy
| 2254 | [Design Video Sharing Platform](./problems/2254-design-video-sharing-platform.md) | [Go](./golang/2254_design_video_sharing_platform.go) | ctor: _O(1)_<br>upload: _O(logn + l)_<br>remove: _O(logn)_<br>like: _O(1)_<br>dislike: _O(1)_<br>view: _O(1)_<br>getLikesAndDislikes: _O(1)_<br>getViews: _O(1)_ | _O(n * l)_ | Hard | 🔒 | Heap
| 2276 | [Count Integers in Intervals](./problems/2276-count-integers-in-intervals.md) | [Go](./golang/2276_count_integers_in_intervals.go) | ctor: _O(1)_<br>add: _O(logn)_, amortized<br>Count: _O(1)_ | _O(n)_ | Hard | | Sorted List
| 2286 | [Booking Concert Tickets in Groups](./problems/2286-booking-concert-tickets-in-groups.md) | [Go](./golang/2286_booking_concert_tickets_in_groups.go) | ctor: _O(n)_<br>gather: _O(logn)_<br>scatter: _O(logn)_, amortized | _O(n)_ | Hard | | Segment Tree, Binary Search
| 2336 | [Smallest Number in Infinite Set](./problems/2336-smallest-number-in-infinite-set.md) | [Go](./golang/2336_smallest_number_in_infinite_set.go) | ctor: _O(1)_<br>popSmallest: _O(logn)_<br>addBack: _O(logn)_ | _O(n)_ | Medium | | Heap, BST
| 2349 | [Design a Number Container System](./problems/2349-design-a-number-container-system.md) | [Go](./golang/2349_design_a_number_container_system.go) | ctor: _O(1)_<br>change: _O(logn)_<br>find: _O(1)_ | _O(n)_ | Medium | | Sorted List, BST
| 2353 | [Design a Food Rating System](./problems/2353-design-a-food-rating-system.md) | [Go](./golang/2353_design_a_food_rating_system.go) | ctor: _O(nlogn)_<br>changeRating: _O(logn)_<br>highestRated: _O(1)_ | _O(n)_ | Medium | | Sorted List, BST
| 2408 | [Design SQL](./problems/2408-design-sql.md) | [Go](./golang/2408_design_sql.go) | ctor: _O(t * max_m)_<br>insertRow: _O(m)_<br>deleteRow: _O(1)_<br>selectCell: _O(m)_ | _O(d)_ | Medium | 🔒 | Hash Table
| 2424 | [Longest Uploaded Prefix](./problems/2424-longest-uploaded-prefix.md) | [Go](./golang/2424_longest_uploaded_prefix.go) | ctor: _O(1)_<br>upload: _O(1)_, amortized <br>longest: _O(1)_ | _O(n)_ | Medium | | Hash Table
| 2502 | [Design Memory Allocator](./problems/2502-design-memory-allocator.md) | [Go](./golang/2502_design_memory_allocator.go) | ctor: _O(1)_<br>allocate: _O(logn)_<br>free: _O(logn)_ | _O(n)_ | Medium | | Sorted List
| 2526 | [Find Consecutive Integers from a Data Stream](./problems/2526-find-consecutive-integers-from-a-data-stream.md) | [Go](./golang/2526_find_consecutive_integers_from_a_data_stream.go) | _O(1)_ | _O(1)_ | Medium | | Array
| 2590 | [Design a Todo List](./problems/2590-design-a-todo-list.md) | [Go](./golang/2590_design_a_todo_list.go) | ctor: _O(1)_<br>addTask: _O(l + logn)_<br>getAllTasks: _O(r)_<br>getTasksForTag: _O(r * c)_<br>completeTask: _O(l + logn)_ | _O(n * l)_ | Medium | 🔒 | BST, Sorted List
| 2642 | [Design Graph With Shortest Path Calculator](./problems/2642-design-graph-with-shortest-path-calculator.md) | [Go](./golang/2642_design_graph_with_shortest_path_calculator.go) | ctor: _O(\|V\| + \|E\|)_<br>addEdge: _O(1)_<br>shortestPath: _O(\|E\| * log\|V\|)_ | _O(\|E\|)_ | Hard | | `Dijkstra's Algorithm`
| 2671 | [Frequency Tracker](./problems/2671-frequency-tracker.md) | [Go](./golang/2671_frequency_tracker.go) | ctor: _O(1)_<br>add: _O(1)_<br>deleteOne: _O(1)_<br>hasFrequency: _O(1)_ | _O(min(n, r))_ | Medium | | Freq Table

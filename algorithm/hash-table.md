## Hash Table

### 1. Classic Two-Sum & Complements

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0001 | [Two Sum](./problems/0001-two-sum.md) | [C++](./C++/two-sum.cpp) [Python](./Python/two-sum.py) | _O(n)_ | _O(n)_ | Easy | | The map stores `number -> index` to check if `target - current_number` exists |
| 0170 | [Two Sum III - Data structure design](./problems/0170-two-sum-iii.md) | [C++](./C++/two-sum-iii-data-structure-design.cpp) [Python](./Python/two-sum-iii-data-structure-design.py) | _O(n)_ | _O(n)_ | Easy | 🔒 | Numbers are streamed dynamically; map stores `number -> frequency` |
| 0454 | [4Sum II](./problems/0454-4sum-ii.md) | [C++](./C++/4sum-ii.cpp) [Python](./Python/4sum-ii.py) | _O(n^2)_ | _O(n^2)_ | Medium | | Map stores `sum(A[i] + B[j]) -> frequency`; look up `-(C[k] + D[l])` |
| 0532 | [K-diff Pairs in an Array](./problems/0532-k-diff-pairs.md) | [C++](./C++/k-diff-pairs-in-an-array.cpp) [Python](./Python/k-diff-pairs-in-an-array.py) | _O(n)_ | _O(n)_ | Easy | | Looking for specific differences; map stores `number -> frequency` |
| 0825 | [Friends Of Appropriate Ages](./problems/0825-friends-appropriate-ages.md) | [C++](./C++/friends-of-appropriate-ages.cpp) [Python](./Python/friends-of-appropriate-ages.py) | _O(a^2 + n)_ | _O(a)_ | Medium | | Validating age rules; map/array tracks `age -> frequency` |

---

### 2. Prefix Sums & Contiguous Arrays

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0325 | [Maximum Size Subarray Sum Equals k](./problems/0325-maximum-size-subarray-sum.md) | [C++](./C++/maximum-size-subarray-sum-equals-k.cpp) [Python](./Python/maximum-size-subarray-sum-equals-k.py) | _O(n)_ | _O(n)_ | Medium | 🔒 | Map stores `prefix_sum -> first_seen_index`; find longest subarray |
| 0523 | [Continuous Subarray Sum](./problems/0523-continuous-subarray-sum.md) | [C++](./C++/continuous-subarray-sum.cpp) [Python](./Python/continuous-subarray-sum.py) | _O(n)_ | _O(k)_ | Medium | | Map stores `(prefix_sum % k) -> first_seen_index`; find multiples of k |
| 0560 | [Subarray Sum Equals K](./problems/0560-subarray-sum-equals-k.md) | [C++](./C++/subarray-sum-equals-k.cpp) [Python](./Python/subarray-sum-equals-k.py) | _O(n)_ | _O(n)_ | Medium | | Map stores `prefix_sum -> frequency`; count total subarrays |
| 0974 | [Subarray Sums Divisible by K](./problems/0974-subarray-sums-divisible-by-k.md) | [C++](./C++/subarray-sums-divisible-by-k.cpp) [Python](./Python/subarray-sums-divisible-by-k.py) | _O(n)_ | _O(k)_ | Medium | variant of [Subarray Sum Equals K](https://leetcode.com/problems/subarray-sum-equals-k/) | Map stores `(prefix_sum % K) -> frequency`; counting occurrences |

---

### 3. Sliding Window & Character Frequencies

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0003 | [Longest Substring Without Repeating Characters](./problems/0003-longest-substring-without-repeating.md) | [C++](./C++/longest-substring-without-repeating-characters.cpp) [Python](./Python/longest-substring-without-repeating-characters.py) | _O(n)_ | _O(1)_ | Medium | | Map stores `character -> last_seen_index`; dynamic window without duplicates |
| 0030 | [Substring with Concatenation of All Words](./problems/0030-substring-concatenation-words.md) | [C++](./C++/substring-with-concatenation-of-all-words.cpp) [Python](./Python/substring-with-concatenation-of-all-words.py) | _O((m + n) * k)_ | _O(n * k)_ | Hard | | Two frequency maps: target words and current sliding window |
| 0076 | [Minimum Window Substring](./problems/0076-minimum-window-substring.md) | [C++](./C++/minimum-window-substring.cpp) [Python](./Python/minimum-window-substring.py) | _O(n)_ | _O(k)_ | Hard | | Map stores `character -> required_count`; smallest window containing all targets |
| 0159 | [Longest Substring with At Most Two Distinct Characters](./problems/0159-longest-substring-two-distinct.md) | [C++](./C++/longest-substring-with-at-most-two-distinct-characters.cpp) [Python](./Python/longest-substring-with-at-most-two-distinct-characters.py) | _O(n)_ | _O(1)_ | Hard | 🔒 | Map stores `character -> frequency`; constrained to exactly two character types |
| 0340 | [Longest Substring with At Most K Distinct Characters](./problems/0340-longest-substring-k-distinct.md) | [C++](./C++/longest-substring-with-at-most-k-distinct-characters.cpp) [Python](./Python/longest-substring-with-at-most-k-distinct-characters.py) | _O(n)_ | _O(1)_ | Hard | 🔒 | Same as 0159, but map size limit is `K` |
| 0438 | [Find All Anagrams in a String](./problems/0438-find-all-anagrams.md) | [C++](./C++/find-all-anagrams-in-a-string.cpp) [Python](./Python/find-all-anagrams-in-a-string.py) | _O(n)_ | _O(1)_ | Easy | | Fixed-size sliding window; map tracks current window's character frequencies |

---

### 4. Grouping & Fingerprinting

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0049 | [Group Anagrams](./problems/0049-group-anagrams.md) | [C++](./C++/group-anagrams.cpp) [Python](./Python/group-anagrams.py) | _O(n * glogg)_ | _O(n)_ | Medium | | Map stores signature key (sorted string or char count tuple) `-> [list_of_words]` |
| 0249 | [Group Shifted Strings](./problems/0249-group-shifted-strings.md) | [C++](./C++/group-shifted-strings.cpp) [Python](./Python/group-shifted-strings.py) | _O(nlogn)_ | _O(n)_ | Easy | 🔒 | Map key is relative distance between characters `-> [list_of_strings]` |
| 0609 | [Find Duplicate File in System](./problems/0609-find-duplicate-file-system.md) | [C++](./C++/find-duplicate-file-in-system.cpp) [Python](./Python/find-duplicate-file-in-system.py) | _O(n * l)_ | _O(n * l)_ | Medium | | Map stores `file_content -> [list_of_file_paths]` |
| 0869 | [Reordered Power of 2](./problems/0869-reordered-power-of-2.md) | [C++](./C++/reordered-power-of-2.cpp) [Python](./Python/reordered-power-of-2.py) | _O(1)_ | _O(1)_ | Medium | | Map/set stores sorted character counts of all valid powers of 2 |

---

### 5. String Validation & Mapping

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0205 | [Isomorphic Strings](./problems/0205-isomorphic-strings.md) | [C++](./C++/isomorphic-strings.cpp) [Python](./Python/isomorphic-strings.py) | _O(n)_ | _O(1)_ | Easy | | Two maps track `char_from_S -> char_from_T` and prevent mapping collisions |
| 0290 | [Word Pattern](./problems/0290-word-pattern.md) | [C++](./C++/word-pattern.cpp) [Python](./Python/word-pattern.py) | _O(n)_ | _O(c)_ | Easy | variant of [Isomorphic Strings](https://leetcode.com/problems/isomorphic-strings/) | Mapping `pattern_character -> whole_word` |
| 0734 | [Sentence Similarity](./problems/0734-sentence-similarity.md) | [C++](./C++/sentence-similarity.cpp) [Python](./Python/sentence-similarity.py) | _O(n + p)_ | _O(p)_ | Easy | | Map stores `word -> Set(similar_words)` to validate translations |
| 0760 | [Find Anagram Mappings](./problems/0760-find-anagram-mappings.md) | [C++](./C++/find-anagram-mappings.cpp) [Python](./Python/find-anagram-mappings.py) | _O(n)_ | _O(n)_ | Easy | | Map stores `value -> [list_of_indices_in_array_B]` |

---

### 6. Cycle Detection & States

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0187 | [Repeated DNA Sequences](./problems/0187-repeated-dna-sequences.md) | [Python](./Python/repeated-dna-sequences.py) | _O(n)_ | _O(n)_ | Medium | | Hash Set stores every 10-char slice seen so far (or bitmasks) |
| 0202 | [Happy Number](./problems/0202-happy-number.md) | [C++](./C++/happy-number.cpp) [Python](./Python/happy-number.py) | _O(k)_ | _O(k)_ | Easy | | Hash Set stores every sum-of-squares result; detect cycles |
| 0957 | [Prison Cells After N Days](./problems/0957-prison-cells-after-n-days.md) | [C++](./C++/prison-cells-after-n-days.cpp) [Python](./Python/prison-cells-after-n-days.py) | _O(1)_ | _O(1)_ | Medium | | Map stores `prison_state -> day_seen`; use modulo math to skip cycles |

---

### 7. Coordinates, Geometry & Graphs

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0036 | [Valid Sudoku](./problems/0036-valid-sudoku.md) | [C++](./C++/valid-sudoku.cpp) [Python](./Python/valid-sudoku.py) | _O(9^2)_ | _O(9)_ | Easy | | Hash Set stores formatted strings like `"5 in row 3"`, `"5 in col 4"`, `"5 in block 1-1"` |
| 0149 | [Max Points on a Line](./problems/0149-max-points-on-a-line.md) | [C++](./C++/max-points-on-a-line.cpp) [Python](./Python/max-points-on-a-line.py) | _O(n^2)_ | _O(n)_ | Hard | | Map stores strictly reduced fraction of slope `dy/dx -> count_of_points` |
| 0356 | [Line Reflection](./problems/0356-line-reflection.md) | [C++](./C++/line-reflection.cpp) [Python](./Python/line-reflection.py) | _O(n)_ | _O(n)_ | Medium | 🔒 | Hash Set stores all points; check mirrored counterparts |
| 0447 | [Number of Boomerangs](./problems/0447-number-of-boomerangs.md) | [C++](./C++/number-of-boomerangs.cpp) [Python](./Python/number-of-boomerangs.py) | _O(n^2)_ | _O(n)_ | Easy | | Map stores `squared_distance_to_other_points -> count` |
| 0554 | [Brick Wall](./problems/0554-brick-wall.md) | [C++](./C++/brick-wall.cpp) [Python](./Python/brick-wall.py) | _O(n)_ | _O(m)_ | Medium | | Map stores `gap_distance_from_left_edge -> count_of_gaps` |

---

### 8. Counting & Uniqueness Filters

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0217 | [Contains Duplicate](./problems/0217-contains-duplicate.md) | [C++](./C++/contains-duplicate.cpp) [Python](./Python/contains-duplicate.py) | _O(n)_ | _O(n)_ | Easy | | Hash Set stores numbers; duplicate if already in set |
| 0219 | [Contains Duplicate II](./problems/0219-contains-duplicate-ii.md) | [C++](./C++/contains-duplicate-ii.cpp) [Python](./Python/contains-duplicate-ii.py) | _O(n)_ | _O(n)_ | Easy | | Map stores `number -> last_seen_index`; check within distance k |
| 0266 | [Palindrome Permutation](./problems/0266-palindrome-permutation.md) | [C++](./C++/palindrome-permutation.cpp) [Python](./Python/palindrome-permutation.py) | _O(n)_ | _O(1)_ | Easy | 🔒 | Map/set tracks character frequencies; verify at most one odd count |
| 0288 | [Unique Word Abbreviation](./problems/0288-unique-word-abbreviation.md) | [C++](./C++/unique-word-abbreviation.cpp) [Python](./Python/unique-word-abbreviation.py) | ctor: _O(n)_, lookup: _O(1)_ | _O(k)_ | Easy | 🔒 | Map stores `abbreviation -> Set(original_words)` |
| 0387 | [First Unique Character in a String](./problems/0387-first-unique-character.md) | [C++](./C++/first-unique-character-in-a-string.cpp) [Python](./Python/first-unique-character-in-a-string.py) | _O(n)_ | _O(n)_ | Easy | | Map tracks `character -> frequency`; find first with count of 1 |
| 0409 | [Longest Palindrome](./problems/0409-longest-palindrome.md) | [C++](./C++/longest-palindrome.cpp) [Python](./Python/longest-palindrome.py) | _O(n)_ | _O(1)_ | Easy | | Map tracks `character -> frequency`; even counts fully added, one odd allowed |
| 0575 | [Distribute Candies](./problems/0575-distribute-candies.md) | [C++](./C++/distribute-candies.cpp) [Python](./Python/distribute-candies.py) | _O(n)_ | _O(n)_ | Easy | | Hash Set stores all candy types for instant unique count |
| 0594 | [Longest Harmonious Subsequence](./problems/0594-longest-harmonious-subsequence.md) | [C++](./C++/longest-harmonious-subsequence.cpp) [Python](./Python/longest-harmonious-subsequence.py) | _O(n)_ | _O(n)_ | Easy | | Map stores `number -> frequency`; if `num + 1` exists, length is `freq[num] + freq[num+1]` |
| 0748 | [Shortest Completing Word](./problems/0748-shortest-completing-word.md) | [C++](./C++/shortest-completing-word.cpp) [Python](./Python/shortest-completing-word.py) | _O(n)_ | _O(1)_ | Easy | | Map stores frequency of alphabetical characters in target license plate |
| 0771 | [Jewels and Stones](./problems/0771-jewels-and-stones.md) | [C++](./C++/jewels-and-stones.cpp) [Python](./Python/jewels-and-stones.py) | _O(m + n)_ | _O(n)_ | Easy | | Hash Set stores "Jewels" characters for O(1) lookups |

---

### 9. Structural & Pathing Assistance

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0244 | [Shortest Word Distance II](./problems/0244-shortest-word-distance-ii.md) | [C++](./C++/shortest-word-distance-ii.cpp) [Python](./Python/shortest-word-distance-ii.py) | ctor: _O(n)_, lookup: _O(a + b)_ | _O(n)_ | Medium | 🔒 | Map stores `word -> [list_of_indices]`; use two pointers |
| 0246 | [Strobogrammatic Number](./problems/0246-strobogrammatic-number.md) | [C++](./C++/strobogrammatic-number.cpp) [Python](./Python/strobogrammatic-number.py) | _O(n)_ | _O(1)_ | Easy | 🔒 | Map stores valid pairs: `{'0':'0', '1':'1', '6':'9', '8':'8', '9':'6'}` |
| 0299 | [Bulls and Cows](./problems/0299-bulls-and-cows.md) | [C++](./C++/bulls-and-cows.cpp) [Python](./Python/bulls-and-cows.py) | _O(n)_ | _O(1)_ | Easy | | Map tracks frequencies of unmatched characters for partial matches |
| 0314 | [Binary Tree Vertical Order Traversal](./problems/0314-binary-tree-vertical-order.md) | [C++](./C++/binary-tree-vertical-order-traversal.cpp) [Python](./Python/binary-tree-vertical-order-traversal.py) | _O(n)_ | _O(n)_ | Medium | 🔒 BFS | Map stores `column_index -> [list_of_nodes]`; left gets `col-1`, right gets `col+1` |
| 0336 | [Palindrome Pairs](./problems/0336-palindrome-pairs.md) | [C++](./C++/palindrome-pairs.cpp) [Python](./Python/palindrome-pairs.py) | _O(n * k^2)_ | _O(n * k)_ | Hard | | Map stores `reversed_word -> index`; check prefixes/suffixes |
| 0388 | [Longest Absolute File Path](./problems/0388-longest-absolute-file-path.md) | [C++](./C++/longest-absolute-file-path.cpp) [Python](./Python/longest-absolute-file-path.py) | _O(n)_ | _O(d)_ | Medium | Stack | Map stores `directory_depth -> total_string_length` |
| 0561 | [Array Partition I](./problems/0561-array-partition-i.md) | [C++](./C++/array-partition-i.cpp) [Python](./Python/array-partition-i.py) | _O(r)_ | _O(r)_ | Easy | | Bucket-sort style frequency map `number -> frequency` |
| 0599 | [Minimum Index Sum of Two Lists](./problems/0599-minimum-index-sum-two-lists.md) | [C++](./C++/minimum-index-sum-of-two-lists.cpp) [Python](./Python/minimum-index-sum-of-two-lists.py) | _O((m + n) * l)_ | _O(m * l)_ | Easy | | Map stores `restaurant_name -> list_1_index` |
| 0811 | [Subdomain Visit Count](./problems/0811-subdomain-visit-count.md) | [C++](./C++/subdomain-visit-count.cpp) [Python](./Python/subdomain-visit-count.py) | _O(n)_ | _O(n)_ | Easy | | Map stores `domain_fragment -> total_visits` |
| 0822 | [Card Flipping Game](./problems/0822-card-flipping-game.md) | [C++](./C++/card-flipping-game.cpp) [Python](./Python/card-flipping-game.py) | _O(n)_ | _O(n)_ | Medium | | Hash Set records numbers appearing on front AND back of same card |
| 0873 | [Length of Longest Fibonacci Subsequence](./problems/0873-longest-fibonacci-subsequence.md) | [C++](./C++/length-of-longest-fibonacci-subsequence.cpp) [Python](./Python/length-of-longest-fibonacci-subsequence.py) | _O(n^2)_ | _O(n)_ | Medium | | Hash Set stores all numbers; check if `arr[i] + arr[j]` exists |
| 0966 | [Vowel Spellchecker](./problems/0966-vowel-spellchecker.md) | [C++](./C++/vowel-spellchecker.cpp) [Python](./Python/vowel-spellchecker.py) | _O(n)_ | _O(w)_ | Medium | | Two maps: `lowercase_word -> original` and `devoweled_word -> original` |
| 0982 | [Triples with Bitwise AND Equal To Zero](./problems/0982-triples-bitwise-and-zero.md) | [C++](./C++/triples-with-bitwise-and-equal-to-zero.cpp) [Python](./Python/triples-with-bitwise-and-equal-to-zero.py) | _O(nlogn)_ | _O(n)_ | Hard | Math, `Fast Wavelet Transform (FWT)` | Map stores frequency of all `A[i] & A[j]` combinations |

---

### 10. Assisting Advanced Data Structures (Union-Find / Sieve / Trees)

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0204 | [Count Primes](./problems/0204-count-primes.md) | [C++](./C++/count-primes.cpp) [Python](./Python/count-primes.py) | _O(n)_ | _O(n)_ | Easy | `Linear Sieve of Eratosthenes` | Array as boolean map to mark composite numbers |
| 0305 | [Number of Islands II](./problems/0305-number-of-islands-ii.md) | [C++](./C++/number-of-islands-ii.cpp) [Python](./Python/number-of-islands-ii.py) | _O(k)_ | _O(k)_ | Hard | LintCode, 🔒 Union Find | Map stores parent sets for Union-Find as islands are added |
| 0323 | [Number of Connected Components in an Undirected Graph](./problems/0323-number-connected-components.md) | [C++](./C++/number-of-connected-components-in-an-undirected-graph.cpp) [Python](./Python/number-of-connected-components-in-an-undirected-graph.py) | _O(n)_ | _O(n)_ | Medium | 🔒 Union Find | Map tracks parent nodes for Union-Find |
| 0473 | [Matchsticks to Square](./problems/0473-matchsticks-to-square.md) | [C++](./C++/matchsticks-to-square.cpp) [Python](./Python/matchsticks-to-square.py) | _O(n * s * 2^n)_ | _O(n * (2^n + s))_ | Medium | | Hash Map as memoization cache for visited states (bitmasks) |
| 0721 | [Accounts Merge](./problems/0721-accounts-merge.md) | [C++](./C++/accounts-merge.cpp) [Python](./Python/accounts-merge.py) | _O(nlogn)_ | _O(n)_ | Medium | Union Find | Map `email -> account_name` and `email -> unique_ID` to unify disjoint sets |
| 0737 | [Sentence Similarity II](./problems/0737-sentence-similarity-ii.md) | [C++](./C++/sentence-similarity-ii.cpp) [Python](./Python/sentence-similarity-ii.py) | _O(n + p)_ | _O(p)_ | Medium | Union Find | Map `word -> integer_ID` to build Union-Find graph of transitive similarities |

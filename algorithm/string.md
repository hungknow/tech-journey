## String

### 1. Palindrome & Substring

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0005 | [Longest Palindromic Substring](./problems/0005-longest-palindromic-substring.md) | [Go](./golang/0005_longest_palindromic_substring.go) | _O(n)_ | _O(n)_ |  Medium || `Manacher's Algorithm`
| 0125 | [Valid Palindrome](./problems/0125-valid-palindrome.md) | [Go](./golang/0125_valid_palindrome.go) | _O(n)_  | _O(1)_         | Easy           ||
| 0214 | [Shortest Palindrome](./problems/0214-shortest-palindrome.md) | [Go](./golang/0214_shortest_palindrome.go) | _O(n)_ | _O(n)_ |  Hard || `KMP Algorithm`, `Manacher's Algorithm`
| 0564 | [Find the Closest Palindrome](./problems/0564-find-the-closest-palindrome.md) |[Go](./golang/0564_find_the_closest_palindrome.go) | _O(l)_ | _O(l)_ | Hard         | |
| 0647 | [Palindromic Substrings](./problems/0647-palindromic-substrings.md) | [Go](./golang/0647_palindromic_substrings.go) | _O(n)_ | _O(n)_ |  Medium || `Manacher's Algorithm`
| 0680 | [Valid Palindrome II](./problems/0680-valid-palindrome-ii.md) | [Go](./golang/0680_valid_palindrome_ii.go) | _O(n)_  | _O(1)_         | Easy           ||
| 1147 | [Longest Chunked Palindrome Decomposition](./problems/1147-longest-chunked-palindrome-decomposition.md) | [Go](./golang/1147_longest_chunked_palindrome_decomposition.go) | _O(n)_ | _O(1)_ | Hard | | `Rabin-Karp Algorithm`
| 1177 | [Can Make Palindrome from Substring](./problems/1177-can-make-palindrome-from-substring.md) | [Go](./golang/1177_can_make_palindrome_from_substring.go) | _O(m + n)_ | _O(n)_ | Medium | |
| 1328 | [Break a Palindrome](./problems/1328-break-a-palindrome.md) | [Go](./golang/1328_break_a_palindrome.go) | _O(n)_ | _O(1)_ | Medium | |
| 1332 | [Remove Palindromic Subsequences](./problems/1332-remove-palindromic-subsequences.md) | [Go](./golang/1332_remove_palindromic_subsequences.go) | _O(n)_ | _O(1)_ | Easy | |
| 1542 | [Find Longest Awesome Substring](./problems/1542-find-longest-awesome-substring.md) | [Go](./golang/1542_find_longest_awesome_substring.go) | _O(n)_ | _O(1)_ | Hard |||
| 1763 | [Longest Nice Substring](./problems/1763-longest-nice-substring.md) | [Go](./golang/1763_longest_nice_substring.go) | _O(n)_ | _O(n)_ | Easy |||
| 1839 | [Longest Substring Of All Vowels in Order](./problems/1839-longest-substring-of-all-vowels-in-order.md) | [Go](./golang/1839_longest_substring_of_all_vowels_in_order.go) | _O(n)_ | _O(1)_ | Medium |||
| 2081 | [Sum of k-Mirror Numbers](./problems/2081-sum-of-k-mirror-numbers.md) | [Go](./golang/2081_sum_of_k_mirror_numbers.go) | _O(10^6)_ | _O(1)_ | Hard || String, Palindrome, Brute Force |
| 2108 | [Find First Palindromic String in the Array](./problems/2108-find-first-palindromic-string-in-the-array.md) | [Go](./golang/2108_find_first_palindromic_string_in_the_array.go) | _O(n)_ | _O(1)_ | Easy || |
| 2131 | [Longest Palindrome by Concatenating Two Letter Words](./problems/2131-longest-palindrome-by-concatenating-two-letter-words.md) | [Go](./golang/2131_longest_palindrome_by_concatenating_two_letter_words.go) | _O(n)_ | _O(n)_ | Medium |||
| 2213 | [Longest Substring of One Repeating Character](./problems/2213-longest-substring-of-one-repeating-character.md) | [Go](./golang/2213_longest_substring_of_one_repeating_character.go) | _O(nlogn)_   | _O(n)_        | Hard         | | Segment Tree
| 2272 | [Substring With Largest Variance](./problems/2272-substring-with-largest-variance.md) | [Go](./golang/2272_substring_with_largest_variance.go) | _O(a^2 * n)_   | _O(a)_        | Hard         | | `Kadane's Algorithm`
| 2414 | [Length of the Longest Alphabetical Continuous Substring](./problems/2414-length-of-the-longest-alphabetical-continuous-substring.md) | [Go](./golang/2414_length_of_the_longest_alphabetical_continuous_substring.go) | _O(n)_   | _O(1)_        | Medium         | | String
| 2967 | [Minimum Cost to Make Array Equalindromic](./problems/2967-minimum-cost-to-make-array-equalindromic.md) | [Go](./golang/2967_minimum_cost_to_make_array_equalindromic.go)| _O(n + logr)_ | _O(logr)_ | Medium | variant of [Find the Closest Palindrome](https://leetcode.com/problems/find-the-closest-palindrome/) | Sort, Quick Select, Math, String |
| 0696 | [Count Binary Substrings](./problems/0696-count-binary-substrings.md) | [Go](./golang/0696_count_binary_substrings.go) | _O(n)_ | _O(1)_ | Easy||
| 1016 | [Binary String With Substrings Representing 1 To N](./problems/1016-binary-string-with-substrings-representing-1-to-n.md) | [Go](./golang/1016_binary_string_with_substrings_representing_1_to_n.go) | _O(n^2)_ | _O(1)_      | Medium         ||
| 1100 | [Find K-Length Substrings With No Repeated Characters](./problems/1100-find-k-length-substrings-with-no-repeated-characters.md) | [Go](./golang/1100_find_k_length_substrings_with_no_repeated_characters.go) | _O(n)_ | _O(k)_      | Medium         |🔒|
| 1371 | [Find the Longest Substring Containing Vowels in Even Counts](./problems/1371-find-the-longest-substring-containing-vowels-in-even-counts.md) | [Go](./golang/1371_find_the_longest_substring_containing_vowels_in_even_counts.go) | _O(n)_ | _O(1)_ | Medium | |
| 1624 | [Largest Substring Between Two Equal Characters](./problems/1624-largest-substring-between-two-equal-characters.md) | [Go](./golang/1624_largest_substring_between_two_equal_characters.go) | _O(n)_ | _O(1)_ | Easy |||
| 1638 | [Count Substrings That Differ by One Character](./problems/1638-count-substrings-that-differ-by-one-character.md) | [Go](./golang/1638_count_substrings_that_differ_by_one_character.go) | _O(m * n)_ | _O(1)_ | Medium | variant of [Count Unique Characters of All Substrings of a Given String](https://leetcode.com/problems/count-unique-characters-of-all-substrings-of-a-given-string/) | Tricky |
| 1876 | [Substrings of Size Three with Distinct Characters](./problems/1876-substrings-of-size-three-with-distinct-characters.md) | [Go](./golang/1876_substrings_of_size_three_with_distinct_characters.go) | _O(n)_ | _O(1)_ | Easy | |  |
| 1933 | [Check if String Is Decomposable Into Value-Equal Substrings](./problems/1933-check-if-string-is-decomposable-into-value-equal-substrings.md) | [Go](./golang/1933_check_if_string_is_decomposable_into_value_equal_substrings.go) | _O(n)_ | _O(1)_ |  Easy | 🔒 |
| 2301 | [Match Substring After Replacement](./problems/2301-match-substring-after-replacement.md) | [Go](./golang/2301_match_substring_after_replacement.go) | _O(n * k)_   | _O(m)_        | Hard         | | Brute Force
| 1698 | [Number of Distinct Substrings in a String](./problems/1698-number-of-distinct-substrings-in-a-string.md) | [Go](./golang/1698_number_of_distinct_substrings_in_a_string.go) | _O(n^2)_ | _O(t)_ | Medium | 🔒 | Trie |

---

### 2. String Matching & Algorithms

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0028 | [Implement strStr()](./problems/0028-implement-strstr.md) | [Go](./golang/0028_implement_strstr.go) | _O(n + k)_   | _O(k)_  | Easy           || `KMP Algorithm`
| 0459 | [Repeated Substring Pattern](./problems/0459-repeated-substring-pattern.md) | [Go](./golang/0459_repeated_substring_pattern.go) | _O(n)_ | _O(n)_ | Easy         || `KMP Algorithm` |
| 0686 | [Repeated String Match](./problems/0686-repeated-string-match.md) | [Go](./golang/0686_repeated_string_match.go) | _O(n + m)_ | _O(1)_ | Easy || `Rabin-Karp Algorithm` |
| 0796 | [Rotate String](./problems/0796-rotate-string.md) | [Go](./golang/0796_rotate_string.go) | _O(n)_ | _O(1)_ | Easy         || `KMP Algorithm`, `Rabin-Karp Algorithm` |
| 1392 | [Longest Happy Prefix](./problems/1392-longest-happy-prefix.md) | [Go](./golang/1392_longest_happy_prefix.go) | _O(n)_ | _O(n)_ | Hard         || `KMP Algorithm`, `Rabin-Karp Algorithm` |
| 1408 | [String Matching in an Array](./problems/1408-string-matching-in-an-array.md) | [Go](./golang/1408_string_matching_in_an_array.go) | _O(n)_ | _O(t)_ | Easy || `KMP Algorithm`, `Aho-Corasick Automata`, Trie |
| 1554 | [Strings Differ by One Character](./problems/1554-strings-differ-by-one-character.md) | [Go](./golang/1554_strings_differ_by_one_character.go) | _O(n * m)_ | _O(n)_ | Medium || `Rabin-Karp Algorithm` |
| 1668 | [Maximum Repeating Substring](./problems/1668-maximum-repeating-substring.md) | [Go](./golang/1668_maximum_repeating_substring.go) | _O(n)_ | _O(m)_ | Easy || `KMP Algorithm` |
| 1910 | [Remove All Occurrences of a Substring](./problems/1910-remove-all-occurrences-of-a-substring.md) | [Go](./golang/1910_remove_all_occurrences_of_a_substring.go) | _O(n + m)_ | _O(n + m)_ | Medium | | `KMP Algorithm` |
| 1967 | [Number of Strings That Appear as Substrings in Word](./problems/1967-number-of-strings-that-appear-as-substrings-in-word.md) | [Go](./golang/1967_number_of_strings_that_appear_as_substrings_in_word.go) | _O(n * l + m)_ | _O(t)_ | Easy || `KMP Algorithm`, `Aho-Corasick Automata`, Trie |
| 2156 | [Find Substring With Given Hash Value](./problems/2156-find-substring-with-given-hash-value.md) | [Go](./golang/2156_find_substring_with_given_hash_value.go) | _O(n)_ | _O(1)_ | Medium | | `Rabin-Karp Algorithm`, Rolling Hash
| 2168 | [Unique Substrings With Equal Digit Frequency](./problems/2168-unique-substrings-with-equal-digit-frequency.md) | [Go](./golang/2168_unique_substrings_with_equal_digit_frequency.go) | _O(n^2)_ | _O(n^2)_ | Medium | 🔒 | `Rabin-Karp Algorithm`, Rolling Hash
| 2223 | [Sum of Scores of Built Strings](./problems/2223-sum-of-scores-of-built-strings.md) | [Go](./golang/2223_sum_of_scores_of_built_strings.go) | _O(n)_   | _O(n)_        | Hard         | | `Z-Function`
| 2416 | [Sum of Prefix Scores of Strings](./problems/2416-sum-of-prefix-scores-of-strings.md) | [Go](./golang/2416_sum_of_prefix_scores_of_strings.go) | _O(n * l)_   | _O(t)_        | Hard         | | Trie
| 2800 | [Shortest String That Contains Three Strings](./problems/2800-shortest-string-that-contains-three-strings.md) | [Go](./golang/2800_shortest_string_that_contains_three_strings.go)| _O(l)_ | _O(l)_ | Medium | | String, Brute Force, Longest Prefix Suffix, `KMP Algorithm` |
| 2851 | [String Transformation](./problems/2851-string-transformation.md) | [Go](./golang/2851_string_transformation.go) | _O(n + logk)_   | _O(n)_        | Hard         | | DP, Matrix Exponentiation, Math, `Z-Function`, `KMP Algorithm`
| 0014 | [Longest Common Prefix](./problems/0014-longest-common-prefix.md) | [Go](./golang/0014_longest_common_prefix.go) | _O(n * k)_   | _O(1)_  | Easy           ||
| 1071 | [Greatest Common Divisor of Strings](./problems/1071-greatest-common-divisor-of-strings.md) | [Go](./golang/1071_greatest_common_divisor_of_strings.go) | _O(m + n)_ | _O(1)_      | Easy         ||

---

### 3. String Manipulation

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0008 | [String to Integer (atoi)](./problems/0008-string-to-integer-atoi.md) | [Go](./golang/0008_string_to_integer_atoi.go) | _O(n)_ | _O(1)_ | Easy      ||
| 0038 | [Count and Say](./problems/0038-count-and-say.md) | [Go](./golang/0038_count_and_say.go)| _O(n * 2^n)_  | _O(2^n)_        | Easy           ||
| 0068 | [Text Justification](./problems/0068-text-justification.md) | [Go](./golang/0068_text_justification.go) | _O(n)_ | _O(1)_      | Hard           ||
| 0415 | [Add Strings](./problems/0415-add-strings.md) | [Go](./golang/0415_add_strings.go) | _O(n)_ | _O(1)_ | Easy         | |
| 0434 | [Number of Segments in a String](./problems/0434-number-of-segments-in-a-string.md) | [Go](./golang/0434_number_of_segments_in_a_string.go) | _O(n)_ | _O(1)_ | Easy         | |
| 0443 | [String Compression](./problems/0443-string-compression.md) | [Go](./golang/0443_string_compression.go) | _O(n)_ | _O(1)_ | Easy         | |
| 0482 | [License Key Formatting](./problems/0482-license-key-formatting.md) | [Go](./golang/0482_license_key_formatting.go) | _O(n)_ | _O(1)_ | Easy | |
| 0520 | [Detect Capital](./problems/0520-detect-capital.md) | [Go](./golang/0520_detect_capital.go) | _O(l)_ | _O(1)_ | Easy         | |
| 0555 | [Split Concatenated Strings](./problems/0555-split-concatenated-strings.md) | [Go](./golang/0555_split_concatenated_strings.go) | _O(n^2)_       | _O(n)_          | Medium         || String |
| 0709 | [To Lower Case](./problems/0709-to-lower-case.md) | [Go](./golang/0709_to_lower_case.go) | _O(n)_       | _O(1)_          | Easy         || String |
| 0833 | [Find And Replace in String](./problems/0833-find-and-replace-in-string.md) | [Go](./golang/0833_find_and_replace_in_string.go) | _O(n + m)_ | _O(n)_ | Medium         |||
| 1119 | [Remove Vowels from a String](./problems/1119-remove-vowels-from-a-string.md) | [Go](./golang/1119_remove_vowels_from_a_string.go) | _O(n)_ | _O(1)_      | Easy         |🔒|
| 1309 | [Decrypt String from Alphabet to Integer Mapping](./problems/1309-decrypt-string-from-alphabet-to-integer-mapping.md) | [Go](./golang/1309_decrypt_string_from_alphabet_to_integer_mapping.go) | _O(n)_ | _O(1)_ | Easy | |
| 1370 | [Increasing Decreasing String](./problems/1370-increasing-decreasing-string.md) | [Go](./golang/1370_increasing_decreasing_string.go) | _O(n)_ | _O(1)_ | Easy | | Sort |
| 1417 | [Reformat The String](./problems/1417-reformat-the-string.md) | [Go](./golang/1417_reformat_the_string.go)| _O(n)_ | _O(1)_ | Easy |||
| 1422 | [Maximum Score After Splitting a String](./problems/1422-maximum-score-after-splitting-a-string.md) | [Go](./golang/1422_maximum_score_after_splitting_a_string.go)| _O(n)_ | _O(1)_ | Easy |||
| 1528 | [Shuffle String](./problems/1528-shuffle-string.md) | [Go](./golang/1528_shuffle_string.go) | _O(n)_ | _O(1)_ | Easy |||
| 1544 | [Make The String Great](./problems/1544-make-the-string-great.md) | [Go](./golang/1544_make_the_string_great.go) | _O(n)_ | _O(1)_ | Easy |||
| 1556 | [Thousand Separator](./problems/1556-thousand-separator.md) | [Go](./golang/1556_thousand_separator.go) | _O(n)_ | _O(1)_ | Easy |||
| 1576 | [Replace All ?'s to Avoid Consecutive Repeating Characters](./problems/1576-replace-all-s-to-avoid-consecutive-repeating-characters.md) | [Go](./golang/1576_replace_all_s_to_avoid_consecutive_repeating_characters.go) | _O(n)_ | _O(1)_ | Easy |||
| 1694 | [Reformat Phone Number](./problems/1694-reformat-phone-number.md) | [Go](./golang/1694_reformat_phone_number.go) | _O(n)_ | _O(1)_ | Easy || Inplace |
| 1768 | [Merge Strings Alternately](./problems/1768-merge-strings-alternately.md) | [Go](./golang/1768_merge_strings_alternately.go) | _O(m + n)_ | _O(1)_ | Easy |||
| 1784 | [Check if Binary String Has at Most One Segment of Ones](./problems/1784-check-if-binary-string-has-at-most-one-segment-of-ones.md) | [Go](./golang/1784_check_if_binary_string_has_at_most_one_segment_of_ones.go) | _O(n)_ | _O(1)_ | Easy |||
| 1805 | [Number of Different Integers in a String](./problems/1805-number-of-different-integers-in-a-string.md) | [Go](./golang/1805_number_of_different_integers_in_a_string.go) | _O(n)_ | _O(n)_ | Easy |||
| 1844 | [Replace All Digits with Characters](./problems/1844-replace-all-digits-with-characters.md) | [Go](./golang/1844_replace_all_digits_with_characters.go) | _O(n)_ | _O(1)_ | Easy |||
| 1903 | [Largest Odd Number in String](./problems/1903-largest-odd-number-in-string.md) | [Go](./golang/1903_largest_odd_number_in_string.go) | _O(n)_ | _O(1)_ | Easy | |  |
| 1957 | [Delete Characters to Make Fancy String](./problems/1957-delete-characters-to-make-fancy-string.md) | [Go](./golang/1957_delete_characters_to_make_fancy_string.go) | _O(n)_ | _O(1)_ | Easy || Inplace
| 2042 | [Check if Numbers Are Ascending in a Sentence](./problems/2042-check-if-numbers-are-ascending-in-a-sentence.md) | [Go](./golang/2042_check_if_numbers_are_ascending_in_a_sentence.go) | _O(n)_ | _O(1)_ | Easy |||
| 2124 | [Check if All A's Appears Before All B's](./problems/2124-check-if-all-as-appears-before-all-bs.md) | [Go](./golang/2124_check_if_all_as_appears_before_all_bs.go) | _O(n)_ | _O(1)_ | Easy |||
| 2129 | [Capitalize the Title](./problems/2129-capitalize-the-title.md) | [Go](./golang/2129_capitalize_the_title.go) | _O(n)_ | _O(1)_ | Easy |||
| 2138 | [Divide a String Into Groups of Size k](./problems/2138-divide-a-string-into-groups-of-size-k.md) | [Go](./golang/2138_divide_a_string_into_groups_of_size_k.go) | _O(n)_ | _O(1)_ | Easy || |
| 2243 | [Calculate Digit Sum of a String](./problems/2243-calculate-digit-sum-of-a-string.md) | [Go](./golang/2243_calculate_digit_sum_of_a_string.go) | _O(n)_   | _O(n)_        | Easy         | | Simulation
| 2255 | [Count Prefixes of a Given String](./problems/2255-count-prefixes-of-a-given-string.md) | [Go](./golang/2255_count_prefixes_of_a_given_string.go) | _O(n * l)_   | _O(1)_        | Easy         | | String
| 2264 | [Largest 3-Same-Digit Number in String](./problems/2264-largest-3-same-digit-number-in-string.md) | [Go](./golang/2264_largest_3_same_digit_number_in_string.go) | _O(n)_   | _O(1)_        | Easy         | | String
| 2278 | [Percentage of Letter in String](./problems/2278-percentage-of-letter-in-string.md) | [Go](./golang/2278_percentage_of_letter_in_string.go) | _O(n)_   | _O(1)_        | Easy         | | String
| 2288 | [Apply Discount to Prices](./problems/2288-apply-discount-to-prices.md) | [Go](./golang/2288_apply_discount_to_prices.go) | _O(n)_   | _O(1)_        | Medium         | | String
| 2315 | [Count Asterisks](./problems/2315-count-asterisks.md) | [Go](./golang/2315_count_asterisks.go) | _O(n)_   | _O(1)_        | Easy         | | String
| 2390 | [Removing Stars From a String](./problems/2390-removing-stars-from-a-string.md) | [Go](./golang/2390_removing_stars_from_a_string.go) | _O(n)_   | _O(n)_        | Medium         | | String, Stack
| 2490 | [Circular Sentence](./problems/2490-circular-sentence.md) | [Go](./golang/2490_circular_sentence.go) | _O(n)_   | _O(1)_        | Easy         | | String
| 2496 | [Maximum Value of a String in an Array](./problems/2496-maximum-value-of-a-string-in-an-array.md) | [Go](./golang/2496_maximum_value_of_a_string_in_an_array.go) | _O(n * l)_   | _O(1)_        | Easy         | | String
| 2575 | [Find the Divisibility Array of a String](./problems/2575-find-the-divisibility-array-of-a-string.md) | [Go](./golang/2575_find_the_divisibility_array_of_a_string.go)| _O(n)_ | _O(1)_ | Medium | | Prefix Sum |
| 2710 | [Remove Trailing Zeros From a String](./problems/2710-remove-trailing-zeros-from-a-string.md) | [Go](./golang/2710_remove_trailing_zeros_from_a_string.go)| _O(n)_ | _O(1)_ | Easy | | String |
| 2788 | [Split Strings by Separator](./problems/2788-split-strings-by-separator.md) | [Go](./golang/2788_split_strings_by_separator.go)| _O(n * l)_ | _O(l)_ | Easy | | String |
| 2810 | [Faulty Keyboard](./problems/2810-faulty-keyboard.md) | [Go](./golang/2810_faulty_keyboard.go)| _O(n)_ | _O(n)_ | Easy | | String, Deque |
| 2937 | [Make Three Strings Equal](./problems/2937-make-three-strings-equal.md) | [Go](./golang/2937_make_three_strings_equal.go)| _O(n)_ | _O(1)_ | Easy | | String |

---

### 4. Parsing & Validation

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0043 | [Multiply Strings](./problems/0043-multiply-strings.md) | [Go](./golang/0043_multiply_strings.go) | _O(m * n)_ | _O(m + n)_  | Medium         ||
| 0242 | [Valid Anagram](./problems/0242-valid-anagram.md) | [Go](./golang/0242_valid_anagram.go) | _O(n)_       | _O(1)_         | Easy         | LintCode |
| 0271 | [Encode and Decode Strings](./problems/0271-encode-and-decode-strings.md) | [Go](./golang/0271_encode_and_decode_strings.go) | _O(n)_ | _O(1)_ | Medium         | 🔒 |
| 0408 | [Valid Word Abbreviation](./problems/0408-valid-word-abbreviation.md) | [Go](./golang/0408_valid_word_abbreviation.go) | _O(n)_ | _O(1)_ | Easy         | 🔒 |
| 0468 | [Validate IP Address](./problems/0468-validate-ip-address.md) | [Go](./golang/0468_validate_ip_address.go) | _O(1)_ | _O(1)_ | Medium         | |
| 0527 | [Word Abbreviation](./problems/0527-word-abbreviation.md) | [Go](./golang/0527_word_abbreviation.go) | _O(n * l)_ ~ _O(n^2 * l^2)_  | _O(n * l)_ | Hard         |🔒|
| 0591 | [Tag Validator](./problems/0591-tag-validator.md) |[Go](./golang/0591_tag_validator.go) | _O(n)_ | _O(n)_ | Hard         | |
| 0678 | [Valid Parenthesis String](./problems/0678-valid-parenthesis-string.md) |[Go](./golang/0678_valid_parenthesis_string.go) | _O(n)_ | _O(1)_ | Medium         | |
| 0751 | [IP to CIDR](./problems/0751-ip-to-cidr.md) | [Go](./golang/0751_ip_to_cidr.go) | _O(n)_ | _O(1)_ | Medium         |||
| 0880 | [Decoded String at Index](./problems/0880-decoded-string-at-index.md) | [Go](./golang/0880_decoded_string_at_index.go) | _O(n)_ | _O(1)_ | Medium ||
| 1108 | [Defanging an IP Address](./problems/1108-defanging-an-ip-address.md) | [Go](./golang/1108_defanging_an_ip_address.go) | _O(n)_ | _O(1)_      | Easy         ||
| 1178 | [Number of Valid Words for Each Puzzle](./problems/1178-number-of-valid-words-for-each-puzzle.md) | [Go](./golang/1178_number_of_valid_words_for_each_puzzle.go) | _O(n * l + m * L)_ | _O(L!)_ | Hard | | Trie, Bit Manipulation
| 1410 | [HTML Entity Parser](./problems/1410-html-entity-parser.md) | [Go](./golang/1410_html_entity_parser.go)| _O(n)_ | _O(t)_ | Medium || `Aho-Corasick Automata`, Trie |
| 1461 | [Check If a String Contains All Binary Codes of Size K](./problems/1461-check-if-a-string-contains-all-binary-codes-of-size-k.md) | [Go](./golang/1461_check_if_a_string_contains_all_binary_codes_of_size_k.go) | _O(n * k)_ | _O(k * 2^k)_ | Medium || Bit Manipulation |
| 1614 | [Maximum Nesting Depth of the Parentheses](./problems/1614-maximum-nesting-depth-of-the-parentheses.md) | [Go](./golang/1614_maximum_nesting_depth_of_the_parentheses.go) | _O(n)_ | _O(1)_ | Easy |||
| 1678 | [Goal Parser Interpretation](./problems/1678-goal-parser-interpretation.md) | [Go](./golang/1678_goal_parser_interpretation.go) | _O(n)_ | _O(1)_ | Easy |||
| 2047 | [Number of Valid Words in a Sentence](./problems/2047-number-of-valid-words-in-a-sentence.md) | [Go](./golang/2047_number_of_valid_words_in_a_sentence.go) | _O(n)_ | _O(1)_ | Easy |||
| 2116 | [Check if a Parentheses String Can Be Valid](./problems/2116-check-if-a-parentheses-string-can-be-valid.md) | [Go](./golang/2116_check_if_a_parentheses_string_can_be_valid.go) | _O(n)_ | _O(1)_ | Medium |||
| 1963 | [Minimum Number of Swaps to Make the String Balanced](./problems/1963-minimum-number-of-swaps-to-make-the-string-balanced.md) | [Go](./golang/1963_minimum_number_of_swaps_to_make_the_string_balanced.go) | _O(n)_ | _O(1)_ | Medium | variant of [Maximum Nesting Depth of the Parentheses](https://leetcode.com/problems/maximum-nesting-depth-of-the-parentheses/) ||

---

### 5. Word & Pattern

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0058 | [Length of Last Word](./problems/0058-length-of-last-word.md) | [Go](./golang/0058_length_of_last_word.go) | _O(n)_   | _O(1)_  | Easy           ||
| 0273 | [Integer to English Words](./problems/0273-integer-to-english-words.md) | [Go](./golang/0273_integer_to_english_words.go) | _O(1)_ | _O(1)_ | Hard         | |
| 0420 | [Strong Password Checker](./problems/0420-strong-password-checker.md) | [Go](./golang/0420_strong_password_checker.go) | _O(n)_ | _O(1)_ | Hard         | |
| 0524 | [Longest Word in Dictionary through Deleting](./problems/0524-longest-word-in-dictionary-through-deleting.md) | [Go](./golang/0524_longest_word_in_dictionary_through_deleting.go) | _O((d * l)  * logd)_ | _O(1)_ | Medium         | | Sort
| 0648 | [Replace Words](./problems/0648-replace-words.md) | [Go](./golang/0648_replace_words.go) | _O(n)_ | _O(t)_ | Medium         || Trie |
| 0720 | [Longest Word in Dictionary](./problems/0720-longest-word-in-dictionary.md) | [Go](./golang/0720_longest_word_in_dictionary.go) | _O(n)_ | _O(t)_ | Easy         || Trie |
| 0804 | [Unique Morse Code Words](./problems/0804-unique-morse-code-words.md) | [Go](./golang/0804_unique_morse_code_words.go) | _O(n)_ | _O(n)_ | Easy         |||
| 0809 | [Expressive Words](./problems/0809-expressive-words.md) | [Go](./golang/0809_expressive_words.go) | _O(n + s)_ | _O(l + s)_ | Medium         |||
| 0819 | [Most Common Word](./problems/0819-most-common-word.md) | [Go](./golang/0819_most_common_word.go) | _O(m + n)_ | _O(m + n)_ | Easy         |||
| 0820 | [Short Encoding of Words](./problems/0820-short-encoding-of-words.md) | [Go](./golang/0820_short_encoding_of_words.go) | _O(n)_ | _O(t)_ | Medium         || Trie |
| 0884 | [Uncommon Words from Two Sentences](./problems/0884-uncommon-words-from-two-sentences.md) | [Go](./golang/0884_uncommon_words_from_two_sentences.go) | _O(m + n)_ | _O(m + n)_ | Easy ||
| 0890 | [Find and Replace Pattern](./problems/0890-find-and-replace-pattern.md) | [Go](./golang/0890_find_and_replace_pattern.go) | _O(n * l)_ | _O(1)_ | Medium ||
| 0916 | [Word Subsets](./problems/0916-word-subsets.md) | [Go](./golang/0916_word_subsets.go) | _O(m + n)_ | _O(1)_ | Medium ||
| 0953 | [Verifying an Alien Dictionary](./problems/0953-verifying-an-alien-dictionary.md) | [Go](./golang/0953_verifying_an_alien_dictionary.go) | _O(n * l)_ | _O(1)_      | Easy         ||
| 1324 | [Print Words Vertically](./problems/1324-print-words-vertically.md) | [Go](./golang/1324_print_words_vertically.go) | _O(n)_ | _O(n)_ | Medium | |
| 1347 | [Minimum Number of Steps to Make Two Strings Anagram](./problems/1347-minimum-number-of-steps-to-make-two-strings-anagram.md) | [Go](./golang/1347_minimum_number_of_steps_to_make_two_strings_anagram.go) | _O(n)_ | _O(1)_ | Medium | |
| 1455 | [Check If a Word Occurs As a Prefix of Any Word in a Sentence](./problems/1455-check-if-a-word-occurs-as-a-prefix-of-any-word-in-a-sentence.md) | [Go](./golang/1455_check_if_a_word_occurs_as_a_prefix_of_any_word_in_a_sentence.go) | _O(n)_ | _O(n)_ | Easy || `KMP Algorithm` |
| 1592 | [Rearrange Spaces Between Words](./problems/1592-rearrange-spaces-between-words.md) | [Go](./golang/1592_rearrange_spaces_between_words.go) | _O(n)_ | _O(1)_ | Easy || Inplace |
| 1858 | [Longest Word With All Prefixes](./problems/1858-longest-word-with-all-prefixes.md) | [Go](./golang/1858_longest_word_with_all_prefixes.go) | _O(n)_ | _O(t)_ | Medium | 🔒 | Trie, DFS |
| 1880 | [Check if Word Equals Summation of Two Words](./problems/1880-check-if-word-equals-summation-of-two-words.md) | [Go](./golang/1880_check_if_word_equals_summation_of_two_words.go) | _O(n)_ | _O(1)_ | Easy | |  |
| 1935 | [Maximum Number of Words You Can Type](./problems/1935-maximum-number-of-words-you-can-type.md) | [Go](./golang/1935_maximum_number_of_words_you_can_type.go) | _O(n)_ | _O(1)_ | Easy | |  |
| 1974 | [Minimum Time to Type Word Using Special Typewriter](./problems/1974-minimum-time-to-type-word-using-special-typewriter.md) | [Go](./golang/1974_minimum_time_to_type_word_using_special_typewriter.go) | _O(n)_ | _O(1)_ | Easy |||
| 2114 | [Maximum Number of Words Found in Sentences](./problems/2114-maximum-number-of-words-found-in-sentences.md) | [Go](./golang/2114_maximum_number_of_words_found_in_sentences.go) | _O(n)_ | _O(1)_ | Easy |||
| 2135 | [Count Words Obtained After Adding a Letter](./problems/2135-count-words-obtained-after-adding-a-letter.md) | [Go](./golang/2135_count_words_obtained_after_adding_a_letter.go) | _O(n)_ | _O(n)_ | Medium || Bitmasks |
| 2185 | [Counting Words With a Given Prefix](./problems/2185-counting-words-with-a-given-prefix.md) | [Go](./golang/2185_counting_words_with_a_given_prefix.go) | _O(n * p)_ | _O(1)_ | Easy | | 
| 2186 | [Minimum Number of Steps to Make Two Strings Anagram II](./problems/2186-minimum-number-of-steps-to-make-two-strings-anagram-ii.md) | [Go](./golang/2186_minimum_number_of_steps_to_make_two_strings_anagram_ii.go) | _O(n)_ | _O(1)_ | Medium | variant of [Minimum Number of Steps to Make Two Strings Anagram](https://leetcode.com/problems/minimum-number-of-steps-to-make-two-strings-anagram/) |
| 2273 | [Find Resultant Array After Removing Anagrams](./problems/2273-find-resultant-array-after-removing-anagrams.md) | [Go](./golang/2273_find_resultant_array_after_removing_anagrams.go) | _O(n * l)_   | _O(1)_        | Easy         | | Freq Table, Sort
| 2299 | [Strong Password Checker II](./problems/2299-strong-password-checker-ii.md) | [Go](./golang/2299_strong_password_checker_ii.go) | _O(n)_   | _O(1)_        | Easy         | | String
| 2828 | [Check if a String Is an Acronym of Words](./problems/2828-check-if-a-string-is-an-acronym-of-words.md) | [Go](./golang/2828_check_if_a_string_is_an_acronym_of_words.go)| _O(n)_ | _O(1)_ | Easy | | String |
| 2942 | [Find Words Containing Character](./problems/2942-find-words-containing-character.md) | [Go](./golang/2942_find_words_containing_character.go)| _O(n * l)_ | _O(1)_ | Easy | | String |

---

### 6. Reverse & Transform

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0006 | [ZigZag Conversion](./problems/0006-zigzag-conversion.md) | [Go](./golang/0006_zigzag_conversion.go) | _O(n)_ | _O(1)_        | Easy           ||
| 0067 | [Add Binary](./problems/0067-add-binary.md) | [Go](./golang/0067_add_binary.go) | _O(n)_          | _O(1)_          | Easy           ||
| 0151 | [Reverse Words in a String](./problems/0151-reverse-words-in-a-string.md) | [Go](./golang/0151_reverse_words_in_a_string.go) | _O(n)_ | _O(1)_ | Medium         ||
| 0186 | [Reverse Words in a String II](./problems/0186-reverse-words-in-a-string-ii.md) |[Go](./golang/0186_reverse_words_in_a_string_ii.go) | _O(n)_ | _O(1)_ | Medium         | 🔒 |
| 0541 | [Reverse String II](./problems/0541-reverse-string-ii.md) | [Go](./golang/0541_reverse_string_ii.go) | _O(n)_ | _O(1)_ | Easy         | |
| 0557 | [Reverse Words in a String III](./problems/0557-reverse-words-in-a-string-iii.md) |[Go](./golang/0557_reverse_words_in_a_string_iii.go) | _O(n)_ | _O(1)_ | Easy         | |
| 0917 | [Reverse Only Letters](./problems/0917-reverse-only-letters.md) | [Go](./golang/0917_reverse_only_letters.go) | _O(n)_ | _O(1)_ | Easy ||
| 2000 | [Reverse Prefix of Word](./problems/2000-reverse-prefix-of-word.md) | [Go](./golang/2000_reverse_prefix_of_word.go) | _O(n)_ | _O(1)_ | Easy |||

---

### 7. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0016 | [One Edit Distance](./problems/0161-one-edit-distance.md) | [Go](./golang/0161_one_edit_distance.go) | _O(m + n)_ | _O(1)_    | Medium         |🔒 |
| 0165 | [Compare Version Numbers](./problems/0165-compare-version-numbers.md) | [Go](./golang/0165_compare_version_numbers.go) | _O(n)_ | _O(1)_ | Easy     ||
| 0306 | [Addictive Number](./problems/0306-additive-number.md) | [Go](./golang/0306_additive_number.go) | _O(n^3)_ | _O(n)_ | Medium         | |
| 0383 | [Ransom Note](./problems/0383-ransom-note.md) | [Go](./golang/0383_ransom_note.go) | _O(n)_ | _O(1)_ | Easy         | EPI |
| 0405 | [Convert a Number to Hexadecimal](./problems/0405-convert-a-number-to-hexadecimal.md) | [Go](./golang/0405_convert_a_number_to_hexadecimal.go) | _O(n)_ | _O(1)_ | Easy         | |
| 0481 | [Magical String](./problems/0481-magical-string.md) | [Go](./golang/0481_magical_string.go) | _O(n)_       | _O(n)_          | Medium         || String |
| 0500 | [Keyboard Row](./problems/0500-keyboard-row.md) | [Go](./golang/0500_keyboard_row.go) | _O(n)_       | _O(1)_          | Easy         || String, Hash |
| 0521 | [Longest Uncommon Subsequence I](./problems/0521-longest-uncommon-subsequence-i.md) | [Go](./golang/0521_longest_uncommon_subsequence_i.go) | _O(min(a, b))_ | _O(1)_ | Easy         | |
| 0522 | [Longest Uncommon Subsequence II](./problems/0522-longest-uncommon-subsequence-ii.md) | [Go](./golang/0522_longest_uncommon_subsequence_ii.go) | _O(l * n^2)_ | _O(1)_ | Medium         | | Sort
| 0539 | [Minimum Time Difference](./problems/0539-minimum-time-difference.md) | [Go](./golang/0539_minimum_time_difference.go) | _O(nlogn)_ | _O(n)_ | Medium         | |
| 0551 | [Student Attendance Record I](./problems/0551-student-attendance-record-i.md) | [Go](./golang/0551_student_attendance_record_i.go) | _O(n)_ | _O(1)_ | Easy |||
| 0556 | [Next Greater Element III](./problems/0556-next-greater-element-iii.md) |[Go](./golang/0556_next_greater_element_iii.go) | _O(1)_ | _O(1)_ | Medium         | |
| 0616 | [Add Bold Tag in String](./problems/0616-add-bold-tag-in-string.md) | [Go](./golang/0616_add_bold_tag_in_string.go) | _O(n * d * l)_ | _O(n)_ |  Medium | 🔒 |
| 0657 | [Robot Return to Origin](./problems/0657-robot-return-to-origin.md) |[Go](./golang/0657_robot_return_to_origin.go) | _O(n)_ | _O(1)_ | Easy         | |
| 0681 | [Next Closest Time](./problems/0681-next-closest-time.md) | [Go](./golang/0681_next_closest_time.go) | _O(1)_  | _O(1)_         | Medium           ||
| 0722 | [Remove Comments](./problems/0722-remove-comments.md) | [Go](./golang/0722_remove_comments.go) | _O(n)_ | _O(k)_ | Medium         |||
| 0791 | [Custom Sort String](./problems/0791-custom-sort-string.md) | [Go](./golang/0791_custom_sort_string.go) | _O(n)_ | _O(1)_ | Medium         |||
| 0806 | [Number of Lines To Write String](./problems/0806-number-of-lines-to-write-string.md) | [Go](./golang/0806_number_of_lines_to_write_string.go) | _O(n)_ | _O(1)_ | Easy         |||
| 0816 | [Ambiguous Coordinates](./problems/0816-ambiguous-coordinates.md) | [Go](./golang/0816_ambiguous_coordinates.go) | _O(n^4)_ | _O(n)_ | Medium         |||
| 0824 | [Goat Latin](./problems/0824-goat-latin.md) | [Go](./golang/0824_goat_latin.go) | _O(n + w^2)_ | _O(l)_ | Easy         |||
| 0831 | [Masking Personal Information](./problems/0831-masking-personal-information.md) | [Go](./golang/0831_masking_personal_information.go) | _O(1)_ | _O(1)_ | Medium         |||
| 0839 | [Similar String Groups](./problems/0839-similar-string-groups.md) | [Go](./golang/0839_similar_string_groups.go) | _O(n^2 * l)_ | _O(n)_ | Hard || Union Find
| 0848 | [Shifting Letters](./problems/0848-shifting-letters.md) | [Go](./golang/0848_shifting_letters.go) | _O(n)_ | _O(1)_ | Medium ||
| 0859 | [Buddy Strings](./problems/0859-buddy-strings.md) | [Go](./golang/0859_buddy_strings.go) | _O(n)_ | _O(1)_ | Easy ||
| 0893 | [Groups of Special-Equivalent Strings](./problems/0893-groups-of-special-equivalent-strings.md) | [Go](./golang/0893_groups_of_special_equivalent_strings.go) | _O(n * l)_ | _O(n)_ | Easy ||
| 0925 | [Long Pressed Name](./problems/0925-long-pressed-name.md) | [Go](./golang/0925_long_pressed_name.go) | _O(n)_ | _O(1)_ | Easy ||
| 0929 | [Unique Email Addresses](./problems/0929-unique-email-addresses.md) | [Go](./golang/0929_unique_email_addresses.go) | _O(n * l)_ | _O(n * l)_ | Easy ||
| 0939 | [Minimum Area Rectangle](./problems/0939-minimum-area-rectangle.md) | [Go](./golang/0939_minimum_area_rectangle.go) | _O(n^1.5)_ on average | _O(n)_ | Medium ||
| 0942 | [DI String Match](./problems/0942-di-string-match.md) | [Go](./golang/0942_di_string_match.go) | _O(n)_ | _O(1)_      | Easy         ||
| 0944 | [Delete Columns to Make Sorted](./problems/0944-delete-columns-to-make-sorted.md) | [Go](./golang/0944_delete_columns_to_make_sorted.go) | _O(n * l)_ | _O(1)_      | Medium         ||
| 0955 | [Delete Columns to Make Sorted II](./problems/0955-delete-columns-to-make-sorted-ii.md) | [Go](./golang/0955_delete_columns_to_make_sorted_ii.go) | _O(n * l)_ | _O(n)_      | Medium         ||
| 1023 | [Camelcase Matching](./problems/1023-camelcase-matching.md) | [Go](./golang/1023_camelcase_matching.go) | _O(n * l)_ | _O(1)_      | Medium         ||
| 1056 | [Confusing Number](./problems/1056-confusing-number.md) | [Go](./golang/1056_confusing_number.go) | _O(logn)_ | _O(logn)_ |  Easy | 🔒 |
| 1061 | [Lexicographically Smallest Equivalent String](./problems/1061-lexicographically-smallest-equivalent-string.md) | [Go](./golang/1061_lexicographically_smallest_equivalent_string.go) | _O(n)_ | _O(n)_ |  Medium | 🔒 | Union Find
| 1078 | [Occurrences After Bigram](./problems/1078-occurrences-after-bigram.md) | [Go](./golang/1078_occurrences_after_bigram.go) | _O(n)_ | _O(1)_      | Easy         ||
| 1189 | [Maximum Number of Balloons](./problems/1189-maximum-number-of-balloons.md) | [Go](./golang/1189_maximum_number_of_balloons.go) | _O(n)_ | _O(1)_ | Easy | | Hash
| 1233 | [Remove Sub-Folders from the Filesystem](./problems/1233-remove-sub-folders-from-the-filesystem.md) | [Go](./golang/1233_remove_sub_folders_from_the_filesystem.go) | _O(n)_ | _O(t)_ | Medium | | Trie
| 1271 | [Hexspeak](./problems/1271-hexspeak.md) | [Go](./golang/1271_hexspeak.go) | _O(n)_ | _O(1)_ | Easy | |
| 1374 | [Generate a String With Characters That Have Odd Count](./problems/1374-generate-a-string-with-characters-that-have-odd-counts.md) | [Go](./golang/1374_generate_a_string_with_characters_that_have_odd_counts.go) | _O(n)_ | _O(1)_ | Easy | |
| 1436 | [Destination City](./problems/1436-destination-city.md) | [Go](./golang/1436_destination_city.go)| _O(n)_ | _O(n)_ | Easy |||
| 1446 | [Consecutive Characters](./problems/1446-consecutive-characters.md) | [Go](./golang/1446_consecutive_characters.go)| _O(n)_ | _O(1)_ | Easy |||
| 1496 | [Path Crossing](./problems/1496-path-crossing.md) | [Go](./golang/1496_path_crossing.go) | _O(n)_ | _O(n)_ | Easy |||
| 1507 | [Reformat Date](./problems/1507-reformat-date.md) | [Go](./golang/1507_reformat_date.go) | _O(n)_ | _O(1)_ | Easy |||
| 1529 | [Bulb Switcher IV](./problems/1529-bulb-switcher-iv.md) | [Go](./golang/1529_bulb_switcher_iv.go) | _O(n)_ | _O(1)_ | Medium |||
| 1540 | [Can Convert String in K Moves](./problems/1540-can-convert-string-in-k-moves.md) | [Go](./golang/1540_can_convert_string_in_k_moves.go) | _O(n)_ | _O(1)_ | Medium |||
| 1545 | [Find Kth Bit in Nth Binary String](./problems/1545-find-kth-bit-in-nth-binary-string.md) | [Go](./golang/1545_find_kth_bit_in_nth_binary_string.go) | _O(n)_ | _O(1)_ | Medium |||
| 1573 | [Number of Ways to Split a String](./problems/1573-number-of-ways-to-split-a-string.md) | [Go](./golang/1573_number_of_ways_to_split_a_string.go) | _O(n)_ | _O(1)_ | Medium |||
| 1598 | [Crawler Log Folder](./problems/1598-crawler-log-folder.md) | [Go](./golang/1598_crawler_log_folder.go) | _O(n)_ | _O(1)_ | Easy |||
| 1662 | [Check If Two String Arrays are Equivalent](./problems/1662-check-if-two-string-arrays-are-equivalent.md) | [Go](./golang/1662_check_if_two_string_arrays_are_equivalent.go) | _O(n)_ | _O(1)_ | Easy |||
| 1684 | [Count the Number of Consistent Strings](./problems/1684-count-the-number-of-consistent-strings.go) | [Go](./golang/1684_count_the_number_of_consistent_strings.go) | _O(n)_ | _O(1)_ | Easy |||
| 1704 | [Determine if String Halves Are Alike](./problems/1704-determine-if-string-halves-are-alike.md) | [Go](./golang/1704_determine_if_string_halves_are_alike.go) | _O(n)_ | _O(1)_ | Easy |||
| 1790 | [Check if One String Swap Can Make Strings Equal](./problems/1790-check-if-one-string-swap-can-make-strings-equal.md) | [Go](./golang/1790_check_if_one_string_swap_can_make_strings_equal.go) | _O(n)_ | _O(1)_ | Easy |||
| 1796 | [Second Largest Digit in a String](./problems/1796-second-largest-digit-in-a-string.md) | [Go](./golang/1796_second_largest_digit_in_a_string.go) | _O(n)_ | _O(1)_ | Easy |||
| 1813 | [Sentence Similarity III](./problems/1813-sentence-similarity-iii.md) | [Go](./golang/1813_sentence_similarity_iii.go) | _O(n)_ | _O(1)_ | Medium |||
| 1816 | [Truncate Sentence](./problems/1816-truncate-sentence.md) | [Go](./golang/1816_truncate_sentence.go) | _O(n)_ | _O(1)_ | Easy |||
| 1832 | [Check if the Sentence Is Pangram](./problems/1832-check-if-the-sentence-is-pangram.md) | [Go](./golang/1832_check_if_the_sentence_is_pangram.go) | _O(n)_ | _O(1)_ | Easy |||
| 1854 | [Maximum Population Year](./problems/1854-maximum-population-year.md) | [Go](./golang/1854_maximum_population_year.go) | _O(n)_ | _O(1)_ | Easy || Line Sweep |
| 1961 | [Check If String Is a Prefix of Array](./problems/1961-check-if-string-is-a-prefix-of-array.md) | [Go](./golang/1961_check_if_string_is_a_prefix_of_array.go) | _O(n)_ | _O(1)_ | Easy ||
| 2048 | [Next Greater Numerically Balanced Number](./problems/2048-next-greater-numerically-balanced-number.md) | [Go](./golang/2048_next_greater_numerically_balanced_number.go) | _O(1)_ | _O(1)_ | Medium || Permutations, Precompute, Binary Search |
| 2103 | [Rings and Rods](./problems/2103-rings-and-rods.md) | [Go](./golang/2103_rings_and_rods.go) | _O(n)_ | _O(1)_ | Easy || |
| 2109 | [Adding Spaces to a String](./problems/2109-adding-spaces-to-a-string.md) | [Go](./golang/2109_adding_spaces_to_a_string.go) | _O(n)_ | _O(1)_ | Medium || Inplace |
| 2157 | [Groups of Strings](./problems/2157-groups-of-strings.md) | [Go](./golang/2157_groups_of_strings.go) | _O(26 * n)_ | _O(26 * n)_ | Hard | | Bitmasks, Union Find
| 2211 | [Count Collisions on a Road](./problems/2211-count-collisions-on-a-road.md) | [Go](./golang/2211_count_collisions_on_a_road.go) | _O(n)_ | _O(1)_ | Medium | | Counting, Simulation
| 2232 | [Minimize Result by Adding Parentheses to Expression](./problems/2232-minimize-result-by-adding-parentheses-to-expression.md) | [Go](./golang/2232_minimize_result_by_adding_parentheses_to_expression.go) | _O(n^2)_   | _O(1)_        | Medium         | | Brute Force
| 2269 | [Find the K-Beauty of a Number](./problems/2269-find-the-k-beauty-of-a-number.md) | [Go](./golang/2269_find_the_k_beauty_of_a_number.go) | _O(logn)_   | _O(logn)_        | Easy         | | Sliding Window
| 2381 | [Shifting Letters II](./problems/2381-shifting-letters-ii.md) | [Go](./golang/2381_shifting_letters_ii.go) | _O(n)_   | _O(n)_        | Medium         | | Line Sweep
| 2586 | [Count the Number of Vowel Strings in Range](./problems/2586-count-the-number-of-vowel-strings-in-range.md) | [Go](./golang/2586_count_the_number_of_vowel_strings_in_range.go)| _O(n)_ | _O(1)_ | Medium | | String |
| 2678 | [Number of Senior Citizens](./problems/2678-number-of-senior-citizens.md) | [Go](./golang/2678_number_of_senior_citizens.go)| _O(n)_ | _O(1)_ | Easy | | String |
| 2729 | [Check if The Number is Fascinating](./problems/2729-check-if-the-number-is-fascinating.md) | [Go](./golang/2729_check_if_the_number_is_fascinating.go)| _O(logn)_ | _O(1)_ | Easy | | String, Bitmasks |
| 2843 | [Count Symmetric Integers](./problems/2843-count-symmetric-integers.md) | [Go](./golang/2843_count_symmetric_integers.go)| _O(rlogr)_ | _O(r)_ | Easy | | String, Brute Force, Memoization |

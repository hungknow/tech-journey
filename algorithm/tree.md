## Tree

### 1. Morris Traversal (O(1) Space Tree Traversal)

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0094 | [Binary Tree Inorder Traversal](https://leetcode.com/problems/binary-tree-inorder-traversal/) | [C++](./C++/binary-tree-inorder-traversal.cpp) [Python](./Python/binary-tree-inorder-traversal.py) | _O(n)_ | _O(1)_ | Medium | | Uses thread modification to traverse without stack |
| 0099 | [Recover Binary Search Tree](https://leetcode.com/problems/recover-binary-search-tree/) | [C++](./C++/recover-binary-search-tree.cpp) [Python](./Python/recover-binary-search-tree.py) | _O(n)_ | _O(1)_ | Hard | | Inorder traversal to find swapped nodes |
| 0144 | [Binary Tree Preorder Traversal](https://leetcode.com/problems/binary-tree-preorder-traversal/) | [C++](./C++/binary-tree-preorder-traversal.cpp) [Python](./Python/binary-tree-preorder-traversal.py) | _O(n)_ | _O(1)_ | Medium | | Thread-based preorder traversal |
| 0145 | [Binary Tree Postorder Traversal](https://leetcode.com/problems/binary-tree-postorder-traversal/) | [C++](./C++/binary-tree-postorder-traversal.cpp) [Python](./Python/binary-tree-postorder-traversal.py) | _O(n)_ | _O(1)_ | Hard | | Thread-based postorder traversal |

---

### 2. Trie (Prefix Tree)

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0208 | [Implement Trie (Prefix Tree)](https://leetcode.com/problems/implement-trie-prefix-tree/) | [C++](./C++/implement-trie-prefix-tree.cpp) [Python](./Python/implement-trie-prefix-tree.py) | _O(n)_ | _O(1)_ | Medium | | Each node has 26 children; prefix search O(length) |
| 0211 | [Add and Search Word - Data structure design](https://leetcode.com/problems/add-and-search-word-data-structure-design/) | [C++](./C++/add-and-search-word-data-structure-design.cpp) [Python](./Python/add-and-search-word-data-structure-design.py) | _O(min(n, h))_ | _O(min(n, h))_ | Medium | Trie, DFS | Supports '.' wildcard with DFS |
| 0677 | [Map Sum Pairs](https://leetcode.com/problems/map-sum-pairs/) | [C++](./C++/map-sum-pairs.cpp) [Python](./Python/map-sum-pairs.py) | _O(n)_ | _O(t)_ | Medium | | Trie with value aggregation at nodes |

---

### 3. Tree Traversals (DFS/BFS)

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0429 | [N-ary Tree Level Order Traversal](https://leetcode.com/problems/n-ary-tree-level-order-traversal/) | [C++](./C++/n-ary-tree-level-order-traversal.cpp) [Python](./Python/n-ary-tree-level-order-traversal.py) | _O(n)_ | _O(w)_ | Medium | | BFS level by level |
| 0589 | [N-ary Tree Preorder Traversal](https://leetcode.com/problems/n-ary-tree-preorder-traversal/) | [C++](./C++/n-ary-tree-preorder-traversal.cpp) [Python](./Python/n-ary-tree-preorder-traversal.py) | _O(n)_ | _O(h)_ | Easy | | DFS: root, then children recursively |
| 0590 | [N-ary Tree Postorder Traversal](https://leetcode.com/problems/n-ary-tree-postorder-traversal/) | [C++](./C++/n-ary-tree-postorder-traversal.cpp) [Python](./Python/n-ary-tree-postorder-traversal.py) | _O(n)_ | _O(h)_ | Medium | | DFS: children first, then root |
| 0958 | [Check Completeness of a Binary Tree](https://leetcode.com/problems/check-completeness-of-a-binary-tree/) | [C++](./C++/check-completeness-of-a-binary-tree.cpp) [Python](./Python/check-completeness-of-a-binary-tree.py) | _O(n)_ | _O(w)_ | Medium | | BFS; check for gaps in level order |
| 0637 | [Average of Levels in Binary Tree](https://leetcode.com/problems/average-of-levels-in-binary-tree/) | [C++](./C++/average-of-levels-in-binary-tree.cpp) [Python](./Python/average-of-levels-in-binary-tree.py) | _O(n)_ | _O(h)_ | Easy | | BFS; sum and count nodes per level |

---

### 4. BST Operations & Properties

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0501 | [Find Mode in Binary Search Tree](https://leetcode.com/problems/find-mode-in-binary-search-tree/) | [C++](./C++/find-mode-in-binary-search-tree.cpp) [Python](./Python/find-mode-in-binary-search-tree.py) | _O(n)_ | _O(1)_ | Easy | Tree, Inorder Traversal | Inorder gives sorted order; track consecutive counts |
| 0538 | [Convert BST to Greater Tree](https://leetcode.com/problems/convert-bst-to-greater-tree/) | [C++](./C++/convert-bst-to-greater-tree.cpp) [Python](./Python/convert-bst-to-greater-tree.py) | _O(n)_ | _O(h)_ | Easy | | Reverse inorder: right, node, left |
| 0653 | [Two Sum IV - Input is a BST](https://leetcode.com/problems/two-sum-iv-input-is-a-bst/) | [C++](./C++/two-sum-iv-input-is-a-bst.cpp) [Python](./Python/two-sum-iv-input-is-a-bst.py) | _O(n)_ | _O(h)_ | Easy | Two Pointers | Inorder to sorted array + two pointers |
| 0700 | [Search in a Binary Search Tree](https://leetcode.com/problems/search-in-a-binary-search-tree/) | [C++](./C++/search-in-a-binary-search-tree.cpp) [Python](./Python/search-in-a-binary-search-tree.py) | _O(h)_ | _O(1)_ | Easy | Tree | Standard BST search: compare and go left/right |
| 0701 | [Insert into a Binary Search Tree](https://leetcode.com/problems/insert-into-a-binary-search-tree/) | [C++](./C++/insert-into-a-binary-search-tree.cpp) [Python](./Python/insert-into-a-binary-search-tree.py) | _O(h)_ | _O(1)_ | Medium | Tree | Find leaf position and insert |
| 0897 | [Increasing Order Search Tree](https://leetcode.com/problems/increasing-order-search-tree/) | [C++](./C++/increasing-order-search-tree.cpp) [Python](./Python/increasing-order-search-tree.py) | _O(n)_ | _O(h)_ | Easy | DFS | Inorder traversal; restructure to right-skewed |
| 0938 | [Range Sum of BST](https://leetcode.com/problems/range-sum-of-bst/) | [C++](./C++/range-sum-of-bst.cpp) [Python](./Python/range-sum-of-bst.py) | _O(n)_ | _O(h)_ | Medium | DFS | Prune branches outside range |

---

### 5. Tree Serialization/Deserialization

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0297 | [Serialize and Deserialize Binary Tree](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/) | [C++](./C++/serialize-and-deserialize-binary-tree.cpp) [Python](./Python/serialize-and-deserialize-binary-tree.py) | _O(n)_ | _O(h)_ | Hard | LintCode, DFS | Preorder with null markers |
| 0428 | [Serialize and Deserialize N-ary Tree](https://leetcode.com/problems/serialize-and-deserialize-n-ary-tree/) | [C++](./C++/serialize-and-deserialize-n-ary-tree.cpp) [Python](./Python/serialize-and-deserialize-n-ary-tree.py) | _O(n)_ | _O(h)_ | Hard | 🔒 | Encode child count for each node |
| 0431 | [Encode N-ary Tree to Binary Tree](https://leetcode.com/problems/encode-n-ary-tree-to-binary-tree/) | [C++](./C++/encode-n-ary-tree-to-binary-tree.cpp) [Python](./Python/encode-n-ary-tree-to-binary-tree.py) | _O(n)_ | _O(h)_ | Hard | 🔒 | Left child = first child, right child = next sibling |
| 0430 | [Flatten a Multilevel Doubly Linked List](https://leetcode.com/problems/flatten-a-multilevel-doubly-linked-list/) | [C++](./C++/flatten-a-multilevel-doubly-linked-list.cpp) [Python](./Python/flatten-a-multilevel-doubly-linked-list.py) | _O(n)_ | _O(1)_ | Medium | | Treat child as next, flatten recursively |
| 0426 | [Convert Binary Search Tree to Sorted Doubly Linked List](https://leetcode.com/problems/convert-binary-search-tree-to-sorted-doubly-linked-list/) | [C++](./C++/convert-binary-search-tree-to-sorted-doubly-linked-list.cpp) [Python](./Python/convert-binary-search-tree-to-sorted-doubly-linked-list.py) | _O(n)_ | _O(h)_ | Medium | 🔒 | Inorder traversal; link left and right pointers |

---

### 6. Tree Construction

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0427 | [Construct Quad Tree](https://leetcode.com/problems/construct-quad-tree/) | [C++](./C++/construct-quad-tree.cpp) [Python](./Python/construct-quad-tree.py) | _O(n)_ | _O(h)_ | Medium | | Divide and conquer; check if all values same |
| 0536 | [Construct Binary Tree from String](https://leetcode.com/problems/construct-binary-tree-from-string/) | [C++](./C++/construct-binary-tree-from-string.cpp) [Python](./Python/construct-binary-tree-from-string.py) | _O(n)_ | _O(h)_ | Medium | 🔒 | Parse parentheses recursively |
| 0654 | [Maximum Binary Tree](https://leetcode.com/problems/maximum-binary-tree/) | [C++](./C++/maximum-binary-tree.cpp) [Python](./Python/maximum-binary-tree.py) | _O(n)_ | _O(n)_ | Medium | LintCode, Mono Stack, Cartesian Tree | Max is root; recursively build left/right |
| 0889 | [Construct Binary Tree from Preorder and Postorder Traversal](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-postorder-traversal/) | [C++](./C++/construct-binary-tree-from-preorder-and-postorder-traversal.cpp) [Python](./Python/construct-binary-tree-from-preorder-and-postorder-traversal.py) | _O(n)_ | _O(h)_ | Medium | DFS, Stack | Multiple valid trees possible |
| 0919 | [Complete Binary Tree Inserter](https://leetcode.com/problems/complete-binary-tree-inserter/) | [C++](./C++/complete-binary-tree-inserter.cpp) [Python](./Python/complete-binary-tree-inserter.py) | ctor: _O(n)_, insert: _O(1)_, get_root: _O(1)_ | _O(n)_ | Medium | | Use deque to track insertion points |
| 0998 | [Maximum Binary Tree II](https://leetcode.com/problems/maximum-binary-tree-ii/) | [C++](./C++/maximum-binary-tree-ii.cpp) [Python](./Python/maximum-binary-tree-ii.py) | _O(h)_ | _O(1)_ | Medium | Cartesian Tree | Insert new max at right; restructure |

---

### 7. Tree Properties & Metrics

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0543 | [Diameter of Binary Tree](https://leetcode.com/problems/diameter-of-binary-tree/) | [C++](./C++/diameter-of-binary-tree.cpp) [Python](./Python/diameter-of-binary-tree.py) | _O(n)_ | _O(h)_ | Easy | | Max of left+right heights at each node |
| 0563 | [Binary Tree Tilt](https://leetcode.com/problems/binary-tree-tilt/) | [C++](./C++/binary-tree-tilt.cpp) [Python](./Python/binary-tree-tilt.py) | _O(n)_ | _O(n)_ | Easy | | Sum of absolute differences of subtree sums |
| 0559 | [Maximum Depth of N-ary Tree](https://leetcode.com/problems/maximum-depth-of-n-ary-tree/) | [C++](./C++/maximum-depth-of-n-ary-tree.cpp) [Python](./Python/maximum-depth-of-n-ary-tree.py) | _O(n)_ | _O(h)_ | Easy | Tree, DFS | 1 + max(child depths) |
| 0662 | [Maximum Width of Binary Tree](https://leetcode.com/problems/maximum-width-of-binary-tree/) | [C++](./C++/maximum-width-of-binary-tree.cpp) [Python](./Python/maximum-width-of-binary-tree.py) | _O(n)_ | _O(h)_ | Medium | DFS | Assign index; width = last - first + 1 per level |
| 0687 | [Longest Univalue Path](https://leetcode.com/problems/longest-univalue-path/) | [C++](./C++/longest-univalue-path.cpp) [Python](./Python/longest-univalue-path.py) | _O(n)_ | _O(h)_ | Easy | | Path through same-valued nodes |
| 0965 | [Univalued Binary Tree](https://leetcode.com/problems/univalued-binary-tree/) | [C++](./C++/univalued-binary-tree.cpp) [Python](./Python/univalued-binary-tree.py) | _O(n)_ | _O(h)_ | Easy | DFS | All nodes have same value |

---

### 8. Tree Modification

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0226 | [Invert Binary Tree](https://leetcode.com/problems/invert-binary-tree/) | [C++](./C++/invert-binary-tree.cpp) [Python](./Python/invert-binary-tree.py) | _O(n)_ | _O(h)_, _O(w)_ | Easy | | Swap left and right children recursively |
| 0617 | [Merge Two Binary Trees](https://leetcode.com/problems/merge-two-binary-trees/) | [C++](./C++/merge-two-binary-trees.cpp) [Python](./Python/merge-two-binary-trees.py) | _O(n)_ | _O(h)_ | Easy | | Sum values; create new node or use existing |
| 0623 | [Add One Row to Tree](https://leetcode.com/problems/add-one-row-to-tree/) | [C++](./C++/add-one-row-to-tree.cpp) [Python](./Python/add-one-row-to-tree.py) | _O(n)_ | _O(h)_ | Medium | | BFS to depth d-1; insert new row |
| 0814 | [Binary Tree Pruning](https://leetcode.com/problems/binary-tree-pruning/) | [C++](./C++/binary-tree-pruning.cpp) [Python](./Python/binary-tree-pruning.py) | _O(n)_ | _O(h)_ | Medium | DFS | Remove subtrees without 1 |
| 0971 | [Flip Binary Tree To Match Preorder Traversal](https://leetcode.com/problems/flip-binary-tree-to-match-preorder-traversal/) | [C++](./C++/flip-binary-tree-to-match-preorder-traversal.cpp) [Python](./Python/flip-binary-tree-to-match-preorder-traversal.py) | _O(n)_ | _O(h)_ | Medium | DFS | Try flip if value doesn't match |
| 0979 | [Distribute Coins in Binary Tree](https://leetcode.com/problems/distribute-coins-in-binary-tree/) | [C++](./C++/distribute-coins-in-binary-tree.cpp) [Python](./Python/distribute-coins-in-binary-tree.py) | _O(n)_ | _O(h)_ | Medium | DFS | Count moves to balance each subtree |

---

### 9. Tree Search & Validation

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0572 | [Subtree of Another Tree](https://leetcode.com/problems/subtree-of-another-tree/) | [C++](./C++/subtree-of-another-tree.cpp) [Python](./Python/subtree-of-another-tree.py) | _O(m * n)_ | _O(h)_ | Easy | | Check if t matches any subtree of s |
| 0951 | [Flip Equivalent Binary Trees](https://leetcode.com/problems/flip-equivalent-binary-trees/) | [C++](./C++/flip-equivalent-binary-trees.cpp) [Python](./Python/flip-equivalent-binary-trees.py) | _O(n)_ | _O(h)_ | Medium | DFS | Same structure with optional flips |
| 0993 | [Cousins in Binary Tree](https://leetcode.com/problems/cousins-in-binary-tree/) | [C++](./C++/cousins-in-binary-tree.cpp) [Python](./Python/cousins-in-binary-tree.py) | _O(n)_ | _O(h)_ | Easy | DFS | Same depth but different parent |

---

### 10. Tree Path & Distance Problems

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0513 | [Find Bottom Left Tree Value](https://leetcode.com/problems/find-bottom-left-tree-value/) | [C++](./C++/find-bottom-left-tree-value.cpp) [Python](./Python/find-bottom-left-tree-value.py) | _O(n)_ | _O(h)_ | Medium | Tree, DFS, BFS | BFS right-to-left; last node is bottom-left |
| 0545 | [Boundary of Binary Tree](https://leetcode.com/problems/boundary-of-binary-tree/) | [C++](./C++/boundary-of-binary-tree.cpp) [Python](./Python/boundary-of-binary-tree.py) | _O(n)_ | _O(h)_ | Medium | 🔒 | Left boundary, leaves, right boundary |
| 0863 | [All Nodes Distance K in Binary Tree](https://leetcode.com/problems/all-nodes-distance-k-in-binary-tree/) | [C++](./C++/all-nodes-distance-k-in-binary-tree.cpp) [Python](./Python/all-nodes-distance-k-in-binary-tree.py) | _O(n)_ | _O(n)_ | Medium | DFS + BFS | Build parent map; BFS from target |
| 0865 | [Smallest Subtree with all the Deepest Nodes](https://leetcode.com/problems/smallest-subtree-with-all-the-deepest-nodes/) | [C++](./C++/smallest-subtree-with-all-the-deepest-nodes.cpp) [Python](./Python/smallest-subtree-with-all-the-deepest-nodes.py) | _O(n)_ | _O(h)_ | Medium | DFS | Return LCA of deepest nodes |
| 0988 | [Smallest String Starting From Leaf](https://leetcode.com/problems/smallest-string-starting-from-leaf/) | [C++](./C++/smallest-string-starting-from-leaf.cpp) [Python](./Python/smallest-string-starting-from-leaf.py) | _O(n + l * h)_ | _O(h)_ | Medium | DFS | Build strings from leaf to root; keep smallest |

---

### 11. Tree with Hash/Map

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0508 | [Most Frequent Subtree Sum](https://leetcode.com/problems/most-frequent-subtree-sum/) | [C++](./C++/most-frequent-subtree-sum.cpp) [Python](./Python/most-frequent-subtree-sum.py) | _O(n)_ | _O(n)_ | Medium | Tree, DFS, Hash | Map stores `sum -> frequency` |
| 0652 | [Find Duplicate Subtrees](https://leetcode.com/problems/find-duplicate-subtrees/) | [C++](./C++/find-duplicate-subtrees.cpp) [Python](./Python/find-duplicate-subtrees.py) | _O(n)_ | _O(n)_ | Medium | DFS, Hash | Serialize subtree as key; track duplicates |
| 0663 | [Equal Tree Partition](https://leetcode.com/problems/equal-tree-partition/) | [C++](./C++/equal-tree-partition.cpp) [Python](./Python/equal-tree-partition.py) | _O(n)_ | _O(n)_ | Medium | 🔒, Hash | Check if any subtree sum = total/2 |

---

### 12. Segment Tree / BIT / Fenwick Tree

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0307 | [Range Sum Query - Mutable](https://leetcode.com/problems/range-sum-query-mutable/) | [C++](./C++/range-sum-query-mutable.cpp) [Python](./Python/range-sum-query-mutable.py) | ctor: _O(n)_, update: _O(logn)_, query: _O(logn)_ | _O(n)_ | Medium | LintCode, DFS, Segment Tree, BIT, Fenwick Tree | Point updates, range sum queries |
| 0308 | [Range Sum Query 2D - Mutable](https://leetcode.com/problems/range-sum-query-2d-mutable/) | [C++](./C++/range-sum-query-2d-mutable.cpp) [Python](./Python/range-sum-query-2d-mutable.py) | ctor: _O(m * n)_, update: _O(logm * logn)_, query: _O(logm * logn)_ | _O(m * n)_ | Hard | 🔒, DFS, Quad Tree, 2D BIT, 2D Fenwick Tree | 2D range queries |
| 0315 | [Count of Smaller Numbers After Self](https://leetcode.com/problems/count-of-smaller-numbers-after-self/) | [C++](./C++/count-of-smaller-numbers-after-self.cpp) [Python](./Python/count-of-smaller-numbers-after-self.py) | _O(nlogn)_ | _O(n)_ | Hard | LintCode, BST, BIT, Fenwick Tree, Divide and Conquer, Merge Sort | Count smaller elements to the right |
| 0699 | [Falling Squares](https://leetcode.com/problems/falling-squares/) | [C++](./C++/falling-squares.cpp) [Python](./Python/falling-squares.py) | _O(nlogn)_ | _O(n)_ | Hard | Segment Tree | Track max height in intervals |
| 0850 | [Rectangle Area II](https://leetcode.com/problems/rectangle-area-ii/) | [C++](./C++/rectangle-area-ii.cpp) [Python](./Python/rectangle-area-ii.py) | _O(nlogn)_ | _O(n)_ | Hard | Segment Tree | Sweep line with segment tree |

---

### 13. Quad Tree

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0427 | [Construct Quad Tree](https://leetcode.com/problems/construct-quad-tree/) | [C++](./C++/construct-quad-tree.cpp) [Python](./Python/construct-quad-tree.py) | _O(n)_ | _O(h)_ | Medium | | Divide grid into 4 quadrants recursively |
| 0558 | [Logical OR of Two Binary Grids Represented as Quad-Trees](https://leetcode.com/problems/logical-or-of-two-binary-grids-represented-as-quad-trees/) | [C++](./C++/logical-or-of-two-binary-grids-represented-as-quad-trees.cpp) [Python](./Python/logical-or-of-two-binary-grids-represented-as-quad-trees.py) | _O(n)_ | _O(h)_ | Medium | Tree, Divide and Conquer | Merge two quad trees with OR operation |

---

### 14. Union Find (Disjoint Set)

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0684 | [Redundant Connection](https://leetcode.com/problems/redundant-connection/) | [C++](./C++/redundant-connection.cpp) [Python](./Python/redundant-connection.py) | _O(n)_ | _O(n)_ | Medium | Union Find | Find edge that creates cycle |
| 0685 | [Redundant Connection II](https://leetcode.com/problems/redundant-connection-ii/) | [C++](./C++/redundant-connection-ii.cpp) [Python](./Python/redundant-connection-ii.py) | _O(n)_ | _O(n)_ | Hard | Union Find | Directed graph; handle two cases |

---

### 15. Tree String Operations & Display

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0606 | [Construct String from Binary Tree](https://leetcode.com/problems/construct-string-from-binary-tree/) | [C++](./C++/construct-string-from-binary-tree.cpp) [Python](./Python/construct-string-from-binary-tree.py) | _O(n)_ | _O(h)_ | Easy | | Preorder with parentheses for null children |
| 0655 | [Print Binary Tree](https://leetcode.com/problems/print-binary-tree/) | [C++](./C++/print-binary-tree.cpp) [Python](./Python/print-binary-tree.py) | _O(n)_ | _O(h)_ | Medium | | Calculate positions; print with spacing |
| 0987 | [Vertical Order Traversal of a Binary Tree](https://leetcode.com/problems/vertical-order-traversal-of-a-binary-tree/) | [C++](./C++/vertical-order-traversal-of-a-binary-tree.cpp) [Python](./Python/vertical-order-traversal-of-a-binary-tree.py) | _O(nlogn)_ | _O(n)_ | Medium | DFS | Map `col -> (row, val)`; sort by row then val |

---

### 16. Other Tree Problems

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|---------------- | --------------- | --------------- | --------------- | ------------- |--------------|-----|
| 0525 | [Contiguous Array](https://leetcode.com/problems/contiguous-array/) | [C++](./C++/contiguous-array.cpp) [Python](./Python/contiguous-array.py) | _O(n)_ | _O(n)_ | Medium | | Map prefix sum; 0=-1, 1=1 |
| 0529 | [Minesweeper](https://leetcode.com/problems/minesweeper/) | [C++](./C++/minesweeper.cpp) [Python](./Python/minesweeper.py) | _O(m * n)_ | _O(m + n)_ | Medium | | DFS/BFS to reveal cells |
| 0548 | [Split Array with Equal Sum](https://leetcode.com/problems/split-array-with-equal-sum/) | [C++](./C++/split-array-with-equal-sum.cpp) [Python](./Python/split-array-with-equal-sum.py) | _O(n^2)_ | _O(n)_ | Medium | 🔒 | Find indices i<j<k with equal sums |

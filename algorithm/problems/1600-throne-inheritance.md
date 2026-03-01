# 1600 Throne Inheritance

## Problem Description

A kingdom consists of a king, his children, their children, and so on. The kingdom is represented as a tree where the king is the root.

When a king dies, his first child becomes the new king, and the first child of that child becomes the crown prince, and so on.

The inheritance order is defined as:
1. The current king
2. The first child of the current king (if any)
3. The first child of the first child (if any)
4. And so on until we reach a king with no children
5. Then we go back to the previous level and visit the second child (if any)
6. Then the first child of the second child
7. And so on

Implement the `ThroneInheritance` class:

- `ThroneInheritance(string kingName)` Initializes the object with the name of the king.
- `void birth(string parentName, string childName)` Indicates that `parentName` gave birth to `childName`.
- `void death(string name)` Indicates the death of `name`. The death of a person doesn't affect the inheritance order.
- `string[] getInheritanceOrder()` Returns a list representing the inheritance order.

### Example 1:
```
Input
["ThroneInheritance","birth","birth","birth","birth","birth","birth","getInheritanceOrder","death","getInheritanceOrder"]
[["king"],["king","andrew"],["king","bob"],["king","catherine"],["andrew","matthew"],["bob","alex"],[],["bob"],[]]
Output
[null,null,null,null,null,null,null,["king","andrew","matthew","bob","alex","catherine"],["king","andrew","matthew","alex","catherine"]]

Explanation
ThroneInheritance t = new ThroneInheritance("king"); // inheritance order: ["king"]
t.birth("king", "andrew");         // inheritance order: ["king", "andrew"]
t.birth("king", "bob");           // inheritance order: ["king", "andrew", "bob"]
t.birth("king", "catherine");     // inheritance order: ["king", "andrew", "bob", "catherine"]
t.birth("andrew", "matthew");     // inheritance order: ["king", "andrew", "matthew", "bob", "catherine"]
t.birth("bob", "alex");           // inheritance order: ["king", "andrew", "matthew", "bob", "alex", "catherine"]
t.getInheritanceOrder();           // ["king", "andrew", "matthew", "bob", "alex", "catherine"]
t.death("bob");                  // inheritance order: ["king", "andrew", "matthew", "alex", "catherine"]
t.getInheritanceOrder();           // ["king", "andrew", "matthew", "alex", "catherine"]
```

## The Twist

Implementing a monarchy inheritance system that tracks family relationships and generates the proper inheritance order, handling deaths appropriately.

## Algorithm

### Tree + DFS Approach:
1. Use a HashMap to represent the family tree (parent -> list of children)
2. Use a HashSet to track deceased members
3. For ThroneInheritance(kingName):
   - Initialize with the king as the root
4. For birth(parentName, childName):
   - Add childName to the children list of parentName
5. For death(name):
   - Add name to the deceased set
6. For getInheritanceOrder():
   - Perform a pre-order traversal of the family tree starting from the king
   - Skip deceased members
   - Return the traversal order

The key insight is using a pre-order traversal to naturally follow the inheritance order and simply skipping deceased members.

## Complexity

- **Time**: 
  - ThroneInheritance constructor: O(1)
  - birth: O(1)
  - death: O(1)
  - getInheritanceOrder: O(n) where n is the number of family members
- **Space**: O(n) where n is the number of family members

## Solution Code

```go
package main

type ThroneInheritance struct {
	king      string
	family    map[string][]string
	deceased  map[string]bool
}

func Constructor(kingName string) ThroneInheritance {
	return ThroneInheritance{
		king:     kingName,
		family:   make(map[string][]string),
		deceased: make(map[string]bool),
	}
}

func (this *ThroneInheritance) Birth(parentName string, childName string)  {
	this.family[parentName] = append(this.family[parentName], childName)
}

func (this *ThroneInheritance) Death(name string)  {
	this.deceased[name] = true
}

func (this *ThroneInheritance) GetInheritanceOrder() []string {
	result := make([]string, 0)
	this.dfs(this.king, &result)
	return result
}

func (this *ThroneInheritance) dfs(current string, result *[]string) {
	// Skip deceased members
	if !this.deceased[current] {
		*result = append(*result, current)
	}
	
	// Visit children in birth order
	for _, child := range this.family[current] {
		this.dfs(child, result)
	}
}

/**
 * Your ThroneInheritance object will be instantiated and called as such:
 * obj := Constructor(kingName);
 * obj.Birth(parentName,childName);
 * obj.Death(name);
 * param_3 := obj.GetInheritanceOrder();
 */
```

## Link

[LeetCode 1600 Throne Inheritance](https://leetcode.com/problems/throne-inheritance/)
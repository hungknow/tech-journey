# 0433 Minimum Genetic Mutation

## Problem Description

A gene string is a sequence of nucleotides. There are 8 possible genes: `['A', 'C', 'G', 'T']`.

You are given the start gene, end gene, and a bank of genes. Each gene in the bank is unique.

You can mutate a single character in the gene string at a time. Each mutation must be a gene in the bank.

Return the minimum number of mutations needed to mutate from start to end. If it's impossible, return -1.

### Example 1:
```
Input: start = "AACCGGTT", end = "AACCGGTA", bank = ["AACCGGTA"]
Output: 1
```

### Example 2:
```
Input: start = "AACCGGTT", end = "AAACGGTA", bank = ["AACCGGTA","AACCGCTA","AAACGGTA"]
Output: 2
```

## Approach

This problem can be solved using BFS to find the shortest path in the gene mutation graph:

1. **Graph Construction**:
   - Each gene is a node
   - Two genes are connected if they differ by exactly one character
   - Only genes in the bank (plus start) are valid nodes

2. **BFS Traversal**:
   - Start BFS from the start gene
   - For each gene, generate all possible single mutations
   - Track visited genes to avoid cycles

3. **Early Termination**: When we reach the end gene, return the current distance

## Solution Code

```go
func minMutation(start string, end string, bank []string) bool {
    // Convert bank to a set for O(1) lookup
    bankSet := make(map[string]bool)
    for _, gene := range bank {
        bankSet[gene] = true
    }
    
    // If end gene is not in bank, it's impossible
    if !bankSet[end] {
        return -1
    }
    
    // BFS setup
    queue := []string{start}
    visited := make(map[string]bool)
    visited[start] = true
    mutations := 0
    
    // Possible nucleotides
    nucleotides := []byte{'A', 'C', 'G', 'T'}
    
    for len(queue) > 0 {
        levelSize := len(queue)
        
        for i := 0; i < levelSize; i++ {
            current := queue[0]
            queue = queue[1:]
            
            if current == end {
                return mutations
            }
            
            // Generate all possible single mutations
            for j := 0; j < len(current); j++ {
                original := current[j]
                
                for _, nuc := range nucleotides {
                    if nuc == original {
                        continue
                    }
                    
                    mutated := current[:j] + string(nuc) + current[j+1:]
                    
                    if bankSet[mutated] && !visited[mutated] {
                        visited[mutated] = true
                        queue = append(queue, mutated)
                    }
                }
            }
        }
        
        mutations++
    }
    
    return -1
}
```

## Complexity Analysis

- **Time**: O(N * M * 4) where N is the number of genes in the bank and M is the gene length
  - For each gene, we generate M * 4 possible mutations
  - Each mutation check is O(1) with the hash set
- **Space**: O(N) for the bank set and visited set

## Link

[LeetCode 0433 Minimum Genetic Mutation](https://leetcode.com/problems/minimum-genetic-mutation/)
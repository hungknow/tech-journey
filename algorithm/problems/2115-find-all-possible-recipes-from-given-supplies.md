# 2115 Find All Possible Recipes from Given Supplies

## Problem Description

You are given `recipes` where `recipes[i] = [ingredients, supplies]` represents a recipe that can be made using `ingredients`. Each `ingredients[i]` is a string representing an ingredient.

You are also given `supplies` which contains all available ingredients.

Return all recipes that can be made from the given supplies. The answer can be returned in any order.

### Example 1:
```
Input: recipes = [["bread","tomato","oil","salt","flour"], ["sandwich","meat","bread"]], supplies = ["tomato","oil","salt"]
Output: ["sandwich"]
```

### Example 2:
```
Input: recipes = [["bread","tomato","oil","salt","flour"], ["sandwich","meat","bread"]], supplies = ["tomato","oil","salt","flour"]
Output: ["sandwich","bread"]
```

## Approach

This problem can be solved using topological sorting:

1. **Graph Construction**: Build a directed graph from recipes where each ingredient is a node and each recipe is a directed edge.

2. **Topological Sort**: Use Kahn's algorithm to find a topological order of ingredients.

3. **Recipe Processing**:
   - For each recipe, check if all ingredients are available
   - If yes, add the recipe to the result

## Solution Code

```go
func findAllRecipes(recipes [][]string, supplies []string) []string {
    // Build graph and in-degree array
    ingredientMap := make(map[string]bool)
    for _, supply := range supplies {
        ingredientMap[supply] = true
    }
    
    graph := make(map[string][]string)
    inDegree := make(map[string]int)
    
    for _, recipe := range recipes {
        ingredients, result := recipe[0], recipe[1]
        
        for _, ingredient := range ingredients {
            if !ingredientMap[ingredient] {
                inDegree[ingredient]++
            }
        }
        
        for _, ingredient := range ingredients {
            graph[ingredients[0]] = append(graph[ingredients[0]], ingredient)
        }
    }
    
    // Initialize queue with ingredients having in-degree 0
    queue := []string{}
    for ingredient := range inDegree {
        if inDegree[ingredient] == 0 {
            queue = append(queue, ingredient)
        }
    }
    
    // Process ingredients in topological order
    order := []string{}
    for len(queue) > 0 {
        ingredient := queue[0]
        queue = queue[1:]
        order = append(order, ingredient)
        
        // Reduce in-degree for all dependent ingredients
        for _, dependent := range graph[ingredient] {
            inDegree[dependent]--
            if inDegree[dependent] == 0 {
                queue = append(queue, dependent)
            }
        }
    }
    
    // Check which recipes can be made
    result := []string{}
    for _, recipe := range recipes {
        canMake := true
        for _, ingredient := range recipe[0] {
            if !ingredientMap[ingredient] {
                canMake = false
                break
            }
        }
        
        if canMake {
            result = append(result, recipe[1])
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(R × I + S) where R is the number of recipes, I is the average number of ingredients, and S is the number of supplies
  - Building graph: O(R × I)
  - Topological sort: O(I + S)
  - Recipe checking: O(R × I)
- **Space**: O(I + S) for the graph and in-degree map

## Link

[LeetCode 2115 Find All Possible Recipes from Given Supplies](https://leetcode.com/problems/find-all-possible-recipes-from-given-supplies/)
# 2353 Design a Food Rating System

## Problem Description

Design a food rating system that can rate food items and return the highest-rated items for a given cuisine.

Implement the `FoodRatings` class:

- `FoodRatings(string[] foods, string[] cuisines, int[] ratings)` Initializes the system with the given foods, cuisines, and ratings.
- `void changeRating(string food, int newRating)` Changes the rating of the given food.
- `string highestRated(string cuisine)` Returns the highest-rated food item for the given cuisine.

### Example 1:
```
Input
["FoodRatings","changeRating","highestRated","changeRating","highestRated","changeRating","highestRated"]
[["kimchi","french","japanese"], ["mexican"], [9,5,9,8,10]]
Output
[null,null,null,null,null,null,null]

Explanation
FoodRatings fr = new FoodRatings(["kimchi","french","japanese"], ["mexican"], [9,5,9,8,10]);
fr.changeRating("kimchi", 8); // change rating of "kimchi" from 9 to 8
fr.changeRating("japanese", 6); // change rating of "japanese" from 5 to 6
fr.highestRated("mexican"); // return "kimchi", highest rated Mexican food is "kimchi" with rating 8
fr.highestRated("japanese"); // return "japanese", highest rated Japanese food is "japanese" with rating 6
fr.highestRated("french");   // return null, no French food in the system
```

## The Twist

Implementing a food rating system that efficiently tracks food ratings by cuisine and can quickly retrieve the highest-rated item.

## Algorithm

### HashMap + TreeSet Approach:
1. Use a HashMap of HashMaps to store food ratings by cuisine
2. For each cuisine, maintain a TreeSet of foods sorted by rating
3. For FoodRatings(foods, cuisines, ratings):
   - Initialize data structures
4. For changeRating(food, newRating):
     - Update the rating in the HashMap
     - Update the TreeSet for the cuisine
5. For highestRated(cuisine):
     - Return the highest rated food for the given cuisine

The key insight is using HashMaps for O(1) updates and TreeSets for O(logn) retrieval of highest rated items.

## Complexity

- **Time**: 
  - FoodRatings constructor: O(n) where n is the number of foods
  - changeRating: O(logn) where n is the number of foods for the cuisine
  - highestRated: O(1) for TreeMap lookup
- **Space**: O(n) where n is the number of foods

## Solution Code

```go
package main

import (
	"container/heap"
)

type Food struct {
	name     string
	cuisine  string
	rating  int
}

type FoodRatings struct {
	foods      map[string]*Food
	cuisines    map[string]map[int]*Food
	ratingSets  map[string]*IntHeap
}

func Constructor(foods []string, cuisines []string, ratings []int) FoodRatings {
	foods := make(map[string]*Food)
	cuisines := make(map[string]map[int]*Food)
	ratingSets := make(map[string]*IntHeap)
	
	for i, food := range foods {
		foods[food] = &Food{
			name:    food,
			cuisine: cuisines[i],
			rating:  ratings[i],
		}
		
		cuisine := cuisines[i]
		if _, exists := cuisines[cuisine]; !exists {
			cuisines[cuisine] = make(map[int]*Food)
		}
		
		cuisines[cuisine][food] = foods[food]
		
		// Create max-heap for this cuisine
		maxHeap := &IntHeap{}
		heap.Init(maxHeap)
		heap.Push(maxHeap, foods[food])
		ratingSets[cuisine] = maxHeap
	}
	
	return FoodRatings{
		foods:      foods,
		cuisines:    cuisines,
		ratingSets:  ratingSets,
	}
}

func (this *FoodRatings) ChangeRating(food string, newRating int)  {
	if f, exists := this.foods[food]; exists {
		oldRating := f.rating
		f.rating = newRating
		
		// Update rating in the map
		this.foods[food] = f
		
		// Update the heap for the cuisine
		if heap, exists := this.ratingSets[f.cuisine]; exists {
			// Remove old rating
			heap.Remove(f)
			
			// Add new rating
			f.rating = newRating
			heap.Push(heap, f)
			this.ratingSets[f.cuisine] = heap
		}
	}
}

func (this *FoodRatings) HighestRated(cuisine string) string {
	if heap, exists := this.ratingSets[cuisine]; exists && heap.Len() > 0 {
		return heap.Peek().(*Food).name
	}
	
	return ""
}

/**
 * Your FoodRatings object will be instantiated and called as such:
 * obj := Constructor(foods,cuisines,ratings);
 * param_1 := obj.ChangeRating(food,newRating);
 * param_2 := obj.HighestRated(cuisine);
 */
```

## Link

[LeetCode 2353 Design a Food Rating System](https://leetcode.com/problems/design-a-food-rating-system/)
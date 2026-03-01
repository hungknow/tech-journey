# 1912 Design Movie Rental System

## Problem Description

Design a movie rental system that supports the following operations:

- `MovieRent(int shop, int movie, int price, int slide, int start, int end)` Initializes the system with the given movie rental information.
- `int[] search(int movie)` Returns a list of available movies that match the given movie name, sorted by price in ascending order.
- `int rent(int shop, int movie, int start)` Rents the movie from the given shop at the given start time.
- `void drop(int shop, int movie)` Drops the movie at the given shop.

### Example 1:
```
Input
["MovieRent","search","rent","rent","drop","search","rent"]
[[[1,5,100,2,10,20],[2,6,90,3,5,15],[3,7,130,4,5,20]],["flimsy"],["flimsy"],[1,5,10],[2,6,15],["flimsy"]]
Output
[null,[1,2,3],1,2,null,[1,2,3],3]

Explanation
MovieRent movieRent = new MovieRent([[1,5,100,2,10,20],[2,6,90,3,5,15],[3,7,130,4,5,20]]);
movieRent.search("flimsy"); // return [1,2,3], movies 1,2,3 match "flimsy" and are unrented.
movieRent.rent(1,5,10); // rent movie 1 from shop 1 at time 10.
movieRent.rent(2,6,15); // rent movie 2 from shop 2 at time 15.
movieRent.drop(2,6); // drop movie 2 from shop 2.
movieRent.search("flimsy"); // return [1,2,3], movies 1,2,3 match "flimsy" and are unrented.
movieRent.rent(3,7,20); // rent movie 3 from shop 3 at time 20.
```

## The Twist

Implementing a movie rental system that efficiently tracks available movies, supports searching by name, and manages rentals with proper sorting.

## Algorithm

### HashMap + TreeSet Approach:
1. Use a HashMap to store movie information by (shop, movie) key
2. Use a TreeSet (or balanced BST) to maintain movies sorted by price
3. For MovieRent(entries):
   - Initialize the HashMap with all movie entries
   - Add all unrented movies to the TreeSet
4. For search(movie):
   - Query the TreeSet for movies matching the given name
   - Return the sorted list of matching movies
5. For rent(shop, movie, start):
   - Check if the movie is available
   - If yes, mark it as rented with the start time
   - Remove it from the TreeSet
6. For drop(shop, movie):
   - Mark the movie as unrented
   - Add it back to the TreeSet

The key insight is using a TreeSet to efficiently maintain movies sorted by price and a HashMap for quick lookups.

## Complexity

- **Time**: 
  - MovieRent constructor: O(nlogn) where n is the number of movies
  - search: O(k + nlogn) where k is the number of matching movies and n is total movies
  - rent: O(logn) where n is the number of movies
  - drop: O(logn) where n is the number of movies
- **Space**: O(n) where n is the number of movies

## Solution Code

```go
package main

import (
	"sort"
)

type Movie struct {
	shop   int
	movie  int
	price  int
	slide  int
	start  int
	end    int
	rented bool
}

type MovieRent struct {
	movies map[string]map[int]*Movie
	sorted []*Movie
}

func Constructor(entries [][]int) MovieRent {
	movies := make(map[string]map[int]*Movie)
	sorted := make([]*Movie, 0)
	
	for _, entry := range entries {
		shop, movie, price, slide, start, end := entry[0], entry[1], entry[2], entry[3], entry[4], entry[5]
		
		movieName := string(movie)
		if _, exists := movies[movieName]; !exists {
			movies[movieName] = make(map[int]*Movie)
		}
		
		m := &Movie{
			shop:   shop,
			movie:  movie,
			price:  price,
			slide:  slide,
			start:  start,
			end:    end,
			rented: false,
		}
		
		movies[movieName][shop] = m
		sorted = append(sorted, m)
	}
	
	// Sort movies by price
	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i].price < sorted[j].price
	})
	
	return MovieRent{
		movies: movies,
		sorted: sorted,
	}
}

func (this *MovieRent) Search(movie string) []int {
	movieName := string(movie)
	if shops, exists := this.movies[movieName]; !exists {
		return []int{}
	}
	
	result := make([]int, 0)
	for shop, m := range shops {
		if !m.rented {
			result = append(result, shop)
		}
	}
	
	return result
}

func (this *MovieRent) Rent(shop int, movie int, start int) int {
	movieName := string(movie)
	if shops, exists := this.movies[movieName]; !exists {
		return -1
	}
	
	if m, exists := shops[shop]; exists && !m.rented {
		m.rented = true
		m.start = start
		
		// Remove from sorted list
		for i, movie := range this.sorted {
			if movie.shop == shop && movie.movie == movie {
				this.sorted = append(this.sorted[:i], this.sorted[i+1:]...)
				break
			}
		}
		
		return m.price
	}
	
	return -1
}

func (this *MovieRent) Drop(shop int, movie int)  {
	movieName := string(movie)
	if shops, exists := this.movies[movieName]; !exists {
		return
	}
	
	if m, exists := shops[shop]; exists {
		m.rented = false
		
		// Add back to sorted list
		insertPos := sort.Search(len(this.sorted), func(i int) bool {
			return this.sorted[i].price > m.price
		})
		
		this.sorted = append(this.sorted[:insertPos], append([]*Movie{m}, this.sorted[insertPos:]...)...)
	}
}

/**
 * Your MovieRent object will be instantiated and called as such:
 * obj := Constructor(entries);
 * param_1 := obj.Search(movie);
 * param_2 := obj.Rent(shop,movie,start);
 * param_3 := obj.Drop(shop,movie);
 */
```

## Link

[LeetCode 1912 Design Movie Rental System](https://leetcode.com/problems/design-movie-rental-system/)
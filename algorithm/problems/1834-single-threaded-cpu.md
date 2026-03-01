# Single-Threaded CPU

## Problem Description

You are given `n` tasks labeled from `0` to `n-1` represented by a 2D integer array `tasks`, where `tasks[i] = [enqueueTimei, processingTimei]` means that the `i`th task will be available to process at `enqueueTimei` and will take `processingTimei` to finish processing.

You have a single-threaded CPU that can process at most one task at a time and will act in the following way:

- If the CPU is idle and there are no available tasks, the CPU remains idle.
- If the CPU is idle and there are available tasks, the CPU will choose the one with the shortest processing time. If multiple tasks have the same shortest processing time, it will choose the task with the smallest index.
- Once a task is started, the CPU will process the entire task without stopping.
- The CPU can finish a task then start a new one instantly.

Return the order in which the CPU will process the tasks.

**Example 1:**
```
Input: tasks = [[1,2],[2,4],[3,2],[4,1]]
Output: [0,2,3,1]
Explanation: 
- At time = 1, task 0 is available. CPU processes task 0 for 2 units.
- At time = 3, tasks 1, 2, 3 are available. Task 2 has the shortest processing time, so CPU processes task 2 for 2 units.
- At time = 5, tasks 1, 3 are available. Task 3 has the shortest processing time, so CPU processes task 3 for 1 unit.
- At time = 6, only task 1 is available. CPU processes task 1 for 4 units.
```

**Example 2:**
```
Input: tasks = [[7,10],[7,4],[7,6],[7,1]]
Output: [3,1,2,0]
Explanation: 
- At time = 7, all tasks are available. Task 3 has the shortest processing time, so CPU processes task 3 for 1 unit.
- At time = 8, tasks 0, 1, 2 are available. Task 1 has the shortest processing time, so CPU processes task 1 for 4 units.
- At time = 12, tasks 0, 2 are available. Task 2 has the shortest processing time, so CPU processes task 2 for 6 units.
- At time = 18, only task 0 is available. CPU processes task 0 for 10 units.
```

**Constraints:**
- 1 <= tasks.length <= 10^5
- 1 <= enqueueTimei, processingTimei <= 10^9

## The Twist

This is a scheduling problem that requires simulating a CPU with a single thread. The key insight is to use a min-heap (priority queue) to efficiently select the next task to process based on processing time and index.

## Algorithm

### Approach: Simulation with Min-Heap

1. Sort tasks by enqueue time
2. Use a min-heap to store available tasks, ordered by processing time and index
3. Simulate the CPU:
   - At each time step, add all tasks that become available to the heap
   - If the heap is not empty, pop the task with the shortest processing time (and smallest index if tie)
   - Process the task and advance time
   - If the heap is empty, jump to the next task's enqueue time
4. Record the order of processed tasks

```go
func getOrder(tasks [][]int) []int {
    n := len(tasks)
    
    // Sort tasks by enqueue time
    sortedTasks := make([][]int, n)
    for i, task := range tasks {
        sortedTasks[i] = []int{task[0], task[1], i}
    }
    sort.Slice(sortedTasks, func(i, j int) bool {
        return sortedTasks[i][0] < sortedTasks[j][0]
    })
    
    // Min-heap: [processingTime, index]
    heap := &MinHeap{}
    heap.Init()
    
    result := make([]int, 0, n)
    time := 0
    taskIndex := 0
    
    for len(result) < n {
        // Add all tasks that are available at current time
        for taskIndex < n && sortedTasks[taskIndex][0] <= time {
            heap.Push(sortedTasks[taskIndex][1], sortedTasks[taskIndex][2])
            taskIndex++
        }
        
        if heap.Len() > 0 {
            // Process the task with shortest processing time
            processingTime, index := heap.Pop()
            result = append(result, index)
            time += processingTime
        } else if taskIndex < n {
            // Jump to next task's enqueue time
            time = sortedTasks[taskIndex][0]
        }
    }
    
    return result
}

type MinHeap struct {
    items [][]int // [processingTime, index]
}

func (h *MinHeap) Init() {
    h.items = make([][]int, 0)
}

func (h *MinHeap) Len() int {
    return len(h.items)
}

func (h *MinHeap) Less(i, j int) bool {
    if h.items[i][0] != h.items[j][0] {
        return h.items[i][0] < h.items[j][0]
    }
    return h.items[i][1] < h.items[j][1]
}

func (h *MinHeap) Swap(i, j int) {
    h.items[i], h.items[j] = h.items[j], h.items[i]
}

func (h *MinHeap) Push(processingTime, index int) {
    h.items = append(h.items, []int{processingTime, index})
    h.up(len(h.items) - 1)
}

func (h *MinHeap) Pop() (int, int) {
    n := len(h.items)
    h.Swap(0, n-1)
    h.down(0)
    item := h.items[n-1]
    h.items = h.items[:n-1]
    return item[0], item[1]
}

func (h *MinHeap) up(i int) {
    for i > 0 {
        parent := (i - 1) / 2
        if h.Less(i, parent) {
            h.Swap(i, parent)
            i = parent
        } else {
            break
        }
    }
}

func (h *MinHeap) down(i int) {
    n := len(h.items)
    for {
        left := 2*i + 1
        right := 2*i + 2
        smallest := i
        
        if left < n && h.Less(left, smallest) {
            smallest = left
        }
        if right < n && h.Less(right, smallest) {
            smallest = right
        }
        
        if smallest != i {
            h.Swap(i, smallest)
            i = smallest
        } else {
            break
        }
    }
}
```

## Complexity

- **Time Complexity:** O(n log n) - Sorting takes O(n log n), and each heap operation takes O(log n)
- **Space Complexity:** O(n) - For the heap and the result array

## Link

[LeetCode 1834 - Single-Threaded CPU](https://leetcode.com/problems/single-threaded-cpu/)

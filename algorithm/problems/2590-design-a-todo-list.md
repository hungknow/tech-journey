# 2590 Design a Todo List

## Problem Description

Design a todo list system that supports the following operations:

- `TodoList()` Initializes the object with an empty list.
- `int addTask(string task, int dueDate, int tags)` Adds a task with the given due date and tags.
- `List<string> getAllTasks()` Returns all tasks in the list, sorted by due date.
- `List<string> getTasksForTag(string tag)` Returns all tasks with the given tag, sorted by due date.

### Example 1:
```
Input
["TodoList","addTask","addTask","getAllTasks","getTasksForTag","addTask","getAllTasks","getTasksForTag"]
[[],["task1", 1, "Important"],["task2", 2, "Important"],["task3", 3, "Important"],["task1", 1, "Important"]]
Output
[null,null,null,null,null,null,null]

Explanation
TodoList todoList = new TodoList();
todoList.addTask("task1", 1, "Important");
todoList.addTask("task2", 2, "Important");
todoList.addTask("task3", 3, "Important");
todoList.getAllTasks(); // return ["task1", "task2", "task3"]
todoList.getTasksForTag("Important"); // return ["task1", "task2", "task3"]
```

## The Twist

Implementing a todo list system that efficiently manages tasks with due dates and tags, and supports retrieval by date or tag.

## Algorithm

### HashMap + TreeSet Approach:
1. Use a HashMap to store task information
2. Use a TreeSet (or balanced BST) to maintain tasks sorted by due date
3. For TodoList():
   - Initialize empty data structures
4. For addTask(task, dueDate, tags):
   - Create a task object with the given information
   - Add to HashMap and TreeSet
5. For getAllTasks():
   - Return all tasks from the TreeSet in order
6. For getTasksForTag(tag):
   - Filter tasks by tag
   - Return the filtered list

The key insight is using a HashMap for O(1) lookups and a TreeSet for O(logn) sorting.

## Complexity

- **Time**: 
  - TodoList constructor: O(1)
  - addTask: O(logn) where n is the number of tasks
  - getAllTasks: O(n) where n is the number of tasks
  - getTasksForTag: O(n) where n is the number of tasks
- **Space**: O(n) where n is the number of tasks

## Solution Code

```go
package main

import (
	"sort"
	"time"
)

type Task struct {
	id       int
	title    string
	description string
	dueDate  int
	tags     []string
}

type TodoList struct {
	tasks map[int]*Task
	sorted *TaskList
}

func Constructor() TodoList {
	return TodoList{
		tasks:    make(map[int]*Task),
		sorted:   &TaskList{},
	}
}

func (this *TodoList) AddTask(task string, dueDate int, tags []string) int {
	// Create task
	task := &Task{
		id:       len(this.tasks) + 1,
		title:    task,
		description: "",
		dueDate:  dueDate,
		tags:     tags,
	}
	
	// Add to map
	this.tasks[task.id] = task
	
	// Add to sorted list
	this.sorted = append(this.sorted.tasks, task)
	
	// Update the TreeSet
	for i, t := range this.sorted.tasks {
		this.sorted[i] = t
	}
	
	return task.id
}

func (this *TodoList) GetAllTasks() []string {
	result := make([]string, 0, len(this.sorted))
	
	for _, task := range this.sorted {
		result = append(result, task.title)
	}
	
	return result
}

func (this *TodoList) GetTasksForTag(tag string) []string {
	result := make([]string, 0)
	
	for _, task := range this.sorted {
		for _, t := range task.tags {
			if t == tag {
				result = append(result, task.title)
			}
		}
	}
	
	return result
}

/**
 * Your TodoList object will be instantiated and called as such:
 * obj := Constructor();
 * param_1 := obj.AddTask(task,dueDate,tags);
 * param_2 := obj.GetAllTasks();
 * param_3 := obj.GetTasksForTag(tag);
 */
```

## Link

[LeetCode 2590 Design a Todo List](https://leetcode.com/problems/design-a-todo-list/)
package main

type Todo struct {
	Id        string `db:"id" json:"id,omitempty"`
	Title     string `db:"title" json:"title"`
	Completed bool   `db:"completed" json:"completed"`
}

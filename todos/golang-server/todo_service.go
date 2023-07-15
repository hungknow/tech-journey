package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"

	"github.com/google/uuid"
	"github.com/pkg/errors"
)

type TodoService interface {
	Add(ctx context.Context, todo *Todo) (*Todo, error)
	Update(ctx context.Context, todo *Todo) (*Todo, error)
	Destroy(ctx context.Context, todoID string) (*Todo, error)
}

type TodoSvcImpl struct {
	db *sql.DB
}

func NewTodoSvcImpl(db *sql.DB) *TodoSvcImpl {
	return &TodoSvcImpl{
		db: db,
	}
}

func (o *TodoSvcImpl) Add(ctx context.Context, todo *Todo) (*Todo, error) {
	if todo.Id == "" {
		todo.Id = uuid.NewString()
	}

	stmt, err := o.db.PrepareContext(ctx, fmt.Sprintf("INSERT INTO %s(id, title, completed) VALUES(?, ?, ?)", TableNameTodo))
	if err != nil {
		return nil, errors.WithStack(err)
	}

	sqlResult, err := stmt.ExecContext(ctx, todo.Id, todo.Title, todo.Completed)
	if err != nil {
		return nil, errors.WithStack(err)
	}
	rowAffected, err := sqlResult.RowsAffected()
	if err != nil {
		log.Fatal(err)
	} else {
		if rowAffected != 1 {
			return nil, errors.Errorf("Not insert for todo id %s", todo.Id)
		}
	}

	return todo, nil
}

package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
)

func printPwd() {
	path, err := os.Getwd()
	if err != nil {
		log.Println(err)
	}
	fmt.Println(path)
}

func main() {
	dbConfig, err := LoadDBConfig([]string{"../config", "./config"})
	if err != nil {
		log.Panic(err)
	}

	// Create the Postgres Connection
	db, err := sql.Open("postgres", dbConfig.DbUrl)
	if err != nil {
		log.Panic(err)
	}
	defer func() {
		db.Close()
	}()

	// Create the Postgres driver for migration
	pgDriver, err := postgres.WithInstance(db, &postgres.Config{})
	if err != nil {
		log.Panic(err)
	}

	sqlPath, err := filepath.Abs(dbConfig.SqlPath)
	if err != nil {
		log.Panic(err)
	}
	log.Printf("sqlPath: %v\n", sqlPath)

	m, err := migrate.NewWithDatabaseInstance(
		fmt.Sprintf("file://%v", sqlPath),
		"postgres",
		pgDriver)
	if err != nil {
		log.Panic(err)
	}

	if err = m.Up(); err != nil && err != migrate.ErrNoChange {
		log.Panic(err)
	}
}

package main

import (
	"database/sql"
	"log"

	"github.com/erikdenisrs97/masterbank/api"
	db "github.com/erikdenisrs97/masterbank/db/sqlc"
	"github.com/erikdenisrs97/masterbank/util"
	_ "github.com/lib/pq"
)

func main() {
	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load configurations:", err)
	}
	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to database:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("cannot start server:", err)
	}

}

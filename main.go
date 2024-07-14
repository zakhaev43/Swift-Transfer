package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/lib/pq"

	"github.com/zakhaev43/Swift-Transfer/api"
	db "github.com/zakhaev43/Swift-Transfer/db/sqlc"
	"github.com/zakhaev43/Swift-Transfer/util"
)

func main() {

	config, err := util.LoadConfig(".")

	if err != nil {

		log.Fatal("cannot load config file:", err)
	}
	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	fmt.Printf("The length of TokenSymmetricKey is: %d\n", len(config.TokenSymmetricKey))
	server, err := api.NewServer(config, store)

	if err != nil {
		log.Fatal("cant not create server\n", err)
	}

	err = server.Start(config.ServerAddress)

	if err != nil {
		log.Fatal("cannot start server:", err)
	}

}

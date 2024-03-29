postgres:
	docker run --name postgres16 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:16-alpine

createdb:
	docker exec -it postgres16 createdb --username=root --owner=root master_bank

dropdb:
	docker exec -it postgres16 dropdb --username=root --owner=root master_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/master_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/master_bank?sslmode=disable" -verbose up
 
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/master_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/master_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go clean -testcache
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/erikdenisrs97/masterbank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server mock
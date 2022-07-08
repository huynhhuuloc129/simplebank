postgres: 
	docker run --name postgres1 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=Codnumber1postgres -p 5432:5432 -d postgres

createdb:
	docker exec -it postgres1 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres1 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:Codnumber1postgres@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:Codnumber1postgres@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server
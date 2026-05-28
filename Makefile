postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

create_migration:
	migrate create -ext=sql -dir=db/migration -seq $(name)

sqlc:
	sqlc generate

test:
	CGO_ENABLED=0 go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown create_migration sqlc test

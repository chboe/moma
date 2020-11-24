#!/bin/bash
docker run -v $(pwd)/sql:/migrations --network host migrate/migrate -path=/migrations/ -database postgres://postgres:1234@localhost:5432/moma?sslmode=disable $@

#!/bin/bash
docker run -v E:\Skole\'Formelle sprog og dataprocessering'\MoMa\moma\backend\migrations/sql:/migrations --network host migrate/migrate -path=/migrations/ -database postgres://postgres:1234@localhost:5432/moma?sslmode=disable up

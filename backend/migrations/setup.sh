#!/bin/bash
docker run --name postgres -e POSTGRES_PASSWORD=1234 -p5432:5432 -d postgres
docker exec postgres psql -Upostgres -c "CREATE DATABASE moma"

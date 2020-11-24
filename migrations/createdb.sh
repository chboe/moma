#!/bin/bash
docker exec postgres psql -Upostgres -c "CREATE DATABASE moma"

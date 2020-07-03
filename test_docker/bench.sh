#!/bin/bash -e

function cleanup() {
	docker-compose down -v --remove-orphans >/dev/null 2>&1
}

trap cleanup EXIT

docker-compose build
docker-compose up -d
docker-compose ps

CONTAINERS=$(docker-compose ps -q | xargs docker inspect --format "{{.Name}}" | sort)

echo
echo "Time to stop:"
TIMEFORMAT=%R
for container in $CONTAINERS; do
	time docker stop "$container"
done
docker-compose logs

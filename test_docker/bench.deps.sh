#!/bin/bash -e

CFGS="docker-compose.deps.yml docker-compose.nodeps.yml"

function cleanup() {
	for cfg in $CFGS; do
		docker-compose -f "$cfg" down -v --remove-orphans >/dev/null 2>&1
	done
}

trap cleanup EXIT

for cfg in $CFGS; do
	docker-compose -f "$cfg" up -d >/dev/null 2>&1
done

echo -e "Time to stop:"
TIMEFORMAT="%R"
function row() {
	# shellcheck disable=SC2068
	printf "%-25s| %5s\n" $@
}

row cfg time
row | tr " " "-"
for cfg in $CFGS; do
	time_elapsed=$(time (docker-compose -f "$cfg" stop >/dev/null 2>&1) 2>&1)
	row "$cfg" "$time_elapsed"
done

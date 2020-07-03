# Efficient &amp; gracefully stopping docker containers

Depending how we write our Dockerfile or docker-compose the termination signal will either be properly propagated or not.

Proper signal propagation to the docker processes means:

- they have a chance to gracefully be closed before being forced terminated
- stopping container will be faster
- other signals can be sent to the dockerized app through `docker kill` - this is rarely needed, but still a nice tool to have in your bag of tricks.

## Dockerfile `CMD cmd` vs `CMD ["cmd"]`

**`CMD ["cmd"]` is the way to go!**

The `CMD cmd` will prevent signals from being passed to command, and thus cause longer stop time and prevent process from shutting down cleanly.

Measured using [bench.sh](./test_docker/bench.sh)

| container name                  | time   | CMD                            |
| ------------------------------- | ------ | ------------------------------ |
| docker_efficient_teardown_1_run | 10.347 | `CMD ./signal.sh hello`        |
| docker_efficient_teardown_2_run | 0.388  | `CMD ["./signal.sh", "hello"]` |

process PIDs:

```
docker_efficient_teardown_1_run | Script started with hello
docker_efficient_teardown_1_run |     PID TTY          TIME CMD
docker_efficient_teardown_1_run |       1 ?        00:00:00 sh
docker_efficient_teardown_1_run |       8 ?        00:00:00 signal.sh
docker_efficient_teardown_1_run |       9 ?        00:00:00 ps

docker_efficient_teardown_2_run | Script started with hello
docker_efficient_teardown_2_run |     PID TTY          TIME CMD
docker_efficient_teardown_2_run |       1 ?        00:00:00 signal.sh
docker_efficient_teardown_2_run |       8 ?        00:00:00 ps
docker_efficient_teardown_2_run | Handler run with
```

## Docker-compose `command: cmd` vs `command: ["cmd"]`

`command` seems to be always parsed on `docker-compose` side regardless how we write it and no additional shell is spawned.

Measured using [bench.sh](./test_docker/bench.sh)

| container name                  | time  | CMD                                 |
| ------------------------------- | ----- | ----------------------------------- |
| docker_efficient_teardown_3_run | 1.231 | `command: ./signal.sh hello`        |
| docker_efficient_teardown_4_run | 1.075 | `command: ["./signal.sh", "hello"]` |

## Docker-compose `depends_on` - does one wait for another to stop first?

**Yes!**

Kill signal will be passed in the reversed start sequence between `depends_on` services.

Measured using [bench.deps.sh](./test_docker/bench.deps.sh)

| cfg                       | time  |                   |
| ------------------------- | ----- | ----------------- |
| docker-compose.deps.yml   | 3.722 | `depends_on` used |
| docker-compose.nodeps.yml | 0.566 | no `depends_on`   |

# Efficient &amp; gracefully stopping docker containers

Depending how we write our Dockerfile or docker-compose the termination signal will either be properly propagated or not.

Proper signal propagation to the docker processes means:

- they have a chance to gracefully be closed before being forced terminated
- stopping container will be faster
- other signals can be sent to the dockerized app through `docker kill` - this is rarely needed, but still a nice tool to have in your bag of tricks.

## Dockerfile `CMD cmd` vs `CMD ["cmd"]`

Measured using [bench.sh](./test_docker/bench.sh)

| container name                  | time   | CMD                            |
| ------------------------------- | ------ | ------------------------------ |
| docker_efficient_teardown_1_run | 10.347 | `CMD ./signal.sh hello`        |
| docker_efficient_teardown_2_run | 0.388  | `CMD ["./signal.sh", "hello"]` |

## Docker-compose `command: cmd` vs `command: ["cmd"]`

Measured using [bench.sh](./test_docker/bench.sh)

| container name                  | time  | CMD                                 |
| ------------------------------- | ----- | ----------------------------------- |
| docker_efficient_teardown_3_run | 1.231 | `command: ./signal.sh hello`        |
| docker_efficient_teardown_4_run | 1.075 | `command: ["./signal.sh", "hello"]` |

## Docker-compose `depends_on` - does one wait for another to stop first?

Measured using [bench.deps.sh](./test_docker/bench.deps.sh)

| cfg                       | time  |
| ------------------------- | ----- |
| docker-compose.deps.yml   | 3.722 | `depends_on` used |
| docker-compose.nodeps.yml | 0.566 | no `depends_on` |

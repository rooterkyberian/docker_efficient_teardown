# Efficient &amp; gracefully stopping docker containers

Depending how we write our Dockerfile or docker-compose the termination signal will either be properly propagated or not.

Proper signal propagation to the docker processes means:

- they have a chance to gracefully be closed before being forced terminated
- stopping container will be faster
- other signals can be sent to the dockerized app through `docker kill` - this is rarely needed, but still a nice tool to have in your bag of tricks.

The first two are a must have,

## Dockerfile `CMD cmd` vs `CMD ["cmd"]`

## Docker-compose `command: cmd` vs `command: ["cmd"]`

## Docker-compose `depends_on` - does one wait for another to stop first?

#! /bin/sh

    docker volume create db-data

    docker network create frontend --driver overlay

    docker network create backend --driver overlay

    docker swarm init

    docker service create --network frontend --publish 80:80 --replicas 2 --name vote bretfisher/examplevotingapp_vote

    docker service create --network frontend --replicas 1 --name redis redis:3.2

    docker service create --network frontend --network backend --replicas 1 --name worker bretfisher/examplevotingapp_worker

    docker service create --network backend --env POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,src=db-data,dst=/var/lib/postgresql/data --replicas 1 --name db postgres:9.4

    docker service create --network backend --publish 6969:80 --replicas 1 --name result bretfisher/examplevotingapp_result
#! /bin/bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
cd ./traefik && docker-compose up -d

## Pull the postgres:13.1 image
FROM postgres:latest

# database = test and password for root = password
ENV POSTGRES_PASSWORD postgres 
ENV POSTGRES_DB liveauth

# when container will be started, we'll have `` database created with this schema
COPY ./plain-auth.sql /docker-entrypoint-initdb.d/
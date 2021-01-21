## Pull the mysql:5.7 image
FROM postgres:latest

# database = test and password for root = password
ENV POSTGRES_PASSWORD postgres 
ENV POSTGRES_DB livecalendar

# when container will be started, we'll have `test` database created with this schema
COPY ./plaincalendar.sql /docker-entrypoint-initdb.d/
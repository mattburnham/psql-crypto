FROM postgres:13

# set authentication free access
ENV POSTGRES_HOST_AUTH_METHOD trust

# add sql scripts to initialization scripts
ADD sql/*.gz /docker-entrypoint-initdb.d/
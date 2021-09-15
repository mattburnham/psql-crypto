# ODSC Docker Image

This repo contains code used to build the `pqsl-crypto` Docker image used for the SQL Masterclass for Data Scientists training for the ODSC APAC 2021 Conference and O'Reilly Katacoda SQL Simplified course.

# Structure

* Database initialisation scripts can be found in `sql/`

All `.sql` files will be zipped into a `sql.gz` file automagically before the Docker image is built.

# Convenience Commands

* Test the Docker build: `make run`

* Start an interactive `psql` shell: first run `make run` and then in another tab run `make psql`

* Stop single Docker container: `make stop`

* To spin-up and spin-down a local Docker stack: `make up-local` and `make down-local`

* To deploy to Docker image: `make push` - check to update the version and app name

Run `make help` to see all other convenience commands inside the `Makefile`
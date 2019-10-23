# Entur - CircleCI Database Test Orb

> This is a work in progress, not yet available as a pulic release.

This orb is a utility orb for creating docker images (on GCR) with a database preloaded with data. This can then be used as a service image for your DB testing needs.

## Requirements

An executor that has `gcloud` pre-installed. One is available as `gcp-auth/entur-cci-toolbox`

## Usage

Use the orb like this:

```yaml
version: 2.1

orbs: # This makes the gcp-auth orb available in your config
  test-db: entur/test-db@volatile # Use volatile if you always want the newest version.

jobs:
  build-test-db-mysql:
    executor: test-db/entur-cci-toolbox
    steps:
      - test-db/database-build:
          image-name-suffix: schemaonly
          checkout: true
          setup-remote-docker: true
          database-type: "mysql"
          database-version: "8.0.17"
          database-schema: ./path/to/schema_only.sql
          gcp-service-key: $DOCKER_PASSWORD #set in CCI Context
          gcr-namespace: gcr.io
          gcr-project: project-id
  run-with-test-db-mysql:
    docker:
      - image: circleci/golang:1.12 #select a base image suitable for your project
      - image: gcr.io/project-id/YOUR_PROJECT_REPONAME-test-db-mysql-schemaonly:latest
        auth:
          username: $DOCKER_LOGIN
          password: $DOCKER_PASSWORD
        environment:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: testdb
          MYSQL_USER: user
          MYSQL_PASSWORD: passw0rd
    steps:
      - checkout
      - run: go get -u github.com/go-sql-driver/mysql
      - run: SQL_CONNECTION_STRING="root:root@tcp(127.0.0.1:3306)/testdb" go run main.go
```

Available commands can be found in `src/commands`. Usage examples in `examples` and in `text/install-test.yml`

## Pack and publish orb

Make sure you have the CircleCI CLI:

```bash
curl -fLSs https://circle.ci/cli | bash
```

Pack the contents of src/ to a single orb file:

```bash
circleci config pack ./src > orb.yml
```

Validate that the orb is valid:

```bash
circleci orb validate orb.yml
```

After commit & push to the repository, the orb will be automatically published as part of the workflow in CircleCI.

A dev-orb will be published as: `entur/test-db@dev:YOUR-BRANCH-NAME`. Release orbs are created on push to the master branch.

You can read more here: https://circleci.com/docs/2.0/creating-orbs/

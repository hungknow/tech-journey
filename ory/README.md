# API Gateway using Kong, Ory Kratos & Ory Oathkeeper

Reference: https://www.ory.sh/zero-trust-api-security-ory-tutorial/

![Kong Ory](./kong_ory.png)

# Overview

- A simple Go HTTP API that exposes /greet endpoint and listens :8090 port.
- Ory Oathkeeper as Zero Trust Identity Access Proxy.
- Ory Kratos to manage identities and users.
- Kong as ingress for incoming HTTP traffic.

Request Flow:

```
User -> Kong -> Ory Oathkeeper -> Ory Kratos -> Go API
```

Ory Oathkeeper checks the incoming request for presence of ory_kratos_session and does the following steps:

Proxies request to Go HTTP API if the identity check passes in Ory Kratos.
Redirects user to the Kratos UI if the identity check fails.


# Prequisites
- Create Postgres database:
    - Database Name: kong1
    - Database User: kong1

```sql
create database kong1;
create user kong1 with password 'kong1';
grant all privileges on database kong1 to kong1;
```

# Run locally

Using docker-compose

```
docker-compose up --build
```
Open http://127.0.0.1:8000/hello in your browser and follow the login flow

The docker-compose command builds a go webserver, runs all services, and exposes the following ports:

- HTTP :8001 and SSL :8444 ports for Kong Gateway admin API
- HTTP :8000 and SSL :8444 ports for Kong Gateway Proxy listener
- HTTP :4433 and :4434 are public and admin APIs of Ory Kratos
- HTTP :4436 for Mailslurper
- HTTP :4455 for UI interface

# Configuring Kong
That command creates an /greet endpoint on secure-api service and creates a reverse proxy for Ory Oathkeeper.

```sh
bash config.kong.sh
```
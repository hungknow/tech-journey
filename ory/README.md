# API Gateway using Kong, Ory Kratos & Ory Oathkeeper

Reference: https://www.ory.sh/zero-trust-api-security-ory-tutorial/

![Kong Ory](./kong_ory.png)

# Overview

- Kong gateway can be an excellent solution for an ingress load balancer and API gateway if you do not want vendor lock-in of any cloud API Gateways in your application. Kong uses OpenResty and Lua. OpenResty extends Nginx with Lua scripting to use Nginx's event model for non-blocking I/O with HTTP clients and remote backends like PostgreSQL, Memcached, and Redis. OpenResty is not an Nginx fork, and Kong is not an Openresty fork. Kong uses OpenResty to enable API gateway features.

- Oathkeeper acts like an identity and access proxy for our microservices. It allows us to proxy only authenticated requests to our microservices, so we don't need to implement middleware to check authentication. It can also transform requests, for example, convert session auth into JWT for a back-end service.

- Kratos is the authentication provider; it handles all first-party authentication flows: username/password, forgot password, MFA/2FA, and more. It also provides OIDC/social login capabilities for example, "Login with GitHub".

- A simple Go HTTP API that exposes /greet endpoint and listens :8090 port.

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

create database kratos1;
create user kratos1 with password 'kratos1';
grant all privileges on database kratos1 to kratos1;

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
# Database Migration
- [ ] go-migrate to generate the Postgresql database

```
go run ./migration/.
```

```
migrate create -ext sql -dir ./migration/sql -seq
```

## Golang Server
- [ ] http rest handler
- [ ] Handle the authentication
- [ ] Handle the simple permission
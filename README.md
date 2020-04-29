# BankApiPhx

This is a Stone Challenge, to propose financial logic API

## Development

Clone project

```shell script
https://gitlab.com/marcio-elixir/bank-api-phx.git
cd bank-api-phx
```

Docker deploy

```shell script
cd docker/dev
docker volume create bank_data
docker-compose up -d && docker logs bank-api-phx -f
```

## Production

**Heroku**
[https://devcenter.heroku.com/articles/heroku-cli](https://devcenter.heroku.com/articles/heroku-cli)

Login Account

Inside project follow this commands 

```shell script
heroku login
```

Create App

```shell script
heroku create stone-bank-api-phx --buildpack hashnuke/elixir
```

Create PostgreSQL instance

```shell script
heroku addons:create heroku-postgresql:hobby-dev
```

Setup environment

```shell script
heroku config:set MIX_ENV=prod
```

Migrate database

```shell script
heroku run "MIX_ENV=prod POOL_SIZE=2 mix ecto.create"
heroku run "MIX_ENV=prod POOL_SIZE=2 mix ecto.migrate"
heroku run "MIX_ENV=prod POOL_SIZE=2 mix utils.seed"
```

Push project

```shell script
git push heroku master
```

## Tests and Coveralls

Run Tests

```shell script
docker exec -it bank-api-phx mix test
```

Run Coveralls

```shell script
docker exec -it bank-api-phx bash -c "MIX_ENV=test mix coveralls.html"
```

## API Tools

Import this file in Insomnia
[https://insomnia.rest/](https://insomnia.rest/)

```shell script
rest-tools/insomnia.json
```

Import this file in Postman
[https://postman.io](https://postman.io)

```shell script
rest-tools/postman.json
```

API Docs

- Endpoint Development `http://localhost:4000/api`
- Endpoint Release `http://localhost:4001/api`
- Endpoint Production `https://stone-bank-api-phx.herokuapp.com/api`

**Fallback route**

Default to all errors in routes

NotFound
Status 404
```json
{
  "message": "Page not found"
}
```

**Mock data**

Admin
```json
{
  "email": "albusdumbledore@hogwarts.com",
  "password": "123123123"
}
```

Users
```json
{
  "email": "hermione@hogwarts.com",
  "password": "123123123"
}
```

```json
{
  "email": "harrypotter@hogwarts.com",
  "password": "123123123"
}
```

**Account**

### `GET /account/create`    

Create a new user account

  * `Headers`
  * `Content-Type: application/json`

Body
```json
{
  "user": {
    "email": "hermione@hogwarts.com",
    "firstName": "Hermione",
    "lastName": "Granger",
    "phone": "00 0000 0000",
    "password": "123123123"
  }
}
```

Response
Status 200
```json
{
  "message": "Account created with success!",
  "user": {
    "id": 8,
    "firstName": "Hermione",
    "lastName": "Granger",
    "email": "hermione@hogwarts.com",
    "phone": "00 0000 0000",
    "accounts": {
      "balance": "1000.00"
    },
    "acl": "user"
  }
}
```

Errors
```json
{
  "errors": {
    "email": [
      "can't be blank"
    ],
    "firstName": [
      "can't be blank"
    ],
    "lastName": [
      "can't be blank"
    ],
    "password": [
      "can't be blank"
    ]
  }
}
```

### `GET /auth/login`    

User login and get access token

  * `Headers`
  * `Content-Type: application/json`
  
Response
Status 200
```json
{
  "message": "Login success!",
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6Ik...",
  "user": {
    "id": 2,
    "firstName": "Hermione",
    "lastName": "Granger",
    "email": "hermione@hogwarts.com",
    "phone": "00 0000 0000",
    "accounts": null,
    "acl": "user"
  }
}
```

Errors
```json
{
  "errors": "Invalid credentials"
}
```

### `GET /account/index`    

Show current account

  * `Headers`
  * `Authorization: Bearer TOKEN`

Response
Status 200
```json
{
  "message": "Login success!",
  "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6Ik...",
  "user": {
    "id": 2,
    "firstName": "Hermione",
    "lastName": "Granger",
    "email": "hermione@hogwarts.com",
    "phone": "00 0000 0000",
    "accounts": null,
    "acl": "user"
  }
}
```

Errors
```json
{
  "errors": "Unauthorized"
}
```

### `GET /account/withdrawal`    

Withdrawal money from your account

  * `Headers`
  * `Authorization: Bearer TOKEN`
  * `Content-Type: application/json`
 
Password confirmation is false
Body
```json
{
  "value": "10.00",
  "password_confirm": false
}
```

Response
Status 200
```json
{
  "message": "Please check your transation",
  "result": {
    "email": "hermione@hogwarts.com",
    "new_balance": "980.00",
    "old_balance": "990.00"
  }
}
```

Password confirmation is true
  
Body
```json
{
  "value": "10.00",
  "password_confirm": "123123123"
}
```

Response
Status 200
```json
{
  "message": "Successful withdrawal!",
  "result": {
    "email": "hermione@hogwarts.com",
    "new_balance": "980.00"
  }
}
```

Errors

Invalid Credentials
```json
{
  "errors": "Invalid credentials"
}
```

Value be less than 0.00
```json
{
  "errors": "Value cannot be less than 0.00"
}
```

You don't   have enough funds
```json
{
  "errors": "You don't have enough funds"
}
```

### `GET /account/transfer`    

Transfer money to other user account

  * `Headers`
  * `Authorization: Bearer TOKEN`
  * `Content-Type: application/json`
 
Password confirmation is false 
Body
```json
{
  "account_to": "harrypotter@hogwarts.com",
  "value": "10.00",
  "password_confirm": false
}
```

Response
Status 200
```json
{
  "message": "Please check your transation",
  "result": {
    "from": {
      "email": "hermione@hogwarts.com",
      "new_balance": "960.00",
      "old_balance": "970.00"
    },
    "to": {
      "email": "harrypotter@hogwarts.com",
      "new_balance": "1020.00",
      "old_balance": "1010.00"
    }
  }
}
```

Password confirmation is true
  
Body
```json
{
  "account_to": "harrypotter@hogwarts.com",
  "value": "10.00",
  "password_confirm": "123123123"
}
```

Response
Status 200
```json
{
  "message": "Successful withdrawal!",
  "result": {
    "email": "hermione@hogwarts.com",
    "new_balance": "980.00"
  }
}
```

Errors

Invalid Credentials
```json
{
  "errors": "Invalid credentials"
}
```

Value be less than 0.00
```json
{
  "errors": "Value cannot be less than 0.00"
}
```

You don't   have enough funds
```json
{
  "errors": "You don't have enough funds"
}
```

### `GET /account/terminate

User terminate account

  * `Headers`
  * `Authorization: Bearer TOKEN`
  * `Content-Type: application/json`    
  
Response
Status 200
```json
{
  "message": "Your account has been terminated"
}
```

Errors
```json
{
  "errors": "You need authenticated to this action"
}
```

**Dashboard**

### `GET /transactions/report

Show transactions reports

  * `Headers`
  * `Authorization: Bearer ADMIN_TOKEN` 
  * `Content-Type: application/json`    
  * `filter daily, monthly, yearly, empty`
  * `type withdrawal, transfer`
  * `period day, month, year`
 
Body
All transactions
```json
{
	"filter": "",
	"type": "",
	"period": ""
}
```

Per transaction type
```json
{
	"filter": "",
	"type": "withdrawal",
	"period": ""
}
```

Daily transactions
```json
{
	"filter": "daily",
	"type": "",
	"period": "01"
}
```

Monthly transactions
```json
{
	"filter": "monthly",
	"type": "",
	"period": "04"
}
```

Yearly transactions
```json
{
	"filter": "yearly",
	"type": "",
	"period": "2020"
}
```
 
Response
Status 200
```json
{
  "message": "All transactions",
  "result": {
    "total": "10.00",
    "transactions": [
      {
        "account_from": "hermione@hogwarts.com",
        "account_to": "hermione@hogwarts.com",
        "value": "10.00",
        "inserted_at": "2020-04-28T19:04:04"
      }
    ]
  }
}
```

Errors
```json
{
  "errors": "You need authenticated to this action"
}
```
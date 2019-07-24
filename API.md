# API FLS (Cashout)

## General
The Base URL endpoint is: `https://www.cashout.credit/api`

Every request needs the following header:
```
Content-Type: application/json
X-Requested-With: XMLHttpRequest
```

Once logged in you will receive a response containing an `access_token`.

For every request the header will have to cointain the `access_token` in the `Authorization` header prefixed by `Bearer` (+ space), like so:
```
Content-Type: application/json
X-Requested-With: XMLHttpRequest
Authorization: Bearer eyJ0eXAiOiJKV1QiL...F04wRJBVtRRoyrI6CVDBe1R6dU
```

All data to be send are to be in `JSON` format.

## Login
##### method: `POST`
##### url: `/login`

##### JSON to send (body):
```json
{
	"email": "agente@dolciaria.it",
	"password": "passwordtemporanea"
}
```

##### Response:
```json
{
  "access_token": "eyJ0eXAiOiJKV1Q...57gxRjbinJhM0I",
  "token_type": "Bearer",
  "expires_at": "2020-03-06 15:15:39"
}
```

## Unauthorized
##### method: `GET/POST`
##### url: `/*` (any url)
- Every request to an existing `url` while not authenticated or with an expired token will return an "`Unauthenticated.`" message.

##### Response:
```json
{
  "message": "Unauthenticated."
}
```

## Errors
##### method: `GET/POST`
##### url: `/*` (any url)
- Every request to an existing or non-existing `url` returning an error will have an empty `message` and a populated `exception` string

##### Response:
```json
{
  "message": "",
  "exception": "Symfony\\Component\\HttpKernel\\Exception\\NotFoundHttpException",
  "file": "/Users/mrweb/Futurelabs/DEV/Laravel/cashout/vendor/laravel/framework/src/Illuminate/Routing/RouteCollection.php",
  "line": 179,
}
```

## Logout
##### method: `POST`
##### url: `/logout`

##### Response:
```json
{
  "message": "Successfully logged out"
}
```

## List of Order
- Returns the list of all order of the logged user + their customer data + the products of the order
- If the user is an Admin the list will contain all of his Branch orders (branch_id)
- If the user is a Super Admin will see all orders in the system

##### method: `GET`
#### url: `/orders`
Order `status` possibilities:
- `0`: Draft (Draft: does NOT have a registry_id set)
- `0`: Open (Open: DOES HAVE a registry_id set)
- `1`: Completed
- `2`: Cancelled

The field `status_word` contains the status in words (Italian)

##### Response:
```json
[
  {
    "id": "45f20840-4015-11e9-bf47-d3f6a2fe1562",
    "branch_id": 1,
    "user_id": 1,
    "registry_id": "246bf0f0-38ea-11e9-b132-cb9b976d607e",
    "status": 1,
    "discount": 1000,
    "notes": null,
    "created_at": "2019-03-06 14:39:32",
    "updated_at": "2019-03-06 14:39:54",
    "status_word": "Completato",
    "customer": {
      "id": "246bf0f0-38ea-11e9-b132-cb9b976d607e",
      "branch_id": 1,
      "user_id": 1,
      "kind": "customer",
      "fname": "Alice",
      "lname": "Paris",
      "CF": null,
      "phone": null,
      "email": null,
      "address": "Via Cane, 12",
      "city": null,
      "zip": null,
      "district": null,
      "company": null,
      "PIVA": null,
      "created_at": "2019-02-25 11:43:09",
      "updated_at": "2019-02-25 11:43:15"
    },
    "products": [
      {
        "id": "4a0292c0-4015-11e9-b5f5-9b3f7fc85e20",
        "branch_id": 1,
        "user_id": 1,
        "order_id": "45f20840-4015-11e9-bf47-d3f6a2fe1562",
        "name": "Casa",
        "description": null,
        "price": 150000,
        "created_at": "2019-03-06 14:39:39",
        "updated_at": "2019-03-06 14:39:50"
      }
    ]
  }
]
```

## Single Order
- Returns the list of all order of the logged user + their customer data + the products of the order

##### method: `GET`
#### url: `/order` (singular)
##### body: `{"id":"the-order-id"}`

##### Response:
```json
[
  {
    "id": "45f20840-4015-11e9-bf47-d3f6a2fe1562",
    "branch_id": 1,
    "user_id": 1,
    "registry_id": "246bf0f0-38ea-11e9-b132-cb9b976d607e",
    "status": 1,
    "discount": 1000,
    "notes": null,
    "created_at": "2019-03-06 14:39:32",
    "updated_at": "2019-03-06 14:39:54",
    "status_word": "Completato",
    "customer": {
      "id": "246bf0f0-38ea-11e9-b132-cb9b976d607e",
      "branch_id": 1,
      "user_id": 1,
      "kind": "customer",
      "fname": "Alice",
      "lname": "Paris",
      "CF": null,
      "phone": null,
      "email": null,
      "address": "Via Cane, 12",
      "city": null,
      "zip": null,
      "district": null,
      "company": null,
      "PIVA": null,
      "created_at": "2019-02-25 11:43:09",
      "updated_at": "2019-02-25 11:43:15"
    },
    "products": [
      {
        "id": "4a0292c0-4015-11e9-b5f5-9b3f7fc85e20",
        "branch_id": 1,
        "user_id": 1,
        "order_id": "45f20840-4015-11e9-bf47-d3f6a2fe1562",
        "name": "Casa",
        "description": null,
        "price": 150000,
        "created_at": "2019-03-06 14:39:39",
        "updated_at": "2019-03-06 14:39:50"
      }
    ]
  }
]
```

## Customer Order List:
- Returns a list of all customers' orders (by customer id)

Admins will see their branch Users and Super Admins will see all Users.
non-Admin and non-Super Admin will not access this resource
##### method: `POST`
##### url: `/customerorders`
##### body: `{"id":"the-customer-id"}`

##### Response:
```json
[
  {
    "id": "c6bdef60-4a6a-11e9-a387-318fdcd590f9",
    "branch_id": 1,
    "user_id": 1,
    "registry_id": "acb9a2e0-45e3-11e9-864a-fd579f3bb4ca",
    "status": 1,
    "discount": 0,
    "notes": null,
    "created_at": "2019-03-19 18:16:47",
    "updated_at": "2019-03-19 18:17:06",
    "status_word": "Completato",
    "total": 123
  },
  {
    "id": "c6bdef60-4a6a-11e9-a387-318fdcd590fa",
    "branch_id": 1,
    "user_id": 1,
    "registry_id": "acb9a2e0-45e3-11e9-864a-fd579f3bb4ca",
    "status": 1,
    "discount": 0,
    "notes": null,
    "created_at": "2019-03-19 18:16:47",
    "updated_at": "2019-03-19 18:17:06",
    "status_word": "Completato",
    "total": 0
  }
]
```

## Customer List:
- Returns a list of all customers of the logged User.
- If the user is an Admin the list will contain all of his Branch customers (branch_id)
- If the user is a Super Admin will see all customers in the system

Admins will see their branch Users and Super Admins will see all Users.
non-Admin and non-Super Admin will not access this resource
##### method: `GET`
##### url: `/customers`

##### Response:
```json
[
  {
    "id": "017f8d70-3db9-11e9-9a19-d73b88190308",
    "branch_id": 1,
    "user_id": 1,
    "kind": "customer",
    "fname": "Luca",
    "lname": "Minardi",
    "CF": null,
    "phone": null,
    "email": null,
    "address": "Via Daniele, 12",
    "city": null,
    "zip": null,
    "district": null,
    "company": null,
    "PIVA": null,
    "created_at": "2019-03-03 14:34:01",
    "updated_at": "2019-03-03 14:34:05"
  }
]
```

## Receipt:
- Returns a receipt by order id

Admins will see their branch Users and Super Admins will see all Users.
non-Admin and non-Super Admin will not access this resource
##### method: `POST`
##### url: `/receipt`
##### body: `{"id":"the-order-id"}`

##### Response:
```json
{
  "id": "3e331230-4a73-11e9-bdb7-ed4735f702eb",
  "order_id": "c6bdef60-4a6a-11e9-a387-318fdcd590fa",
  "branch_id": 1,
  "user_id": 1,
  "price": 0,
  "discount": 0,
  "tax": 0,
  "total": 0,
  "printed": 0,
  "created_at": "2019-03-19 19:17:23",
  "updated_at": "2019-03-19 19:17:23",
  "number": "3E331230",
  "order_number": "C6BDEF60"
}
```

## Update Order Status:
- Returns a receipt by order id

Admins will see their branch Users and Super Admins will see all Users.
non-Admin and non-Super Admin will not access this resource

##### method: `POST`
##### url: `/updateorderstatus`
##### body:
```
{
  "id":String, #Order id
  "status":Int, #1 = completed, 2 = cancelled
  "complete":Bool, #true only for status 1
}
```

##### Response:
(Will return the receipt if appropriate or empty `{}` if cancelled)
```json
{
  "id": "552d1db0-4a8f-11e9-a003-83dfcb7cd9ec",
  "order_id": "bd7e9b60-45e3-11e9-9985-25b2cda7d9c5",
  "branch_id": 1,
  "user_id": 1,
  "price": 260,
  "discount": 13,
  "tax": 57.2,
  "total": 317.2,
  "printed": 0,
  "created_at": "2019-03-19 22:38:28",
  "updated_at": "2019-03-19 22:38:28",
  "number": "552D1DB0",
  "order_number": "BD7E9B60"
}
```
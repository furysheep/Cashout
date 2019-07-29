# API FLS (Cashout)

## General
The Base URL endpoint is: `https://www.cashout.credit/api`

Every request needs the following header:
```
Content-Type: application/json
X-Requested-With: XMLHttpRequest
```

Once logged in you will receive a response containing an `access_token`.

For every request the header will have to cointain the `access_token` in the `Authorization` header prefixed by `Bearer`, like so:
```
Content-Type: application/json
X-Requested-With: XMLHttpRequest
Authorization: Bearer eyJ0eXAiOiJKV1QiL...F04wRJBVtRRoyrI6CVDBe1R6dU
```

All data to be send are to be in `JSON` format.

## Login
##### url: `/login`

##### JSON to send:
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
##### url: `/*` (any url)
- Every request to an existing `url` while not authenticated or with an expired token will return an "`Unauthenticated.`" message.

##### Response:
```json
{
  "message": "Unauthenticated."
}
```

## Errors
##### url: `/*` (any url)
- Every request to an existing or non-existing `url` returning an error will have an empty `message` and a populated `exception` string

##### Response:
```json
{
  "message": "",
  "exception": "Symfony\\Component\\HttpKernel\\Exception\\NotFoundHttpException",
  "file": "/Users/mrweb/Futurelabs/DEV/Laravel/cashout/vendor/laravel/framework/src/Illuminate/Routing/RouteCollection.php",
  "line": 179,
  ...
}
```

## Logout
##### url: `/logout`

##### Response:
```json
{
  "message": "Successfully logged out"
}
```

## Orders
#### url: `/orders`
- Returns a list of all Users's orders. 
- If the user is an Admin the list will contain all of his Branch orders (branch_id)
- If the user is a Super Admin will see all orders in the system

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
    "id": "string",
    "branch_id": "int",
    "user_id": "int",
    "registry_id": "string",
    "status": "int",
    "discount": "int",
    "notes": null,
    "created_at": "datetime",
    "updated_at": "datetime",
    "status_word": "string"
  },{...}
]
```

## Single Order Data
#### url: `/orders/{id}`
- Returns a specific order by ID, with the corrisponding customer and products

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

## Customer List:
Admins will see their branch Users and Super Admins will see all Users.
non-Admin and non-Super Admin will not access this resource
##### url: `/customers`
- Returns a list of all customers of the logged User.
- If the user is an Admin the list will contain all of his Branch customers (branch_id)
- If the user is a Super Admin will see all customers in the system

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
  },
  {...}
]
```

## Make a Transaction:
##### url: `/transaction/make`
There are 3 types of transactions, that is the `kind` field sent:

1. `balance`: the full payment. If the order is 100 (either total or 100 still to be paid) and you pay 100 this payment closes the order.
2. `advance`: payment which is not full. If the order has 30 euro left and you make a 10 eur it's an advance.
3. `storno`: closes a payment before the whole sum is reached. I don't know the translation but it means the guy has a debt with you of 100 then you have a debt with him of 20 so "storno" means he pays 80 and you close the order because with the 20 you owe him you are now even. When this is send you have to send "storno_doc" as well which is a document number (String type)

If the `payment` can be either `cash` or `check`. In case is `check` the request has to have `bank` and `check_number` 

The field `price` is the price paid.

##### JSON request:
```json
{
  "order_id": "351f8490-5c21-11e9-9b45-0f65e3249fbf",
  "kind":"advance",
  "payment":"cash",
  "bank":"Bank Of America",
  "check_number":"12367",
  "storno_doc":"A1-34",
  "price":13
}
```
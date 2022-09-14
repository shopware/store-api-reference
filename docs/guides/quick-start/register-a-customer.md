# Registering a customer

## Overview

One has to be a registered customer to place orders, manage a profile or view old orders.

## Registration of a customer

To register, a customer must possess some personal data and a billing address. In addition to that, you have to define a storefront URL. This URL is required for Shopware to correctly assemble a confirmation link so they can confirm their registration in case of a [double opt in](register-a-customer.md#double-opt-in). This is especially required for frontends that run on a different host than the Shopware API itself.

> The customer requires a **salutationId** and a **countryId** parameter. You can fetch the different options using the `/store-api/salutation` and `/store-api/country` endpoints respectively.

**Try it out**

> If you get an error saying the values of `salutationId` or `countryId` are invalid, fetch them using their respective endpoints first.
>  * [Salutations](../../../storeapi.json/paths/~1salutation/post)
>  * [Countries](../../../storeapi.json/paths/~1country/post)

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/account/register",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG",
    "sw-context-token": "my-frontend-token"
  },
  "body": {
    "salutationId": "32d6c76401d749d2b025eba20a511e54",
    "firstName": "Alice",
    "lastName": "Apple",
    "email": "alice.apple@example.com",
    "password": "ilovefruits",
    "storefrontUrl": "http://localhost",
    "billingAddress": {
        "street": "Apple Alley 42",
        "zipcode": "1234-5",
        "city": "Appleton",
        "countryId": "de7ca8cbb8934e63bed964f8d592d501"
    }
  }
}
```

```javascript
// POST /store-api/account/register

{
    "salutationId": "32d6c76401d749d2b025eba20a511e54",
    "firstName": "Alice",
    "lastName": "Apple",
    "email": "alice.apple@example.com",
    "password": "ilovefruits",
    "storefrontUrl": "http://localhost",
    "billingAddress": {
        "street": "Apple Alley 42",
        "zipcode": "1234-5",
        "city": "Appleton",
        "countryId": "de7ca8cbb8934e63bed964f8d592d501"
    }
}
```

If your request is successful, the response contains the newly created customer.

**Context Token**

> When you are using double opt-in, please follow [these steps](register-a-customer.md#double-opt-in) before continuing.

There is one more interesting thing about the headers. Usually, `sw-context-token` header contains the token which identifies your current session. However, when you register a customer, it contains both the new and the old token, separated by a comma:

```text
sw-context-token GP6Yin6JlKeFP55oKVpVYx8Zt4Um1fqc, YoKCWdUdMYh5FEszia4ZrcoyAh7hJNY1
```

The first token is the new one you can use on subsequent requests, and your customer is already logged in. The old token is still valid and contains the cart and other settings. You can pass it as an additional header `sw-context-token` to identify your requests.

> The **context token** also works for non-logged-in users. If you do not provide a context token with each request, Shopware will generate one for you and pass it as a response header.

You can always double-check the state of your session using the `/store-api/account/customer` endpoint. If you are logged in, it returns information about the customer; otherwise, it returns a **403 Forbidden** error.

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/account/customer",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG",
    "sw-context-token": "my-frontend-token"
  }
}
```

```javascript
// GET /store-api/account/customer

{
  "errors": [
    {
      "status": "403",
      "code": "CHECKOUT__CUSTOMER_NOT_LOGGED_IN",
      "title": "Forbidden",
      "detail": "Customer is not logged in.",
      "meta": {
        "parameters": []
      }
    }
  ]
}
```

## Double Opt-In

Some data regulations force stores to provide a double opt-in registration. In that flow, customers have to confirm their registration using a link sent to them by email. Shopware assembles this URL using the following format, where `storefrontUrl` is the URL of your application \(as provided during registration\).

```http
[storefrontUrl]/registration/confirm?em=[email-hash]&hash=[customer-hash]
```

> Your frontend application must listen on the **`/registration/confirm`** route to support double opt-in.

This URL will direct the user to your application, so you have to make sure that your application calls the following endpoint to confirm the registration:

```javascript
// POST /store-api/account/register-confirm

{
  "em": "[email-hash]",
  "hash": "[customer-hash]"
}
```

## Guest Customers

Guest customers are one-time customers who simply place an order without creating an account. Technically, guest customers have to be registered as well; however, the record will just be created for technical reasons. Just pass the `guest: true` to the registration request in order to create a guest customer. The rest of the flow will be the same as a normal registration. Just be aware that you cannot re-obtain a valid session for guest customers once they have been logged out.

The double opt-in procedure described above works the same for guest customers.

## Logging in

Logging in as a user is even easier. You just have to pass the user's email and password to authenticate.

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/account/login",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG",
    "sw-context-token": "my-frontend-token"
  },
  "body": {
    "email": "alice.apple@example.com",
    "password": "ilovefruits"
  }
}
```

```javascript
// POST /store-api/account/login

{
    "email": "alice.apple@example.com",
    "password": "ilovefruits"
}
```

The response contains your new context token identifying the logged-in customer.

```javascript
{
  "apiAlias": "array_struct",
  "contextToken": "PwSFY3T3IZCWdq658ku3nZMPouLmAlJU"
}
```

Now that you are logged in let us look for some products. 

> Next Chapter: **[Search for products](search-for-products.md)**

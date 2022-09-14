# Working with the cart

## Overview

Any online store would be useless if it were not shoppable. Hence, we need a cart to collect items which we want to buy.

Implicitly, a cart is associated with your `sw-context-token` header.

## Create a new cart

To create a new cart, make sure to set a context token header. You can also pass a name to identify the cart later if you want to.

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/checkout/cart",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG",
    "sw-context-token": "my-frontend-token"
  },
  "body": {
    "name": "my-cart"
  }
}
```

```javascript
// POST /store-api/checkout/cart

{
  "name": "my-cart"
}
```

**Response**

```javascript
{
  "name": "my-cart",
  "token": "nqVMbLr8Q1Vs5jFdz4xk4vkSXAEKiOMt",
  "price": {
    "netPrice": 0,
    "totalPrice": 0,
    "calculatedTaxes": [],
    "taxRules": [],
    "positionPrice": 0,
    "taxStatus": "gross",
    "apiAlias": "cart_price"
  },
  "lineItems": [],
  "errors": [],
  "deliveries": [],
  "transactions": [
    {
      "amount": {
        "unitPrice": 0,
        "quantity": 1,
        "totalPrice": 0,
        "calculatedTaxes": [],
        "taxRules": [],
        "referencePrice": null,
        "listPrice": null,
        "apiAlias": "calculated_price"
      },
      "paymentMethodId": "35ce6af5a12a49708740a38bbbdf517e",
      "apiAlias": "cart_transaction"
    }
  ],
  "modified": false,
  "customerComment": null,
  "affiliateCode": null,
  "campaignCode": null,
  "extensions": {
    "cart-promotions": {
      "addedCodes": [],
      "blockedPromotionIds": [],
      "apiAlias": "shopware_core_checkout_promotion_cart_extension_cart_extension"
    }
  },
  "apiAlias": "cart"
}
```

If you want to delete your cart, you can send a `DELETE` request to the same endpoint.

## Adding new items to the cart

One can add multiple new line items into the cart using the following endpoint:

### Product

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/checkout/cart/line-item",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG",
    "sw-context-token": "my-frontend-token"
  },
  "body": {
    "items": [
        {
            "type": "product",
            "referencedId": "015e61367f204921b6bf6a8b2c72f85e"
        },
        {
            "type": "product",
            "referencedId": "015e61367f204921b6bf6a8b2c72f85e",
            "quantity": 2
        }
    ]
  }
}
```

```javascript
// POST /store-api/checkout/cart/line-item

{
    "items": [
        {
            "type": "product",
            "referencedId": "<productId>"
        },
        {
            "type": "product",
            "referencedId": "<productId>",
            "quantity": 2
        }
    ]
}
```

You can set following properties : `referencedId`, `payload`, and `quantity` on a product line item. If the line item is misconfigured, the cart will add an error. This error is shown as `error` key in the response.

### Promotion

When adding a promotion, just set the line item type to `promotion` and pass the promotion code as `referencedId`.

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/checkout/cart/line-item",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG",
    "sw-context-token": "my-frontend-token"
  },
  "body": {
    "items": [
      {
        "type": "promotion",
        "referencedId": "<promotionCode>"
      }
    ]
  }
}
```

```javascript
// POST /store-api/checkout/cart/line-item

{
  "items": [
    {
      "type": "promotion",
      "referencedId": "<promotionCode>"
    }
  ]
}
```

### Error handling

Whenever an invalid configuration is passed to the cart, or you try to perform an action that is not available, the cart is prone to errors. Reasons for errors can be:

 * Product out of stock
 * Invalid payment method selection
 * Promotion not applicable
 * Invalid quantity

These errors are not handled via HTTP response codes but are only contained in the `errors` field of your cart. Each error comes with an error message, a message key (so you can map custom error messages), and additional information.

For example, when you pass an invalid line item configuration to the API, the cart calculation process will remove the line items again and add errors to the cart. In case of an invalid `referencedId`, it would look like this:

```javascript
{
  /* ... */
  "errors": {
    "product-not-foundfc2376912354406d80dd8887fc30ffa8": {
      "id": "fc2376912354406d80dd8887fc30ffa8",
      "message": "The product %s could not be found",
      "code": 0,
      "line": 166,
      "key": "product-not-foundfc2376912354406d80dd8887fc30ffa8",
      "level": 10,
      "messageKey": "product-not-found"
      }
  }
}
```

## Updating items in the cart

Use a `PATCH` request to the `/checkout/cart/line-item` endpoint to update line items into the cart.

```javascript
// PATCH /store-api/checkout/cart/line-item

{
    "items": [
        {
            "id": "<id>",
            "quantity": "<quantity>",
            "referencedId": "<newReferenceId>"
        }
    ]
}
```

## Deleting items in the cart

Perform a `DELETE` request to the `/checkout/cart/line-item` endpoint to remove line items from the cart.

```javascript
// DELETE /store-api/checkout/cart/line-item

{
    "ids": [
        "<id>"
    ]
}
```

## Creating order from the cart

To create an order, you need a minimum of one item in the cart, and you need to be a [logged in](register-a-customer.md#logging-in) customer. This also applies to anonymous orders, where a user has to be registered as a [guest customer](register-a-customer.md#guest-customers) before the order is created. The following endpoint can be used to create one:

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/checkout/order",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG",
    "sw-context-token": "my-frontend-token"
  }
}
```

```javascript
// POST /store-api/checkout/order

{
    "includes": {
        "order": ["orderNumber", "price", "lineItems"],
        "order_line_item": ["label", "price"]
    }
}
```

**Response**

```javascript
{
  "orderNumber": "10060",
  "price": {
    "netPrice": 557.94,
    "totalPrice": 597,
    "calculatedTaxes": [
      {
        "tax": 39.06,
        "taxRate": 7,
        "price": 597,
        "apiAlias": "cart_tax_calculated"
      }
    ],
    "taxRules": [
      {
        "taxRate": 7,
        "percentage": 100,
        "apiAlias": "cart_tax_rule"
      }
    ],
    "positionPrice": 597,
    "taxStatus": "gross",
    "apiAlias": "cart_price"
  },
  "lineItems": [
    {
      "label": "Aerodynamic Bronze Prawn Crystals",
      "price": {
        "unitPrice": 597,
        "quantity": 1,
        "totalPrice": 597,
        "calculatedTaxes": [
          {
            "tax": 39.06,
            "taxRate": 7,
            "price": 597,
            "apiAlias": "cart_tax_calculated"
          }
        ],
        "taxRules": [
          {
            "taxRate": 7,
            "percentage": 100,
            "apiAlias": "cart_tax_rule"
          }
        ],
        "referencePrice": null,
        "listPrice": null,
        "apiAlias": "calculated_price"
      },
      "apiAlias": "order_line_item"
    }
  ],
  "customerComment": "comment",
  "affiliateCode": "affiliate code",
  "campaignCode": "campaign code",
  "apiAlias": "order"
}
```

Depending on your requirements, you might need additional data from the order. You can control what gets passed using the `includes` parameter in the request body. Some interesting fields:

### `order.deliveries`

Shopware's data model is capable of representing multiple deliveries or shipments within a single order. Each delivery can have different items, shipping methods, and delivery dates. However, in our current version, Shopware does not support the creation of multiple deliveries out of the box, so most likely, you will just be using `order.deliveries[0]`.

### `order.transactions`

A transaction represents payment for an order. It contains a payment method, an amount, and a state. An order can have multiple payment methods \(for example, if a payment fails, you can [switch methods](handling-the-payment.md#handle-exceptions) and create a second transaction with an alternative payment method\).

### `order.addresses`

An order can have multiple associated addresses \(e.g. for shipping or delivery\). Those will be passed in the `addresses` association. You can map them using their references in the order, such as `order.billingMethodId` or `order.deliveries[*].shippingOrderAddressId` .

### `order.lineItems`

This field contains all line items of the order. Line items may not only be products, but also discounts or virtual items, like bundles. Line items are stored as copies of their corresponding products, so when a product is deleted in your store, the line items from older orders remain available.

> All the above also applies to the `/order` endpoint, which simply lists orders for the current customer.

## Payment methods

The endpoint `/store-api/payment-method` can be used to list all payment methods of the sales channel. With the query parameter `?onlyAvailable=1` you can restrict the result to only valid payments methods \(some payment methods can be generally available, but dynamically disabled based on the cart configuration or other parameters\)

Additionally, the criteria parameters \(`filter`, `aggregations`, etc.\) can be used to restrict the result, as described in our [Search Queries](../../concepts/search-queries.md) guide

```javascript
// POST /store-api/payment-method

{
    "includes": {
        "payment_method": ["name", "description", "active"]
    }
}

[
    {
        "name": "Cash on delivery",
        "description": "Payment upon receipt of goods.",
        "active": true,
        "apiAlias": "payment_method"
    },
    {
        "name": "Paid in advance",
        "description": "Pay in advance and get your order afterwards",
        "active": true,
        "apiAlias": "payment_method"
    }
]
```

## Shipping methods

The endpoint `/store-api/shipping-method` can be used to list all shipping methods of the sales channel. It behaves in the same fashion as the payment methods endpoint, which is described above.

```javascript
// POST /store-api/shipping-method

{
    "includes": {
        "shipping_method": ["name", "active", "deliveryTime"],
        "delivery_time": ["name", "unit"]
    }
}

[
    {
        "name": "Express",
        "active": true,
        "deliveryTime": {
            "name": "1-3 days",
            "unit": "day",
            "apiAlias": "delivery_time"
        },
        "apiAlias": "shipping_method"
    }
]
```

> Next Chapter: **[Handling the payment](handling-the-payment.md)**

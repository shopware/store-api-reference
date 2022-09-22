# Quick Start Guide

## Overview

In this guide, you will explore the Shopware Store APIs using different examples. You will learn how to:

* Authenticate as an API user
* Register and login as a customer
* Perform product searches and fetch product listings
* Use the cart
* Create an order
* Handle payment transactions

If you want to follow this guide, using an API client like Postman or Insomnia is useful. You can also go along writing your custom script in Javascript, PHP, or any programming language you are familiar with.

## General

The Store API has a base route that is always relative to your Shopware instance host. Note that it might differ from your sales channel domain. Let's assume your Shopware host is:

```text
https://shop.example.com/
```

Then your Store API base route will be:

```text
https://shop.example.com/store-api
```

>  Before Shopware Version 6.4, the API version was passed within the endpoint path (e.g. `/store-api/v3/product`).

The Store API offers a variety of functionalities referred to as _endpoints_ or _nodes_, where each has its own route. The endpoints mentioned subsequently are always relative to the API base route.

### Authentication and setup

Just as any shop frontend is public to its visitors, the Store API is a public API and does not have an actual authentication. However, you have to pass some type of identification for Shopware to determine the right sales channel for the API call. This identification is the `sw-access-key`. It is sent as an HTTP header. You can find the correct access key within your admin panel's sales channel configuration in a section labeled _API Access_

![API Access section in the Admin sales channel configuration](https://stoplight.io/api/v1/projects/cHJqOjEwNjA0NQ/images/QZFki14SFdc)

A typical Store API request, including headers, will look as shown below. Switch through the tabs to see the different parameters and add your server URL and access token in the "Headers" tab.

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/product",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG"
  },
  "body": {
    "associations": {
      "media": {}
    },
    "includes": {
      "media": ["url"]
    }
  }
}
```

Now that you have authenticated, you can perform your first request.

### Fetch the context

The `/context` endpoint gives some general information about the store and the user. 

**Try it out**

```json http
{
  "method": "get",
  "url": "http://localhost/store-api/context",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG"
  }
}
```

Below is how the response looks:

```javascript
{
  "token": "jDUPcIRg1Mi7WZQJAm1nFTqhoMc0Eqev",
  "currentCustomerGroup": { ... },
  "fallbackCustomerGroup": { ... },
  "currency": { ... },
  "salesChannel": { ... },
  "taxRules": [ ... ],
  "customer": null,
  "paymentMethod": { ... },
  "shippingMethod": { ... },
  "shippingLocation": { ... },
  "rulesIds": [ ... ],
  "rulesLocked": false,
  "permissions": [ ... ],
  "permisionsLocked": false,
  "apiAlias": "sales_channel_context"
}
```

The complete response is too big to be included here, but we already have many things to work with. In a later section, we will see how we can make changes to the context - e.g., changing the selected shipping method or the language.

Observe from the response that the `customer` field is still empty. Now is the time to change that.

> Next Chapter: **[Register a customer](register-a-customer.md)**

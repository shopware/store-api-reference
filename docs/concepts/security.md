# Security

This article lays out a set of guidelines you should follow to ensure the secure operation of your application.

## Terminology

This section depicts different aspects of our application:

**Client/User**

A client is the consuming application of an API. It makes requests, which the API responds to, and works with these responses. Usually, a client is something that a customer works with, but it can also be an automated system. 

Exemplary clients are:

 * Native Apps
 * Single Page Applications or PWAs
 * Headless integrations with other systems
 * API Gateways or Middlewares

**API**

The API is an abstract interface accessible through HTTP requests that can perform operations or query data on/from an application's backend. In the context of this documentation, the backend (or API) referred to will always be a Shopware application.

## Architecture

The Store API is a public API, which means that, in general, every application that knows the endpoint URL can consume it. However, Shopware has a concept called sales channels. Sales channels can scope applications to specific content, products, categories, payment, and shipping methods.

To let Shopware determine that sales channel, a client has to provide an **access token** in every request. This token is passed as a HTTP header. It is safe to store this token in a client application directly (e.g., as part of the configuration).

In addition, some APIs require a *context* or *state* to perform operations on a cart or a user login. Shopware identifies clients that perform these operations using a **context token**. This token is also passed as a HTTP header. It is unique per user and must not be shared amongst multiple clients or sessions, as it may contain access to sensitive data. This token should be stored in the client's local storage when building an application.

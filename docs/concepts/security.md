# Security

This article lines out a set of guidelines you should follow in order to ensure a secure opration of your application.

## Terminology

We are going to use some words in the following section to separate different aspects of our application:

**Client/User**

A client is the consuming application of an API. It makes requests, which the API responds to, and works with these responses. Usually a client is something that a customer works with, but it can also be an automated system. 

Exemplary clients are 

 * Native Apps
 * Single Page Applications or PWAs
 * Headless integrations with other systems
 * API Gateways or Middlewares

**API**

The API is an abstract interface, accessible through HTTP requests that can be used to perform operations or query data on/from an application backend. In the context of this documentation, the backend (or API) referred to will always be a Shopware application.

## Architecture

The Store API is a public API, which means that, in general, every application that knows the endpoint URL can consume it. However, Shopware has a concept called sales channels. Sales channels can be used to scope applications to specific content, products, categories, payment methods and shipping methods.

In order to let Shopware determine that sales channel, a client has to provide an **access key** in every request. That key is passed as a HTTP header. It is safe to store this key in a client application directly (e.g. as part of the configuration).

Some operation require a *context* or *state*, such as a cart, or a user login. Shopware is able to identify clients that perform these operations using a **context token**. This token is also passed as a HTTP header. This token is unique per user must not be shared amongst multiple clients or sessions, as it may contain access to sensitive data. When building an application, this token should be stored in the clients local storage.
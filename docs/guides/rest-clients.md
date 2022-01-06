# REST Clients

Even though the API documentation provides an integrated API client (on the right side in the "Try it out" section) and code generation tools, it is possible to import the generated API specification into a REST client of your choice.

Please go here to download the [OpenAPI specification](https://github.com/elkmod/store-api-documentation/blob/main/storeapi.json) (JSON format) for our Store API.

> **Hint** - You can also generate an OpenAPI specification using your own Shopware instance. Just make sure that it is in _development mode_ (`APP_ENV=dev` in your `.env` file) and navigate to `http://[your-host]/store-api/_info/openapi3.json`.

## Import OpenAPI spec into REST clients

**Insomnia**

1. Open your **Preferences** dialog
2. Open the **Data** tab
3. Choose **Import Data** > **From File** and select the `storeapi.json` file
4. Confirm by importing into a new or your current workspace

**Postman**

1. Click the **Import** button on your top left
2. Select **Import File** from the import options tabs
3. Import the `storeapi.json` file

## Why not Swagger?

Swagger is commonly used as a synonym for OpenAPI, but technically refers to the ecosystem of tools built on OpenAPI rather than the specification itself. https://swagger.io/blog/api-strategy/difference-between-swagger-and-openapi/
# Specification

To add the route to the Swagger page, a JSON file is needed in a specific format. It contains information about the paths, methods, parameters, and more. You must place the JSON file in `<plugin root>/src/Resources/Schema/StoreApi/` so the shopware internal `OpenApi3Generator` can find it (for Admin API endpoints, use AdminAPI). For more details see the [Add store API route guide](https://developer.shopware.com/docs/guides/plugins/plugins/framework/store-api/add-store-api-route).

## Code example

This example shows how to add an endpoint with the URL http://localhost/store-api/example and `POST` as an allowed request.

```json
{
  "openapi": "3.0.0",
  "info": [],
  "paths": {
    "/example": {
      "post": {
        "tags": [
          "Example",
          "Endpoints supporting Criteria "
        ],
        "summary": "Example entity endpoint",
        "description": "Returns a list of example entities.",
        "operationId": "example",
        "requestBody": {
          "required": false,
          "content": {
            "application/json": {
              "schema": {
                "allOf": [
                  {
                    "$ref": "#/components/schemas/Criteria"
                  }
                ]
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Returns a list of example entities.",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Example"
                }
              }
            }
          }
        },
        "security": [
          {
            "ApiKey": []
          }
        ]
      }
    }
  }
}
```



### General Guidelines

* If a property or a parameter is optional, please document the *default* value or the default behavior.
* Be comprehensive in your descriptions for operations, parameters, properties and responses. The more, the better.
* Make use of Markdown syntax in descriptions, when it's beneficial.
* Document not only the happy case, but also errors that can be handled by the client. (Work with response codes!)
* Mark required fields as such

If you want to exploit OpenAPI 3.0 in its entirety, check out the full [OpenAPI specification](https://swagger.io/specification/).

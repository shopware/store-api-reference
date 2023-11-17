# Request and Response Structure

The Store API provides a base endpoint to which all other endpoints are relative.

The base endpoint depends on your Shopware host URL - for example:

```text
https://shop.example.com/store-api
```

From this base endpoint, you can interact with storefront resources like cart, order, etc.

## HTTP method

The HTTP methods indicate the type of operation you want to perform.

| HTTP method  | Description                     |
| -------------| --------------------------------|
| GET          | Fetches or adds a new object    |
| POST         | Fetches or creates a new object |
| PATCH        | Updates the object info         |
| DELETE       | Deletes the object              |

## Request format

The request format for Shopware 6 store API's must follow the below format:

* The request body has to be JSON encoded.

* It is mandatory to use type-safe values, e.g. if the API expects an integer value, you are required to provide an actual integer.

* When using a Date field, make sure to use an ISO 8601 compatible date format.

### Request URL

* Request with resource path:

```text
https://shop.example.com/store-api/path
```

* Request with resource path and query parameter

```text
https://shop.example.com/store-api/path/{query-parameter}
```

### Request headers

Request headers provide information about your request to a REST API service that allows to authenticate/authorize and receive the request body.

| Request header              | Key                                    | Description                                                                                |
| --------------------------- | ---------------------------------------|--------------------------------------------------------------------------------------------|
| sw-access-token             | SWSCXYZSNTVMAWNZDNFKSHLAYW             | Access key to identify and get authorized to respective sales channel access               |
| sw-context-token            | 84266fdbd31d4c2c6d0665f7e8380fa3       | Sample endpoints `/account/login`, `/checkout/cart` that require user authentication       |
| Content-Type                | application/json                       | Indicate the format of the request body                                                    |
| Accept                      | application/json                       | Indicate the format in which the response will be returned                                 |

### Request body

```javascript
//sample request body format

{
  "items": [
    {
      "id": "01bd7e70a50443ec96a01fd34890dcc5",
      "referencedId": "01bd7e71b277653ec96a01fd34890ecc21",
      "quantity": 1,
      "type": "string",
      "good": true,
      "description": "Metal ice cream scooper",
      "removable": true,
      "stackable": true,
      "modified": true
    }
  ],
  "apiAlias": "string"
}
```

## Response format

### Response headers

The Store API generally supports the following headers. By default, the response will be in JSON:API format. You can control the response format using the `Accept` header.

| Response header             | Accept                      | Format                                                                    |
| ----------------------------| --------------------------- | --------------------------------------------------------------------------|
| Content-type                | application/json            | Simplified JSON format                                                    |
| Cache-control               |                             | Provides directives for caching mechanisms in both requests and responses |
| Date                        | date                        |  Specifies the date and time at which the response was generated          |
| X-Frame-Options, Strict-transport-encoding | deny         | Protects against a certain cyber-attacks                                  |
| SW-Context-Token            | token                       |  For authentication purpose                                               |
| Referrer-Policy             | strict-origin-when-cross-origin| Controls the amount of information sent                                |
| Content-Encoding            | gzip                      |  Resource compression format for faster loading                             |

### Sample response

The format has a rich structure that makes discovering the API easier, even without documentation. Some libraries can even generate user interfaces from it. It provides relationships to other resources and additional information about the resource. You can see a shortened example response below:

```javascript

{
 "price": {
        "netPrice": 168.22,
        "totalPrice": 180,
        "calculatedTaxes": [
            {
                "tax": 11.78,
                "taxRate": 7,
                "price": 180,
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
        "positionPrice": 180,
        "taxStatus": "gross",
        "rawTotal": 180,
        "apiAlias": "cart_price"
    },
    "lineItems": [
        {
            "payload": {
                "isCloseout": false,
                "customFields": [],
                "createdAt": "2020-08-06 06:26:32.065",
                "releaseDate": null,
                "isNew": false,
                "markAsTopseller": null,
                "productNumber": "SW10423",
                "manufacturerId": "05cd4e976df14c4d90e351f345ff5aa3",
                "taxId": "94f1e03140d24698a894320e258e6d83",
                "tagIds": null,
                "categoryIds": [
                    "525abe8981214bd2ba94fd33942333ec",
                    "bda4b60e845240b2b9d6b60e71196e14"
                ],
                "propertyIds": [
                    "6e3be72d8ad84a4ab73746a17863c1e8"
                ],
                "optionIds": null,
                "options": [],
                "streamIds": [
                    "1318833f46df457981763b94179d9ef0",
                    "89a367082c0d48c88f59424a8bb0265b"
                ],
                "parentId": null,
                "stock": 2389,
                "features": []
            },
            "label": "Ice Cream Scoop",
            "quantity": 1,
            "priceDefinition": {
                "price": 180,
                "taxRules": [
                    {
                        "taxRate": 7,
                        "percentage": 100,
                        "apiAlias": "cart_tax_rule"
                    }
                ],
                "quantity": 1,
                "isCalculated": true,
                "referencePriceDefinition": null,
                "listPrice": null,
                "regulationPrice": null,
                "type": "quantity",
                "apiAlias": "cart_price_quantity"
            },
            "price": {
                "unitPrice": 180,
                "quantity": 1,
                "totalPrice": 180,
                "calculatedTaxes": [
                    {
                        "tax": 11.78,
                        "taxRate": 7,
                        "price": 180,
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
                "regulationPrice": null,
                "apiAlias": "calculated_price"
            },
            "good": true,
            "description": null,
            "cover": {
                "translated": {
                    "alt": null,
                    "title": null,
                    "customFields": {}
                },
                "createdAt": "2020-08-06T06:26:06.221+00:00",
                "updatedAt": "2020-08-06T06:26:32.029+00:00",
                "mimeType": "image/jpeg",
                "fileExtension": "jpg",
                "fileSize": 44808,
                "title": null,
                "metaData": {
                    "type": 2,
                    "width": 900,
                    "height": 900
                },
                "uploadedAt": "2020-01-14T12:13:35.000+00:00",
                "alt": null,
                "url": "https://cdn.swstage.store/F/S/g/2pFUo/media/01/b0/34/1579004015/943278_SPLK_Eisportionierer_01.jpg",
                "fileName": "943278_SPLK_Eisportionierer_01",
                "translations": null,
                "thumbnails": [
                    {
                        "translated": [],
                        "createdAt": "2020-08-06T06:26:06.219+00:00",
                        "updatedAt": "2020-08-06T06:26:32.027+00:00",
                        "width": 400,
                        "path": "thumbnail/01/b0/34/1579004015/943278_SPLK_Eisportionierer_01_400x400.jpg",
                        "height": 400,
                        "url": "https://cdn.swstage.store/F/S/g/2pFUo/thumbnail/01/b0/34/1579004015/943278_SPLK_Eisportionierer_01_400x400.jpg",
                        "mediaId": "394243c9602e4bf7a288b9a0ba845ac6",
                        "customFields": null,
                        "id": "70477ce7dda548b186036e8b3197e9ef",
                        "apiAlias": "media_thumbnail"
                    },
...
...
...

```

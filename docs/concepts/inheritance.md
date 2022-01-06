# Field value inheritance

Shopware 6 allows developers to define inheritance (parent-child) relationships between entities of the same type. This has been used, for example, for products and their variants. Certain fields of a variant can therefore inherit the data from the parent product or define (i.e. override) them themselves.

However, the API initially only delivers the data of its own record, without considering parent-child inheritance. To tell the API that the inheritance should be considered, the header `sw-inheritance` must be sent along with the request.

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/product",
  "headers": {
    "sw-inheritance": "true",
    "sw-access-key": "SWSCY1NPSKHPSFNHWGDLTMM5NQ",
    "Content-Type": "application/json"
  },
  "body": {
    "filter": [{
      "type": "not",
      "queries": [{
        "type": "equals",
        "value": null,
        "field": "parentId"
      }]
    }],
    "includes": {
      "product": ["name"]
    }
  }
}
```

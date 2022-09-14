# Translations

By default, the API delivers the entities via the system language. This can be changed by specifying a language id using the sw-language-id header.

```bash
// POST /api/search/product

--header 'sw-language-id: be01bd336c204f20ab86eab45bbdbe45'
```

The same behaviour applies to filters on translatable fields. If your search term does not apply in the selected language, it will not yield a matching result.

> Shopware only populates a translatable field if there is an explicit translation for that field. Otherwise, the translated object always contains values for necessary fallbacks.
>
>   **Example:** You instruct Shopware to fetch the french translation of a product using the `sw-language-id` header. However, there is no french translation for the product name. The resulting field `product.name` will be null. Nevertheless, when building applications, always use `product.translated.[value]` to access translated values. This ensures you will always get a valid translation or a fallback value.

Try it out using the example below. If you remove the `sw-language-id` header, the filter will not match.

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/product",
  "headers": {
    "Content-Type": "application/json",
    "sw-access-key": "SWSCY1NPSKHPSFNHWGDLTMM5NQ",
    "sw-language-id": "e76274932a52482390f0b9b0bf2195e4"
  },
  "body": {
    "filter": [{
      "type": "equals",
      "value": "Beispielprodukt",
      "field": "name"
    }],
    "includes": {
      "product": ["id", "translated", "name"]
    }
  }
}
```

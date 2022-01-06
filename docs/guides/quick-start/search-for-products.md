# Searching for products

## Overview

One of the most common actions that customers perform in an online store is browsing products. We'll cover different topics in this guide

* Search products
* Filter and sort products
* Apply field projections \(make the response smaller\)
* Work with associations

## Simple search

Let's start by performing a simple product search

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/search",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG"
  },
  "body": {
    "search": "abc"
  }
}
```

```javascript
// POST /store-api/search

{
    "search": "braeburn"
}
```

Let's look at the response:

```javascript
{
  "sorting": "score",
  "currentFilters": {
    "manufacturer": [],
    "price": {
      "min": null,
      "max": null
    },
    "rating": null,
    "shipping-free": false,
    "properties": [],
    "search": "braeburn"
  },
  "page": 1,
  "limit": 24,
  "availableSortings": [
    {
      "key": "name-asc",
      "label": "Name A-Z",
      "id": "2526e30bf667446a888d04804483939b",
      "apiAlias": "product_sorting"
    },
    {
      "key": "name-desc",
      "label": "Name Z-A",
      "id": "3757223aef334b61a41c7d1b07fad8f1",
      "apiAlias": "product_sorting"
    },
    {
      "key": "price-asc",
      "label": "Price ascending",
      "id": "05d09bfc26c6468ca2ede06e0f8ebf52",
      "apiAlias": "product_sorting"
    },
    {
      "key": "price-desc",
      "label": "Price descending",
      "id": "79db02f2acf644178c0fae80434d95cd",
      "apiAlias": "product_sorting"
    },
    {
      "key": "score",
      "label": "Top results",
      "id": "12be6eee109444b39e15bf014bf8e928",
      "apiAlias": "product_sorting"
    },
    {
      "key": "topseller",
      "label": "Topseller",
      "id": "acbde485a5fd429c94dada82260c465a",
      "apiAlias": "product_sorting"
    }
  ],
  "total": 1,
  "aggregations": {
    "manufacturer": {
      "entities": [ ... ],
      "apiAlias": "manufacturer_aggregation"
    },
    "price": {
      "min": "149",
      "max": "149",
      "avg": null,
      "sum": null,
      "apiAlias": "price_aggregation"
    },
    "rating": {
      "max": 0,
      "apiAlias": "rating_aggregation"
    },
    "shipping-free": {
      "max": 0,
      "apiAlias": "shipping-free_aggregation"
    },
    "properties": { ... },
    "options": { ... }
  },
  "elements": [
    {
      "translated": {
        "name": "Box Braeburn Apples (2 kg)",
      },
      "id": "eaf1ee42ef884f3c941f22596aa0163f",
      "apiAlias": "product"
    }
  ],
  "apiAlias": "product_listing"
}
```

The response has the `ProductListingResult` type. Often, responses are some type of listings, such as products, categories or orders. These usually have the type `EntitySearchResult`. As you can see below, the `ProductListingResult` contains some additional fields which are helpful for building listing interactions.

```json json_schema
{
  "$ref": "../../../storeapi.json#/components/schemas/ProductListingResult"
}
```

## Refined search

We can apply any of the given sortings by passing them through the `order` field.

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/search",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG"
  },
  "body": {
    "search": "abc",
    "order": "topseller"
  }
}
```

```javascript
// POST /store-api/search

{
    "search": "braeburn",
    "order": "topseller"
}
```

Let's say you want to filter out products with a price higher than 50.00. We simply add a `filter` section and applying a `range` filter for the price field. Note, that `filter` is an array - you can pass in multiple filters at once.

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/search",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG"
  },
  "body": {
    "search": "abc",
    "order": "topseller",
    "filter": [
      {
        "type": "range",
        "field": "stock",
        "parameters": {
          "lt": 50
        }
      }
    ]
  }
}
```

```javascript
// POST /store-api/search

{
    "search": "braeburn",
    "order": "topseller",
    "filter": [
        {
            "type": "range",
            "field": "stock",
            "parameters": {
                "lt": 50.0
            }
        }
    ]
}
```

## Product listing criteria

Several endpoints accept additional search and filtering parameters, wrapped in a specification we refer to as product listing criteria. Most of these parameters are shorthands which could also be written using the search criteria specifications, some others add logic which is not supported by the search criteria, such as filtering by prices.

Endpoints supporting that specification are

 * /store-api/search
 * /store-api/product-listing/{categoryId}

All parameters are **optional** and can be passed within the request body.

```json json_schema
{
  "type": "object",
  "description": "Additional search parameters for product listings",
  "properties": {
    "order": {
      "description": "Specifies the sorting of the products by `availableSortings`. If not set, the default sorting will be set according to the shop settings. The available sorting options are sent within the response under the `availableSortings` key. In order to sort by a field, consider using the `sort` parameter from the listing criteria. Do not use both parameters together, as it might lead to unexpected results.",
      "type": "string"
    },
    "limit": {
      "description": "Number of items per result page. If not set, the limit will be set according to the default products per page, defined in the system settings.",
      "type": "integer",
      "minimum": 0
    },
    "p": {
      "description": "Search result page",
      "type": "integer",
      "default": 1
    },
    "manufacturer": {
      "description": "Filter by manufacturers. List of manufacturer identifiers separated by a `|`.",
      "type": "string"
    },
    "min-price": {
      "description": "Filters by a minimum product price. Has to be lower than the `max-price` filter.",
      "type": "integer",
      "minimum": 0,
      "default": 0
    },
    "max-price": {
      "description": "Filters by a maximum product price. Has to be higher than the `min-price` filter.",
      "type": "integer",
      "minimum": 0,
      "default": 0
    },
    "rating": {
      "description": "Filter products with a minimum average rating.",
      "type": "integer"
    },
    "shipping-free": {
      "description": "Filters products that are marked as shipping-free.",
      "type": "boolean",
      "default": false
    },
    "properties": {
      "description": "Filters products by their properties. List of property identifiers separated by a `|`.",
      "type": "string"
    },
    "manufacturer-filter": {
      "description": "Enables/disabled filtering by manufacturer. If set to false, the `manufacturer` filter will be ignored. Also the `aggregations[manufacturer]` key will be removed from the response.",
      "type": "boolean",
      "default": true
    },
    "price-filter": {
      "description": "Enables/disabled filtering by price. If set to false, the `min-price` and `max-price` filter will be ignored. Also the `aggregations[price]` key will be removed from the response.",
      "type": "boolean",
      "default": true
    },
    "rating-filter": {
      "description": "Enables/disabled filtering by rating. If set to false, the `rating` filter will be ignored. Also the `aggregations[rating]` key will be removed from the response.",
      "type": "boolean",
      "default": true
    },
    "shipping-free-filter": {
      "description": "Enables/disabled filtering by shipping-free products. If set to false, the `shipping-free` filter will be ignored. Also the `aggregations[shipping-free]` key will be removed from the response.",
      "type": "boolean",
      "default": true
    },
    "property-filter": {
      "description": "Enables/disabled filtering by properties products. If set to false, the `properties` filter will be ignored. Also the `aggregations[properties]` key will be removed from the response.",
      "type": "boolean",
      "default": true
    },
    "property-whitelist": {
      "description": "A whitelist of property identifiers which can be used for filtering. List of property identifiers separated by a `|`. The `property-filter` must be `true`, otherwise the whitelist has no effect.",
      "type": "string"
    },
    "reduce-aggregations":{
      "description": "By sending the parameter `reduce-aggregations` , the post-filters that were applied by the customer, are also applied to the aggregations. This has the consequence that only values are returned in the aggregations that would lead to further filter results. This parameter is a flag, the value has no effect.",
      "type": "string",
      "nullable": true
    }
  }
}
```

## Field projection

A single-product response from the search endpoint already measures ~11KB. That's because a lot of fields from the product are loaded eagerly. However, we can restrict response to only the fields that we need.

If you take a look at the search response from above - almost every object contains a `apiAlias` key. We can use this key to refer to a list of fields that we want to be included in our response.

The following request provides us with a response containing the most essential fields that we need to display a simple product listing which only measures ~2.5KB for a single-product listing.

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/search",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG"
  },
  "body": {
    "search": "abc",
    "includes": {
      "product_sorting": ["id", "translated"],
      "product_manufacturer": ["id", "translated"],
      "product": ["id", "name", "translated", "cover", "calculatedPrice"],
      "property_group": ["id", "name", "translated", "options"],
      "property_group_option": ["id", "name", "translated"],
      "calculated_price": ["totalPrice", "listPrice"],
      "product_media": ["media"],
      "media": ["thumbnails"],
      "media_thumbnail": ["width", "height", "url"]
    }
  }
}
```

```javascript
// POST /store-api/search

{
    "search": "breaburn",
    "includes": {
      "product_sorting": ["id", "translated"],
      "product_manufacturer": ["id", "translated"],
      "product": ["id", "name", "translated", "cover", "calculatedPrice"],
      "property_group": ["id", "name", "translated", "options"],
      "property_group_option": ["id", "name", "translated"],
      "calculated_price": ["totalPrice", "listPrice"],
      "product_media": ["media"],
      "media": ["thumbnails"],
      "media_thumbnail": ["width", "height", "url"]
    }
  }
```

It doesn't take a lot of time to shrink your response down to a fraction and you have full control over the fields it contains.

> Why is the **`translated`** field always included?
> 
> Most natural text fields in Shopware are stored as translatable values. Depending on the current language, Shopware will try to hydrate these fields with the correct value. Sometimes it occurs, that a text value is not maintained in a given language. For that case, Shopware provides a fallback mechanism based on a translation hierarchy. However, these fallback values are only contained in the translated field of the entity.
>
> By using **`product.translated.name`** instead of **`product.name`** you can make sure to always fall back correctly if there's no translated value present.

## Fetching associations

Sometimes it's necessary to fetch additional associations like categories or properties of a product. We can specify those additional associations using a corresponding field within the request body. All fields used in the example below are parts of the [Search Criteria](../../concepts/search-queries.md).

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/search",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG"
  },
  "body": {
    "search": "abc",
    "associations": {
      "categories": {}
    },
    "includes": {
      "product_listing": ["elements"],
      "product": ["id", "name", "translated", "categories"],
      "category": ["id", "name", "translated"]
    }
  }
}
```

```javascript
// POST /store-api/search

{
    "search": "braeburn",
    "associations": {
        "categories": {}
    },
    "includes": {
        "product_listing": ["elements"],
        "product": ["id", "translated", "categories"],
        "category": ["id", "translated"]
    }
}
```

Once we've provided the association, Shopware will try to fetch the related entities and hydrate the response accordingly.

> **Wonder which associations there are?**
>
> Normally, an unfiltered response already suggests which associations you could load. Usually these fields are pre-filled with `null` if the association is not fetched. You can always look into the corresponding entity schema given in our reference.
>
> Have a look at the [product schema](./c2NoOjE1MDg3ODI3-product)

## Fetch a single product

Sometimes, you just want to fetch a single product, the product endpoint \(as well as doing searches\) lets you do this

**Try it out**

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/product/b728db0e3fd04947ae2f8a79d72d1f26",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "sw-access-key": "SWSCDZH3WULKMDGXTMNQS2VRVG"
  }
}
```

```text
// POST /store-api/product/eaf1ee42ef884f3c941f22596aa0163f
```

Now that we're done with searching products, let's do something with them.

> Next Chapter: **[Work with the cart](work-with-the-cart.md)**
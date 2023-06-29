# Search Queries

Many endpoints provide enhanced search functionality that can thin down listing results, such as:

 * Products
 * Orders
 * Payment methods

Likely, the most interesting case for such queries is the filtering of products, but it generalizes to many other searches within your system.

These search queries are defined using criteria, passed within the body of `POST` request, or encoded as query parameters in any `GET` request.

> **How should I encode the criteria for `GET` requests?**
> 
> Some API endpoints use the `GET` method. To pass your search details here, you must encode and send them as query parameters. The PHP method [`http_build_query`](https://www.php.net/manual/en/function.http-build-query.php) will do the job for you.
>
> For example:
> ```json
> {
>   associations: {
>     lineItems: {
>       limit: 5  
>     }
>   },
>   limit: 1
> }
> ```
> becomes
>
> `?associations[lineItems][limit]=5&limit=1`

## Try it out

```json http
{
  "method": "post",
  "url": "http://localhost/store-api/product",
  "headers": {
    "Content-Type": "application/json",
    "sw-access-key": "SWSCY1NPSKHPSFNHWGDLTMM5NQ",
  },
  "body": {
    "filter": [{ 
      "type": "range", 
      "field": "stock", 
      "parameters": {
        "gte": 10,      
        "lte": 30
      }
    }],
    "associations": {
      "categories": {
        "limit": 1
      }
    },
    "includes": {
      "product": ["id", "name", "categories"],
      "category": ["name"],
      "aggregation_bucket": ["key"]
    },
    "aggregations": [{
      "name": "product-categories",
      "type": "terms",
      "field": "categories.name"
    }]
  }
}
```


## Structure

The search criteria follow the below schema:

```json json_schema
{
  "$ref": "../../storeapi.json#/components/schemas/Criteria"
}
```

In the following, you will go through the different parameters, a criteria can be assembled in-depth:

| Parameter | Usage |
| :--- | :--- |
| [**associations**](#associations) | Allows to load additional data to the standard data of an entity |
| [**includes**](#includes-apialias) | Restricts the output to the defined fields |
| [**ids**](#ids) | Limits the search to a list of Ids |
| [**total-count-mode**](#total-count-mode) | Defines whether a total must be determined |
| [**page**](#page--limit) | Defines at which page the search result should start |
| [**limit**](#page--limit) | Defines the number of entries to be determined |
| [**filter**](#filter) | Allows you to filter the results and aggregations |
| [**post-filter**](#post-filter) | Allows you to filter the result, but not the aggregations |
| [**query**](#query) | Enables you to determine a ranking for the search result |
| [**term**](#term) | Enables you to determine a ranking for the search result |
| [**sort**](#sort) | Defines the sorting of the search result |
| [**aggregations**](#aggregations) | Specifies aggregations to be computed on-the-fly |
| [**grouping**](#grouping) | Lets you group records by fields |

## Parameters

### ***associations***

The `associations` parameter allows you to load additional data to the minimal data set of an entity without sending another request. It is similar to SQL Join. The parameter's key is the association's property name in the entity. You can pass nested criteria just for that association, e.g., to perform a sort or to apply filters within the association.

```javascript
{
    "associations": {
        "products": {
            "limit": 5,
            "filter": [
                { "type": "equals", "field": "active", "value": true }
            ],
            "sort": [
                { "field": "name", "order": "ASC" }    
            ]
        }
    }
}
```

### ***includes (apiAlias)***

The `includes` parameter allows you to restrict the returned fields.

* Transfer what you only need reduces response payload
* Easier to consume for client applications
* When debugging, the response is smaller, and you can concentrate on the essential fields

```javascript
{
    "includes": {
        "product": ["id", "name"]
    }
}

// Response
{
    "total": 120,
    "data": [
        {
            "name": "Synergistic Rubber Fish Soda",
            "id": "012cd563cf8e4f0384eed93b5201cc98",
            "apiAlias": "product"
        },
        {
            "name": "Mediocre Plastic Ticket Lift",
            "id": "075fb241b769444bb72431f797fd5776",
            "apiAlias": "product"
        }
  ]
}
```

>  All response types come with an `apiAlias` field which you can use to identify the type in your `includes` field. If you only want a category id, then add: `"category": ["id"]`; for entities types, the following are few - `product`, `product_manufacturer`, `order_line_item`; check the complete response for other non-entity types like a listing result or a line item. This pattern applies not only to simple fields but also to associations.

#### ***Custom fields and includes***

A custom field set of entities is by default loaded in the response. You can include them as you would expect using the following payload:

```javascript
{
  "includes": {
    "product": ["customFields"]
  }
}
```

However, you might have many custom fields associated with your entity but might not want to fetch them all at once. In such a case, please stick to the following syntax:

```javascript
{
  "includes": {
    "product": [
      "customFields.ean_number",
      "customFields.delivery_from_warehouse_xy"
    ]
  }
}
```

this returns:

```javascript
[
  {
    "customFields": {
      "ean_number": "4006381333931",
      "delivery_from_warehouse_xy": true
    },
    "apiAlias": "product"
  }
]
```

#### ***Extensions and includes***

Shopware allows the addition of extensions to API payloads. You can simply use the extension's name to project it into the response. 
Say you have added an extension named `configuratorSetting` to every `PropertyGroupOption` struct. Just use it within your includes in the same fashion as any other field.

```javascript
{
  "includes": {
    "product_configurator_setting": ["media", "selected"],
    "property_group_option": ["configuratorSetting"]
  }
}
```

The extension then gets included in the `extension` object of that specific entity:

```javascript
{
  "options": [
    {
      "extensions": {
        "configuratorSetting": {
          "media": null,
          "selected": false,
          "apiAlias": "product_configurator_setting"
        }
      },
      "apiAlias": "property_group_option"
    },
    {
      "extensions": {
        "configuratorSetting": {
          "media": null,
          "selected": false,
          "apiAlias": "product_configurator_setting"
        }
      },
      "apiAlias": "property_group_option"
    }
  ]
}
```



### ***ids***

If you want to perform a simple lookup using just the record ids, you can pass a list of those using the `ids` field:

```javascript
{
    "ids": [
        "012cd563cf8e4f0384eed93b5201cc98", 
        "075fb241b769444bb72431f797fd5776",
        "090fcc2099794771935acf814e3fdb24"
    ]
}
```

### ***total-count-mode***

The `total-count-mode` parameter defines whether the total number of hits should be determined for the search query or not. This parameter supports the following values:

* `0 [default]` - No total is determined
  * Purpose: Should be used if pagination is not required
  * Advantage: This is the most performing mode because MySQL Server does not require running the `SQL_CALC_FOUND_ROWS` in the background.
* `1` - An exact total is determined
  * Purpose: Should be used if pagination with an exact page number has to be displayed
  * Disadvantage: Performance intensive. Here you have to work with `SQL_CALC_FOUND_ROWS`
* `2` - It is determined whether there is a next page
  * Purpose: Can be used well for infinite scrolling. With infinite scrolling, the information is enough to know if there is a next page to load
  * Advantage: Good performance, same as `0`.

```javascript
{
    "total-count-mode": 1
}
```

### ***page & limit***

The `page` and `limit` parameters are used to control pagination. The `page` parameter is 1-indexed.

```javascript
{
    "page": 1,
    "limit": 5
}
```

### ***filter***

The `filter` parameter allows you to filter the results and aggregations using many filters and parameters. The filter types are equivalent to the [filters available for the DAL](https://developer.shopware.com/docs/resources/references/core-reference/dal-reference/filters-reference).

> When you are filtering for nested values for example, you are filtering orders by their transaction state \(`order.transactions.stateMachineState`\) make sure to fetch those in your `associations` field before.

```javascript
{
  "associations": {
    "transactions": {
      "associations": {
        "stateMachineState": {}
      }
    }
  },
  "filter": [
    {
      "type": "multi",
      "operator": "and",
      "queries": [
        {
          "type": "multi",
          "operator": "or",
          "queries": [
            {
              "type": "equals",
              "field": "transactions.stateMachineState.technicalName",
              "value": "paid"
            },
            {
              "type": "equals",
              "field": "transactions.stateMachineState.technicalName",
              "value": "open"
            }
          ]
        },
        {
          "type": "equals",
          "field": "customFields.exportedFlag",
          "value": null
        }
      ]
    }
  ]
}
```

### ***post-filter***

This parameter works similarly to `filter` parameter. However, they do not apply to aggregations. This is great when you want to work with aggregations to display facets for a filter navigation but already filter results based on filters without making an additional request.

### ***query***

Use this parameter to create a weighted search query that returns a `_score` for each found entity. Any filter type can be used for the `query`. A `score` has to be defined for each query. The sum of the matching queries then results in the total `_score` value.

```javascript
{
    "query": [
        {
            "score": 500,
            "query": { "type": "contains", "field": "name", "value": "Bronze"}
        },
        { 
            "score": 500,
            "query": { "type": "equals", "field": "active", "value": true }
        },
        {
            "score": 100,
            "query": {
                "type": "equals",
                "field": "manufacturerId",
                "value": "db3c17b1e572432eb4a4c881b6f9d68f"
            }
        }
    ]
}
```

The resulting score is appended to every resulting record in the `extensions.search` field:

```javascript
{
    "total": 5,
    "data": [
        {
            "manufacturerId": "db3c17b1e572432eb4a4c881b6f9d68f",
            "name": "Awesome Bronze Krill Kream",
            "extensions": {
                "search": {
                    "_score": "1100"
                }
            },
            "id": "0acc3aa5c45a492c9a2adb8844cb7adc",
            "apiAlias": "product"
        },
        {
            "manufacturerId": "d0c0daa910d94b3c8b03c2bef6acb9b8",
            "name": "Synergistic Bronze New Tab",
            "extensions": {
                "search": {
                    "_score": "1000"
                }
            },
            "id": "72858576ac634f209b7ad61db15b7cc3",
            "apiAlias": "product"
        },
        {
            "manufacturerId": "3b5f9d51803849c68bb72360debd3da0",
            "name": "Fantastic Paper Zamox",
            "extensions": {
                "search": {
                    "_score": "500"
                }
            },
            "id": "18d2b4225ea34b17a6099108da159e7f",
            "apiAlias": "product"
        }
    ]
}
```

### ***term***

Using the `term` parameter, the server performs a text search on all records based on their data model and weighting as defined in the entity definition using the `SearchRanking` flag.

> Do not use `term` parameters together with `query` parameters.

```javascript
{
    "term": "Awesome Bronze"
}
```

The results are formatted the same as for the `query` parameter above.

## ***sort***

The `sort` parameter controls the sorting of results. Several sorts can be transferred at the same time.

* The `field` parameter defines which field is used for sorting
* The `order` parameter defines the sort direction
* The parameter `naturalSorting` allows to use a [Natural Sorting Algorithm](https://en.wikipedia.org/wiki/Natural_sort_order)

```javascript
{
    "limit": 5,
    "sort": [
        { "field": "name", "order": "ASC", "naturalSorting": true },
        { "field": "active", "order": "DESC" }    
    ]
}
```

## ***aggregations***

The `aggregations` parameter can determine metadata for a search query. There are different types of aggregations listed in the reference documentation. A simple example is determining the average price from a product search query.

* Purpose
    * Calculation of statistics and metrics
    * Determination of possible filters

The aggregation types are equivalent to the [aggregations available in the DAL](https://developer.shopware.com/docs/resources/references/core-reference/dal-reference/aggregations-reference).

```javascript
{
    "limit": 1,
    "includes": {
        "product": ["id", "name"]
    },
    "aggregations": [
        {
            "name": "average-price",
            "type": "avg",
            "field": "price"
        }    
    ]
}
```

## ***grouping***

The `grouping` parameter groups the result over fields. It can realize queries such as:

* Fetch one product for each manufacturer
* Fetch one order per day, and customer

```javascript
{
    "limit": 5,
    "grouping": ["active"]
}
```

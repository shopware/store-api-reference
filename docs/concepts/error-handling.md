# Error Handling
 The Store API works with HTTP response codes to indicate the outcome of an operation.
There are different types of responses and knowing about them will make your work way easier.‌

### Success

**200 OK** This is the most common response, indicating a successful operation. Oftentimes, the API responds with the entity you just modified or simply the `success: true` field in an object.‌

**204 No Content** Some endpoints respond with a no content response if it's more applicable.‌

```json json_schema
{
  "$ref": "../../storeapi.json#/components/schemas/SuccessResponse"
}
```

### Client Error

The API tries to resolve client errors and give an indication of what has gone wrong. Therefore, the response usually contains an `errors` field containing one or multiple errors to help you track them down. Each error contains a summary of the issue in the `detail` field.‌

```json json_schema
{
  "$ref": "../../storeapi.json#/components/schemas/failure"
}
```

> We have focused on documenting non-generic errors for every endpoint. Generic errors for resources, such as `400 Bad Request` for missing parameters or `404 Not Found` for not found resources are not documented in every endpoint.

**400 Bad Request** This response usually indicates that there's an issue with your request format - for example a missing parameter or violated constraints.‌

**401 Unauthorized** The unauthorised error indicates, that your [sales channel access key](../../../../guides/integrations-api/store-api-guide/#authentication-and-setup) is missing.‌

**403 Forbidden** This response indicates that you are not authorised to perform that operation. For some operations, such as _placing an order_ or _submitting a review_ you need to be logged in as a customer. In those cases, check your `sw-context-token` header and whether you're [logged in](https://app.gitbook.com/@shopware/s/shopware-1/~/drafts/-MU8LxyY2Ad3ushWb8Jl/guides/integrations-api/store-api-guide/register-a-customer#logging-in/@drafts).‌

**405 Method Not Allowed** The HTTP method used for the request is not valid.‌

**412 Precondition Failed** This error occurs if your [sales channel access key](../../../../guides/integrations-api/store-api-guide/) is invalid. Make sure that it matches any of your configured sales channels.‌

### Server Error

**5xx** Server errors are rare, but they occur. They can be related to inconsistencies in the DB, infrastructure outages or software issues. If you cannot backtrack that issue, please create an [issue ticket to let us know](https://issues.shopware.com/).‌

## Submit reference issues

If you find any issues, errors or missing parts in the reference, please create an issue or a pull request in our [Github Documentation repository](https://github.com/shopware/docs/issues).‌
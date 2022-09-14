# Error Handling
The Store API works with HTTP response codes to indicate the outcome of an operation. There are different categories of responses, and knowing them will make your work easier.‌

* 2XX - Successful
* 4XX - Client error
* 5XX - Server error

### 2XX Success

This category of status codes indicates the API request was received and realized.

**200 OK** is the most common response, indicating a successful operation. Often, the API responds with the entity you just modified or simply the `success: true` field in an object.‌

**204 No Content** implies the request was successful, and the response contains no data to return.

### 4XX Client Error

This category of status codes indicates that the error seems to have been caused by the requesting client. Therefore, the response usually contains the `errors` field with one or more errors to help you track them down. Each error contains a summary of the issue in the `detail` field.‌

```json json_schema
{
  "$ref": "../../storeapi.json#/components/schemas/failure"
}
```

**400 Bad Request** response usually indicates an issue with your request format, such as a missing parameter, violated constraints, or malformed request syntax.

**401 Unauthorized** indicates, that your [sales channel access key](../../docs/guides/quick-start/README.md/#authentication-and-setup) is missing.‌

**403 Forbidden** indicates the request contained valid data, but you are not authorized to perform the operation. Some operations, such as _placing an order_ or _submitting a review_ require the customer to be logged in. In such cases, check your `sw-context-token` header and whether you are logged in.‌

**405 Method Not Allowed** error occurs if the HTTP method used for the request is not valid.‌

**412 Precondition Failed** error occurs if your [sales channel access key](../../docs/guides/quick-start/README.md/#authentication-and-setup) is invalid. Make sure that it matches any of your configured sales channels.‌

> We have focused on documenting non-generic errors for every endpoint. Generic errors such as `400 Bad Request` for missing parameters or `404 Not Found` for resources not found are not documented in every endpoint.

### 5XX Server Error

Server errors are rare, but they occur. They can be related to inconsistencies in the database, infrastructure outages, or software issues. If you cannot backtrack that issue, please create an [issue ticket to let us know](https://issues.shopware.com/).‌

## Submit reference issues

If you find any issues, errors, or missing parts in the reference guide, please create an issue or a pull request in our [Github Documentation repository](https://github.com/shopware/docs/issues).‌

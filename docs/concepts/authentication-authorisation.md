# Authentication & Authorisation

Just as any shop frontend is public to its visitors, the Store API is a public API and does not have an actual authentication. However, some header credentials are to be provided to use the API.

| Header | Description | Required |
| --- | --- | --- |
| `sw-access-key` | identifies the sales channel | always |
| `sw-context-token` | identifies a user session | on some endpoints |

**Access Token**

You have to pass some type of identification for Shopware to determine the right sales channel for the API call. This identification is the `sw-access-key`. It is sent as an HTTP header. You can find the correct access key within your [admin panel's sales channel configuration](https://docs.shopware.com/en/shopware-6-en/settings/saleschannel#api-access) in the section labeled API Access.

**Context Token**

Besides Access Token for identification, some endpoints of the Store API are protected and require user authentication or at least a user state. Example endpoints are the `/account/login` or the `/checkout/cart`. These endpoints would not make without the context of a **specific user** because all state changes would immediately be lost. For this reason, there is the `sw-context-token` header. Think of it like a session ID. This token is **unique** per user and must not be shared with other users.

You can either set it by yourself (and make sure it is unique) or use the one passed within the server's corresponding response header.

**Note:** A context token does not imply that a user is logged in but is required for logged-in users.

### Try it out

```json http
{
  "method": "get",
  "url": "http://localhost/store-api/context",
  "headers": {
    "Content-Type": "application/json",
    "sw-access-key": "SWSCY1NPSKHPSFNHWGDLTMM5NQ"
  }
}
```

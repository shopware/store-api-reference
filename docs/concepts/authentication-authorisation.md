# Authentication & Authorisation

The Store API doesn't have a real authentication - it is a public API - just as any shop frontend is public to its visitors.

However, there are some header credentials that we have to provide in order to use the API.

| Header | Description | Required |
| --- | --- | --- |
| `sw-access-key` | Identifies the sales channel | always |
| `sw-context-token` | Identifies a user session | on some endpoints |

**Access Token (identification)**

We have to pass some type of identification so Shopware is able to determine the correct sales channel for the API call. This identification is the `sw-access-key` HTTP header. You can find the correct access key within your [admin panel's sales channel configuration](https://docs.shopware.com/en/shopware-6-en/settings/saleschannel#api-access) in a section labeled API Access.

**Context Token (user state)**

However, some endpoints of the Store API are protected and require a user authentication or at least a user state. Examples for those are the `/account/login` or the `/checkout/cart` endpoints. Using those endpoints wouldn't make without the context of a **specific user**, because all state changes would immediately be lost. For that reason, there is the `sw-context-token` header. Think of it like a session ID. This token is **unique** per user and must not be shared with other users.

You can either set it by yourself (and make sure it is unique) or use the one passed within the server's corresponding response header.

**Note:** A context token does not imply that your user is logged in, but it is required for logged in users to pass a context token.

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
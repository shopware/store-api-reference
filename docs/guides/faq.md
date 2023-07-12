# FAQ

**How do I fetch associations to my Store API request?**

> Sometimes the standard response from Store API requests is not enough for your use case; for example when fetching an order you would like to retrieve line items or images for a product. Just add those as an `associations` parameter.
>
> ```javascript
> {
>     "associations": {
>         "lineItems": {}
>     }
> }
> ```

**How to check whether a user is currently logged in?**

> The least you need in order to have logged in is, a `sw-context-token` header. In order to check whether you are actually logged in call the following endpoint
>
> ```text
> GET /store-api/account/customer
> ```
>
> If the user is logged in, you should see their information, else the response will contain a `403 Forbidden - CHECKOUT__CUSTOMER_NOT_LOGGED_IN` exception.

**Is there an SDK for the Store API?**

> In fact, there is a Javascript SDK which has been built as part of the Shopware PWA platform. Feel free to use it in any other Javascript-based projects - [https://www.npmjs.com/package/@shopware-pwa/shopware-6-client](https://www.npmjs.com/package/@shopware-pwa/shopware-6-client)

**My customFields only contain IDs and not the objects?**

> Oftentimes, custom fields are used to persist data \(such as images or files\) along with products or categories. However, Shopware doesn't hydrate these as objects when products are fetched, because it cannot ensure that they are valid references or objects. Custom fields can contain any value and are only hydrated by the admin panel for management purposes. If you want to fetch the object \(e.g. a media object\) instead you can either [decorate the corresponding service](https://developer.shopware.com/docs/guides/plugins/plugins/plugin-fundamentals/adjusting-service) *(Developer Documentation)* or add these entities as an association using an [entity extension](https://developer.shopware.com/docs/guides/plugins/plugins/framework/data-handling/add-complex-data-to-existing-entities) *(Developer Documentation)*.

**How can I fetch SEO URLs for requested categories or products**

> When your request includes the `sw-include-seo-urls: 1` header Shopware will automatically try to resolve relative URLs for all your categories and products. These will then be accessible in the `seoUrls` field of each record.  

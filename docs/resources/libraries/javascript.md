# Javascript SDKs

The [**shopware-6-client**](https://www.npmjs.com/package/@shopware-pwa/shopware-6-client) package provides interfaces for all Store API endpoints and can be used in any JS/Node.js based project.

## Installation

Install it using a package manager of your choice - for example yarn.

```bash
yarn add @shopware-pwa/shopware-6-client
```

## Initialization

Configure the client using the [credentials](../../concepts/authentication-authorisation.md) of your Shopware instance 

```javascript
import { setup } from "@shopware-pwa/shopware-6-client";

setup({
  endpoint: "https://address-to-my-shopware-instance.com",
  accessToken: "myaccesstoken",
});
```

## Usage

```javascript
import { getCategories } from "@shopware-pwa/shopware-6-client"

const categories = await getCategories();
```

The SDK comes with full typescript typehinting and completion. An overview of all endpoints can be [found here](https://shopware-pwa-docs.vuestorefront.io/landing/resources/api/shopware-6-client.html).
# Specification

The Shopware Core is written in PHP and we prefer to document our API format in the same place as the code that produces it. For that reason, we are using [swagger-php](https://github.com/zircote/swagger-php) to annotate our code and generate the specification for our API.

## Code Annotation Standard

An annotated operation looks like this:

```php
    /**
     * @Since("6.2.0.0")
     * @OA\Post(
     *      path="/account/register-confirm",
     *      summary="Confirm a customer registration",
     *      description="Confirms a customer registration when double opt-in is activated.

Learn more about double opt-in registration in our guide ""Register a customer"".",
     *      operationId="registerConfirm",
     *      tags={"Store API", "Login & Registration"},
     *      @OA\RequestBody(
     *          required=true,
     *          @OA\JsonContent(
     *              required={
     *                  "hash",
     *                  "em"
     *              },
     *              @OA\Property(
     *                  property="hash",
     *                  type="string",
     *                  description="Hash from the email received"),
     *              @OA\Property(
     *                  property="em",
     *                  type="string",
     *                  description="Email hash from the email received"),
     *          )
     *      ),
     *      @OA\Response(
     *          response="200",
     *          description="Returns the logged in customer. The customer is automatically logged in with the `sw-context-token` header provided, which can be reused for subsequent requests."
     *      ),
     *      @OA\Response(
     *          response="404",
     *          description="No hash provided"
     *      ),
     *      @OA\Response(
     *          response="412",
     *          description="The customer has already been confirmed"
     *      )
     * )
     * @Route("/store-api/account/register-confirm", name="store-api.account.register.confirm", methods={"POST"})
     */

public function confirm(RequestDataBag $dataBag, SalesChannelContext $context): CustomerResponse
{
  /* Code */
}
```

In order to understand the different parts of the annotation, let's take it apart step by step.

## Structure of an Endpoint Annotation

```
@OA\Post(
```

Declares the **operation** as a `POST` operation.

```
path="/account/register-confirm"
```

Sets the **endpoint path** relative to the API endpoint (`store-api`)

```
summary="Confirm a customer registration",
description="Confirms a customer registration when double opt-in is activated.

Learn more about double opt-in registration in our guide ""Register a customer"".",
```

**Title** (summary) and **long description** (description) for the endpoint respectively. `description` can contain Markdown, line breaks and special characters (escaped).

```
operationId="registerConfirm",
tags={"Store API", "Login & Registration"},
```

Unique **ID** for the operation and **exactly two** tags. Please try to use existing tags, so that each tag contains a maximum 10 operations. One of the tags has to be `Store API`.

```
@OA\RequestBody(
    required=true,
```

This annotation contains a description of the request body. If your endpoint expects a body payload, `required` must be set to `true`, as its default is `false`.

```
@OA\JsonContent
```

Describes the **payload** format within the body.

> The payload can be described in two ways. Either using **properties** or using an **existing schema**.
>
> **Properties**
>
> ```
>@OA\JsonContent()
>   required={
>       "hash",
>       "em"
>   },
>   @OA\Property(
>       property="hash",
>       type="string",
>       description="Hash from the email received"),
>   @OA\Property(
>       property="em",
>       type="string",
>       description="Email hash from the email received"))
>```
>
> Note, that the *required* fields are passed in a separate array.
>
> ** Existing Schema** 
>```
@OA\JsonContent(ref="#/components/schemas/category_flat")
>```

```
@OA\Parameter(
  name="categoryId",
  description="Identifier of the category to be fetched",
  @OA\Schema(type="string"),
  in="path",
  required=true
),
```

Describes a **parameter** (e.g. path, query or header parameters). Note, that parameters contain a `required` field in contrast to schema properties.

```
@OA\Response(
    response="200",
    ref="#/components/responses/200",
    description="Returns the logged in customer. The customer is automatically logged in with the `sw-context-token` header provided, which can be reused for subsequent requests."
)
```

Describes a **response**. An operation can have multiple responses (with different response codes). A response can **optionally** contain a schema.

### General Guidelines

* If a property or a parameter is optional, please document the *default* value or the default behavior.
* Be comprehensive in your descriptions for operations, parameters, properties and responses. The more, the better.
* Make use of Markdown syntax in descriptions, when it's beneficial. It's totally fine according to the standard.
* Document not only the happy case, but also errors that can be handled by the client. (Work with response codes!)
* Mark required fields as such

These annotations fully support the OpenAPI 3.0 Specification. If you want to exploit OpenAPI 3.0 in its entirety, check out the full [OpenAPI specification](https://swagger.io/specification/).
# Shopware 6 Store API Reference

This repository reflects our official Store API reference and documentation available on [shopware.stoplight.io/docs/store-api](https://shopware.stoplight.io/docs/store-api).

![Store API Reference Screenshot](assets/images/reference-screenshot.png)

## Notes

The `storeapi.json` file contains the OpenAPI schema. Please do not make manual changes to that file, since it is synchronized with the latest version using an automated action. Feel free to propose changes to all other files in this repository.

## Version branches

Different branches (e.g. `trunk`, `latest`, `v6.6`) hold API schemas for different Shopware 6 versions. Workflows and docs are maintained on the default branch and can be synced into version branches by merging from main; generated schema JSON files on each branch are kept automatically. See [Version branches and syncing workflows](docs/concepts/version-branches.md). If you work with version branches, run once per clone: `git config merge.keepSchema.driver true`.

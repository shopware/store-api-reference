#! /bin/env bash

for k in $(yq '. | keys | .[]' descriptions.yml); do
    newDescription=$(yq ".\"$k\"" descriptions.yml);
    yq -iPo json "$k.description = \"${newDescription}\"" storeapi.json;
done
#! /bin/env bash

for k in $(yq '. | keys | .[]' override.yml); do
    newDescription=$(yq ".\"$k\"" override.yml);
    yq -iPo json "$k.description = \"${newDescription}\"" storeapi.json;
done
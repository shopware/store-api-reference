#! /bin/env bash

for k in $(yq '. | keys | .[]' descriptions.yml); do
    newDescription=$(yq ".\"$k\"" descriptions.yml);
    yq  -I 4 -o json -iP "$k.description = \"${newDescription}\"" storeapi.json;
done
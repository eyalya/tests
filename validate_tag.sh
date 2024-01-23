#!/usr/bin/env bash


# validate branch tag is valid for docker image  
# remove invalid chars
# if its too long then shorten it
# tag
# push

function validateTag() {
    tag=$(sed 's/[^a-zA-Z0-9.]/_/g' <<< $tag);
    tag=$(tr -s '__' <<< $tag);
    while [ ${tag::1} == "." ]; do tag="${tag#?}"; done
    while [ ${tag: -1} == "." ]; do tag="${tag%?}"; done
    while [ ${tag::1} == "_" ]; do tag="${tag#?}"; done
    if [[ ${#tag} -gt 127 ]]; then 
        echo "The tag is too long. It will truncate the tag."
        echo "Old tag: $tag"
        tag=$(head -c 127 <<<$tag)
        echo "New tag: $tag"
    fi
}


# fail the buiold if its longer than 128 chars

while getopts t: options; do
    case $options in
        t)tag=$OPTARG; validateTag ;;
        *)echo "invalid option";;
    esac
done
echo "APP_VERSION: $tag"
echo "APP_VERSION=$VALIDATED_TAG" >> $GITHUB_ENV   
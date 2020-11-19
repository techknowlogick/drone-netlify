#!/bin/sh
set -e

NETLIFY_SITE=""
NETLIFY_DEPLOY_OPTIONS=""
NETLIFY_UPDATE_OPTIONS=""

if [ -n "$PLUGIN_ENVIRONMENT" ]
then
    NETLIFY_DEPLOY_OPTIONS="-e ${PLUGIN_ENVIRONMENT}"
    NETLIFY_UPDATE_OPTIONS="${NETLIFY_DEPLOY_OPTIONS}"
fi

if [ -n "$PLUGIN_PATH" ]
then
    NETLIFY_DEPLOY_OPTIONS="${NETLIFY_DEPLOY_OPTIONS} -d ${PLUGIN_PATH}"
else
    NETLIFY_DEPLOY_OPTIONS="${NETLIFY_DEPLOY_OPTIONS} -d ./"
fi

if [ -z "$PLUGIN_TOKEN" ]
then
    if [ -z "$NETLIFY_TOKEN" ]
    then
        echo "> Error! token or netlify_token secret is required"
        exit 1;
    else
        PLUGIN_TOKEN="$NETLIFY_TOKEN"
    fi
fi

if [ -n "$PLUGIN_SITE_ID" ] && [ -n "$PLUGIN_TOKEN" ]
then
    NETLIFY_SITE="--prod -a $PLUGIN_TOKEN -s $PLUGIN_SITE_ID"
    echo "> Deploying on Netlify…" &&
    netlify deploy $NETLIFY_SITE $NETLIFY_DEPLOY_OPTIONS;
else
    echo "> Error! site_id and token are required"
    exit 1
fi

if [ -n "$PLUGIN_SITE_NAME" ]
then
    NETLIFY_UPDATE_OPTIONS="${NETLIFY_UPDATE_OPTIONS} -n ${PLUGIN_SITE_NAME}"
fi

if [ -n "$PLUGIN_DOMAIN" ]
then
    NETLIFY_UPDATE_OPTIONS="${NETLIFY_UPDATE_OPTIONS} -d ${PLUGIN_DOMAIN}"
fi

if [ -n "$PLUGIN_SITE_NAME" ] || [ -n "$PLUGIN_DOMAIN" ]
then
    echo "> Updating your Netlify site…" &&
    netlify $NETLIFY_SITE update $NETLIFY_UPDATE_OPTIONS;
fi

rc=$?;
if [[ $rc != 0 ]]
then 
    echo "> non-zero exit code $rc" &&
    exit $rc
else
    echo $'\n'"> Successfully deployed!"$'\n'
fi

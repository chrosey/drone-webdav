#!/bin/bash

# Use WEBDAV_USERNAME or WEBDAV_PASSWORD as default, if provided
if [ -z "$PLUGIN_USERNAME" ] && [ ! -z "$WEBDAV_USERNAME" ]; then
    PLUGIN_USERNAME="$WEBDAV_USERNAME"
fi
if [ -z "$PLUGIN_PASSWORD" ] && [ ! -z "$WEBDAV_PASSWORD" ]; then
    PLUGIN_PASSWORD="$WEBDAV_PASSWORD"
fi

# If username and password are provided, add auth
if [ ! -z "$PLUGIN_USERNAME" ] && [ ! -z "$PLUGIN_PASSWORD" ]; then
    AUTH="-u ${PLUGIN_USERNAME}:${PLUGIN_PASSWORD}"
fi


find $PLUGIN_FILE > target_file
sum_num=`cat target_file |wc -l`

curl -s -X DELETE $AUTH $PLUGIN_DESTINATION -f
curl -s -X MKCOL $AUTH $PLUGIN_DESTINATION -f

for((i=1;i<sum_num;i++))
do
        upload_file=`sed -n "$i"p target_file`
        if [ -f $upload_file ];then
                echo uploading $upload_file to $PLUGIN_DESTINATION$upload_file
                curl -s $AUTH -T $upload_file $PLUGIN_DESTINATION$upload_file -f
        else
                # create file in remote
                dirs=${upload_file//// }
                BASE=$PLUGIN_DESTINATION
                for dir in ${dirs[@]}
                do
                    BASE=$BASE/$dir
                    echo create dir $BASE
                    curl -s $AUTH -X MKCOL $BASE
                done
        fi
done

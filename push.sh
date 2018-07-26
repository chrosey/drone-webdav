#!/bin/sh

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

curl -X DELETE $AUTH $PLUGIN_DESTINATION -f

for((i=1;i<sum_num;i++))
do
        upload_file=`sed -n "$i"p target_file`
        if [ -f $upload_file ];then
                echo uploading $upload_file
                curl $AUTH -T $upload_file $PLUGIN_DESTINATION$upload_file -f
        else
                # create file in remote
                echo create dir $upload_file
                curl $AUTH -X MKCOL $PLUGIN_DESTINATION$upload_file -f
        fi
done

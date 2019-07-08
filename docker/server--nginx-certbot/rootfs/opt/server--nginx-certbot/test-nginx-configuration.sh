#!/bin/bash

nginx -t

if [ ${?} -eq 0 ];then
    echo "true"
else
    echo "false"
fi
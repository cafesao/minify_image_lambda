#!/bin/bash

zip -r minify.zip . -x '*.git*' '/aws*' '/image*' '*.sh' '*.md' 'LICENSE'
aws s3 cp minify.zip s3://optimize-s3-code  
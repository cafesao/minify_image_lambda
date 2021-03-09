#!/bin/bash

echo 'Copy Images...'
aws s3 cp ../../image s3://optimize-bucket-image/uploads/ --recursive
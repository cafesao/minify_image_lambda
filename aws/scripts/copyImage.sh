#!/bin/bash

echo 'Copy Images...'
aws s3 cp ../../images s3://optimize-bucket-image/uploads/ --recursive
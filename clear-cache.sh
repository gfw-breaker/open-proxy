#!/bin/bash

rm -fr /usr/local/nginx/content/cache/*
rm -fr /usr/share/nginx/cache/*

service nginx restart



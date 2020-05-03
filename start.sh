#!/bin/bash

service nginx start
echo "Test nginx with the following commands:"
echo "curl localhost"
echo "curl localhost:8080"
zsh
exec "$@"
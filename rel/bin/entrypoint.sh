#!/bin/ash -e

NODE_IP=$(hostname -i)
export NODE_IP

exec "$@"

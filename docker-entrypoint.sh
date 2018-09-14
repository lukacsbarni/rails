#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "Waiting for Mysql to start..."
while ! nc -z mysql 3306; do sleep 0.1; done
echo "Mysql is up and running"

exec bundle exec "$@"
#exec "$@"

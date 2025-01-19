#!/bin/bash

cp /app/lazymc.toml /app/config/lazymc.toml
sed -ie 's/__SERVER__/'"$APP_SERVER"'/g'  /app/config/lazymc.toml
sed -ie 's/__SERVER__/'"$APP_SERVER"'/g'  /app/config/lazymc.toml

echo "[APP] Configuration is:"
cat /app/config/lazymc.toml

echo "[APP] starting lazymc"

/app/lazymc -c /app/config/lazymc.toml
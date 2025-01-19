#!/bin/bash

cp /app/lazymc.toml /app/config/lazymc.toml
sed -ie 's/__SERVER__/'"$APP_SERVER"'/g'  /app/config/lazymc.toml
sed -ie 's/__SERVER__/'"$APP_SERVER"'/g'  /app/config/lazymc.toml

/app/lazymc -c /app/config/lazymc.toml
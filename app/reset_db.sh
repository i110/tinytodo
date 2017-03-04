#!/bin/sh
if [ -f tinytodo.db ]; then
    rm tinytodo.db
fi
sqlite3 tinytodo.db 'CREATE TABLE items (id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT default "" not null, done integer default 0 not null)'

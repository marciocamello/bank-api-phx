#!/bin/bash

str=`date -Ins | md5sum`
name=${str:0:10}

mix ecto.create
mix ecto.migrate

iex -S mix phx.server
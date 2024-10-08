#!/usr/bin/env bash

username="$(whoami)"
realname="$(getent passwd "${username}" | cut -d ':' -f 5 | cut -d ',' -f 1)"
class=powermenu

echo -e "{\"text\":\""$realname"\", \"class\":\""$class"\"}"

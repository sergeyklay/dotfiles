#!/bin/bash

while read ext; do
  code --install-extension "$ext" --force ;
done < code-list-extensions

#!/bin/bash

while read ext; do code --install-extension "$ext" ; done < code-list-extensions

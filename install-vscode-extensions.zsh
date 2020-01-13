#!/usr/bin/env zsh

>&1 printf "===========================================\n"
>&1 printf "Installing or updating extensions...\n"
>&1 printf "===========================================\n\n"

while read ext; do
  code --install-extension "$ext" --force ;
done < code-list-extensions

>&1 printf "\n===========================================\n"
>&1 printf "Uninstalling no longer used extensions...\n"
>&1 printf "===========================================\n\n"

for ext in $(code --list-extensions); do
  grep "${ext}" code-list-extensions 1>/dev/null || \
    code --uninstall-extension "${ext}"
done

# Local Variables:
# mode: sh
# End:

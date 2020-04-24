# Check whether the string given is already in the PATH.
pathmunge () {
  if ! echo "$PATH" | grep -Eq "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      export PATH="$PATH:$1"
    else
      export PATH="$1:$PATH"
    fi
  fi
}

# Local Variables:
# mode: sh
# End:

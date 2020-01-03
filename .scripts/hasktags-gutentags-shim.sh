#!/bin/bash
set -euo pipefail
#
# A hack to get hasktags working with vim-gutentags
#
# In vimrc:
#
#     let g:gutentags_project_info = []
#     call add(g:gutentags_project_info, {'type': 'haskell', 'file': 'stack.yaml'})
#     call add(g:gutentags_project_info, {'type': 'haskell', 'glob': '*.cabal'})
#     let g:gutentags_ctags_executable_haskell = 'hasktags-gutentags-shim.sh'
#

append=0  # Ignored

while [[ "$#" -gt 0 ]]; do case $1 in
  -f|--file)   tagsfile="$2";      shift;;
  --options=*) options="${1#*=}"      ;;  # Ignored; used for some reason to pass --recurse=true
  -a|--append) append=1               ;;
  *)           path="$1"              ;;  # Assume last param
esac; shift; done

# This lets us ignore `--append`:
touch "$tagsfile"

# ASCII merge changed file tags with (possibly empty) existing tags:
hasktags -R -c --file -  "$path" |\
  LC_ALL=C sort -m "$tagsfile" - -o "$tagsfile"

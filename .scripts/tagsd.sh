#!/usr/bin/env sh
# https://gist.github.com/romainl/5f943706f33ee657f9ba4556c55d4760

# Requirements:
#     git: https://git-scm.com/downloads
#     entr: http://eradman.com/entrproject/
#     ctags: http://ctags.sourceforge.net/ (Exuberant Ctags) or https://ctags.io/ (Universal Ctags)

# Usage:
#     $ cd my_project
#     $ ctagsd

while true; do
	git ls-files --modified --exclude-standard --others | entr -dnp ctags -R . >/dev/null 2>&1
done

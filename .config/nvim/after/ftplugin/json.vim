setlocal shiftwidth=2
setlocal tabstop=2

let &formatprg='python -c "import json, sys, collections;
      \ print json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict),
      \ ensure_ascii=False, indent=' . &shiftwidth . ')" 2>/dev/null'

if executable('jq')
  let &formatprg='jq . --indent ' . &shiftwidth . ' 2>/dev/null'
endif

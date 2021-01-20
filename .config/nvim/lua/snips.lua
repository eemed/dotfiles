local snippets = require'snippets'

-- snippets.use_suggested_mappings()
--
snippets.set_ux(require'snippets.inserters.text_markers')

local U = require'snippets.utils'

snippets.snippets = {
  rust = {
    pr = [[println!("$0");]];
    prd = [[println!("{:?}", $0);]];
    -- req = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']];
    -- func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]];
    -- ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]];
    -- Match the indentation of the current line for newlines.
    -- ["for"] = U.match_indentation [[
-- for ${1:i}, ${2:v} in ipairs(${3:t}) do
--   $0
-- end]];
  };
    python = {
        she = [[#!/usr/bin/env python3]]
    };
    sh = {
        she = [[#!/usr/bin/env bash]]
    };
  _global = {
    me = [[Eemeli Lottonen]];
    -- If you aren't inside of a comment, make the line a comment.
    -- copyright = U.force_comment [[Copyright (C) Ashkan Kiani ${=os.date("%Y")}]];
  };
}

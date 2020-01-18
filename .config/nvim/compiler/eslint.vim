if exists("current_compiler")
  finish
endif
let current_compiler = "eslint"

CompilerSet makeprg=npx\ eslint\ --format\ unix\ %:S

CompilerSet errorformat=%A%f:%l:%c:%m,%-G\\s%#,%-G%*\\d\ problem%.%#

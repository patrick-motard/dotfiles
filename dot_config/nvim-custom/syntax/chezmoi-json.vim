if exists('b:current_syntax')
  finish
endif

runtime! syntax/json.vim
unlet! b:current_syntax

syntax region chezmoiTemplate start="{{-\?" end="-\?}}" keepend contains=chezmoiTemplateDelimiter,chezmoiTemplateKeyword,chezmoiTemplateVariable,chezmoiTemplateFunction,chezmoiTemplateString,chezmoiTemplateOperator
syntax match chezmoiTemplateDelimiter /{{-\?\|-\?}}/ contained
syntax match chezmoiTemplateFunction /\<[A-Za-z_][A-Za-z0-9_]*\ze\s*(\?/ contained
syntax match chezmoiTemplateKeyword /\<\(if\|else\|end\|range\|with\|define\|template\|block\)\>/ contained
syntax match chezmoiTemplateVariable /\.[A-Za-z_][A-Za-z0-9_.]*/ contained
syntax match chezmoiTemplateString /"\%([^"\\]\|\\.\)*"/ contained
syntax match chezmoiTemplateOperator /[:|=]/ contained

highlight default link chezmoiTemplateDelimiter Delimiter
highlight default link chezmoiTemplateKeyword Keyword
highlight default link chezmoiTemplateVariable Identifier
highlight default link chezmoiTemplateFunction Function
highlight default link chezmoiTemplateString String
highlight default link chezmoiTemplateOperator Operator

let b:current_syntax = 'chezmoi-json'

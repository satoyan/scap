function! s:getSelectedLines()
  let l:select_from = getpos("'<")[1]
  let l:select_to = getpos("'>")[1]
  return getline(l:select_from, l:select_to)
endfunction

function! s:padding(s,number)
  return repeat(' ', a:number - len(a:s)) . a:s
endfunction

function! s:getSelectedLinesWithLineNumbers()
  let l:select_from = getpos("'<")[1]
  let l:select_to = getpos("'>")[1]
  let l:lines = getline(l:select_from, l:select_to)
  let l:maxLen = len(l:select_to)
  let l:linesWithLineNumbers = map(l:lines, {i, val
        \ -> s:padding((i + l:select_from), l:maxLen)  . '  ' . val})
  return l:linesWithLineNumbers
endfunction

function! s:buildTitle()
  let l:select_from = getpos("'<")[1]
  let l:select_to = getpos("'>")[1]
  let l:file_name = expand('%:.')
  return l:file_name . ' Line:' . l:select_from . '%7E' . l:select_to "
endfunction

function! s:encodeBase64(code)
  if has('macunix')
    return system('echo ' . shellescape(a:code) . ' | base64')
  elseif has("linux")
    return system('echo ' . shellescape(a:code) . ' | base64 --wrap=0 --ignore-garbage')
  endif
endfunction

function! s:buildFileName()
  let l:select_from = getpos("'<")[1]
  let l:select_to = getpos("'>")[1]
  let l:file_name = expand('%:.')
  return l:file_name . ':' . l:select_from
endfunction

function! s:getCommentString()
  return substitute(&commentstring, '%s', '', 'g')
endfunction

function! scap#CopyAsMarkdown() range
  let l:lang = &filetype
  let l:fileName = s:buildFileName()
  let l:content = '_```' . l:fileName . '```_' . "\n"
      \. '```' . l:lang . "\n"
      \. join(s:getSelectedLines(), "\r\n")
      \. "\n```"

  let @a = l:content
  let @+=@a
endfunction

function! scap#Capture() range
  let l:code = join(s:getSelectedLines(), "\r\n")
  let l:urlBase = 'https://ray.so'
  let l:title = s:buildTitle()
  let l:language = &filetype
  let l:colors = get(g:,'scap_colors', 'breeze')
  let l:dark_mode = 'true'
  let l:padding = 32
  let l:codeBase64 = s:encodeBase64(l:code)
  let l:background = get(g:, 'scap_background', 'false')

  let l:url = l:urlBase
     \. '#title=' . l:title
     \. '&language=' . l:language
     \. '&theme=' . l:colors
     \. '&darkMode=' . l:dark_mode
     \. '&padding=' . l:padding
     \. '&background=' . l:background
     \. '&code=' . l:codeBase64

  let l:result = system('open ' . shellescape(substitute(l:url, '+', '%2B', 'g')))
endfunction


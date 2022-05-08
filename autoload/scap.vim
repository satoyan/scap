function! scap#GetSelectedLines()
  let l:select_from = getpos("'<")[1]
  let l:select_to = getpos("'>")[1]
  return getline(l:select_from, l:select_to)
endfunction

function! scap#BuildTitle()
  let l:select_from = getpos("'<")[1]
  let l:select_to = getpos("'>")[1]
  let l:file_name = expand('%:.')
  return l:file_name . ' Line:' . l:select_from . '%7E' . l:select_to "%7E = ~
endfunction

function! scap#EncodeBase64(code)
  if has('macunix')
    return system('echo ' . shellescape(a:code) . ' | base64')
  elseif has("linux")
    return system('echo ' . shellescape(a:code) . ' | base64 --wrap=0 --ignore-garbage')
  endif
endfunction

function! scap#Capture() range
  let l:code = join(scap#GetSelectedLines(), "\r\n")
  let l:urlBase = 'https://ray.so'
  let l:title = scap#BuildTitle()
  let l:language = &filetype
  let l:colors = 'breeze'
  let l:dark_mode = 'true'
  let l:padding = 32
  let l:codeBase64 = scap#EncodeBase64(l:code)

  let l:url = l:urlBase
     \. '?title=' . l:title
     \. '&language=' . l:language
     \. '&colors=' . l:colors
     \. '&darkMode=' . l:dark_mode
     \. '&padding=' . l:padding
     \. '&code=' . l:codeBase64

  let l:result = system('open ' . shellescape(substitute(l:url, '+', '%2B', 'g')))
endfunction


" Statusline highlight
" From https://github.com/phaazon/config/blob/master/nvim-lua/statusline.vim
hi StatusLineBg guibg=#23272e guifg=#efefef
hi StatusLineBg2 guibg=#23272e guifg=#efefef
hi StatusLineBg2b guibg=#23272e guifg=#5B6268
hi StatusLineBg2c guibg=#5B6268 guifg=#23272e

hi StatusLineLinNbr guibg=#23272e guifg=#51afef
hi StatusLineColNbr guibg=#23272e guifg=#98be65

hi StatusLineGitBranchSymbol guibg=#23272e guifg=#ff6c6b
hi StatusLineGitBranchName guibg=#23272e guifg=#da8548
hi StatusLineGitDiffNone guibg=#23272e guifg=#98be65
hi StatusLineGitDiffAdd guibg=#23272e guifg=LightGreen
hi StatusLineGitDiffMod guibg=#23272e guifg=LightBlue
hi StatusLineGitDiffDel guibg=#23272e guifg=LightRed

hi StatusLineALEMsg guibg=#23272e guifg=#da8548
hi StatusLineALEErrors guibg=#23272e guifg=#ff6c6b
hi StatusLineALEWarnings guibg=#23272e guifg=#ECBE7B
hi StatusLineALEInformations guibg=#23272e guifg=#51afef
hi StatusLineALEHints guibg=#23272e guifg=#c678dd

hi StatusLineCurrentSymbolName guibg=#23272e guifg=#c678dd
hi StatusLineCurrentSymbolType guibg=#23272e guifg=#98be65 gui=italic
hi StatusLineCurrentSymbolBracket guibg=#23272e guifg=#5B6268 gui=italic

hi StatusLineNormalMode guibg=#51afef guifg=#23272e
hi StatusLineNormalModeItalic guibg=#51afef guifg=#23272e gui=italic
hi StatusLineNormalModeWinNr guibg=#317a91 guifg=#23272e

hi StatusLineInsertMode guibg=#98be65 guifg=#23272e
hi StatusLineInsertModeItalic guibg=#98be65 guifg=#23272e gui=italic
hi StatusLineInsertModeWinNr guibg=#62803b guifg=#23272e

hi StatusLineReplaceMode guibg=#ff6c6b guifg=#23272e
hi StatusLineReplaceModeItalic guibg=#ff6c6b guifg=#23272e
hi StatusLineReplaceModeWinNr guibg=#b64a49 guifg=#23272e

hi StatusLineVisualMode guibg=#fe8019 guifg=#23272e
hi StatusLineVisualModeItalic guibg=#fe8019 guifg=#23272e gui=italic
hi StatusLineVisualModeWinNr guibg=#994806 guifg=#23272e
hi StatusLineVisualBlockMode guibg=#fe8019 guifg=#23272e
hi StatusLineVisualBlockModeItalic guibg=#fe8019 guifg=#23272e gui=italic
hi StatusLineVisualBlockModeWinNr guibg=#994806 guifg=#23272e
hi StatusLineVisualLineMode guibg=#fe8019 guifg=#23272e
hi StatusLineVisualLineModeItalic guibg=#fe8019 guifg=#23272e gui=italic
hi StatusLineVisualLineModeWinNr guibg=#994806 guifg=#23272e
hi StatusLineSelectMode guibg=#fe8019 guifg=#23272e
hi StatusLineSelectModeItalic guibg=#fe8019 guifg=#23272e gui=italic
hi StatusLineSelectModeWinNr guibg=#994806 guifg=#23272e
hi StatusLineSelectLineMode guibg=#fe8019 guifg=#23272e
hi StatusLineSelectLineModeItalic guibg=#fe8019 guifg=#23272e gui=italic
hi StatusLineSelectLineModeWinNr guibg=#994806 guifg=#23272e
hi StatusLineSelectBlockMode guibg=#fe8019 guifg=#23272e
hi StatusLineSelectBlockModeItalic guibg=#fe8019 guifg=#23272e gui=italic
hi StatusLineSelectBlockModeWinNr guibg=#994806 guifg=#23272e

hi StatusLineCommandMode guibg=#5B6268 guifg=#23272e
hi StatusLineCommandModeItalic guibg=#5B6268 guifg=#23272e gui=italic
hi StatusLineCommandModeWinNr guibg=#42474b guifg=#23272e

hi StatusLineHitEnterPromptMode guibg=#ff6c6b guifg=#23272e
hi StatusLineHitEnterPromptModeItalic guibg=#ff6c6b guifg=#23272e gui=italic
hi StatusLineHitEnterPromptModeWinNr guibg=#b64a49 guifg=#23272e

if !exists('g:statusline_ignore')
  let g:statusline_ignore = {
        \ 'help': '[Help]',
        \ 'startify': '[Startify]',
        \ 'coc-explorer': '[Coc-Explorer]'}
end

function! s:win_id2alpha(id)
  let alpha = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '\zs')
  return get(alpha, a:id - 1, '?')
endf

function! VcsStatus()
  let branch = fugitive#head()
  let b:branch_maxwin = 20

  if branch ==# ''
    return ''
  endif

  let hunk_stat = get(b:,'gitsigns_status_dict', {})
  let a = get(hunk_stat, 'added', 0)
  let m = get(hunk_stat, 'changed', 0)
  let r = get(hunk_stat, 'removed', 0)
  let ahl = ''
  let mhl = ''
  let rhl = ''
  if a > 0
    let ahl .= '%#StatusLineGitDiffAdd#'
  else
    let ahl .= '%#StatusLineBg2b#'
  end

  if m > 0
    let mhl .= '%#StatusLineGitDiffMod#'
  else
    let mhl .= '%#StatusLineBg2b#'
  end

  if r > 0
    let rhl .= '%#StatusLineGitDiffDel#'
  else
    let rhl .= '%#StatusLineBg2b#'
  end

  return printf(' %%#StatusLineGitBranchSymbol# %%#StatusLineGitBranchName#%s %s %d  %s %d  %s %d ', trim(branch), ahl, a, mhl, m, rhl, r)
endfunction

function! ALEStatus() abort
  let sl = ''
  let ale_res = ale#statusline#Count(winbufnr(g:statusline_winid))

  let total = ale_res['total']
  if total > 0
    let sl .= '%#StatusLineALEMsg#'
  else
    let sl .= '%#StatusLineBg2b#'
  end
  let l:linter = get(g:ale_linters, &filetype, [])
  if l:linter ==# []
    let sl .= ' '
  else
    let sl .= l:linter[0] . ' '
  end

  let errors = ale_res['error']
  if errors > 0
    let sl .= '%#StatusLineALEErrors#'
  else
    let sl .= '%#StatusLineBg2b#'
  end
  let sl .= printf('  %d', errors)

  let warnings = ale_res['warning']
  if warnings > 0
    let sl .= '%#StatusLineALEWarnings#'
  else
    let sl .= '%#StatusLineBg2b#'
  end
  let sl .= printf('   %d ', warnings)

  return sl
endfunction

function! GetFileName()
  let b:max_width = 3 * winwidth(g:statusline_winid) / 5
  let b:file_name = bufname(winbufnr(g:statusline_winid))
  let b:width = strwidth(b:file_name)

  if b:width == 0
    let b:file_name = '[Scratch] '
  else
    " If the file name is too big, we just write its tail part
    if b:width > b:max_width
      let b:file_name = fnamemodify(b:file_name, ':t')
    endif

    if exists('*WebDevIconsGetFileTypeSymbol')
      let b:file_name = printf('%s %s %%m', WebDevIconsGetFileTypeSymbol(b:file_name), b:file_name)
    endif
  endif

  return b:file_name
endfunction

function! MakeActiveStatusLine()
  let b:hls = {
        \ 'n': {
        \ 'n': 'StatusLineNormalMode',
        \ 'i': 'StatusLineNormalMode',
        \ 'nr': 'StatusLineNormalModeWinNr'
        \ },
        \ 'i': {
        \ 'n': 'StatusLineInsertMode',
        \ 'i': 'StatusLineInsertMode',
        \ 'nr': 'StatusLineInsertModeWinNr'
        \ },
        \ "\<C-v>": {
        \ 'n': 'StatusLineVisualMode',
        \ 'i': 'StatusLineVisualMode',
        \ 'nr': 'StatusLineVisualModeWinNr'
        \ },
        \ 'v': {
        \ 'n': 'StatusLineVisualMode',
        \ 'i': 'StatusLineVisualMode',
        \ 'nr': 'StatusLineVisualModeWinNr'
        \ },
        \ 'V': {
        \ 'n': 'StatusLineVisualLineMode',
        \ 'i': 'StatusLineVisualLineMode',
        \ 'nr': 'StatusLineVisualLineModeWinNr'
        \ },
        \ '': {
        \ 'n': 'StatusLineVisualBlockMode',
        \ 'i': 'StatusLineVisualBlockMode',
        \ 'nr': 'StatusLineVisualBlockModeWinNr'
        \ },
        \ 'R': {
        \ 'n': 'StatusLineReplaceMode',
        \ 'i': 'StatusLineReplaceMode',
        \ 'nr': 'StatusLineReplaceModeWinNr'
        \ },
        \ 'c': {
        \ 'n': 'StatusLineCommandMode',
        \ 'i': 'StatusLineCommandMode',
        \ 'nr': 'StatusLineCommandModeWinNr'
        \ },
        \ 'r?': {
        \ 'n': 'StatusLineHitEnterPromptMode',
        \ 'i': 'StatusLineHitEnterPromptMode',
        \ 'nr': 'StatusLineHitEnterPromptModeWinNr'
        \ },
        \ }
  let b:hl = 'StatusLineBg'
  let b:hl2 = 'StatusLineBg2c'

  if has_key(b:hls, mode()) == 1
    if &modified
      let b:hl = b:hls[mode()]['i']
    else
      let b:hl = b:hls[mode()]['n']
    endif

    let b:hl2 = b:hls[mode()]['nr']
  endif

  if get(g:statusline_ignore, &filetype, '') !=# ''
    let b:status_line = printf(
          \ '%%#%s# %s %%#%s# %s',
          \ b:hl2,
          \ s:win_id2alpha(win_id2win(g:statusline_winid)),
          \ b:hl,
          \ g:statusline_ignore[&filetype])
  else
    let b:status_line = printf(
          \ '%%#%s# %s %%#%s# %s ',
          \ b:hl2,
          \ s:win_id2alpha(win_id2win(g:statusline_winid)),
          \ b:hl,
          \ GetFileName())
    let b:status_line .=
          \ '%#StatusLineLinNbr# %v%#StatusLineBg2b#:%#StatusLineColNbr#%l%< %#StatusLineBg2b#(%p%% %LL)'
    let b:status_line .= printf(
          \ '%%=%%#StatusLineBg# %s%s ',
          \ ALEStatus(),
          \ VcsStatus())
  end

  return b:status_line
endfunction

function! MakeInactiveStatusLine()
  let b:hl = 'StatusLineBg2c'
  let b:hlend = 'StatusLineBg'
  let ft = getbufvar(winbufnr(g:statusline_winid), '&filetype')
  if get(g:statusline_ignore, ft, '') !=# ''
    let b:status_line = printf(
          \ ' %s %%#%s# %s %%#%s#',
          \ s:win_id2alpha(win_id2win(g:statusline_winid)),
          \ b:hl,
          \ g:statusline_ignore[ft],
          \ b:hlend)
  else
    let b:status_line = printf(
          \ ' %s %%#%s# %s %%#%s#',
          \ s:win_id2alpha(win_id2win(g:statusline_winid)),
          \ b:hl,
          \ GetFileName(),
          \ b:hlend)
  end
  return b:status_line
endfunction

augroup mystatusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!MakeActiveStatusLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!MakeInactiveStatusLine()
augroup END


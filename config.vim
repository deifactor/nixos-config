set termguicolors
set clipboard=unnamedplus

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

let g:rustfmt_autosave = 1

let g:ale_sign_column_always = 1

let g:airline#extensions#tagbar#enabled = 0
let g:airline_powerline_fonts=1

" necessary so we don't get weird when operating near 100 characters, since
" that's also the width after a split
set nowrap
set sidescrolloff=1
" errors tend to be long and need to be wrapped, though
autocmd FileType qf setlocal wrap

set nohlsearch

set noequalalways
set splitbelow
set splitright
nnoremap <silent> <F8> :TagbarToggle<CR>
au BufNewFile,BufRead /*.rasi setf css

inoremap jk <esc>

let mapleader = "\<Space>"
au FileType vim nnoremap <Leader>r :write<CR>:source %<CR>
" useful for debugging highlighting
nnoremap <Leader><Leader>i :Inspecthi<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>a :Ag<CR>

let g:airline_mode_map = {
  \ 'c': 'CMND',
  \ 'i': 'INSR',
  \ 'ic': 'I-CM',
  \ 'ix': 'I-CM',
  \ 'n': 'NRML',
  \ 'ni': '[IN]',
  \ 'R': 'RPLC',
  \ 'Rv': 'VRPL',
  \ 's': 'SLCT',
  \ 'S': 'S-LN',
  \ 't': 'TERM',
  \ 'v': 'VSUL',
  \ 'V': 'V-LN',
  \}

" startify {{{

let g:startify_fortune_use_unicode = 1
let g:startify_custom_header_quotes = [
      \ ['im gay'],
      \ ['remember, always, that you are beloved.'],
      \ ['if the zoo bans me for hollering at the animals i will face god and walk backwards into hell', '', '- @dril'],
      \ ['Everything happens so much', '', '- @horse_ebooks'],
      \ ['Most of you are familiar with the virtues of a programmer. There are three, of course: laziness, impatience, and hubris.', '', '- Larry Wall'],
      \ ['Escape will make me God.', '', '- Durandal'],
      \ ['Time is the school in which we learn,', 'Time is the fire in which we burn.', '', '- Delmore Schwartz'],
      \ ['It takes long winter nights to teach a girl how to cultivate within herself invincible summer days.', '', '- Ticker'],
      \ ]

" }}}

let s:local_config = expand('~/nix-staging/config.vim')
if filereadable(s:local_config)
  execute 'source' s:local_config
endif

" vim:foldmethod=marker:shiftwidth=2

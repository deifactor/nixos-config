set termguicolors

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

let g:rustfmt_autosave = 1

let g:ale_sign_column_always = 1

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

colorscheme iceberg
" just a little bit darker than normal
highlight! Normal guibg=#14161f
highlight! EndOfBuffer guibg=#14161f

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

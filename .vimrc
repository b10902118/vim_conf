set nocompatible

filetype on
filetype plugin on
filetype indent on

""set selectmode=mouse
set exrc
set whichwrap+=<,>,[,]
set showcmd
set laststatus=0
set smartindent
set shiftwidth=4
set tabstop=4
set number
set cursorline
set mouse=a
set hls is
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set showmatch
set background=dark	" another is 'light'
set wildmenu "show commandline autocomplete options
"not sure usage (lines don't break)
set textwidth=78
" VIM 6.0,
if version >= 600
    "set nohlsearch
    set foldmethod=marker
    set foldlevel=1
    set fileencodings=ucs-bom,utf-8,sjis,big5,latin1
else
    set fileencoding=taiwan
endif

set backupdir=.,/tmp "file with ~ (last version)
set directory=/tmp/vimswap,/tmp "swapfile (unsafed buffer) location
set backup		" keep a backup file
set viminfo='20,<100,h,n~/.vim/cache/.viminfo	" read/write a .viminfo file, don't store more

""prevent strange unicode char
""let &t_TI = ""
""let &t_TE = ""

"test on windows for block cursor
""let &t_ti.="\e[1 q"
""let &t_EI.="\e[1 q"
""let &t_te.="\e[0 q"


""disable continual comment in new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"popup menu (172 yellow nice  74 blue good)
highlight Pmenu ctermbg=239  ctermfg=253 cterm=NONE 
highlight PmenuSel ctermbg=172

"" 
"reference: https://vi.stackexchange.com/questions/24757/how-to-delete-a-pair-of-parenthesis-with-backspace
""inoremap <C-h> <BS>
"""bug: remove \n at the end (fixed!)

""
nnoremap x i<Del><Right><Esc>
""inoremap jk <Esc>la
inoremap <expr> <BS>  <sid>remove_pair()
""imap <C-h> <BS> seems to be automatically done
" add "inoremap <C-h> <BS>" causes failure

function s:remove_pair() abort 
  if col('.')==1
	  return "\<BS>"
  endif
  let pair = getline('.')[ col('.')-2 : col('.')-1 ]
  if (pair=='""') || (pair=="''") || (pair=="()") || (pair=="[]") || (pair=="{}")
	  return "\<Del>\<BS>"
  endif
  return "\<BS>"
endfunction 


function StrOrCmt() abort
	let type=synID(line('.'), col('.')-1, 0)->synIDattr('name')
	return ( (type =~'String') || ( type =~ 'Comment') )
endfunction




"closing
inoremap <expr> { StrOrCmt() ? '{' : '{}<Esc>i'
autocmd FileType python inoremap <buffer> { {}<Esc>i
"inoremap <expr> ( StrOrCmt() ? '(' : '()<Esc>i'
inoremap ( ()<Esc>i
inoremap <expr> " StrOrCmt() ? '"' : '""<Esc>i'
inoremap <expr> ' StrOrCmt() ? "'" : "''<Esc>i"
""inoremap <expr> [ StrOrCmt() ? '[' : '[]<Esc>i'

""inoremap " ""<Esc>i
""inoremap ' ''<Esc>i
inoremap [ []<Esc>i

"1. confirm suggestion in popup menu
"2. {<CR>} to {<CR><CR>}"
inoremap <expr> <CR> Enter() 
function Enter()
	if pumvisible()
		return "\<C-y>"
	endif
	let pair = getline('.')[ col('.')-2 : col('.')-1 ]
	if pair== "{}"
		return "\<CR>\<Esc>O"
	else
		return "\<CR>"
	endif
endfunction

"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
"clear highlight
nnoremap <silent> <C-l> <Esc>:noh<CR>

""coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)
	



""status line
""source $VIMRUNTIME/delmenu.vim
""source $VIMRUNTIME/menu.vim




"conditional mapping:
"https://stackoverflow.com/questions/72314580/how-to-make-map-in-vim-to-work-only-when-i-dont-write-inside-quotes
"

""from workstation
" If no screen, use color term
if ($TERM == "vt100")
  " xterm-color / screen
  set t_Co=8
  set t_AF=[1;3%p1%dm
  set t_AB=[4%p1%dm
endif

if filereadable($VIMRUNTIME . "/vimrc_example.vim")
 so $VIMRUNTIME/vimrc_example.vim
endif

if filereadable($VIMRUNTIME . "/macros/matchit.vim")
 so $VIMRUNTIME/macros/matchit.vim
endif



" Tab key binding
if version >= 700
  map  <C-c> :tabnew<CR>
  imap <C-c> <ESC>:tabnew<CR>
  map  <C-k> :tabclose<CR>
  map  <C-p> :tabprev<CR>
  imap <C-p> <ESC>:tabprev<CR>
  map  <C-n> :tabnext<CR>
  "imap <C-n> <ESC>:tabnext<CR>
  map <F4> :set invcursorline<CR>

  map g1 :tabn 1<CR>
  map g2 :tabn 2<CR>
  map g3 :tabn 3<CR>
  map g4 :tabn 4<CR>
  map g5 :tabn 5<CR>
  map g6 :tabn 6<CR>
  map g7 :tabn 7<CR>
  map g8 :tabn 8<CR>
  map g9 :tabn 9<CR>
  map g0 :tabn 10<CR>
  map gc :tabnew<CR>
  map gn :tabn<CR>
  map gp :tabp<CR>

  highlight TabLineSel term=bold,underline cterm=bold,underline ctermfg=7 ctermbg=0
  highlight TabLine    term=bold cterm=bold
  highlight clear TabLineFill
end

" Crontabs must be edited in place
au BufRead /tmp/crontab* :set backupcopy=yes

call plug#begin()

Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'skywind3000/asyncrun.vim'
"Plug 'jiangmiao/auto-pairs'

"status line
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
call plug#end()


''
"funcion for checking syntax and chars
""
""set statusline+=%{SyntaxItem()}
function GetSyntax()
	echo synID(line('.'), col('.'), 0)->synIDattr('name')
endfunction

function GetCur()
	let pair=getline('.')[col('.')-2:col('.')-1]
	echo col('.')
	echo pair[0] pair[1]
endfunction
""function SynStack()
""  if !exists("*synstack")
""    return
""  endif
""  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
""endfunc

""function Syn()
""  for id in synstack(line("."), col("."))
""    echo synIDattr(id, "name")
""  endfor
""endfunction

""function SyntaxItem()
""  return synIDattr(synID(line("."),col("."),1),"name")
""endfunction


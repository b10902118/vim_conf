""cpp start
if &ft=="cpp" 
	colorscheme cpp_color
	""build and run shortcut (no optimization)
	nnoremap <silent> <F7> :call <SID>Run()<CR>
	nnoremap <F8> :call <SID>Compile()<CR>
	nnoremap <F9> :call <SID>CompileRun()<CR>
	nnoremap <silent><F2> :call asyncrun#quickfix_toggle(7)<CR>
	inoremap <silent> <F7> <Esc>:call <SID>Run()<CR>
	inoremap <F8> <Esc>:call <SID>Compile()<CR>
	inoremap <F9> <Esc>:call <SID>CompileRun()<CR>
	inoremap <silent><F2> <Esc>:call asyncrun#quickfix_toggle(7)<CR>li

""create project dir when in /home/bill/c++
""let tmp= system('echo -n `pwd`')
""if tmp == "/home/bill/c++"
""	echoerr "changing"
""	call mkdir(expand('%:r'))
""	cd %:r
""endif

""default code for new cpp cc file (not including header with h in extension like h hpp)

if !filereadable(expand('%')) && &ft == "cpp"  
	if expand('%:e')!~'h' && !filereadable(expand('%:r') . '.h') && !filereadable(expand('%:r') . '.hpp')
		normal! i#include <iostream>using namespace std;int main(){return 0;}
		normal! 6ggi	
	endif
endif

"used in ~/.vim/plugged/asyncrun.vim/plugin/asyncrun.vim#quickfix_toggle
function Highlight() abort
	""highlight QfError cterm=bold ctermfg=196 ctermbg=NONE
	""syntax match QfError "error.*"
	""highlight QfWarning cterm=bold ctermfg=135 ctermbg=NONE
	""syntax match Warning "warning.*"
endfunction

" When using `dd` in the quickfix list, remove the item from the quickfix list.
"https://stackoverflow.com/questions/42905008/quickfix-list-how-to-add-and-remove-entries
""function! RemoveQFItem(line_n) abort
""  let curqfidx = a:line_n - 1
""  let qfall = getqflist()
""  call remove(qfall, curqfidx)
""  call setqflist(qfall, 'r')
""""seems to cause error
""  ""execute curqfidx + 1 . "cfirst"
""  ""copen
""endfunction
""command! RemoveQFItem :call RemoveQFItem()
" Use map <buffer> to only map dd in the quickfix window. Requires +localmap
""autocmd FileType qf map <silent> <buffer> dd :RemoveQFItem<cr>


""function s:StripCmd() abort
""	normal 1gg
""	normal dd
""endfunction
function s:Run() abort
	""ccl
	wincmd t
	if filereadable(expand("%:p:r"))
		""old --geometry=65x18+1000+0
		AsyncRun -cwd=$(VIM_FILEDIR) gnome-terminal --title=$(VIM_FILENOEXT) --geometry=50x16+1000+0 -- bash -c '$(VIM_FILEDIR)/$(VIM_FILENOEXT);echo "";read -n1 -rsp "press any key to continue ..."' & 
	else
		echohl ErrorMsg | echon "RunError: " expand("%:p:r") "\: No such file or directory" | echohl None
	endif
endfunction

function s:Compile() abort
	"back to top window (assume to be code)
	wincmd t
	w
	AsyncRun g++ -g -Wall "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" 
	copen 7
	""call Highlight()
	""call <SID>StripCmd()
	""call RemoveQFItem(1)
endfunction
function s:CompileRun() abort
	wincmd t
	w
	AsyncRun g++ -g -Wall "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" &&gnome-terminal --title=$(VIM_FILENOEXT) --geometry=50x16+1000+0 -- bash -c 'cd '\''$(VIM_FILEDIR)'\'';$(VIM_FILEDIR)/$(VIM_FILENOEXT);echo "";read -n1 -rsp "press any key to continue ..."' & 
	copen 7
	""call <SID>StripCmd()
	""call RemoveQFItem(1)
	""call Highlight()
	wincmd t
"stripped $(VIM_FILEDIR)/

"qterminal cannot open (sometimes can resize!?)
"qterminal cannot echo and read -p not working
""AsyncRun g++ -g -Wall "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" &&qterminal -w $(VIM_FILEDIR) --title $(VIM_FILEDIR)/$(VIM_FILENOEXT) --geometry 900x500+1000+0 -e bash -c '$(VIM_FILEDIR)/$(VIM_FILENOEXT)&&read -n1 -rsp "\npress any key to continue ...";sleep 5;'


	""while fail to finish the command 
	""copen 7	
	"== 0  and =='0' not working no requirement for space
""	if compile_error_code == 0
""		wincmd t 
""		AsyncRun -mode=term -pos=external  $(VIM_FILEDIR)/$(VIM_FILENOEXT)
""	endif
endfunction

endif ""cpp end

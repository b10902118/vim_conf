
""c start
if &ft=="c"
	colorscheme cpp_color
	nnoremap <silent> <F7> :call <SID>Run()<CR>
	nnoremap <F8> :call <SID>Compile()<CR>
	nnoremap <F9> :call <SID>CompileRun()<CR>
	nnoremap <silent> <F2> :call asyncrun#quickfix_toggle(7)<CR>
	inoremap <silent> <F7> <Esc>:call <SID>Run()<CR>
	inoremap <F8> <Esc>:call <SID>Compile()<CR>
	inoremap <F9> <Esc>:call <SID>CompileRun()<CR>

""default code for new cpp cc file (not including header with h in extension like h hpp)

if !filereadable(expand('%')) && &ft == "c"  
	if expand('%:e')!~'h' && !filereadable(expand('%:r') . '.h') && !filereadable(expand('%:r') . '.hpp')
		normal! i#include <stdio.h>#include <unistd.h>int main(int argc, char **argv){return 0;}
		normal! 5ggi	
	endif
endif

function s:Run() abort
	""ccl
	wincmd t
	if filereadable(expand("%:p:r"))
		if exists("g:run_arg")
			exec "AsyncRun -cwd=$(VIM_FILEDIR) gnome-terminal --title=$(VIM_FILENOEXT) --geometry=50x16+1000+0 -- bash -c 'cd $(VIM_FILEDIR);$(VIM_FILEDIR)/$(VIM_FILENOEXT) ". expand(g:run_arg). "; echo \"\";read -n1 -rsp \"press any key to continue ...\"' &" 
		else
			""old --geometry=65x18+1000+0
			AsyncRun -cwd=$(VIM_FILEDIR) gnome-terminal --title=$(VIM_FILENOEXT) --geometry=50x16+1000+0 -- bash -c '$(VIM_FILEDIR)/$(VIM_FILENOEXT);echo "";read -n1 -rsp "press any key to continue ..."' & 
		endif
	else
		echohl ErrorMsg | echon "RunError: " expand("%:p:r") "\: No such file or directory" | echohl None
	endif
endfunction

function s:Compile() abort
	"back to top window (assume to be code)
	wincmd t
	w
	if filereadable(expand("%:p:h")."/Makefile")
		AsyncRun make
	else
		AsyncRun gcc -Wall "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" 
	endif
	copen 7 
endfunction
function s:CompileRun() abort
	copen 7
	wincmd t
	w
	if exists("g:run_arg")
		exec "AsyncRun ". "gcc -Wall $(VIM_FILEPATH) -o $(VIM_FILEDIR)/$(VIM_FILENOEXT) &&gnome-terminal --title=$(VIM_FILENOEXT) --geometry=50x16+1000+0 -- bash -c 'cd $(VIM_FILEDIR);$(VIM_FILEDIR)/$(VIM_FILENOEXT) ". expand(g:run_arg). "; echo \"\";read -n1 -rsp \"press any key to continue ...\"' &" 
	else
		AsyncRun gcc -Wall "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" &&gnome-terminal --title=$(VIM_FILENOEXT) --geometry=50x16+1000+0 -- bash -c 'cd '\''$(VIM_FILEDIR)'\'';$(VIM_FILEDIR)/$(VIM_FILENOEXT);echo "";read -n1 -rsp "press any key to continue ..."' & 
	endif

"stripped $(VIM_FILEDIR)/

"qterminal cannot open (sometimes can resize!?)
"qterminal cannot echo and read -p not working
""AsyncRun g++ -Wall "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" &&qterminal -w $(VIM_FILEDIR) --title $(VIM_FILEDIR)/$(VIM_FILENOEXT) --geometry 900x500+1000+0 -e bash -c '$(VIM_FILEDIR)/$(VIM_FILENOEXT)&&read -n1 -rsp "\npress any key to continue ...";sleep 5;'


	""while fail to finish the command 
	""copen 7	
	"== 0  and =='0' not working no requirement for space
""	if compile_error_code == 0
""		wincmd t 
""		AsyncRun -mode=term -pos=external  $(VIM_FILEDIR)/$(VIM_FILENOEXT)
""	endif
endfunction

endif ""c end

"PEP8 tab to spaces seems to be fulfilled by coc or other scripts

""build and run shortcut (no optimization)
nnoremap <silent> <F7> :call Run()<CR>

function Run() abort
	w
	AsyncRun -cwd=$(VIM_FILEDIR) -mode=term -pos=gnome  python "$(VIM_FILEPATH)"
endfunction





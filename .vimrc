" Use vim with all enhancements.
"unlet! skip_defaults_vim " Not necessary, vimrc_example will source
"defaults.vim
source $VIMRUNTIME/vimrc_example.vim

" Use minpac to manage plugins.
function! PackInit() abort
	packadd minpac
	"if !exists('g:loaded_minpac')
	"	echohl WarningMsg
	"	echo "Warning: minpac is not available."
	"	echohl None
	"else
	call minpac#init()
	call minpac#add('k-takata/minpac', {'type': 'opt'})

	" Add plugins here.
	call minpac#add('tpope/vim-unimpaired')
	"call minpac#add('altercation/vim-colors-solarized')
	call minpac#add('vim-airline/vim-airline')
	call minpac#add('vim-airline/vim-airline-themes')
	call minpac#add('ryanoasis/vim-devicons')
	call minpac#add('scrooloose/nerdtree')
	call minpac#add('jistr/vim-nerdtree-tabs')
endfunction

" Use the following user commands to load minpac on demand.
command! PackUpdate call PackInit() | call minpac#update()
command! PackClean call PackInit() | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

" Plugin settings here.
" vim-airline/vim-airline settings
let g:airline_powerline_fonts=1 " Need to install a patched font. You can choose one from the nerd fonts project.
let g:airline_detect_paset=1
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='violet'
" <C-r>="\Uf04f3" to insert symbols
" use nerd fonts cheat sheet to find the hex code
" "\U" to escape 32-bit unicode, "\u" to escape 16-bit
" Below is the default value of g:airline_section_z
"let g:airline_section_z='%p%%%#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__#%#__accent_bold#%{g:airline_symbols.colnr}%v%#__restore__#'
let g:airline_section_z='%p%%%#__accent_bold#%{g:airline_symbols.linenr}%l%#__restore__#%#__accent_bold#/%L %#__restore__#%#__accent_bold#:%v%#__restore__#'

" jistr/vim-nerdtree-tabs
nnoremap<silent> <leader>t :NERDTreeTabsToggle<CR>
"let g:nerdtree_tabs_open_on_console_startup=1

" General settings.

if has('persistent_undo')
	" The directory name ending in two path separators will cause the
	" filename to be built from the complete path to the file.
	let &undodir = expand("$HOME") . '/tmp/vimundo//'
	" The directory must exist, vim will not create it for you.
	if !isdirectory(&undodir)
		call mkdir(&undodir, "p")
	endif

	set undofile " already set in vimrc_example.vim

	" Disable persistent undo for temporary files.
	" augroup persistentundo
	" 	autocmd!
	" 	autocmd BufWritePre /tmp/* setlocal noundofile
	" augroup END
endif

set backup
let &backupdir = expand("~/tmp/vimbackup//")
if !isdirectory(&backupdir)
	call mkdir(&backupdir, "p")
endif

let &directory = expand("~/tmp/vimswap//")
if !isdirectory(&directory)
	call mkdir(&directory, "p")
endif

augroup nofortemp
	autocmd!
	autocmd BufWritePre /tmp/*,~/tmp/* setlocal noundofile nobackup
augroup END

set number
set hlsearch " Already set in vimrc_example.vim.
set incsearch " Already set in defaults.vim.

nnoremap<silent> <C-l> :<C-u>nohlsearch<CR><C-l>

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Make * and # work on visual mode too.
function! s:VSetSearch(cmdtype)
	let tmp = @s
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
	let @s = tmp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap * :<C-u>call <SID>VSetSearch('?')<CR>/<C-R>=@/<CR><CR>

nnoremap & :&&<CR>
xnoremap & :&&<CR>

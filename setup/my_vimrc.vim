" Desktop Integration:
" Plugins" -----------------------------------{{{1
function! MinpacInit()" -----------------{{{2
	packadd minpac
	call minpac#init( #{dir:$VIM, package_name: 'plugins' } )

	call minpac#add('dense-analysis/ale')
	call minpac#add('junegunn/fzf.vim')
	call minpac#add('jremmen/vim-ripgrep')
	call minpac#add('itchyny/lightline.vim')
	call minpac#add('itchyny/vim-gitbranch')
	call minpac#add('OmniSharp/omnisharp-vim')
	call minpac#add('gyim/vim-boxdraw')

	call minpac#add('SirVer/ultisnips')
	call minpac#add('honza/vim-snippets')
	call minpac#add('vifm/vifm.vim')
	call minpac#add('tpope/vim-dadbod')
	call minpac#add('tpope/vim-surround')
	call minpac#add('tpope/vim-repeat')
	call minpac#add('junegunn/vim-easy-align')
	call minpac#add('tpope/vim-fugitive')
	call minpac#add('tpope/vim-obsession')
	call minpac#add('ap/vim-css-color')

	call minpac#add('wellle/targets.vim')
	call minpac#add('michaeljsmith/vim-indent-object')

	call minpac#add('Melandel/vim-empower')
	call minpac#add('Melandel/fzfcore.vim')
	call minpac#add('Melandel/gvimtweak')
	call minpac#add('Melandel/vim-amake')

	call minpac#add('ajatkj/vim-qotd')
	call minpac#add('ajatkj/vim-helper')
endfunction
" ---------------------------------------}}}2
command! -bar MinPacInit call MinpacInit()
command! -bar MinPacUpdate call MinpacInit()| call minpac#clean()| call minpac#update()

packadd! matchit
" --------------------------------------------}}}1
" First time" --------------------------------{{{1
if !isdirectory($VIM.'/pack/plugins')
	call system('git clone https://github.com/k-takata/minpac.git ' . $VIM . '/pack/packmanager/opt/minpac')
	call MinpacInit()
	call minpac#update()
	packloadall
endif
" --------------------------------------------}}}1
" Duplicated/Generated files" ----------------{{{1
augroup duplicatefiles
	au!
	au BufWritePost my_keyboard.ahk exec '!Ahk2Exe.exe /in %:p /out ' . fnameescape($HOME . '/Desktop/tools/myAzertyKeyboard.RunMeAsAdmin.exe')
augroup end
" --------------------------------------------}}}1

" General:
" Utils" -------------------------------------{{{1
let $v = $VIM . '/_vimrc'
let $d = $HOME . '/Desktop'
let $p = $VIM . '/pack/plugins/start/'
let $c = $VIM . '/pack/plugins/start/vim-empower/colors/empower.vim'
let $n = $d.'/my.notes'
let $r = $d.'/my.resources'
let $hz = $d.'/my.happyzone'
let $dz = $d.'/my.drivenzone'
let $k = $d.'/my.knowledge'
" --------------------------------------------}}}1
" Settings" ----------------------------------{{{1
syntax on
filetype plugin indent on
language messages English_United states
set novisualbell
set langmenu=en_US.UTF-8
set encoding=utf8
set scrolloff=0
set relativenumber
set number
set cursorline
set backspace=indent,start,eol
set listchars=tab:▸\ ,eol:¬,extends:>,precedes:<
set list
set noswapfile
set directory=$HOME/Desktop/tmp/vim
set backup
set backupdir=$HOME/Desktop/tmp/vim
set undofile
set undodir=$HOME/Desktop/tmp/vim
set shellslash " path autocompletion works either with \, either with /. ripgrep path arguments needs either \\, either /. Let's use /.

" GVim specific
if has("gui_running")
	set guioptions-=m  "menu bar
	set guioptions-=T  "toolbar
	set guioptions-=t  "toolbar
	set guioptions-=r  "scrollbar
	set guioptions-=L  "scrollbar
	set guioptions+=c  "console-style dialogs instead of popups
	set guifont=consolas:h11
	set termwintype=conpty

endif
" --------------------------------------------}}}1
" Tabs and Indentation" ------------------{{{
set smartindent
set tabstop=1
set shiftwidth=1

nnoremap > >>
nnoremap < <<

command! -bar Spaces2Tabs set noet ts=2 |%retab!
" ---------------------------------------}}}
" Leader keys" ---------------------------{{{
let mapleader = 's'
let maplocalleader = 'q'
" ---------------------------------------}}}
" Local Current Directories" -------------{{{
function! LcdToPluginDirectory(...)" -----------{{{2
	if getwinvar(1, '&filetype') == 'fugitive' | return | endif
	" asking for diff in fugitive-status displays an error

	let filepath = expand('%:p')
	if filepath !~ '\v%(start|opt)' | return | endif

	let path = fnamemodify(filepath, ':h')
	let previous_path = path
	while path !~ '\v%(start|opt)$'
		let previous_path = path
		let path = fnamemodify(path, ':h')
	endwhile

	execute(printf('lcd %s', previous_path))
endfunc
" --------------------------------------------}}}2
function! LcdToSlnOrCsproj(...)" -----------{{{2
	let omnisharp_host = getbufvar(bufnr('%'), 'OmniSharp_host')
	if empty(omnisharp_host)
		return
	endif
	let srcRoot = fnamemodify(omnisharp_host.sln_or_dir, ':h')
	execute(printf('lcd %s', srcRoot))
endfunc
" --------------------------------------------}}}2

augroup lcd
	au!
	autocmd BufRead,WinEnter *.vim silent call LcdToPluginDirectory()
	autocmd BufRead,WinEnter my.* silent lcd $d
	autocmd BufRead,WinEnter *.cs silent call LcdToSlnOrCsproj()
augroup end
" ---------------------------------------}}}


" AZERTY Keyboard:
" AltGr keys" --------------------------------{{{1
inoremap ^q {|		cnoremap ^q {
inoremap ^s [|		cnoremap ^d [
inoremap ^d ]|		cnoremap ^f ]
inoremap ^f }|		cnoremap ^s }
inoremap ^w ~|		cnoremap ^w ~
inoremap ^x #|		cnoremap ^x #
inoremap ^c <Bar>|	cnoremap ^c <Bar>
inoremap ^b \
					cnoremap ^b \
inoremap ^n @|		cnoremap ^n @
inoremap ^g `|		cnoremap ^g `
inoremap ^h +|		cnoremap ^h +
" --------------------------------------------}}}1
" Arrows" ------------------------------------{{{1
inoremap <C-J> <Left>|  cnoremap <C-J> <Left>|  tnoremap <C-J> <Left>
inoremap <C-K> <Right>| cnoremap <C-K> <Right>| tnoremap <C-K> <Right>
" --------------------------------------------}}}1
" Home,End" ----------------------------------{{{1
inoremap ^j <Home>| cnoremap ^j <Home>| tnoremap ^j <Home>
inoremap ^k <End>|  cnoremap ^k <End>|  tnoremap ^k <End>
" --------------------------------------------}}}1
" Backspace,Delete" --------------------------{{{1
tnoremap <C-L> <Del>
inoremap <C-L> <Del>|   cnoremap <C-L> <Del>
" --------------------------------------------}}}1

" Graphical Layout:
" Colorscheme, Highlight groups" -------------{{{1
colorscheme empower
nnoremap <LocalLeader>h :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
nnoremap <LocalLeader>H :OmniSharpHighlightEchoKind<CR>
" --------------------------------------------}}}1
" Buffers, Windows & Tabs" -------------------{{{1
set hidden
set splitbelow
set splitright
set previewheight=25
set showtabline=0

" List/Open Buffers
nnoremap <Leader>b :History<CR>
nnoremap <Leader>B :Buffers<CR>

" Close Buffers
function! DeleteHiddenBuffers()" -------------{{{2
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
	if getbufvar(buf, '&mod') == 0
	  silent execute 'bwipeout' buf
	  let closed += 1
	endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction
" --------------------------------------------}}}2
nnoremap <Leader>c :silent! call DeleteHiddenBuffers()<CR>:ls<CR>

" Open/Close Window or Tab
nnoremap <Leader>s :split<CR>
nnoremap <Leader>v :vsplit<CR>
nnoremap K :q<CR>
nnoremap <Leader>o mW:tabnew<CR>`W:silent call ToggleMyMetaBanner()<CR>
nnoremap <silent> <Leader>x :tabclose<CR>
nnoremap <Leader>X :tabonly<CR>:sp<CR>:q<CR>:let g:zindex+=1<CR>:call DisplayPopupTime()<CR>

" Browse to Window or Tab
nnoremap <Leader>h <C-W>h
nnoremap <Leader>j <C-W>j
nnoremap <Leader>k <C-W>k
nnoremap <Leader>l <C-W>l
nnoremap <Leader>n gt
nnoremap <Leader>p gT

augroup windows
	autocmd!
	"
	" foldcolumn serves here to give a visual clue for the current window
	autocmd WinLeave * setlocal norelativenumber foldcolumn=0
	autocmd WinEnter * setlocal relativenumber foldcolumn=1
	" Safety net if I close a window accidentally
	autocmd QuitPre * mark K
	" Make sure Vim returns to the same line when you reopen a file.
 autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif
augroup end



" Position Window
nnoremap <Leader>H <C-W>H
nnoremap <Leader>J <C-W>J
nnoremap <Leader>K <C-W>K
nnoremap <Leader>L <C-W>L

" Resize Window
nnoremap <silent> <A-h> :vert res -2<CR>
nnoremap <silent> <A-l> :vert res +2<CR>
nnoremap <silent> <A-j> :res -2<CR>
nnoremap <silent> <A-k> :res +2<CR>
nnoremap <silent> <A-m> <C-W>=

" Alternate file fast switching
nnoremap <Leader>d :b #<CR>

function! SwapWindowContents(hjkl_keys)"------{{{2
	mark V
	let originalWinNr = winnr()

	for hjkl_key in split(a:hjkl_keys, '\zs') | silent! execute('wincmd ' . hjkl_key) | endfor
	mark W
	normal! `V

	execute(originalWinNr.'wincmd w')
 normal! `W
	delmarks VW
endfunction
"---------------------------------------------}}}2
command! -nargs=1 -bar SwapWindows call SwapWindowContents(<f-args>)
nnoremap SJ :SwapWindows j<CR> | nnoremap SJJ :SwapWindows jj<CR> | nnoremap SJK :SwapWindows jk<CR> | nnoremap SJH :SwapWindows jh<CR> | nnoremap SJL :SwapWindows jl<CR> 
nnoremap SK :SwapWindows k<CR> | nnoremap SKJ :SwapWindows kj<CR> | nnoremap SKK :SwapWindows kk<CR> | nnoremap SKH :SwapWindows kh<CR> | nnoremap SKL :SwapWindows kl<CR>
nnoremap SH :SwapWindows h<CR> | nnoremap SHJ :SwapWindows hj<CR> | nnoremap SHK :SwapWindows hk<CR> | nnoremap SHH :SwapWindows hh<CR> | nnoremap SHL :SwapWindows hl<CR>
nnoremap SL :SwapWindows l<CR> | nnoremap SLJ :SwapWindows lj<CR> | nnoremap SLK :SwapWindows lk<CR> | nnoremap SLH :SwapWindows lh<CR> | nnoremap SLL :SwapWindows ll<CR>
" --------------------------------------------}}}1
" Status bar" --------------------------------{{{1
set laststatus=2
function! FoldLevel()"------------------------{{{2
	return printf('FoldLevel:%d', &foldlevel)
endfunction
"---------------------------------------------}}}2
function! FileSizeAndRows() abort" -----------{{{2
	let rows = line('$')

	let l:bytes = getfsize(expand('%p'))
	if (l:bytes >= 1024)
		let l:kbytes = l:bytes / 1025
	endif
	if (exists('kbytes') && l:kbytes >= 1000)
		let l:mbytes = l:kbytes / 1000
	endif

	if l:bytes <= 0
		let size = '0'
	endif

	if (exists('mbytes'))
		let size = l:mbytes . 'MB'
	elseif (exists('kbytes'))
		let size = l:kbytes . 'KB'
	else
		let size = l:bytes . 'B'
	endif

	let percent = 100*line('.')/rows

	return printf('%drows[%s]:%d%%', rows, size, percent)
endfunction
" --------------------------------------------}}}2
function! MyFilePathIndicator() abort" -------{{{2
	let path = GitRootAndCwd()

	let current_directory = getcwd()
	if stridx(path, fnamemodify(current_directory, ':t')) == -1
		let path .= printf(' %s/%s', fnamemodify(current_directory, ':h:t'), fnamemodify(current_directory, ':t'))
	endif
	
	let path .= ' '.GitFilePath()

	return substitute(path, fnamemodify(current_directory, ':t') , '(&)', '')
endfunction
" --------------------------------------------}}}2
function! GitFilePath()" ---------------------{{{2
	let file_path_absolute = expand('%:p')
	let git_path_absolute = fnamemodify(gitbranch#dir(file_path_absolute), ':h')
	
	return git_path_absolute == '.' ? expand('%') : file_path_absolute[len(git_path_absolute)+1:]
endfunction
" --------------------------------------------}}}2
function! GitRootAndCwd()" -------------------{{{2
	let file_path_absolute = expand('%:p')
	let git_path_absolute = fnamemodify(gitbranch#dir(file_path_absolute), ':h')

	return git_path_absolute == '.' ? '' :	printf('%s[%s/%s]', gitbranch#name(), fnamemodify(git_path_absolute, ':h:t'), fnamemodify(git_path_absolute, ':t')) 
endfunction
" --------------------------------------------}}}2

let g:lightline = {
	\ 'colorscheme': 'empower',
	\ 'component_function': { 'filesize_and_rows': 'FileSizeAndRows', 'mypathinfo': 'MyFilePathIndicator', 'gitpath': 'GitFilePath', 'gitroot': 'GitRootAndCwd', 'fl': 'FoldLevel' },
	\ 'active':   {   'left':  [ [ 'mode', 'fl', 'paste', 'readonly', 'modified' ], [ 'mypathinfo' ] ], 'right': [ [ 'filesize_and_rows' ]               ] },
	\ 'inactive': {   'left':  [ [ 'gitroot' ]                                                       ], 'right': [ [ 'gitpath', 'modified', 'readonly' ] ] }
\}
" --------------------------------------------}}}1

" Motions:
" hjkl"-----------------------------------{{{
nnoremap j gj
nnoremap k gk
""----------------------------------------}}}
" Browsing File Architecture" ----------------{{{1
"
function! BrowseLayoutDown()" ----------------{{{2
	if &diff
		keepjumps execute 'silent! normal! ]czx'
	elseif len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')) > 0
		keepjumps silent! cnext
	else
		keepjumps execute 'silent! normal! }}{j'
	endif

	norma! m'
endfunction
" --------------------------------------------}}}2
nnoremap <silent> <C-J> :call BrowseLayoutDown()<CR>

function! BrowseLayoutUp()" ------------------{{{2
	if &diff
		keepjumps execute 'silent! normal! [czx'
	elseif len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')) > 0
		keepjumps silent! cprev
	else
		let original_pos = line('.')
		normal! {j
		if line('.') == original_pos
			keepjumps normal! {{j
		endif
	endif

	normal! m'
endfunction
" --------------------------------------------}}}2
nnoremap <silent> <C-K> :call BrowseLayoutUp()<CR>

" --------------------------------------------}}}1
" Current Line" ------------------------------{{{1

function! ExtendedHome()" --------------------{{{2
    let column = col('.')
    normal! ^
    if column == col('.')
        normal! 0
    endif
endfunction
" --------------------------------------------}}}2
nnoremap <silent> <Home> :call ExtendedHome()<CR>
vnoremap <silent> <Home> <Esc>:call ExtendedHome()<CR>mvgv`v
onoremap <silent> <Home> :call ExtendedHome()<CR>

function! ExtendedEnd()" ---------------------{{{2
    let column = col('.')
    normal! g_
    if column == col('.') || column == col('.')+1
        normal! $
    endif
endfunction
" --------------------------------------------}}}2
nnoremap <silent> <End> :call ExtendedEnd()<CR>
vnoremap <silent> <End> <Esc>:call ExtendedEnd()<CR>mvgv`v
onoremap <silent> <End> :call ExtendedEnd()<CR>

function! MoveCursorToNext(pattern)" ---------{{{2
	mark '
	let match =	 searchpos(a:pattern, '', line('.'))
endfunction
" --------------------------------------------}}}2
function! MoveCursorToLast(pattern)" ---------{{{2
	mark '
	let match = searchpos(a:pattern, 'b', line('.'))
endfunction
" --------------------------------------------}}}2
nnoremap <silent> / :call MoveCursorToNext('[^A-Za-z_ \t]\C')<CR>
nnoremap <silent> . :call MoveCursorToLast('[^A-Za-z_ \t]\C')<CR>
" --------------------------------------------}}}1
" Text objects" ------------------------------{{{1

" Always add cursor position to jumplist
let g:targets_jumpRanges = 'cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb al rB Al bb aa bB Aa BB AA'

" Lines
vnoremap il ^og_| onoremap il :normal vil<CR>
vnoremap al 0o$h|  onoremap al :normal val<CR>

" Folds
vnoremap iz [zjo]zkVg_| onoremap iz :normal viz<CR>
vnoremap az [zo]zVg_|   onoremap az :normal vaz<CR>

" Entire file
vnoremap if ggoGV| onoremap if :normal vif<CR>

" --------------------------------------------}}}1

" Text Operations:
" Visualization" -----------------------------{{{1

" select until end of line
nnoremap vv vg_

" Last inserted text
nnoremap vI `[v`]h

" --------------------------------------------}}}1
" Copy & Paste" ------------------------------{{{1

" Yank current line, trimmed
nnoremap Y y$

" Yank into system clipboard
nnoremap zy "+y
nnoremap zY "+Y
nnoremap <C-C> "+y
vnoremap <C-C> "+y

" Paste from system clipboard
nnoremap zp :set paste<CR>o<Esc>"+p:set nopaste<CR>
nnoremap zP :set paste<CR>O<Esc>"+P:set nopaste<CR>
inoremap <C-V> <C-R>+| inoremap <C-C> <C-V>
cnoremap <C-V> <C-R>=escape(@+,'\%#')<CR>| cnoremap <C-C> <C-V>
tnoremap <C-V> <C-W>"+

" Cursor position after yanking in Visual mode
vnoremap gy y`]

" Allow pasting several times when replacing visual selection
vnoremap p "0p
vnoremap P "0P

" Select the text that was pasted
nnoremap <expr> vp '`[' . strpart(getregtype(), 0, 1) . '`]'

" --------------------------------------------}}}1
" Repeat-Last-Action" -------------{{{1
nnoremap ù .
" --------------------------------------------}}}1
" Vertical Alignment" ------------------------{{{1
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" --------------------------------------------}}}1

" Vim Functionalities:
" Wild Menu" ---------------------------------{{{1

set wildmenu
set wildcharm=<Tab>
set wildignorecase
set wildmode=full

function! EnterSubdir()"----------------------{{{2
    call feedkeys("\<Down>", 't')
    return ''
endfunction
"---------------------------------------------}}}2
cnoremap <expr> j (wildmenumode() == 1) ? EnterSubdir() : "j"

function! MoveUpIntoParentdir()"--------------{{{2
    call feedkeys("\<Up>", 't')
    return ''
endfunction
"---------------------------------------------}}}2
cnoremap <expr> k (wildmenumode() == 1) ? MoveUpIntoParentdir() : "k"

cnoremap <expr> h (wildmenumode() == 1) ? "\<s-Tab>" : "h"
cnoremap <expr> l (wildmenumode() == 1) ? "\<Tab>"   : "l"

"cnoremap <expr> <Esc> (wildmenumode() == 1) ? " \<BS>"   : "\<Esc>"
"---------------------------------------------}}}1
" Expanded characters" -----------------------{{{1

" Folder of current file
cnoremap µ <C-R>=expand('%:p:h')<CR>\

"---------------------------------------------}}}1
" Sourcing" ----------------------------------{{{1

" Run a line/selected text composed of vim script
vnoremap <silent> <Leader>S y:execute @@<CR>
nnoremap <silent> <Leader>S ^vg_y:execute @@<CR>

" Write output of a vim command in a buffer
nnoremap ç :let script=''\|call histadd('cmd',script)\|put=execute(script)<Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>

augroup vimsourcing
	au!
	autocmd BufWritePost _vimrc GvimTweakToggleFullScreen | so % | GvimTweakToggleFullScreen
augroup end

"---------------------------------------------}}}1
" Find, Grep, Make, Equal" -------------------{{{1
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ $*

nnoremap <Leader>f :Files<CR>
nnoremap <Leader>F :Files <C-R>=fnamemodify('.', ':p')<CR>
nnoremap <Leader>g :Agrep --no-ignore-parent  <C-R>=fnamemodify('.', ':p')<CR><Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>
vnoremap <Leader>g "vy:let cmd = printf('Agrep --no-ignore-parent %s %s',escape(@v,'\\#%'),fnamemodify('.', ':p'))\|echo cmd\|call histadd('cmd',cmd)\|execute cmd<CR>
"---------------------------------------------}}}1
" Registers" ---------------------------------{{{1
command! ClearRegisters for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor
"---------------------------------------------}}}1
" Terminal" ----------------------------------{{{1
set termwinsize=12*0
tnoremap <C-s>h <C-W>h
tnoremap <C-s>j <C-W>j
tnoremap <C-s>k <C-W>k
tnoremap <C-s>l <C-W>l
"---------------------------------------------}}}1
" Folding" -----------------------------------{{{1
	function! MyFoldExpr()" -----------------{{{2
		let res = ''
		let line=getline(v:lnum)
		let pos_brackets = match(line, '\v%(\{\{\{|\}\}\})\d?$')
		if pos_brackets == -1
			let res= '='
		else
			let is_beginning = line[pos_brackets] == '{'
			let line_length = len(line)

			if line_length == (pos_brackets + 3)
				let res= printf('%s1', (is_beginning ? 'a' : 's'))
			else
				let following_char = line[pos_brackets+3]

				if following_char =~ '\s'
					let res= printf('%s1', (is_beginning ? 'a' : 's'))
				else
					let res= printf('%s%s', ( is_beginning ? '>' : '<'), following_char)
				endif
			endif
		endif

		return res
	endfunction
	" ---------------------------------------}}}2
	function! MyFoldText()" ----------------------{{{2
		let line = getline(v:foldstart)
		let end_of_title = stridx(line, (&commentstring == '' ? '-' : split(&commentstring, '%s')[0]), match(line, '\a'))-1
		let nucolwidth = &fdc + &number * &numberwidth
		let windowwidth = winwidth(0) - nucolwidth - 3
		let foldedlinecount = v:foldend - v:foldstart - 1

		return printf('%s%s%d', line[:end_of_title], repeat(' ', windowwidth - (end_of_title+1) - len(string(foldedlinecount))), foldedlinecount)
	endfunction
	" --------------------------------------------}}}2
	function! MyFoldCreate() range" ---------{{{2
		let last_column_reached = 50 - 1 - 1 - 3
		let comment_string = &commentstring == '' ? '' : split(&commentstring, '%s')[0]
		let title_max_length = last_column_reached-len('{{{')-len(comment_string)-len('-')

		execute string(a:firstline)
		if col('$') > title_max_length
			echoerr 'The first selected line should be smaller than ' . title_max_length
			return
		endif

		execute(printf('normal! A%s%s{{{', comment_string, repeat('-', last_column_reached - len('{{{') - len(comment_string) - col('$') +1)))
		set backspace-=eol | execute(printf("normal! %dGo\<BS>T\<Esc>", a:lastline)) | set backspace+=eol
		execute(printf("normal! A\<BS>%s%s}}}", comment_string, repeat('-', last_column_reached - len(comment_string) - len('}}}') - len('$'))))
	endfunction
	" ---------------------------------------}}}2
	function! CursorIsInClosedFold()
		return foldclosed(line('.')) > 0
	endfunction
function! ToggleUpdatedFoldLevel()"------{{{2
	if CursorIsInClosedFold()
		normal! zx
	else
		normal! zX
	endif
endfunction
"----------------------------------------}}}2

set foldmethod=expr
set foldexpr=MyFoldExpr()
set foldtext=MyFoldText()

command! -bar -range FoldCreate <line1>,<line2>call MyFoldCreate()

nnoremap <silent> zf <S-V>:FoldCreate<CR>
vnoremap <silent> zf :FoldCreate<CR>
nnoremap <silent> zj :keepjumps normal! zj<CR>
nnoremap <silent> zk :keepjumps normal! zkzkzj<CR>
nnoremap <silent> <Space> :silent call ToggleUpdatedFoldLevel()<CR>

"---------------------------------------------}}}1
" Search" ------------------------------------{{{1
set hlsearch
set incsearch
set ignorecase

" Display '1 out of 23 matches' when searching
set shortmess=filnxtToO
nnoremap ! /
vnoremap ! "vy/<C-R>v

nnoremap q! q/
nnoremap z! :BLines {{{<CR>

command! UnderlineCurrentSearchItem silent call matchadd('ErrorMsg', '\c\%#'.@/, 101)

nnoremap <silent> n n:UnderlineCurrentSearchItem<CR>
nnoremap <silent> N N:UnderlineCurrentSearchItem<CR>
nnoremap <silent> * *<C-O>:UnderlineCurrentSearchItem<CR>
vnoremap * "vy/\V<C-R>v\C<cr>:UnderlineCurrentSearchItem<CR>
"---------------------------------------------}}}1
" Autocompletion (Insert Mode)" --------------{{{1

" <Enter> confirms selection
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" <Esc> cancels popup menu
inoremap <expr> <Esc> pumvisible() ? "\<C-E>" : "\<Esc>"

" <C-N> for omnicompletion, <C-P> for context completion
inoremap <expr> <C-N> pumvisible() ? "\<C-N>" : (&omnifunc == '') ? "\<C-N>" : "\<C-X>\<C-O>"

"---------------------------------------------}}}1
" Diff" --------------------------------------{{{1

set diffopt+=algorithm:histogram,indent-heuristic

augroup diff
	au!
	autocmd OptionSet diff let &cursorline=!v:option_new
	autocmd OptionSet diff normal! gg]c
augroup end

"---------------------------------------------}}}1
" QuickFix, Preview, Location window" ---------------------------{{{1

" Always show at the bottom of other windows
augroup quickfix
	au!
" Automatically open, but do not go to (if there are errors).Also close it when is has become empty.
	autocmd QuickFixCmdPost [^l]* nested cwindow
	autocmd FileType qf wincmd J

	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

	autocmd QuickFixCmdPost	l* nested lwindow
augroup end

"---------------------------------------------}}}1

" Additional Functionalities:
" My Meta Files" -----------------------------{{{1
function! ToggleMyMetaBanner()" --------------{{{2
	let buffers = map(tabpagebuflist(), {idx, itm -> bufname(itm)})
	let metafiles = filter(tabpagebuflist(), {idx, itm -> bufname(itm) =~ 'my\.'})
	if len(metafiles) >= 3
		 for bufid in metafiles
		 	call win_gotoid(bufwinid(bufid))
				write | quit
		 endfor
	else
		mark V | let originalWinNr = winnr()

		vnew $r| wincmd L
		new $hz
		new $dz
		new $k | vertical resize 50 | setlocal winfixwidth

		execute(originalWinNr.'wincmd w') | normal! `V
		delmarks V
	endif
endfunction
" -------------------------------------------}}}2
command! ToggleMetaBanner silent call ToggleMyMetaBanner()
nnoremap <Leader>m :ToggleMetaBanner<CR>

augroup mymetabanner
	au!
	autocmd BufEnter my.* setlocal nolist
augroup END

" --------------------------------------------}}}1
" Full screen" ---------------------------{{{
let g:gvimtweak#window_alpha=255 " alpha value (180 ~ 255) default: 245
let g:gvimtweak#enable_alpha_at_startup=1
let g:gvimtweak#enable_topmost_at_startup=0
let g:gvimtweak#enable_maximize_at_startup=1
let g:gvimtweak#enable_fullscreen_at_startup=1
nnoremap <silent> ° :GvimTweakToggleFullScreen<CR>
nnoremap <silent> <A-n> :GvimTweakSetAlpha 10<CR>
nnoremap <silent> <A-p> :GvimTweakSetAlpha -10<CR>
" ---------------------------------------}}}
" Time & Tab Info" ---------------------------{{{1

let g:zindex = 50
function! DisplayPopupTime(...)" -------------{{{2
	if empty(prop_type_get('time'))
		call prop_type_add('time', #{highlight: 'PopupTime'})
	endif

	let text = printf('%s  %s  %s', printf('[Tab%s(%s)]', tabpagenr(), tabpagenr('$')), strftime('%A %d %B'), strftime('[%Hh%M]'))
	let text_length = len(text)
	call popup_create([#{text: text, props:[#{type: 'time', col:1, end_col:1+text_length}]}], #{time:20000, line:&lines+2, col:&columns + 1 - text_length, zindex:g:zindex})
endfunction
" --------------------------------------------}}}2
augroup timedisplay
	au!
	autocmd VimEnter * call DisplayPopupTime() | let t = timer_start(20000, 'DisplayPopupTime', {'repeat':-1})
	autocmd TabLeave,TabEnter * let g:zindex+=1 | call DisplayPopupTime()
augroup end

" --------------------------------------------}}}1
" Pomodoro" ----------------------------------{{{1
let preparation_ms = 5000 * 60
let pomodoro_session_ms = 25000 * 60
let pomodoro_break_ms = 5000 * 60
let nb_pomodoros_in_a_day = 24
let g:current_cycle_nr = 0

function! DisplayPopupTimeSpan(fms, bd_hi, ...)" ---{{{2
	let milliseconds=eval(a:fms)
	let seconds = milliseconds / 1000
	let minutes = seconds / 60
	let seconds = seconds % 60
	let minutes = minutes > 9 ? string(minutes) : '0'.string(minutes)
	let seconds = seconds > 9 ? string(seconds) : '0'.string(seconds)

	let content = printf('%sm%ss', minutes, seconds)
		call popup_create( content, {  'time': 1000, 'highlight':'Normal', 'border':[], 'borderhighlight':repeat([eval(a:bd_hi)], 4), 'line': 1, 'col': &columns - 8 })
	let g:countdown -= 1000
endfunction
" -------------------------------------------}}}2
function! DisplayPopupPomodoro(title, ...)" ---------{{{2
	if empty(prop_type_get('time')) | call prop_type_add('time', #{highlight: 'PopupTime'}) | endif

	let content = [strftime('[%Hh%M] - %A %d %B'), ''] + a:000 + ['', 'La petite citation du jour:', printf('  %s', qotd#getquoteoftheday())]
	call popup_create( content, {  'title': printf(' %s ', a:title), 'close':'button', 'zindex':g:zindex, 'highlight':'Normal', 'border':[], 'borderhighlight':repeat(['csharpClassName'], 4), 'padding':[1,1,1,2] })

	let g:zindex+=1
endfunction
" -------------------------------------------}}}2
function! DisplayPomodoroIntroduction()" -----{{{2
	call DisplayPopupPomodoro( 'Un nouveau soleil se lève...', 'Bonjour :D', '', "Essayons d'avoir une journée productive!", '', "L'objectif est de gérer notre énergie cognitive en ne se perdant pas dans un sujet trop longtemps!", '', "Commençons par prendre [5 minutes] pour se mettre dans le bain et planifier les objectifs de la journée :)")
endfunction
" ------------------------------------------(-}}}2
function! DisplayPomodoroEnding(nb, ...)" ----{{{2
	call DisplayPopupPomodoro( "Le soleil n'ira pas plus haut aujourd'hui!", 'Maintenant, le plus dur...', '', printf("%d pomodoros se sont déroulés aujourd'hui. ", a:nb), '', 'Il est temps de faire autre chose !! :)', '', "Ressource tes énergies pour demain au lieu de forcer dessus pour rien!")
endfunction
" -------------------------------------------}}}2
function! DisplayPomodoroSessionStart(cycle_nr, nb_pomodoros_in_a_day, ...)" --{{{2
	call DisplayPopupPomodoro( printf('[%d/%d] Une nouvelle session démarre...', a:cycle_nr, a:nb_pomodoros_in_a_day), 'Tu viens de passer 5 minutes complètes à te préparer à te re-concentrer sur un problème.', '', 'Il est temps de passer [25 minutes] sur un nombre restreint de problèmes sans dérangement!')
endfunction
" -------------------------------------------}}}2
function! DisplayPomodoroBreakStart(cycle_nr, nb_pomodoros_in_a_day, ...)" ----{{{2
	call DisplayPopupPomodoro( printf('[%d/%d] Fin de la session Pomodoro!', a:cycle_nr, a:nb_pomodoros_in_a_day), 'Tu viens de passer 25 minutes complètes sur un nombre restreint de problèmes.', '', 'Il est temps de passer [5 minutes] sur des choses qui n''ont rien à voir pour te changer les idées! ', '', 'Tu as passé suffisamment de moments dans le passé à coder en faisant plein de fautes d''étourderie', 'pour savoir comment la qualité de tes implémentations va évoluer sans pause mentale ;)', '', 'Je te recommande de commencer par célébrer tes progrès :)')
endfunction
" -------------------------------------------}}}2

function! InitPomodoroDay(preparation_duration, session_duration, break_duration, nb_pomodoros_in_a_day)
	call DisplayPomodoroIntroduction()
	let l:timer_cycles = timer_start(a:preparation_duration, function('StartPomodoroCycles', [a:session_duration, a:break_duration, a:nb_pomodoros_in_a_day]))
	let l:timer_end = timer_start(a:preparation_duration + a:nb_pomodoros_in_a_day * (a:session_duration+a:break_duration), function('DisplayPomodoroEnding', [a:nb_pomodoros_in_a_day]))
endfunction

function! StartPomodoroCycles(session_duration, break_duration, nb_pomodoros_in_a_day, ...)
	call StartPomodoroCycle(a:session_duration, a:break_duration, a:nb_pomodoros_in_a_day)
	let l:timer = timer_start(a:session_duration+a:break_duration, function('StartPomodoroCycle', [a:session_duration, a:break_duration, a:nb_pomodoros_in_a_day]), {'repeat': a:nb_pomodoros_in_a_day-1})

endfunction

function! StartPomodoroCycle(session_ms, break_ms, nb_pomodoros_in_a_day, ...)
		let g:current_cycle_nr += 1
		let g:countdown = a:session_ms+a:break_ms

		call DisplayPomodoroSessionStart(g:current_cycle_nr, a:nb_pomodoros_in_a_day)
		let l:timer = timer_start(a:session_ms, function('DisplayPomodoroBreakStart', [g:current_cycle_nr, a:nb_pomodoros_in_a_day]))

		call DisplayPopupTimeSpan('g:countdown', printf('g:countdown > %d ? "%s" : "%s"', a:break_ms, 'csharpClassName', 'csharpKeyword'))
		let l:timer2 =timer_start(1000, function('DisplayPopupTimeSpan', ['g:countdown', printf('g:countdown > %d ? "%s" : "%s"', a:break_ms, 'csharpClassName', 'csharpKeyword')]), {'repeat': g:countdown/1000})
endfunction

augroup pomodoro
	au!
	"autocmd VimEnter * call InitPomodoroDay(preparation_ms, pomodoro_session_ms,pomodoro_break_ms,nb_pomodoros_in_a_day)
augroup end
" --------------------------------------------}}}1
" File explorer (graphical)" -----------------{{{1

let g:vifm_replace_netrw = 1

function! BuildVifmMarkCommandForFilePath(mark_label, file_path)
	let file_folder_path = substitute(fnamemodify(a:file_path, ':h'), '\\', '/', 'g')
	let file_name = substitute(fnamemodify(a:file_path, ':t'), '\\', '/', 'g')

	return '"mark ' . a:mark_label . ' ' . file_folder_path . ' ' . file_name . '"'
endfunction

let g:vifm_exec_args = ' +"fileviewer *.cs,*.csproj bat --tabs 4 --color always --wrap never --pager never --map-syntax csproj:xml -p %c %p"'
let g:vifm_exec_args.= ' +"windo set number relativenumber numberwidth=1"'
let g:vifm_exec_args.= ' +"nnoremap <C-I> :histnext<cr>"'
let g:vifm_exec_args.= ' +"nnoremap s :!powershell -NoLogo<cr>"'
let g:vifm_exec_args.= ' +"nnoremap K :q<cr>"'
let g:vifm_exec_args.= ' +"nnoremap ! /"'
let g:vifm_exec_args.= ' +"nnoremap yp :!echo %\"F|clip<cr>"'
let g:vifm_exec_args.= ' +"highlight Border cterm=none ctermbg=DarkSeaGreen4"'
let g:vifm_exec_args.= ' +"highlight TopLineSel cterm=none ctermfg=NavajoWhite1 ctermbg=DarkSeaGreen4"'
let g:vifm_exec_args.= ' +"highlight TopLine cterm=none ctermfg=default ctermbg=DarkSeaGreen4"'
let g:vifm_exec_args.= ' +"highlight CurrLine cterm=none ctermfg=NavajoWhite1 ctermbg=66"'
let g:vifm_exec_args.= ' +"highlight OtherLine cterm=none ctermfg=default ctermbg=Grey30"'
let g:vifm_exec_args.= ' +"highlight StatusLine cterm=none ctermfg=default ctermbg=Grey42"'
let g:vifm_exec_args.= ' +"highlight CmdLine cterm=none ctermfg=default ctermbg=Grey23"'
let g:vifm_exec_args.= ' +"highlight WildMenu cterm=none ctermfg=NavajoWhite1 ctermbg=Grey46"'
let g:vifm_exec_args.= ' +' . BuildVifmMarkCommandForFilePath('v', $v)
let g:vifm_exec_args.= ' +' . BuildVifmMarkCommandForFilePath('p', $p)
nnoremap <silent> <expr> <Leader>e ":set noshellslash \| Vifm " . (bufname()=="" ? "." : "%:p:h") . " . \| set shellslash\<CR>"
nnoremap <silent> <expr> <Leader>E ":set noshellslash \| vs\<CR>:Vifm " . (bufname()=="" ? "." : "%:p:h") . " . \| set shellslash\<CR>"

" --------------------------------------------}}}1
" Web Browsing" ------------------------------{{{1
function! WeatherInNewTab()" -----------------{{{2
	tabnew
	let buf = term_start([&shell, '/k', 'chcp 65001 | start /wait /b curl http://wttr.in'], {'exit_cb': {... -> execute('tabclose')}, 'curwin':1})
endfunction
" --------------------------------------------}}}2
command! Weather :call WeatherInNewTab()

function! OpenWebUrl(firstPartOfUrl,...)" ----{{{2
	let visualSelection = getpos('.') == getpos("'<") ? getline("'<")[getpos("'<")[2] - 1:getpos("'>")[2] - 1] : ''

	let finalPartOfUrl = ((a:0 == 0) ? visualSelection : join(a:000))

	let nbDoubleQuotes = len(substitute(finalPartOfUrl, '[^"]', '', 'g'))
	if nbDoubleQuotes > 0 && nbDoubleQuotes % 2 != 0
		finalPartOfUrl.= ' "'
	endif

	let finalPartOfUrl = substitute(finalPartOfUrl, '^\s*\(.\{-}\)\s*$', '\1', '')
	let finalPartOfUrl = substitute(finalPartOfUrl, '"', '\\"', 'g')

	let url = a:firstPartOfUrl . finalPartOfUrl
	let url = escape(url, '%')
	silent! execute '! start firefox "" "' . url . '"'
endfun
" --------------------------------------------}}}2
command! -nargs=* -range Web :call OpenWebUrl('', <f-args>)
nnoremap <Leader>w :Web <C-R>=substitute(expand('%:p'), '/', '\\', 'g')<CR><CR>
vnoremap <Leader>w :Web<CR>

command! -nargs=* -range WordreferenceFrEn :call OpenWebUrl('https://www.wordreference.com/fren/', <f-args>)
command! -nargs=* -range GoogleTranslateFrEn :call OpenWebUrl('https://translate.google.com/?hl=fr#view=home&op=translate&sl=fr&tl=en&text=', <f-args>)
nnoremap <Leader>t :WordreferenceFrEn 
vnoremap <Leader>t :GoogleTranslateFrEn<CR>

command! -nargs=* -range WordreferenceEnFr :call OpenWebUrl('https://www.wordreference.com/enfr/', <f-args>)
command! -nargs=* -range GoogleTranslateEnFr :call OpenWebUrl('https://translate.google.com/?hl=fr#view=home&op=translate&sl=en&tl=fr&text=', <f-args>)
nnoremap <Leader>T :WordreferenceEnFr 
vnoremap <Leader>T :GoogleTranslateEnFr<CR>

command! -nargs=* -range Google :call OpenWebUrl('http://google.com/search?q=', <f-args>)
nnoremap <Leader>q :Google 
vnoremap <Leader>q :Google<CR>

command! -nargs=* -range Youtube :call OpenWebUrl('https://www.youtube.com/results?search_query=', <f-args>)
command! -nargs=* -range YoutubePlaylist :call OpenWebUrl('https://www.youtube.com/results?sp=EgIQAw%253D%253D&search_query=', <f-args>)
nnoremap <Leader>y :Youtube 
nnoremap <Leader>Y :YoutubePlaylist 

" --------------------------------------------}}}1
" Snippets" ----------------------------------{{{1
augroup ultisnips
	au!
	autocmd User UltiSnipsEnterFirstSnippet mark '
augroup end

let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=[$VIM . "/pack/plugins/start/vim-snippets/ultisnips", $HOME . "/Desktop/snippets"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

nnoremap <Leader>u :UltiSnipsEdit!<CR>G
" --------------------------------------------}}}1
" Git" ---------------------------------------{{{1
augroup gitstatus
	autocmd!
	autocmd FileType fugitive set previewwindow
augroup END

augroup gitcommit
	autocmd!
	autocmd FileType gitcommit startinsert
augroup END

nnoremap <silent> <Leader>G :Gtabedit :<CR>
" --------------------------------------------}}}1

" Specific Workflows:
" cs(c#)" ------------------------------------{{{1
function! CsFoldExpr()" ---------------------{{{2
	if !exists('g:fold_levels')
		let g:fold_levels = []
	endif

	let bufnr=bufnr('%')
	if v:lnum ==1
		let nb_lines = line('$')
		let g:fold_levels = map(range(nb_lines+1), {x-> '='})
		let g:fold_levels[nb_lines] = 0
		let g:fold_levels[nb_lines-1] = 0
		let recent_member_declaration = 1
		let recent_class_declaration = 1
		let pat_member_declaration_beginning                             = '\v^%(' . repeat('\t', 3) . '*|' . repeat('\ ', 2*&tabstop+1) . '*)<%(private|protected|public)>' 
		let pat_member_declaration_end_if_right_before_another_beginning = '\v%(^.*})|;\s*$'
		let pat_attribute_or_comment                                     = '\v^%(' . repeat('\t', 3) . '*|' . repeat('\ ', 2*&tabstop+1) . '*)%(/|[).*$'
		let pat_class_or_interface_or_enum_or_struct                               = '\v<%(class|interface|enum|struct)>'

		for i in range(nb_lines-2, 1, -1)
			let line = getline(i)

			if line =~ pat_member_declaration_beginning && line !~ pat_class_or_interface_or_enum_or_struct
				let recent_member_declaration = 1
				if line =~pat_member_declaration_end_if_right_before_another_beginning
					let g:fold_levels[i] = '='
				else
					let g:fold_levels[i] = 'a1'
				endif
			elseif line =~ pat_class_or_interface_or_enum_or_struct
				let recent_class_declaration = 1
			elseif line =~ pat_member_declaration_end_if_right_before_another_beginning
				if recent_class_declaration	
					let g:fold_levels[i] = '='
					let recent_class_declaration = 0
				elseif recent_member_declaration
					let g:fold_levels[i] = 's1'
					let recent_member_declaration = 0
				endif
			elseif line =~ pat_attribute_or_comment	&& g:fold_levels[i+1] == 'a1'
				let g:fold_levels[i+1] = '='
				let g:fold_levels[i] = 'a1'
			endif
		endfor
endif

let res = g:fold_levels[v:lnum]
"echomsg printf('[%d:%s;%d] %s', v:lnum, res, match(getline(v:lnum), '\v<%(class|interface)>'),getline(v:lnum))
return res
endfunction
" --------------------------------------------}}}2
function! CsParseMemberDeclaration(line)" ---{{{2
	if !exists('g:keywords_mapping')
		let g:keywords_mapping = { 'public': '+', 'internal': '&', 'protected': '|', 'private': '-', 'static': '^', 'abstract': '%', 'override': 'o', 'async': 'a'}
	endif
	let res = {}
	let res.name = matchlist(a:line, '\v(%(\w|\<|\>|\[|\])+)\(')[1]
	if (expand('%:t') == printf('%s.cs', res.name ))
		let res.output = res.name
	else
		let res.output = matchlist(a:line, '\v(%(\w|\<|\>|\[|\])+) %(\w|\<|\>|\[|\])+\(')[1] 
	end

	let res.indent = a:line[:match(a:line, '\a')-1]

	let meta_keywords = split(a:line[:stridx(a:line, res.output)-1], '\s\+')
	let res.meta = {'keywords':[], 'shortversion': ''}
	for kw in meta_keywords
		call add(res.meta.keywords, kw)
		let res.meta.shortversion.= get(g:keywords_mapping, kw)
	endfor

	let res.params = []
	let params = split(a:line[stridx(a:line, res.name)+ len(res.name) + 1:match(a:line, '\)')-1], ', ')
	for param in params
		let parsed = split(param, ' ')
		call add(res.params, {'type': parsed[0], 'name': parsed[1]})
	endfor

	return res
endfunction
" -------------------------------------------}}}2
function! CsFoldText()" ---------------------{{{2
	let titleLineNr = v:foldstart
	let line = getline(titleLineNr)

	while (match(line, '\v^\s+([|\<)') >= 0 && titleLineNr < v:foldend)
		let titleLineNr += 1
	let line = getline(titleLineNr)
	endwhile
let nucolwidth = &fdc + &number * &numberwidth
let windowwidth = winwidth(0) - nucolwidth - (&foldcolumn ? 3 : 0)
let foldedlinecount = v:foldend - v:foldstart - 1

let d = CsParseMemberDeclaration(line)
return printf('%s%s%s%s %s -> %s [%s line%s]', d.indent, d.meta.shortversion, repeat(' ', 4-len(d.meta.shortversion)), d.name, empty(d.params) ? '' : '{ '.join(map(d.params, {_,itm->printf('%s @%s',itm.name, itm.type)}), ', ').' }', d.output, foldedlinecount, foldedlinecount > 1 ? 's' : '')
endfunction
"  --------------------------------------------}}}2
let g:OmniSharp_server_stdio = 1"--------{{{
let g:OmniSharp_popup_options = {
\ 'highlight': 'csharpClassName',
\ 'padding': [1,1,1,2],
\ 'border': [1],
\ 'borderhighlight': ['csharpInterfaceName']
\}
let g:OmniSharp_highlight_types = 3
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_want_snippet=1
let g:omnicomplete_fetch_full_documentation = 1
let g:OmniSharp_highlight_debug = 1
let g:OmniSharp_diagnostic_showid = 1
let g:OmniSharp_diagnostic_overrides = { 'CS8019': {'type': 'None'} }
let g:OmniSharp_highlight_groups = { 
	\ 'csharpKeyword':                [ 'keyword'                     ],
	\ 'csharpNamespaceName':          [ 'namespace name'              ],
	\ 'csharpPunctuation':            [ 'punctuation'                 ],
	\ 'csharpOperator':               [ 'operator'                    ],
	\ 'csharpInterfaceName':          [ 'interface name'              ],
	\ 'csharpStructName':             [ 'struct name'                 ],
	\ 'csharpEnumName':               [ 'enum name'                   ],
	\ 'csharpEnumMemberName':         [ 'enum member name'            ],
	\ 'csharpClassName':              [ 'class name'                  ],
	\ 'csharpStaticSymbol':           [ 'static symbol'               ],
	\ 'csharpFieldName':              [ 'field name'                  ],
	\ 'csharpPropertyName':           [ 'property name'               ],
	\ 'csharpMethodName':             [ 'method name'                 ],
	\ 'csharpParameterName':          [ 'parameter name'              ],
	\ 'csharpLocalName':              [ 'local name'                  ],
	\ 'csharpKeywordControl':         [ 'keyword - control'           ],
	\ 'csharpString':                 [ 'string'                      ],
	\ 'csharpNumber':                 [ 'number'                      ],
	\ 'csharpConstantName':           [ 'constant name'               ],
	\ 'csharpIdentifier':             [ 'identifier'                  ],
	\ 'csharpExtensionMethodName':    [ 'extension method name'       ],
	\ 'csharpComment':                [ 'comment'                     ],
	\ 'csharpXmlDocCommentName':      [ 'xml doc comment - name'      ],
	\ 'csharpXmlDocCommentDelimiter': [ 'xml doc comment - delimiter' ],
	\ 'csharpXmlDocCommentText':      [ 'xml doc comment - text'      ]
	\ }
"----------------------------------------}}}

	augroup csharpfiles
		au!
		autocmd BufEnter *.cs setlocal foldmethod=expr foldexpr=CsFoldExpr() foldtext=CsFoldText()
		autocmd BufEnter *.cs setlocal errorformat=\ %#%f(%l\\\,%c):\ %m
		autocmd BufEnter *.cs setlocal makeprg=dotnet\ build\ /p:GenerateFullPaths=true
		autocmd BufEnter *.cs nnoremap <LocalLeader>M :!dotnet run<CR>
		autocmd BufWritePost *.cs OmniSharpFixUsings | OmniSharpCodeFormat
		autocmd FileType cs nnoremap <buffer> zk :OmniSharpNavigateUp<CR>zz
		autocmd FileType cs nnoremap <buffer> zj :OmniSharpNavigateDown<CR>zz
		autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
		autocmd FileType cs nnoremap <buffer> gD :OmniSharpPreviewDefinition<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>i :OmniSharpFindImplementations<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>I :OmniSharpPreviewImplementation<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>s :OmniSharpFindSymbol<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>u :OmniSharpFindUsages<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>m :OmniSharpFindMembers<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>t :OmniSharpTypeLookup<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>d :OmniSharpDocumentation<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>O :ALEEnable<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>c :OmniSharpGlobalCodeCheck<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>q :OmniSharpGetCodeActions<CR>
		autocmd FileType cs xnoremap <buffer> <LocalLeader>q :call OmniSharp#GetCodeActions('visual')<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>r :OmniSharpRename<CR>
		autocmd FileType cs nnoremap <buffer> <LocalLeader>f :OmniSharpFixUsings<CR>:OmniSharpCodeFormat<CR>
	augroup end

	"--------------------------------------------}}}1

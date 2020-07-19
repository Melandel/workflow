" Most used files and directories" ------{{{1
let $desktop = $HOME . '/Desktop'
let $v = $desktop . '/tools/vim/_vimrc'
let $p = $desktop . '/tools/vim/pack/plugins/start/'
let $c = $desktop . '/tools/vim/pack/plugins/start/vim-empower/colors/empower.vim'
" ---------------------------------------}}}1

" Desktop Integration:
" Plugins" ------------------------------{{{1
function! MinpacInit()
	packadd minpac
	call minpac#init( #{dir:$VIM, package_name: 'plugins' } )

	call minpac#add('dense-analysis/ale')
	call minpac#add('junegunn/fzf.vim')
	call minpac#add('itchyny/lightline.vim')
	call minpac#add('itchyny/vim-gitbranch')
	call minpac#add('OmniSharp/omnisharp-vim')
	call minpac#add('nickspoons/vim-sharpenup')

	call minpac#add('SirVer/ultisnips')
	call minpac#add('honza/vim-snippets')

	call minpac#add('justinmk/vim-dirvish')

	call minpac#add('tpope/vim-dadbod')
	call minpac#add('tpope/vim-surround')
	call minpac#add('tpope/vim-repeat')
	call minpac#add('junegunn/vim-easy-align')
	call minpac#add('tpope/vim-fugitive')
	call minpac#add('tpope/vim-obsession')
	call minpac#add('ap/vim-css-color')

	call minpac#add('wellle/targets.vim')

	call minpac#add('Melandel/vim-empower')
	call minpac#add('Melandel/fzfcore.vim')
	call minpac#add('Melandel/gvimtweak')
	call minpac#add('Melandel/vim-amake')
endfunction
command! -bar MinPacInit call MinpacInit()
command! -bar MinPacUpdate call MinpacInit()| call minpac#clean()| call minpac#update()

packadd! matchit
" ---------------------------------------}}}1
" First time" ---------------------------{{{1
if !isdirectory($VIM.'/pack/plugins')
	call system('git clone https://github.com/k-takata/minpac.git ' . $VIM . '/pack/packmanager/opt/minpac')
	call MinpacInit()
	call minpac#update()
	packloadall
endif
" ---------------------------------------}}}1
" Duplicated/Generated files" -----------{{{1
augroup duplicatefiles
	au!
	au BufWritePost my_keyboard.ahk exec '!Ahk2Exe.exe /in %:p /out ' . fnameescape($HOME . '/Desktop/tools/myAzertyKeyboard.RunMeAsAdmin.exe')
augroup end
" ---------------------------------------}}}1

" General:
" Settings" -----------------------------{{{1
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
set fillchars=vert:\|,fold:\ 
set noswapfile
set directory=$HOME/Desktop/tmp/vim
set backup
set backupdir=$HOME/Desktop/tmp/vim
set undofile
set undodir=$HOME/Desktop/tmp/vim
set viewdir=$HOME/Desktop/tmp/vim

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
" ---------------------------------------}}}1
" Tabs and Indentation" -----------------{{{
set smartindent
set tabstop=1
set shiftwidth=1

nnoremap > >>
nnoremap < <<

command! -bar Spaces2Tabs set noet ts=4 |%retab!|set ts=1
" ---------------------------------------}}}
" Leader keys" --------------------------{{{
let mapleader = 's'
let maplocalleader = 'q'
" ---------------------------------------}}}
" Local Current Directories" ------------{{{
function! LcdToGitRoot()"---------------{{{2
	let gitrootdir = fnamemodify(gitbranch#dir(expand('%:p')), ':h')
	execute(printf('lcd %s', gitrootdir))
endfunction
"---------------------------------------}}}2
function! LcdToSlnOrCsproj(...)" --------{{{2
	let omnisharp_host = getbufvar(bufnr('%'), 'OmniSharp_host')
	if empty(omnisharp_host)
		return
	endif
	let srcRoot = fnamemodify(omnisharp_host.sln_or_dir, ':h')
	execute(printf('lcd %s', srcRoot))
endfunc
" ---------------------------------------}}}2
command! -bar Lcd silent lcd $desktop | call LcdToGitRoot() | call LcdToSlnOrCsproj() | echomsg printf('Current directory path set to: %s', getcwd())

augroup lcd
	au!
	autocmd BufRead * lcd $desktop | call LcdToGitRoot() | call LcdToSlnOrCsproj()
augroup end
" ---------------------------------------}}}
" Utils"--------------------------------{{{
function! LastCharacter()
	return strcharpart(getline('.')[col('.'):], 0, 1)
endfunction

function! CurrentCharacter()
	return strcharpart(getline('.')[col('.') - 1:], 0, 1)
endfunction

function! NextCharacter()
	return strcharpart(getline('.')[col('.') - 2:], 0, 1)
endfunction

function! ExecuteAndAddIntoHistory(script)
	call histadd('cmd', a:script)
	execute(a:script)
endfunction

function! ClearTrailingWhiteSpaces()
	%s/\s\+$//e
endfunction
command ClearTrailingWhiteSpaces call ClearTrailingWhiteSpaces()

function! QuickFixWindowIsOpen()
	return len(filter(range(1, winnr('$')), {_,x -> getwinvar(x, '&syntax') == 'qf'}))
endfunction
"---------------------------------------}}}

" AZERTY Keyboard:
" AltGr keys" ---------------------------{{{1
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
" ---------------------------------------}}}1
" Arrows" -------------------------------{{{1
inoremap <C-J> <Left>|  cnoremap <C-J> <Left>|  tnoremap <C-J> <Left>
inoremap <C-K> <Right>| cnoremap <C-K> <Right>| tnoremap <C-K> <Right>
" ---------------------------------------}}}1
" Home,End" -----------------------------{{{1
inoremap ^j <Home>| cnoremap ^j <Home>| tnoremap ^j <Home>
inoremap ^k <End>|  cnoremap ^k <End>|  tnoremap ^k <End>
" ---------------------------------------}}}1
" Backspace,Delete" ---------------------{{{1
tnoremap <C-L> <Del>
inoremap <C-L> <Del>|   cnoremap <C-L> <Del>
" ---------------------------------------}}}1

" Graphical Layout:
" Colorscheme, Highlight groups" --------{{{1
colorscheme empower
nnoremap <LocalLeader>h :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
nnoremap <LocalLeader>H :OmniSharpHighlightEchoKind<CR>
" ---------------------------------------}}}1
" Buffers, Windows & Tabs" --------------{{{1
set hidden
set splitbelow
set splitright
set previewheight=25
set showtabline=0

" List/Open Buffers
nnoremap <Leader>b :History<CR>
nnoremap <Leader>B :Buffers<CR>

" Close Buffers
function! DeleteHiddenBuffers()" --------{{{2
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
" ---------------------------------------}}}2
nnoremap <Leader>c :silent! call DeleteHiddenBuffers()<CR>:ls<CR>

" Open/Close Window or Tab
nnoremap <Leader>s :split<CR>
nnoremap <Leader>v :vsplit<CR>
nnoremap K :q<CR>
nnoremap <Leader>o mW:tabnew<CR>`W
nnoremap <silent> <Leader>x :tabclose<CR> | nnoremap <C-s>x :tabclose<CR>
nnoremap <Leader>X :tabonly<CR>:sp<CR>:q<CR>:let g:zindex+=1<CR>:call DisplayPopupTime()<CR>

" Browse to Window or Tab
nnoremap <Leader>h <C-W>h| nnoremap <C-s>h <C-W>h| tnoremap <C-s>h <C-W>h
nnoremap <Leader>j <C-W>j| nnoremap <C-s>l <C-W>l| tnoremap <C-s>l <C-W>l 
nnoremap <Leader>k <C-W>k| nnoremap <C-s>j <C-W>j| tnoremap <C-s>j <C-W>j
nnoremap <Leader>l <C-W>l| nnoremap <C-s>k <C-W>k| tnoremap <C-s>k <C-W>k
nnoremap <Leader>n gt|     nnoremap <C-s>n gt
nnoremap <Leader>p gT|     nnoremap <C-s>p gT

augroup windows
	autocmd!
	"
	" foldcolumn serves here to give a visual clue for the current window
	autocmd WinLeave * if !pumvisible() | setlocal norelativenumber foldcolumn=0 | endif
	autocmd WinEnter * if !pumvisible() | setlocal relativenumber foldcolumn=1 | endif

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
nnoremap <silent> <A-h> :vert res -2<CR>| tmap <silent> <A-h> <C-W>N:vert res -2<CR>i
nnoremap <silent> <A-l> :vert res +2<CR>| tmap <silent> <A-l> <C-W>N:vert res +2<CR>i
nnoremap <silent> <A-j> :res -2<CR>|      tmap <silent> <A-j> <C-W>N:res -2<CR>i
nnoremap <silent> <A-k> :res +2<CR>|      tmap <silent> <A-k> <C-W>N:res +2<CR>i
nnoremap <silent> <Leader>= <C-W>=
nnoremap <silent> <Leader>\| <C-W>\|
nnoremap <silent> <Leader>_ <C-W>_

" Resize a window for some text
function! FocusLines(...) range"--------{{{2
	let nblines_minus_one = (a:0 == 1) ? a:1 : (a:lastline - a:firstline)
	if getline(a:lastline) =~ '^\s*$'
		let nblines_minus_one -=1
	endif

	split
	wincmd k
 setlocal nowrap

	let winid = win_getid()
	wincmd h
	let is_leftmost_win = win_getid() == winid
	if is_leftmost_win
		setlocal winfixwidth
	else
		call win_gotoid(winid)
	endif

 execute('resize '.(nblines_minus_one+2+1))
	normal! kztj
endfunction
"---------------------------------------}}}2
command! -range -nargs=? -bar FocusLines <line1>,<line2>call FocusLines(<f-args>)
nnoremap <Leader>r :FocusLines 
vnoremap <Leader>r :FocusLines<CR>

" Alternate file fast switching
noremap <Leader>d <C-^>

function! SwapWindowContents(hjkl_keys)"-{{{2
	mark V
	let originalWinNr = winnr()

	for hjkl_key in split(a:hjkl_keys, '\zs') | silent! execute('wincmd ' . hjkl_key) | endfor
	let targetWinNr = winnr()
	mark W
	normal! `V

	execute(originalWinNr.'wincmd w')
 normal! `W

	execute(targetWinNr.'wincmd w')

	delmarks VW
endfunction
"----------------------------------------}}}2
command! -nargs=1 -bar SwapWindows call SwapWindowContents(<f-args>)
nnoremap SJ :SwapWindows j<CR> | nnoremap SJJ :SwapWindows jj<CR> | nnoremap SJK :SwapWindows jk<CR> | nnoremap SJH :SwapWindows jh<CR> | nnoremap SJL :SwapWindows jl<CR> 
nnoremap SK :SwapWindows k<CR> | nnoremap SKJ :SwapWindows kj<CR> | nnoremap SKK :SwapWindows kk<CR> | nnoremap SKH :SwapWindows kh<CR> | nnoremap SKL :SwapWindows kl<CR>
nnoremap SH :SwapWindows h<CR> | nnoremap SHJ :SwapWindows hj<CR> | nnoremap SHK :SwapWindows hk<CR> | nnoremap SHH :SwapWindows hh<CR> | nnoremap SHL :SwapWindows hl<CR>
nnoremap SL :SwapWindows l<CR> | nnoremap SLJ :SwapWindows lj<CR> | nnoremap SLK :SwapWindows lk<CR> | nnoremap SLH :SwapWindows lh<CR> | nnoremap SLL :SwapWindows ll<CR>
" ---------------------------------------}}}1
" Status bar" ---------------------------{{{1
set laststatus=2
function! FileSizeAndRows() abort" ------{{{2
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
" ---------------------------------------}}}2
function! FolderRelativePathFromGit()
	let filepath = expand('%:p')
	let folderpath = expand('%:p:h')
	let gitrootfolder = fnamemodify(gitbranch#dir(filepath), ':h:p')
	let foldergitpath = folderpath[len(gitrootfolder)+1:]

	return './' . substitute(foldergitpath, '\', '/', 'g')
endfunction
function! GitBranch()
	return printf('[%s]', gitbranch#name())
endfunction
function! GitInfo()
	return FolderRelativePathFromGit() . ' ' . GitBranch()
endfunction
function! IsOmniSharpRelated()
	return OmniSharp#GetHost().sln_or_dir =~ '\v\.(sln|csproj)$'
endfunction
function! WinNr()
	return printf('[Window #%s]', winnr())
endfunction
exec("source $p/vim-sharpenup/autoload/sharpenup/statusline.vim")

let g:sharpenup_statusline_opts = '%s'
let g:sharpenup_statusline_opts = { 'Highlight': 0 }
let g:sharpenup_statusline_opts = {
\ 'TextLoading': '%s…',
\ 'TextReady': '%s',
\ 'TextDead': '…',
\ 'Highlight': 0
\}
let g:lightline = {
	\ 'colorscheme': 'empower',
	\ 'component_function': { 'filesize_and_rows': 'FileSizeAndRows', 'winnr': 'WinNr', 'gitbranch': 'GitBranch', 'foldergitpath': 'FolderRelativePathFromGit'	},
	\ 'component': { 'sharpenup': sharpenup#statusline#Build(), 'gitinfo': '%<%{FolderRelativePathFromGit()} %{GitBranch()}' },
	\ 'component_visible_condition': { 'sharpenup': 'IsOmniSharpRelated()' },
	\ 'active':   {   'left':  [ [ 'mode', 'paste', 'readonly', 'modified' ] ], 'right': [ ['sharpenup', 'filename',  'readonly', 'modified' ], [ 'gitinfo' ] ] },
	\ 'inactive': {   'left':  [ ['winnr'] ], 'right': [ [ 'sharpenup', 'filename', 'readonly', 'modified' ], [ 'gitinfo' ] ] }
\}
" ---------------------------------------}}}1

" Motions:
" hjkl"----------------------------------{{{
nnoremap j gj
nnoremap k gk
""---------------------------------------}}}
" Browsing File Architecture" -----------{{{1
"
function! BrowseLayoutDown()" -----------{{{2 
	if &diff
		keepjumps execute 'silent! normal! ]czx'
	elseif len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')) > 0
		keepjumps silent! cnext
	else
		keepjumps execute 'silent! normal! }}{j'
	endif

	silent! normal! zv
	normal! m'
endfunction
" ---------------------------------------}}}2
nnoremap <silent> <C-J> :call BrowseLayoutDown()<CR>

function! BrowseLayoutUp()" -------------{{{2
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

	silent! normal! zv
	normal! m'
endfunction
" ---------------------------------------}}}2
nnoremap <silent> <C-K> :call BrowseLayoutUp()<CR>

" ---------------------------------------}}}1
" Current Line" -------------------------{{{1

nnoremap <silent> . :let c= strcharpart(getline('.')[col('.') - 1:], 0, 1)\|exec "normal! f".c<CR>

function! ExtendedHome()" ---------------{{{2
    let column = col('.')
    normal! ^
    if column == col('.')
        normal! 0
    endif
endfunction
" ---------------------------------------}}}2
nnoremap <silent> <Home> :call ExtendedHome()<CR>
vnoremap <silent> <Home> <Esc>:call ExtendedHome()<CR>mvgv`v
onoremap <silent> <Home> :call ExtendedHome()<CR>

function! ExtendedEnd()" ----------------{{{2
    let column = col('.')
    normal! g_
    if column == col('.') || column == col('.')+1
        normal! $
    endif
endfunction
" ---------------------------------------}}}2
nnoremap <silent> <End> :call ExtendedEnd()<CR>
vnoremap <silent> <End> <Esc>:call ExtendedEnd()<CR>mvgv`v
onoremap <silent> <End> :call ExtendedEnd()<CR>

function! MoveCursorToNext(pattern)" ----{{{2
	mark '
	let match =	 searchpos(a:pattern, '', line('.'))
endfunction
" ---------------------------------------}}}2
function! MoveCursorToLast(pattern)" ----{{{2
	mark '
	let match = searchpos(a:pattern, 'b', line('.'))
endfunction
" ---------------------------------------}}}2
function! MoveToLastMatch()"------------{{{2
	let lastcmd = histget('cmd', -1)

	if lastcmd =~ 'MoveCursorTo'
		execute substitute(lastcmd, 'Next', 'Last', 'g')
	else
		normal! ,
	endif
endfunction
"---------------------------------------}}}2
function! MoveToNextMatch()"------------{{{2
	let lastcmd = histget('cmd', -1)

	if lastcmd =~ 'MoveCursorTo'
		execute substitute(lastcmd, 'Last', 'Next', 'g')
	else
		normal! ;
	endif
endfunction
"---------------------------------------}}}2
nnoremap <silent> <Leader>, :call ExecuteAndAddIntoHistory("call MoveCursorToNext('[A-Z_]\\C')")<CR>
nnoremap <silent> <Leader>; :call ExecuteAndAddIntoHistory("call MoveCursorToNext('[^A-Za-z_ \\t]\\C')")<CR>
nnoremap <silent> , :call MoveToLastMatch()<CR>
nnoremap <silent> ; :call MoveToNextMatch()<CR>

function! VMoveToLastMatch()"------------{{{2
	normal! gv
	let lastcmd = histget('cmd', -1)

	if lastcmd =~ 'MoveCursorTo'
		execute substitute(lastcmd, 'Next', 'Last', 'g')
	else
		normal! ,
	endif
endfunction
"---------------------------------------}}}2
function! VMoveToNextMatch()"------------{{{2
	normal! gv
	let lastcmd = histget('cmd', -1)

	if lastcmd =~ 'MoveCursorTo'
		execute substitute(lastcmd, 'Last', 'Next', 'g')
	else
		normal! ;
	endif
endfunction
"---------------------------------------}}}2
vnoremap <silent> <Leader>, :<C-U>call ExecuteAndAddIntoHistory("call MoveCursorToNext('[A-Z_]\\C')") \| normal! v`<o<CR>
vnoremap <silent> <Leader>; :<C-U>call ExecuteAndAddIntoHistory("call MoveCursorToNext('[^A-Za-z_ \\t]\\C')") \| normal! v`<o<CR>
vnoremap <silent> , :<C-U>call VMoveToLastMatch()<CR>
vnoremap <silent> ; :<C-U>call VMoveToNextMatch()<CR>
" ---------------------------------------}}}1
" Text objects" -------------------------{{{1

" Always add cursor position to jumplist
let g:targets_jumpRanges = 'cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb al rB Al bb aa bB Aa BB AA'

" Lines
vnoremap il ^og_| onoremap il :normal vil<CR>
vnoremap al 0o$h| onoremap al :normal val<CR>

" Folds
vnoremap iz [zjo]zkVg_| onoremap iz :normal viz<CR>
vnoremap az [zo]zVg_|   onoremap az :normal vaz<CR>

" Entire file
vnoremap if ggoGV| onoremap if :normal vif<CR>

" ---------------------------------------}}}1

" Text Operations:
" Visualization" ------------------------{{{1

" select until end of line
nnoremap vv ^vg_

" Last inserted text
nnoremap vI `[v`]h

" ---------------------------------------}}}1
" Copy & Paste" -------------------------{{{1

" Yank current line, trimmed
nnoremap Y y$

" Yank into system clipboard
nnoremap zy "+y
nnoremap zY "+Y
vnoremap zy "+y

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

" ---------------------------------------}}}1
" Repeat-Last-Action" -------------{{{1
nnoremap ù .
" ---------------------------------------}}}1
" Vertical Alignment" -------------------{{{1
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" ---------------------------------------}}}1

" Vim Core Functionalities:
" Wild Menu" ----------------------------{{{1

set wildmenu
set wildcharm=<Tab>
set wildignorecase
set wildmode=full

"----------------------------------------}}}1
" Expanded characters" ------------------{{{1

" Folder of current file
cnoremap µ <C-R>=expand('%:p:h')<CR>\

"----------------------------------------}}1
" Sourcing" -----------------------------{{{1

" Run a line/selected text composed of vim script
vnoremap <silent> <Leader>S y:execute @@<CR>
nnoremap <silent> <Leader>S ^vg_y:execute @@<CR>

" Write output of a vim command in a buffer
nnoremap ç :let script=''\|call histadd('cmd',script)\|put=execute(script)<Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>

augroup vimsourcing
	au!
	autocmd BufWritePost _vimrc GvimTweakToggleFullScreen | so % | GvimTweakToggleFullScreen
augroup end

"----------------------------------------}}}1
" Find, Grep, Make, Equal" --------------{{{1
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ $*

nnoremap <Leader>f :Files<CR>
nnoremap <Leader>F :Files <C-R>=fnamemodify('.', ':p')<CR>
nnoremap <Leader>g :Lcd<CR>:Agrep --no-ignore-parent 
vnoremap <Leader>g "vy:Lcd<CR>:let cmd = printf('Agrep --no-ignore-parent %s %s',escape(@v,'\\#%'),getcwd())\|echo cmd\|call histadd('cmd',cmd)\|execute cmd<CR>
"----------------------------------------}}}1
" Registers" ----------------------------{{{1
command! ClearRegisters for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor
"----------------------------------------}}}1
" Terminal" -----------------------------{{{1
set termwinsize=12*0
tnoremap <C-W>N <C-W>N:setlocal norelativenumber nonumber foldcolumn=0 nowrap<CR>zb
"----------------------------------------}}}1
" Folding" ------------------------------{{{1
function! MyFoldExpr()" ----------------{{{2
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
" --------------------------------------}}}2
function! MyFoldText()" ----------------{{{2
	let line = getline(v:foldstart)
	let end_of_title = stridx(line, (&commentstring == '' ? '-' : split(&commentstring, '%s')[0]), match(line, '\a'))-1
	let nucolwidth = &fdc + &number * &numberwidth
	let windowwidth = winwidth(0) - nucolwidth - 3
	let foldedlinecount = v:foldend - v:foldstart - 1

	return printf('%s%s%d', line[:end_of_title], repeat(' ', windowwidth - (end_of_title+1) - len(string(foldedlinecount))), foldedlinecount)
endfunction
" --------------------------------------}}}2
function! MyFoldCreate() range" --------{{{2
	let last_column_reached = 50 - 7 "1 for eol listchar, 2 for line number, 2 for relative line number, 1 for foldcolumn, 1 for foldlevel
	let comment_string = &commentstring == '' ? '' : split(&commentstring, '%s')[0]
	let title_max_length = last_column_reached-len('{{{')-len(comment_string)-len('-')

	execute string(a:firstline)
if col('$') > title_max_length
	echoerr 'The first selected line should be smaller than ' . title_max_length
		return
	endif

	let title_foldmarker = printf('%s%s{{{', comment_string, repeat('-', last_column_reached - len('{{{') - len(comment_string) - col('$') +1))
	execute('normal! A'.title_foldmarker)

	execute('copy '.a:lastline)
	normal! vt{r-f{v$r}
	if comment_string != ''
		execute('normal! ^R'.comment_string)
		execute('normal! $')
	endif
endfunction
" --------------------------------------}}}2
function! CursorIsInClosedFold()"------{{{2
	return foldclosed(line('.')) > 0
endfunction
"--------------------------------------}}}
function! ToggleUpdatedFoldLevel()"------{{{2
	if CursorIsInClosedFold()
		normal! zx
	else
		normal! zX
	endif
endfunction
"----------------------------------------}}}2
function! GoToPreviousFoldBeginning()"--{{{2
	keepjumps normal! zk
	if CursorIsInClosedFold()
		return
	else
		keepjumps normal! [z
	endif
endfunction
"---------------------------------------}}}2

set foldmethod=expr
set foldexpr=MyFoldExpr()
set foldtext=MyFoldText()

command! -bar -range FoldCreate <line1>,<line2>call MyFoldCreate()

nnoremap <silent> <Space> :silent call ToggleUpdatedFoldLevel()<CR>
nnoremap <silent> zv zvzz
nnoremap <silent> zf <S-V>:FoldCreate<CR>
vnoremap <silent> zf :FoldCreate<CR>
nnoremap <silent> zj :keepjumps normal! zj<CR>
nnoremap <silent> zk :silent call GoToPreviousFoldBeginning()<CR>
nnoremap <silent> zh [z
nnoremap <silent> zl ]z

"----------------------------------------}}}1
" Search" -------------------------------{{{1
set hlsearch
set incsearch
set ignorecase

" Display '1 out of 23 matches' when searching
set shortmess=filnxtToO
nnoremap ! /
vnoremap ! "vy/<C-R>v
nnoremap <Leader>! :BLines<CR>

nnoremap q! q/
nnoremap z! :BLines {{{<CR>

command! UnderlineCurrentSearchItem silent call matchadd('ErrorMsg', '\c\%#'.@/, 101)

nnoremap <silent> n n:UnderlineCurrentSearchItem<CR>
nnoremap <silent> N N:UnderlineCurrentSearchItem<CR>
nnoremap <silent> * *<C-O>:UnderlineCurrentSearchItem<CR>
vnoremap * "vy/\V<C-R>v\C<cr>:UnderlineCurrentSearchItem<CR>

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -nargs=? CopyMatches :call CopyMatches(<f-args>)
"----------------------------------------}}}1
" Autocompletion (Insert Mode)" ---------{{{1

" <Enter> confirms selection
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" <Esc> cancels popup menu
"inoremap <expr> <Esc> pumvisible() ? "\<C-E>" : "\<Esc>"

" <C-N> for omnicompletion, <C-P> for context completion
inoremap <expr> <C-N> (&omnifunc == '') ? '<C-N>' : '<C-X><C-O>'
"----------------------------------------}}}1
" Diff" ---------------------------------{{{1

set diffopt+=algorithm:histogram,indent-heuristic

augroup diff
	au!
	autocmd OptionSet diff let &cursorline=!v:option_new
	autocmd OptionSet diff normal! gg]c
augroup end

"----------------------------------------}}}1
" QuickFix, Preview, Location window" ---{{{1

" Always show at the bottom of other windows
augroup quickfix
	au!
" Automatically open, but do not go to (if there are errors).Also close it when is has become empty.
	autocmd QuickFixCmdPost [^l]* nested cwindow
	autocmd FileType qf wincmd J

	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

	autocmd QuickFixCmdPost	l* nested lwindow
augroup end

"----------------------------------------}}}1

" Additional Functionalities:
" My Files" -----------------------------{{{1
function! GetMyFilesBuffers()
	return filter(tabpagebuflist(), {idx, itm -> bufname(itm) =~ 'my\.day\|my\.happyplace\|my\.todo\|my\.notabene'})
endfunction
function! ToggleMyFiles()" --------------{{{2
	let mybuffers = GetMyFilesBuffers()
if len(mybuffers) > 0 && len(mybuffers) % 4 == 0
		call HideMyFiles(mybuffers)
	else
		call ShowMyFiles()
	endif
endfunction
" ---------------------------------------}}}2
function! ShowMyFiles()"----------------{{{2
		let original_winid = win_getid(winnr())
		windo setlocal winfixheight winfixwidth

		let botright_winid =win_getid(winnr('$')) 
		call win_gotoid(botright_winid)
		setlocal nowinfixheight nowinfixwidth

		vnew $desktop/my.day | normal! Gzx[zkzt
		wincmd L
		new $desktop/my.happyplace |normal! Gzx[zkzt 
		new $desktop/my.todo
		new $desktop/my.notabene
		vertical resize 50
		call win_gotoid(original_winid)
endfunction
"---------------------------------------}}}2
function! HideMyFiles(...)"-------------{{{2
	let original_winid = win_getid(winnr())
	let mybuffers = (a:0 > 0) ? a:1 :filter(copy(tabpagebuflist()), {idx, itm -> bufname(itm) =~ 'my\.'}) 

	for bufid in mybuffers
		call win_gotoid(bufwinid(bufid)) | write | quit
	endfor

	call win_gotoid(original_winid)
	windo setlocal nowinfixheight nowinfixwidth
endfunction
"---------------------------------------}}}2
command! ShowMyFiles silent call ShowMyFiles()
command! HideMyFiles silent call HideMyFiles()
command! ToggleMyFiles silent call ToggleMyFiles()

nnoremap <Leader>m :ToggleMyFiles<CR> | nnoremap <C-W>m :ToggleMyFiles<CR> | tmap <C-S>m <C-W>N:ToggleMyFiles<CR>i

augroup myfiles
	au!
	autocmd BufEnter my.* set filetype=my
	autocmd FileType my setlocal nolist
	autocmd FileType my setlocal commentstring=
augroup end

" ---------------------------------------}}}1
" Full screen" --------------------------{{{
let g:gvimtweak#window_alpha=255 " alpha value (180 ~ 255) default: 245
let g:gvimtweak#enable_alpha_at_startup=1
let g:gvimtweak#enable_topmost_at_startup=0
let g:gvimtweak#enable_maximize_at_startup=1
let g:gvimtweak#enable_fullscreen_at_startup=1
nnoremap <silent> ° :GvimTweakToggleFullScreen<CR>
nnoremap <silent> <A-n> :GvimTweakSetAlpha 10<CR>| tmap <silent> <A-n> <C-W>N:GvimTweakSetAlpha 10<CR>i
nnoremap <silent> <A-p> :GvimTweakSetAlpha -10<CR>| tmap <silent> <A-p> <C-W>N:GvimTweakSetAlpha i-10<CR>i
" ---------------------------------------}}}
" " Time & Tab Info" ----------------------{{{1
" 
" let g:zindex = 50
" function! DisplayPopupTime(...)" --------{{{2
" 	if empty(prop_type_get('time'))
" 		call prop_type_add('time', #{highlight: 'PopupTime'})
" 	endif
" 
" 	let text = printf('%s  %s  %s', printf('[Tab%s(%s)]', tabpagenr(), tabpagenr('$')), strftime('%A %d %B'), strftime('[%Hh%M]'))
" 	let text_length = len(text)
" 	call popup_create([#{text: text, props:[#{type: 'time', col:1, end_col:1+text_length}]}], #{time:20000, line:&lines+2, col:&columns + 1 - text_length, zindex:g:zindex})
" endfunction
" " ---------------------------------------}}}2
" augroup timedisplay
" 	au!
" 	autocmd VimEnter * call DisplayPopupTime() | let t = timer_start(20000, 'DisplayPopupTime', {'repeat':-1})
" 	autocmd TabLeave,TabEnter * let g:zindex+=1 | call DisplayPopupTime()
" augroup end
" 
" " ---------------------------------------}}}1
" " Pomodoro" -----------------------------{{{1
" function! DisplayTimer(t, hi, ...)"-----{{{2
" 	let milliseconds=eval(a:t)
" 	let seconds = milliseconds / 1000
" 	let minutes = seconds / 60
" 	let seconds = seconds % 60
" 	let minutes = minutes > 9 ? string(minutes) : '0'.string(minutes)
" 	let seconds = seconds > 9 ? string(seconds) : '0'.string(seconds)
" 	let content = printf('%sm%ss [%s]', minutes, seconds, g:cyclecount)
" 	let highlight_group = eval(a:hi)
" 	let g:zindex += 1
" 
" 	call popup_create( content, {  'time': 1000, 'highlight':highlight_group, 'border':[0,0,0,1], 'borderhighlight':repeat([highlight_group], 4), 'line': &lines-2, 'col': &columns - 11, 'zindex':g:zindex })
" 
" 	execute('let '.a:t.' -= 1000')
" endfunction
" "---------------------------------------}}}2
" function! StartCycles(...)"----------------{{{2
" 	let session_time_in_minutes = 25
" 	let break_time_in_minutes = 5
" 	let cycle_time_in_minutes = session_time_in_minutes + break_time_in_minutes
" 	let g:cyclecount = 0
" 
" 	call StartCycle(session_time_in_minutes, break_time_in_minutes)
" 	let l:timer = timer_start(cycle_time_in_minutes*60*1000, function('StartCycle', [session_time_in_minutes, break_time_in_minutes]), {'repeat': -1})
" endfunction
" "---------------------------------------}}}2
" function! StartCycle(dur1,dur2,...)"----{{{
" 	call StartSession(a:dur1)
" 	let l:timer = timer_start(a:dur1*60*1000, function('StartBreak', [a:dur2]))
" endfunction
" "---------------------------------------}}}
" function! StartSession(minutes, ...)"---{{{
" 	let mybuffers = GetMyFilesBuffers()
" 	if len(mybuffers) > 0 && len(mybuffers) %4 == 0
" 		call HideMyFiles(mybuffers)
" 	endif
" 	call ShowMyFiles()
" 
" 	let g:cyclecount += 1
" 	let g:pomodoro_session_timer_ms = a:minutes*60*1000 - 1000
"  " we repeat with 10 seconds margin; justification: we can only specify the <minimum> time before the function starts, so each second is potentially delayed
" 	let l:timer = timer_start(1000, function('DisplayTimer', ['g:pomodoro_session_timer_ms', "'csharpInterfaceName'"]), {'repeat': a:minutes * 60 - 1 - 10})
" 	call popup_create(printf('[%s]   ( `ω´)   Pomodoro session %d started!', strftime('%Hh%M'), g:cyclecount), { 'time': 60*1000, 'highlight':'Normal', 'border':[], 'borderhighlight':repeat(['csharpString'], 4), 'close': 'button' })
" 
" endfunction
" "---------------------------------------}}}
" function! StartBreak(minutes, ...)"-----{{{
" 	let mybuffers = GetMyFilesBuffers()
" 	if len(mybuffers) > 0 && len(mybuffers) %4 == 0
" 		call HideMyFiles(mybuffers)
" 	endif
" 	call ShowMyFiles()
" 	let g:pomodoro_break_timer_ms = a:minutes*60*1000 - 1000
" 	" we repeat with 10 seconds margin; justification: we can only specify the <minimum> time before the function starts, so each second is potentially delayed
" 	let l:timer = timer_start(1000, function('DisplayTimer', ['g:pomodoro_break_timer_ms', "'csharpKeyword'"]), {'repeat': a:minutes * 60 - 1 - 10})
" 	call popup_create(printf('[%s]   (*´∀`*)   Well done! End of the pomodoro session %d!', strftime('%Hh%M'), g:cyclecount), { 'time': 60*1000, 'highlight':'Normal', 'border':[], 'borderhighlight':repeat(['csharpClassName'], 4), 'close': 'button' })
" endfunction
" "---------------------------------------}}}
" augroup pomodoro
" 	au!
" 	autocmd VimEnter * call timer_start(2000, 'StartCycles')
" augroup end
" " ---------------------------------------}}}1
" Quotes" -------------------------------{{{1
function! GetQuote()
	let allquotes = readfile($desktop.'/my.quotes')
	let random_index =str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % len(allquotes)-1 
	return allquotes[random_index]
endfunction

command! Quote echomsg GetQuote()

nnoremap <Leader>Q :Quote<CR>
" ---------------------------------------}}}1
" File explorer (graphical)" ------------{{{1
" Tree"---------------------------------{{{2
function Tree(...)
	execute('read !tree.exe '.join(a:000, ' '))
endfunction
command! -nargs=* Tree call Tree(<f-args>)
"---------------------------------------}}}2
" Dirvish"------------------------------{{{2
nmap <Leader>e <Plug>(dirvish_up)
augroup my_dirvish
	au!
	autocmd FileType dirvish let b:vifm_mappings=1 | lcd %:p:h | mark L
	autocmd FileType dirvish nmap <buffer> <LocalLeader>m :let b:vifm_mappings = (b:vifm_mappings ? 0 : 1)<CR>
	autocmd FileType dirvish nmap <buffer> <expr> l b:vifm_mappings ? 'i' : 'l'
	autocmd FileType dirvish nmap <buffer> <expr> h b:vifm_mappings ? "\<Leader>e" : 'h'
	autocmd FileType dirvish nnoremap <buffer> <LocalLeader>q :Shdo  {} {}<Left><Left><Left><Left><Left><Left>
augroup end
"---------------------------------------}}}2

" ---------------------------------------}}}1
" Web Browsing" -------------------------{{{1
function! WeatherInNewTab()" ------------{{{2
	tabnew
	let buf = term_start([&shell, '/k', 'chcp 65001 | start /wait /b curl http://wttr.in'], {'exit_cb': {... -> execute('tabclose')}, 'curwin':1})
endfunction
" ---------------------------------------}}}2
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
" ---------------------------------------}}}2
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

" ---------------------------------------}}}1
" Snippets" -----------------------------{{{1
augroup ultisnips
	au!
	autocmd User UltiSnipsEnterFirstSnippet mark '
augroup end

let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=[$desktop . "/tools/vim/pack/plugins/start/vim-snippets/ultisnips", $desktop.'/snippets']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

nnoremap <Leader>u :UltiSnipsEdit!<CR>G
" ---------------------------------------}}}1
" Git" ----------------------------------{{{1
nnoremap <silent> <Leader>G :tab G<CR>
" ---------------------------------------}}}1
" Diagrams"-----------------------------{{{1
function! InitNewDiagram(filename)"-------------{{{2
	execute(printf('tabedit %s.bob',a:filename))
	read my.legend
 call feedkeys("ggOnode\<Tab>")
endfunction
"---------------------------------------}}}2
command! -nargs=1 -bar NewDiagram lcd $desktop/diagrams | call InitNewDiagram(<f-args>)
nnoremap <Leader>D :NewDiagram 
function! RegisterBoxLineTypes()"-------{{{2
	"empty box line
	let @e=@"[0] . repeat(' ', len(@")-2). @"[len(@")-1]

	"border box line
	let @b="'" . repeat('-', len(@")-2). "'"

	"limit box line (second bordere type)
	let @l="'" . repeat('~', len(@")-2). "'"
endfunction
"---------------------------------------}}}2
augroup mydiagrams
	autocmd!
	autocmd BufRead,BufWinEnter *.bob silent setlocal filetype=bob fileformat=unix 
 autocmd BufRead,BufWinEnter *.bob silent set virtualedit=all
	autocmd BufLeave *.bob silent set virtualedit=
	autocmd BufRead,BufWinEnter *.bob silent vnoremap <buffer> p p 
	autocmd BufRead,BufWinEnter *.bob silent vnoremap <buffer> vv F\|<C-v>,
	autocmd BufRead,BufWinEnter *.bob silent vnoremap <buffer> vV F\!<C-v>,
	autocmd BufRead,BufWinEnter *.bob silent nnoremap <buffer> H r-h
	autocmd BufRead,BufWinEnter *.bob silent nnoremap <buffer> J r\|j
	autocmd BufRead,BufWinEnter *.bob silent nnoremap <buffer> K r\|k
	autocmd BufRead,BufWinEnter *.bob silent nnoremap <buffer> L r-l
	autocmd BufRead,BufWinEnter *.bob silent nnoremap <buffer> <silent> <Leader>w :exec('silent !svgbob "%:p" -o "%:p:r.svg" --background \#575b61 --fill-color transparent') \| call OpenWebUrl('', printf('%s.svg', expand('%:p:r')))<CR>
	autocmd TextYankPost *.bob call RegisterBoxLineTypes()
augroup END
"---------------------------------------}}}1
" Brackets"-----------------------------{{{1
function! SmartBracketPowerActivate()
	let brackets = [['(', ')'], ['{', '}'], ['[', ']'], ["'", "'"], ['"', '"'], ["'", "'"], ['`', '`'], ['<', '>']]

	let last2chars = substitute(getline('.')[:col('.')-1], '\s', '', 'g')[-2:]
	let pairindex = index(map(copy(brackets), {_,itm -> itm[0].itm[1]}), last2chars)
	if pairindex >= 0
		return "\<Left>\<CR>\<CR>\<Up>\<Tab>"
	endif

	let lastchar = last2chars[1]
	let charindex = index(map(copy(brackets), {_,itm -> itm[0]}), lastchar)
	if charindex >= 0
		let matchingbracket = brackets[charindex][1] 
		if matchingbracket == '}'
			let matchingbracket = "\<Space>\<Space>}\<Left>"
		endif

		return matchingbracket . "\<Left>"
	endif
endfunction
inoremap <expr><silent> <C-O> SmartBracketPowerActivate()
"---------------------------------------}}}1



" Specific Workflows:
" cs(c#)" -------------------------------{{{1
let g:OmniSharp_start_server = 0
let g:OmniSharp_server_stdio = 1
let g:ale_linters = { 'cs': ['OmniSharp'] }
let g:OmniSharp_popup = 0
let g:OmniSharp_loglevel = 'debug'
let g:OmniSharp_highlight_types = 3
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_want_snippet=1
let g:OmniSharp_diagnostic_showid = 1
augroup lightline_integration
  autocmd!
  autocmd User OmniSharpStarted,OmniSharpReady,OmniSharpStopped call lightline#update()
augroup END

function! CSharpBuild()
	let omnisharp_host = getbufvar(bufnr('%'), 'OmniSharp_host')
	if empty(omnisharp_host) || !get(omnisharp_host, 'initialized')
		echomsg "Omnisharp server isn't loaded. Please load Omnisharp server with :OmniSharpStartServer."
		return
endif

	set cmdheight=4
	setlocal errorformat=%f(%l\\,%c):\ error\ CS%n:\ %m\ [%.%#
	setlocal errorformat+=%-G%.%#
	setlocal makeprg=dotnet\ build\ /p:GenerateFullPaths=true\ /clp:NoSummary
	call LcdToSlnOrCsproj()
	silent make

	if QuickFixWindowIsOpen()
		set cmdheight=1
		return
	endif

	setlocal errorformat=%A\ %#X\ %.%#
	setlocal errorformat+=%Z\ %#X\ %.%#
	setlocal errorformat+=%-C\ %#Arborescence%.%#
	setlocal errorformat+=%C\ %#at%.%#\ in\ %f:line\ %l
	setlocal errorformat+=%-C%.%#\ Message\ d'erreur%.%#
	setlocal errorformat+=%-C%.%#\ (pos\ %.%#
	setlocal errorformat+=%C\ %#%m\ Failure
	setlocal errorformat+=%C\ %#%m
	setlocal errorformat+=%-G%.%#
	setlocal makeprg=dotnet\ test\ --no-build\ --nologo
	call LcdToSlnOrCsproj()
	silent make
	set cmdheight=1
endfunction

augroup csharpfiles
	au!
	autocmd FileType cs nnoremap <silent> <LocalLeader>m :call CSharpBuild()<CR>
	autocmd FileType cs nmap <buffer> zk <Plug>(omnisharp_navigate_up)
	autocmd FileType cs nmap <buffer> zj <Plug>(omnisharp_navigate_down)
	autocmd FileType cs nmap <buffer> z! :BLines public\\|private\\|protected<CR>
	autocmd FileType cs nmap <buffer> gd <Plug>(omnisharp_go_to_definition)
	autocmd FileType cs nmap <buffer> gD <Plug>(omnisharp_preview_definition)
	autocmd FileType cs nmap <buffer> <LocalLeader>i <Plug>(omnisharp_find_implementations)
	autocmd FileType cs nmap <buffer> <LocalLeader>I <Plug>(omnisharp_preview_implementations)
	autocmd FileType cs nmap <buffer> <LocalLeader>s <Plug>(omnisharp_find_symbol)
	autocmd FileType cs nmap <buffer> <LocalLeader>u <Plug>(omnisharp_find_usages)
	autocmd FileType cs nmap <buffer> <LocalLeader>l <Plug>(omnisharp_find_members)
	autocmd FileType cs nmap <buffer> <LocalLeader>t <Plug>(omnisharp_type_lookup)
	autocmd FileType cs nmap <buffer> <LocalLeader>d <Plug>(omnisharp_documentation)
	autocmd FileType cs nmap <buffer> <LocalLeader>c <Plug>(omnisharp_global_code_check)
	autocmd FileType cs nmap <buffer> <LocalLeader>q <Plug>(omnisharp_code_actions)
	autocmd FileType cs xmap <buffer> <LocalLeader>q <Plug>(omnisharp_code_actions)
	autocmd FileType cs nmap <buffer> <LocalLeader>r <Plug>(omnisharp_rename)
	autocmd FileType cs nmap <buffer> <LocalLeader>= <Plug>(omnisharp_code_format)
	autocmd FileType cs nmap <buffer> <LocalLeader>f <Plug>(omnisharp_fix_usings)
	autocmd FileType cs nmap <buffer> <LocalLeader>R <Plug>(omnisharp_restart_server)
augroup end

"
"	\ 'ExcludedCode': '', 	
"	\ 'ModuleName': '', 	
"	\ 'WhiteSpace': '', 	
"	\ 'Text': '', 	
"	\ 'RegexAnchor': '', 	
"	\ 'RegexQuantifier': '', 	
"	\ 'RegexGrouping': '', 	
"	\ 'RegexAlternation': '', 	
"	\ 'RegexText': '', 	
"	\ 'RegexSelfEscapedCharacter': '',
"	\ 'RegexOtherEscape': ''
"	\ 'RegexCharacterClass': '' 	
"	\ 'OperatorOverloaded': '', 	
"	\ 'PreprocessorKeyword': '', 	
"	\ 'PreprocessorText': '', 	
let g:OmniSharp_highlight_groups = {
	\ 'Comment': 'Comment', 	
	\ 'Identifier': 'Identifier',
	\ 'Keyword': 'Keyword', 	
	\ 'ControlKeyword': 'String', 	
	\ 'NumericLiteral': 'Number', 	
	\ 'Operator': 'Identifier', 	
	\ 'StringLiteral': 'String', 	
	\ 'StaticSymbol': 'Identifier',
	\ 'Punctuation': 'Identifier', 	
	\ 'VerbatimStringLiteral': 'String', 	
	\ 'StringEscapeCharacter': 'Special', 	
	\ 'ClassName': 'Pmenu',
	\ 'DelegateName': 'Identifier',
	\ 'EnumName': 'Structure',
	\ 'InterfaceName': 'Character',
	\ 'StructName': 'Float',
	\ 'TypeParameterName': 'Type',
	\ 'FieldName': 'Identifier',
	\ 'EnumMemberName': 'Structure',
	\ 'ConstantName': 'Constant',
	\ 'LocalName': 'Identifier',
	\ 'ParameterName': 'Constant',
	\ 'MethodName': 'Identifier',
	\ 'ExtensionMethodName': 'Identifier',
	\ 'PropertyName': 'Identifier',
	\ 'EventName': 'Identifier',
	\ 'NamespaceName': 'Identifier',
	\ 'LabelName': 'Label',
	\ 'XmlDocCommentAttributeName': 'Comment', 	
	\ 'XmlDocCommentAttributeQuotes': 'Comment', 	
	\ 'XmlDocCommentAttributeValue': 'Comment', 	
	\ 'XmlDocCommentCDataSection': 'Comment', 	
	\ 'XmlDocCommentComment': 'Comment', 	
	\ 'XmlDocCommentDelimiter': 'Comment', 	
	\ 'XmlDocCommentEntityReference': 'Comment', 	
	\ 'XmlDocCommentName': 'Comment', 	
	\ 'XmlDocCommentProcessingInstruction': 'Comment', 	
	\ 'XmlDocCommentText': 'Comment', 	
	\ 'XmlLiteralAttributeName': 'Comment', 	
	\ 'XmlLiteralAttributeQuotes': 'Comment', 	
	\ 'XmlLiteralAttributeValue': 'Comment', 	
	\ 'XmlLiteralCDataSection': 'Comment', 	
	\ 'XmlLiteralComment': 'Comment', 	
	\ 'XmlLiteralDelimiter': 'Comment', 	
	\ 'XmlLiteralEmbeddedExpression': 'Comment', 	
	\ 'XmlLiteralEntityReference': 'Comment', 	
	\ 'XmlLiteralName': 'Comment', 	
	\ 'XmlLiteralProcessingInstruction': 'Comment', 	
	\ 'XmlLiteralText': 'Comment', 	
	\ 'RegexComment': 'Comment' 	
\}
let g:OmniSharp_diagnostic_exclude_paths = [
\ 'obj\\',
\ '[Tt]emp\\',
\ '\.nuget\\',
\ '\<AssemblyInfo\.cs\>'
\]
" 	"---------------------------------------}}}1
" dirvish

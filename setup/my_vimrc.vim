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
	call minpac#add('jremmen/vim-ripgrep')
	call minpac#add('itchyny/lightline.vim')
	call minpac#add('itchyny/vim-gitbranch')
	call minpac#add('OmniSharp/omnisharp-vim')

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

	call minpac#add('Melandel/DrawIt')
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
" ---------------------------------------}}}1
" Tabs and Indentation" -----------------{{{
set smartindent
set tabstop=1
set shiftwidth=1

nnoremap > >>
nnoremap < <<

command! -bar Spaces2Tabs set noet ts=2 |%retab!
" ---------------------------------------}}}
" Leader keys" --------------------------{{{
let mapleader = 's'
let maplocalleader = 'q'
" ---------------------------------------}}}
" Local Current Directories" ------------{{{
function! LcdToGitRoot()"---------------{{{2
	let gitrootdir = fnamemodify(gitbranch#dir(expand('%:p')), ':h')

	echo printf('Current directory path set to: %s', gitrootdir)
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
command LG call LcdToGitRoot()

augroup lcd
	au!
	autocmd BufRead,WinEnter * silent lcd $desktop | silent call LcdToGitRoot() | silent call LcdToSlnOrCsproj()
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
nnoremap <Leader>o mW:tabnew<CR>`W:silent call ToggleMyFiles()<CR>
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
function! FoldLevel()"-------------------{{{2
	return printf('FoldLevel:%d', &foldlevel)
endfunction
"----------------------------------------}}}2
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
function! MyFilePathIndicator() abort" --{{{2
	let path = GitRootAndCwd()

	let current_directory = getcwd()
	if stridx(path, fnamemodify(current_directory, ':t')) == -1
		let path .= printf(' %s/%s', fnamemodify(current_directory, ':h:t'), fnamemodify(current_directory, ':t'))
	endif
	
	let path .= ' '.GitFilePath()

	return substitute(path, fnamemodify(current_directory, ':t') , '(&)', '')
endfunction
" ---------------------------------------}}}2
function! GitFilePath()" ----------------{{{2
	let file_path_absolute = expand('%:p')
	let git_path_absolute = fnamemodify(gitbranch#dir(file_path_absolute), ':h')
	
	return git_path_absolute == '.' ? expand('%') : file_path_absolute[len(git_path_absolute)+1:]
endfunction
" ---------------------------------------}}}2
function! GitRootAndCwd()" --------------{{{2
	let file_path_absolute = expand('%:p')
	let git_path_absolute = fnamemodify(gitbranch#dir(file_path_absolute), ':h')

	return git_path_absolute == '.' ? '' :	printf('%s[%s/%s]', gitbranch#name(), fnamemodify(git_path_absolute, ':h:t'), fnamemodify(git_path_absolute, ':t')) 
endfunction
" ---------------------------------------}}}2

let g:lightline = {
	\ 'colorscheme': 'empower',
	\ 'component_function': { 'filesize_and_rows': 'FileSizeAndRows', 'mypathinfo': 'MyFilePathIndicator', 'gitpath': 'GitFilePath', 'gitroot': 'GitRootAndCwd', 'fl': 'FoldLevel' },
	\ 'active':   {   'left':  [ [ 'mode', 'fl', 'paste', 'readonly', 'modified' ], [ 'mypathinfo' ] ], 'right': [ [ 'filesize_and_rows' ]               ] },
	\ 'inactive': {   'left':  [ [ 'gitroot' ]                                                       ], 'right': [ [ 'gitpath', 'modified', 'readonly' ] ] }
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

function! EnterSubdir()"-----------------{{{2
    call feedkeys("\<Down>", 't')
    return ''
endfunction
"----------------------------------------}}}2
cnoremap <expr> j (wildmenumode() == 1) ? EnterSubdir() : "j"

function! MoveUpIntoParentdir()"---------{{{2
    call feedkeys("\<Up>", 't')
    return ''
endfunction
"----------------------------------------}}}2
cnoremap <expr> k (wildmenumode() == 1) ? MoveUpIntoParentdir() : "k"

cnoremap <expr> h (wildmenumode() == 1) ? "\<s-Tab>" : "h"
cnoremap <expr> l (wildmenumode() == 1) ? "\<Tab>"   : "l"

"cnoremap <expr> <Esc> (wildmenumode() == 1) ? " \<BS>"   : "\<Esc>"
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
nnoremap <Leader>g :Agrep --no-ignore-parent  <C-R>=fnamemodify('.', ':p')<CR><Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>
vnoremap <Leader>g "vy:let cmd = printf('Agrep --no-ignore-parent %s %s',escape(@v,'\\#%'),fnamemodify('.', ':p'))\|echo cmd\|call histadd('cmd',cmd)\|execute cmd<CR>
"----------------------------------------}}}1
" Registers" ----------------------------{{{1
command! ClearRegisters for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor
"----------------------------------------}}}1
" Terminal" -----------------------------{{{1
set termwinsize=12*0
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
function! MoveToPreviousFoldBeginning()
	keepjumps normal! zk
	if CursorIsInClosedFold()
		return
	else
		keepjumps normal! [z
	endif
endfunction

set foldmethod=expr
set foldexpr=MyFoldExpr()
set foldtext=MyFoldText()

command! -bar -range FoldCreate <line1>,<line2>call MyFoldCreate()

nnoremap <silent> <Space> :silent call ToggleUpdatedFoldLevel()<CR>
nnoremap <silent> zf <S-V>:FoldCreate<CR>
vnoremap <silent> zf :FoldCreate<CR>
nnoremap <silent> zj :keepjumps normal! zj<CR>
nnoremap <silent> zk :silent call MoveToPreviousFoldBeginning()<CR>
nnoremap <silent> z{ [z
nnoremap <silent> z} ]z

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
"----------------------------------------}}}1
" Autocompletion (Insert Mode)" ---------{{{1

" <Enter> confirms selection
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" <Esc> cancels popup menu
inoremap <expr> <Esc> pumvisible() ? "\<C-E>" : "\<Esc>"

" <C-N> for omnicompletion, <C-P> for context completion
inoremap <expr> <C-N> pumvisible() ? "\<C-N>" : (&omnifunc == '') ? "\<C-N>" : "\<C-X>\<C-O>"

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
	return filter(tabpagebuflist(), {idx, itm -> bufname(itm) =~ 'my\.'})
endfunction
function! ToggleMyFiles()" --------------{{{2
	let mybuffers = GetMyFilesBuffers()
if len(mybuffers) >= 3
		call HideMyFiles(mybuffers)
	else
		call ShowMyFiles()
	endif
endfunction
" ---------------------------------------}}}2
function! ShowMyFiles()"----------------{{{2
		mark V
		let originalWinNr = winnr()
		vnew $desktop/my.day | normal! Gzx[zkzt
		wincmd L
		new $desktop/my.happyplace |normal! Gzx[zkzt 
		new $desktop/my.todo
		new $desktop/my.notabene
		vertical resize 50
		setlocal winfixwidth
		execute(originalWinNr.'wincmd w')
		normal! `V
		delmarks V
endfunction
"---------------------------------------}}}2
function! HideMyFiles(...)"----------------{{{2
	let mybuffers = (a:0 > 0) ? a:1 :filter(tabpagebuflist(), {idx, itm -> bufname(itm) =~ 'my\.'}) 

	for bufid in mybuffers
		call win_gotoid(bufwinid(bufid)) | write | quit
	endfor
endfunction
"---------------------------------------}}}2
command! ShowMyFiles silent call ShowMyFiles()
command! HideMyFiles silent call HideMyFiles()
command! ToggleMyFiles silent call ToggleMyFiles()

nnoremap <Leader>m :ToggleMyFiles<CR>

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
nnoremap <silent> <A-n> :GvimTweakSetAlpha 10<CR>
nnoremap <silent> <A-p> :GvimTweakSetAlpha -10<CR>
" ---------------------------------------}}}
" Time & Tab Info" ----------------------{{{1

let g:zindex = 50
function! DisplayPopupTime(...)" --------{{{2
	if empty(prop_type_get('time'))
		call prop_type_add('time', #{highlight: 'PopupTime'})
	endif

	let text = printf('%s  %s  %s', printf('[Tab%s(%s)]', tabpagenr(), tabpagenr('$')), strftime('%A %d %B'), strftime('[%Hh%M]'))
	let text_length = len(text)
	call popup_create([#{text: text, props:[#{type: 'time', col:1, end_col:1+text_length}]}], #{time:20000, line:&lines+2, col:&columns + 1 - text_length, zindex:g:zindex})
endfunction
" ---------------------------------------}}}2
augroup timedisplay
	au!
	autocmd VimEnter * call DisplayPopupTime() | let t = timer_start(20000, 'DisplayPopupTime', {'repeat':-1})
	autocmd TabLeave,TabEnter * let g:zindex+=1 | call DisplayPopupTime()
augroup end

" ---------------------------------------}}}1
" Pomodoro" -----------------------------{{{1
function! DisplayTimer(t, hi, ...)"-----{{{2
	let milliseconds=eval(a:t)
	let seconds = milliseconds / 1000
	let minutes = seconds / 60
	let seconds = seconds % 60
	let minutes = minutes > 9 ? string(minutes) : '0'.string(minutes)
	let seconds = seconds > 9 ? string(seconds) : '0'.string(seconds)
	let content = printf('%sm%ss [%s]', minutes, seconds, g:cyclecount)
	let highlight_group = eval(a:hi)
	let g:zindex += 1

	call popup_create( content, {  'time': 1000, 'highlight':highlight_group, 'border':[0,0,0,1], 'borderhighlight':repeat([highlight_group], 4), 'line': &lines-2, 'col': &columns - 11, 'zindex':g:zindex })

	execute('let '.a:t.' -= 1000')
endfunction
"---------------------------------------}}}2
function! StartCycles()"----------------{{{2
	let session_time_in_minutes = 25
	let break_time_in_minutes = 5
	let cycle_time_in_minutes = session_time_in_minutes + break_time_in_minutes
	let g:cyclecount = 0

	call StartCycle(session_time_in_minutes, break_time_in_minutes)
	let l:timer = timer_start(cycle_time_in_minutes*60*1000, function('StartCycle', [session_time_in_minutes, break_time_in_minutes]), {'repeat': -1})
endfunction
"---------------------------------------}}}2
function! StartCycle(dur1,dur2,...)"----{{{
	call StartSession(a:dur1)
	let l:timer = timer_start(a:dur1*60*1000, function('StartBreak', [a:dur2]))
endfunction
"---------------------------------------}}}
function! StartSession(minutes, ...)"---{{{
	let mybuffers = GetMyFilesBuffers()
	if len(mybuffers) >= 3
		call HideMyFiles(mybuffers)
	endif
	call ShowMyFiles()

	let g:cyclecount += 1
	let g:pomodoro_session_timer_ms = a:minutes*60*1000 - 1000
 " we repeat with 10 seconds margin; justification: we can only specify the <minimum> time before the function starts, so each second is potentially delayed
	let l:timer = timer_start(1000, function('DisplayTimer', ['g:pomodoro_session_timer_ms', "'csharpInterfaceName'"]), {'repeat': a:minutes * 60 - 1 - 10})
	call popup_create(printf('[%s]   ( `ω´)   Pomodoro session %d started!', strftime('%Hh%M'), g:cyclecount), { 'time': 60*1000, 'highlight':'Normal', 'border':[], 'borderhighlight':repeat(['csharpString'], 4), 'close': 'button' })

endfunction
"---------------------------------------}}}
function! StartBreak(minutes, ...)"-----{{{
	let mybuffers = GetMyFilesBuffers()
	if len(mybuffers) >= 3
		call HideMyFiles(mybuffers)
	endif
	call ShowMyFiles()
	let g:pomodoro_break_timer_ms = a:minutes*60*1000 - 1000
	" we repeat with 10 seconds margin; justification: we can only specify the <minimum> time before the function starts, so each second is potentially delayed
	let l:timer = timer_start(1000, function('DisplayTimer', ['g:pomodoro_break_timer_ms', "'csharpKeyword'"]), {'repeat': a:minutes * 60 - 1 - 10})
	call popup_create(printf('[%s]   (*´∀`*)   Well done! End of the pomodoro session %d!', strftime('%Hh%M'), g:cyclecount), { 'time': 60*1000, 'highlight':'Normal', 'border':[], 'borderhighlight':repeat(['csharpClassName'], 4), 'close': 'button' })
endfunction
"---------------------------------------}}}
augroup pomodoro
	au!
	autocmd VimEnter * call StartCycles()
augroup end
" ---------------------------------------}}}1
" Quotes" -------------------------------{{{1
function! GetQuote()
	let allquotes = readfile($desktop.'/my.quotes')
	let random_index =str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % len(allquotes)-1 
	return allquotes[random_index]
endfunction

command! Quote echo GetQuote()

nnoremap <Leader>Q :Quote<CR>
" ---------------------------------------}}}1
" File explorer (graphical)" ------------{{{1

let g:vifm_replace_netrw = 1

function! BuildVifmMarkCommandForFilePath(mark_label, file_path)
	let file_folder_path = substitute(fnamemodify(a:file_path, ':h'), '\\', '/', 'g')
	let file_name = substitute(fnamemodify(a:file_path, ':t'), '\\', '/', 'g')

	return '"mark ' . a:mark_label . ' ' . file_folder_path . ' ' . file_name . '"'
endfunction

let g:vifm_exec_args = ' +"fileviewer *.cs,*.csproj bat --tabs 4 --color always --wrap never --pager never --map-syntax csproj:xml -p %c %p"'
let g:vifm_exec_args.= ' +"windo set number relativenumber numberwidth=1"'
let g:vifm_exec_args.= ' +"set runexec"'
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
" Smart Brackets and quotes"------------{{{1
function! DeclareBracketContent()"------{{{2
	let g:declare_bracket_content = 1
	normal! lv
endfunc
"---------------------------------------}}}2
function! CloseBracket(open)"-----------{{{2
	if !exists('g:declare_bracket_content') || g:declare_bracket_content == 0
		execute("normal! \<CR>")
		return
	endif

	let g:declare_bracket_content = 0
	let close = ''
	if a:open == '('
		let close = ')'
	elseif a:open == '{'
		let close = '}'
	elseif a:open == '['
		let close = ']'
	elseif a:open == '"'
		let close = '"'
	elseif a:open == "'"
		let close = "'"
	elseif a:open == '`'
		let close = '`'
	else
		return
	endif

	execute("normal! gvo\<Esc>a".close)
endfunc
"---------------------------------------}}}2
inoremap <silent> ^v <Esc>:call DeclareBracketContent()<CR>
vnoremap <silent> <CR> om'h<Esc>:call CloseBracket(CurrentCharacter())<CR>
"---------------------------------------}}}1
" Diagrams"-----------------------------{{{1
augroup mydiagrams
	autocmd!
	autocmd BufWinEnter *.bob silent set fileformat=unix
	autocmd BufWritePost *.bob silent exec('!svgbob "%:p" -o "%:p:r.svg"') | call OpenWebUrl(substitute(printf('%s.svg', expand('%:p:r')), '/', '\\', 'g'))
augroup END

nnoremap <Leader>D :20new \| lcd $desktop/diagrams \| normal! yy18pgg<CR>:DrawIt<CR>
"---------------------------------------}}}1


" Specific Workflows:
" cs(c#)" -------------------------------{{{1
function! CsFoldExpr()" -----------------{{{2
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
" ---------------------------------------}}}2
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
" ---------------------------------------}}}2
function! CsFoldText()" -----------------{{{2
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
"  --------------------------------------}}}2
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
		"autocmd BufEnter *.cs setlocal foldmethod=expr foldexpr=CsFoldExpr() foldtext=CsFoldText()
		autocmd BufEnter *.cs setlocal errorformat=\ %#%f(%l\\\,%c):\ %m
		autocmd BufEnter *.cs setlocal makeprg=dotnet\ build\ /p:GenerateFullPaths=true
		autocmd BufEnter *.cs nnoremap <LocalLeader>M :!dotnet run<CR>
		autocmd BufWritePost *.cs OmniSharpFixUsings | OmniSharpCodeFormat
		autocmd FileType cs nnoremap <buffer> zk :OmniSharpNavigateUp<CR>zz
		autocmd FileType cs nnoremap <buffer> zj :OmniSharpNavigateDown<CR>zz
		autocmd FileType cs nnoremap <buffer> z! :BLines public\\|private\\|protected<CR>
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

	"---------------------------------------}}}1

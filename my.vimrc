" General:
" Variables-------------------------------------------{{{
let $v = $VIM . '/_vimrc'
let $p = $VIM . '/pack/plugins/start/'
let $c = $VIM . '/pack/plugins/start/vim-empower/colors/empower.vim'
let $n = $HOME . '/Desktop/my.notes'
let $pomodoro = $HOME . '/Desktop/my.pomodoro'
"----------------------------------------------------}}}
" General-------------------------------------------{{{
syntax on
filetype plugin indent on
language messages English_United states
set novisualbell
set langmenu=en_US.UTF-8
set encoding=utf8
set scrolloff=0
set backspace=indent,eol,start

" Backup files
set swapfile
set directory=$HOME/Desktop/tmp/vim
set backup
set backupdir=$HOME/Desktop/tmp/vim
set undofile
set undodir=$HOME/Desktop/tmp/vim

set cursorline

set relativenumber
set number

" Indentation & Tabs
set smartindent
set tabstop=4
set shiftwidth=4
nnoremap > >>
nnoremap < <<

" Leader keys
noremap q <Nop>
let mapleader = "s"
let maplocalleader = "q"

" Command line mode
" This is relevant because all custom commands start with an upper case
nnoremap / :

" Matchit plugin (%)
packadd! matchit

" GVim specific
if has("gui_running")
	set guioptions-=m  "menu bar
	set guioptions-=T  "toolbar
	set guioptions-=t  "toolbar
	set guioptions-=r  "scrollbar
	set guioptions-=L  "scrollbar
	set guifont=consolas:h11
	set termwintype=conpty
	nnoremap ° :call libcallnr("gvimfullscreen_64.dll", "ToggleFullScreen", 0)<CR>
	au GUIEnter * call libcallnr("gvimfullscreen_64.dll", "ToggleFullScreen", 0)
endif
"----------------------------------------------------}}}
" Wrapping-------------------------------------------{{{

nnoremap <Leader>W :set wrap!<CR>

"----------------------------------------------------}}}
" FileTypes-------------------------------------------{{{

" FileTypeDetect-------------------------------------------{{{
augroup filetypedetect
  	au! BufRead,BufNewFile *.pomodoro	setfiletype pomodoro
  	au! BufRead,BufNewFile *.notes		setfiletype notes
augroup END
"----------------------------------------------------}}}
" Vim-------------------------------------------{{{
augroup vimfiles
	au!
	au FileType vim setlocal foldmethod=marker
augroup END
"----------------------------------------------------}}}
" Pomodoro file-------------------------------------------{{{
function! PomodoroFolds()"-------------------------------------------{{{
	let thisline = getline(v:lnum)

	if match(thisline, '^\s*$') >= 0
		return "0"
	endif

	if match(thisline, '^\S') >= 0
		return ">1"
	endif

	return "="
endfunction
"----------------------------------------------------}}}
augroup pomodorofiles
	autocmd!
	au FileType pomodoro setlocal foldmethod=expr
	au FileType pomodoro setlocal foldexpr=PomodoroFolds()
	au FileType pomodoro setlocal foldtext=foldtext()
augroup end
"----------------------------------------------------}}}
" Notes file-------------------------------------------{{{
augroup notesfiles
	autocmd!
	au FileType notes setlocal foldmethod=marker
augroup end
"----------------------------------------------------}}}
" C#-------------------------------------------{{{

" Plugin: omnisharp-vim-------------------------------------------{{{
sign define OmniSharpCodeActions text=💡
let g:OmniSharp_start_without_solution = 1
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_highlight_types = 2
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_want_snippet=1
let g:omnicomplete_fetch_full_documentation = 1
let g:OmniSharp_highlight_debug = 1
let g:OmniSharp_diagnostic_overrides = { 'CS1717': {'type': 'None'}, 'CS9019': {'type': 'None'} }
" Highlight groups (omnisharp 'kinds')-------------------------------------------{{{
let g:OmniSharp_highlight_groups = {
\ 'csharpKeyword':				[ 'keyword' ],
\ 'csharpNamespaceName':		  [ 'namespace name' ],
\ 'csharpPunctuation':			[ 'punctuation' ],
\ 'csharpOperator':			   [ 'operator' ],
\ 'csharpInterfaceName':		  [ 'interface name' ],
\ 'csharpStructName':			 [ 'struct name' ],
\ 'csharpEnumName':			   [ 'enum name' ],
\ 'csharpEnumMemberName':		 [ 'enum member name' ],
\ 'csharpClassName':			  [ 'class name' ],
\ 'csharpStaticSymbol':		   [ 'static symbol' ],
\ 'csharpFieldName':			  [ 'field name' ],
\ 'csharpPropertyName':		   [ 'property name' ],
\ 'csharpMethodName':			 [ 'method name' ],
\ 'csharpParameterName':		  [ 'parameter name' ],
\ 'csharpLocalName':			  [ 'local name' ],
\ 'csharpKeywordControl':		 [ 'keyword - control' ],
\ 'csharpString':				 [ 'string' ],
\ 'csharpNumber':				 [ 'number' ],
\ 'csharpConstantName':		   [ 'constant name' ],
\ 'csharpIdentifier':			 [ 'identifier' ],
\ 'csharpExtensionMethodName':	[ 'extension method name' ],
\ 'csharpComment':				[ 'comment' ],
\ 'csharpXmlDocCommentName':	  [ 'xml doc comment - name' ],
\ 'csharpXmlDocCommentDelimiter': [ 'xml doc comment - delimiter' ],
\ 'csharpXmlDocCommentText':	  [ 'xml doc comment - text' ]
\ }
"----------------------------------------------------}}}
"----------------------------------------------------}}}

function! CSharpFolds()"-------------------------------------------{{{
	let thisline = getline(v:lnum)

	if thisline ==# ""
		return "="
	elseif match(thisline, '^\t\t}$') >= 0
		return "<1"
	elseif match(thisline, '\t\t{$') >= 0
		return "1"
	elseif match(thisline, '^\t\t\t') >= 0
		return "1"
	elseif match(thisline, '^\t\t') >= 0
		return ">1"
	else
		return "0"
endfunction
"----------------------------------------------------}}}
function! CSharpFolds2()"-------------------------------------------{{{
	let thisline = getline(v:lnum)

	if indent(v:lnum) < 8
		return '='
	endif

	let previousline = getline(v:lnum-1)

	if previousline =~ '^\s\+\['
		return '='
	endif

	if thisline =~ '^\s\+\['
		return 'a1'
	endif

	if thisline =~ '^\s\+{$'
		" Open bracket by itself

		" the previous line started the folding
		return '='
	endif

	if thisline =~ '{$'
		" Open bracket preceded by text
		return 'a1'
	endif

	if thisline =~ '}$'
		" Closing bracet by itself
		return 's1'
	endif

	let nextline = getline(v:lnum+1)
	if indent(v:lnum+1) >= 8 && getline(v:lnum+1) =~ '^\s\+{$'
		return 'a1'
	endif

	return '='
endfunction
"----------------------------------------------------}}}
function! CSharpFoldText()"-------------------------------------------{{{
	let titleLineNr = v:foldstart
	let line = getline(titleLineNr)

	while (match(line, '\v^\s+([|\<)') >= 0 && titleLineNr < v:foldend)
		let titleLineNr = titleLineNr + 1
		let line = getline(titleLineNr)
	endwhile

	let ts = repeat(' ',&tabstop)
	let line = substitute(line, '\t', ts, 'g')
	"let foldsize = v:foldend - v:foldstart + 1
	let foldsize = v:foldend - titleLineNr - 1
	return line . ' [' . foldsize . ' line' . (foldsize > 1 ? 's' : '') . ']'
endfunction
"----------------------------------------------------}}}
function! OSCountCodeActions() abort"-------------------------------------------{{{
  if bufname('%') ==# '' || OmniSharp#FugitiveCheck() | return | endif
  if !OmniSharp#IsServerRunning() | return | endif
  let opts = {
  \ 'CallbackCount': function('CBReturnCount'),
  \ 'CallbackCleanup': {-> execute('sign unplace 99')}
  \}
  call OmniSharp#CountCodeActions(opts)
endfunction

function! CBReturnCount(count) abort
  if a:count
	let l = getpos('.')[1]
	let f = expand('%:p')
	execute ':sign place 99 line='.l.' name=OmniSharpCodeActions file='.f
  endif
endfunction
"----------------------------------------------------}}}
augroup csharpfiles
	au!
	autocmd FileType cs setlocal foldmethod=expr
	autocmd FileType cs setlocal foldexpr=CSharpFolds2()
	autocmd FileType cs setlocal foldtext=CSharpFoldText()
	autocmd FileType cs setlocal foldminlines=2

	autocmd FileType cs setlocal errorformat=\ %#%f(%l\\\,%c):\ %m
	autocmd FileType cs setlocal makeprg=dotnet\ build
	autocmd FileType cs nnoremap <LocalLeader>M :!dotnet run<CR>
	autocmd CursorHold *.cs call OSCountCodeActions()
	autocmd FileType cs set signcolumn=yes
	autocmd BufWritePost *.cs :OmniSharpFixUsings<CR>:OmniSharpCodeFormat<CR>:OmniSharpGlobalCodeCheck<CR>

	" Plugin: omnisharp-vim-------------------------------------------{{{
	autocmd FileType cs set updatetime=500
	autocmd FileType cs nnoremap <buffer> ( :OmniSharpNavigateUp<CR>zz
	autocmd FileType cs nnoremap <buffer> ) :OmniSharpNavigateDown<CR>zz
	autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
	autocmd FileType cs nnoremap <buffer> gD :OmniSharpPreviewDefinition<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>i :OmniSharpFindImplementations<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>I :OmniSharpPreviewImplementation<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>s :OmniSharpFindSymbol<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>u :OmniSharpFindUsages<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>m :OmniSharpFindMembers<CR>
	"autocmd FileType cs nnoremap <buffer> <LocalLeader>fx :OmniSharpFixUsings<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>t :OmniSharpTypeLookup<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>d :OmniSharpDocumentation<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>o :ALEDisable<CR>:OmniSharpStopServer<CR>:OmniSharpStartServer<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>O :ALEEnable<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>c :OmniSharpGlobalCodeCheck<CR>
	autocmd FileType cs nnoremap <LocalLeader>q :OmniSharpGetCodeActions<CR>
	autocmd FileType cs xnoremap <LocalLeader>q :call OmniSharp#GetCodeActions('visual')<CR>
	autocmd FileType cs nnoremap <LocalLeader>r :OmniSharpRename<CR>
	autocmd FileType cs nnoremap <LocalLeader>f :OmniSharpFixUsings<CR>:OmniSharpCodeFormat<CR>
"----------------------------------------------------}}}
augroup end


"----------------------------------------------------}}}

"----------------------------------------------------}}}

" AZERTY Keyboard:
" AltGr keys-------------------------------------------{{{

inoremap ^q {|		cnoremap ^q {
inoremap ^s }|		cnoremap ^s }
inoremap ^d [|		cnoremap ^d [
inoremap ^f ]|		cnoremap ^f ]
inoremap ^w ~|		cnoremap ^w ~
inoremap ^x #|		cnoremap ^x #
inoremap ^c <Bar>|	cnoremap ^c <Bar>
inoremap ^b \
					cnoremap ^b \
inoremap ^n @|		cnoremap ^n @
inoremap ^g `|		cnoremap ^g `
inoremap ^h +|		cnoremap ^h +

"----------------------------------------------------}}}
" Arrows,Home,End,Backspace,Delete keys-------------------------------------------{{{

inoremap <C-J> <Left>|  cnoremap <C-J> <Left>
inoremap <C-K> <Right>| cnoremap <C-K> <Right>
inoremap <C-L> <Del>|   cnoremap <C-L> <Del>

inoremap ^j <Home>| cnoremap ^j <Home>
inoremap ^k <End>|  cnoremap ^k <End>

"----------------------------------------------------}}}

" Graphical Layout:
" Buffers, Windows & Tabs-------------------------------------------{{{
set hidden
set splitbelow
set splitright
set previewheight=25
set showtabline=0

" List/Open Buffers
nnoremap <Leader>b :Buffers<CR>

" Close Buffers
function! DeleteHiddenBuffers()"-------------------------------------------{{{
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
"----------------------------------------------------}}}
nnoremap <Leader>c :call DeleteHiddenBuffers()<CR>:ls<CR>

" Open/Close Window or Tab
nnoremap <Leader>s :split<CR>
nnoremap <Leader>v :vsplit<CR>
nnoremap K :q<CR>
nnoremap <Leader>o mW:tabnew<CR>`W
nnoremap <Leader>x :tabclose<CR>
nnoremap <Leader>X :tabonly<CR>:sp<CR>:q<CR>

" Browse to Window or Tab
nnoremap <Leader>h <C-W>h
nnoremap <Leader>j <C-W>j
nnoremap <Leader>k <C-W>k
nnoremap <Leader>l <C-W>l
augroup windows
	autocmd!
	"
	" foldcolumn serves here to give a visual clue for the current window
	autocmd BufLeave * setlocal norelativenumber foldcolumn=0
	autocmd BufEnter * setlocal relativenumber foldcolumn=1
	" Safety net if I close a window accidentally
	autocmd QuitPre * mark K
	" Make sure Vim returns to the same line when you reopen a file.
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif
augroup end
nnoremap <Leader>n gt
nnoremap <Leader>p gT

" Position Window
nnoremap <Leader>H <C-W>H
nnoremap <Leader>J <C-W>J
nnoremap <Leader>K <C-W>K
nnoremap <Leader>L <C-W>L
nnoremap <Leader>r <C-W>r

" Resize Window
nnoremap <Leader>, :vert res -2<CR>
nnoremap <Leader>; :vert res +2<CR>
nnoremap <Leader>: :res -2<CR>
nnoremap <Leader>! :res +2<CR>
nnoremap <Leader>= <C-W>=

" Alternate file fast switching
nnoremap <Leader>d :b #<CR>
"----------------------------------------------------}}}
" Status bar-------------------------------------------{{{

set laststatus=2
" Plugin: lightline.vim-------------------------------------------{{{
function! FileSize() abort"-------------------------------------------{{{
	let l:bytes = getfsize(expand('%p'))
	if (l:bytes >= 1024)
		let l:kbytes = l:bytes / 1025
	endif
	if (exists('kbytes') && l:kbytes >= 1000)
		let l:mbytes = l:kbytes / 1000
	endif

	if l:bytes <= 0
		return '0'
	endif

	if (exists('mbytes'))
		return l:mbytes . 'MB '
	elseif (exists('kbytes'))
		return l:kbytes . 'KB '
	else
		return l:bytes . 'B '
	endif
endfunction
"----------------------------------------------------}}}
function! LightlineStatuslineTabs() abort"-------------------------------------------{{{
	if tabpagenr('$') == 1
		return ''
	endif
	return 'Tab' . tabpagenr() . '[' . tabpagenr('$') . ']'
endfunction
"----------------------------------------------------}}}

let g:lightline = {
	\ 'colorscheme': 'deus',
	\ 'component': { 
		\ 'lineinfo': "%{'LINE ' . line('.') . '[' . line('$') . ']'}",
		\ 'nblines': "%{line('$') . 'rows'}",
		\ 'date': "%{strftime('%A %d %B')}",
		\ 'time': "%{strftime('%Hh%M')}"
	\ },
	\ 'component_function': { 'gitbranch': 'gitbranch#name', 'filesize': 'FileSize' },
	\ 'component_expand': { 'statuslinetabs': 'LightlineStatuslineTabs' },
	\ 'active': {   'left':  [ [ 'statuslinetabs', 'mode', 'paste', 'readonly', 'modified' ], [ 'relativepath', 'gitbranch' ] ],
				\   'right': [ [ 'date', 'time' ], [ 'fileformat', 'fileencoding', 'filesize', 'nblines' ] ] },
	\ 'inactive': {   'left':  [ [ 'statuslinetabs', 'filename' ] ],
				\   'right': [ [ 'modified', 'readonly'], ['date', 'time' ], [ 'filesize', 'nblines'] ] }
\ }"----------------------------------------------------}}}

function! UpdateStatusBar(timer)
	  execute 'let &ro = &ro'
endfunction
let timer = timer_start(20000, 'UpdateStatusBar',{'repeat':-1})
"----------------------------------------------------}}}
" Colorscheme, Highlight groups-------------------------------------------{{{

colorscheme empower

nnoremap <LocalLeader>h :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
nnoremap <LocalLeader>H :OmniSharpHighlightEchoKind<CR>
"----------------------------------------------------}}}

" Motions:
" Cursor vertical position-------------------------------------------{{{

function! DoWithoutChangingCurrentWinLine(sequenceOfLiteralKeys)
	let winLineBefore=winline()
	execute 'normal! ' . a:sequenceOfLiteralKeys
	let winLineAfter=winline()
	
	if winLineAfter > winLineBefore
		execute 'silent normal! ' . (winLineAfter-winLineBefore) . ''
	elseif winLineAfter < winLineBefore
		execute 'silent normal! ' . (winLineBefore-winLineAfter) . ''
	endif
endfunction

"----------------------------------------------------}}}
" Current Line-------------------------------------------{{{

function ExtendedHome()"-------------------------------------------{{{
    let column = col('.')
    normal! ^
    if column == col('.')
        normal! 0
    endif
endfunction
"----------------------------------------------------}}}
nnoremap <silent> <Home> :call ExtendedHome()<CR>
vnoremap <silent> <Home> <Esc>:call ExtendedHome()<CR>mvgv`v
onoremap <silent> <Home> :call ExtendedHome()<CR>

function ExtendedEnd()"-------------------------------------------{{{
    let column = col('.')
    normal! g_
    if column == col('.') || column == col('.')+1
        normal! $
    endif
endfunction
"----------------------------------------------------}}}
nnoremap <silent> <End> :call ExtendedEnd()<CR>
vnoremap <silent> <End> <Esc>:call ExtendedEnd()<CR>mvgv`v
onoremap <silent> <End> :call ExtendedEnd()<CR>

"----------------------------------------------------}}}
" Text objects-------------------------------------------{{{

" Plugin: targets.vim
" Always add cursor position to jumplist
let g:targets_jumpRanges = 'cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb al rB Al bb aa bB Aa BB AA'

" Lines
vnoremap il ^og_| onoremap il :normal vil<CR>
vnoremap al 0o$h|  onoremap al :normal val<CR>

" Folds
vnoremap iz [zjo]zkVg_| onoremap iz :normal viz<CR>
vnoremap az [zo]zVg_|   onoremap az :normal vaz<CR>
"----------------------------------------------------}}}
" Marks-------------------------------------------{{{


augroup marks
	au!
	autocmd TextYankPost * mark Y
augroup end

"----------------------------------------------------}}}
" Jump list-------------------------------------------{{{

" Add to jump list when doing an operation
nnoremap m m'm
nnoremap c m'c
nnoremap d m'd
nnoremap y m'y
nnoremap r m'r
nnoremap s m's
nnoremap i m'i
nnoremap I m'I
nnoremap a m'a
nnoremap A m'A
nnoremap o m'o
nnoremap O m'O

"----------------------------------------------------}}}

" Text Operations:
" Visualization-------------------------------------------{{{

" Current, trimmed line
nnoremap vv ^vg_

" Last inserted text
nnoremap vi `[v`]h

"----------------------------------------------------}}}
" Copy & Paste-------------------------------------------{{{

" Yank current line, trimmed
nnoremap Y y$

" Yank into system clipboard
nnoremap <C-C> "+y
vnoremap <C-C> "+y

" Paste from system clipboard
nnoremap ¨p :set paste<CR>o<Esc>"+p:set nopaste<CR>
nnoremap ¨P :set paste<CR>O<Esc>"+P:set nopaste<CR>
nnoremap ¨¨p :set paste<CR>"+p:set nopaste<CR>
nnoremap ¨¨P :set paste<CR>"+P:set nopaste<CR>
inoremap <C-V> <C-R>+| inoremap <C-C> <C-V>
cnoremap <C-V> <C-R>+| inoremap <C-C> <C-V>

" Cursor position after yanking in Visual mode
vnoremap gy y`]

" Allow pasting several times when replacing visual selection
vnoremap p "0p
vnoremap P "0P

" Select the text that was pasted
nnoremap <expr> vp '`[' . strpart(getregtype(), 0, 1) . '`]'
"----------------------------------------------------}}}
" Macros and Repeat-Last-Action-------------------------------------------{{{

" Repeat last action
nnoremap ù .

" Record macro
nnoremap <Leader>m q

" Replay macro
nnoremap à @@

" Repeat last Ex command
nnoremap . @:
"----------------------------------------------------}}}
" Whitespace characters Handler-------------------------------------------{{{

set listchars=tab:▸\ ,eol:¬,extends:>,precedes:<
set list

" Clean trailing whitespace
nnoremap <Leader>w :%s/\s\+$//<CR>:let @/=''<CR>

"----------------------------------------------------}}}
" Vertical Alignment-------------------------------------------{{{

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"----------------------------------------------------}}}
" Split current line-------------------------------------------{{{

" By given separator (default:,)
nnoremap S :.s/,/\1\r/ge<Left><Left><Left><Left><Left><Left><Left><Left>
vnoremap S :s/,/\1\r/ge<Left><Left><Left><Left><Left><Left><Left><Left>

"----------------------------------------------------}}}
" Separators and newlines-------------------------------------------{{{

let g:MatchPairs = '^""$\|^[]$\|^{}$\|^``$'
function! ReturnAfterBracket()"-------------------------------------------{{{
	if pumvisible()
		return "\<C-y>"
	else
		let l:part = strcharpart(getline('.')[col('.') - 3:], 0, 2)
		if (l:part=~ g:MatchPairs)
			return "\<BS>\<C-O>o" . l:part[1] . "\<C-O>O" 
		else
			return "\<CR>"
		endif
	endif
endfunction
"----------------------------------------------------}}}
inoremap <expr> <CR> ReturnAfterBracket() 

"----------------------------------------------------}}}

" Vim Functionalities:
" Wild Menu-------------------------------------------{{{

set wildmenu
set wildignorecase
set wildmode=full

function! EnterSubdir()"-------------------------------------------{{{
    call feedkeys("\<Down>", 't')
    return ''
endfunction
"----------------------------------------------------}}}
cnoremap <expr> <C-N> EnterSubdir()

function! MoveUpIntoParentdir()"-------------------------------------------{{{
    call feedkeys("\<Up>", 't')
    return ''
endfunction
"----------------------------------------------------}}}
cnoremap <expr> <C-P> MoveUpIntoParentdir()

"----------------------------------------------------}}}
" Expanded characters-------------------------------------------{{{

" Folder of current file
cnoremap µ <C-R>=expand('%:p:h')<CR>\

"----------------------------------------------------}}}
" Sourcing-------------------------------------------{{{

vnoremap <silent> <Leader>S y:execute @@<CR>
nnoremap <silent> <Leader>S ^vg_y:execute @@<CR>

"----------------------------------------------------}}}
" Find, Grep, Make, Equal-------------------------------------------{{{

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ $*

nnoremap <Leader>f :Files <C-R>=fnamemodify('.', ':p')<CR>
nnoremap <Leader>g :Agrep  <C-R>=fnamemodify('.', ':p')<CR><Home><Right><Right><Right><Right><Right><Right>
nnoremap <LocalLeader>m :Amake<CR>

"----------------------------------------------------}}}
" Registers-------------------------------------------{{{

command! ClearRegisters for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

nnoremap t "+

nnoremap T :registers<CR>
"----------------------------------------------------}}}
" Terminal-------------------------------------------{{{

set termwinsize=12*0

" The following line breaks fzf.vim
" set shell=powershell\ -NoLogo

" Delete last word while typing a command line
tnoremap <C-W><C-W> <C-W>.

" Leave terminal mode into Normal mode
tnoremap <C-O> <C-W>N| tnoremap <C-V><C-O> <C-O>
"----------------------------------------------------}}}
" Folding-------------------------------------------{{{

set commentstring=
set foldmarker=-------------------------------------------{{{,----------------------------------------------------}}}

function! MyFoldText()"-------------------------------------------{{{
	let line = getline(v:foldstart)
	let line = strpart(line, 0, len(line)-len('{{{'))

	let nucolwidth = &fdc + &number * &numberwidth
	let windowwidth = winwidth(0) - nucolwidth
	let foldedlinecount = v:foldend - v:foldstart - 1

	" expand tabs into spaces
	let onetab = strpart('		  ', 0, &tabstop)
	let line = substitute(line, '\t', onetab, 'g')

	let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
	let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
	return line . repeat("-",fillcharcount) . foldedlinecount
endfunction
"----------------------------------------------------}}}
set foldtext=MyFoldText()

nnoremap <silent> zr :call DoWithoutChangingCurrentWinLine('zr')<CR>
nnoremap <silent> zR :call DoWithoutChangingCurrentWinLine('zR')<CR>
nnoremap <silent> zm :call DoWithoutChangingCurrentWinLine('zm')<CR>
nnoremap <silent> zM :call DoWithoutChangingCurrentWinLine('zM')<CR>

" Toggle current fold
nnoremap <silent> <Space> :silent! call DoWithoutChangingCurrentWinLine('za')<CR>

" Close all folds except the one cursor is in
nnoremap <silent> zo :call DoWithoutChangingCurrentWinLine('zMzv')<CR>

"----------------------------------------------------}}}
" Search-------------------------------------------{{{
set hlsearch
set incsearch
set ignorecase

" Display '1 out of 23 matches' when searching
set shortmess=filnxtToO

nnoremap ! :call DoWithoutChangingCurrentWinLine('zR')<CR>/
nnoremap z! :call :BLines <C-R>=split(&foldmarker, ",")[0]<CR><CR>
" Display current cursor position in red (error color) for more visibility

function! HLNext (blinktime)"-------------------------------------------{{{
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction
"----------------------------------------------------}}}
nnoremap <silent> n n:call DoWithoutChangingCurrentWinLine('zMzv')\| call HLNext(0.15)<cr>
nnoremap <silent> N N:call DoWithoutChangingCurrentWinLine('zMzv')\| call HLNext(0.15)<cr>

" search selected text
vnoremap * "vy/\V<C-R>v\C<cr>:call DoWithoutChangingCurrentWinLine('zMzv')\| call HLNext(0.15)<cr>
"----------------------------------------------------}}}
" Autocompletion (Insert Mode)-------------------------------------------{{{

" <Esc> cancels popup menu
inoremap <expr> <Esc> pumvisible() ? "\<C-E>" : "\<Esc>"

" <C-N> for omnicompletion, <C-P> for context completion
inoremap <expr> <C-N> pumvisible() ? "\<C-N>" : "\<C-X>\<C-O>"

"----------------------------------------------------}}}
" Diff-------------------------------------------{{{

set diffopt+=algorithm:histogram,indent-heuristic

nnoremap <expr> <C-J> &diff ? ']c' : ':cnext<CR>'
nnoremap <expr> <C-K> &diff ? '[c' : ':cprev<CR>'

augroup diff
	au!
	au OptionSet diff let &cul=!v:option_new
augroup end

"----------------------------------------------------}}}
" Calculator-------------------------------------------{{{

inoremap <C-B> <C-O>yiW<End>=<C-R>=<C-R>0<CR>

"----------------------------------------------------}}}
" QuickFix window-------------------------------------------{{{

" Always show at the bottom of other windows
augroup quickfix
	autocmd!
	autocmd FileType qf wincmd J
augroup end

" Automatically open, but do not go to (if there are errors).Also close it when is has become empty.
autocmd! QuickFixCmdPost [^l]* nested cwindow

"----------------------------------------------------}}}
" Preview window-------------------------------------------{{{

" Close preview window on leaving the insert mode
augroup autocompletion
	autocmd!
	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end

"----------------------------------------------------}}}
" Location window-------------------------------------------{{{

" Automatically open, but do not go to (if there are errors).Also close it when is has become empty.
autocmd QuickFixCmdPost	l* nested lwindow

"----------------------------------------------------}}}

" Additional Functionalities:
" File explorer (graphical)-------------------------------------------{{{

" Plugin: vifm.vim-------------------------------------------{{{
let g:vifm_replace_netrw = 1

function! BuildVifmMarkCommandForFilePath(mark_label, file_path)
	let file_folder_path = substitute(fnamemodify(a:file_path, ':h'), '\\', '/', 'g')
	let file_name = substitute(fnamemodify(a:file_path, ':t'), '\\', '/', 'g')

	return '"mark ' . a:mark_label . ' ' . file_folder_path . ' ' . file_name . '"'
endfunction

let g:vifm_exec_args =  '+"colorscheme juef-zenburn"'

" Open :terminal from vifm's shell feature
let g:vifm_exec_args.=  '+"nnoremap s :!powershell -NoLogo<cr>"'

" Set marks for vifm
let g:vifm_exec_args.= ' +' . BuildVifmMarkCommandForFilePath('v', $v)
let g:vifm_exec_args.= ' +' . BuildVifmMarkCommandForFilePath('p', $p)

" Set previewer (bat)
let g:vifm_exec_args.= ' +' . '"fileviewer *.cs,*.csproj bat --tabs 4 --color always --wrap never --pager never --map-syntax csproj:xml -p %c %p"'

" Set shortcuts
let g:vifm_exec_args.=  ' +"nnoremap K :q<cr>"'
let g:vifm_exec_args.=  ' +"nnoremap ! /"'
"----------------------------------------------------}}}
nnoremap <expr> <Leader>e ":Vifm " . (bufname()=="" ? "." : "%:h") . " .\<CR>"
nnoremap <expr> <Leader>E ":!start explorer.exe " . (bufname()=="" ? "." : "%:h") . "\<CR>"

"----------------------------------------------------}}}
" Google query-------------------------------------------{{{

" Plugin: vim-g
nnoremap <Leader>q :Google 
vnoremap <Leader>q :Google<CR>

"----------------------------------------------------}}}
" Snippets-------------------------------------------{{{

" Plugin: UltiSnips
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir=$VIM . "/pack/plugins/start/vim-snippets-perso"
let g:UltiSnipsSnippetDirectories=[$VIM . "/pack/plugins/start/vim-snippets/ultisnips", $VIM . "/pack/plugins/start/vim-snippets-perso"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

nnoremap su :UltiSnipsEdit<CR>G

augroup ultisnips
	au!
	autocmd User UltiSnipsEnterFirstSnippet mark '
augroup end

"----------------------------------------------------}}}
" Git-------------------------------------------{{{

nnoremap <Leader>G :Git<CR>

"----------------------------------------------------}}}
" Pomodoro & Notes -------------------------------------------{{{

" Open in a new tab
nnoremap <Leader>_ mW:tabnew $pomodoro<CR>zMGkzazjzazk[zkkzt<C-Y>:vs<CR>`Wzz:sp $n<CR>zMGza[zjzt:exec 'resize ' . string(&lines * 0.7)<CR>:exec 'vertical resize ' . string(&columns * 0.6)<CR><C-W>k

"----------------------------------------------------}}}

" Others:
" Popup example-------------------------------------------{{{
" augroup timedisplay
" 	au!
" 	autocmd VimEnter * call prop_type_add('time', #{highlight: 'Normal'})
" augroup end
"nnoremap <silent> <Leader>t :call popup_create([#{text: strftime('%Hh%M - %A %d %B'), props:[#{type: 'time'}]}], #{time: 1750, padding: [0,1,0,1], border: [], borderhighlight: ['Keyword','Keyword', 'Keyword', 'Keyword']})<CR>

"----------------------------------------------------}}}
" Desktop Integration-------------------------------------------{{{
augroup duplicatefiles
	au!

	au BufWritePost _vimrc saveas! $HOME/Desktop/my.vimrc
	au BufWritePost my.vimrc saveas! $HOME/Desktop/tools/vim/_vimrc

	au BufWritePost empower.vim saveas! $HOME/Desktop/my.colorscheme
	au BufWritePost my.colorscheme saveas! $HOME/Desktop/tools/vim/pack/plugins/start/vim-empower/colors/empower.vim

	au BufWritePost my.ahk exec '!Ahk2Exe.exe /in %:p /out ' . fnameescape($HOME . '/Desktop/tools/myAzertyKeyboard.RunMeAsAdmin.exe')
augroup end
"----------------------------------------------------}}}

let $desktop = $HOME . '/Desktop'
set path+=$desktop/notes

" Desktop Integration:-----------------{{{
" Plugins" ----------------------------{{{
function! MinpacInit()
	packadd minpac
	call minpac#init( #{dir:$VIM, package_name: 'plugins' } )
	call minpac#add('dense-analysis/ale')
	call minpac#add('zigford/vim-powershell')
	call minpac#add('junegunn/fzf.vim')
	call minpac#add('itchyny/lightline.vim')
	call minpac#add('itchyny/vim-gitbranch')
	call minpac#add('Melandel/omnisharp-vim')
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
let loaded_netrwPlugin = 1 " do not load netrw

" First time" -------------------------{{{
if !isdirectory($VIM.'/pack/plugins')
	call system('git clone https://github.com/k-takata/minpac.git ' . $VIM . '/pack/packmanager/opt/minpac')
	call MinpacInit()
	call minpac#update()
	packloadall
endif

" Duplicated/Generated files" ---------{{{
augroup duplicatefiles
	au!
	au BufWritePost my_keyboard.ahk exec '!Ahk2Exe.exe /in %:p /out ' . fnameescape($HOME . '/Desktop/tools/myAzertyKeyboard.RunMeAsAdmin.exe')
augroup end

" General:-----------------------------{{{
" Settings" ---------------------------{{{
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

" Tabs and Indentation" ---------------{{{
set smartindent
set tabstop=1
set shiftwidth=1
nnoremap > >>
nnoremap < <<
command! -bar Spaces2Tabs set noet ts=4 |%retab!|set ts=1

" Leader keys" ------------------------{{{
let mapleader = 's'
let maplocalleader = 'q'

" Local Current Directories" ----------{{{
let g:lcd_qf = getcwd()

function! GetInterestingParentDirectory()
	if IsOmniSharpRelated()
		return fnamemodify(b:OmniSharp_host.sln_or_dir, ':p:h')
	elseif &ft == 'qf'
		return g:lcd_qf
	elseif IsInsideGitClone()
		return fnamemodify(gitbranch#dir(expand('%:p')), ':h')
	else
		return getcwd()
	endif
endfunction

function! UpdateLocalCurrentDirectory()
	let dir = GetInterestingParentDirectory()
	let current_wd = getcwd()
	if current_wd != dir
		redraw
		echo printf('[%s] -> [%s]', current_wd, dir)
		execute('lcd '.dir)
	endif	
endfunction
command! -bar Lcd call UpdateLocalCurrentDirectory()

augroup lcd
	au!
	autocmd BufEnter * if &ft!='dirvish' | Lcd | else | lcd %:p:h | endif
	autocmd QuickFixCmdPre * let g:lcd_qf = getcwd()
augroup end

" Utils"-------------------------------{{{
function! IsQuickFixWindowOpen()
	return len(filter(range(1, winnr('$')), {_,x -> getwinvar(x, '&syntax') == 'qf'}))
endfunction

function! IsInsideGitClone()
	return gitbranch#dir(expand('%:p')) != ''
endfunction

function! IsOmniSharpRelated()
	return exists('b:OmniSharp_host.sln_or_dir') && b:OmniSharp_host.sln_or_dir =~ '\v\.(sln|csproj)$'
endfunction

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

function! ExecuteAndAddIntoSearchHistory(searched)
	call histadd('search', a:searched)
	let @/=a:searched
	set hls
endfunction

function! ClearTrailingWhiteSpaces()
	%s/\s\+$//e
endfunction
command ClearTrailingWhiteSpaces call ClearTrailingWhiteSpaces()

" AZERTY Keyboard:---------------------{{{
" AltGr keys" -------------------------{{{
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

" Arrows" -----------------------------{{{
inoremap <C-J> <Left>|  cnoremap <C-J> <Left>|  tnoremap <C-J> <Left>
inoremap <C-K> <Right>| cnoremap <C-K> <Right>| tnoremap <C-K> <Right>

" Home,End" ---------------------------{{{
inoremap ^j <Home>| cnoremap ^j <Home>| tnoremap ^j <Home>
inoremap ^k <End>|  cnoremap ^k <End>|  tnoremap ^k <End>

" Backspace,Delete" -------------------{{{
tnoremap <C-L> <Del>
inoremap <C-L> <Del>|   cnoremap <C-L> <Del>

" Graphical Layout:--------------------{{{
" Colorscheme, Highlight groups" ------{{{
colorscheme empower
"nnoremap <LocalLeader>h :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
"nnoremap <LocalLeader>H :OmniSharpHighlightEchoKind<CR>

" Buffers, Windows & Tabs" ------------{{{
set hidden
set splitbelow
set splitright
set noequalalways " keep windows viewport when splitting
set previewheight=25
set showtabline=0

" List/Open Buffers
nnoremap <Leader>b :Buffers<CR>

" Close Buffers
function! DeleteHiddenBuffers()" ------{{{
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
nnoremap <Leader>c :silent! call DeleteHiddenBuffers()<CR>:ls<CR>

" Open/Close Window or Tab
command! -bar Enew    exec('enew    | set buftype=nofile bufhidden=hide noswapfile | silent lcd '.$desktop.'/tmp')
command! -bar New     exec('new     | set buftype=nofile bufhidden=hide noswapfile | silent lcd '.$desktop.'/tmp')
command! -bar Vnew    exec('vnew    | set buftype=nofile bufhidden=hide noswapfile | silent lcd '.$desktop.'/tmp')
command! -bar Tabedit exec('tabedit | set buftype=nofile bufhidden=hide noswapfile | silient lcd '.$desktop.'/tmp')
nnoremap <silent> <Leader>s :if bufname() != '' \| split  \| else \| New  \| endif<CR>
nnoremap <silent> <Leader>v :if bufname() != '' \| vsplit \| else \| Vnew \| endif<CR>
nnoremap <silent> K :q<CR>
nnoremap <silent> <Leader>o mW:tabnew<CR>`W
nnoremap <silent> <Leader>x :tabclose<CR>

" Browse to Window or Tab
nnoremap <silent> <Leader>h <C-W>h
nnoremap <silent> <Leader>j <C-W>j
nnoremap <silent> <Leader>k <C-W>k
nnoremap <silent> <Leader>l <C-W>l
nnoremap <silent> <Leader><home> 1<C-W>W
nnoremap <silent> <Leader><end> 99<C-W>W
nnoremap <silent> <Leader>n gt
nnoremap <silent> <Leader>p gT

augroup windows
	autocmd!
	"
	" Use foldcolumn to give a visual clue for the current window
	autocmd WinLeave * if !pumvisible() | setlocal norelativenumber foldcolumn=0 | endif
	autocmd WinEnter * if !pumvisible() | setlocal relativenumber   foldcolumn=1 | endif
	" Safety net if I close a window accidentally
	autocmd QuitPre * mark K
	" Make sure Vim returns to the same line when you reopen a file.
 autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif
augroup end

" Position Window
nnoremap <silent> <Leader>H <C-W>H
nnoremap <silent> <Leader>J <C-W>J
nnoremap <silent> <Leader>K <C-W>K
nnoremap <silent> <Leader>L <C-W>L

" Resize Window
nnoremap <silent> <A-h> :vert res -2<CR>| tmap <silent> <A-h> <C-W>N:vert res -2<CR>i
nnoremap <silent> <A-l> :vert res +2<CR>| tmap <silent> <A-l> <C-W>N:vert res +2<CR>i
nnoremap <silent> <A-j> :res -2<CR>|      tmap <silent> <A-j> <C-W>N:res -2<CR>i
nnoremap <silent> <A-k> :res +2<CR>|      tmap <silent> <A-k> <C-W>N:res +2<CR>i
nnoremap <silent> <Leader>= <C-W>=
nnoremap <silent> <Leader>\| <C-W>\|
nnoremap <silent> <Leader>_ <C-W>_

" Alternate file fast switching
noremap <Leader>d <C-^>

" Status bar" -------------------------{{{
set laststatus=2

function! TabInfo()
	let maxtab = tabpagenr('$')
	if maxtab == 1
		return ''
	else
		let currenttab = tabpagenr()
		return join(map(range(1, tabpagenr('$')), {_,itm -> (itm == currenttab ? '['.itm.']' : string(itm))}), ' ')
	endif
endfunction

function! WinNr()
	return printf('[Window #%s]', winnr())
endfunction

function! GitBranch()
	return printf('[%s]', gitbranch#name())
endfunction

function! FolderRelativePathFromGit()
	let filepath = expand('%:p')
	let folderpath = expand('%:p:h')
	let gitrootfolder = fnamemodify(gitbranch#dir(filepath), ':h:p')
	let foldergitpath = folderpath[len(gitrootfolder)+1:]
	return './' . substitute(foldergitpath, '\', '/', 'g')
endfunction
exec("source $VIM/pack/plugins/start/vim-sharpenup/autoload/sharpenup/statusline.vim")
let g:sharpenup_statusline_opts = { 'TextLoading': '%s…', 'TextReady': '%s', 'TextDead': '_', 'Highlight': 0 }

let g:lightline = {
	\ 'colorscheme': 'empower',
	\ 'component_function': {
	\    'filesize_and_rows': 'FileSizeAndRows',
	\    'winnr': 'WinNr',
	\    'tabinfo': 'TabInfo'
	\ },
	\ 'component': {
	\   'sharpenup': sharpenup#statusline#Build(),
	\   'gitinfo': '%{FolderRelativePathFromGit()} %{GitBranch()}',
	\   'time': '%{strftime("%A %d %B [%Hh%M]")}',
	\   'winnr2': '#%{winnr()}'
 \ },
	\ 'component_visible_condition': {
	\    'sharpenup': 'IsOmniSharpRelated()',
	\    'winnr2': '0'
	\  },
	\ 'active':   {
	\    'left':  [
	\        [ 'mode', 'winnr2', 'paste', 'readonly', 'modified' ],
	\        [ 'tabinfo', 'time' ]
	\    ],
	\    'right': [
	\        ['sharpenup', 'filename', 'readonly', 'modified' ],
	\        [ 'gitinfo' ]
	\    ]
	\ },
	\ 'inactive': {
	\    'left':  [
	\        ['winnr']
	\    ],
	\    'right': [
	\        [ 'sharpenup', 'filename', 'readonly', 'modified' ],
	\        [ 'gitinfo' ]
	\    ]
	\ }
	\}
let timer = timer_start(20000, 'UpdateStatusBar',{'repeat':-1})

function! UpdateStatusBar(timer)
  execute 'let &ro = &ro'
endfunction

" Motions:-----------------------------{{{
" Browsing File Architecture" ---------{{{
function! BrowseToNextParagraph()
	let oldpos = line('.')
	if oldpos != line('$')
		normal! }
	endif
	if line('.') != line('$')
		normal! j
	endif
endfunction

function! BrowseToLastParagraph()
	let oldpos = line('.')
	normal! {
	if line('.') == oldpos-1
		normal! {
	endif
	if line('.') != 1
		normal! j
	endif
	if oldpos != 1 && line('.') == oldpos
		normal! k
	endif
endfunction
nnoremap <silent> <C-N> :call BrowseToNextParagraph()<CR>
nnoremap <silent> <C-P> :call BrowseToLastParagraph()<CR>

function! BrowseLayoutDown()
	if &diff
		keepjumps execute 'silent! normal! ]czx'
	elseif len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')) > 0
		keepjumps silent! cnext
	endif
	silent! normal! zv
	normal! m'
endfunction
nnoremap <silent> <C-J> :call BrowseLayoutDown()<CR>

function! BrowseLayoutUp()
	if &diff
		keepjumps execute 'silent! normal! [czx'
	elseif len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')) > 0
		keepjumps silent! cprev
	endif
	silent! normal! zv
	normal! m'
endfunction
nnoremap <silent> <C-K> :call BrowseLayoutUp()<CR>

" Current Line" -----------------------{{{
nnoremap <silent> . :let c= strcharpart(getline('.')[col('.') - 1:], 0, 1)\|exec "normal! f".c<CR>

function! ExtendedHome()
    let column = col('.')
    normal! ^
    if column == col('.')
        normal! 0
    endif
endfunction
nnoremap <silent> <Home> :call ExtendedHome()<CR>
vnoremap <silent> <Home> <Esc>:call ExtendedHome()<CR>mvgv`v
onoremap <silent> <Home> :call ExtendedHome()<CR>

function! ExtendedEnd()
    let column = col('.')
    normal! g_
    if column == col('.') || column == col('.')+1
        normal! $
    endif
endfunction
nnoremap <silent> <End> :call ExtendedEnd()<CR>
vnoremap <silent> <End> $
onoremap <silent> <End> :call ExtendedEnd()<CR>

function! MoveCursorToNext(pattern)
	mark '
	let match =	 searchpos(a:pattern, '', line('.'))
endfunction

function! MoveCursorToLast(pattern)
	mark '
	let match = searchpos(a:pattern, 'b', line('.'))
endfunction

function! MoveToLastMatch()
	let lastcmd = histget('cmd', -1)
	if lastcmd =~ 'MoveCursorTo'
		execute substitute(lastcmd, 'Next', 'Last', 'g')
	else
		normal! ,
	endif
endfunction

function! MoveToNextMatch()
	let lastcmd = histget('cmd', -1)
	if lastcmd =~ 'MoveCursorTo'
		execute substitute(lastcmd, 'Last', 'Next', 'g')
	else
		normal! ;
	endif
endfunction
nnoremap <silent> <Leader>, :call ExecuteAndAddIntoHistory("call MoveCursorToNext('[A-Z_]\\C')")<CR>
nnoremap <silent> <Leader>; :call ExecuteAndAddIntoHistory("call MoveCursorToNext('[^A-Za-z_ \\t]\\C')")<CR>
nnoremap <silent> , :call MoveToLastMatch()<CR>
nnoremap <silent> ; :call MoveToNextMatch()<CR>

function! VMoveToLastMatch()
	normal! gv
	let lastcmd = histget('cmd', -1)
	if lastcmd =~ 'MoveCursorTo'
		execute substitute(lastcmd, 'Next', 'Last', 'g')
	else
		normal! ,
	endif
endfunction

function! VMoveToNextMatch()
	normal! gv
	let lastcmd = histget('cmd', -1)
	if lastcmd =~ 'MoveCursorTo'
		execute substitute(lastcmd, 'Last', 'Next', 'g')
	else
		normal! ;
	endif
endfunction
vnoremap <silent> <Leader>, :<C-U>call ExecuteAndAddIntoHistory("call MoveCursorToNext('[A-Z_]\\C')") \| normal! v`<o<CR>
vnoremap <silent> <Leader>; :<C-U>call ExecuteAndAddIntoHistory("call MoveCursorToNext('[^A-Za-z_ \\t]\\C')") \| normal! v`<o<CR>
vnoremap <silent> , :<C-U>call VMoveToLastMatch()<CR>
vnoremap <silent> ; :<C-U>call VMoveToNextMatch()<CR>

" Text objects" -----------------------{{{
vnoremap il ^og_| onoremap il :normal vil<CR>
vnoremap al 0o$h| onoremap al :normal val<CR>
vnoremap if ggoGV| onoremap if :normal vif<CR>
" Always add cursor position to jumplist
let g:targets_jumpRanges = 'cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb al rB Al bb aa bB Aa BB AA'

" Text Operations:---------------------{{{
" Visualization" ----------------------{{{
" select until end of line
nnoremap vv ^vg_
" remove or add a line to visualization
vnoremap <C-J> V<esc>ojo
vnoremap <C-K> V<esc>oko

" Copy & Paste" -----------------------{{{
nnoremap Y y$
nnoremap zy "+y
nnoremap zY "+Y
vnoremap zy "+y
nnoremap zp :set paste<CR>o<Esc>"+p:set nopaste<CR>
nnoremap zP :set paste<CR>O<Esc>"+P:set nopaste<CR>
inoremap <C-V> <C-O>:set paste<CR><C-R>+<C-O>:set nopaste<CR>| inoremap <C-C> <C-V>
cnoremap <C-V> <C-R>=@+<CR>| cnoremap <C-C> <C-V>
tnoremap <C-V> <C-W>"+
vnoremap gy y`]
nnoremap <expr> vp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Repeat-Last-Action" -----------------{{{
nnoremap ù .

" Vertical Alignment" -----------------{{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Vim Core Functionalities:------------{{{
" Command Line"------------------------{{{
cnoremap µ **/*$<left>

" Wild Menu" --------------------------{{{
set wildmenu
set wildcharm=<Tab>
set wildignorecase
set wildmode=full

" Expanded characters" ----------------{{{
" Folder of current file
cnoremap <expr> <C-F> (stridx(getcmdline()[-1-len(expand('%:p:h')):], expand('%:p:h')) == 0 ? '**\*' : expand('%:p:h').'\')
cnoremap <expr> <C-G> (stridx(getcmdline()[-1-len(GetInterestingParentDirectory()):], GetInterestingParentDirectory()) == 0 ? '**\*' : GetInterestingParentDirectory().'\')

" Sourcing" ---------------------------{{{
" Run a line/selected text composed of vim script
vnoremap <silent> <Leader>S y:execute @@<CR>
nnoremap <silent> <Leader>S ^vg_y:execute @@<CR>
" Write output of a vim command in a buffer
nnoremap ç :let script=''\|call histadd('cmd',script)\|put=execute(script)<Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>
augroup vimsourcing
	au!
	autocmd BufWritePost _vimrc GvimTweakToggleFullScreen | so % | GvimTweakToggleFullScreen
	autocmd FileType vim nnoremap <buffer> z! :BLines function!\\|{{{<CR>
augroup end

" Find, Grep, Make, Equal" ------------{{{
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --no-ignore-parent\ --no-column\ \"$*\"
set switchbuf+=uselast
set errorformat=%m
nnoremap <Leader>f :GFiles?<CR>
nnoremap <Leader>r :Rg! 
vnoremap <Leader>r "vy:let cmd = printf('Rg! %s',@v)\|echo cmd\|call histadd('cmd',cmd)\|execute cmd<CR>
nnoremap <LocalLeader>m :silent make<CR>

" Terminal" ---------------------------{{{
set termwinsize=12*0
tnoremap <Esc> <C-W>N:setlocal norelativenumber number foldcolumn=0 nowrap<CR>zb
tnoremap <C-O> <Esc>

" Folding" ----------------------------{{{
vnoremap <silent> <space> <Esc>zE:let b:focus_mode=1 \| setlocal foldmethod=manual<CR>`<kzfgg`>jzfG`<
nnoremap <silent> <space> :exec('normal! '.(b:focus_mode==1 ? 'zR' : 'zM')) \| let b:focus_mode=!b:focus_mode<CR>

" Search" -----------------------------{{{
set hlsearch
set incsearch
set ignorecase
" Display '1 out of 23 matches' when searching
set shortmess=filnxtToO
nnoremap ! mG/
vnoremap ! <Esc>mGgv"vy/<C-R>v
nnoremap / mG:Lines<CR>

augroup search
	au!
	autocmd FileType * if &ft != 'dirvish' | silent nnoremap <buffer> q! q/ | endif
augroup end
nnoremap z! :BLines<CR>
command! UnderlineCurrentSearchItem silent call matchadd('ErrorMsg', '\c\%#'.@/, 101)
nnoremap <silent> n :keepjumps normal! n<CR>:UnderlineCurrentSearchItem<CR>
nnoremap <silent> N :keepjumps normal! N<CR>:UnderlineCurrentSearchItem<CR>
nnoremap <silent> * :call ExecuteAndAddIntoSearchHistory('<C-R>='\<'.expand('<cword>').'\>\C'<CR>')<CR>
vnoremap <silent> * "vy:call ExecuteAndAddIntoSearchHistory('<C-R>='\<'.@v.'\>\C'<CR>')<CR>

function! CopyAllMatches(...)
  let reg= a:0 ? a:1 : '+'
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -nargs=? CopyAllMatches :call CopyAllMatches(<f-args>)

" Autocompletion (Insert Mode)" -------{{{
inoremap ù <C-X><C-O>

" Diff" -------------------------------{{{
set diffopt+=algorithm:histogram,indent-heuristic,vertical

augroup diff
	au!
	autocmd OptionSet diff let &cursorline=!v:option_new
	autocmd OptionSet diff normal! gg]c
augroup end

" QuickFix, Preview, Location window" -{{{
" Always show at the bottom of other windows
augroup quickfix
	au!
" Automatically open, but do not go to (if there are errors).Also close it when is has become empty.
	autocmd QuickFixCmdPost [^l]* nested cwindow
	autocmd FileType qf wincmd J
	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
	autocmd QuickFixCmdPost	l* nested lwindow
	autocmd FileType nofile nnoremap <buffer> K :bd!<CR>
augroup end

" Marks"-------------------------------{{{
" H and L are used for cycling between buffers and `A is a pain to type
nnoremap M `
" Changelist"--------------------------{{{
nnoremap g; g;zv
nnoremap g, g,zv

" Additional Functionalities:----------{{{
" Brackets"----------------------------{{{
inoremap <expr> ( (col('.') == col('$')) ? "()\<left>" : '('
inoremap <expr> [ (col('.') == col('$')) ? "[]\<left>" : '['
inoremap <expr> { (col('.') == col('$')) ? "{}\<left>" : '{'
inoremap <expr> <cr> getline('.')[max([0,col('.')-2]):max([col('.')-1,0])]=='{}' ? '<cr><esc>O' : '<cr>'

" Buffer navigation"-------------------{{{
nnoremap <silent> H :call CycleWindowBuffersHistoryBackwards()<CR>
nnoremap <silent> L :call CycleWindowBuffersHistoryForward()<CR>

" Fuzzy Finder"------------------------{{{
let $FZF_DEFAULT_OPTS="--expect=ctrl-t,ctrl-v,ctrl-x,ctrl-j,ctrl-k,ctrl-o --bind up:preview-up,down:preview-down"
let g:fzf_preview_window = 'right:60%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
augroup my_fzf"------------------------{{{
	au!
	autocmd FileType fzf tnoremap <buffer> <C-V> <C-V>
	autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
	autocmd FileType fzf tnoremap <buffer> <C-J> <C-J>
	autocmd FileType fzf tnoremap <buffer> <C-K> <C-K>
	autocmd FileType fzf tnoremap <buffer> <C-O> <C-T>
augroup end
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Constant'],
  \ 'fg+':     ['fg', 'Constant', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Ignore'],
  \ 'gutter':  ['fg', 'Comment'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Normal'],
  \ 'prompt':  ['fg', 'Normal'],
  \ 'pointer': ['fg', 'Constant'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

function! Edit(lines)"-----------------{{{
	if len(a:lines) < 2 | return | endif
	let file_or_dir = a:lines[1]
	let cmd = isdirectory(file_or_dir) ?
		\get({'ctrl-x': 'split | Dirvish',
		     \'ctrl-j': 'split | Dirvish',
		     \'ctrl-v': 'vertical split | Dirvish',
		     \'ctrl-k': 'vertical split | Dirvish',
							\'ctrl-t': 'tabe | Dirvish',
							\'ctrl-o': 'tabe | Dirvish'}, a:lines[0], 'Dirvish') :
		\get({'ctrl-x': 'split',
		     \'ctrl-j': 'split',
		     \'ctrl-v': 'vertical split',
		     \'ctrl-k': 'vertical split',
							\'ctrl-t': 'tabe',
							\'ctrl-o': 'tabe'}, a:lines[0], 'e')
	execute cmd file_or_dir
endfunction

function! Explore()
	let vimrc = expand($VIM.'\_vimrc')
	let plugins = expand($VIM.'\pack\plugins\start\*', 0, 1)
	let csharpfolders = filter(keys(get(g:,'csprojs2sln',{})), {_,x->isdirectory(x)})
	let gitfiles = filter(systemlist('git ls-files'), {_,x->x !~ 'my_vimrc.vim'})
	let downloads = expand($HOME.'\Downloads\')
	let desktop = expand($HOME.'\Desktop')
	let todofiles = map(['todo', 'done', 'achievements'], {_,x -> expand($HOME.'\Desktop\'.x)})
	let projects = [expand($HOME.'\Desktop\projects'), expand($HOME.'\Desktop\projects\*',0,1)]
	let setup = [expand($HOME.'\Desktop\setup'), expand($HOME.'\Desktop\setup\*',0,1)]
	let snippets = [expand($HOME.'\Desktop\snippets'), expand($HOME.'\Desktop\snippets\*',0,1)]
	let templates = [expand($HOME.'\Desktop\templates'), expand($HOME.'\Desktop\templates\*',0,1)]
	let tools = [expand($HOME.'\Desktop\tools'), expand($HOME.'\Desktop\tools\*',0,1)]
	let tmp = [expand($HOME.'\Desktop\tmp')] + expand($HOME.'\Desktop\tmp\*', 0, 1) 
	let colorfiles = [expand($VIM.'\pack\plugins\start\vim-empower\colors\empower.vim'), expand($VIM.'\pack\plugins\start\vim-empower\autoload\lightline\colorscheme\empower.vim')]
	let notes = [expand($HOME.'\Desktop\notes\'), expand($HOME.'\Desktop\notes\*', 0, 1)]
	let source = uniq([expand('%:h:p')]+sort(flatten([vimrc,plugins,csharpfolders,downloads,gitfiles,desktop,todofiles,projects,setup,snippets,templates,tools,tmp,colorfiles,notes])))
	call fzf#run(fzf#vim#with_preview(fzf#wrap({'source': source,'sink*': function('Edit'), 'options': ['--prompt', 'Edit> ']})))
endfunction
command! Explore call Explore()
nnoremap <leader>e :Explore<CR>
nnoremap <leader>g :Commits<CR>
nnoremap <leader>G :BCommits<CR>

" Window buffer navigation"------------{{{
function! CycleWindowBuffersHistoryBackwards()
	let jumplist = getjumplist()
	let currentbufnr = bufnr('%')
	let newbuffer = currentbufnr
	let currentpos = get(w:, 'pos', jumplist[1]-1)
	for i in range(currentpos, 0, -1)
		let bufnr = jumplist[0][i].bufnr
		if bufnr != currentbufnr && bufnr > 0
			let newbuffer = bufnr
			let w:pos = i
			break
		endif
	endfor
	exec(printf('silent keepjumps b %d',newbuffer))
endfunction

function! CycleWindowBuffersHistoryForward()
	let jumplist = getjumplist()
	let currentbufnr = bufnr('%')
	let newbuffer = currentbufnr
	let currentpos = get(w:, 'pos', jumplist[1]-1)
	for i in range(currentpos, len(jumplist[0])-1)
		let bufnr = jumplist[0][i].bufnr
		if bufnr != currentbufnr && bufnr > 0
			let newbuffer = bufnr
			let w:pos = i
			break
		endif
	endfor
	exec(printf('silent keepjumps b %d',newbuffer))
endfunction

" Full screen" ------------------------{{{
let g:gvimtweak#window_alpha=255 " alpha value (180 ~ 255) default: 245
let g:gvimtweak#enable_alpha_at_startup=1
let g:gvimtweak#enable_topmost_at_startup=0
let g:gvimtweak#enable_maximize_at_startup=1
let g:gvimtweak#enable_fullscreen_at_startup=1
nnoremap <silent> ° :GvimTweakToggleFullScreen<CR>
nnoremap <silent> <A-n> :GvimTweakSetAlpha 10<CR>| tmap <silent> <A-n> <C-W>N:GvimTweakSetAlpha 10<CR>i
nnoremap <silent> <A-p> :GvimTweakSetAlpha -10<CR>| tmap <silent> <A-p> <C-W>N:GvimTweakSetAlpha i-10<CR>i

" File explorer (graphical)" ----------{{{
function! IsPreviouslyYankedItemValid()
	return @d != ''
endfunction

function! PromptUserForRenameOrSkip(filename)
	let rename_or_skip = input(a:filename.' already exists. Rename it or skip operation?(r/S) ')
	if rename_or_skip != 'r'
		return ''
	endif
	return input('Rename into:', a:filename)
endfunction

function! CopyPreviouslyYankedItemToCurrentDirectory()
	if !IsPreviouslyYankedItemValid()
		echomsg 'Select a path first!'
		return
	endif
	let cwd = getcwd()
	let item = trim(@d, '/\')
	let item_folder= fnamemodify(item, ':h')
	let item_filename= fnamemodify(item, ':t')
	let item_finalname = item_filename
	if !empty(glob(item_filename))
		let item_finalname = PromptUserForRenameOrSkip(item_filename)
		redraw
		echomsg 'a:'.item_finalname
		if item_finalname == ''
			return
		endif
	endif
	let cmd = 'robocopy '
	if isdirectory(item)
		let cmd .= printf('/e "%s" "%s\%s"', item, cwd, item_finalname)
	else
		let cmd .= printf('"%s" "%s" "%s"', item_folder, cwd, item_finalname)
	endif
echomsg cmd
	silent execute(printf(':!start /b %s', cmd))
endfunction

function! DeleteItemUnderCursor()
	let target = trim(getline('.'), '/\')
	let filename = fnamemodify(target, ':t')
	let cmd = (isdirectory(target)) ?  printf('rmdir "%s" /s /q',target) : printf('del "%s"', target)
	silent execute(printf(':!start /b %s', cmd))
	normal R
endfunction

function! MovePreviouslyYankedItemToCurrentDirectory()
	if !IsPreviouslyYankedItemValid()
		echomsg 'Select a path first!'
		return
	endif
	let cwd = getcwd()
	let item = trim(@d, '/\')
	let item_folder= fnamemodify(item, ':h')
	let item_filename= fnamemodify(item, ':t')
	let item_finalname = item_filename
	if !empty(glob(item_finalname))
		let item_finalname = PromptUserForRenameOrSkip(item_filename)
		if item_finalname == ''
			return
		endif
	endif
	let cmd = printf('move "%s" "%s\%s"', item, cwd, item_finalname)
	silent execute(printf(':!start /b %s', cmd))
	normal R
	silent exec(printf('/\<%s\>', item_finalname))
	nohlsearch
endfunction

function! RenameItemUnderCursor()
	let target = trim(getline('.'), '/\')
	let filename = fnamemodify(target, ':t')
	let newname = input('Rename into:', filename)
	silent execute(printf(':!start /b rename "%s" "%s"',target,newname))
	normal R
endfunction

function! OpenTree(flags)
	let flags = ( a:flags != '' ? ('-'.a:flags) : '' )
	let target = trim(getline('.'), '\') " Remove the ending separator or tree won't work with double quotes
	let filename = fnamemodify(target,':t')
	vnew | set buftype=nofile nowrap
	set conceallevel=3 concealcursor=n | syn match Todo /\v(\a|\:|\\|\/|\.)*(\/|\\)/ conceal
	nnoremap <buffer> yy $"by$
	let cmd = printf('silent read !tree.exe --noreport -I "bin|obj" "%s" %s', target, flags)
	exec(cmd)
	%s,\\,/,ge
	normal! gg"_dd
endfunction

function! CreateDirectory()
	let dirname = input('Directory name:')
	if trim(dirname) == ''
		return
	elseif isdirectory(glob(dirname))
		redraw
		echomsg printf('"%s" already exists.', dirname)
		return
	endif
	let cmd = printf(':!start /b mkdir "%s"', dirname)
	silent execute(cmd)
	normal R
	silent exec(printf('/\<%s\>', dirname))
	nohlsearch
endf

function! CreateFile()
	let filename = input('File name:')
	if trim(filename) == ''
		return
	elseif !empty(glob(filename))
		redraw
		echomsg printf('"%s" already exists.', filename)
		return
	endif
	let cmd = printf(':!start /b copy /y NUL "%s" >NUL', filename)
	silent execute(cmd)
	normal R
	silent exec(printf('/\<%s\>', filename))
	nohlsearch
endf

function! PreviewFile(splitcmd, giveFocus)
	let path=trim(getline('.'))
	let bufnr=bufnr()
	let previewwinid = getbufvar(bufnr, 'preview'.a:splitcmd, 0)
	if previewwinid == 0
		exec(a:splitcmd. ' ' .path)
		call setbufvar(bufnr, 'preview'.a:splitcmd, win_getid())
	else
		call win_gotoid(previewwinid)
		if win_getid() == previewwinid
			exec("edit ".path)
		else
			exec(a:splitcmd. ' ' .path)
			call setbufvar(bufnr, 'preview'.a:splitcmd, win_getid())
		endif
	endif
	if !a:giveFocus
		exec(printf('wincmd %s', (a:splitcmd == 'vsplit' ? 'h' : 'k')))
	endif
endfunction

augroup my_dirvish
	au!
	autocmd BufEnter if &ft == 'dirvish' | let b:previewvsplit = 0 | let b:previewsplit = 0 | endif
	autocmd BufLeave if &ft == 'dirvish' | mark L | endif
	autocmd BufEnter if &ft == 'dirvish' | silent normal R
	autocmd FileType dirvish nmap <silent> <buffer> <nowait> q gq
	autocmd FileType dirvish nnoremap <silent> <buffer> f :term ++curwin ++noclose powershell -NoLogo<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> F :term ++noclose powershell -NoLogo<CR>
	autocmd FileType dirvish unmap <buffer> o
	autocmd FileType dirvish nnoremap <silent> <buffer> o :call PreviewFile('vsplit', 0)<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> O :call PreviewFile('vsplit', 1)<CR>
	autocmd FileType dirvish unmap <buffer> a
	autocmd FileType dirvish nnoremap <silent> <buffer> a :call PreviewFile('split', 0)<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> A :call PreviewFile('split', 1)<CR>
	autocmd FileType dirvish let b:vifm_mappings=1 | lcd %:p:h | setlocal foldcolumn=1
	autocmd FileType dirvish nnoremap <silent> <buffer> l :<C-U>.call dirvish#open("edit", 0)<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> i :call CreateDirectory()<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> I :call CreateFile()<CR>
	autocmd FileType dirvish nmap <buffer> h <Plug>(dirvish_up)
	autocmd FileType dirvish nmap <buffer> , <Plug>(dirvish_K)
	autocmd FileType dirvish nnoremap <silent> <buffer> K :q<CR>
	autocmd FileType dirvish unmap <buffer> p
	autocmd FileType dirvish nnoremap <buffer> yy ^"dy$
	autocmd FileType dirvish nnoremap <silent> <buffer> dd :call DeleteItemUnderCursor()<CR>
	autocmd FileType dirvish nmap <silent> <buffer> p :call CopyPreviouslyYankedItemToCurrentDirectory()<CR>
	autocmd FileType dirvish nmap <silent> <buffer> P :call MovePreviouslyYankedItemToCurrentDirectory()<CR>
	autocmd FileType dirvish nmap <silent> <buffer> cc :call RenameItemUnderCursor()<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> t :call OpenTree('')<CR>
	autocmd FileType dirvish nnoremap <buffer> T :call OpenTree('df')<left><left><left>
	autocmd FileType dirvish nnoremap <silent> <buffer> <space> :Lcd \| e .<CR>
augroup end

" Web Browsing" -----------------------{{{
function! OpenWebUrl(firstPartOfUrl,...)
	let visualSelection = getpos('.') == getpos("'<") ? getline("'<")[getpos("'<")[2] - 1:getpos("'>")[2] - 1] : ''
	let finalPartOfUrl = ((a:0 == 0) ? visualSelection : join(a:000))
	let nbDoubleQuotes = len(substitute(finalPartOfUrl, '[^"]', '', 'g'))
	if nbDoubleQuotes > 0 && nbDoubleQuotes % 2 != 0
		let finalPartOfUrl.= ' "'
	endif
	let finalPartOfUrl = substitute(finalPartOfUrl, '^\s*\(.\{-}\)\s*$', '\1', '')
	let finalPartOfUrl = substitute(finalPartOfUrl, '"', '\\"', 'g')
	let url = a:firstPartOfUrl . finalPartOfUrl
	let url = escape(url, '%#')
	silent! execute '! start firefox "" "' . url . '"'
endfun
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
nnoremap <Leader>q :Google <C-R>=&ft<CR> 
vnoremap <Leader>q :Google<CR>

" Snippets" ---------------------------{{{
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

" Dashboard" --------------------------{{{
function! OpenDashboard()
	silent tab G
	call settabvar(tabpagenr(),'is_dashboard',1)
	normal gu
	exec('silent '.winheight(0)/4.'split ' . $desktop.'/todo')
	exec('silent vnew ' . $desktop.'/done')
	exec('silent vnew ' . $desktop.'/achievements')
	wincmd k
	GvimTweakSetAlpha 180
	redraw | echo 'You are doing great <3'
endfunction
nnoremap <silent> <Leader>m :call OpenDashboard()<CR>
let g:alpha = get(g:, 'g:alpha', gvimtweak#window_alpha)

augroup dashboard
	au!
	autocmd TabLeave * if get(t:,'is_dashboard', 0) | GvimTweakSetAlpha g:alpha | redraw | echo 'Back to work already? Alright!' | endif
	autocmd TabEnter * if get(t:,'is_dashboard', 0) | let g:alpha = gvimtweak#window_alpha | GvimTweakSetAlpha 140 | endif
	autocmd FileType fugitive,git nnoremap <buffer> <LocalLeader>m :Git push --force-with-lease<CR>
	autocmd FileType fugitive,git nnoremap <buffer> <LocalLeader>l :silent! Glog! 
	autocmd FileType fugitive     nmap <silent> <buffer> <space> =
	autocmd FileType fugitive     nmap <silent> <buffer> <leader>s s
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>l <C-W>l
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>h <C-W>h
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>j <C-W>j
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>k <C-W>k
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>n gt
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>p gT
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>o :only<CR>
	autocmd FileType          git nmap <silent> <buffer> l <CR>
	autocmd FileType          git nnoremap <silent> <buffer> h <C-O>
	autocmd BufEnter     todo,done,achievements set buftype=nofile nowrap
	autocmd BufEnter     todo,done,achievements cnoremap <buffer> w set buftype=<CR>:w
	autocmd BufWritePost todo,done,achievements set buftype=nofile
	autocmd BufEnter     todo,done,achievements normal! gg
	autocmd BufLeave     todo,done,achievements normal! gg
	autocmd BufEnter     todo,done,achievements redraw | echo 'You are doing great <3'
	autocmd BufWritePost todo                   redraw | echo 'Nice :)'
	autocmd BufWritePost      done              redraw | echo 'Good job! :D'
	autocmd BufWritePost           achievements redraw | echo 'You did great ;)'
	autocmd BufEnter     todo,done,achievements inoremap <buffer> <Esc> <Esc>:set buftype=<CR>:w<CR>
	autocmd BufEnter     todo,done,achievements inoremap <buffer> <Esc> <Esc>:set buftype=<CR>:w<CR> 
	autocmd BufEnter     todo,done,achievements nnoremap <buffer> dd dd:set buftype=<CR>:w<CR> 
	autocmd BufEnter     todo,done,achievements nnoremap <buffer> p p:set buftype=<CR>:w<CR> 
	autocmd BufEnter     todo,done,achievements nnoremap <buffer> P P:set buftype=<CR>:w<CR> 
augroup end

" Diagrams"----------------------------{{{
function! CreateDiagramFile()
	let extension = 'puml_'
	let diagramtype = trim(input ('Diagram type? ([g]raph, [s]equence, [a]ctivity, [m]indmap, [c]lass, [C]omponent, [e]ntities, [S]tate, [u]secase, [w]orkbreakdown):'))
	if diagramtype == ''
		return
	elseif trim(diagramtype) == 'g'
		let extension = 'dot'
	elseif trim(diagramtype) == 's'
		let extension .= 'sequence'
	elseif trim(diagramtype) == 'a'
		let extension .= 'activity'
	elseif trim(diagramtype) == 'm'
		let extension .= 'mindmap'
	elseif trim(diagramtype) == 'c'
		let extension .= 'class'
	elseif trim(diagramtype) == 'C'
		let extension .= 'component'
	elseif trim(diagramtype) == 'e'
		let extension .= 'entities'
	elseif trim(diagramtype) == 'S'
		let extension .= 'state'
	elseif trim(diagramtype) == 'u'
		let extension .= 'usecase'
	elseif trim(diagramtype) == 'w'
		let extension .= 'workbreakdown'
	else
		return
	endif
	let filename = input('Title:')
	if trim(filename) == ''
		return
	elseif !empty(glob(filename.'.'.extension))
		redraw
		echomsg printf('"%s" already exists.', filename.'.'.extension)
		return
	endif
	let cmd = printf(':!start /b copy /y NUL "%s" >NUL', filename.'.'.extension)
	silent execute(cmd)
	normal R
	silent exec(printf('/\<%s\>', filename))
	nohlsearch
endfunction

function! CompileDiagramAndShowImage(outputExtension)
	let input=expand('%:p')
	let output=fnamemodify(input, ':r').'.'.a:outputExtension
	let cmd=''
	if expand('%:e') != 'dot'
		let cmd = printf('!plantuml -t%s -config "%s" "%s"', a:outputExtension, $HOME.'/Desktop/setup/my_skinparam.txt',input)
	else ".dot file
		if a:outputExtension == 'txt'
			let output=fnamemodify(input, ':r').'.atxt'
			let cmd = printf('!graph-easy --from=graphviz --as=ascii --output %s %s',output,input)
		else
			let cmd = printf('!dot -T%s "%s" -o "%s"', a:outputExtension, input, output)
		endif
	endif
	exec cmd
	redraw
	if (a:outputExtension == 'txt')
		exec('split '.output)
	else
		call OpenWebUrl('',output)
	endif
endfunction
command! -nargs=1 CompileDiagramAndShowImage call CompileDiagramAndShowImage(<f-args>)

augroup mydiagrams
	autocmd!
	autocmd BufRead *.dot                  set ft=dot
	autocmd BufRead *.puml                 set ft=plantuml
	autocmd BufRead *.puml_activity        set ft=plantuml_activity
	autocmd BufRead *.puml_class           set ft=plantuml_class
	autocmd BufRead *.puml_component       set ft=plantuml_component
	autocmd BufRead *.puml_entities        set ft=plantuml_entities
	autocmd BufRead *.puml_mindmap         set ft=plantuml_mindmap
	autocmd BufRead *.puml_sequence        set ft=plantuml_sequence
	autocmd BufRead *.puml_state           set ft=plantuml_state
	autocmd BufRead *.puml_usecase         set ft=plantuml_usecase
	autocmd BufRead *.puml_workbreakdown   set ft=plantuml_workbreakdown
	autocmd FileType dot,plantuml_sequence,
                  \plantuml_activity,plantuml_component,plantuml_component,
                  \plantuml_entities,plantuml_mindmap,plantuml_sequence,
                  \plantuml_state,plantuml_usecase,plantuml_workbreakdown
	                                      \silent nnoremap <buffer> <Leader>w :silent w \| CompileDiagramAndShowImage png<CR>
	autocmd FileType dot,plantuml_sequence silent nnoremap <buffer> <Leader>W :silent w \| CompileDiagramAndShowImage txt<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> D :call CreateDiagramFile()<CR>
augroup END

" Specific Workflows:------------------{{{
" cs(c#)" -----------------------------{{{
let g:OmniSharp_server_path = $desktop . '/tools/omnisharp/OmniSharp.exe'
let $DOTNET_NEW_LOCAL_SEARCH_FILE_ONLY=1
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
let originalwinid = win_getid()
let sln_dir = fnamemodify(omnisharp_host.sln_or_dir, isdirectory(omnisharp_host.sln_or_dir) ? ':p' : ':h:p')
	setlocal errorformat=%f(%l\\,%c):\ error\ MSB%n:\ %m\ [%.%#
	setlocal errorformat+=%f(%l\\,%c):\ error\ CS%n:\ %m\ [%.%#
	setlocal errorformat+=%-G%.%#
	setlocal makeprg=dotnet\ build\ /p:GenerateFullPaths=true\ /clp:NoSummary
	echomsg 'Building...'
	execute(printf('lcd %s | silent make!',sln_dir))
	redraw
	if IsQuickFixWindowOpen()
		call win_gotoid(originalwinid)
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
	setlocal makeprg=dotnet\ test\ --nologo
	echomsg '           Testing...'
	execute(printf('lcd %s | silent make!',sln_dir))
	redraw
	call win_gotoid(originalwinid)
endfunction
augroup csharpfiles
	au!
	autocmd FileType cs nnoremap <silent> <LocalLeader>m :call CSharpBuild()<CR>
	autocmd FileType cs nnoremap <silent> <LocalLeader>M :!dotnet run -p Startup<CR>
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
	\ 'ClassName': 'Float',
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

function! DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call DiffWithSaved()

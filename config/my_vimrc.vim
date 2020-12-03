let g:isWindows = has('win32')
let g:isWsl = isdirectory('/mnt/c/Windows')
if !g:isWindows && !g:isWsl
	echoerr 'Only Windows and WSL are handled by this vimrc for now.'
	finish
endif



if g:isWindows
	let $desktop    = $HOME.'/Desktop'
	let $rcfolder   = $VIM
	let $rcfilename = '_vimrc'
	let $packpath   = $VIM
elseif g:isWsl
	let $desktop    = $HOME
 let $rcfolder   = $HOME
	let $rcfilename = '.vimrc'
	let $packpath   = $HOME.'/.vim'
endif

" Desktop Integration:-----------------{{{
" Plugins" ----------------------------{{{
function! MinpacInit()
	packadd minpac
	call minpac#init( {'dir':$packpath, 'package_name': 'plugins', 'progress_open': 'none' } )
	call minpac#add('editorconfig/editorconfig-vim')
	call minpac#add('dense-analysis/ale')
	call minpac#add('junegunn/fzf.vim')
	call minpac#add('itchyny/lightline.vim')
	call minpac#add('itchyny/vim-gitbranch')
	call minpac#add('OmniSharp/omnisharp-vim')
	call minpac#add('puremourning/vimspector')
	call minpac#add('nickspoons/vim-sharpenup')
	call minpac#add('SirVer/ultisnips')
	call minpac#add('honza/vim-snippets')
	call minpac#add('justinmk/vim-dirvish')
	call minpac#add('tpope/vim-dadbod')
	call minpac#add('tpope/vim-surround')
	call minpac#add('godlygeek/tabular')
	call minpac#add('tpope/vim-fugitive')
	call minpac#add('tpope/vim-obsession')
	call minpac#add('ap/vim-css-color')
	call minpac#add('wellle/targets.vim')
	call minpac#add('Melandel/vim-empower')
	call minpac#add('Melandel/fzfcore.vim')
	call minpac#add('Melandel/gvimtweak')
endfunction
command! -bar MinPacInit call MinpacInit()
command! -bar MinPacUpdate call MinpacInit()| call minpac#clean()| call minpac#update()
let loaded_netrwPlugin = 1 " do not load netrw

" First time" -------------------------{{{
if !isdirectory($packpath.'/pack/plugins')
	call system('git clone https://github.com/k-takata/minpac.git ' . $packpath . '/pack/packmanager/opt/minpac')
	call MinpacInit()
	call minpac#update()
	packloadall
endif

" Duplicated/Generated files" ---------{{{
augroup duplicatefiles
	au!
	au BufWritePost my_keyboard.ahk exec '!Ahk2Exe.exe /in %:p /out '.$desktop.'\myAzertyKeyboard.RunMeAsAdmin.exe'
augroup end

" General:-----------------------------{{{
" Settings" ---------------------------{{{
syntax on
filetype plugin indent on
silent! language messages English_United states
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
set directory=$desktop/tmp/vim
set backup
set backupdir=$desktop/tmp/vim
set undofile
set undodir=$desktop/tmp/vim
set viewdir=$desktop/tmp/vim
set history=200
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
" Windows Subsystem for Linx (WSL)
set ttimeout ttimeoutlen=0
if &term =~ '^xterm'
  autocmd VimEnter * silent !echo -ne "\e[0 q"
  let &t_EI .= "\<Esc>[0 q"
  let &t_SI .= "\<Esc>[5 q"
  " 1 or 0 -> blinking block
  " 2 -> solid block
  " 3 -> blinking underscore
  " 4 -> solid underscore
  " Recent versions of xterm (282 or above) also support
  " 5 -> blinking vertical bar
  " 6 -> solid vertical bar
  autocmd VimLeave * silent !echo -ne "\e[5 q"
endif

if g:isWsl
	augroup WSLYank
		autocmd!
		autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/mnt/c/Windows/System32/clip.exe', @0) | endif
	augroup END
endif

" Tabs and Indentation" ---------------{{{
set smartindent
set tabstop=1
set shiftwidth=1
command! -bar Spaces2Tabs set noet ts=4 |%retab!|set ts=1

" Leader keys" ------------------------{{{
let mapleader = 's'
let maplocalleader = 'q'

" Local Current Directories" ----------{{{
let g:lcd_qf = getcwd()

function! GetInterestingParentDirectory()
	if IsOmniSharpRelated()
		return fnamemodify(b:OmniSharp_host.sln_or_dir, isdirectory(b:OmniSharp_host.sln_or_dir) ? ':p' : ':p:h')
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
		exec 'lcd' dir
	endif
endfunction
command! -bar Lcd call UpdateLocalCurrentDirectory()

augroup lcd
	au!
	autocmd BufEnter * if &ft!='dirvish' | Lcd | else | lcd %:p:h | endif
	autocmd QuickFixCmdPre * let g:lcd_qf = getcwd()
augroup end

" Utils"-------------------------------{{{
function! BufferIsEmpty()
	return line('$') == 1 && getline(1) == ''
endfunction

function! DeleteEmptyScratchBuffers()
    let buffers = filter(range(1, bufnr('$')), 'getbufvar(v:val, "&bt")=="nofile" && len(getbufline(v:val, 1, "$")) == 1 && empty(getbufline(v:val, 1)[0])')
    if !empty(buffers)
        exec 'bw' join(buffers, ' ')
    endif
endfunction

function! IsQuickFixWindowOpen()
	return len(filter(range(1, winnr('$')), {_,x -> getwinvar(x, '&syntax') == 'qf'}))
endfunction

function! IsInsideGitClone()
	return gitbranch#dir(expand('%:p')) != ''
endfunction

function! IsOmniSharpRelated()
	return exists('b:OmniSharp_host.sln_or_dir')
endfunction

function! PreviousCharacter()
	return strcharpart(getline('.')[col('.') - 2:], 0, 1)
endfunction

function! GetCurrentSelection()
	return getpos('.') == getpos("'<") ? getline("'<")[getpos("'<")[2]-1 : getpos("'>")[2]-1] : ''
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
command! ClearTrailingWhiteSpaces call ClearTrailingWhiteSpaces()

function! OmnifunctionExample(findstart, base)
	if a:findstart
		return col('.')
	endif
	let previouschar = PreviousCharacter()
	if previouschar == '@'
		return ['workflow', 'planned', 'improvement', 'emergency']
	elseif previouschar == '+'
  let hits = []
		call substitute(join(readfile($desktop.'/todo')), '\v\+(\S)+', '\=len(add(hits, submatch(0))) ? submatch(0) : ""', 'gne')
		call substitute(join(readfile($desktop.'/done')), '\v\+(\S)+', '\=len(add(hits, submatch(0))) ? submatch(0) : ""', 'gne')
		return map(uniq(sort(hits)), {_,x->x[1:]})
	endif
	return ['toto', previouschar]
endfunction

function! JobStartExample(...)
	let cmd = a:0 ? (a:1 != '' ? a:1 : 'dir') : 'dir'
	let scratchbufnr = ResetScratchBuffer($desktop.'tmp/Job')
	echomsg "<start> ".cmd
	if g:isWindows
		let cmd = 'cmd /C '.cmd
	endif
	let s:job = job_start(
		\cmd,
		\{
			\'cwd': getcwd(),
			\'out_io': 'buffer',
			\'out_buf': scratchbufnr,
			\'out_modifiable': 1,
			\'err_io': 'buffer',
			\'err_buf': scratchbufnr,
			\'err_modifiable': 1,
			\'in_io': 'null',
			\'callback': { chan,msg  -> execute('echo ''[cb] '.substitute(msg,"'","''","g").'''',  1)},
			\'close_cb': { chan      -> execute('echomsg "[close] '.chan.'"', 1)},
			\'exit_cb':  { job,status-> execute('echomsg "[exit] '.status.'" | botright sbuffer '.scratchbufnr, '')}
		\}
	\)
endfunction
command! -nargs=* Start call JobStartExample(<q-args>)

function! WinTextWidth()
    let winwidth = winwidth(0)
    let winwidth -= (max([len(line('$')), &numberwidth]) * (&number || &relativenumber))
    let winwidth -= &foldcolumn
    redir => signs
    execute 'silent sign place buffer=' . bufnr('%')
    redir END
    if signs !~# '^\n---[^\n]*\n$'
        let winwidth -= 2
    endif
    return winwidth
endfunction

function! LineCount(...)
    let startlnr = get(a:000, 0, 1)
    let endlnr = get(a:000, 1, line('$'))
    let numlines = 0
    let winwidth = WinTextWidth()
    for lnr in range(startlnr, endlnr)
        let lwidth = strdisplaywidth(getline(lnr))
        let numlines += max([(lwidth - 1) / winwidth + 1, 1])
    endfor
    return numlines
endfunction

function! ResetScratchBuffer(path)
	silent! exec 'bdelete!' bufnr(a:path)
	let bufnr = bufadd(a:path)
	call setbufvar(bufnr, '&bufhidden', 'hide')
	call setbufvar(bufnr, '&buftype', 'nofile')
	call setbufvar(bufnr, '&buflisted', 1)
	call setbufvar(bufnr, '&list', 0)
	call setbufvar(bufnr, '&wrap', 0)
	return bufnr
endfunction

function! PromptUserForFilename(requestToUser, ...)
	let title = input(a:requestToUser)
	let ComputeFinalPath = a:0 ? a:1 : { x -> x }
	let GetRetryMessage = { x -> a:0 > 0 ? a:1 : printf('[%s] already exists. %s', x, a:requestToUser) }
	while title != '' && len(glob(ComputeFinalPath(title))) > 0
		redraw | let title= input(GetRetryMessage(title))
	endwhile
	redraw
	return title
endfunction

function! WindowsPath(path)
	return has('win32') ? shellescape(substitute(a:path, '/', '\', 'g')) : a:path
endfunction

function! Alert(text)
	let winid = popup_create(a:text, #{border:[], borderhighligh:'Constant', padding: [], time:10000, close:'button'})
endfunction

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

" Close Buffers
function! DeleteHiddenBuffers()" ------{{{
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
	if getbufvar(buf, '&mod') == 0
	  silent exec 'bwipeout' buf
	  let closed += 1
	endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction
nnoremap <Leader>c :silent! call DeleteHiddenBuffers()<CR>:ls<CR>

" Open/Close Window or Tab
command! -bar Enew    exec(' enew | call DeleteEmptyScratchBuffers() | setlocal buftype=nofile bufhidden=hide noswapfile| silent lcd '.$desktop.'/tmp')
command! -bar New     call SplitWindow(0)
command! -bar Vnew    call SplitWindow(1)
nnoremap <silent> <Leader>s :New<CR>
nnoremap <silent> <Leader>v :Vnew<CR>
nnoremap <silent> K :q<CR>
nnoremap <silent> <Leader>o <C-W>_<C-W>\|
nnoremap <silent> <Leader>O mW:tabnew<CR>`W
nnoremap <silent> <Leader>x :if !IsDebuggingTab() \| tabclose \| else \| unlet g:vimspector_session_windows.tabpage \| call vimspector#Reset() \| endif<CR>

function! ComputeRemainingHeight()
	let screenrow = screenrow()
	let res = &lines - screenrow - min([line('$')-line('.'), winheight(0)-winline()]) - (&cmdheight+1)
	return res
endfunction

function! SplitWindow(isVertical)
	let useRemainingSpace = 0
	let bufferHistory = get(w:, 'buffers', [])
	if a:isVertical
		vsplit
	else
		let minheight = 2
		let remainingheight = ComputeRemainingHeight()
		let useRemainingSpace = 0
		let currentwinnr = winnr()
		wincmd j
		if winnr() != currentwinnr
			call win_gotoid(win_getid(currentwinnr))
		else
			let useRemainingSpace = 1
			let remaininglines = getline('.', line('.')+remainingheight)
			let winwidth = WinTextWidth()
			let nbRemainingLinesRequiringWrapping = len(filter(remaininglines, { _,x -> len(x) > winwidth }))
			let remainingheight -= nbRemainingLinesRequiringWrapping
		endif
		let useRemainingSpace = useRemainingSpace && remainingheight > (minheight+1)
		if useRemainingSpace
			mark k
			normal! H
		endif
		exec (useRemainingSpace ? (remainingheight-1) : '').'split'
		if useRemainingSpace
			wincmd k
			normal! `k
			delmarks k
			wincmd j
		endif
	endif
	mark `
	let w:buffers = bufferHistory
	Enew
	call CycleWindowBuffersHistoryBackwards()
endfunction

" Browse to Window or Tab
nnoremap <silent> <Leader>h <C-W>h
nnoremap <silent> <Leader>j <C-W>j
nnoremap <silent> <Leader>k <C-W>k
nnoremap <silent> <Leader>l <C-W>l
nnoremap <silent> <Leader><home> 1<C-W>W
nnoremap <silent> <Leader><end> 99<C-W>W
nnoremap <silent> <Leader>n gt
nnoremap <silent> <Leader>N :tabnew<CR>
nnoremap <silent> <Leader>p gT
nnoremap <silent> <Leader>P :$tabnew<CR>

augroup windows
	autocmd!
	"
	" Use foldcolumn to give a visual clue for the current window
	autocmd WinLeave * if !pumvisible() | setlocal norelativenumber foldcolumn=0 | endif
	autocmd WinEnter * if !pumvisible() | setlocal relativenumber   foldcolumn=1 | endif
	" Safety net if I close a window accidentally
	autocmd QuitPre * mark K
	" Make sure Vim returns to the same line when you reopen a file.
 autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exec 'normal! g`"zvzz' | endif
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
	return printf('(#%s)', winnr())
endfunction

function! GitBranch()
	return printf('[%s:%s]', fnamemodify(gitbranch#dir(expand('%:p')), ':h:t'), gitbranch#name())
endfunction

function! FolderRelativePathFromGit()
	let filepath = expand('%:p')
	let folderpath = expand('%:p:h')
	let gitrootfolder = fnamemodify(gitbranch#dir(filepath), ':h:p')
	let foldergitpath = folderpath[len(gitrootfolder)+(has('win32')?1:0):]
	return '/' . substitute(foldergitpath, '\', '/', 'g')
endfunction
let sharpenupStatusLineScript = $packpath.'/pack/plugins/start/vim-sharpenup/autoload/sharpenup/statusline.vim'
if (glob(sharpenupStatusLineScript) != '') | exec 'source' sharpenupStatusLineScript | endif
let g:sharpenup_statusline_opts = { 'TextLoading': '<%s…>', 'TextReady': '<%s>', 'TextDead': '<>', 'Highlight': 0 }
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
	\    'mode': '0'
	\  },
	\ 'active':   {
	\    'left':  [
	\        [ 'mode', 'paste', 'readonly', 'modified' ],
	\        [ 'tabinfo', 'time' ]
	\    ],
	\    'right': [
	\        ['filename', 'readonly', 'modified' ],
	\        [ 'gitinfo', 'sharpenup' ]
	\    ]
	\ },
	\ 'inactive': {
	\    'left':  [
	\        ['winnr']
	\    ],
	\    'right': [
	\        [ 'filename', 'readonly', 'modified' ],
	\        [ 'gitinfo', 'sharpenup' ]
	\    ]
	\ }
	\}
let timer = timer_start(20000, 'UpdateStatusBar',{'repeat':-1})

function! UpdateStatusBar(timer)
  exec 'let &ro = &ro'
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
nnoremap <silent> <C-N> :call BrowseToNextParagraph()<CR>zz
nnoremap <silent> <C-P> :call BrowseToLastParagraph()<CR>zz

function! BrowseLayoutDown()
	if &diff
		silent! normal! ]czxzz
	elseif len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')) > 0
		silent! cnext
	elseif len(getloclist(winnr())) > 0
		ALENext
	endif
	silent! normal! zv
	normal! m'
endfunction
nnoremap <silent> <C-J> :call BrowseLayoutDown()<CR>

function! BrowseLayoutUp()
	if &diff
		silent! normal! [czxzz
	elseif len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')) > 0
		silent! cprev
	elseif len(getloclist(winnr())) > 0
		ALEPrevious
	endif
	silent! normal! zv
	normal! m'
endfunction
nnoremap <silent> <C-K> :call BrowseLayoutUp()<CR>

nnoremap <silent> <C-H> :cnfile<CR>
nnoremap <silent> <C-L> :cpfile<CR>
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

" Text objects" -----------------------{{{
vnoremap iz [zjo]zkVg_| onoremap iz :normal viz<CR>
vnoremap az [zo]zVg_|   onoremap az :normal vaz<CR>
vnoremap if ggoGV| onoremap if :normal vif<CR>
" Always add cursor position to jumplist
let g:targets_jumpRanges = 'cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb al rB Al bb aa bB Aa BB AA'

" Text Operations:---------------------{{{
" Visualization" ----------------------{{{
" select until end of line
nnoremap vv ^vg_
nnoremap <C-V><C-V> ^<C-V>
" remove or add a line to visualization
vnoremap <silent> <C-J> <C-V><esc>gvVojo
vnoremap <silent> <C-K> <C-V><esc>gvVoko

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
xmap ga :Tabular /
nmap ga :Tabular /
xnoremap gA :Tabular /\|<CR>
nnoremap gA vip:Tabular /\|<CR>

" Vim Core Functionalities:------------{{{
" Command Line"------------------------{{{
set cmdwinheight=40
set cedit=<C-S>
cnoremap !! Start

" Wild Menu" --------------------------{{{
set wildmenu
set wildcharm=<Tab>
set wildignorecase
set wildmode=full

" Expanded characters" ----------------{{{
" Folder of current file
cnoremap <expr> <C-F> (expand('%:h') != '' && stridx(getcmdline()[-1-len(expand('%:h')):], expand('%:h')) == 0 ? '**\*' : expand('%:h').(has('win32')?'\':'/'))
cnoremap <expr> <C-G> (stridx(getcmdline()[-1-len(GetInterestingParentDirectory()):], GetInterestingParentDirectory()) == 0 ? '**\*' : GetInterestingParentDirectory().(has('win32')?'\':'/'))

" Sourcing" ---------------------------{{{
" Run a line/selected text composed of vim script
vnoremap <silent> <Leader>S y:exec @@<CR>
nnoremap <silent> <Leader>S ^vg_y:exec @@<CR>
" Write output of a vim command in a buffer
nnoremap ç :let script=''\|call histadd('cmd',script)\|put=execute(script)<Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>
augroup vimsourcing
	au!
	if has('win32')
		autocmd BufWritePost .vimrc,_vimrc,*.vim GvimTweakToggleFullScreen | so % | GvimTweakToggleFullScreen
	else
		autocmd BufWritePost .vimrc,_vimrc,*.vim so %
	endif
	autocmd FileType vim nnoremap <buffer> z! :BLines function!\\|{{{<CR>
augroup end

" Find, Grep, Make, Equal" ------------{{{
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --no-ignore-parent\ --no-column\ \"$*\"
set switchbuf+=uselast
set errorformat=%m
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>F :GFiles?<CR>
nnoremap <Leader>r :Rg <C-R><C-W><CR>
vnoremap <Leader>r "vy:let cmd = printf('Rg! %s',@v)\|echo cmd\|call histadd('cmd',cmd)\|exec cmd<CR>
nnoremap <Leader>R :Rg 
nnoremap <LocalLeader>m :silent make<CR>

" Terminal" ---------------------------{{{
tnoremap <C-O> <C-W>N:setlocal norelativenumber number foldcolumn=0 nowrap<CR>zb

" Folding" ----------------------------{{{
vnoremap <silent> <space> <Esc>zE:let b:focus_mode=1 \| setlocal foldmethod=manual<CR>`<kzfgg`>jzfG`<
nnoremap <silent> <space> :if IsDebuggingTab() \| call vimspector#StepOver() \| else \| exec('normal! '.(b:focus_mode==1 ? 'zR' : 'zM')) \| let b:focus_mode=!b:focus_mode \| endif<CR>


set foldtext=FoldText()
function! FoldText()
	return v:folddashes.getline(v:foldstart)[len(v:folddashes)-1:].' ('.(v:foldend-v:foldstart+1).'rows)'
endfunction
" Search" -----------------------------{{{
set hlsearch
set incsearch
set ignorecase
" Display '1 out of 23 matches' when searching
set shortmess=filnxtToOc
nnoremap ! /
vnoremap ! /
nnoremap q! q/
nnoremap / :Lines<CR>

nnoremap z! :BLines<CR>
command! UnderlineCurrentSearchItem silent call matchadd('ErrorMsg', '\c\%#'.@/, 101)
nnoremap <silent> n :keepjumps normal! n<CR>:UnderlineCurrentSearchItem<CR>
nnoremap <silent> N :keepjumps normal! N<CR>:UnderlineCurrentSearchItem<CR>
nnoremap <silent> * :call ExecuteAndAddIntoSearchHistory('<C-R>='\V'.expand('<cword>')<CR>')<CR>
vnoremap <silent> * "vy:call ExecuteAndAddIntoSearchHistory('<C-R>='\V'.@v<CR>')<CR>

function! CopyAllMatches(...)
  let reg= a:0 ? a:1 : '+'
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  exec 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -nargs=? CopyAllMatches :call CopyAllMatches(<f-args>)

" Sort" -------------------------------{{{
function! SortLinesByLength() range
	let range = a:firstline.','.a:lastline
	silent exec range 's/.*/\=printf("%03d", len(submatch(0)))."|".submatch(0)/'
	exec range 'sort n'
	silent exec range 's/..../'
	nohlsearch
endfunction
command! -range=% SortByLength <line1>,<line2>call SortLinesByLength()

" Autocompletion (Insert Mode)" -------{{{
set completeopt+=menuone,noselect,noinsert
let g:UltiSnipsExpandTrigger = "<nop>"
let g:UltiSnipsJumpForwardTrigger="<nop>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="horizontal"

function! AsyncCompletion()
	return pumvisible() ? '' : ForceAsyncCompletion()
endfunction

function! ForceAsyncCompletion()
	return "\<C-X>".(&omnifunc!='' ? "\<C-O>" : "\<C-N>")
endfunction

	inoremap <expr> a 'a'.AsyncCompletion()
	inoremap <expr> b 'b'.AsyncCompletion()
	inoremap <expr> c 'c'.AsyncCompletion()
	inoremap <expr> d 'd'.AsyncCompletion()
	inoremap <expr> e 'e'.AsyncCompletion()
	inoremap <expr> f 'f'.AsyncCompletion()
	inoremap <expr> g 'g'.AsyncCompletion()
	inoremap <expr> h 'h'.AsyncCompletion()
	inoremap <expr> i 'i'.AsyncCompletion()
	inoremap <expr> j 'j'.AsyncCompletion()
	inoremap <expr> k 'k'.AsyncCompletion()
	inoremap <expr> l 'l'.AsyncCompletion()
	inoremap <expr> m 'm'.AsyncCompletion()
	inoremap <expr> n 'n'.AsyncCompletion()
	inoremap <expr> o 'o'.AsyncCompletion()
	inoremap <expr> p 'p'.AsyncCompletion()
	inoremap <expr> q 'q'.AsyncCompletion()
	inoremap <expr> r 'r'.AsyncCompletion()
	inoremap <expr> s 's'.AsyncCompletion()
	inoremap <expr> t 't'.AsyncCompletion()
	inoremap <expr> u 'u'.AsyncCompletion()
	inoremap <expr> v 'v'.AsyncCompletion()
	inoremap <expr> w 'w'.AsyncCompletion()
	inoremap <expr> x 'x'.AsyncCompletion()
	inoremap <expr> y 'y'.AsyncCompletion()
	inoremap <expr> z 'z'.AsyncCompletion()
augroup autocompletion
	au!
	autocmd User UltiSnipsEnterFirstSnippet mark '
	autocmd FileType cs inoremap <expr> . '.'.ForceAsyncCompletion()
augroup end

inoremap <C-I> <C-R>=ExpandSnippetOrValidateAutocompletionSelection()<CR>
xnoremap <C-I> :call UltiSnips#SaveLastVisualSelection()<cr>gvs
snoremap <C-I> <esc>:call UltiSnips#ExpandSnippetOrJump()<CR>
nnoremap <Leader>u :UltiSnipsEdit!<CR>G
nnoremap <Leader>U :call UltiSnips#RefreshSnippets()<CR>
inoremap <C-O> <C-X><C-O>

function! CompleteFuncTodo(findstart, base)
	if a:findstart
		let line = getline('.')
		return min(filter([match(line, '\a'), match(line, '\d')], { _,x -> x != -1 }))
	endif
	return map(['✗', '✓'], { _,x -> x.' '.trim(a:base, ' \t✗✓+*') })
endfunction
set completefunc=CompleteFuncTodo


function! ExpandSnippetOrValidateAutocompletionSelection()
	if col('.') == 1
		return "\<C-I>"
	endif
	if !pumvisible()
		let g:ulti_expand_or_jump_res = 0
		call UltiSnips#ExpandSnippetOrJump()
		return g:ulti_expand_or_jump_res > 0 ? '' : PreviousCharacter() =~ '\S' ? "\<C-N>" : "\<C-I>"
	else
		echomsg 'selected' complete_info(['selected'])
		let completionstate = complete_info(['selected', 'items'])
		if completionstate.selected != -1
			return "\<C-Y>"
		elseif empty(UltiSnips#SnippetsInCurrentScope())
			return "\<C-N>\<C-Y>"
		else
			let g:ulti_expand_or_jump_res = 0
			call UltiSnips#ExpandSnippetOrJump()
			return g:ulti_expand_or_jump_res > 0 ? '' : "\<C-N>\<C-Y>"
		endif
	endif
endfunction

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
	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
	autocmd QuickFixCmdPost	l* nested lwindow
	autocmd FileType nofile nnoremap <buffer> K :bd!<CR>
augroup end

function! QuickFixVerticalAlign(info)
	if a:info.quickfix
		let qfl = getqflist({'id': a:info.id, 'items': 0}).items
	else
		let qfl = getloclist(a:info.winid, {'id': a:info.id, 'items': 0}).items
	endif
	let l = []
	let efm_type = {'e': 'error', 'w': 'warning', 'i': 'info', 'n': 'note'}
	let lnum_width =   len(max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), { _,v -> qfl[v].lnum })))
	let col_width =    len(max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), {_, v -> qfl[v].col})))
	let fname_width =  max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), {_, v -> strchars(fnamemodify(bufname(qfl[v].bufnr), ':t'), 1)}))
	let type_width =   max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), {_, v -> strlen(get(efm_type, qfl[v].type, ''))}))
	let errnum_width = len(max(map(range(a:info.start_idx - 1, a:info.end_idx - 1),{_, v -> qfl[v].nr})))
	for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
		let e = qfl[idx]
		if !e.valid
			call add(l, '|| ' .. e.text)
		else
			if e.lnum == 0 && e.col == 0
				call add(l, bufname(e.bufnr))
			else
				let fname = fnamemodify(printf('%-*S', fname_width, bufname(e.bufnr)), ':t')
				let lnum = printf('%*d', lnum_width, e.lnum)
				let col = printf('%*d', col_width, e.col)
				let type = printf('%-*S', type_width, get(efm_type, e.type, ''))
				let errnum = ''
				if e.nr
					let errnum = printf('%*d', errnum_width + 1, e.nr)
				endif
				call add(l, printf('%s|%s col %s %s%s| %s', fname, lnum, col, type, errnum, e.text))
			endif
		endif
	endfor
	return l
endfunction
set quickfixtextfunc=QuickFixVerticalAlign

" Marks"-------------------------------{{{
" H and L are used for cycling between buffers and `A is a pain to type
nnoremap M `

" Changelist"--------------------------{{{
nnoremap g; g;zv
nnoremap g, g,zv

" Additional Functionalities:----------{{{
" Buffer navigation"-------------------{{{
nnoremap <silent> H :call CycleWindowBuffersHistoryBackwards()<CR>
nnoremap <silent> L :call CycleWindowBuffersHistoryForward()<CR>

" Fuzzy Finder"------------------------{{{
" Makes Omnishahrp-vim code actions select both two elements
"let g:fzf_layout = { 'window': { 'width': 0.39, 'height': 0.25 } }
"let g:fzf_preview_window = []
let $FZF_DEFAULT_OPTS="--expect=ctrl-t,ctrl-v,ctrl-x,ctrl-j,ctrl-k,ctrl-o,ctrl-b --bind up:preview-up,down:preview-down"

augroup my_fzf"------------------------{{{
	au!
	autocmd FileType fzf tnoremap <buffer> <C-V> <C-V>
	autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
	autocmd FileType fzf tnoremap <buffer> <C-J> <C-J>
	autocmd FileType fzf tnoremap <buffer> <C-K> <C-K>
	autocmd FileType fzf tnoremap <buffer> <C-O> <C-T>
augroup end

function! Edit(lines)"-----------------{{{
	if len(a:lines) < 2 | return | endif
	let file_or_dir = a:lines[1]
	echomsg file_or_dir
	if file_or_dir =~ '^projects/'
		let g:last_opened_project = file_or_dir
	endif
	if file_or_dir =~ '^(current folder) '
		let file_or_dir = expand('%:h:p')
	elseif file_or_dir == 'tools'
		let file_or_dir = isdirectory('tools') ? $desktop.'/tools' : '/usr/local/src'
	elseif glob(file_or_dir) == ''
		if glob($desktop.'/'.file_or_dir) != ''
			let file_or_dir = $desktop.'/'.file_or_dir
		elseif glob($HOME.'/'.file_or_dir) != ''
			let file_or_dir = $HOME.'/'.file_or_dir
		elseif glob($rcfolder.'/'.file_or_dir) != ''
			let file_or_dir = $rcfolder.'/'.file_or_dir
		elseif glob($packpath.'/pack/plugins/start/'.file_or_dir) != ''
			let file_or_dir = $packpath.'/pack/plugins/start/'.file_or_dir
		endif
	endif
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
	exec cmd file_or_dir
endfunction

function! Explore()
	let original_lcd = getcwd()
	let source = []
	lcd $desktop
	let source += expand('tmp/*',      0, 1)
	let source += expand('notes/*',    0, 1)
	let source += expand('snippets/*', 0, 1)
	let source += expand('templates/*',0, 1)
	let source += expand('setup/*',    0, 1)
	if isdirectory('tools')
		let source += expand('tools/*',    0, 1)
	endif
	let source += expand('projects/*', 0, 1)
	call add(source, map(filter(keys(get(g:,'csprojs2sln',{})), {_,x->isdirectory(x)}), { _,x -> fnamemodify(x, ':.') }))
	call add(source, map(filter(systemlist('git ls-files'), {_,x->x !~ 'my_vimrc.vim'}), { _,x -> fnamemodify(x, ':.') }))
	lcd $packpath/pack/plugins/start
	call add(source, [expand('*', 0, 1)])
	let source = uniq(sort(flatten(source)))
	let source = ['(current folder) '.expand('%:h:p'), $rcfilename] + (isdirectory($HOME.'/Desktop') ? ['Downloads', 'Desktop'] : []) + ['tmp', 'notes', 'snippets', 'templates', 'config', 'tools', 'projects'] + source
	let source = map(source, { _,x -> substitute(x, '\', '/', 'g') })
	exec 'lcd' (has('win32') ? shellescape(original_lcd) : original_lcd)
	call fzf#run(fzf#wrap({'source': source,'sink*': function('Edit'), 'options': ['--expect', 'ctrl-t,ctrl-v,ctrl-x,ctrl-j,ctrl-k,ctrl-o,ctrl-b','--prompt', 'Explore> ']}))
endfunction
command! Explore call Explore()
nnoremap <leader>e :Explore<CR>
nnoremap <silent> <leader>E :edit $desktop/<C-R>=g:last_opened_project<CR><CR>
nnoremap <leader>g :Commits<CR>
nnoremap <leader>G :BCommits<CR>
nnoremap q, :History<CR>
nnoremap q; :Buffers<CR>

" Window buffer navigation"------------{{{
augroup cycleWindowBuffer
	au!
	autocmd BufEnter * call AddCurrentBufferToWindowBufferList()
augroup end

function! AddCurrentBufferToWindowBufferList()
	let w:buffers = get(w:, 'buffers', [])
	let w:skip_tracking_buffers = get(w:, 'skip_tracking_buffers', 0)
	if w:skip_tracking_buffers | return | endif
	let bufnr = bufnr('%')
	let existing_pos = index(w:buffers, bufnr)
	if existing_pos == -1
		call add(w:buffers, bufnr)
	else
		let before = existing_pos == 0 ? [] : copy(w:buffers[:existing_pos-1])
		let after = existing_pos == len(w:buffers)-1 ? [] : copy(w:buffers[existing_pos+1:])
		let element = copy(w:buffers[existing_pos])
		let w:buffers = before + after + [element]
	endif
endfunction

function! CycleWindowBuffersHistoryForward()
	let w:buffers = w:buffers[1:] + [w:buffers[0]]
	let w:skip_tracking_buffers = 1
	while !bufexists(w:buffers[-1])
		call remove(w:buffers, -1)
	endwhile
	exec 'buffer' w:buffers[-1]
	let w:skip_tracking_buffers = 0
endfunction

function! CycleWindowBuffersHistoryBackwards()
	let w:buffers = [w:buffers[-1]] + w:buffers[:-2]
	let w:skip_tracking_buffers = 1
	while !bufexists(w:buffers[-1])
		call remove(w:buffers, -1)
	endwhile
	exec 'buffer' w:buffers[-1]
	let w:skip_tracking_buffers = 0
endfunction

" Full screen" ------------------------{{{
let g:gvimtweak#window_alpha=255 " alpha value (180 ~ 255) default: 245
let g:gvimtweak#enable_alpha_at_startup=1
let g:gvimtweak#enable_topmost_at_startup=0
let g:gvimtweak#enable_maximize_at_startup=1
let g:gvimtweak#enable_fullscreen_at_startup=1
nnoremap <silent> ° :GvimTweakToggleFullScreen<CR>
nnoremap <silent> <A-n> :GvimTweakToggleTransparency<CR>
nnoremap <silent> <A-i> :GvimTweakSetAlpha -10<CR>| tmap <silent> <A-o> <C-W>N:GvimTweakSetAlpha -10<CR>i
nnoremap <silent> <A-o> :GvimTweakSetAlpha 10<CR>| tmap <silent> <A-i> <C-W>N:GvimTweakSetAlpha 10<CR>i

" File explorer (graphical)" ----------{{{
function! IsPreviouslyYankedItemValid()
	return @d != ''
endfunction

function! PromptUserForRenameOrSkip(filename)
	let rename_or_skip = input(a:filename.' already exists. Rename it or skip operation?(r/S) ')
	if rename_or_skip != 'r'
		return ''
	endif
	let newname = input('New name:', a:filename)
	while glob(newname) != ''
		redraw | let newname = input(printf('[%s] already exists. %s', newname, 'Rename into:'), a:filename)
	endwhile
	return newname
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
	if glob(item_filename) != ''
		let item_finalname = PromptUserForRenameOrSkip(item_filename) | redraw
		if item_finalname == ''
			return
		endif
	endif
	if has('win32')
		if cwd == item_folder
			let cmd = printf( (isdirectory(item)? 'xcopy %s %s /E /I' : 'copy %s %s'), WindowsPath(item), item_finalname)
		else
			let cmd = 'robocopy '
			if isdirectory(item)
				let cmd .= printf('/e "%s" "%s\%s"', WindowsPath(item), cwd, item_finalname)
			else
				let cmd .= printf('"%s" "%s" "%s"', WindowsPath(item_folder), cwd, item_finalname)
			endif
			silent exec '!start /b' cmd
		endif
	else
		let item = '/'.item
		let cmd = printf('cp '.(isdirectory(item)?'-r ':'').'%s %s', item, item_finalname)
		silent exec '!'.cmd '&' | redraw!
	endif
endfunction

function! DeleteItemUnderCursor()
	let target = trim(getline('.'), '/\')
	let filename = fnamemodify(target, ':t')
	if has('win32')
		let cmd = (isdirectory(target)) ?  printf('rmdir "%s" /s /q',target) : printf('del "%s"', target)
		silent exec '!start /b' cmd
	else
		let target = '/'.target
		let cmd = (isdirectory(target)) ?  printf('rm -r "%s"',target) : printf('rm "%s"', target)
		silent exec '!'.cmd '&' | redraw!
	endif
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
	if has('win32')
		let cmd = printf('move "%s" "%s\%s"', item, cwd, item_finalname)
		silent exec '!start /b' cmd
		normal R
		exec '/'.escape(getcwd(), '\').'\\'.item_finalname.'$'
	nohlsearch
	else
		let item = '/'.item
		let cmd = printf('mv "%s" "%s/%s"', item, cwd, item_finalname)
		silent exec '!'.cmd '&' | redraw!
		normal R
		exec '/'.escape(getcwd(), '/').'\/'.item_finalname.'$'
		nohlsearch
	endif
endfunction

function! RenameItemUnderCursor()
	let target = trim(getline('.'), '/\')
	let filename = fnamemodify(target, ':t')
	let newname = input('Rename into:', filename)
	if has('win32')
		silent exec '!start /b rename' WindowsPath(filename) WindowsPath(newname)
		normal R
	else
		let cmd = printf('mv "%s" "%s"', filename, newname)
		silent exec '!'.cmd '&' | redraw!
		normal R
	endif
endfunction

function! OpenTree(path, flags)
	let flags = ( a:flags != '' ? ('-'.a:flags) : '' )
	vnew | set buftype=nofile nowrap
	set conceallevel=3 concealcursor=n | syn match Todo /\v(\a|\:|\\|\/|\.)*(\/|\\)/ conceal
	nnoremap <buffer> yy $"by$
	let cmd = printf('silent read !tree'.(has('win32')?'.exe':' --charset=ascii').' --noreport -I "bin|obj" "%s" %s', a:path, flags)
	exec(cmd)
	%s,\\,/,ge
	normal! gg"_dd
	nnoremap <buffer> gf :e <C-R>=GetPathFromTree()<CR><CR>
	nnoremap <buffer> gF :sp <C-R>=GetPathFromTree()<CR><CR>
endfunction

function! GetPathFromTree()
	let line = getline('.')
	let farthest = FindLastOccurrencePos(line, '|`')
	let path = line[farthest+3:]
	for i in range(line('.')-1, 1, -1)
		let currentline = getline(i)
		let lastVerticalBarPos = FindLastOccurrencePos(currentline, '|`')
		if lastVerticalBarPos < farthest
			let start = lastVerticalBarPos+ (lastVerticalBarPos == -1 ? 1 : 3)
			let path = currentline[start:] . '/' . path
			let farthest = lastVerticalBarPos
		endif
	endfor
	return path
endfunction

function! ReverseString(string)
	let res = ''
	let len = len(a:string)
	for i in range(1, len)
		let res .= a:string[len-i]
	endfor
	return res
endfunction

function! FindLastOccurrencePos(string, chars)
	let list = []
	for i in range(len(a:chars))
		call add(list, FindLastOccurrencePosSingle(a:string, a:chars[i]))
	endfor
	return max(list)
endfunction

function! FindLastOccurrencePosSingle(string, char)
	let res = len(a:string) - stridx(ReverseString(a:string), a:char)
	return res > len(a:string) ? -1 : res
endfunction

function! CreateDirectory()
	let dirname = PromptUserForFilename('Directory name:')
	if trim(dirname) == ''
		return
	endif
	if has('win32')
		silent exec '!start /b mkdir' shellescape(dirname)
		normal R
		exec '/'.escape(getcwd(), '\').'\\'.dirname.'\\$'
	else
		silent exec '!mkdir' dirname '&' | redraw!
		normal R
		exec '/'.escape(getcwd(), '/').'\/'.dirname.'\/$'
	endif
	nohlsearch
endf

function! CreateFile()
	let filename = PromptUserForFilename('File name:')
	if trim(filename) == ''
		return
	endif
	if has('win32')
		exec '!start /b copy /y NUL' shellescape(filename) '>NUL'
		normal R
		exec '/'.escape(getcwd(), '\').'\\'.filename.'$'
	else
		exec '!touch' filename '&' | redraw!
		normal R
		exec '/'.escape(getcwd(), '/').'\/'.filename.'$'
	endif
	nohlsearch
endf

function! PreviewFile(splitcmd, giveFocus)
	let path=trim(getline('.'))
	let bufnr=bufnr()
	let previewwinid = getbufvar(bufnr, 'preview'.a:splitcmd, 0)
	if previewwinid == 0
		exec a:splitcmd path
		call setbufvar(bufnr, 'preview'.a:splitcmd, win_getid())
	else
		call win_gotoid(previewwinid)
		if win_getid() == previewwinid
			silent exec 'edit' path
		else
			exec a:splitcmd path
			call setbufvar(bufnr, 'preview'.a:splitcmd, win_getid())
		endif
	endif
	if !a:giveFocus
		exec 'wincmd' (a:splitcmd == 'vsplit' ? 'h' : 'k')
	endif
endfunction

augroup my_dirvish
	au!
	autocmd BufEnter if &ft == 'dirvish' | let b:previewvsplit = 0 | let b:previewsplit = 0 | endif
	autocmd BufLeave if &ft == 'dirvish' | mark L | endif
	autocmd BufEnter if &ft == 'dirvish' | silent normal R
	autocmd FileType dirvish silent! nunmap <silent> <buffer> q
	autocmd FileType dirvish nnoremap <silent> <buffer> q: q:
	if g:isWindows
	autocmd FileType dirvish nnoremap <silent> <buffer> f :term ++curwin ++noclose powershell -NoLogo<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> F :term ++noclose powershell -NoLogo<CR>
elseif g:isWsl
	autocmd FileType dirvish nnoremap <silent> <buffer> f :term ++curwin ++noclose<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> F :term ++noclose<CR>
endif
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
	autocmd FileType dirvish nnoremap <silent> <buffer> t :call OpenTree(trim(getline('.'), '\'), '')<CR>
	autocmd FileType dirvish nnoremap <buffer> T :call OpenTree(trim(getline('.'), '\'), 'df')<left><left><left>
	autocmd FileType dirvish nnoremap <silent> <buffer> gt :call OpenTree(fnamemodify(trim(getline('.'), '\'), ':h'), '')<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> gT :call OpenTree(fnamemodify(trim(getline('.'), '\'), ':h'), 'df')<left><left><left>
	autocmd FileType dirvish nnoremap <silent> <buffer> <space> :Lcd \| e .<CR>
	autocmd FileType dirvish nmap <silent> <buffer> <leader>w vv<leader>w<CR>
augroup end

" Web Browsing" -----------------------{{{
function! BuildFirefoxUrl(path)
	let url = a:path
	let nbDoubleQuotes = len(substitute(url, '[^"]', '', 'g'))
	if nbDoubleQuotes > 0 && nbDoubleQuotes % 2 != 0 | let url.= ' "' |	endif
	let url = escape(trim(url), '%#')
	if g:isWindows
		let url = substitute(url, '"', '\\"', 'g')
	elseif g:isWsl
		let url = substitute(escape(url, '\'), '"', '\\"', 'g')
		if url !~ '^http'
			let url = 'file:\/\/\/\/\/wsl$\/Ubuntu-20.04'.url
		endif
	endif
	return url
endfunction

function! Firefox(...)
	let s:job= job_start('firefox.exe "'. BuildFirefoxUrl((a:0 == 0) ? GetCurrentSelection() : join(a:000)) .'"')
endfun
command! -nargs=* -range Firefox :call Firefox(<f-args>)
command! -nargs=* -range Ff :call Firefox(<f-args>)
nnoremap <Leader>w :w!<CR>:Firefox <C-R>=substitute(expand('%:p'), '/', '\\', 'g')<CR><CR>
vnoremap <Leader>w :Firefox<CR>
command! -nargs=* -range WordreferenceFrEn :call Firefox('https://www.wordreference.com/fren/', <f-args>)
command! -nargs=* -range GoogleTranslateFrEn :call Firefox('https://translate.google.com/?hl=fr#view=home&op=translate&sl=fr&tl=en&text=', <f-args>)
nnoremap <Leader>t :WordreferenceFrEn 
vnoremap <Leader>t :GoogleTranslateFrEn<CR>
command! -nargs=* -range WordreferenceEnFr :call Firefox('https://www.wordreference.com/enfr/', <f-args>)
command! -nargs=* -range GoogleTranslateEnFr :call Firefox('https://translate.google.com/?hl=fr#view=home&op=translate&sl=en&tl=fr&text=', <f-args>)
nnoremap <Leader>T :WordreferenceEnFr 
vnoremap <Leader>T :GoogleTranslateEnFr<CR>
command! -nargs=* -range Google :call Firefox('http://google.com/search?q=', <f-args>)
nnoremap <Leader>q :Google <C-R>=&ft<CR> 
vnoremap <Leader>q :Google<CR>

function! Lynx(...)
	let url = ((a:0 == 0) ? GetCurrentSelection() : join(a:000))
	let url = shellescape(url, 1)
	exec (bufname() =~ '\.lynx$' ? 'edit!' : 'tabedit') printf($desktop.'/tmp/_%s.lynx', substitute(url, '\v(\<|\>|:|"|/|\||\?|\*)', '_', 'g'))
	normal! ggdG
	exec 'silent 0read' '!echo' url
	exec 'silent 1read' '!lynx -dump -nonumbers -width=9999 -display_charset=utf-8' url
	normal! gg
	write
endfunction
command! -nargs=* -range Lynx call Lynx(<f-args>)
nnoremap <Leader>W :Lynx
vnoremap <Leader>W :Lynx<CR>

command! -nargs=* -range Wikipedia :call Lynx('https://en.wikipedia.org/wiki/Special:Random')

augroup lynx
	au!
	autocmd BufEnter *.lynx set filetype=lynx
	autocmd FileType lynx set nowrap
	autocmd FileType lynx vnoremap <buffer> <Leader>w :Lynx<CR>
	autocmd FileType lynx vnoremap <buffer> <Leader>W :Firefox<CR>
	autocmd FileType lynx nnoremap <buffer> <Leader>w :Firefox <C-R>=getline('1')<CR><CR>
augroup end

" Dashboard" --------------------------{{{
function! OpenDashboard()
	silent tab G
	-tabmove
	normal gu
	silent exec winheight(0)/4.'split' $desktop.'/todo'
	silent exec 'vnew $desktop/done'
	silent exec 'new $desktop/achievements'
	silent resize -2
	0wincmd w
	redraw | echo 'You are doing great <3'
endfunction
command! -bar Dashboard call OpenDashboard()
nnoremap <silent> <Leader>m :Dashboard<CR>

augroup dashboard
	au!
	autocmd FileType fugitive,git nnoremap <buffer> <LocalLeader>m :Git push --force-with-lease<CR>
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
	autocmd FileType fugitive,git nnoremap <buffer> <Leader>w :Todo<CR>
	autocmd BufEnter     todo,done,achievements set buftype=nofile nowrap
	autocmd BufWritePost todo,done,achievements set buftype=nofile
	autocmd BufEnter     todo,done,achievements normal! gg
	autocmd BufLeave     todo,done,achievements normal! gg
	autocmd BufEnter     todo,done,achievements redraw | echo 'You are doing great <3'
	autocmd BufWritePost todo                   redraw | echo 'Nice :)'
	autocmd BufWritePost      done              redraw | echo 'Good job! :D'
	autocmd BufWritePost           achievements redraw | echo 'You did great ;)'
	autocmd BufEnter               achievements nnoremap <buffer> p o<C-R>=strftime('%Y-%m-%d')<CR> <C-R>"<esc>
	autocmd BufEnter               achievements nnoremap <buffer> P O<C-R>=strftime('%Y-%m-%d')<CR> <C-R>"<esc>
	autocmd BufEnter     todo,done,achievements inoremap <buffer> <Esc> <Esc>:set buftype=<CR>:w!<CR>
	autocmd TextChanged  todo,done,achievements set buftype= | silent write!
	autocmd BufEnter     todo,done,achievements nnoremap <buffer> <Leader>w :Todo<CR>
augroup end


function! RenderTodoList(todofile, donefile)
	let todolines = readfile(a:todofile)
	let donelines = readfile(a:donefile)
	let lines = todolines + donelines
	let todomaxindex=len(todolines)-1
	let items = []
	for i in range(len(lines))
		if lines[i] == ''
			continue
		endif
		let item = ParseTodoItem(lines[i])
		let item.isDone = (i > todomaxindex)
		call add(items, item)
	endfor
	let itemsToRender = []
	let mantras = []
	for itm in items
		if has_key(itm, 'mantra')
			let existingMantras = filter(copy(mantras), { _,x -> x.title == itm.mantra})
			if len(existingMantras) == 0
				call add(mantras, #{ title: itm.mantra, priority: itm.priority, items: [itm] })
			else
				call add(existingMantras[0].items, itm)
			endif
		elseif has_key(itm, 'group')
			let existingGroups = filter(copy(itemsToRender), { _,x -> has_key(x, 'title') && x.title == itm.group})
			if len(existingGroups) == 0
				call add(itemsToRender, #{ title: itm.group, priority: itm.priority, items: [itm] })
			else
				call add(existingGroups[0].items, itm)
			endif
		else
			call add(itemsToRender, itm)
		endif
	endfor
	let itemsToRender = mantras + itemsToRender
	let todoHtml = []
	let doneHtml = []
	let ideasHtml = []
	let doneParentsAlreadyProcessed = []
	for itm in itemsToRender
		if has_key(itm, 'title') && index(doneParentsAlreadyProcessed, itm.title) == -1
			if len(filter(copy(itm.items), {_,x->!x.isDone})) == 0
				call add(doneHtml, BuildDoneTodoParentItemHtml(itm))
				call add(doneParentsAlreadyProcessed, itm.title)
			else
				call add((itm.priority >= 1 ? todoHtml : ideasHtml), BuildUnfinishedTodoParentItemHtml(itm))
				for i in filter(copy(itm.items), {_,x->x.isDone})
					call add(doneHtml, BuildTodoItemHtml(i))
				endfor
			endif
		else
			if itm.isDone
					call add(doneHtml, BuildTodoItemHtml(itm))
			else
					call add((itm.priority >= 1 ? todoHtml : ideasHtml), BuildTodoItemHtml(itm))
			endif
		endif
	endfor
	let html = BuildHtml(join(todoHtml,''), join(doneHtml,''), join(ideasHtml,''))
	call writefile([html], $desktop.'/tmp/today.html')
	call Firefox('',expand($desktop.'/tmp/today.html', ':p'))
endfunction

function! ParseTodoItem(line)
	let res = #{ priority: 0 }
	let descriptionstart = 0
	let descriptionend = len(a:line)-1
	if (a:line =~ '^#')
		if (stridx(a:line, '@ ') != -1)
			echoerr printf('%s should have either a priority (@), either a mantra (#), but not both', res.description)
		endif
		let res.mantra = CapitalizeFirstLetter(matchlist(a:line, '#\(\S\+\)')[1])
		let res.priority = 9
		let descriptionstart = len(res.mantra)+1
	elseif (a:line =~ '^@')
			let descriptionstart = 1
		for i in range(1,3)
			let priorityPattern = '^'.repeat('@',i)
			if (a:line =~ priorityPattern)
				let res.priority += 1
				let descriptionstart += 1
			else
				break
			endif
		endfor
	endif
	if (stridx(a:line, ' #') != -1)
		let res.group = CapitalizeFirstLetter(a:line[stridx(a:line, ' #')+2:])
		let descriptionend = stridx(a:line, ' #')-1
	endif
	let res.description = CapitalizeFirstLetter(a:line[descriptionstart:descriptionend])
	return res
endfunction

function! CapitalizeFirstLetter(string)
	if a:string==''
		return ''
	endif
	return toupper(a:string[0]) . a:string[1:]
endfunction

function! HtmlEncode(string)
	let string = a:string
	let string = substitute(string, '<', '\&lt;', 'g')
	let string = substitute(string, '>', '\&gt;', 'g')
	return string
endfunction

function! BuildHtml(todoHtml, doneHtml, ideasHtml)
	return join(['<html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"><style type="text/css" media="screen">.priority-1{background:#b2d0e4!important}.priority-3{background:#fb8072!important}.priority-2{background:#8dd3c7!important}.priority-0{background:#ffffb3!important}.priority-9{background:#d8e7f1!important}body{margin: 0px; height: 100%; font-family: georgia}#main{display: flex; flex-direction: column; background:url(../notes/media/dagger.jpg) no-repeat center center fixed; background-size: cover; min-height:100%;}#content{flex-grow: 1; font-size:x-large;}#todoHeader{text-align: center; background:#fabd2f;}#doneHeader{text-align: center; background:#b3de69;}#ideasHeader{text-align: center; background:#fdb462;}#content>table>tbody>tr>th{padding:0px 10px 1px 10px; margin:2px; height:42px;}.columncontent{height:100%;}.item{background:lightgrey; border-radius:5px; padding:0px 10px 1px 10px; margin:4px; display: flex;}.item>div{overflow: hidden; text-overflow: ellipsis; white-space: nowrap;}.item>div:first-child{max-width: 25%; width: 25%; font-weight: bold;}.item>div:last-child{max-width:75%; width:75%; font-style: italic;}.item>div:only-child{max-width:100%; width:100%; font-weight: normal; font-style:normal;}.itemparent{background:lightgrey; border-radius:5px; padding:0px 10px 1px 10px; margin:4px;}.itemparent>div:first-child{font-weight:bold; margin:2px; padding:2px; display:inline-block; text-decoration:underline;}.striked{text-decoration:line-through;}ul{margin:0px 0px 5px 0px;}li>div{overflow:hidden; text-overflow:ellipsis; white-space:nowrap;}</style><title>TODO</title></head><body><div id="main"><div id="content" height="100%"><table width="100%" height="100%" style="table-layout:fixed;"><tr><th id="todoHeader">THE PLAN</td><th id="doneHeader"><u>DONE</u></td><th id="ideasHeader">TODOLIST</td></tr><tr><td><div class="columncontent">', a:todoHtml, '</div></td><td><div class="columncontent">', a:doneHtml, '</div></td><td><div class="columncontent">', a:ideasHtml, '</div></td></tr></table></div><div id="footer"><div style="color: white;float: right;">', strftime("generated at %Hh%M"),'</div></div></div></body></html>'], '')
endfunction

function! BuildTodoItemHtml(todoItem)
	if get(a:todoItem, 'parent', '') != ''
		return printf('<div class="item priority-%d"><div title="%s">%s</div><div title="%s">%s</div></div>', a:todoItem.priority, HtmlEncode(a:todoItem.parent), HtmlEncode(a:todoItem.parent), HtmlEncode(a:todoItem.description), HtmlEncode(a:todoItem.description))
	else
		return printf('<div class="item priority-%d"><div title="%s">%s</div></div>', a:todoItem.priority, HtmlEncode(a:todoItem.description), HtmlEncode(a:todoItem.description))
	endif
endfunction

function! BuildUnfinishedTodoParentItemHtml(parentItem)
	return printf('<div class="itemparent priority-%d"><div>%s</div><ul>%s</ul></div>', HtmlEncode(a:parentItem.priority), HtmlEncode(a:parentItem.title), BuildListOfUnfinishedTodoItemsHtml(a:parentItem.items))
endfunction

function! BuildListOfUnfinishedTodoItemsHtml(todoItems)
	return join(map(copy(a:todoItems), {_,x -> printf('<li%s title="%s">%s</li>', GetHtmlClassAttributeByDoneState(x.isDone), HtmlEncode(x.description), HtmlEncode(x.description))}), '')
endfunction

function! GetHtmlClassAttributeByDoneState(isDone)
	return a:isDone ? ' class="striked"' : ''
endfunction

function! BuildDoneTodoParentItemHtml(parentItem)
	return printf('<div class="itemparent priority-%d"><div>%s</div><ul>%s</ul></div>', HtmlEncode(a:parentItem.priority), HtmlEncode(a:parentItem.title), BuildListOfDoneTodoItemsHtml(a:parentItem.items))
endfunction

function! BuildListOfDoneTodoItemsHtml(doneItems)
	return join(map(copy(a:doneItems), {_,x -> printf('<li title="%s">%s</li>', HtmlEncode(x.description), HtmlEncode(x.description))}))
endfunction

command! RenderTodoList call RenderTodoList($desktop.'/todo', $desktop.'/done')
command! Todo call RenderTodoList($desktop.'/todo', $desktop.'/done')

" Drafts (Diagrams & Notes)"-----------{{{
function! Draft(lines)"-----------------{{{
	if len(a:lines) < 2 | return | endif
	let file_or_diagramtype = a:lines[1]
	let cmd=''
	if glob(file_or_diagramtype) != ''
		let file = file_or_diagramtype
		let cmd = get({
			\'ctrl-x': 'split',
			\'ctrl-j': 'split',
			\'ctrl-v': 'vertical split',
			\'ctrl-k': 'vertical split',
			\'ctrl-t': 'tabe',
			\'ctrl-o': 'tabe',
			\'ctrl-b': 'CompileDiagramAndShowImage png'}, a:lines[0], 'e')
	exec cmd file
	else
		let cmd = get({
			\'ctrl-x': 'split',
			\'ctrl-j': 'split',
			\'ctrl-v': 'vertical split',
			\'ctrl-k': 'vertical split',
			\'ctrl-t': 'tabe',
			\'ctrl-o': 'tabe'}, a:lines[0], 'e')
		let ComputePath = { str -> '' }
		if file_or_diagramtype == 'note'
			let ComputePath = { x -> $desktop.'/notes/'.x }
		elseif file_or_diagramtype == 'adr'
			let ComputePath = { x -> $desktop.'/notes/'.x.'.md' }
		else " if is diagramtype
			let ComputePath = { x -> $desktop.'/tmp/'.x.'.puml_'.split(file_or_diagramtype,' ')[0] }
		endif
		let title = PromptUserForFilename('Note title:', ComputePath) | redraw | exec cmd ComputePath(title)
	endif
endfunction

function! ExploreDrafts()
	let diagramtypes = map(['activity', 'mindmap', 'sequence', 'workbreakdown', 'class', 'component', 'entities', 'state', 'usecase', 'dot'], { _,x -> x. ' diagram' })
	let diagrams = expand($desktop.'/tmp/*.puml*', 0, 1)
	let notetypes = ['note']
	let notes = expand($desktop.'/notes/*', 0, 1)
	let adrtypes = ['adr']
	let adrs = expand($desktop.'/tmp/*.md', 0, 1)
	call fzf#run(fzf#vim#with_preview(fzf#wrap({'source': notetypes+adrtypes+diagramtypes+notes+adrs+diagrams,'sink*': function('Draft'), 'options': ['--expect', 'ctrl-t,ctrl-v,ctrl-x,ctrl-j,ctrl-k,ctrl-o,ctrl-b', '--prompt', 'Drafts> ']})))
endfunction
command! ExploreDrafts call ExploreDrafts()
nnoremap <leader>d :ExploreDrafts<CR>
nnoremap <leader>D :vs\|Dirvish <C-R>=expand('$HOME/Downloads')<CR><CR>

function! JobExitDiagramCompilationJob(outputfile, channelInfos, status)
	if a:status != 0
		10messages
		return
	endif
	call Firefox('', a:outputfile)
endfunc

function! CompileDiagramAndShowImage(outputExtension, ...)
	let inputfile = (a:0 == 2) ? a:2 : expand('%:p')
	let outputfile = fnamemodify(inputfile, ':r').'.'.a:outputExtension
	let cmd = printf('plantuml -t%s -charset UTF-8 -config "%s" "%s"', a:outputExtension, GetPlantumlConfigFile(fnamemodify(inputfile,':e')), inputfile)
	if g:isWindows
		let cmd = 'cmd /C '.cmd
	endif
	let s:job = job_start(
		\cmd,
		\{
			\'callback': { chan,msg  -> execute('echomsg ''[cb] '.substitute(msg,"'","''","g").'''',  1)      },
			\'out_cb':   { chan,msg  -> execute('echomsg '''.substitute(msg,"'","''","g").'''',  1)           },
			\'err_cb':   { chan,msg  -> execute('echohl Constant | echomsg '''.substitute(msg,"'","''","g").''' | echohl Normal',  1) },
			\'close_cb': { chan      -> execute('echomsg ''[close] '.chan.'''', 1)                            },
			\'exit_cb':  function('JobExitDiagramCompilationJob', [outputfile])
		\}
	\)
endfunction

function! GetPlantumlConfigFile(fileext)
	let configfilebyft = #{
		\puml_activity:      'styles',
		\puml_mindmap:       'styles',
		\puml_sequence:      'styles',
		\puml_workbreakdown: 'styles',
		\puml_class:         'skinparams',
		\puml_component:     'skinparams',
		\puml_entities:      'skinparams',
		\puml_state:         'skinparams',
		\puml_usecase:       'skinparams',
		\puml_dot:           'graphviz'
	\}
	return $desktop.'/config/my_plantuml_'.configfilebyft[a:fileext].'.config'
endfunction
command! -nargs=* -bar CompileDiagramAndShowImage call CompileDiagramAndShowImage(<f-args>)


augroup mydiagrams
	autocmd!
	autocmd BufRead,BufNewFile *.puml_dot             set ft=plantuml_dot
	autocmd BufRead,BufNewFile *.puml_activity        set ft=plantuml_activity
	autocmd BufRead,BufNewFile *.puml_class           set ft=plantuml_class
	autocmd BufRead,BufNewFile *.puml_component       set ft=plantuml_component
	autocmd BufRead,BufNewFile *.puml_entities        set ft=plantuml_entities
	autocmd BufRead,BufNewFile *.puml_mindmap         set ft=plantuml_mindmap
	autocmd BufRead,BufNewFile *.puml_sequence        set ft=plantuml_sequence
	autocmd BufRead,BufNewFile *.puml_state           set ft=plantuml_state
	autocmd BufRead,BufNewFile *.puml_usecase         set ft=plantuml_usecase
	autocmd BufRead,BufNewFile *.puml_workbreakdown   set ft=plantuml_workbreakdown
	autocmd BufRead,BufNewFile *.puml_*               silent nnoremap <buffer> <Leader>w :silent w<CR>
	autocmd BufWritePost       *.puml_*               if line('$') > 1 | CompileDiagramAndShowImage png | endif
	autocmd FileType           dirvish                nnoremap <silent> <buffer> D :call CreateDiagramFile()<CR>
augroup END

" Debugging"---------------------------{{{
let g:vimspector_enable_mappings = 'HUMAN'
sign define vimspectorBP text=:          texthl=MatchParen
sign define vimspectorBPCond text=;      texthl=MatchParen
sign define vimspectorBPDisabled text=. texthl=MatchParen
sign define vimspectorPC text=\=>         texthl=ErrorMsg
sign define vimspectorPCBP text=:>       texthl=ErrorMsg

function! ToggleBreakpoint()
	let alreadyHasBreakpoint1 = len(sign_getplaced(bufnr(), #{group:'VimspectorBP', lnum: line(".")})[0].signs) > 0
	let alreadyHasBreakpoint2 = len(sign_getplaced(bufnr(), #{group:'VimspectorCode', lnum: line(".")})[0].signs) > 0
	if alreadyHasBreakpoint1 || alreadyHasBreakpoint2
		call vimspector#ToggleBreakpoint()
	else
		let condition = input('condition:')
		if condition == ''
			call vimspector#ToggleBreakpoint()
		else
			call vimspector#ToggleBreakpoint({'condition': condition})
		endif
		redraw
	endif
endfunction

function! IsDebuggingTab()
	return tabpagenr() == get(get(g:, 'vimspector_session_windows', {}), 'tabpage', 0)
endfunction

function! IsDebuggingHappening()
	return get(get(g:, 'vimspector_session_windows', {}), 'tabpage', 99) <= tabpagenr('$')
endfunction

function! StartDebuggingSession()
	if IsDebuggingHappening()
		exec 'normal!' g:vimspector_session_windows.tabpage.'gt'
	else
		let debugConfigFiles = FindDebugConfigFiles()
		let debugConfig = empty(debugConfigFiles) ? CreateDebugConfigFile() : debugConfigFiles[0]
		call vimspector#Launch()
	endif
endfunction

function! FindDebugConfigFile()
	return ''
endfunction


func! CustomiseUI()
	call win_gotoid(g:vimspector_session_windows.stack_trace)
	wincmd H
	call win_gotoid( g:vimspector_session_windows.code )
	wincmd H
	call win_gotoid(g:vimspector_session_windows.variables)
	let b = bufnr('%')
	quit
	call win_gotoid(g:vimspector_session_windows.watches)
	nunmenu WinBar
	wincmd J
	exec 'vertical sbuffer' b
	call win_gotoid( g:vimspector_session_windows.code )
	nunmenu WinBar
	call win_gotoid(g:vimspector_session_windows.output)
	nunmenu WinBar.Telemetry
	resize 12
	set winfixheight
	wincmd J
	wincmd =
	call win_gotoid( g:vimspector_session_windows.code )
	resize +4
	normal! zz
	windo nnoremap <buffer> <localleader>j :call vimspector#StepInto()<CR>
	windo nnoremap <buffer> <localleader>k :call vimspector#StepOut()<CR>
	windo nnoremap <buffer> <localleader>l :call vimspector#Continue()<CR>
	windo nnoremap <buffer> <localleader>h :call vimspector#Restart()<CR>
endfunction

augroup MyVimspectorUICustomistaion
  autocmd!
  autocmd User VimspectorUICreated call CustomiseUI()
augroup END

" Specific Workflows:------------------{{{
" Nuget" ------------------------------{{{
function! FindNuget(...)
	let tokens = flatten(map(copy(a:000), { _,x -> split(x, '\.') }))
	let scratchbufnr = ResetScratchBuffer($desktop.'tmp/Nugets')
	let cmd = 'nuget list id:'.tokens[0]
	if g:isWindows
		let cmd = 'cmd /C '.cmd
	endif
	let s:job = job_start(
		\cmd,
		\{
			\'out_io': 'buffer',
			\'out_buf': scratchbufnr,
			\'out_modifiable': 1,
			\'err_io': 'buffer',
			\'err_buf': scratchbufnr,
			\'err_modifiable': 1,
			\'in_io': 'null',
			\'callback': { chan,msg  -> execute('echo ''[cb] '.substitute(msg,"'","''","g").'''',  1)   },
			\'out_cb':   { chan,msg  -> execute('echo ''Found: '.substitute(msg,"'","''","g").'''',  1) },
			\'err_cb':   { chan,msg  -> execute('echohl Constant | echomsg '''.substitute(msg,"'","''","g").''' | echohl Normal',  1) },
			\'close_cb': { chan      -> execute('echomsg ''[close] '.chan.'''', 1)},
			\'exit_cb':  function('FindNugetExitCb', [tokens, scratchbufnr])
		\}
	\)
endfunc
command! -nargs=+ Nuget call FindNuget(<f-args>)

function! FindNugetExitCb(tokens, scratchbufnr, job, status)
	echomsg "[exit] ".a:status
	exec 'sbuffer' a:scratchbufnr
	for token in a:tokens
		exec 'v/'.token.'/d'
	endfor
	SortByLength
	normal! gg
endfunction

" cs(c#)" -----------------------------{{{
if has('win32') | let g:OmniSharp_server_path = $desktop . '/tools/omnisharp/OmniSharp.exe' | endif
let $DOTNET_NEW_LOCAL_SEARCH_FILE_ONLY=1
let g:OmniSharp_start_server = 0
let g:OmniSharp_server_stdio = 1
let g:ale_linters = { 'cs': ['OmniSharp'] }
let g:OmniSharp_popup = 0
let g:OmniSharp_loglevel = 'none'
let g:OmniSharp_highlighting = 2
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_fzf_options = { 'window': 'botright 7new' }
let g:OmniSharp_want_snippet=1
let g:OmniSharp_diagnostic_showid = 1
let g:omnicomplete_fetch_full_documentation = 0
augroup lightline_integration
  autocmd!
  autocmd User OmniSharpStarted,OmniSharpReady,OmniSharpStopped call lightline#update()
augroup END

function! BuildAndTestCurrentSolution()
	cclose
	let sln_dir = GetCsproj()
	let omnisharp_host = getbufvar(bufnr('%'), 'OmniSharp_host')
	if !empty(omnisharp_host) && get(omnisharp_host, 'initialized')
		let sln_dir = fnamemodify(omnisharp_host.sln_or_dir, isdirectory(omnisharp_host.sln_or_dir) ? ':p' : ':h:p')
	endif
	call StartCSharpBuild(sln_dir)
endfunction
command! -bar BuildAndTestCurrentSolution call BuildAndTestCurrentSolution()

function! StartCSharpBuild(sln_or_dir)
	let folder = isdirectory(a:sln_or_dir) ? a:sln_or_dir : fnamemodify(a:sln_or_dir, ':h:p')
	let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Build')
	let cmd = 'dotnet build /p:GenerateFullPaths=true /clp:NoSummary'
	if g:isWindows
		let cmd = 'cmd /C '.cmd
	endif
	let s:job = job_start(
		\cmd,
		\{
			\'cwd': folder,
			\'out_io': 'buffer',
			\'out_buf': scratchbufnr,
			\'out_modifiable': 0,
			\'err_io': 'buffer',
			\'err_buf': scratchbufnr,
			\'err_modifiable': 0,
			\'in_io': 'null',
			\'callback': { chan,msg  -> execute('echomsg ''[cb] '.substitute(msg,"'","''","g").'''',  1) },
			\'out_cb':   { chan,msg  -> execute('echomsg '''.substitute(msg,"'","''","g").'''',  1)      },
			\'err_cb':   { chan,msg  -> execute('echohl Constant | echomsg '''.substitute(msg,"'","''","g").''' | echohl Normal',  1) },
			\'close_cb': { chan      -> execute('echomsg ''[close] '.chan.'''', 1)                       },
			\'exit_cb':  function('StartCSharpBuildExitCb', [folder, scratchbufnr])
		\}
	\)
endfunction

function! StartCSharpBuildExitCb(workingdir, scratchbufnr, job, status)
	if a:status
		echomsg 'Compilation failed.'
		set errorformat=MSBUILD\ :\ error\ MSB%n:\ %m
		set errorformat+=%f(%l\\,%c):\ error\ MSB%n:\ %m\ [%.%#
		set errorformat+=%f(%l\\,%c):\ error\ CS%n:\ %m\ [%.%#
		set errorformat+=%f(%l\\,%c):\ error\ xUnit%n:\ %m\ [%.%#
		set errorformat+=%f\ :\ error\ NU%c:\ %m\ [%.%#
		set errorformat+=%-G%.%#
		exec 'cgetbuffer' a:scratchbufnr
	else
		call StartCSharpTest(a:workingdir)
	endif
endfunction

function! StartCSharpTest(workingdir)
	let cmd = 'dotnet test --no-build'
	let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Test')
	if g:isWindows
		let cmd = 'cmd /C '.cmd
	endif
	let s:job = job_start(
		\cmd,
		\{
			\'cwd': a:workingdir,
			\'out_io': 'buffer',
			\'out_buf': scratchbufnr,
			\'out_modifiable': 0,
			\'err_io': 'buffer',
			\'err_buf': scratchbufnr,
			\'err_modifiable': 0,
			\'in_io': 'null',
			\'err_cb':   { chan,msg  -> execute('echohl Constant | echomsg '''.substitute(msg,"'","''","g").''' | echohl Normal',  1) },
			\'close_cb': { chan      -> execute('echomsg ''[close] '.chan.'''', 1)                       },
			\'exit_cb':  function('Commit', [scratchbufnr])
		\}
	\)
endfunction

function! Commit(scratchbufnr, job, status)
	if a:status
		echomsg 'Tests failed.'
		set errorformat=%A\ %#Failed\ %.%#
		set errorformat+=%Z\ %#Failed\ %.%#
		set errorformat+=%-C\ %#Stack\ Trace:
		set errorformat+=%-C\ %#at%.%#\ in\ %.%#ValidationResultExtention.cs%.%#
		set errorformat+=%C\ %#at%.%#\ in\ %f:line\ %l
		set errorformat+=%-C%.%#\ Error\ Message%.%#
		set errorformat+=%-C%.%#\ (pos\ %.%#
		set errorformat+=%-G%*\\d-%*\\d-%*\\d\ %.%#
		set errorformat+=%C\ %#%m\ Failure
		set errorformat+=%C\ %#%m
		set errorformat+=%-G%.%#
		exec 'cgetbuffer' a:scratchbufnr
	else
		call OpenDashboard()
	endif
endfunction

function! GetCsproj()
	let dir = expand('%:p:h')
	let lastfolder = ''
	let csproj_dir = []
	while dir !=# lastfolder
		let csproj_dir += globpath(dir, '*.csproj', 1, 1)
		call uniq(csproj_dir)
		if !empty(csproj_dir)
				return csproj_dir[0]
		endif
		let lastfolder = dir
		let dir = fnamemodify(dir, ':h')
	endwhile
endfunction

function! GetDirOrSln()
	let csproj = GetCsproj()
	let csprojdir = fnamemodify(csproj, ':h')
	let csproj = fnamemodify(csproj, ':.')
	let sln = has_key(g:, 'csprojs2sln') && has_key(g:csprojs2sln, csprojdir) ? g:csprojs2sln[csprojdir] : csproj
	let sln = fnamemodify(sln, ':.')
	let cmdline = getcmdline()
	let csproj_len = len(csproj)
	let sln_len = len(sln)
	if cmdline[-csproj_len:] == csproj
		return repeat("\<BS>", csproj_len).sln
	elseif cmdline[-sln_len:] == sln
		return repeat("\<BS>", sln_len).csproj
	else
		return csproj
	endif
endfunction

augroup csharpfiles
	au!
	autocmd FileType cs nnoremap <buffer> <silent> <LocalLeader>m :BuildAndTestCurrentSolution<CR>
	autocmd FileType cs nnoremap <buffer> <silent> <LocalLeader>M :!dotnet run -p Startup<CR>
	autocmd FileType cs nmap <buffer> zk <Plug>(omnisharp_navigate_up)
	autocmd FileType cs nmap <buffer> zj <Plug>(omnisharp_navigate_down)
	autocmd FileType cs nmap <buffer> z! <Plug>(omnisharp_find_members)
	autocmd FileType cs nmap <buffer> gd <Plug>(omnisharp_go_to_definition)
	autocmd FileType cs nmap <buffer> gD <Plug>(omnisharp_preview_definition)
	autocmd FileType cs nmap <buffer> <LocalLeader>i <Plug>(omnisharp_find_implementations)
	autocmd FileType cs nmap <buffer> <LocalLeader>I <Plug>(omnisharp_preview_implementations)
	autocmd FileType cs nmap <buffer> <LocalLeader>s <Plug>(omnisharp_find_type)
	autocmd FileType cs nmap <buffer> <LocalLeader>S <Plug>(omnisharp_find_symbol)
	autocmd FileType cs nmap <buffer> <LocalLeader>u <Plug>(omnisharp_find_usages)
	autocmd FileType cs nmap <buffer> <LocalLeader>d <Plug>(omnisharp_type_lookup)
	autocmd FileType cs nmap <buffer> <LocalLeader>D <Plug>(omnisharp_documentation)
	autocmd FileType cs nmap <buffer> <LocalLeader>c <Plug>(omnisharp_global_code_check)
	autocmd FileType cs nmap <buffer> <LocalLeader>q <Plug>(omnisharp_code_actions)
	autocmd FileType cs xmap <buffer> <LocalLeader>q <Plug>(omnisharp_code_actions)
	autocmd FileType cs nmap <buffer> <LocalLeader>r <Plug>(omnisharp_rename)
	autocmd FileType cs nmap <buffer> <LocalLeader>= <Plug>(omnisharp_code_format)
	autocmd FileType cs nmap <buffer> <LocalLeader>f <Plug>(omnisharp_fix_usings)
	autocmd FileType cs nmap <buffer> <LocalLeader>R <Plug>(omnisharp_restart_server)
	autocmd FileType cs nmap <buffer> <LocalLeader>t :OmniSharpRunTest<CR>
	autocmd FileType cs nmap <buffer> <LocalLeader>T :OmniSharpRunTestsInFile<CR>
	autocmd FileType cs nmap <buffer> <LocalLeader>Q :if !IsDebuggingHappening() \| call vimspector#Launch() \| else \| exec 'normal!' g:vimspector_session_windows.tabpage.'gt' \| endif<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>b :call ToggleBreakpoint()<CR>
	autocmd FileType cs nnoremap <buffer> <LocalLeader>B :call vimspector#ListBreakpoints()<CR>
	autocmd FileType cs nnoremap <buffer> <localleader>j :call vimspector#StepInto()<CR>
	autocmd FileType cs nnoremap <buffer> <localleader>k :call vimspector#StepOut()<CR>
	autocmd FileType cs nnoremap <buffer> <localleader>l :call vimspector#Continue()<CR>
	autocmd FileType cs nnoremap <buffer> <localleader>h :call vimspector#Restart()<CR>
	autocmd FileType cs cnoremap <buffer> <expr> <C-G> GetDirOrSln()
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

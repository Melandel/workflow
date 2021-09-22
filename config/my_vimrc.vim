let g:isWindows = has('win32')
let g:isWsl = isdirectory('/mnt/c/Windows')
if !g:isWindows && !g:isWsl
	echoerr 'Only Windows and WSL are handled by this vimrc for now.'
	finish
endif

if g:isWindows
let $HOME = substitute($HOME, '\\', '/', 'g')
let $config    = $HOME.'/Desktop/config'
let $desktop   = $HOME.'/Desktop'                    | let $d = $desktop
let $downloads = $HOME.'/Downloads'
let $notes     = $HOME.'/Desktop/notes'              | let $n = $notes
let $projects  = $HOME.'/Desktop/projects'           | let $p = $projects
let $rest      = $HOME.'/Desktop/templates/rest'
let $snippets  = $HOME.'/Desktop/templates/snippets'
let $tmp       = $HOME.'/Desktop/tmp'                | let $t = $tmp
let $tools     = $HOME.'/Desktop/tools'
let $templates = $HOME.'/Desktop/templates'
let $todo      = $HOME.'/Desktop/todo'
let $today     = $HOME.'/Desktop/today'
let $scripts   = $HOME.'/Desktop/scripts'            | let $s = $scripts
let $gtools    = $HOME.'/Desktop/tools/git/usr/bin'

let $rc         = $HOME.'/Desktop/config/my_vimrc.vim'
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
packadd! matchit
packadd! cfilter
function! MinpacInit()
	packadd minpac
	call minpac#init( {'dir':$packpath, 'package_name': 'plugins', 'progress_open': 'none' } )
	call minpac#add('editorconfig/editorconfig-vim')
	call minpac#add('dense-analysis/ale')
	call minpac#add('junegunn/fzf.vim')
	call minpac#add('itchyny/lightline.vim')
	call minpac#add('itchyny/vim-gitbranch')
	call minpac#add('OmniSharp/omnisharp-vim')
	"call minpac#add('Melandel/omnisharp-vim')
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
	"call minpac#add('ap/vim-css-color')
	call minpac#add('wellle/targets.vim')
	call minpac#add('bfrg/vim-qf-preview')
	call minpac#add('zigford/vim-powershell')
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
set nowrap
set noswapfile
set directory=$desktop/tmp/vim
set backup
set backupdir=$desktop/tmp/vim
set undofile
set undodir=$desktop/tmp/vim
set viewdir=$desktop/tmp/vim
set history=200
set mouse=a
" GVim specific
if has("gui_running")
	augroup emojirendering
		au!
		autocmd FileType fzf  set renderoptions=
		autocmd TerminalWinOpen * set renderoptions=
		autocmd BufEnter *    if &buftype == 'terminal' | set renderoptions= | endif
		autocmd BufLeave *    if len(&renderoptions) == 0 | set renderoptions=type:directx,level:0.75,gamma:1.25,contrast:0.25,geom:1,renmode:5,taamode:1 | endif
	augroup end
	set renderoptions=type:directx,level:0.75,gamma:1.25,contrast:0.25,geom:1,renmode:5,taamode:1
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
	if &ft == 'qf'
		return g:lcd_qf
	elseif &ft == 'dirvish'
		return trim(expand('%:p'), '\')
	endif
	let dir = substitute(expand('%:p:h'), '\\', '/', 'g')
	if stridx(dir, $projects) >= 0
		let dir = dir[:stridx(dir, '/', len($projects)+1)]
	elseif IsInsideGitClone()
		let dir = substitute(fnamemodify(gitbranch#dir(expand('%:p')), ':h'), '\\', '/', 'g')
	elseif IsOmniSharpRelated()
		let dir = fnamemodify(b:OmniSharp_host.sln_or_dir, isdirectory(b:OmniSharp_host.sln_or_dir) ? ':p' : ':p:h')
	else
		let dir = getcwd()
	endif
	return dir
endfunction

function! UpdateLocalCurrentDirectory()
	if &buftype == 'terminal'
		return
	endif
	let dir = GetInterestingParentDirectory()
	if dir =~ '^fugitive://'
		return
	endif
	let current_wd = getcwd()
	if current_wd != dir
		redraw
		exec 'lcd' dir
	endif
endfunction
command! -bar Lcd call UpdateLocalCurrentDirectory()

function! UpdateEnvironmentLocationVariables()
	let csproj = GetNearestParentFolderContainingFile('*.csproj')
	if csproj != ''
		let $csproj = csproj
		let sln = GetNearestParentFolderContainingFile('*.sln')
		if sln != ''
			let $sln = sln
		elseif has_key(g:, 'csprojs2sln') && has_key(g:csprojs2sln, csprojdir)
			let sln = g:csprojs2sln[csproj]
		endif
	endif
	let gitfolder = gitbranch#dir(expand('%:p'))
	if gitfolder != ''
		let $git = fnamemodify(gitfolder, ':h')
	endif
endfunc

augroup lcd
	au!
	" enew has a delay before updating bufname()
	autocmd BufCreate * call timer_start(100, { timerid -> execute('if &ft != "qf" && bufname() == "" | set bt=nofile | endif', '') })
	autocmd BufEnter  * call timer_start(100, { timerid -> execute('if &ft!="dirvish" | Lcd | else | lcd %:p:h | endif', '') })
	autocmd QuickFixCmdPre * let g:lcd_qf = getcwd()
	autocmd BufEnter * call UpdateEnvironmentLocationVariables()
augroup end

" Utils"-------------------------------{{{
function! DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call DiffWithSaved()

function! ComputeSecondsFromHoursMinutesSeconds(string)
	let array = map(split(a:string, ':', 1), {_,x->str2nr(x)})
	echo array
	if len(array) == 2
		return array[0]*60 + array[1]
	elseif len(array) == 3
		return array[0]*60 + array[1]*60 + array[2]
	else
		echoerr a:string 'not a handled time format'
		return a:string
	endif
endfunction
function! ParseArgs(argValues, ...)
	let args = {}
	let argNames = a:000
	let nbargValues = len(a:argValues)
	for i in range(len(argNames))
		if type(argNames[i]) == v:t_list
			let spec = argNames[i]
			let name = spec[0]
			let defaultValue = spec[1]
			let args[name] = (nbargValues >= (i+1)) ? a:argValues[i] : defaultValue
		else
			let name = argNames[i]
			if (nbargValues >= (i+1))
				let args[name] = a:argValues[i]
			else
				echoerr 'Could not parse argument' name 'from' a:argValues
			endif
		endif
	endfor
	return args
endfunc

function! GetNearestParentFolderContainingFile(regex)
	let filepath = GetNearestPathInCurrentFileParents(a:regex)
	return filepath != '' ? fnamemodify(filepath, ':h') : ''
endfunc

function! GetNearestPathInCurrentFileParents(regex)
	return GetNearestPathInParentFolders(a:regex, expand('%:p:h'))
endfunction

function! GetNearestPathInParentFolders(regex, path)
	let dir = isdirectory(a:path) ? a:path : fnamemodify(a:path, ':p:h')
	let lastfolder = ''
	let csproj_dir = []
	while dir !=# lastfolder
		let csproj_dir += globpath(dir, a:regex, 1, 1)
		call uniq(csproj_dir)
		if !empty(csproj_dir)
				return csproj_dir[0]
		endif
		let lastfolder = dir
		let dir = fnamemodify(dir, ':h')
	endwhile
	return ''
endfunc

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

function! IsLocListWindow()
	return &ft == 'qf' && (getwininfo(win_getid())[0].loclist || get(getbufinfo(winbufnr(winnr()))[0].variables, 'is_custom_loclist', 0))
endfunction

function! IsQuickFixWindow()
	return &ft == 'qf' && !getwininfo(win_getid())[0].loclist && !get(getbufinfo(winbufnr(winnr()))[0].variables, 'is_custom_loclist', 0)
endfunction


function! FileNameorQfTitle()
	if IsQuickFixWindow() || IsLocListWindow()
		return get(w:, 'quickfix_title', get(b:, 'quickfix_title'))
	else
		return fnamemodify(bufname(), ':t')
	endif
endfunction

function! IsInsideDashboard()
	return len(filter(range(1, winnr('$')), {_,x -> bufname(winbufnr(x)) =~ '^\.git.index'}))
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

function! ClearTrailingWhiteSpaces()
	%s/\s\+$//e
endfunction
command! ClearTrailingWhiteSpaces call ClearTrailingWhiteSpaces()

function! UserCompleteFuncExample(findstart, base)
	if a:findstart
		let line = getline('.')
		return min(filter([match(line, '\a'), match(line, '\d')], { _,x -> x != -1 }))
	endif
	return map(['✗', '✓'], { _,x -> x.' '.trim(a:base, ' \t✗✓+*') })
endfunction
set completefunc=UserCompleteFuncExample

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
	let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Job')
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
	let finalpath = ComputeFinalPath(title)
	let finalfilename = fnamemodify(finalpath, ':t')
	let GetRetryMessage = { x -> a:0 > 0 ? a:1 : printf('[%s] already exists. %s', finalfilename, a:requestToUser) }
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
inoremap ^h .|		cnoremap ^h .
inoremap ^v /|		cnoremap ^v /

inoremap § <C-O><C-Z>
nnoremap § <C-Z>
cnoremap § <C-U>ter 

" Arrows" -----------------------------{{{
inoremap <C-J> <Left>|  cnoremap <C-J> <Left>|  tnoremap <C-J> <Left>
inoremap <C-K> <Right>| cnoremap <C-K> <Right>| tnoremap <C-K> <Right>

" Home,End" ---------------------------{{{
inoremap ^j <Home>| cnoremap ^j <Home>| tnoremap ^j <Home>
inoremap ^k <End>|  cnoremap ^k <End>|  tnoremap ^k <End>

" Backspace,Delete" -------------------{{{
tnoremap <C-L> <Del>
inoremap <C-L> <Del>|   cnoremap <C-L> <Del>| smap <C-L> <Del>

" Graphical Layout:--------------------{{{
" Colorscheme, Highlight groups" ------{{{
colorscheme empower
"nnoremap <LocalLeader>h :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
"nnoremap <LocalLeader>H :OmniSharpHighlightEchoKind<CR>
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
elseif(&term == 'win32' && !empty($SSH_TTY))
  let &t_ti.="\<Esc>[1 \q"
  let &t_SI.="\<Esc>[5 \q"
  let &t_EI.="\<Esc>[1 \q"
  let &t_te.="\<Esc>[0 \q"
elseif &term == 'win32' && empty($SSH_TTY)
  let &t_ti.=" \<Esc>[1 q"
  let &t_SI.=" \<Esc>[5 q"
  let &t_EI.=" \<Esc>[1 q"
  let &t_te.=" \<Esc>[0 q"
	endif

" Buffers, Windows & Tabs" ------------{{{
set hidden
set splitbelow
set splitright
set noequalalways " keep windows viewport when splitting
set previewheight=25
set showtabline=0

" Close Buffers
function! DeleteBuffers(regex)
	exec 'bd' join(filter(copy(range(1, bufnr('$'))), { _,y -> bufname(y)=~ a:regex }), ' ')
endfunc

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
nnoremap <silent> <Leader>s :silent! split<CR>
nnoremap <silent> <Leader>v :silent! vsplit<CR>
nnoremap <silent> K :q<CR>
nnoremap <silent> <Leader>o <C-W>_<C-W>\|
nnoremap <silent> <Leader>O mW:-tabnew<CR>`W
nnoremap <silent> <Leader>x :tabclose<CR>

function! SynchronizeBufferHistoryWithLastWindow()
	let lastWinNr = winnr('#')
	let lastBufNr = winbufnr(lastWinNr)
	if fnamemodify(bufname(), ':p') == fnamemodify(bufname(lastBufNr), ':p')
		call cursor(getcurpos(win_getid(winnr('#')))[1:])
		let w:buffers=getwinvar(winnr('#'), 'buffers', [])
	endif
endfunction

augroup splits
	au!
	autocmd! WinNew * call SynchronizeBufferHistoryWithLastWindow()
	autocmd! WinNew * set nowrap
augroup end

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

augroup windows
	autocmd!
	"
	" Use foldcolumn to give a visual clue for the current window
	autocmd WinLeave * if !pumvisible() | setlocal norelativenumber foldcolumn=0 | endif
	autocmd WinEnter * if !pumvisible() | setlocal relativenumber   foldcolumn=1 | endif
	" Safety net if I close a window accidentally
	autocmd QuitPre * mark K
	autocmd FileType nofile nnoremap <buffer> K :bd!<CR>
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
	\    'filename_or_qftitle': 'FileNameorQfTitle',
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
	\        ['filename_or_qftitle', 'readonly', 'modified' ],
	\        [ 'gitinfo', 'sharpenup' ]
	\    ]
	\ },
	\ 'inactive': {
	\    'left':  [
	\        ['winnr']
	\    ],
	\    'right': [
	\        [ 'filename_or_qftitle', 'readonly', 'modified' ],
	\        [ 'gitinfo', 'sharpenup' ]
	\    ]
	\ }
	\}
let timer = timer_start(20000, 'UpdateStatusBar',{'repeat':-1})

function! UpdateStatusBar(timer)
  exec 'let &ro = &ro'
endfunction

" Motions:-----------------------------{{{
nnoremap zl zL
nnoremap zL zl
nnoremap zH zh
nnoremap zh zH

" Browsing File Architecture" ---------{{{
let g:qfprio = 'c'
let g:framingoffset = 5

function! Reframe()
	setlocal scrolloff=5
	normal! zt
	setlocal scrolloff=-1
endfunction
command! -bar Reframe call Reframe()
nnoremap <silent> zt :Reframe<CR>
nnoremap <silent> zT zt

function! Qfnext()
	if g:qfprio == 'l'
		try
			lnext
		catch
			silent! ll
		endtry
	elseif g:qfprio == 'c'
		try
			cnext
		catch
			silent! cc
		endtry
	endif
endfunction

function! Qfprev()
	if g:qfprio == 'l'
		try
			lprev
		catch
			silent! ll
		endtry
	elseif g:qfprio == 'c'
		try
			cprev
		catch
			silent! cc
		endtry
	endif
endfunction

function! BrowseLayoutDown()
	if &diff
		silent! normal! ]czxzz
	elseif get(ale#statusline#Count(bufnr('')), 'error', 0)
		ALENext
	else
		let quickfixbuffers =filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')
		if !empty(quickfixbuffers)
			let loclistbuffers = filter(map(copy(quickfixbuffers), {_,x ->getwininfo(win_getid(v:val))[0]}), {_,x -> get(x, 'loclist', 0) == 1})
			let qflistbuffers = filter(map(copy(quickfixbuffers), {_,x ->getwininfo(win_getid(v:val))[0]}), {_,x -> get(x, 'loclist', 0) == 0})
			if !empty(loclistbuffers) && empty(qflistbuffers)
				let g:qfprio = 'l'
			elseif !empty(qflistbuffers) && empty(loclistbuffers)
				let g:qfprio = 'c'
			endif
		endif
		call Qfnext()
	endif
	silent! normal! zv
	normal! m'
endfunction
nnoremap <silent> <C-J> :call BrowseLayoutDown()<CR>

function! BrowseLayoutUp()
	if &diff
		silent! normal! [czxzz
	elseif get(ale#statusline#Count(bufnr('')), 'error', 0)
		ALEPrevious
	else
		let quickfixbuffers =filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')
		if !empty(quickfixbuffers)
			let loclistbuffers = filter(map(copy(quickfixbuffers), {_,x ->getwininfo(win_getid(v:val))[0]}), {_,x -> get(x, 'loclist', 0) == 1})
			let qflistbuffers = filter(map(copy(quickfixbuffers), {_,x ->getwininfo(win_getid(v:val))[0]}), {_,x -> get(x, 'loclist', 0) == 0})
			if !empty(loclistbuffers) && empty(qflistbuffers)
				let g:qfprio = 'l'
			elseif !empty(qflistbuffers) && empty(loclistbuffers)
				let g:qfprio = 'c'
			endif
		endif
		call Qfprev()
	endif
	silent! normal! zv
	normal! m'
endfunction
nnoremap <silent> <C-K> :call BrowseLayoutUp()<CR>

function! GetVisibleLocListWinNrs()
	return filter(range(1, winnr('$')), {_,x -> getwinvar(x, "&ft") == "qf" && get(getwininfo(win_getid(x))[0], 'loclist', 0) == 1 })
endfunction

function! IsLocListVisible()
	return !empty(GetVisibleLocListWinNrs())
endfunction

function! GetVisibleQListWinNrs()
	return filter(range(1, winnr('$')), {_,x -> getwinvar(x, "&ft") == "qf" && get(getwininfo(win_getid(x))[0], 'loclist', 0) == 0 })
endfunction

function! IsQListVisible()
	return !empty(GetVisibleQListWinNrs())
endfunction

" Jump to last insert mode
augroup lastinsert
	au!
	autocmd! InsertLeave * normal! mI
augroup end
nnoremap gi `I

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

" Wild Menu" --------------------------{{{
set wildmenu
set wildcharm=<Tab>
set wildignorecase
set wildmode=full

" Sourcing" ---------------------------{{{
function! RunCurrentlySelectedScriptInNewBufferAsync()
	let script = GetCurrentlySelectedScriptOnOneLine()
	let script = ExpandEnvironmentVariables(script)
	let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Job')
	if g:isWindows
		let len = len(script)
		if len < 8150
			let cmd = 'cmd /C '.script
		else
			let powershell = executable('pwsh') ? 'pwsh' : 'powershell'
			let script = substitute(script, "'", "`'", 'g')
			let script = substitute(script, '"', "'", 'g')
			let cmd = powershell.' -NoLogo -NoProfile -NonInteractive -Command remove-item alias:curl; '.script
		endif
	endif
	echomsg "<start> ".script | redraw
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
			\'exit_cb':  function('DisplayScriptOutputInNewWindow', [scratchbufnr])
		\}
	\)
endfunc

function! DisplayScriptOutputInNewWindow(scratchbufnr, job, status)
	if winnr('$') < 5
	let ea = &equalalways
	let &equalalways=1
	1wincmd w
	let winleft = winnr()
	wincmd l
	let winright = winnr()
	while winleft != winright
		wincmd J
		wincmd k
	let winleft = winnr()
	wincmd l
	let winright = winnr()
	endwhile
	let &equalalways = ea
	exec 'vert botright sbuffer' a:scratchbufnr
	else
		exec '-tab sbuffer' a:scratchbufnr
	endif
	normal! gg
endfunction

command! AsyncTSplitCurrentlySelectedScriptInNewBuffer call RunCurrentlySelectedScriptInNewBufferAsync()
vnoremap <silent> <Leader>S mv:<C-U>AsyncTSplitCurrentlySelectedScriptInNewBuffer<CR>`v
nnoremap <silent> <Leader>S mvvip}}}:<C-U>AsyncTSplitCurrentlySelectedScriptInNewBuffer<CR>`v
vnoremap <silent> <Leader>V mvy:exec @@<CR>`v
nnoremap <silent> <Leader>V mv^y$:exec @@<CR>`v

function! GetCurrentlySelectedScriptOnOneLine()
	let lines = GetCurrentlySelectedScriptLines()
	let oneliner = SquashAndTrimLines(lines)
	return oneliner
endfunc

function! ExpandEnvironmentVariables(script)
	let mayHaveEnvironmentVars = (stridx(a:script, '$') > -1)
	if (!mayHaveEnvironmentVars)
		return a:script
	endif

	let script = a:script
	let environmentvars = sort(items(environ()), {a,b -> len(b[0]) - len(a[0])})
	for [key, value] in environmentvars
		let var = '$'.key
		if (stridx(script, var) == -1)
			continue
		endif
		let script = substitute(script, var, value, 'g')
	endfor
	return script
endfunc

function! GetCurrentlySelectedScriptLines()
	return getline("'<", "'>")
endfunc

function! SquashAndTrimLines(lines)
	if len(a:lines) == 0
		return ''
	elseif len(a:lines) == 1
		return trim(a:lines[0], " \t`")
	else
		let lines = a:lines
		let firstSnippetSep = match(a:lines, '```')
		if (firstSnippetSep != -1)
			let secondSnippetSep = match(a:lines, '```', firstSnippetSep+1)
			let lines = a:lines[firstSnippetSep+1:secondSnippetSep-1]
		endif
		return join(map(lines, { _,x -> ' '.trim(x, " \t")}), ' ')[1:]
	endif
endfunc

" Write output of a vim command in a buffer
nnoremap ç :let script=''\|call histadd('cmd',script)\|put=execute(script)<Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>
augroup vimsourcing
	au!
	if has('win32') && has('gui_running')
		autocmd BufWritePost .vimrc,_vimrc,*.vim GvimTweakToggleFullScreen | so % | GvimTweakToggleFullScreen
	else
		autocmd BufWritePost .vimrc,_vimrc,*.vim so %
	endif
	autocmd FileType vim nnoremap <buffer> z! :BLines function!\\|{{{<CR>
augroup end

" Find, Grep, Make, Equal" ------------{{{
function! Grep(qf_or_loclist, ...)
	let pattern = a:1
	let i = 1
	while ((count(pattern, '"') - count(pattern, '\"')) % 2) == 1
		let pattern .= a:000[i]
		let i+=1
	endwhile
	let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/'.substitute(pattern, '\s', '_', 'g'))
	let cmd = 'rg --vimgrep --no-heading --smart-case --no-ignore-parent '.join(a:000, ' ')
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
			\'exit_cb': function("GrepCB", [pattern, scratchbufnr, a:qf_or_loclist])
		\}
	\)
endfunction

function! GrepCB(pattern, scratchbufnr, qf_or_loclist,...)
	let result = getbufline(a:scratchbufnr, 1, '$')
	let nb = len(result)
	if nb == 1 && empty(result[0])
		echomsg printf('[%s] 0 found.', a:pattern)
		return
	endif
	echomsg printf('[%s] %d found.', a:pattern, nb)
	set errorformat=%f:%l:%c:%m
	let prefix = (a:qf_or_loclist == 'qf' ? 'c' : 'l')
	silent exec prefix.'getbuffer' a:scratchbufnr
	silent exec prefix.'window'
	if &ft == 'qf'
		let w:quickfix_title = printf('[grep] %s', a:pattern)
	endif
endfunction
command! -nargs=+ Grep  call Grep('qf',     <f-args>)
command! -nargs=+ Lgrep call Grep('loclist',<f-args>)

set switchbuf+=uselast
set errorformat=%m
nnoremap <Leader>f :Files<CR>
nnoremap <leader>F :Files $git<CR>
nnoremap <Leader>r :Grep <C-R><C-W><CR>
vnoremap <Leader>r "vy:let cmd = printf('Grep %s',@v)\|call histadd('cmd',cmd)\|exec cmd<CR>
nnoremap <Leader>R :Grep 
nnoremap <LocalLeader>m :silent make<CR>

" Terminal" ---------------------------{{{
tnoremap <silent> <Leader>hh <C-W>h
tnoremap <silent> <Leader>jj <C-W>j
tnoremap <silent> <Leader>kk <C-W>k
tnoremap <silent> <Leader>ll <C-W>l
tnoremap <silent> <Leader><home><home> 1<C-W>W
tnoremap <silent> <Leader><end><end> 99<C-W>W
tnoremap <silent> <Leader>nn <C-W>gt
tnoremap <silent> <Leader>NN :tabnew<CR>
tnoremap <silent> <Leader>pp <C-W>gT
tnoremap <silent> <Leader>xx <C-W>:tabclose<CR>
tnoremap <silent> <Leader>ss <C-W>:new<CR>
tnoremap <silent> <Leader>vv <C-W>:vnew<CR>
tnoremap <silent> <Leader>oo <C-W>:only<CR>i
tnoremap <silent> <Leader>OO <C-W>:exec 'tabnew \|b'.bufnr()<CR>
tnoremap <silent> <Leader>== <C-W>=
tnoremap <silent> KK <C-W>:q<CR>
tnoremap <silent> HH <C-W>:CycleBackwards<CR>
tnoremap <silent> LL <C-W>:CycleForward<CR>

" Folding" ----------------------------{{{
vnoremap <silent> <space> <Esc>zE:let b:focus_mode=1 \| setlocal foldmethod=manual<CR>`<kzfgg`>jzfG`<
nnoremap <silent> <space> :exec('normal! '.(b:focus_mode==1 ? 'zR' : 'zM')) \| let b:focus_mode=!b:focus_mode<CR>

function! FoldExprToday(lnum)
	let lnum = a:lnum == '.' ? line('.') : a:lnum
	let line = getline(lnum)
	if line =~ '^\s*$'
		return 0
	endif
	let nbStars = len(matchstr(getline(lnum), "^\\(\\*\\)*"))
	if nbStars > 0
		let nextLine = getline(lnum+1)
		return nextLine == '' ? 1 : (len(matchstr(nextLine, "^\\(\\*\\)*")) > 0) ? 0 : 1
	else
		return 1
	endif
endfunction

set foldtext=FoldText()
function! FoldText()
	let foldstart = v:foldstart
	while getline(foldstart) =~ '^\s*\({\|\/\|<\|[\|#\)'
		let foldstart += 1
	endwhile
	let title = getline(foldstart)[len(v:folddashes)-1:]
	return repeat('-', len(v:folddashes)-1).title.' ('.(v:foldend-v:foldstart+1).'rows)'
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
nnoremap / !
vnoremap / !

nnoremap z! m`:BLines<CR>
command! UnderlineCurrentSearchItem silent call matchadd('ErrorMsg', '\c\%#'.@/, 101)
nnoremap <silent> n :keepjumps normal! n<CR>:UnderlineCurrentSearchItem<CR>
nnoremap <silent> N :keepjumps normal! N<CR>:UnderlineCurrentSearchItem<CR>
nnoremap <silent> * :let w=escape(expand('<cword>'), '\*[]~')\|call histadd('search', w)\|let @/=w\|set hls<CR>
vnoremap <silent> * "vy:let w=escape(@v, '\*[]~')\|call histadd('search', w)\|let @/=w\|set hls<CR>

let hits=[]
cnoremap <expr> <C-S> SubstituteIntoArray()

function! SubstituteIntoArray()
	let range = getcmdline()
	let action = ''
	if empty(range)
		let range = '%'
		let action  = 'substitute'
	elseif range == "'<,'>"
		let action  = 'substitute'
	else
		let action = 'getSln'
	endif
	if action == 'substitute'
		let sep = (stridx(@/, '/') >= 0) ? (stridx(@/, '#') >= 0) ? (stridx(@/, ':') >= 0) ? '~' : ':' : '#' : '/'
		let cmd = "\<C-U>".range."s".sep."\<C-R>=@/\<CR>".sep."\\=add(hits, submatch(0))".sep."gne\|echomsg hits"
		let cmd .= "\<Home>".repeat("\<Right>", len(range.'s/'))
		return cmd
	endif
	if action == 'getSln'
		let cmd = GetNearestPathInCurrentFileParents("*.sln")
		if empty(cmd)
			let cmd = shellescape(substitute(GetNearestPathInCurrentFileParents('*.csproj'), '\\', '/', 'g'))
		endif
		return cmd
	endif
endfunction

augroup quicksearch
	au!
	autocmd BufEnter * nnoremap          <buffer> [( /\w\+\s*(\ze\s*<home>
	autocmd BufEnter * nnoremap          <buffer> ]( /\w\+\s*(\s*\zs
	autocmd BufEnter * nnoremap          <buffer> [s /\w\+\s*[\ze\s*<home>
	autocmd BufEnter * nnoremap          <buffer> ]d /\w\+\s*[\s*\zs
	autocmd BufEnter * nnoremap          <buffer> [q /\w\+\s*{\ze\s*<home>
	autocmd BufEnter * nnoremap          <buffer> ]f /\w\+\s*{\s*\zs
	autocmd BufEnter * nnoremap          <buffer> [< /\w\+\s*<\ze\s*<home>
	autocmd BufEnter * nnoremap          <buffer> ]< /\w\+\s*<\s*\zs
	autocmd BufEnter * nnoremap          <buffer> [= /\w\+\s*=\ze\s*<home>
	autocmd BufEnter * nnoremap          <buffer> ]= /\w\+\s*=\s*\zs
	autocmd BufEnter * nnoremap          <buffer> [: /\w\+\s*:\ze\s*<home>
	autocmd BufEnter * nnoremap          <buffer> ]: /\w\+\s*:\s*\zs
	autocmd BufEnter * nnoremap          <buffer> [, /\w\+\s*,\ze\s*<home>
	autocmd BufEnter * nnoremap          <buffer> ], /\w\+\s*,\s*\zs
	autocmd BufEnter * nnoremap          <buffer> [& /\w\+\s*&\ze\s*<home>
	autocmd BufEnter * nnoremap          <buffer> ]& /\w\+\s*&\s*\zs
	autocmd BufEnter * nnoremap          <buffer> [\| /\w\+\s*\|\ze\s*<home>
	autocmd BufEnter * nnoremap          <buffer> ]\| /\w\+\s*\|\s*\zs
	autocmd BufEnter * nnoremap <silent> <buffer> [" /\(\s\|\[\|\(\|"\|`\)(\$\|@\|\s\)*"\zs\(\s\)*\w\+.*\ze"<CR>
	autocmd BufEnter * nnoremap <silent> <buffer> [' /\(\s\|\[\|\(\|"\|'\)(\s\|\[\|(\|"\|`\)'\zs\(\s\)*\w\+.*\ze'<CR>
	autocmd BufEnter * nnoremap <silent> <buffer> [` /\(\s\|\[\|\(\|"\|'\)`\zs\s*\w\+.*\ze`<CR>
augroup end

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
set updatetime=250
set complete=.,b
set completeopt+=menuone,noselect,noinsert

function! AsyncAutocomplete()
	if PreviousCharacter() =~ '\w\|\.'
		call feedkeys(&omnifunc!='' ? "\<C-X>\<C-O>" : "\<C-N>", 't')
	endif
endfunction
command! AsyncAutocomplete call AsyncAutocomplete()

augroup autocompletion
	au!
	autocmd CursorHoldI * AsyncAutocomplete
	autocmd User UltiSnipsEnterFirstSnippet mark '
augroup end

let g:UltiSnipsExpandTrigger = "<nop>"
let g:UltiSnipsJumpForwardTrigger="<nop>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="horizontal"


inoremap <C-I> <C-R>=ExpandSnippetOrValidateAutocompletionSelection()<CR>
xnoremap <C-I> :call UltiSnips#SaveLastVisualSelection()<cr>gvs
snoremap <C-I> <esc>:call UltiSnips#ExpandSnippetOrJump()<CR>
snoremap <C-O> <esc>:call UltiSnips#JumpBackwards()<CR>
nnoremap <Leader>u :UltiSnipsEdit!<CR>G
nnoremap <Leader>U :call UltiSnips#RefreshSnippets()<CR>
inoremap <C-O> <C-X><C-O>


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
set diffopt+=algorithm:histogram,indent-heuristic,vertical,iwhite

augroup diff
	au!
	autocmd OptionSet diff let &cursorline=!v:option_new
	autocmd OptionSet diff silent! 1 | silent! normal! ]c
augroup end

" QuickFix, Preview, Location window" -{{{
let g:ale_set_loclist = 0
let g:qfpreview = {
	\'top': "\<Home>",
	\'bottom': "\<End>",
	\'scrolldown': "\<Down>",
	\'scrollup': "\<Up>",
	\'next': "\<C-j>",
	\'previous': "\<C-k>",
	\'reset': "\<space>",
	\'height': "30",
	\'offset': "10",
	\'close': "q",
	\'number': 1,
	\'sign': {'texthl': 'PmenuSel', 'linehl': 'PmenuSel'}
\}
hi link QfPreviewTitle Visual

function! GetQfListCurrentItemPath()
	if &ft != 'qf'
		return -1
	endif
	let line = getline(line('.'))
	return trim(line[:stridx(line, '|')-1])
endfunction

function! GetQfListCurrentItemBufNr()
	if &ft != 'qf'
		return -1
	endif
	let list = IsLocListWindow() ? getloclist(0) : getqflist()
	return list[line('.')-1]
endfunction

function! OpenQfListCurrentItem(openCmd)
	let item = GetQfListCurrentItemBufNr()
	let isLocList = IsLocListWindow()
	exec isLocList ? "quit" : "wincmd p"
		exec a:openCmd '+'.item.lnum item.bufnr
	if item.lnum
		call cursor(item.lnum, item.col)
		Reframe
	endif
endfunction
command! -bar EditQfItemInPreviousWindow call OpenQfListCurrentItem('buffer')
command! -bar SplitQfItemBelow call OpenQfListCurrentItem('sbuffer')
command! -bar SplitQfItemAbove SplitQfItemBelow | wincmd x | wincmd k
command! -bar VSplitQfItemRight call OpenQfListCurrentItem('vertical sbuffer')
command! -bar VSplitQfItemLeft VSplitQfItemRight | wincmd x | wincmd h
command! -bar TSplitQfItemBefore call OpenQfListCurrentItem('-tab sbuffer')
command! -bar TSplitQfItemAfter call OpenQfListCurrentItem('tab sbuffer')

function! LocListOlder()
	if IsLocListVisible()
		try | lolder | catch | finally | let g:qfprio='l' | endtry
	else
		lwindow
	endif
endfunction

function! LocListNewer()
	if IsLocListVisible()
		try | lnewer | catch | finally | let g:qfprio='l' | endtry
	else
		lwindow
	endif
endfunction

function! QListOlder()
	if IsQListVisible()
		try | colder | catch | finally | let g:qfprio='c' | endtry
	else
		cwindow
	endif
endfunction

function! QListNewer()
	if IsQListVisible()
		try | cnewer | catch | finally | let g:qfprio='c' | endtry
	else
		cwindow
	endif
endfunction

function! QfOlder()
	if IsLocListWindow()
		call LocListOlder()
	else
		call QListOlder()
	endif
endfunction
command! QfOlder call QfOlder()

function! QfNewer()
	if IsLocListWindow()
		call LocListNewer()
	else
		call QListNewer()
	endif
endfunction
command! QfNewer call QfNewer()

augroup quickfix
	au!
	autocmd FileType qf set nowrap
	autocmd FileType qf call SetParticularQuickFixBehaviour()
	autocmd FileType qf if IsQuickFixWindow() | wincmd J | endif
	autocmd FileType qf exec 'resize' min([15, line('$')])
	autocmd CompleteDone * if pumvisible() == 0 | silent! pclose | endif
	autocmd QuickFixCmdPost l*    nested lwindow
	autocmd QuickFixCmdPost [^l]* nested cwindow
	autocmd FileType qf nnoremap <buffer> <space> :call FilterQf()<CR>
	autocmd FileType qf nnoremap <buffer> <silent> o :VSplitQfItemRight<CR>
	autocmd FileType qf nnoremap <buffer> <silent> O :VSplitQfItemLeft<CR>
	autocmd FileType qf nnoremap <buffer> <silent> a :SplitQfItemBelow<CR>
	autocmd FileType qf nnoremap <buffer> <silent> A :SplitQfItemAbove<CR>
	autocmd FileType qf nnoremap <buffer> <silent> t :TSplitQfItemBefore<CR>
	autocmd FileType qf nnoremap <buffer> <silent> T :TSplitQfItemAfter<CR>
	autocmd FileType qf     nmap <buffer> <silent> i :EditQfItemInPreviousWindow<CR>
	autocmd FileType qf     nmap <buffer> p <plug>(qf-preview-open)
	autocmd FileType qf if IsQuickFixWindow() | nnoremap <buffer> <CR> <CR>:Reframe<CR>| endif
	autocmd FileType qf nnoremap <silent> <buffer> H :QfOlder<CR>
	autocmd FileType qf nnoremap <silent> <buffer> L :QfNewer<CR>
augroup end

function! FilterQf()
	let qftitle = w:quickfix_title
	if qftitle =~ '^Usages: '
		Cfilter! /Test.\?\.cs/
		call matchadd('Conceal', '^\([^/|]\+\/\)*')
		set conceallevel=3 concealcursor=nvic
		let w:quickfix_title = qftitle.' [no_test]'
	elseif qftitle == 'Members'
		Cfilter +
		call matchadd('Conceal', '^\([^/|]\+\/\)*')
		set conceallevel=3 concealcursor=nvic
		let w:quickfix_title = qftitle.' [public]'
	else
		call feedkeys(':Cfilter')
	endif
endfunction

function! SetParticularQuickFixBehaviour()
	if empty(get(w:, 'quickfix_title'))
		return
	endif
	nnoremap <buffer> <silent> dd <CR>:Gdiffsplit !~<CR>
	vnoremap <buffer> <silent> dd :<C-U>let v1=GetFileVersionID("'<") \| let v2=GetFileVersionID("'>") \| exec 'Gtabedit' v1 \| exec 'Gdiffsplit' v2<CR>
	nnoremap <buffer> <silent> D  <CR>:Gdiffsplit<CR><C-W>h
	nnoremap <buffer> <silent> C  :exec 'Gtabedit' GetSha()<CR>
	cnoremap <buffer> <C-R><C-G> <C-R>=GetSha()<CR>
endfunction

function! GetSha(...)
	let linenr= a:0 == 0 ? '.' : a:1
	let line=getline(linenr)
	return line[:stridx(line,':')-1] 
endfunction

function! GetFileVersionID(...)
	let linenr= a:0 == 0 ? '.' : a:1
	let line=getline(linenr)
	return line[:stridx(line,'|')-1] 
endfunction

function! QuickFixTextFunc(info)
	return len(a:info) > 42 ? a:info : QuickFixVerticalAlign(a:info)
endfunc

function! QuickFixVerticalAlign(info)
	if a:info.quickfix
		let qfl = getqflist({'id': a:info.id, 'items': 0}).items
	else
		let qfl = getloclist(a:info.winid, {'id': a:info.id, 'items': 0}).items
	endif
	let modules_are_used = empty(qfl) ? 1 : (get(qfl[0], 'module', '') != '')
	let l = []
	let efm_type = {'e': 'error', 'w': 'warning', 'i': 'info', 'n': 'note'}
	let lnum_width =   len(max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), { _,v -> qfl[v].lnum })))
	let col_width =    len(max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), {_, v -> qfl[v].col})))
	let fname_width =  max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), modules_are_used ? {_, v -> strchars(qfl[v].module, 1)} : {_, v -> strchars(substitute(fnamemodify(bufname(qfl[v].bufnr), ':.'), '\\', '/', 'g'), 1)}))
	let type_width =   max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), {_, v -> strlen(get(efm_type, qfl[v].type, ''))}))
	let errnum_width = len(max(map(range(a:info.start_idx - 1, a:info.end_idx - 1),{_, v -> qfl[v].nr})))
	for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
		let e = qfl[idx]
		let e.text = substitute(e.text, '\%x00', ' ', 'g')
		if stridx(e.text, ' Expected: ') >= 0
			let e.text = substitute(e.text, ' Actual:   ', '   Actual: ', '')
		endif
		if !e.valid
			call add(l, '|| '.e.text)
		else
			let fname = printf('%-*S', fname_width, modules_are_used ? e.module : substitute(fnamemodify(bufname(e.bufnr), ':.'), '\\', '/', 'g'))
			if e.lnum == 0 && e.col == 0
				call add(l, printf('%s|| %s', fname, e.text))
			else
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
set quickfixtextfunc=QuickFixTextFunc

" Marks"-------------------------------{{{
" H and L are used for cycling between buffers and `A is a pain to type
nnoremap M `

" Changelist"--------------------------{{{
nnoremap g; g;zv
nnoremap g, g,zv

" Additional Functionalities:----------{{{
" Buffer navigation"-------------------{{{
nnoremap <silent> H :CycleBackwards<CR>
nnoremap <silent> L :CycleForward<CR>

" Fuzzy Finder"------------------------{{{
" Makes Omnishahrp-vim code actions select both two elements
"let g:fzf_layout = { 'window': { 'width': 0.39, 'height': 0.25 } }
"let g:fzf_preview_window = []
let $FZF_DEFAULT_OPTS="--bind up:preview-up,down:preview-down"

augroup my_fzf"------------------------{{{
	au!
	autocmd FileType fzf tnoremap <buffer> <C-V> <C-V>
	autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
	autocmd FileType fzf tnoremap <buffer> <C-J> <C-J>
	autocmd FileType fzf tnoremap <buffer> <C-K> <C-K>
	autocmd FileType fzf tnoremap <buffer> <C-O> <C-T>
augroup end

nnoremap <Leader>g :GFiles?<CR>
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
command! CycleForward call CycleWindowBuffersHistoryForward()

function! CycleWindowBuffersHistoryBackwards()
	let w:buffers = [w:buffers[-1]] + w:buffers[:-2]
	let w:skip_tracking_buffers = 1
	while !bufexists(w:buffers[-1])
		call remove(w:buffers, -1)
	endwhile
	exec 'buffer' w:buffers[-1]
	let w:skip_tracking_buffers = 0
endfunction
command! CycleBackwards call CycleWindowBuffersHistoryBackwards()

" Full screen & Opacity" ------------------------{{{
if has('win32') && has('gui_running')
	let g:gvimtweak#window_alpha=255 " alpha value (180 ~ 255) default: 245
	let g:gvimtweak#enable_alpha_at_startup=1
	let g:gvimtweak#enable_topmost_at_startup=0
	let g:gvimtweak#enable_maximize_at_startup=1
	let g:gvimtweak#enable_fullscreen_at_startup=1
	nnoremap <silent> ° :GvimTweakToggleFullScreen<CR>
	nnoremap <silent> <A-n> :GvimTweakToggleTransparency<CR>
	nnoremap <silent> <A-i> :GvimTweakSetAlpha -10<CR>| tmap <silent> <A-o> <C-W>N:GvimTweakSetAlpha -10<CR>i
	nnoremap <silent> <A-o> :GvimTweakSetAlpha 10<CR>| tmap <silent> <A-i> <C-W>N:GvimTweakSetAlpha 10<CR>i
	inoremap <silent> <A-n> <C-O>:GvimTweakToggleTransparency<CR>
endif
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
		let cmd = printf('cmd /C %s %s "%s" "%s"', $gtools.'/cp', isdirectory(item)?'-r':'', item, item_finalname)
		let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': getcwd(),
				\'err_cb':   { chan,msg  -> execute("echomsg '".substitute(msg,"'","''","g")."'",  1) },
				\'exit_cb':  function('RefreshBufferAndMoveToPath', [item_finalname])
			\}
		\)
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
		let cmd = printf('cmd /C %s "%s"', $gtools.'/rm -r', target)
		let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': getcwd(),
				\'err_cb':   { chan,msg  -> execute("echomsg '".substitute(msg,"'","''","g")."'",  1) },
				\'exit_cb':  function('RefreshBufferAndMoveToPath')
			\}
		\)
	else
		let target = '/'.target
		let cmd = (isdirectory(target)) ?  printf('rm -r "%s"',target) : printf('rm "%s"', target)
		silent exec '!'.cmd '&' | redraw!
		normal R
	endif
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
		let cmd = printf('cmd /C %s "%s" "%s"', $gtools.'/mv', item, item_finalname)
		let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': getcwd(),
				\'err_cb':   { chan,msg  -> execute("echomsg '".substitute(msg,"'","''","g")."'",  1) },
				\'exit_cb':  function('RefreshBufferAndMoveToPath', [item_finalname])
			\}
		\)
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
		let cmd = printf('cmd /C %s "%s" "%s"', $gtools.'/mv', filename, newname)
		let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': getcwd(),
				\'err_cb':   { chan,msg  -> execute("echomsg '".substitute(msg,"'","''","g")."'",  1) },
				\'exit_cb':  function('RefreshBufferAndMoveToPath', [newname])
			\}
		\)
	else
		let cmd = printf('mv "%s" "%s"', filename, newname)
		silent exec '!'.cmd '&' | redraw!
		normal R
	endif
endfunction

function! GetCurrentLineAsPath()
	return trim(getline('.'), '\')
endfunc

function! GetCurrentLinePath()
	let line = getline('.')
	let farthest = FindLastOccurrencePos(line, '|`')
	let path = line[farthest+3:]
	if fnamemodify(path, ':p') == path
		return substitute(path, '/', '\', 'g')
	endif
	for i in range(line('.')-1, 1, -1)
		let currentline = getline(i)
		let lastVerticalBarPos = FindLastOccurrencePos(currentline, '|`')
		if lastVerticalBarPos < farthest
			let start = lastVerticalBarPos+ (lastVerticalBarPos == -1 ? 1 : 3)
			let path = currentline[start:] . '/' . path
			let farthest = lastVerticalBarPos
		endif
	endfor
	return substitute(path, '/', '\', 'g')
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
		let cmd = printf('cmd /C %s %s', $gtools.'/mkdir', shellescape(dirname))
		let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': getcwd(),
				\'err_cb':   { chan,msg  -> execute("echomsg '".substitute(msg,"'","''","g")."'",  1) },
				\'exit_cb':  function('RefreshBufferAndMoveToPath', [dirname])
			\}
		\)
	else
		silent exec '!mkdir' dirname '&' | redraw!
		normal R
		exec '/'.escape(getcwd(), '/').'\/'.dirname.'\/$'
	endif
	nohlsearch
endf

function! RefreshBufferAndMoveToPath(path, ...)
	normal R
	if empty(a:path)
		return
	endif
	let search = escape(getcwd(), '\').'\\'.a:path.(isdirectory(a:path) ? '\\$' : '$')
	silent! exec '/'.search
	let @/=search
endfunction

function! CreateFile()
	let filename = PromptUserForFilename('File name:')
	if trim(filename) == ''
		return
	endif
	if has('win32')
		let cmd = printf('cmd /C %s %s', $gtools.'/touch', shellescape(filename))
		let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': getcwd(),
				\'err_cb':   { chan,msg  -> execute("echomsg '".substitute(msg,"'","''","g")."'",  1) },
				\'exit_cb':  function('RefreshBufferAndMoveToPath', [filename])
			\}
		\)
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
	autocmd FileType dirvish nnoremap <silent> <buffer> gF :silent! call PreviewFile('-tabnew', 1)<CR>
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
	autocmd FileType dirvish nnoremap <silent> <buffer> <space> :call GoToGitRoot()<CR>
	autocmd FileType dirvish nmap <silent> <buffer> <leader>w :exec 'Firefox' GetCurrentLineAsPath()<CR>
	autocmd FileType dirvish nnoremap <buffer> <silent> <LocalLeader>m :BuildTestCommit<CR>
	autocmd FileType dirvish nnoremap <buffer> <silent> <LocalLeader>M :BuildTestCommitAll!<CR>
	autocmd FileType dirvish nnoremap <buffer> <LocalLeader>R :call OmniSharp#RestartServer()<CR>
	autocmd FileType dirvish command! -buffer -bar -nargs=? -complete=file OmniSharpStartServer call OmniSharp#StartServer(<q-args>)
	autocmd FileType dirvish nnoremap <buffer> <LocalLeader>O :OmniSharpStartServer 
augroup end

function! GoToGitRoot()
	let gitroot = fnamemodify(gitbranch#dir(expand('%:p')), ':h')
	exec 'Dirvish' gitroot
	exec 'lcd' gitroot
endfunction

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
	let s:job= job_start('firefox.exe "'. BuildFirefoxUrl((a:0 == 0 || (a:0 == 1 && a:1 == '')) ? GetCurrentSelection() : join(a:000)) .'"')
endfun
command! -nargs=* -range Firefox :call Firefox(<q-args>)
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
cnoremap <C-B> <C-R>=gitbranch#name()<CR>

function! OpenDashboard()
	if IsInsideDashboard()
		return
	endif
	let cwd = getcwd()
	silent tab G
	-tabmove
	normal gU
	silent exec winheight(0)/4.'new'
		silent exec 'edit' $desktop.'/todo'
	silent exec winwidth(0)*2/3.'vnew'
		let bufnr = bufnr()
		silent! bdelete git\ --no-pager\ log
		let &termwinsize=''
		let buf = term_start('git --no-pager log -15', {'curwin':1, 'cwd':cwd, 'close_cb': {_ -> execute('let t = timer_start(100, function(''OnGitLogExit'', ['.bufnr.']))', '')}})
		nnoremap <buffer> <silent> t <Home>:Gtabedit <C-R><C-W><CR>
		nnoremap <buffer> <silent> i <Home>:Gedit <C-R><C-W><CR>
	wincmd h
	silent exec 'vnew' $today
	wincmd h
	silent exec '3new' $desktop.'/waiting'
	1wincmd w
	windo nnoremap <buffer> <silent> <leader>L 99<C-W>W<C-W>L:exec 'vert resize' &columns/2<CR>
endfunction
command! -bar Dashboard call OpenDashboard()
nnoremap <silent> <Leader>m :Dashboard<CR>

function! OnGitLogExit(bufnr,...)
	call setbufvar(a:bufnr, '&modifiable', 1)
	call setbufvar(a:bufnr, '&buftype', 'nofile')
	call setbufvar(a:bufnr, '&wrap', 0)
	let winid = bufwinid(a:bufnr)
	call win_execute(winid, ['call setpos(".", [0, 1, 1, 1])', 'redraw'])
	1wincmd w
endfunc

function! GetCommitTypes(findstart, base)
	if a:findstart
		return col('.')
	endif
	if line('.') == 1 && col('.') == 1
		return [
			\{ 'word': 'build',    'menu': 'Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)' },
			\{ 'word': 'ci',       'menu': 'Changes to our CI configuration files and scripts (example scopes: Circle, BrowserStack, SauceLabs)' },
			\{ 'word': 'docs',     'menu': 'Documentation only changes' },
			\{ 'word': 'feature',  'menu': 'A new feature' },
			\{ 'word': 'fix',      'menu': 'A bug fix' },
			\{ 'word': 'perf',     'menu': 'A code change that improves performance' },
			\{ 'word': 'refactor', 'menu': 'A code change that neither fixes a bug nor adds a feature' },
			\{ 'word': 'test',     'menu': 'Adding missing tests or correcting existing tests' }
		\]
	endif
	return []
endfunc

augroup dashboard
	au!
	autocmd FileType fugitive,git nnoremap <buffer> <silent> <LocalLeader>m :Git push --force-with-lease<CR>
	autocmd FileType fugitive     nmap <silent> <buffer> <space> =
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>l <C-W>l
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>h <C-W>h
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>j <C-W>j
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>k <C-W>k
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>n gt
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>p gT
	autocmd FileType fugitive     nnoremap <silent> <buffer> <Leader>o :only<CR>
	autocmd FileType gitcommit    set completefunc=GetCommitTypes
	autocmd FileType gitcommit    set textwidth=0
	autocmd FileType gitcommit    call feedkeys("i\<C-X>\<C-U>")
	autocmd FileType          git nmap     <silent> <buffer> l <CR>
	autocmd FileType          git nnoremap <silent> <buffer> h <C-O>
	autocmd BufEnter     todo,ideas,waiting,today,wip.md set buftype=nofile nowrap
	autocmd BufWritePost todo,ideas,waiting,today,wip.md set buftype=nofile
	autocmd BufEnter     todo,ideas,waiting,today normal! gg
	autocmd BufLeave     todo,ideas,waiting,today normal! gg
	autocmd BufEnter     todo,ideas,waiting,today,wip.md inoremap <buffer> <Esc> <Esc>:set buftype=<CR>:w!<CR>
	autocmd TextChanged  todo,ideas,waiting,today,wip.md set buftype= | silent write!
	autocmd BufEnter                              wip.md nnoremap <buffer> <leader>w :Firefox <C-R>=substitute(expand('%:p'), '/', '\\', 'g')<CR><CR>
	autocmd BufEnter                        today        nnoremap <buffer> <silent> <leader>w :CompileDiagramAndShowImage svg $tmp<CR>
	autocmd BufEnter                        today        set foldmethod=expr foldexpr=FoldExprToday(v:lnum)
augroup end

nnoremap <silent> <leader>d :0Gllog!<CR><C-W>j
nnoremap <silent> <leader>D :Gdiffsplit<CR>

" Drafts (Diagrams & Notes)"-----------{{{
function! LocListNotes()
	exec 'Lgrep' '"^# "' $n '-g "*.md" -g "!*.withsvgs.md"' '--sort path'
endfunction
nnoremap <silent> <leader>en :call LocListNotes()<CR>

function! LocListToDirectory(dir, title)
	let items = expand(fnamemodify(a:dir, ':p').'/*', 0, 1)
	if a:dir == $projects
		call add(items, 'C:\pristineness')
	endif
	call setloclist(0, [], " ", {'nr': '$', 'efm': '%f', 'lines': items, 'title': a:title})
	lwindow
	if(&ft == 'qf')
		call matchadd('Conceal', '^[^/|]\+/')
		set conceallevel=3 concealcursor=nvic
		nnoremap <buffer> <silent> f :let f=GetQfListCurrentItemPath() \| lclose  \| exec 'Files' f<CR>
		nnoremap <buffer> <silent> F :let f=GetQfListCurrentItemPath() \| exec 'Files' f<CR>
	endif
endfunction
nnoremap <silent> <leader>ep :call LocListToDirectory($projects,  'Projects')<CR>

function! GetFilename()
	let line = getline('.')
	let filename = line[:match(line, '\s*|')-1]
	return fnamemodify(filename, ':p')
endfunction

function! SaveInFolderAs(folder, ...)
	let args = ParseArgs(a:000, ['filetype', 'markdown'])
	let ext = get({
				\'markdown':      '.md',
				\'plaintext':     '',
				\'json':          '.json',
				\'xml':           'xml',
				\'puml_mindmap':  '.puml_mindmap',
				\'puml_activity': '.puml_activity',
				\'puml_sequence': '.puml_sequence',
				\'puml_json':     '.puml_json'
			\}, args.filetype, '.md')
	let filename = expand('%:t:r')
	if filename == ''
		let filename = PromptUserForFilename('File name:', {n -> a:folder . '/' . n . ext})
		if trim(filename) == ''
			return
		endif
	endif
	call setbufvar(bufnr(), '&bt', '')
	call setbufvar(bufnr(), '&ft', args.filetype)
	let newpath = a:folder . '/' . filename . ext
	call Move(newpath)
	if fnamemodify(newpath, ':t:e') == 'md' && getline(1) !~ '^#'
		execute 'normal!' 'ggO# '.filename."\<CR>\<esc>:w\<CR>"
	endif
endfunc
command! -nargs=? -complete=customlist,GetNoteFileTypes Note call SaveInFolderAs($notes, <q-args>)
command! -nargs=? -complete=customlist,GetTmpFileTypes  Tmp  call SaveInFolderAs($tmp,   <q-args>)

function! GetNoteFileTypes(argLead, cmdLine, cursorPos)
	return ['markdown', 'puml_mindmap', 'puml_activity', 'puml_sequence', 'puml_json']
endfunc

function! GetTmpFileTypes(argLead, cmdLine, cursorPos)
	return [ 'markdown', 'json', 'xml', 'puml_mindmap', 'puml_activity', 'puml_sequence', 'puml_json']
endfunc

function! Move(newpath)
	if (glob(a:newpath) != '')
		return
	else
		let currentpath = expand('%:p:h')
		exec 'saveas' a:newpath
		exec 'edit' a:newpath
		call delete(currentpath)
		bdelete! #
	endif
endfunc

function! JobExitDiagramCompilationJob(outputfile, scratchbufnr, inputfile, channelInfos, status)
	if a:status != 0
		exec 'botright sbuffer' a:scratchbufnr 
		exec 'vnew' a:inputfile
		return
	endif
	call system(printf($gtools.'/mv "%s" "%s.html"', a:outputfile, a:outputfile))
	call Firefox('', substitute(a:outputfile.'.html', '/', '\', 'g'))
endfunc

function! CompileTodayAndShowImageCommand()
	let inputfile = $tmp.'/today.puml_mindmap'
	let diagram = readfile($today)
	let lunch = index(diagram, '')
	let legend = index(diagram, '', lunch+1)
	let diagramAM = diagram[:lunch-1]
	let diagramAM = map(diagramAM, 'substitute((v:val[0] == "*" ? substitute(v:val[0].v:val, "*:", "*:* ", "") : "* ".v:val), "\\a", "\\U\\0", "")')
	let diagramPM = diagram[lunch+1:legend-1]
	let diagramPM = map(diagramPM, 'substitute((v:val[0] == "*" ? substitute(v:val[0].v:val, "*:", "*:* ", "") : "* ".v:val), "\\a", "\\U\\0", "")')
	let diagramLegend = map(diagram[legend+1:], 'printf("* [[%s %s%s]]", (stridx(v:val[stridx(v:val, "]")+2:-2], "http") == 0 ? v:val[stridx(v:val, "]")+2:-2] : "http://".v:val[stridx(v:val, "]")+2:-2]), toupper(v:val[stridx(v:val, "[")+1]), v:val[stridx(v:val, "[")+2:stridx(v:val, "]")-1])')
	let diagram = ['@startmindmap']
	let diagram +=	['left side', '* **__AM__ | __PM__**'] + diagramAM
	let diagram += ['right side'] + diagramPM
	let diagram += ['legend right'] + diagramLegend + ['endlegend']
	let diagram += ['@endmindmap']
	call writefile(diagram, inputfile)
	call CompileDiagramAndShowImage(inputfile, 'svg', fnamemodify(inputfile, ':h'))
endfunction
command! CompileTodayAndShowImage call CompileTodayAndShowImageCommand()
nnoremap <Leader>M :CompileTodayAndShowImage<CR>

function! CompileDiagramAndShowImageCommand(outputExtension, ...)
	let inputfile = expand('%:p')
	if substitute(inputfile, '\', '/', 'g') == $today
		let inputfile = $tmp.'/today.puml_mindmap'
		let diagram = uniq(getline(1, '$'))
		let lunch = index(diagram, '')
		let legend = index(diagram, '', lunch+1)
		let diagramAM = diagram[:lunch-1]
		let diagramAM = map(diagramAM, 'substitute((v:val[0] == "*" ? substitute(v:val[0].v:val, "*:", "*:* ", "") : "* ".v:val), "\\a", "\\U\\0", "")')
		let diagramPM = diagram[lunch+1:legend-1]
		let diagramPM = map(diagramPM, 'substitute((v:val[0] == "*" ? substitute(v:val[0].v:val, "*:", "*:* ", "") : "* ".v:val), "\\a", "\\U\\0", "")')
		let diagramLegend = map(diagram[legend+1:], 'printf("* [[%s %s%s]]", (stridx(v:val[stridx(v:val, "]")+2:-2], "http") == 0 ? v:val[stridx(v:val, "]")+2:-2] : "http://".v:val[stridx(v:val, "]")+2:-2]), toupper(v:val[stridx(v:val, "[")+1]), v:val[stridx(v:val, "[")+2:stridx(v:val, "]")-1])')
		let diagram = ['@startmindmap']
		let diagram +=	['left side', '* **__AM__ | __PM__**'] + diagramAM
		let diagram += ['right side'] + diagramPM
		let diagram += ['legend right'] + diagramLegend + ['endlegend']
		let diagram += ['@endmindmap']
		call writefile(diagram, inputfile)
	endif
	let outputdir = a:0 ? expand(a:1) : fnamemodify(inputfile, ':h')
	call CompileDiagramAndShowImage(inputfile, a:outputExtension, outputdir)
endfunction

function! CompileDiagramAndShowImage(inputFile, outputExtension, outputDir)
	let cmd = GetPlantumlCmdLine(a:inputFile, a:outputExtension, a:outputDir)
	let outputfile = a:outputDir.'\'.fnamemodify(a:inputFile, ':t:r').'.'.a:outputExtension
	if g:isWindows
		let cmd = 'cmd /C '.cmd
	endif
	let scratchbufnr = ResetScratchBuffer('JobPlantuml')
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
			\'exit_cb':  function('JobExitDiagramCompilationJob', [outputfile, scratchbufnr, a:inputFile])
		\}
	\)
endfunction

function! GetPlantumlCmdLine(inputFile, outputExtension, outputDir)
	let configfile = GetPlantumlConfigFile(a:inputFile)
	if empty(configfile)
		return printf('plantuml -t%s -charset UTF-8 -o "%s" "%s"', a:outputExtension, a:outputDir, a:inputFile)
	else
		return printf('plantuml -t%s -charset UTF-8 -config "%s" -o "%s" "%s"', a:outputExtension, configfile, a:outputDir, a:inputFile)
	endif
endfunction

function! RenderMarkdownFile()
	let inputfile =expand('%:p')
	if empty(inputfile)
		let inputfile = $tmp.'/markdown.md'
		exec 'write!' inputfile
	endif
	if (FileContainsPlantumlSnippets())
		let inputfile = CreateFileWithRenderedSvgs()
	endif
	let inputfile = substitute(inputfile, '/', '\\', 'g')
	exec 'Firefox' inputfile
endfunc
command! RenderMarkdownFile call RenderMarkdownFile()

augroup markdown
	au!
	autocmd FileType markdown nnoremap <buffer> <leader>w :RenderMarkdownFile<CR>
	autocmd FileType markdown nnoremap <buffer> z! :BLines ^##<CR>
	autocmd FileType markdown nnoremap <buffer> Z! :BLines [<CR>
	autocmd FileType markdown nnoremap <buffer> zj /^#<CR>
	autocmd FileType markdown nnoremap <buffer> zk ?^#<CR>
	autocmd FileType markdown setlocal omnifunc=
augroup END


function! FileContainsPlantumlSnippets()
	let file = join(getline(1,'$'))
	return stridx(file, '```puml_') != -1
endfunc

function! GetPlantumlConfigFile(filepath)
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
		\puml_dot:           'graphviz',
		\puml_json:          'styles'
	\}
	let fileext = fnamemodify(a:filepath, ':e')
	if empty(configfilebyft[fileext])
		return ''
	endif
	return $desktop.'/config/my_plantuml_'.configfilebyft[fileext].'.config'
endfunction

function! CreateFileWithRenderedSvgs()
	let inputfile = expand('%:p')
	let inputfolder = fnamemodify(inputfile, ':h')
	let newinputfile = fnamemodify(inputfile, ':h').'/'.fnamemodify(inputfile, ':t:r').'.withsvgs.'.fnamemodify(inputfile, ':t:e')
	let lines = getline(1, '$')
	let start = '^\s*```puml'
	let stop = '^\s*```'
	let delimiter = start
	let lastStart = 0
	let lastStop = -2
	let textSplits = []
	for i in range(len(lines))
		let line = lines[i]
		if line =~ delimiter
			if delimiter == start
				let textSplits += lines[lastStop+2:i-1]
				let lastStart = i
			else
				let diagram =lines[lastStart+1:i-1]
				let diagramtype = split(lines[lastStart], '_')[-1]
				call StartPlantumlToSvg(diagram, diagramtype, textSplits, len(textSplits))
				call add(textSplits, 'generated diagram')
				let lastStop = i
			endif
			let delimiter = (delimiter == start) ? stop : start
		endif
	endfor
	let textSplits += lines[lastStop+2:]
	while !empty(filter(copy(textSplits), {_,x -> x == 'generated diagram'}))
		sleep 50m
	endwhile
	call writefile(textSplits, newinputfile)
	return newinputfile
endfunc

function! StartPlantumlToSvg(diagram, diagramtype, array, pos)
	let pumlDelimiter = GetPlantumlDelimiter(a:diagramtype)
	let diagram = a:diagram
	if diagram[0] !~ '\s*@'
		let diagram = flatten(['@start'.pumlDelimiter, diagram, '@end'.pumlDelimiter])
	endif
	let plantumlbufnr = bufadd(a:pos.'.puml_'.a:diagramtype)
	call bufload(plantumlbufnr)
	call setbufline(plantumlbufnr, 1, diagram)
	let scratchbufnr = ResetScratchBuffer(bufname(plantumlbufnr).'.svg')
	let pumlconfig = GetPlantumlConfigFile('foo.puml_'.a:diagramtype)
	if empty(pumlconfig)
		let cmd = 'plantuml -tsvg -charset UTF-8 -pipe'
	else
		let cmd = 'plantuml -tsvg -charset UTF-8 -pipe -config "'.pumlconfig.'"'
	endif
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
			\'in_io': 'buffer',
			\'in_buf': plantumlbufnr,
			\'exit_cb':  function('StartPlantumlToSvgCB', [a:array, a:pos, scratchbufnr])
		\}
	\)
endfunction

function! StartPlantumlToSvgCB(array, pos, scratchbufnr, job, status)
	call setbufvar(a:scratchbufnr, '&buftype', 'nofile')
	let new = join(getbufline(a:scratchbufnr, 1, '$'), '\n')
	let new = substitute(new, ' style="', ' style="padding:8px;', '')
	let new = substitute(new, '\/svg>.*$', '/svg>', '')
	let new = substitute(new, '', '', 'g')
	if stridx(new, '--></g></svg>') == -1
		let new .= '--></g></svg>'
	endif
	let a:array[a:pos] = new
endfunction

function! GetPlantumlDelimiter(plantuml_type)
	if a:plantuml_type == 'mindmap'
		return 'mindmap'
	elseif a:plantuml_type == 'json' 
		return 'json'
	elseif a:plantuml_type == 'workbreakdown' 
		return 'wbs'
	else
		return 'uml'
	endif
endfunc

command! -nargs=* -bar CompileDiagramAndShowImage call CompileDiagramAndShowImageCommand(<f-args>)

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
	autocmd BufRead,BufNewFile *.puml_json            set ft=plantuml_json
	autocmd BufRead,BufNewFile *.puml_*               silent nnoremap <buffer> <Leader>w :silent w<CR>
	autocmd BufWritePost       *.puml_*               if line('$') > 1 | CompileDiagramAndShowImage svg | endif
	autocmd FileType           dirvish                nnoremap <silent> <buffer> D :call CreateDiagramFile()<CR>
augroup END

" Debugging"---------------------------{{{
 let g:vimspector_enable_mappings = 'HUMAN'
	sign define vimspectorBP text=o             texthl=WarningMsg
	sign define vimspectorBPCond text=o?        texthl=WarningMsg
	sign define vimspectorBPDisabled text=o!    texthl=LineNr
	sign define vimspectorPC text=\ >           texthl=MatchParen
	sign define vimspectorPCBP text=o>          texthl=MatchParen
	sign define vimspectorCurrentThread text=>  texthl=MatchParen
	sign define vimspectorCurrentFrame text=>   texthl=Special


function! ToggleConditionalBreakpoint()
	let condition = input('condition:')
	if condition == ''
		call vimspector#ToggleBreakpoint()
	else
		call vimspector#ToggleBreakpoint({'condition': condition})
	endif
	redraw
endfunction

 function! IsDebuggingTab()
 	return tabpagenr() == get(get(g:, 'vimspector_session_windows', {}), 'tabpage', 0)
 endfunction
 
 function! IsDebuggingHappening()
 	return get(get(g:, 'vimspector_session_windows', {}), 'tabpage', 99) <= tabpagenr('$')
 endfunction

	function! BreakpointIsPresentOnCurrentLine()
		return empty(sign_getplaced(bufnr(), #{group:'VimspectorBP', lnum: line(".")})[0].signs)
	endfunction
 func! CustomiseUI()
 call win_gotoid(g:vimspector_session_windows.stack_trace)
	nmap <silent> <buffer> <Space> <CR>
	nnoremap <silent> <buffer> zt zt
 wincmd H
	nunmenu WinBar
 call win_gotoid( g:vimspector_session_windows.code )
 wincmd H
 call win_gotoid(g:vimspector_session_windows.variables)
	nmap <silent> <buffer> <Space> <CR>
	nnoremap <silent> <buffer> zt zt
 let b = bufnr('%')
 quit
 call win_gotoid(g:vimspector_session_windows.watches)
 nunmenu WinBar
	nmap <silent> <buffer> <Space> <CR>
	nnoremap <silent> <buffer> zt zt
	nnoremap <silent> <buffer> dd :call vimspector#DeleteWatch()<CR>
 wincmd J
 exec 'vertical sbuffer' b
	call win_gotoid( g:vimspector_session_windows.code )
	nunmenu WinBar
	call win_gotoid(g:vimspector_session_windows.output)
	nnoremap <silent> <buffer> zt zt
	resize 12
	set winfixheight
	wincmd J
	wincmd =
	call win_gotoid( g:vimspector_session_windows.code )
	resize +4
	normal! zz
endfunction

augroup MyVimspectorUICustomistaion
	autocmd!
	autocmd User VimspectorUICreated call CustomiseUI()
	autocmd User VimspectorJumpedToFrame call SetDebugMappings()
	autocmd User VimspectorDebugEnded call RemoveDebugMappings()
augroup END

function! SetDebugMappings() abort
		nmap <silent> <buffer> <localleader>b <Plug>VimspectorToggleBreakpoint
		nnoremap <silent> <buffer> <localleader>B :call ToggleConditionalBreakpoint()<CR>
		nnoremap <silent> <buffer> <LocalLeader>L :call vimspector#ListBreakpoints()<CR>
		nnoremap <silent> <buffer> <LocalLeader>C :call vimspector#ClearBreakpoints()<CR>
		nmap <silent> <buffer> <localleader>g <Plug>VimspectorRunToCursor

		nmap <silent> <buffer> <space> <Plug>VimspectorStepOver
		nmap <silent> <buffer> <localleader>j <Plug>VimspectorStepInto
		nmap <silent> <buffer> <localleader>k <Plug>VimspectorStepOut
		nmap <silent> <buffer> <localleader>l <Plug>VimspectorContinue
		nmap <silent> <buffer> <localleader>h <Plug>VimspectorRestart
		nmap <silent> <buffer> <localleader>H <Plug>VimspectorStop
		nmap <silent> <buffer> <C-J> <Plug>VimspectorDownFrame
		nmap <silent> <buffer> <C-K> <Plug>VimspectorUpFrame

	nnoremap <silent> <buffer> <Leader>x :call vimspector#Reset()<CR>
endfunction

function! RemoveDebugMappings() abort
 	silent! nunmap <buffer> <localleader>b
 	silent! nunmap <buffer> <localleader>B
 	silent! nunmap <buffer> <localleader>L
 	silent! nunmap <buffer> <localleader>C
 	silent! nunmap <buffer> <localleader>g

 	silent! nunmap <buffer> <space>
 	silent! nunmap <buffer> <localleader>j
 	silent! nunmap <buffer> <localleader>k
 	silent! nunmap <buffer> <localleader>l
 	silent! nunmap <buffer> <localleader>h
 	silent! nunmap <buffer> <localleader>H
		silent! nunmap <buffer> <C-J>
		silent! nunmap <buffer> <C-K>

 	silent! nunmap <buffer> <Leader>x
		silent! nunmap <buffer> <Space>
endfunction

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
let g:OmniSharp_open_quickfix = 1
augroup lightline_integration
  autocmd!
  autocmd User OmniSharpStarted,OmniSharpReady,OmniSharpStopped call lightline#update()
augroup END

function! GetCsproj()
	return GetNearestPathInCurrentFileParents('*.csproj')
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

function! OpenCodeOnAzureDevops() range
	let s:job= job_start(printf('firefox.exe "%s"', GetCodeUrlOnAzureDevops()))
endfunction

function! GetCodeUrlOnAzureDevops() range
	let filepath = expand('%:p')
	let gitrootfolder = fnamemodify(gitbranch#dir(filepath), ':h:p')
	let gitpath = filepath[len(gitrootfolder)+(has('win32')?1:0):]
	let gitpath = '/' . substitute(gitpath, '\\', '/', 'g')
	let gitbranch = gitbranch#name()
	let gitproject = fnamemodify(gitrootfolder, ':t')
	let url = $ados.'/_git/'.gitproject.'?path='.substitute(gitpath, '/', '%2F', 'g').'&version=GB'.substitute(gitbranch, '/', '%2F', 'g')
	if !empty(GetCurrentSelection())
		let url .= '&line='.line("'<")
		let adostabstop=3
		let url .= '&lineStartColumn='.(max([getpos("'<")[2], 1]) + (getpos("'<")[2] == 1 ? 0 : adostabstop*(min([getpos("'<")[2],indent(line("'<"))]))))
		let url .= '&lineEnd='.line("'>")
		let url .= '&lineEndColumn='.(min([getpos("'>")[2], len(getline("'>'"))]) + 1 + adostabstop*indent(line("'>")))
	else
		let url .= '&line='.line('.')
	endif
	return url
endfunction
command! -range AdosCode call OpenCodeOnAzureDevops()
command! -bar -range CopyAdosUrl let @+=GetCodeUrlOnAzureDevops()

function! MyOmniSharpNavigate(location, ...)
	if OmniSharp#locations#Navigate(a:location)
		Reframe
	endif
endfunction
command! MyOmniSharpNavigateUp   call OmniSharp#actions#navigate#Up  (function('MyOmniSharpNavigate'))
command! MyOmniSharpNavigateDown call OmniSharp#actions#navigate#Down(function('MyOmniSharpNavigate'))

augroup csharpfiles
	au!
	autocmd BufWrite *.cs,*.proto %s/^\(\s*\w\+\)\{0,6}\s\+class\s\+\zs\w\+\ze/\=uniq(sort(add(g:csClassesInChangedFiles, submatch(0))))/gne
	autocmd FileType cs nnoremap <buffer> <silent> <Leader>w :CopyAdosUrl<CR>:echomsg 'Code URL copied!'<CR>
	autocmd FileType cs vnoremap <buffer> <silent> <Leader>w :CopyAdosUrl<CR>:echomsg 'Code URL copied!'<CR>
	autocmd FileType cs nnoremap <buffer> <silent> <Leader>W :AdosCode<CR>
	autocmd FileType cs vnoremap <buffer> <silent> <Leader>W :AdosCode<CR>
	autocmd FileType cs nnoremap <buffer> <silent> <LocalLeader>m :BuildTestCommit <C-R>=b:OmniSharp_host.sln_or_dir<CR><CR>
	autocmd FileType cs nnoremap <buffer> <silent> <LocalLeader>M :BuildTestCommitAll!<CR>
	autocmd FileType cs nnoremap <buffer> <C-P> :MyOmniSharpNavigateUp<CR>
	autocmd FileType cs nnoremap <buffer> <C-N> :MyOmniSharpNavigateDown<CR>
	autocmd FileType cs nnoremap <buffer> <C-H> gg:MyOmniSharpNavigateDown<CR>
	autocmd FileType cs nnoremap <buffer> <C-L> G:MyOmniSharpNavigateUp<CR>
	autocmd FileType cs nmap <buffer> z! :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_find_members)
	autocmd FileType cs nmap <buffer> gd <Plug>(omnisharp_go_to_definition)
	autocmd FileType cs nmap <buffer> gD <Plug>(omnisharp_preview_definition)
	autocmd FileType cs nmap <buffer> <LocalLeader>i :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_find_implementations)
	autocmd FileType cs nmap <buffer> <LocalLeader>I :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_preview_implementations)
	autocmd FileType cs nmap <buffer> <LocalLeader>s :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_find_type)
	autocmd FileType cs nmap <buffer> <LocalLeader>S :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_find_symbol)
	autocmd FileType cs nmap <buffer> <LocalLeader>u :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_find_usages)
	autocmd FileType cs nmap <buffer> <LocalLeader>d <Plug>(omnisharp_type_lookup)
	autocmd FileType cs nmap <buffer> <LocalLeader>D <Plug>(omnisharp_documentation)
	autocmd FileType cs nmap <buffer> <LocalLeader>c <Plug>(omnisharp_global_code_check)
	autocmd FileType cs nmap <buffer> <LocalLeader>q :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_code_actions)
	autocmd FileType cs xmap <buffer> <LocalLeader>q :<C-U>let g:lcd_qf = getcwd()<CR>gv<Plug>(omnisharp_code_actions)
	autocmd FileType cs nmap <buffer> <LocalLeader>r <Plug>(omnisharp_rename)
	autocmd FileType cs nmap <buffer> <LocalLeader>= <Plug>(omnisharp_code_format)
	autocmd FileType cs nmap <buffer> <LocalLeader>f <Plug>(omnisharp_fix_usings)
	autocmd FileType cs nmap <buffer> <LocalLeader>R <Plug>(omnisharp_restart_server)
	autocmd FileType cs nnoremap <buffer> <LocalLeader>O :OmniSharpStartServer <C-R>=expand('%:h')<CR>
	autocmd FileType cs nmap <silent> <buffer> <LocalLeader>Q :if !IsDebuggingHappening() \| if BreakpointIsPresentOnCurrentLine() \| call vimspector#ToggleBreakpoint() \| endif \| call vimspector#Launch() \| else \| exec 'normal!' g:vimspector_session_windows.tabpage.'gt' \| endif<CR>
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


function! GetScriptCommandName(name)
	return a:name =~ 'Start$' ? a:name[:-6] : a:name
endfunction

function! RunScript(name, bang, ...)
	if empty(a:bang)
		if a:name =~ 'Start$'
			let excmd = printf('terminal ++hidden %s.bat %s', a:name, join(a:000, ' '))
		else
			let excmd = printf('terminal ++hidden ++open %s.bat %s', a:name, join(a:000, ' '))
		endif
	else
		let excmd = printf('terminal ++curwin ++noclose %s.bat %s', a:name, join(a:000, ' '))
	endif
	let &termwinsize=(&lines-2).'*'.(&columns-5)
	exec excmd
endfunction

for file in expand('$scripts/*.bat', 1, 1)
	let filename = fnamemodify(file, ':t:r')
	let filename = toupper(filename[0]).filename[1:]
	exec 'command! -nargs=* -bang -bar' GetScriptCommandName(filename) 'call RunScript('''.filename.''', "<bang>", <f-args>)'
endfor

function! SynchronizeDuplicatedConfigFile()
	let filename = expand('%:t')
	let duplicated = glob('%:p:h/bin/**/'.filename)
	if duplicated != ''
		call SynchronizeWith(duplicated)
		return
	endif
	let original = GetNearestParentFolderContainingFile('*.csproj').'/'.filename
	if glob(original) != ''
		call SynchronizeWith(original)
		return
	endif
endfunction

function! SynchronizeWith(path)
	exec 'autocmd BufWritePost <buffer>' 'write!' substitute(a:path, '\\', '/', 'g')
endfunction

augroup runprojects
	au!
	autocmd FileType json,xml call SynchronizeDuplicatedConfigFile()
augroup end

function! Qf2Loclist()
	call setloclist(0, [], ' ', {'items': get(getqflist({'items': 1}), 'items')})
	cclose
	lwindow
endfunction
command! Qf2Loclist call Qf2Loclist()

function! LocListTerminalBuffers(bang)
	if empty(a:bang)
		let prefix = '!cmd '
		let prefixlen = len(prefix.'/k ')
		let terminalbuffers= map(filter(getbufinfo({'buflisted':1}), {_,x->getbufvar(x.bufnr, '&bt') == 'terminal'}), {_,x -> {'bufnr': x.bufnr, 'valid': 1, 'text': term_getstatus(x.bufnr)}})
		call setloclist(0, [], ' ', {'nr': '$', 'items': terminalbuffers, 'title': '[Location List] Terminal Buffers'})
		lwindow
		if(&ft == 'qf')
			call matchadd('Conceal', '!\?cmd /k ')
			set conceallevel=3 concealcursor=nvic
		endif
	else
		let terminalbuffers= map(filter(getbufinfo({'buflisted':1}), {_,x->getbufvar(x.bufnr, '&bt') == 'terminal' && stridx(term_getstatus(x.bufnr), 'running') != -1 }), {_,x -> x.bufnr})
		let bufnb = len(terminalbuffers)
		if bufnb == 0
			return
		endif
		if bufnb > 4
			call LocListTerminalBuffers('')
			return
		endif
		if bufnb == 4
			exec 'tabnew | b'.terminalbuffers[0]
			exec 'sbuffer'.terminalbuffers[2] '| vertical sbuffer'.terminalbuffers[3]
			wincmd k | exec 'vertical sbuffer'.terminalbuffers[1]
		elseif bufnb == 3
			normal! mW
			tabnew
			normal! `W
			exec 'sbuffer'.terminalbuffers[1] '| vertical sbuffer'.terminalbuffers[2]
			wincmd k | exec 'vertical sbuffer'.terminalbuffers[0]
		elseif bufnb == 2
			exec 'tabnew | b'.terminalbuffers[0]
			exec 'vertical sbuffer'.terminalbuffers[1]
		elseif bufnb == 1
			exec 'tabnew | b'.terminalbuffers[0]
		endif
	endif
endfunction
command! -bang LocListTerminalBuffers call LocListTerminalBuffers("<bang>")
nnoremap <silent> <Leader>et :LocListTerminalBuffers<CR>
nnoremap <silent> <Leader>eT :LocListTerminalBuffers!<CR>

function! BuildReverseDependencyTree(...)
	let sln = a:0 ? a:1 : GetNearestPathInCurrentFileParents('*.sln')
	let g:csenvs = get(g:, 'csenvs', {})
	let cache = get(get(g:csenvs, sln, {}), 'projects', {})
	if !empty(cache)
		let g:csenvs[sln].current_build_success = 1
		return cache
	endif
	echomsg '🛠' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) 'Building reverse dependency tree ('.fnamemodify(sln, ':t').')'
	let slndir = fnamemodify(sln, ':h:p')
	let slnprojs = map(filter(readfile(sln), {_,x -> x =~ '"[^"]\+\.\a\{1,3}proj"'}), function("ParseCsprojFromSln", [slndir]))
	let parsedSln = { 'path': sln}
	let rgGlobs = join(mapnew(slnprojs, '"-g ".fnamemodify(v:val, ":t")'), ' ')
	let rgCmd = printf('rg "<ProjectReference Include=(.*)>" %s -r "$1"', rgGlobs)
	let data = systemlist(rgCmd)
	let csprojs = map(data, function("ParseReferenceFromCsproj"))
	let g:csenvs[sln] = {
		\'projects': {},
		\'current_build_success': 1,
	\}
	let reverseDependencyTree = g:csenvs[sln].projects
	let jobs =[]
	echomsg '🛠' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) 'Reading latest modification timestamps from' len(slnprojs) 'projects...'
	for i in range(len(slnprojs))
		let project = slnprojs[i]
		let reverseDependencyTree[project] = {
			\'last_build_timestamp': 0,
			\'consumers': [],
			\'is_leaf_project': 0
		\}
		let csprojFolder = fnamemodify(project, ':h')
		if isdirectory(csprojFolder.'/obj')
			let cmd = printf('stat -c "%%Y" "%s/obj"', csprojFolder)
			call add(jobs, job_start(
				\cmd,
				\{
					\'out_cb': function('GetProjectLastBuiltTimestampCB', [reverseDependencyTree[project]]),
					\'err_cb':   { chan,msg  -> execute('echohl Constant | echomsg '''.substitute(msg,"'","''","g").''' | echohl Normal',  1) }
				\}
			\))
		endif
	endfor
	for i in range(len(csprojs))
		let reference = csprojs[i].reference
		call add(reverseDependencyTree[reference].consumers,csprojs[i].project)
	endfor
	let projectsWithReferences = uniq(sort(map(csprojs, {_,x -> x.project})))
	let leafProjects = filter(copy(slnprojs), {_,x -> index(projectsWithReferences, x) == -1})
	for i in range(len(leafProjects))
		let reverseDependencyTree[leafProjects[i]].is_leaf_project = 1
	endfor
	redraw
	echomsg '🛠' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) 'Reverse dependency tree completed.'
	return copy(reverseDependencyTree)
endfunction

function! GetProjectLastBuiltTimestampCB(reverseDependencyTreeItem, chan, msg)
	let a:reverseDependencyTreeItem.last_build_timestamp = str2nr(a:msg) + 1
endfunction

function! ParseCsprojFromSln(slndir, index, item)
	let x = a:item
	let csprojRelativePathStart = match(x, '"[^"]\+\.\a\{1,3}proj"')+1
	let csprojRelativePathStop = stridx(x, 'proj"', csprojRelativePathStart) + len('proj') - 1
	let csprojRelativePath = x[csprojRelativePathStart:csprojRelativePathStop]
	let csprojFullPath = fnamemodify(a:slndir.'/'.csprojRelativePath, ':p')
	return substitute(csprojFullPath, '\\', '/', 'g')
endfunction

function! ParseReferenceFromCsproj(index, item)
	let x = a:item
	let res = { 'project': '', 'reference': '' }
	let csprojFile = fnamemodify(x[:stridx(x, ':')-1], ':p')
	let csprojFolder = fnamemodify(csprojFile, ':h')
	let referenceRelativePath = trim(x[stridx(x, ':')+1:])[1:]
	let referenceRelativePath = referenceRelativePath[:stridx(referenceRelativePath, '"')-1]
	let referenceFullPath = simplify(fnamemodify(csprojFolder.'/'.referenceRelativePath, ':p'))
	let res.project = substitute(csprojFile, '\\', '/', 'g')
	let res.reference = substitute(referenceFullPath, '\\', '/', 'g')
	return res
endfunction

let g:csClassesInChangedFiles=[]

function! VsTestCB(testedAssembly, csprojsWithNbOccurrences, scratchbufnr, sln, buildAndTestJobs, ...)
	call filter(a:buildAndTestJobs, 'v:val =~ "run"')
	let g:nbTestedCsprojs += 1
	let report = getbufline(a:scratchbufnr, '$')[0]
	let reportStats = stridx(report, ' - ') < 0 ? report : substitute(split(report, ' - ')[1], ':\s\+', ': ', 'g')
	if a:0 && a:2
		redraw | echomsg '🚫🚫' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) printf('%d/{%d+%d}', g:nbBuiltCsprojs+g:nbTestedCsprojs, g:nbCsprojsToBuild, g:nbCsprojsToTest) fnamemodify(a:testedAssembly, ':t:r') '-->' reportStats
		let g:csenvs[a:sln].current_build_success = 0
		set errorformat+=%Z\[xUnit%.%#
			"set errorformat+=%C\ %#NSubstitute\.Exceptions%.%#\ :\ %m
			"set errorformat+=%C%\\%%(Actually%\\\)%\\@=%m
		set errorformat+=%C\%.%#\ at\ %.%#\ in\ %f:line\ %l
			"set errorformat+=%C\	%m
			"set errorformat+=%-C\ %#Stack\ Trace:
			"set errorformat+=%-C\ %#at\ %.%#
			"set errorformat+=%-C---\ %.%#
			"set errorformat+=%-C%.%#[FAIL]
		set errorformat+=%-C%.%#\ Error\ Message%.%#
		set errorformat+=%-C\ %#at%.%#
		set errorformat+=%C\ \ \ %m
			"set errorformat+=%-C%.%#\ (pos\ %.%#
			"set errorformat+=%-G%*\\d-%*\\d-%*\\d\ %.%#
		set errorformat+=%C\ %#%m\ Failure
		set errorformat+=%+C%.%#
		set errorformat+=%-G%.%#
		silent exec 'cgetbuffer' a:scratchbufnr
		if &ft == 'qf'
			let w:quickfix_title = 'Build & Tests'
		endif
	else
		redraw | echomsg '✅✅' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) printf('%d/{%d+%d}', g:nbBuiltCsprojs+g:nbTestedCsprojs, g:nbCsprojsToBuild, g:nbCsprojsToTest) fnamemodify(a:testedAssembly, ':t:r') '-->' reportStats
		if empty(a:csprojsWithNbOccurrences) && empty(a:buildAndTestJobs)
			if !g:csenvs[a:sln].current_build_success
				redraw | echomsg '🚫 Build & Test failed.'
			else
				redraw | echomsg '✅ Build & Test successful!'
				let g:csClassesInChangedFiles = []
				let g:csenvs[a:sln].last_build_projects = get(g:csenvs[a:sln], 'last_build_projects', [])
				let g:csenvs[a:sln].projects_in_git_status = get(g:csenvs[a:sln], 'projects_in_git_status', [])
				call filter(g:csenvs[a:sln].last_build_projects, {_,x -> index(g:csenvs[a:sln].projects_in_git_status, x) != -1})
				unlet g:csenvs[a:sln].projects_in_git_status
				call OpenDashboard()
			endif
		endif
	endif
endfunction

function! FillConsumersParallel(csproj, reverseDependencyTree, output, jobs, timerid)
	call add(a:output, a:csproj)
	let consumers = a:reverseDependencyTree[a:csproj].consumers
	for i in range(len(consumers))
		call add(a:jobs, timer_start(1, function('FillConsumersParallel', [consumers[i], a:reverseDependencyTree, a:output, a:jobs])))
	endfor
	let jobindex = index(a:jobs, a:timerid)
	if jobindex != -1
		call remove(a:jobs, jobindex)
	endif
endfunction

function! FillConsumers(csproj, reverseDependencyTree)
	let consumers = a:reverseDependencyTree[a:csproj].consumers
	let res = [a:csproj]
	let jobs = []
	for i in range(len(consumers))
		call add(jobs, timer_start(1, function('FillConsumersParallel', [consumers[i], a:reverseDependencyTree, res, jobs])))
	endfor
	while !empty(jobs)
		sleep 50ms
	endwhile
	return res
endfunction

function! CascadeBuild(csproj, csprojsWithNbOccurrences, reverseDependencyTree, scratchbufnr, modifiedClasses, previouslyBuiltCsproj, sln, buildAndTestJobs)
	if a:csprojsWithNbOccurrences[a:csproj] > 1
		let consumers = FillConsumers(a:csproj, a:reverseDependencyTree)
		for i in range(len(copy(consumers)))
			let a:csprojsWithNbOccurrences[consumers[i]] -= 1
		endfor
		return
	else
		unlet a:csprojsWithNbOccurrences[a:csproj]
		let consumers = a:reverseDependencyTree[a:csproj].consumers
		let cmd = printf('MSBuild.exe -nologo -p:BuildProjectReferences=false -v:quiet "%s"', a:csproj)
		call add(a:buildAndTestJobs, job_start(
			\cmd,
			\{
				\'out_io': 'buffer',
				\'out_buf': a:scratchbufnr,
				\'out_modifiable': 0,
				\'err_io': 'buffer',
				\'err_buf': a:scratchbufnr,
				\'err_modifiable': 0,
				\'in_io': 'null',
				\'err_cb':   { chan,msg  -> execute('echohl Constant | echomsg '''.substitute(msg,"'","''","g").''' | echohl Normal',  1) },
				\'exit_cb': function("CascadeReferences", [a:reverseDependencyTree[a:csproj].consumers, a:csprojsWithNbOccurrences, a:reverseDependencyTree, a:scratchbufnr, a:modifiedClasses, a:csproj, a:sln, a:buildAndTestJobs])
			\}
		\))
	endif
endfunction

function! CascadeReferences(csprojs, csprojsWithNbOccurrences, reverseDependencyTree, scratchbufnr, modifiedClasses, previouslyBuiltCsproj, sln, buildAndTestJobs, ...)
	let g:nbBuiltCsprojs += 1
	if a:0 && a:2
		redraw | echomsg '🚫' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) fnamemodify(a:previouslyBuiltCsproj, ':t:r')
		let g:csenvs[a:sln].current_build_success = 0
		set errorformat=CSC\ :\ error\ %*\\a%n:\ %m\ [%f]
		set errorformat+=%f(%l\\,%c):\ error\ %*\\a%n:\ %m
		set errorformat+=%f\ :\ error\ %*\\a%n:\ %m\ [%.%#
		set errorformat+=%.%#error\ %*\\a%n:\ %m
		set errorformat+=%-G%.%#
		silent exec 'cgetbuffer' a:scratchbufnr
		if &ft == 'qf'
			let w:quickfix_title = 'Build & Tests'
			return
		endif
	endif
	if !empty(a:previouslyBuiltCsproj)
		redraw | echomsg '✅' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) printf('%d/{%d+%d}', g:nbBuiltCsprojs+g:nbTestedCsprojs, g:nbCsprojsToBuild, g:nbCsprojsToTest) fnamemodify(a:previouslyBuiltCsproj, ':t:r')
		let a:reverseDependencyTree[a:previouslyBuiltCsproj].last_build_timestamp = GetCurrentTimestamp()+10
	endif
	if a:previouslyBuiltCsproj =~# 'Test'
		let g:nbCsprojsToTest += 1
		call TestCsproj(a:previouslyBuiltCsproj, a:csprojsWithNbOccurrences, a:scratchbufnr, a:modifiedClasses, a:sln, a:buildAndTestJobs)
	endif
	for i in range(len(a:csprojs))
		let csproj = a:csprojs[i]
		call CascadeBuild(csproj, a:csprojsWithNbOccurrences, a:reverseDependencyTree, a:scratchbufnr, a:modifiedClasses, a:previouslyBuiltCsproj, a:sln, a:buildAndTestJobs)
	endfor
endfunction

function! TestCsproj(path, csprojsWithNbOccurrences, scratchbufnr, modifiedClasses, sln, buildAndTestJobs)
	let assemblyToTest = GetPathOfAssemblyToTest(a:path)
	if empty(assemblyToTest)
		echomsg fnamemodify(a:path, ':t').': Could not find dll inside /bin, /Debug folders'
		return
	endif
	if empty(a:modifiedClasses)
		let cmd = printf('vstest.console.exe /logger:console;verbosity=minimal %s', assemblyToTest)
		let testedClasses = '[all]'
	else
		let cmd = printf('vstest.console.exe /logger:console;verbosity=minimal /TestCaseFilter:"%s" %s', join(map(copy(a:modifiedClasses), {_,x -> 'FullyQualifiedName~'.fnamemodify(x, ':t:r')}), '|'), assemblyToTest)
		let testedClasses = join(map(copy(a:modifiedClasses), 'fnamemodify(v:val, ":t:r")'), ", ")
	endif
	echomsg '🗡' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) fnamemodify(assemblyToTest, ':t:r') '-->' testedClasses
	call add(a:buildAndTestJobs, job_start(
		\cmd,
		\{
			\'out_io': 'buffer',
			\'out_buf': a:scratchbufnr,
			\'out_modifiable': 0,
			\'err_io': 'buffer',
			\'err_buf': a:scratchbufnr,
			\'err_modifiable': 0,
			\'in_io': 'null',
			\'err_cb':   { chan,msg  -> execute("echomsg '".substitute(msg,"'","''","g")."'",  1) },
			\'exit_cb': function("VsTestCB", [assemblyToTest, a:csprojsWithNbOccurrences, a:scratchbufnr, a:sln, a:buildAndTestJobs])
		\}
	\))
endfunction

function! GetPathOfAssemblyToTest(csproj)
	let assemblyNames = map(filter(readfile(a:csproj), {_,x->stridx(x, '<AssemblyName>') != -1}), {_,x -> x[stridx(x,'>')+1:stridx(x,'<', stridx(x, '>'))-1]})
	let assemblyName = empty(assemblyNames) ? fnamemodify(a:csproj, 't:r') : assemblyNames[0]
	if empty(assemblyNames)
		let assemblyName = fnamemodify(a:csproj, ':t:r')
	else
		let assemblyName = assemblyNames[0]
	endif
	let paths = filter(glob(fnamemodify(a:csproj, ':h').'/**/'.assemblyName.'.dll', 0, 1), {_,x -> stridx(x, 'bin') != -1 && stridx(x,'Debug') != -1 && stridx(x, '\ref\') == -1})
	return empty(paths) ? '' : paths[0]
endfunction

function! BuildTestCommit(all, resetCache, ...)
	if !executable('MSBuild.exe') | echomsg 'MSBuild.exe was not found. Please add it to $PATH.' | return | endif
	if !executable('vstest.console.exe') | echomsg 'vstest.console.exe was not found. Please add it to $PATH.' | return | endif
	if &modified | silent write | endif
	let buildAndTestJobs=[]
	let g:btcStartTime = reltime()
	let sln = a:0 ? a:1 : GetNearestPathInCurrentFileParents('*.sln')
	if sln !~ 'sln$'
		let csproj = substitute(GetNearestPathInCurrentFileParents('*.csproj'), '\\', '/', 'g')
		call BuildTestCommitCsproj(csproj, g:csClassesInChangedFiles, buildAndTestJobs)
		return
	endif
	if a:resetCache && !empty(get(get(g:, 'csenvs', {}), sln, {}))
		unlet g:csenvs[sln]
	endif
	if a:all
		let slnFilename = fnamemodify(sln, ':t:r')
		if exists(':Rebuild'.slnFilename)
			echomsg 'Running :Rebuild'.slnFilename
			exec 'Rebuild'.slnFilename
		else
			echomsg printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) 'Cleaning' fnamemodify(sln, ':t').'...'
			call add(buildAndTestJobs, job_start(printf('MSBuild.exe -nologo -t:Clean -v:quiet "%s"', sln), {'exit_cb': function('PostCleanCB', [sln, buildAndTestJobs])}))
		endif
	else
		let csprojsWithChanges = GetCsprojsWithChanges(sln)
		redraw
		if empty(csprojsWithChanges)
			echomsg '🔍' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) 'No changes - no build.'
			return
		endif
		call BuildTestCommitSln(sln, csprojsWithChanges, g:csClassesInChangedFiles, buildAndTestJobs)
	endif
endfunc
command! -bang -nargs=? BuildTestCommit    call BuildTestCommit(0, !empty("<bang>"), <f-args>)
command! -bang -nargs=? BuildTestCommitAll call BuildTestCommit(1, !empty("<bang>"), <f-args>)

function! PostCleanCB(sln, buildAndTestJobs, ...)
	redraw
	echomsg printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) 'Building' fnamemodify(a:sln, ':t').'...'
	call add(a:buildAndTestJobs, job_start(printf('MSBuild.exe -nologo -t:Build -v:quiet "%s"', a:sln), {'exit_cb': function('PostBuildCB', [a:sln, a:buildAndTestJobs])}))
	silent call BuildReverseDependencyTree(a:sln)
endfunction

function! PostBuildCB(sln, buildAndTestJobs, job, status)
	if a:status
		echomsg '🚫' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) fnamemodify(a:sln, ':t') 'build failed.'
	else
		echomsg '✅' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) fnamemodify(a:sln, ':t') 'build succeeded.'
	end
endfunction

function! GetCsprojsWithChanges(sln)
	if empty(get(get(g:, 'csenvs', {}), a:sln, {}))
		call BuildReverseDependencyTree(a:sln)
	endif
	echomsg '🔍' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) 'Looking for changes...'
	if empty(get(get(get(g:, 'csenvs', {}), a:sln, {}), 'last_build_projects', {}))
		let projectsThatMightHaveChanges = keys(g:csenvs[a:sln].projects)
		let last_build_projects = []
	else
		let last_build_projects = g:csenvs[a:sln].last_build_projects
		let cwd = getcwd()
		let git_diff_files = map(systemlist('git status --short'), {_,x -> substitute(cwd.'/'.x[3:], '\\', '/', 'g')})
		let g:csenvs[a:sln].projects_in_git_status = git_diff_files 
		let git_diff_projects = FindProjectsFromFiles(git_diff_files, keys(g:csenvs[a:sln].projects))
		let projectsThatMightHaveChanges = uniq(sort(extend(last_build_projects, git_diff_projects, )))
	endif
	let csprojsWithChanges = []
	let jobs = []
	echomsg '🔍' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) 'Reading latest modification timestamps from' len(projectsThatMightHaveChanges) 'projects...'
	for project in projectsThatMightHaveChanges
		let csprojFolder = substitute(fnamemodify(project, ':h'), '\', '/', 'g')
		let cmd = printf('"%s/find" "%s" -path "%s/obj" -prune -false -o -path "%s/bin" -prune -false -o -type f -newermt @%d -print0 -quit', $gtools, csprojFolder, csprojFolder, csprojFolder, g:csenvs[a:sln].projects[project].last_build_timestamp)
		call add(jobs, job_start(cmd,{'out_cb': function('GetProjectChangedCB', [csprojsWithChanges, project])}))
	endfor
	while !empty(filter(copy(jobs), 'v:val =~ "run"'))
		sleep 50m
	endwhile
	if len(last_build_projects) == len(keys(g:csenvs[a:sln].projects))
		let g:csenvs[a:sln].last_build_projects = []
	elseif !empty(csprojsWithChanges)
		let g:csenvs[a:sln].last_build_projects = csprojsWithChanges
	endif
	return csprojsWithChanges
endfunction

function! FindProjectsFromFiles(files, projects)
	let csprojs = mapnew(a:files, {_,x -> substitute(GetNearestPathInParentFolders('*.csproj', x), '\\', '/', 'g')})
	let csprojsmin = uniq(sort(csprojs))
	let csprojsInsideSolution = filter(csprojsmin, {_,x -> index(a:projects, x) > -1})
	return csprojsInsideSolution
endfunction

function! GetProjectChangedCB(csprojsWithChanges, csproj, ...)
	call add(a:csprojsWithChanges, a:csproj)
endfunction

function! BuildTestCommitSln(sln, modifiedCsprojs, modifiedClasses, buildAndTestJobs)
	let reverseDependencyTree = BuildReverseDependencyTree(a:sln)
	let csprojsToBuild = map(copy(a:modifiedCsprojs), {_,x -> FillConsumers(x, reverseDependencyTree)})
	call BuildTestCommitCsharp(a:modifiedCsprojs, csprojsToBuild, reverseDependencyTree, a:modifiedClasses, a:sln, a:buildAndTestJobs)
endfunction

function! BuildTestCommitCsproj(csproj, modifiedClasses, buildAndTestJobs)
	let reverseDependencyTree = {}
	let reverseDependencyTree[a:csproj] = {
		\'last_build_timestamp': 0,
		\'consumers': [],
		\'is_leaf_project': 0
	\}
	let g:csenvs = get(g:, 'csenvs', {})
	let g:csenvs[a:csproj] = {
		\'projects': reverseDependencyTree
	\}
	call BuildTestCommitCsharp([a:csproj], [a:csproj], reverseDependencyTree, a:modifiedClasses, a:csproj, a:buildAndTestJobs)
endfunction

function! BuildTestCommitCsharp(modifiedCsprojs, allCsprojsToBuild, reverseDependencyTree, modifiedClasses, sln, buildAndTestJobs)
	let csprojsToBuildFlat = flatten(copy(a:allCsprojsToBuild))
	let csprojsToBuildMin = uniq(sort(flatten(copy(a:allCsprojsToBuild))))
	redraw
	echomsg '🔨' printf('[%.2fs]',reltimefloat(reltime(g:btcStartTime))) len(a:modifiedCsprojs) 'modified projects > Building a total of' len(csprojsToBuildMin) 'projects...'
	let g:nbBuiltCsprojs = 0
	let g:nbCsprojsToBuild = len(csprojsToBuildMin)
	let g:nbCsprojsToTest = 0
	let g:nbTestedCsprojs = 0
	let csprojsWithNbOccurrences = {}
	for i in range(len(csprojsToBuildMin))
		let csproj = csprojsToBuildMin[i]
		let csprojsWithNbOccurrences[csproj] = len(filter(copy(csprojsToBuildFlat), {_,x -> x == csproj}))
	endfor
	redraw
	silent echomsg	join(map(copy(a:modifiedCsprojs), 'fnamemodify(v:val, ":t:r")'), ", ")
	let scratchbufnr = ResetScratchBuffer($desktop.'/tmp/JobBuildTestCommit')
	for i in range(len(copy(a:modifiedCsprojs)))
		let csproj = a:modifiedCsprojs[i]
		call CascadeBuild(csproj, csprojsWithNbOccurrences, a:reverseDependencyTree, scratchbufnr, a:modifiedClasses, '', a:sln, a:buildAndTestJobs)
	endfor
endfunction

if !empty(glob($config.'/my_vimworkenv.vim'))
	source $config/my_vimworkenv.vim
endif

function! GetCurrentTimestamp()
	return str2nr(system(printf('"%s/date" +%%s', $gtools)))
endfunction

function! GetAdosProjectNameAndIdMapping()
	let g:adosProjects = get(g:, 'adosProjects', BuildAdosProjectNameAndIdMapping())
	if empty(g:adosProjects)
		let g:adosProjects = BuildAdosProjectNameAndIdMapping()
	endif
	return g:adosProjects
endfunction

function! BuildAdosProjectNameAndIdMapping()
	let cmd = printf('curl -s --location -u:%s "%s/_apis/projects?api-version=5.0"', $pat, $ados)
	let cmd .= ' | jq "[.value[]|{id: .id, name: .name}]"'
	let v = system(cmd)
	let v = substitute(v, '[\x0]', '', 'g')
	return json_decode(v)
endfunction

function! GetAdosRepositoriesNameAndIdMapping()
	let g:adosRepositories = get(g:, 'adosRepositories', BuildAdosRepositoriesNameAndIdMapping())
	if empty(g:adosRepositories)
		let g:adosRepositories = BuildAdosRepositoriesNameAndIdMapping()
	endif
	return g:adosRepositories
endfunction

function! BuildAdosRepositoriesNameAndIdMapping()
	let cmd = printf('curl -s --location -u:%s "%s/CapsuleTech/_apis/git/repositories?api-version=5.0"', $pat, $ados)
	let cmd .= ' | jq "[.value[]|{id: .id, name: .name}]"'
	let v = system(cmd)
	let v = substitute(v, '[\x0]', '', 'g')
	return json_decode(v)
endfunction

function! ParseVsTfsUrl(url)
	let parsed = {}
	let ids = split(a:url, '/')[-1]
	let ids = split(ids, '%2f')
	let parsed.project = map(filter(copy(GetAdosProjectNameAndIdMapping()), {_,x -> x.id == ids[0]}), {_,x -> x.name})[0]
	let parsed.repository = map(filter(copy(GetAdosRepositoriesNameAndIdMapping()), {_,x -> x.id == ids[1]}), {_,x -> x.name})[0]
	if len(ids) > 2
		let parsed.id = ids[2]
	endif
	return parsed
endfunction

function! BuildAdosWorkItemUrl(...)
	let workItemId = a:0 ? a:1 : $wip
	return printf('%s/_workitems/edit/%d', $ados, workItemId)
endfunction
command! -nargs=? -complete=customlist,GetWorkItemsAssignedToMeInCurrentIteration AdosWorkItem exec 'Firefox' BuildAdosWorkItemUrl(str2nr(<f-args>))

function! BuildAdosWorkItemParentUrl(...)
	let workItemId = a:0 ? a:1 : $wip
	let cmd = printf(
		\'curl -s --location -u:%s "%s/_apis/wit/workitems/%s?api-version=5.0&$expand=relations" | jq ".relations[] | select (.attributes.name == \"Parent\").url"',
		\$pat,
		\$ados,
		\workItemId
	\)
	let v = substitute(system(cmd), '[\x0]', '', 'g')
	let v = trim(v, '"')
	let id = split(v, '/')[-1]
	return printf('%s/_workitems/edit/%d', $ados, id)
endfunction
command! -nargs=? -complete=customlist,GetWorkItemsAssignedToMeInCurrentIteration AdosParentItem exec 'Firefox' BuildAdosWorkItemParentUrl(str2nr(<f-args>))

function! BuildAdosLatestPullRequestWebUrl(...)
	let workItemId = a:0 ? a:1 : $wip
	let cmd = printf(
		\'curl -s --location -u:%s "%s/_apis/wit/workitems/%s?api-version=5.0&$expand=relations" | jq "[.relations[] | select (.attributes.name == \"Pull Request\")] | max_by(.id).url"',
		\$pat,
		\$ados,
		\workItemId
	\)
	let vstfsUrl = substitute(system(cmd), '[\x0]', '', 'g')
	let vstfsUrl = trim(vstfsUrl, '"')
	let infos = ParseVsTfsUrl(vstfsUrl)
	let webUrl = printf('%s/%s/_git/%s/pullrequest/%s', $ados, infos.project, infos.repository, infos.id)
	return webUrl
endfunction
command! -nargs=? -complete=customlist,GetWorkItemsAssignedToMeInCurrentIteration AdosPullRequest exec 'Firefox' BuildAdosLatestPullRequestWebUrl(str2nr(<f-args>))

function! LocListToAdosBuilds()
	let repository = fnamemodify(GetNearestParentFolderContainingFile('.git'), ':t')
	let name2idMapping = copy(GetAdosRepositoriesNameAndIdMapping())
	let matchingRepositories = filter(name2idMapping, {_,x -> x.name == repository})
	if empty(matchingRepositories)
		echomsg repository 'is not a known repository on azuredevops.'
		return
	endif
	let matchingRepository = matchingRepositories[0]
	let cmd = printf(
		\'curl -s --location -u:%s "%s/%s/_apis/build/builds?requestedFor=Minh-Tam%%20Tran&repositoryType=TfsGit&repositoryId=%s&maxBuildsPerDefinition=5&queryOrder=startTimeDescending&api-version=5.0" | jq "[.value[] | {name:.buildNumber, status, result, url:._links.web.href, startTime, id}]"',
		\$pat,
		\$ados,
		\$adosProject,
		\matchingRepository.id
	\)
	let builds = js_decode(substitute(system(cmd), '[\x0]', '', 'g'))
	let builds = map(builds, {_, x -> extend(x, {'displayedStatus': (x.status == 'completed' ? x.result : x.status), 'displayedDate': x.startTime[:9].' '.x.startTime[11:15]})})
	let maxNameLength = max(mapnew(builds, {_,x -> len(x.name)}))
	let maxDisplayedStatusLength = max(mapnew(builds, {_,x -> len(x.displayedStatus)}))
	let height = min([15, len(builds)])
	let items = mapnew(builds, {_,x ->printf('%-*S | %s | [buildId#%d] %s', maxNameLength, x.name, x.displayedDate, x.id, x.displayedStatus)})
	exec height.'new'
	put! =items
	let b:is_custom_loclist = 1
	let b:quickfix_title = repository.' Builds'
	exec "normal! Gddgg"
	set ft=qf bt=nofile
	let b:urls = mapnew(builds, {_,x -> x.url})
	nnoremap <silent> <buffer> i :exec 'Firefox' b:urls[line('.')-1]<CR>
	nnoremap <silent> <buffer> o :exec 'Firefox' $mainBuildUrl<CR>
endfunction
command! AdosBuilds call LocListToAdosBuilds()
nnoremap <Leader>A :AdosBuilds<CR>

function! BuildRepositoryPullRequestsWebUrl(...)
	let repository = a:0 ? a:1 : fnamemodify(GetNearestParentFolderContainingFile('.git'), ':t')
	return printf('%s/%s/_git/%s/pullrequests?_a=mine', $ados, $adosProject, repository)
endfunction

function! GetWorkItemsAssignedToMeInCurrentIteration(argLead, cmdLine, cursorPos)
	let g:adosMyWorkItems = get(g:, 'adosMyWorkItems', [])
	if empty(g:adosMyWorkItems)
		let ids= js_decode(substitute(system(printf('curl -s --location -u:%s "%s/_apis/wit/wiql/abb54a60-97c5-47ea-9525-1cc734c3c834" | jq "[.workItems[].id]"', $pat, $ados)), '[\x0]', '', 'g'))
		let list = js_decode(substitute(system(printf('curl -s --location -u:%s "%s/_apis/wit/workitems?ids=%s&api-version=5.0" | jq "[.value[]|{id, title: .fields[\"System.Title\"], status: .fields[\"System.State\"], type: .fields[\"System.WorkItemType\"]}]"', $pat, $ados, join(ids, ','))), '[\x0]', '', 'g'))
		let g:adosMyWorkItems = map(list, {_,x -> printf('%s {%s-%s:%s}', x.id, x.type, x.status, x.title)})
	endif
	return g:adosMyWorkItems
endfunction

function! LocListAdos(workItemId)
	let items={
		\'Task':                { 'order': 1, 'urlBuilder': function ('BuildAdosWorkItemUrl', [a:workItemId])},
		\'Parent':              { 'order': 2, 'urlBuilder': function ('BuildAdosWorkItemParentUrl', [a:workItemId])},
		\'Latest Pull Request': { 'order': 3, 'urlBuilder': function ('BuildAdosLatestPullRequestWebUrl', [a:workItemId])},
		\'My Pull Requests':    { 'order': 4, 'urlBuilder': function ('BuildRepositoryPullRequestsWebUrl')}
	\}
	exec len(items).'new'
	let b:urlBuilders = items
	set winfixheight
	put! =sort(keys(items), {a,b -> items[a].order - items[b].order})
	normal! Gddgg
	let b:is_custom_loclist = 1
	let b:quickfix_title = 'wit#'.filter(copy(g:adosMyWorkItems), {_,x -> x =~ '^'.a:workItemId})[0]
	set ft=qf bt=nofile
	nnoremap <silent> <buffer> i :exec 'Firefox' eval("b:urlBuilders[getline('.')].urlBuilder()")<CR>
endfunction
command! -nargs=1 -complete=customlist,GetWorkItemsAssignedToMeInCurrentIteration Ados call LocListAdos(str2nr(<f-args>))
nnoremap <Leader>a :Ados <tab>

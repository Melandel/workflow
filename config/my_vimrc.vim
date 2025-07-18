let g:isWindows = has('win32')
let g:isWsl = isdirectory('/mnt/c/Windows')
if !g:isWindows && !g:isWsl
	echoerr 'Only Windows and WSL are handled by this vimrc for now.'
	finish
endif

if g:isWindows
	let desktop = printf('%s/Desktop', substitute($HOME, '\\', '/', 'g'))
	let $rc        = printf('%s/config/my_vimrc.vim', desktop)
	let $rce       = printf('%s/config/my_vimworkenv.vim', desktop)
	let $p         = printf('%s/projects', desktop)
	let $n         = printf('%s/notes', desktop)
	let $m         = printf('%s/notes/media', desktop)
	let $i         = printf('%s/notes/icons', desktop)
	let $d         = printf('%s/diffs', desktop)
	let $vimFiles  = printf('%s/config/myVim', desktop)
	let universalAutocompletionFile = ($UNIVERSAL_AUTOCOMPLETION_JSON != '')
		\? $UNIVERSAL_AUTOCOMPLETION_JSON
		\: printf('%s/config/universal_autocompletion.json', desktop)
	let $ua = universalAutocompletionFile
	let g:rc = {
		\"desktop": desktop,
		\"notes":    printf('%s/%s', desktop, 'notes'),
		\"projects": printf('%s/%s', desktop, 'projects'),
		\"tmp":      printf('%s/%s', desktop, 'tmp'),
		\"today":    printf('%s/%s', desktop, 'today'),
		\"scripts":  printf('%s/%s', desktop, 'scripts'),
		\"gtools":   printf('%s/%s', desktop, 'tools/git/usr/bin'),
		\"wip":      printf('%s/%s', desktop, 'work_in_progress'),
		\"queries":  printf('%s/%s', desktop, 'queries'),
		\"diffs":    printf('%s/%s', desktop, 'diffs'),
		\"config":   printf('%s/%s', desktop, 'config'),
		\"vimFiles": printf('%s/%s', desktop, 'config/myVim'),
		\"workenv":  printf('%s/%s', desktop, 'config/workenv'),
		\"ctx": {
		 \"csproj": '',
		 \"sln": '',
		 \"repoPath": '',
		 \"repoName": '',
		 \"env": ''
		\},
		\"env": {
			\"browser": "firefox.exe",
			\"adosBoard": "www.google.fr",
			\"pat": "azertyuiop1234",
			\"ados": '',
			\"adosProject": "foo",
			\"adosSourceProject": "app",
			\"adosDeploymentPipeline": "www.google.fr",
			\"adosMyAssignedActiveWits": "myquery",
			\"mainBuildUrl": "www.google.fr",
			\"ghOrganization": '',
			\"universalAutocompletionFile": universalAutocompletionFile,
			\"universalAutocompletions": [],
			\"universalAutocompletionItemMaxWidth": 60,
			\"meetingKindsFolder": printf('%s/%s', desktop, 'templates/meetings')
		\}
	\}
endif

" Desktop Integration:-----------------{{{
" Plugins: ----------------------------{{{
let &packpath=printf('%s,%s', $vim, g:rc.vimFiles)
packadd! matchit
packadd! cfilter
function! MinpacInit()
	packadd minpac
	call minpac#init( {'dir': g:rc.vimFiles, 'package_name': 'plugins', 'progress_open': 'none' } )
	call minpac#add('editorconfig/editorconfig-vim')
	call minpac#add('dense-analysis/ale')
	call minpac#add('junegunn/fzf.vim')
	call minpac#add('itchyny/lightline.vim')
	call minpac#add('itchyny/vim-gitbranch')
	"call minpac#add('nickspoons/omnisharp-vim', {'branch': 'test-runner'})
	call minpac#add('OmniSharp/omnisharp-vim')
	"call minpac#add('Melandel/omnisharp-vim') ", {'branch': 'improve_vimspector_config_file_generated'})
	call minpac#add('prabirshrestha/asyncomplete.vim')
	call minpac#add('puremourning/vimspector')
	call minpac#add('nickspoons/vim-sharpenup')
	call minpac#add('Olical/vim-enmasse')
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
	call minpac#add('Melandel/vim-qf-preview', {'rev': 'fix-visual-selection'})
	call minpac#add('zigford/vim-powershell')
	call minpac#add('Melandel/vim-empower')
	call minpac#add('Melandel/fzfcore.vim')
	call minpac#add('Melandel/gvimtweak')
endfunction
command! -bar MinPacInit call MinpacInit()
command! -bar MinPacUpdate call MinpacInit()| call minpac#clean()| call minpac#update()
let loaded_netrwPlugin = 1 " do not load netrw

" First time: -------------------------{{{
if !isdirectory(g:rc.vimFiles.'/pack/plugins')
	call system('git clone https://github.com/k-takata/minpac.git ' . g:rc.vimFiles . '/pack/packmanager/opt/minpac')
	call MinpacInit()
	call minpac#update()
	packloadall
endif

" Duplicated/Generated files: ---------{{{
augroup duplicatefiles
	au!
	au BufWritePost my_keyboard.ahk exec '!Ahk2Exe.exe /in %:p /out '.g:rc.desktop.'\myAzertyKeyboard.RunMeAsAdmin.exe'
augroup end

" General:-----------------------------{{{
" Settings: ---------------------------{{{
syntax on
filetype plugin indent on
silent! language messages English_United states
set autoread
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
let &directory = printf('%s/vim', g:rc.tmp)
set backup
let &backupdir = printf('%s/vim', g:rc.tmp)
set undofile
let &undodir = printf('%s/vim', g:rc.tmp)
let &viewdir = printf('%s/vim', g:rc.tmp)
set sessionoptions=curdir,folds,help,options,tabpages,winsize
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
	set guioptions-=e  "terminal-like tabline
	set guifont=consolas:h11
	"set termwintype=conpty "gives good colors to bat.exe but disables arrows/backspace
endif
" Windows Subsystem for Linx (WSL)
set ttimeout ttimeoutlen=0

if g:isWsl
	augroup WSLYank
		autocmd!
		autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/mnt/c/Windows/System32/clip.exe', @0) | endif
	augroup END
endif

" Tabs and Indentation: ---------------{{{
set smartindent
set tabstop=1
set shiftwidth=1
augroup vimOnlyTabSize
	au!
	autocmd BufEnter *.cs if(&ts != 1) | set tabstop=1 shiftwidth=1 softtabstop=0 noexpandtab | endif
	autocmd BufEnter *.md if(&ts != 2) | set tabstop=2 shiftwidth=2 softtabstop=0 expandtab	| endif
	autocmd BufEnter *.json if(&ts != 2) | set tabstop=2 shiftwidth=2 softtabstop=0 expandtab | endif
augroup end

command! -bar Retab let ts=&ts|let &et=0|let &ts=(&ts+1) |retab!|let &ts=ts|retab!

function! CSharpIndentArrow(currentLineNr)
	"echomsg '='
	let previousLine = GetPreviousLine(a:currentLineNr, '^\s*$', 1)
	let followsBlockClosingParenthesis = previousLine.line =~ ')\s*$'
	let lineBeforePreviousLine = GetPreviousLine(a:currentLineNr-1, '^\s*$', 1)
	let previousLineIsParameter = followsBlockClosingParenthesis && (lineBeforePreviousLine.line =~ '\((\|,\|^\)\s*$')
	return previousLineIsParameter
		\ ? previousLine.lineIndent-1
		\ : previousLine.lineIndent
endfunction

function! CSharpIndentOpeningBracket(currentLineNr)
	"echomsg '{'
	let previousLine = GetPreviousLine(a:currentLineNr, '^\s*$', 1)
	let followsBlockOpeningBracket = previousLine.line =~ '\({\|(\)\s*$'
	return (followsBlockOpeningBracket)
		\ ? previousLine.lineIndent+1
		\ : previousLine.lineIndent
endfunction

function! CSharpIndentClosingBracket(currentLineNr)
	"echomsg '}'
	let previousLine = GetPreviousLine(a:currentLineNr, '^\s*$', 1)
	let followsSoloOpeningBracket = previousLine.line =~ '^\s*{'
	let followsDotCallChainItem =	previousLine.line =~ '^\s*\.'
	return (followsSoloOpeningBracket)
		\ ? previousLine.lineIndent
		\ : (followsDotCallChainItem)
				\ ? previousLine.lineIndent-2
				\ : previousLine.lineIndent-1
endfunction

function! CSharpIndentOpeningParenthesis(currentLineNr)
	"echomsg '('
	let previousLine = GetPreviousLine(a:currentLineNr, '^\s*$', 1)
	let followsBlockOpeningBracket = previousLine.line =~ '\({\|(\)\s*$'
	return (followsBlockOpeningBracket)
		\ ? previousLine.lineIndent+1
		\ : previousLine.lineIndent
endfunction

function! CSharpIndentClosingParenthesis(currentLineNr)
	"echomsg ')'
	let previousLine = GetPreviousLine(a:currentLineNr, '^\s*$', 1)
	let followsSoloOpeningParenthesis = previousLine.line =~ '^\s*('
	return followsSoloOpeningParenthesis
		\ ? previousLine.lineIndent
		\ : previousLine.lineIndent-1
endfunction

function! CSharpIndentColon(currentLineNr)
	"echomsg ':'
	let previousLine = GetPreviousLine(a:currentLineNr, '^\s*$', 1)
	let followsTernary = previousLine.line =~ '\s\+?\s\+'
	return followsTernary
		\ ? previousLine.lineIndent
		\ : previousLine.lineIndent+1
endfunction

function! CSharpIndentDot(currentLineNr)
	"echomsg '.'
	let previousLine = GetPreviousLine(a:currentLineNr, '^\s*$', 1)
	let followsIndentedDotCallChainItem = previousLine.line =~ '^\s*\(}\|)\)\+\s*$'
	let followsDotCallChainItem = previousLine.line =~ '^\s*\..*)\s*$'
	return followsIndentedDotCallChainItem
		\ ? previousLine.lineIndent-1
		\ : (followsDotCallChainItem)
				\ ? previousLine.lineIndent
				\ : previousLine.lineIndent+1
endfunction

function! CSharpIndentNewLine(currentLineNr)
	"echomsg 'NL'
	let previousLine = GetPreviousLine(a:currentLineNr, '^\s*\(//.*\)\?$', 1)
	let followsSoloOpeningChar     = previousLine.line =~ '\({\|(\|=>\)\s*$'
	if followsSoloOpeningChar
		return previousLine.lineIndent+1
	endif
	let followsSoloClosingChar     = previousLine.line =~ '\(}\|)\)\s*$'
	if followsSoloClosingChar
		return previousLine.lineIndent
	endif
	let followsEndOfFunctionCall   = previousLine.line =~ '^\s*\(}\|)\)\+;\s*$'
	if followsEndOfFunctionCall
		return previousLine.lineIndent
	endif
	let followsIndentedEndOfFunctionCall   = previousLine.line =~ '^\s*[^})\a_\d]\+\(}\|)\)\+;\s*$'
	if followsIndentedEndOfFunctionCall
		return previousLine.lineIndent-1
	endif
	let followsAttribute = previousLine.line =~ '^\s*['
	if followsAttribute
		return previousLine.lineIndent
	endif
	let followsIndentedItem   = previousLine.line =~ '^\s*\..\+;\s*$'
	if followsIndentedItem
		let lineNr = a:currentLineNr
		let lineIndent = 99
		while lineIndent >= previousLine.lineIndent
			let lineNr -= 1
			let previousCodeLine = GetPreviousLine(lineNr, '^\s*\(\a\|_\)')
			let lineNr = previousCodeLine.lineNr
			let lineIndent = previousCodeLine.lineIndent
		endwhile
		return lineIndent
	endif
	return previousLine.lineIndent
endfunction

function! GetPreviousLine(lineNrStartExcluded, pattern, ...)
	let shouldNotMatch = a:0 ? a:1 : 0
		let previousLineNr = a:lineNrStartExcluded-1
		let previousLine = getline(previousLineNr)
		if !shouldNotMatch
			while previousLineNr > 1 && previousLine !~ a:pattern
				let previousLineNr = previousLineNr-1
				let previousLine = getline(previousLineNr)
			endwhile
		else
			while previousLineNr > 1 && previousLine =~ a:pattern
				let previousLineNr = previousLineNr-1
				let previousLine = getline(previousLineNr)
			endwhile
		endif
		return { 'line': previousLine, 'lineNr': previousLineNr, 'lineIndent': indent(previousLineNr) }
endfunction

func! CSharpIndent(...)
	let currentLineNr = a:0 ? a:1 : v:lnum
	if currentLineNr == 1 | return 0 | endif
	let currentLine = getline(currentLineNr)
	if currentLine =~ '^\s*$' | return CSharpIndentNewLine(currentLineNr) | endif
	let firstChar = trim(currentLine)[0]
	if firstChar == '=' | return CSharpIndentArrow(currentLineNr) | endif
	if firstChar == '.' | return CSharpIndentDot(currentLineNr) | endif
	if firstChar == '{' | return CSharpIndentOpeningBracket(currentLineNr) | endif
	if firstChar == '(' | return CSharpIndentOpeningParenthesis(currentLineNr) | endif
	if firstChar == '}' | return CSharpIndentClosingBracket(currentLineNr) | endif
	if firstChar == ')' | return CSharpIndentClosingParenthesis(currentLineNr) | endif
	if firstChar == ':' | return CSharpIndentColon(currentLineNr) | endif
	return CSharpIndentNewLine(currentLineNr)
endfunction



" Leader keys: ------------------------{{{
let mapleader = 's'
let maplocalleader = 'q'

" Local Current Directories: ----------{{{
let g:lcd_qf = getcwd()

function! GetInterestingParentDirectory()
	if &ft == 'qf'
		return g:lcd_qf
	elseif &ft == 'dirvish'
		return trim(expand('%:p'), '\')
	endif
	let dir = substitute(expand('%:p:h'), '\\', '/', 'g')
	if stridx(dir, g:rc.projects) >= 0
		let dir = dir[:stridx(dir, '/', len(g:rc.projects)+1)]
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
	if &buftype == 'terminal' | return | endif
	if (&filetype == 'markdown' && filereadable(expand('%')))
		exec 'lcd' expand('%:h')
		return
	endif
	let dir = GetInterestingParentDirectory()
	if dir =~ '^fugitive://' | return | endif
	if has_key(w:, 'row')
		redraw
		exec 'lcd' w:row.cwd
		return
	endif
	let current_wd = getcwd()
	if current_wd != dir
		redraw
		exec 'lcd' dir
		return
	endif
endfunction
command! -bar Lcd call UpdateLocalCurrentDirectory()

function! UpdateEnvironmentLocationVariables()
	let csproj = GetNearestParentFolderContainingFile('*.csproj')
	if csproj != ''
		let g:rc.ctx.csproj = csproj
		let sln = GetNearestParentFolderContainingFile('*.sln')
		if sln != ''
			let g:rc.ctx.sln = sln
		elseif has_key(g:, 'csprojs2sln') && has_key(g:csprojs2sln, csprojdir)
			let sln = g:csprojs2sln[csproj]
		endif
	endif
	let repoPath = trim(fnamemodify(GetNearestParentFolderContainingFile('.git'), ':p'), '\')
	if repoPath !~ 'Desktop' | let g:rc.ctx.repoPath = repoPath | endif
	let repoName = fnamemodify(repoPath, ':t')
	if repoName != 'Desktop' | let g:rc.ctx.repoName = repoName | endif
endfunc

augroup lcd
	au!
	" enew has a delay before updating bufname()
	autocmd BufCreate * call timer_start(100, { timerid -> execute('if &ft != "qf" && bufname() == "" | set bt=nofile | endif', '') })
	autocmd BufEnter	* call timer_start(100, { timerid -> execute('if &ft == "dosbatch" | | elseif &ft!="dirvish" | Lcd | else | lcd %:p:h | endif', '') })
	autocmd QuickFixCmdPre * call timer_start(100, { timerid -> execute('let g:lcd_qf = getcwd()', '') })
	autocmd BufEnter * call UpdateEnvironmentLocationVariables()
augroup end

" Utils:-------------------------------{{{
function! StrftimeFR(format, ...)
	let currentLanguageReport = execute('language')
	let lcTimePosition = stridx(currentLanguageReport, 'LC_TIME=')
	let lcTimeStart = lcTimePosition + len('LC_TIME=')
	let lastQuotePosition = stridx(currentLanguageReport, '"', lcTimeStart)
	let nextLcItem = stridx(currentLanguageReport, ';', lcTimeStart)
	let lcTimeStop = nextLcItem == -1 ? lastQuotePosition-1 : nextLcItem-1
	let currentTimeLanguage = currentLanguageReport[lcTimeStart:lcTimeStop]
	if currentTimeLanguage == 'French_France.utf8'
		return a:0 ? strftime(a:format, a:1) : strftime(a:format)
	endif
	execute ('language time French_France.utf8')
	let strftime = a:0 ? strftime(a:format, a:1) : strftime(a:format)
	execute (printf('language time %s', currentTimeLanguage))
	return strftime
endfunction

function! StringStartsWith(longer, shorter, ...)
	let isCaseSensitive = (a:0 != 0)
	return isCaseSensitive
		\? a:longer[:len(a:shorter)-1] ==# a:shorter
		\: a:longer[:len(a:shorter)-1] ==? a:shorter
endfunc

function! ParseJsonFile(path)
	let lines = readfile(a:path)
	call filter(lines, 'match(v:val, "^\\s*//") == -1')
	call map(lines,	'trim(v:val)')
	let jsonWithoutCommentLines = join(lines)
	return json_decode(jsonWithoutCommentLines)
endfunc

function! MoveCursorInsideWindowAndExecuteCommands(winid, move, ...)
	let pos = getcurpos(a:winid)
	let lnum = pos[1]
	let col = pos[2]
	let newLnum = a:move(lnum)
	if newLnum < 1 || newLnum > line('$', a:winid)
		return
	endif
	let commands = [printf('call cursor(%d,%d)', newLnum, col)]
	call extend(commands, a:000)
	call win_execute(a:winid, commands)
endfunction

function! RemoveDiacritics(str)
	let diacs = 'áâãàçéêèïíóôõüúù'	" lowercase diacritical signs
	let diacs .= toupper(diacs)
	let repls = 'aaaaceeeiiooouuu'	" corresponding replacements
	let repls .= toupper(repls)
	return tr(a:str, diacs, repls)
endfunction

function! ToggleQuickfixList()
	let quickfixWindows = filter(range(1, winnr('$')), {_,x -> getwinvar(x, '&syntax') == 'qf' && !getwininfo(win_getid(x))[0].loclist && !get(getbufinfo(winbufnr(x))[0].variables, 'is_custom_loclist', 0)})
	silent! execute empty(quickfixWindows) ? 'cwin' : 'ccl'
endfunction

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
	return line('$') == 1 && empty(trim(getline(1)))
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
	return &ft == 'qf' && !getwininfo(win_getid())[0].loclist
endfunction


function! FileNameorQfTitle()
	if IsQuickFixWindow() || IsLocListWindow()
		return get(w:, 'quickfix_title', get(b:, 'quickfix_title'))
	else
		let bufname = bufname()
		if isdirectory(bufname)
			return FolderRelativePathFromGit()
		else
			if &readonly
				let res = bufname
				let cwd = substitute(getcwd(), '\', '/', 'g')
				let idx = stridx(res, cwd)		| if idx >= 0 | let res = res[idx+len(cwd)+1:] | endif
				let shaidx = match(res, '\x\{40\}') | if shaidx >= 0 | let res = res[:shaidx+6].res[shaidx+40:] | endif
				return res
			elseif bufname =~ '\\\.git\\\\\d\\'
				let res = bufname
				let idx = stridx(res, '.git\\')
				let res = res[idx:idx+6]
				if res[6] == '0'
					let res.=' (index)'
				elseif res[6] == '2'
					let res.=' (target branch)'
				elseif res[6] == '3'
					let res.=' (merge branch)'
				endif
				return res
			else
				return fnamemodify(bufname, ':t')
			endif
		endif
	endif
endfunction

function! IsInsideDashboard()
	return get(t:, 'is_dashboard_tabpage', 0)
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
		call substitute(join(readfile(g:rc.desktop.'/todo')), '\v\+(\S)+', '\=len(add(hits, submatch(0))) ? submatch(0) : ""', 'gne')
		call substitute(join(readfile(g:rc.desktop.'/done')), '\v\+(\S)+', '\=len(add(hits, submatch(0))) ? submatch(0) : ""', 'gne')
		return map(uniq(sort(hits)), {_,x->x[1:]})
	endif
	return ['toto', previouschar]
endfunction

function! JobStartExample(...)
	let cmd = a:0 ? (a:1 != '' ? a:1 : 'dir') : 'dir'
	let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/Job')
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
			\'close_cb': { chan	 -> execute('echomsg "[close] '.chan.'"', 1)},
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

function! ResetScratchBuffer(pathOrNumber)
	let existingBufNr = type(a:pathOrNumber) == type(0) ? a:pathOrNumber : bufnr(a:pathOrNumber)
	if existingBufNr > 0 | silent! exec 'bdelete!' existingBufNr | endif

	let bufnr = bufadd(a:pathOrNumber)
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

function! PromptUserForFilenameWithSuggestion(default, ...)
	let title = input('', a:default)
	let ComputeFinalPath = a:0 ? a:1 : { x -> x }
	let finalpath = ComputeFinalPath(title)
	let finalfilename = fnamemodify(finalpath, ':t')
	let GetRetryMessage = { x -> a:0 > 0 ? a:1 : printf('[%s] already exists. ', title) }
	while title != '' && len(glob(ComputeFinalPath(title))) > 0
		redraw | let title= input(GetRetryMessage(title), title)
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
" AltGr keys: -------------------------{{{
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

" Arrows: -----------------------------{{{
inoremap <C-J> <Left>|	cnoremap <C-J> <Left>|	tnoremap <C-J> <Left>
inoremap <C-K> <Right>| cnoremap <C-K> <Right>| tnoremap <C-K> <Right>
tnoremap <C-N> <Down>| tnoremap <C-W><C-N> <C-N>
tnoremap <C-P> <Up>| tnoremap <C-W><C-P> <C-P>

" Home,End: ---------------------------{{{
inoremap ^j <Home>| cnoremap ^j <Home>| tnoremap ^j <Home>
inoremap ^k <End>|  cnoremap ^k <End>|	tnoremap ^k <End>

" Backspace,Delete: -------------------{{{
tnoremap <C-L> <Del>
inoremap <C-L> <Del>|	cnoremap <C-L> <Del>| smap <C-L> <Del>

" Accidental <C-U> or <C-W>
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Graphical Layout:--------------------{{{
" Colorscheme, Highlight groups: ------{{{
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

" Buffers, Windows & Tabs: ------------{{{
set hidden
set splitbelow
set splitright
set noequalalways " keep windows viewport when splitting
set previewheight=25
set showtabline=2

" Tab Labels
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
      let s .= (i + 1 == tabpagenr()) ? '%#TabLineSel#' : '%#TabLine#'
    let s .= '%' . (i + 1) . 'T'
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor
  let s .= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999X'
  endif
  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
		let omnisharpHosts = filter(map(copy(buflist), {_,x -> getbufvar(x, 'OmniSharp_host')}), {_,x -> !empty(x)})
		if (!empty(omnisharpHosts) && !(type(omnisharpHosts[0]) == type(1) && omnisharpHosts[0] >= 0))
			let host = omnisharpHosts[0]
			let sln_or_dir = fnamemodify(host.sln_or_dir, ':t:r')
			if exists('*IsDebuggingTab') && IsDebuggingTab(a:n)
				return '🔍'.sln_or_dir.'🔍'
			else
				let winnr = tabpagewinnr(a:n)
				let bufnr = buflist[winnr - 1]
				let filepath = bufname(bufnr)
				let filename = fnamemodify(filepath, ':t')

				if (tabpagenr() == a:n && !empty(sln_or_dir))
					if empty(sln_or_dir)
						return filename
					else
						let currentBufferHost = OmniSharp#GetHost()
						let sln_or_dir = fnamemodify(currentBufferHost.sln_or_dir, ':t:r')
						let omnisharp_up = get(currentBufferHost, 'initialized', 0)
						return omnisharp_up ? printf('<%s> %s', sln_or_dir, filename) : printf('[%s] %s', sln_or_dir, filename)
					endif
				endif
				return filename
			endif
		endif
  let winnr = tabpagewinnr(a:n)
		let bufnr = buflist[winnr - 1]
  let filepath = bufname(bufnr)
  let filename = fnamemodify(filepath, ':t')
	if !empty(filter(tabpagebuflist(a:n), {_,x -> getbufvar(x, 'fugitive_type', '') == 'index' }))
			return 'Git'
		elseif isdirectory(filepath)
			let relativePathFromGitRoot = FolderRelativePathFromGit(bufnr)
			let path = relativePathFromGitRoot == '/' ? fnamemodify(filepath, ':h:t').'/' : relativePathFromGitRoot
			return substitute(path, '\', '/', 'g')
		else
			return empty(filename) ? '#TMP' : filename
		endif
endfunction


function! ShouldMoveToPreviousTab()
	let previousLastTabNr=max([g:TabLeave_TabsStatus.last, g:WinClosed_TabsStatus.last])
	return tabpagenr('$') < previousLastTabNr && g:TabLeave_TabsStatus.current != previousLastTabNr
endfunction

let g:WinClosed_TabsStatus = { 'current': 1, 'last': 1 } 
let g:TabLeave_TabsStatus =  { 'current': 1, 'last': 1 }
augroup tabcloseleft
	au!
	au TabLeave  * let g:TabLeave_TabsStatus  = { 'current': tabpagenr(), 'last': tabpagenr('$') }
	au WinClosed * let g:WinClosed_TabsStatus = { 'current': tabpagenr(), 'last': tabpagenr('$') }
	au TabClosed * if ShouldMoveToPreviousTab() | tabprevious | endif
augroup end

function! CloseDashboardTabPages()
	let dashboardTabPages = map(filter(gettabinfo(), {_,x-> get(x.variables, 'is_dashboard_tabpage', 0)}), "v:val.tabnr")
	for tabnr in dashboardTabPages
		exec 'tabclose' tabnr
	endfor
endfunction

augroup tabline
	au!
	autocmd! SessionLoadPost * set tabline=%!MyTabLine() | autocmd! FileType cs set tabline=%!MyTabLine()
	autocmd! VimLeavePre * call CloseDashboardTabPages()
augroup end

" Close Buffers
function! DeleteBuffers(regex)
	exec 'bd' join(filter(copy(range(1, bufnr('$'))), { _,y -> bufname(y)=~ a:regex }), ' ')
endfunc

function! DeleteHiddenBuffers()
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
function! CloseTab()
	let nextTabNumber = tabpagenr()+1
	let isNextTabDiffTab = nextTabNumber <= tabpagenr('$') && gettabwinvar(nextTabNumber, 1, '&diff') != 0
	if (isNextTabDiffTab) | +tabmove | endif
	tabclose
endfunction
command! CloseTab call CloseTab()
command! CloseTabsOnTheRight .+1,$tabdo :tabclose

nnoremap <silent> <Leader>s :let buffers = w:buffers \| silent! split  \| let w:buffers = buffers<CR>
nnoremap <silent> <Leader>v :let buffers = w:buffers \| silent! vsplit \| let w:buffers = buffers<CR>
nnoremap <silent> K :q<CR>
nnoremap <silent> <Leader>o <C-W>_<C-W>\|
nnoremap <silent> <Leader>O mW:-tabnew<CR>`W
nnoremap <silent> <Leader>x :CloseTab<CR>
nnoremap <silent> <Leader>X :CloseTabsOnTheRight<CR>

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
nnoremap <silent> <Leader><space> :call ToggleQuickfixList()<CR>
nnoremap <silent> <Leader>n gt
nnoremap <silent> <Leader>N :tabnew<CR>
nnoremap <silent> <Leader>p gT

augroup windows
	autocmd!
	"
	" Use foldcolumn to give a visual clue for the current window
	autocmd WinLeave * if !pumvisible() | setlocal norelativenumber foldcolumn=0 | endif
	autocmd WinEnter * if !pumvisible() | setlocal relativenumber	 foldcolumn=1 | endif
	" Safety net if I close a window accidentally
	autocmd QuitPre * normal! mK
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
nnoremap <silent> <A-h> :vert res -2<CR>| tnoremap <silent> <A-h> <C-W>N:vert res -2<CR>i
nnoremap <silent> <A-l> :vert res +2<CR>| tnoremap <silent> <A-l> <C-W>N:vert res +2<CR>i
nnoremap <silent> <A-j> :res -2<CR>|	  tnoremap <silent> <A-j> <C-W>N:res -2<CR>i
nnoremap <silent> <A-k> :res +2<CR>|	  tnoremap <silent> <A-k> <C-W>N:res +2<CR>i
nnoremap <silent> <Leader>= <C-W>=
nnoremap <silent> <Leader>\| <C-W>\|
nnoremap <silent> <Leader>_ <C-W>_

" Status bar: -------------------------{{{
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

function! NumberOfLinesCurrentColumnAndGitBranchName()
	return printf('%dL [%s] |%d', line('$'), gitbranch#name(), col('.'))
endfunction

function! NumberOfLinesAndGitBranchName()
	return printf('%dL [%s]', line('$'), gitbranch#name())
endfunction

function! FolderRelativePathFromGit(...)
	let bufnr = a:0 ? a:1 : bufnr()
	let filepath = bufname(bufnr)
	let folderpath = fnamemodify(filepath, ':h')
	let gitrootfolder = fnamemodify(gitbranch#dir(filepath), ':h:p')
	if isdirectory(filepath)
		let folderpath.='/'
	endif
	let foldergitpath = folderpath[len(gitrootfolder)+(has('win32')?1:0):]
	return '/' . substitute(foldergitpath, '\', '/', 'g')
endfunction
let g:lightline = {
	\ 'colorscheme': 'empower',
	\ 'component_function': {
	\    'filesize_and_rows': 'FileSizeAndRows',
	\    'winnr': 'WinNr',
	\    'filename_or_qftitle': 'FileNameorQfTitle',
	\    'LinesCurrentColumnAndGitBranch': 'NumberOfLinesCurrentColumnAndGitBranchName',
	\    'LinesAndGitBranch': 'NumberOfLinesAndGitBranchName'
	\ },
	\ 'component': {
	\   'winnr2': '#%{winnr()}'
 \ },
	\ 'component_visible_condition': {
	\    'mode': '0'
	\  },
	\ 'active':   {
	\    'left':  [
	\	[ 'mode', 'paste', 'readonly', 'modified' ],
	\	[ 'LinesCurrentColumnAndGitBranch' ]
	\    ],
	\    'right': [
	\	['filename_or_qftitle', 'readonly', 'modified' ]
	\    ]
	\ },
	\ 'inactive': {
	\    'left':  [
	\	['LinesAndGitBranch']
	\    ],
	\    'right': [
	\	[ 'filename_or_qftitle', 'readonly', 'modified' ]
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

" Browsing File Architecture: ---------{{{
let g:qfprio = 'c'
let g:framingoffset = 5

function! Reframe()
	let topOffset = abs(line('.') - line('w0'))
	let bottomOffset = abs(line('.') - line('w$'))
	let minimalMargin = max([5, float2nr(round(winheight(winnr()) * 0.3))])
	if min([topOffset, bottomOffset]) < minimalMargin
		execute 'setlocal scrolloff='.minimalMargin
		let timer = timer_start(10, {_ -> execute('setlocal scrolloff=-1')})
	endif
endfunction

command! -bar Reframe call Reframe()
nnoremap <silent> zt :setlocal scrolloff=5 \| exec 'normal! zt' \| setlocal scrolloff=-1<CR>
nnoremap <silent> zT zt

function! Qfnext()
	call Qfmove('next')
endfunction

function! Qfprev()
	call Qfmove('previous')
endfunction

function! Qfmove(nextOrPrevious)
	let originalWinId = win_getid()
	let commandPrefix = g:qfprio
	try
		execute commandPrefix.a:nextOrPrevious
		execute commandPrefix.'open'
	catch
		execute 'silent!' commandPrefix.commandPrefix
	endtry
	silent call win_gotoid(originalWinId)
endfunction

function! BrowseNext(next)
	if &diff
		" chunk
		execute 'silent!' 'normal!' (a:next ? ']czx' : '[czx')
	elseif get(ale#statusline#Count(bufnr('')), 'error', 0) || get(ale#statusline#Count(bufnr('')), 'warning', 0)
		" warningOrError
		execute 'silent!' (a:next ? 'ALENext' : 'ALEPrevious')
	elseif &ft == 'fugitive'
		" untracked, unstaged, staged
		execute 'silent!' 'normal' (a:next ? "\<Plug>fugitive:]]" : "\<Plug>fugitive:[[")
	elseif &ft == 'git'
		" diff chunk
		execute 'silent!' 'normal' (a:next ? "\<Plug>fugitive:J" : "\<Plug>fugitive:K")
	else
		" loclist row / qflist row
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
		call Qfmove(a:next ? 'next' : 'previous')
	endif
	silent! normal! zzzv
endfunction
nnoremap <silent> <C-J> :call BrowseNext(v:true)<CR>
nnoremap <silent> <C-K> :call BrowseNext(v:false)<CR>

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
nnoremap gi `^
nnoremap <expr> gI v:count == 0 ? '`I' : 'gI'

" Current Line: -----------------------{{{
nnoremap <silent> . :let c= strcharpart(getline('.')[col('.') - 1:], 0, 1)\|exec "normal! f".c<CR>

function! ExtendedHome()
	normal! m'
    let column = col('.')
	keepjumps normal! ^
    if column == col('.')
		keepjumps normal! 0
    endif
endfunction
command! Home call ExtendedHome()
nnoremap <silent> <Home> :Home<CR>
vnoremap <silent> <Home> <Esc>:Home<CR>mvgv`v
onoremap <silent> <Home> :Home<CR>

function! ExtendedEnd()
	normal! m'
    let column = col('.')
	keepjumps normal! g_
    if column == col('.') || column == col('.')+1
		keepjumps normal! $
    endif
endfunction
command! End call ExtendedEnd()
nnoremap <silent> <End> :End<CR>
vnoremap <silent> <End> m'$m'
onoremap <silent> <End> :End<CR>

" Text objects: -----------------------{{{
vnoremap iz [zjo]zkVg_| onoremap iz :normal viz<CR>
vnoremap az [zo]zVg_|	onoremap az :normal vaz<CR>
vnoremap if ggoGV| onoremap if :normal vif<CR>
nnoremap vii :call TextObjectBackslash()<CR>
function! TextObjectBackslash()
	normal vi\ol
endfunction
" Always add cursor position to jumplist
let g:targets_jumpRanges = 'cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb al rB Al bb aa bB Aa BB AA'

" Text Operations:---------------------{{{
" Visualization: ----------------------{{{
" select until end of line
nnoremap vv ^vg_
nnoremap <C-V><C-V> ^<C-V>
" remove or add a line to visualization
vnoremap <silent> <C-J> <C-V><esc>gvVojo
vnoremap <silent> <C-K> <C-V><esc>gvVoko

" Copy & Paste: -----------------------{{{
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
vnoremap y  y
nnoremap <expr> vp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Repeat-Last-Action: -----------------{{{
nnoremap ù .

" Vertical Alignment: -----------------{{{
xmap ga :Tabular /
nmap ga :Tabular /
xnoremap gA :Tabular /\|<CR>
nnoremap gA vip:Tabular /\|<CR>

" Vim Core Functionalities:------------{{{
" Command Line:------------------------{{{
set cmdwinheight=40
set cedit=<C-F>

" Wild Menu: --------------------------{{{
set wildmenu
set wildcharm=<Tab>
set wildignorecase
set wildmode=full

" Sourcing: ---------------------------{{{
vnoremap <silent> <Leader>V mvy:call histadd('cmd', @@)\|exec @@<CR>`v
nnoremap <silent> <Leader>V mv^y$:exec @@<CR>`v

" Write output of a vim command in a buffer
nnoremap ç :let script=''\|call histadd('cmd',script)\|put=execute(script)<Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>
augroup vimsourcing
	au!
	if has('win32') && has('gui_running')
		autocmd BufWritePost .vimrc,_vimrc,*.vim if !IsInsideDashboard() | GvimTweakToggleFullScreen | so % | GvimTweakToggleFullScreen | endif
	else
		autocmd BufWritePost .vimrc,_vimrc,*.vim so %
	endif
	autocmd FileType vim nnoremap <buffer> z! :BLines function!\\|{{{<CR>
augroup end

" Find, Grep, Make, Equal: ------------{{{
function! Grep(qf_or_loclist, ...)
	let cwd = getcwd()
	let winnr = winnr()
	let params = join(a:000)
	let firstDoubleQuote = stridx(params, '"')
	let reversed = join(reverse(split(params, '.\zs')), '')
	let lastDoubleQuote = (-1 * stridx(reversed, '"')) - 1
	let pattern = params[firstDoubleQuote+1:lastDoubleQuote-1]
	call histadd('/', pattern) | let @/ = pattern
	let patternHasDash = stridx(pattern, '-') >= 0
	let firstTokenWithDoubleQuote = index(map(copy(a:000), {i,x -> x =~ '^"'}), 1)
	let cmdParams = firstTokenWithDoubleQuote ? a:000[0:firstTokenWithDoubleQuote-1] : []
	if patternHasDash
		call add(cmdParams, '-e')
	endif
	let cmdParams += a:000[firstTokenWithDoubleQuote:]
	let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/grep')
	let foldersToIgnore = [ 'obj', 'bin' ]
	if WindowsPath(cwd) == WindowsPath(g:rc.desktop)
		let foldersToIgnore += [ 'projects', 'tmp', 'viebfiles', 'myVim/pack', 'templates', 'tools' ]
	endif
	let foldersIgnoreOpts = join(map(foldersToIgnore, { _,x -> '-g "!**/'.x.'/**"' }))
	let leafFoldersIgnoreOpts = join(map(
		\[ 'config' ],
		\{ _,x -> '-g "!**/'.x.'/*"' }))
	let cmd = printf('rg --no-ignore --vimgrep --no-heading --smart-case %s %s %s', leafFoldersIgnoreOpts, foldersIgnoreOpts, join(cmdParams))
	let cmd .= ' \\?\%cd%' "https://github.com/BurntSushi/ripgrep/issues/364
	set cmdheight=2
	echomsg cwd.':' cmd
	if g:isWindows | let cmd = 'cmd /C '.cmd | endif
	let s:job = job_start(
		\cmd,
		\{
			\'cwd': cwd,
			\'out_io': 'buffer',
			\'out_buf': scratchbufnr,
			\'out_modifiable': 1,
			\'err_io': 'buffer',
			\'err_buf': scratchbufnr,
			\'err_modifiable': 1,
			\'in_io': 'null',
			\'exit_cb': function("GrepCB", [winnr, cmd, cwd, pattern, scratchbufnr, a:qf_or_loclist])
		\}
	\)
endfunction

function! GrepCB(winnr, cmd, cwd, pattern, scratchbufnr, qf_or_loclist, job, exit_status)
	if (a:exit_status)
		silent exec printf('botright sbuffer%d | let w:quickfix_title = "%s"', a:scratchbufnr, printf("[grep] %s", escape(a:pattern, '"')))
		0put=a:cmd
		return
	endif
	exec 'lcd' a:cwd
	set errorformat=%*[^C]%f:%l:%c:%m
	let prefix = (a:qf_or_loclist == 'qf' ? 'c' : 'l')
	silent exec prefix.'getbuffer' a:scratchbufnr
	let winnr = winnr()
	let title = printf("[grep] %s", a:pattern)
	let firstDoubleQuotePos = stridx(title, '"')
	if firstDoubleQuotePos >= 1
		let title = title[:firstDoubleQuotePos-1]
	endif
	silent exec printf('call setwinvar(%d, "quickfix_title", ''%s'')', winnr, title)
	set cmdheight=1
	echomsg title
endfunction
command! -nargs=+ Grep	call Grep('qf',     <f-args>)
command! -nargs=+ Lgrep call Grep('loclist',<f-args>)

function! EscapeRipgrepPattern(pattern)
	let surroundWithDoubleQuotes = 0
	if a:pattern[0] == '"' && a:pattern[-1] == '"'
		let surroundWithDoubleQuotes = 1
	endif
	let res = surroundWithDoubleQuotes ? a:pattern[1:-2] : a:pattern
	let res = escape(res, '"')
	let res = surroundWithDoubleQuotes ? printf('"%s"', res) : res
	return res
endfunction

set switchbuf+=uselast
set errorformat=%m
nnoremap <Leader>f :Files<CR>
nnoremap	 µ :Grep -F "<C-R>=EscapeRipgrepPattern(expand('<cword>'))<CR>"<CR>
vnoremap	 µ "vy:let cmd = printf('Grep -F "%s"', EscapeRipgrepPattern(@v))\|call histadd('cmd',cmd)\|exec cmd<CR>
nnoremap <Leader>! :Grep -F ""<left>
vnoremap <silent> <Leader>r "vy:Grep -F "<C-R>=GetCurrentSelection()<CR>"<CR>
nnoremap <LocalLeader>m :silent make<CR>

" Terminal: ---------------------------{{{
tnoremap <silent> <Esc> <C-W>N| tnoremap <silent> <C-W>N <Esc>
tnoremap <silent> <C-U> <Esc>| tnoremap <silent> <C-W>u <C-U>
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
tnoremap <silent> <Leader>tt <C-W>:if &termwinsize == '' \| let &termwinsize='0*9999' \| else \| let &termwinsize='' \| endif<CR>
tnoremap <silent> <Leader>== <C-W>=
tnoremap <silent> KK <C-W>:q<CR>
tnoremap <silent> HH <C-W>:CycleBackwards<CR>
tnoremap <silent> LL <C-W>:CycleForward<CR>
tnoremap <silent> <Leader>qq <C-W>:ToggleQueryRow<CR>
tnoremap <silent> <Leader>qQ <C-W>:CreateQueryRow<CR>

augroup terminal
	au!
	autocmd! TerminalWinOpen * setl termwinsize=0*9999
augroup end
" Folding: ----------------------------{{{
vnoremap <silent> <space> <Esc>zE:let b:focus_mode=1 \| setlocal foldmethod=manual<CR>`<kzfgg`>jzfG`<
nnoremap <silent> <space> :exec('normal! '.(b:focus_mode==1 ? 'zR' : 'zM')) \| let b:focus_mode=!b:focus_mode<CR>

set foldtext=FoldText()
function! FoldText()
	let foldstart = v:foldstart
	while getline(foldstart) =~ '^\s*\({\|\/\|<\|[\|#\)'
		let foldstart += 1
	endwhile
	let title = getline(foldstart)[len(v:folddashes)-1:]
	return repeat('-', len(v:folddashes)-1).title.' ('.(v:foldend-v:foldstart+1).'rows)'
endfunction
" Search: -----------------------------{{{
set hlsearch
set incsearch
set ignorecase
" Display '1 out of 23 matches' when searching
set shortmess=filnxtToOc
nnoremap ! mV/
vnoremap ! mV/
nnoremap g! `V
nnoremap q! q/
nnoremap / !
vnoremap / !

command! -bar UnderlineCurrentSearchItem silent call matchadd('ErrorMsg', '\c\%#'.@/, 101)
command! -bar Noh noh | silent call clearmatches()
augroup my_search
	au!
	autocmd CursorMoved * if (strcharpart(getline('.')[col('.') - 1:], 0, len(@/)) == @/) | UnderlineCurrentSearchItem | endif
augroup end

nnoremap z! m`:BLines<CR>
nnoremap <silent> * :let w=escape(expand('<cword>'), '\*[]~')\|call histadd('search', w)\|let @/=w\|set hls\|UnderlineCurrentSearchItem<CR>
vnoremap <silent> * "vy:let w=escape(@v, '\*[]~')\|call histadd('search', w)\|let @/=w\|set hls\|UnderlineCurrentSearchItem<CR>

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
	autocmd BufEnter * nnoremap	 <buffer> [( /\w\+\s*(\ze\s*<home>
	autocmd BufEnter * nnoremap	 <buffer> ]( /\w\+\s*(\s*\zs
	autocmd BufEnter * nnoremap	 <buffer> [s /\w\+\s*[\ze\s*<home>
	autocmd BufEnter * nnoremap	 <buffer> ]d /\w\+\s*[\s*\zs
	autocmd BufEnter * nnoremap	 <buffer> [q /\w\+\s*{\ze\s*<home>
	autocmd BufEnter * nnoremap	 <buffer> ]f /\w\+\s*{\s*\zs
	autocmd BufEnter * nnoremap	 <buffer> [< /\w\+\s*<\ze\s*<home>
	autocmd BufEnter * nnoremap	 <buffer> ]< /\w\+\s*<\s*\zs
	autocmd BufEnter * nnoremap	 <buffer> [= /\w\+\s*=\ze\s*<home>
	autocmd BufEnter * nnoremap	 <buffer> ]= /\w\+\s*=\s*\zs
	autocmd BufEnter * nnoremap	 <buffer> [: /\w\+\s*:\ze\s*<home>
	autocmd BufEnter * nnoremap	 <buffer> ]: /\w\+\s*:\s*\zs
	autocmd BufEnter * nnoremap	 <buffer> [, /\w\+\s*,\ze\s*<home>
	autocmd BufEnter * nnoremap	 <buffer> ], /\w\+\s*,\s*\zs
	autocmd BufEnter * nnoremap	 <buffer> [& /\w\+\s*&\ze\s*<home>
	autocmd BufEnter * nnoremap	 <buffer> ]& /\w\+\s*&\s*\zs
	autocmd BufEnter * nnoremap	 <buffer> [\| /\w\+\s*\|\ze\s*<home>
	autocmd BufEnter * nnoremap	 <buffer> ]\| /\w\+\s*\|\s*\zs
	autocmd BufEnter * nnoremap <silent> <buffer> [" /\(\s\|\[\|\(\|"\|`\)(\$\|@\|\s\)*"\zs\(\s\)*\w\+.*\ze"<CR>
	autocmd BufEnter * nnoremap <silent> <buffer> [' /\(\s\|\[\|\(\|"\|'\)(\s\|\[\|(\|"\|`\)'\zs\(\s\)*\w\+.*\ze'<CR>
	autocmd BufEnter * nnoremap <silent> <buffer> [` /\(\s\|\[\|\(\|"\|'\)`\zs\s*\w\+.*\ze`<CR>
augroup end

" Sort: -------------------------------{{{
function! SortLinesByLength() range
	let range = a:firstline.','.a:lastline
	silent exec range 's/.*/\=printf("%03d", len(submatch(0)))."|".submatch(0)/'
	exec range 'sort n'
	silent exec range 's/..../'
	nohlsearch
endfunction
command! -range=% SortByLength <line1>,<line2>call SortLinesByLength()

function! SortLinesByLengthBeforeFirstSpaceChar() range
	let range = a:firstline.','.a:lastline
	silent exec range 's/.*/\=printf("%03d", match(submatch(0), "\\s"))."|".submatch(0)/'
	exec range 'sort n'
	silent exec range 's/..../'
	nohlsearch
endfunction
command! -range=% SortByLengthBeforeFirstSpaceChar <line1>,<line2>call SortLinesByLengthBeforeFirstSpaceChar()

" Autocompletion (Insert Mode): -------{{{
inoremap <C-F> <C-R>=expand("%:t:r")<CR>

let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsSnippetDirectories = [ 'UltiSnips', 'specificSnippets' ]
if index(split(&runtimepath, ','), g:rc.vimFiles) < 0
	" access to pythonx folder
	let &runtimepath.= printf(','.g:rc.vimFiles)
	exec 'python3' printf("import sys;\r\nif('%s' not in sys.path): sys.path.append('%s')", g:rc.vimFiles, g:rc.vimFiles)
endif

set updatetime=500
set complete=.,w
set completeopt+=menuone,noselect,noinsert
" when typing too fast, typically after a dot, omnifunc sometimes needs to be reset. This prevents that from happening
inoremap . <C-G>u.
" omnifunc is c# is slow to compute all the possibilities after these characters
inoremap < <C-G>u<
inoremap ( <C-G>u(

function! AutocompletionFallback(timer_id)
	if pumvisible() || mode() != "i"
		return
	endif
	call feedkeys("\<C-N>")
endfunc

function! AsyncAutocomplete()
	if pumvisible() | return | endif
	if PreviousCharacter() =~ '\w\|\.'
		call feedkeys(&omnifunc!='' ? "\<C-X>\<C-O>" : "\<C-N>", 't')
		call timer_start(float2nr(g:OmniSharp_timeout*1000), function('AutocompletionFallback'))
	endif
endfunction
command! AsyncAutocomplete call AsyncAutocomplete()

augroup autocompletion
	au!
	"autocmd CursorHoldI * AsyncAutocomplete
	autocmd User UltiSnipsEnterFirstSnippet normal! m'
	autocmd BufEnter *.md set shellslash "file autocompletion on Windows for D2 icons
	autocmd BufLeave *.md set noshellslash
augroup end

let g:UltiSnipsExpandTrigger = "<F13>"
let g:UltiSnipsJumpForwardTrigger="<F13>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="horizontal"

function! RevertOmnisharpTimeoutValue(value, timer_id)
	let g:OmniSharp_timeout = a:value
endfunc

function! ManualOmniCompletion()
	let originalOmnisharpTimeout = g:OmniSharp_timeout
	let g:OmniSharp_timeout = 1
	call timer_start(1000, function('RevertOmnisharpTimeoutValue', [originalOmnisharpTimeout]))
endfunction
command! ManualOmniCompletion call ManualOmniCompletion()

inoremap <C-I> <C-R>=ExpandSnippetOrValidateAutocompletionSelection()<CR>
xnoremap <C-I> :call UltiSnips#SaveLastVisualSelection()<cr>gvs
snoremap <C-I> <esc>:call UltiSnips#ExpandSnippetOrJump()<CR>
snoremap <C-O> <esc>:call UltiSnips#JumpBackwards()<CR>
nnoremap <Leader>u :UltiSnipsEdit!<CR>G
nnoremap <Leader>U :call UltiSnips#RefreshSnippets()<CR>
inoremap <C-O> x<BS><C-O>:ManualOmniCompletion<CR><C-X><C-O>


function! ExpandSnippetOrValidateAutocompletionSelection()
	if col('.') == 1
		return "\<C-I>"
	endif
	if !pumvisible()
		let g:ulti_expand_or_jump_res = 0
		call UltiSnips#ExpandSnippetOrJump()
		return g:ulti_expand_or_jump_res > 0 ? '' : PreviousCharacter() =~ '\S' ? "\<C-N>" : "\<C-I>"
	else
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

" Diff: -------------------------------{{{
set diffopt+=algorithm:histogram,indent-heuristic,vertical,iwhite

augroup diff
	au!
	autocmd OptionSet diff let &cursorline=!v:option_new
	autocmd OptionSet diff silent! 1 | silent! normal! ]c
augroup end

function! SaveAsDiffFile()
	let incompleteFilename = BuildDiffFilenameWithoutExtension()
	let ext = empty(&ft) ? '' : printf('.%s', &ft)
	let filename = PromptUserForFilenameWithSuggestion(incompleteFilename, { n -> printf('%s/%s%s', g:rc.diffs, n, ext) })
	if empty(trim(filename)) | return | endif
	let @d = filename
	let filepath = printf('%s/%s%s', g:rc.diffs, filename, ext)
	set bt=
	echomsg 'Saving as' filepath
	exec 'saveas' filepath
endfunction
command! Diff call SaveAsDiffFile()

function! BuildDiffFilenameWithoutExtension(...)
	let title = a:0 ? a:1 : ''
	let date = StrftimeFR('%Y-%m-%d-%A')[:len('YYYY-MM-DD-ddd')-1]
	let index = float2nr(str2float(string(len(expand(g:rc.diffs.'/*', v:true, v:true)))) / 2)
	let index +=1
	if empty(title)
		return printf('%s %03d', date, index)
	else
		return printf('%s %03d %s', date, index, title)
	endif
endfunction


" QuickFix, Preview, Location window: -{{{
nnoremap <C-H> :cpfile<CR>
nnoremap <C-L> :cnfile<CR>

let g:ale_set_loclist = 0
augroup ale
	au!
	autocmd FileType ale-preview set wrap
augroup end

let g:qfpreview = {
	\'top': "\<Home>",
	\'bottom': "\<End>",
	\'scrolldown': '',
	\'scrollup': '',
	\'halfpagedown': "d",
	\'halfpageup': "u",
	\'next': "\<C-j>",
	\'previous': "\<C-k>",
	\'reset': "\<space>",
	\'height': 30,
	\'offset': 10,
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
	autocmd FileType qf nnoremap <buffer> <silent> t :TSplitQfItemAfter<CR>
	autocmd FileType qf	nmap <buffer> <silent> i :EditQfItemInPreviousWindow<CR>
	autocmd FileType qf	nmap <buffer> p <plug>(qf-preview-open)
	autocmd FileType qf if IsQuickFixWindow() | nnoremap <buffer> <CR> <CR>:Reframe<CR>| endif
	autocmd FileType qf nnoremap <silent> <buffer> H :QfOlder<CR>
	autocmd FileType qf nnoremap <silent> <buffer> L :QfNewer<CR>
	autocmd FileType qf call SetParticularQuickFixBehaviour()
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
	"elseif qftitle =~ '\[grep\]'
	"	exec printf('Cfilter /\<%s\>/', @/)
	"	exec printf('/\<%s\>', @/)
	"	let sep = stridx(qftitle, ' ')
	"	let w:quickfix_title = printf('%s<%s>', qftitle[:sep], qftitle[sep+1:])
	else
		call feedkeys(':Cfilter')
	endif
endfunction

function! SetParticularQuickFixBehaviour()
	if empty(get(w:, 'quickfix_title'))
		return
	endif
	nnoremap <buffer> <silent> dd :let v1=GetFileVersionID('.') \| let v2=GetFileVersionID(line('.')+1) \| exec 'Gtabedit' v1 \| exec 'Gdiffsplit!' v2<CR>
	vnoremap <buffer> <silent> dd :<C-U>let v1=GetFileVersionID("'<") \| let v2=GetFileVersionID("'>") \| exec 'Gtabedit' v1 \| exec 'Gdiffsplit!' v2<CR>
	nnoremap <buffer> <silent> D  :let v=GetFileVersionID('.') \| let bufnr=winbufnr(winnr('#')) \| exec 'tab sbuffer' bufnr \| exec 'Gdiffsplit!' v<CR>
	nnoremap <buffer> <silent> c  :exec 'Gtabedit' GetSha()<CR>
	nnoremap <buffer> <silent> C  :call DisplayCommitFilesDiffs('fromFileHistoryBuffer')<CR>
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

if has('vim9script')
	def g:QuickFixTextFunc(info: dict<number>): list<string>
		var qfl = info.quickfix ? getqflist({'id': info.id, 'items': 0}).items : getloclist(info.winid, {'id': info.id, 'items': 0}).items
		var modules_are_used = empty(qfl) ? 1 : (get(qfl[0], 'module', '') != '')
		var l = []
		var efm_type = {'e': 'error', 'w': 'warning', 'i': 'info', 'n': 'note'}
		var lnum_width =	 len(max(map(range(info.start_idx - 1, info.end_idx - 1), (_, v) => qfl[v].lnum )))
		var col_width =	 len(max(map(range(info.start_idx - 1, info.end_idx - 1), (_, v) => qfl[v].col)))
		var fname_width =  max(map(range(info.start_idx - 1, info.end_idx - 1), modules_are_used ? (_, v) => strchars(qfl[v].module, 1) : (_, v) => strchars(substitute(fnamemodify(bufname(qfl[v].bufnr), ':.'), '\\', '/', 'g'), 1)))
		var type_width =	 max(map(range(info.start_idx - 1, info.end_idx - 1), (_, v) => strlen(get(efm_type, qfl[v].type, ''))))
		var errnum_width = len(max(map(range(info.start_idx - 1, info.end_idx - 1), (_, v) => qfl[v].nr)))
		for idx in range(info.start_idx - 1, info.end_idx - 1)
			var e = qfl[idx]
			e.text = substitute(e.text, '\%x00', ' ', 'g')
			if stridx(e.text, ' Expected: ') >= 0
				e.text = substitute(e.text, ' Actual:	', '   Actual: ', '')
			endif
			if !e.valid
				add(l, '|| ' .. e.text)
			else
				var fname = printf('%-*S', fname_width, modules_are_used ? e.module : substitute(fnamemodify(bufname(e.bufnr), ':.'), '\\', '/', 'g'))
				if e.lnum == 0 && e.col == 0
					add(l, printf('%s|| %s', fname, e.text))
				else
					var lnum = printf('%*d', lnum_width, e.lnum)
					var col = printf('%*d', col_width, e.col)
					var type = printf('%-*S', type_width, get(efm_type, e.type, ''))
					var errnum = ''
					if !!e.nr
						errnum = printf('%*d', errnum_width + 1, e.nr)
					endif
					add(l, printf('%s|%s col %s %s%s| %s', fname, lnum, col, type, errnum, e.text))
				endif
			endif
		endfor
		return l
	enddef
	set quickfixtextfunc=g:QuickFixTextFunc
else
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
		let lnum_width =	 len(max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), { _,v -> qfl[v].lnum })))
		let col_width =	 len(max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), {_, v -> qfl[v].col})))
		let fname_width =  max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), modules_are_used ? {_, v -> strchars(qfl[v].module, 1)} : {_, v -> strchars(substitute(fnamemodify(bufname(qfl[v].bufnr), ':.'), '\\', '/', 'g'), 1)}))
		let type_width =	 max(map(range(a:info.start_idx - 1, a:info.end_idx - 1), {_, v -> strlen(get(efm_type, qfl[v].type, ''))}))
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
endif

" Marks:-------------------------------{{{
" H and L are used for cycling between buffers and `A is a pain to type
nnoremap M `

function! JumpToPrevious()
	let jumplist=getjumplist(winnr())
	if jumplist[1] < len(jumplist[0])
		exec "normal! \<C-O>"
	else
		if line('.') == jumplist[0][-1].lnum
			if col('.') != jumplist[0][-1].col
				exec "normal! ".jumplist[0][-1].col."|"
			else
			exec "normal! 2\<C-O>"
			endif
		else
			exec "normal! m'2\<C-O>"
		endif
	endif
endfunction
command! JumpToPrevious call JumpToPrevious()
nnoremap <silent> <C-O> :JumpToPrevious<CR>

let g:lastCursorHoldTime = reltimefloat(reltime())

function! MarkCurrentPosition()
	let now = reltimefloat(reltime())
	let jumplist = getjumplist(winnr())
	if empty(jumplist[0])
		normal! m'
		let g:lastCursorHoldTime = now
		return
	endif
	let lockInSeconds = 0.75
	if now - g:lastCursorHoldTime > lockInSeconds
		if jumplist[1] == len(jumplist[0]) && line('.') != jumplist[0][-1].lnum 
			normal! m'
			let g:lastCursorHoldTime = now
		endif
	endif
endfunction

augroup marks
	au!
	"autocmd CursorHold * call MarkCurrentPosition()
augroup end

" Changelist:--------------------------{{{
nnoremap g; g;zv
nnoremap g, g,zv

" Additional Functionalities:----------{{{
" Buffer navigation:-------------------{{{
nnoremap <silent> H :CycleBackwards<CR>
nnoremap <silent> L :CycleForward<CR>

" Fuzzy Finder:------------------------{{{
" Makes Omnishahrp-vim code actions select both two elements
"let g:fzf_layout = { 'window': { 'width': 0.39, 'height': 0.25 } }
"let g:fzf_preview_window = []
let $FZF_DEFAULT_OPTS='--bind up:preview-up,down:preview-down,ctrl-j:backward-char,ctrl-k:forward-char'

augroup my_fzf
	au!
	autocmd FileType fzf setlocal termwinsize=
	autocmd FileType fzf setlocal termwintype=conpty
	autocmd FileType fzf tnoremap <buffer> <C-N> <C-N>
	autocmd FileType fzf tnoremap <buffer> <C-P> <C-P>
	autocmd FileType fzf tnoremap <buffer> <C-U> <C-U>
	autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
	autocmd FileType fzf tnoremap <buffer> <C-R> <C-W>:call feedkeys(@)<left>
	autocmd FileType fzf tnoremap <silent> <buffer> <C-V> <C-W>:call feedkeys(@+)<CR>
	autocmd FileType fzf tnoremap <buffer> <C-J> <C-J>
	autocmd FileType fzf tnoremap <buffer> <C-K> <C-K>
	autocmd FileType fzf tnoremap <buffer> <C-O> <C-T>
augroup end

nnoremap <Leader>g :GFiles?<CR>
nnoremap <leader>G :BCommits<CR>
nnoremap q, :History<CR>
nnoremap q; :Buffers<CR>

" Window buffer navigation:------------{{{
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

" Full screen & Opacity: --------------{{{
if has('win32') && has('gui_running')
	let g:gvimtweak#window_alpha=255 " alpha value (180 ~ 255) default: 245
	let g:gvimtweak#enable_alpha_at_startup=1
	let g:gvimtweak#enable_topmost_at_startup=0
	let g:gvimtweak#enable_maximize_at_startup=1
	let g:gvimtweak#enable_fullscreen_at_startup=1
	nnoremap <silent> <S-°> :GvimTweakToggleFullScreen<CR>|tnoremap <S-°> <C-W>N:GvimTweakToggleFullScreen<CR>i
	nnoremap <silent> <A-n> :GvimTweakToggleTransparency<CR>|tnoremap <A-n> <C-W>N:GvimTweakToggleTransparency<CR>i
	inoremap <silent> <A-n> <C-O>:GvimTweakToggleTransparency<CR>
	nnoremap <silent> <A-i> :GvimTweakSetAlpha -10<CR>| tnoremap <silent> <A-i> <C-W>N:GvimTweakSetAlpha -10<CR>i
	nnoremap <silent> <A-o> :GvimTweakSetAlpha 10<CR>| tnoremap <silent> <A-o> <C-W>N:GvimTweakSetAlpha 10<CR>i
endif
" File explorer (graphical): ----------{{{
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
		let cmd = printf('cmd /C %s %s "%s" "%s"', g:rc.gtools.'/cp', isdirectory(item)?'-r':'', item, item_finalname)
		let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': cwd,
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
	if target =~ '\.cs'
		call OmniSharpDeleteFile(target)
	endif
	if has('win32')
		let cmd = printf('cmd /C %s "%s"', g:rc.gtools.'/rm -r', target)
		let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/Job')
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
	let bufnr = bufnr(filename)
	if bufnr >= 0 | silent! exec bufnr.'bdelete!' | endif
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
		let bufnr = bufnr(item)
		let cmd = printf('cmd /C %s "%s" "%s"', g:rc.gtools.'/mv', item, item_finalname)
		let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': cwd,
				\'err_cb':   { chan,msg  -> execute("echomsg '".substitute(msg,"'","''","g")."'",  1) },
				\'exit_cb':  function('RefreshBufferAndMoveToPathAndCleanMovedBuffer', [bufnr, item_finalname])
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
	let cwd = getcwd()
	let target = trim(getline('.'), '/\')
	let filename = fnamemodify(target, ':t')
	let bufnr = bufnr(filename)
	let newname = input('Rename into:', filename)
	if has('win32')
		if filename =~ '\.cs'
			call OmniSharpReloadProject()
		endif
		let cmd = printf('cmd /C %s "%s" "%s"', g:rc.gtools.'/mv', filename, newname)
		let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': cwd,
				\'err_cb':   { chan,msg  -> execute("echomsg '".substitute(msg,"'","''","g")."'",  1) },
				\'exit_cb':  function('RefreshBufferAndMoveToPathAndCleanMovedBuffer', [bufnr, newname])
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

function! GetNextLineAsPath()
	return trim(getline(line('.')+1), '\')
endfunc

function! GetPreviousLineAsPath()
	return trim(getline(line('.')-1), '\')
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
	let cwd = getcwd()
	if has('win32')
		let cmd = printf('cmd /C %s %s', g:rc.gtools.'/mkdir', shellescape(dirname))
		let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/Job')
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': cwd,
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
	if empty(a:path) | return | endif
	let search = escape(getcwd(), '\').'\\'.a:path.(isdirectory(a:path) ? '\\$' : '$')
	silent! exec '/'.search
	let @/=search
endfunction

function! RefreshBufferAndMoveToPathAndCleanMovedBuffer(bufnr, path, ...)
	call RefreshBufferAndMoveToPath(a:path, a:000)
	if a:bufnr >= 0 | silent! exec a:bufnr.'bdelete!' | endif
	if a:path =~ '\.cs'
		call OmniSharpReloadProject()
	endif
endfunction

function! CreateFile()
	let filename = PromptUserForFilename('File name:')
	if trim(filename) == ''
		return
	endif
	let cwd = getcwd()
	if has('win32')
		let cmd = printf('cmd /C %s %s', g:rc.gtools.'/touch', shellescape(filename))
		let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/Job')
		echomsg cmd
		let s:job = job_start(
			\cmd,
			\{
				\'cwd': cwd,
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

function! PreviewFile(splitcmd)
	let path=trim(getline('.'))
	let bufnr=bufnr()
	let is_wip_buffer = get(b:, 'is_wip_buffer', 0)
	let previewwinid = getbufvar(bufnr, 'preview'.a:splitcmd, 0)
	if previewwinid == 0
		exec a:splitcmd path
		call setbufvar(bufnr, 'preview'.substitute(a:splitcmd, ' ', '', 'g'), win_getid())
		if is_wip_buffer | let b:is_wip_buffer = 1 | endif
	else
		call win_gotoid(previewwinid)
		if win_getid() == previewwinid
			silent exec 'edit' path
		else
			exec a:splitcmd path
			call setbufvar(bufnr, 'preview'.substitute(a:splitcmd, ' ', '', 'g'), win_getid())
		endif
	endif
		exec 'wincmd' (a:splitcmd == 'vsplit' ? 'h' : 'k')
endfunction

augroup my_dirvish
	au!
	autocmd BufEnter if &ft == 'dirvish' | let b:previewvsplit = 0 | let b:previewsplit = 0 | endif
	autocmd BufLeave if &ft == 'dirvish' | normal! mL | endif
	autocmd BufEnter if &ft == 'dirvish' | silent normal R
	autocmd FileType dirvish silent! nunmap <silent> <buffer> q
	autocmd FileType dirvish nnoremap <silent> <buffer> q: q:
	autocmd FileType dirvish nnoremap <silent> <buffer> gh :silent keeppatterns g@\v\\\.[^\\]+\\?$@d _<cr>:setl cole=3<cr>
	if g:isWindows
	autocmd FileType dirvish nnoremap <silent> <buffer> f :term ++curwin ++noclose powershell -NoLogo<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> F :term ++noclose powershell -NoLogo<CR>
elseif g:isWsl
	autocmd FileType =dirvish nnoremap <silent> <buffer> f :term ++curwin ++noclose<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> F :term ++noclose<CR>
endif
	autocmd FileType dirvish nnoremap <silent> <buffer> <C-B> :echo gitbranch#name()<CR>
	autocmd FileType dirvish unmap <buffer> o
	autocmd FileType dirvish nnoremap <silent> <buffer> o :call PreviewFile('vsplit')<CR>
	autocmd FileType dirvish unmap <buffer> a
	autocmd FileType dirvish nnoremap <silent> <buffer> a :call PreviewFile('split')<CR>
	autocmd FileType dirvish nnoremap <silent> <buffer> t :call PreviewFile('tab split')<CR>
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
	autocmd FileType dirvish nmap <silent> <buffer> <leader>w :exec 'WebBrowser' GetCurrentLineAsPath()<CR>
	autocmd FileType dirvish nnoremap <buffer> <silent> <LocalLeader>m :Build<CR>
	autocmd FileType dirvish nnoremap <buffer> <LocalLeader>R :call OmniSharp#RestartServer()<CR>
	autocmd FileType dirvish command! -buffer -bar -nargs=? -complete=file OmniSharpStartServer call OmniSharp#StartServer(<q-args>)
	autocmd FileType dirvish nnoremap <buffer> <LocalLeader>O :OmniSharpStartServer 
	autocmd FileType dirvish unmap <buffer> .
	autocmd FileType dirvish nnoremap <buffer> . :Shdo  {}<Left><Left><Left>
	autocmd FileType dirvish vnoremap <buffer> . :Shdo  {}<Left><Left><Left>
	autocmd FileType dirvish nnoremap <buffer> X :Shdo!  {}<Left><Left><Left>
	autocmd FileType dirvish nnoremap <buffer> e :ter ++hidden explorer.exe /select,<C-R>=GetCurrentLinePath()<CR><CR>
augroup end

function! GoToGitRoot()
	let gitroot = fnamemodify(gitbranch#dir(expand('%:p')), ':h')
	exec 'Dirvish' gitroot
	exec 'lcd' gitroot
endfunction

" Web Browsing: -----------------------{{{
function! BuildFirefoxUrl(path)
	let url = a:path
	let nbDoubleQuotes = len(substitute(url, '[^"]', '', 'g'))
	if nbDoubleQuotes > 0 && nbDoubleQuotes % 2 != 0 | let url.= ' "' | endif
	let url = trim(url)
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

function! BuildViebUrl(path)
	let url = a:path
	let nbDoubleQuotes = len(substitute(url, '[^"]', '', 'g'))
	if nbDoubleQuotes > 0 && nbDoubleQuotes % 2 != 0 | let url.= ' "' | endif
	let url = trim(url)
	if url =~ '\.md$'
		let url = 'markdownviewer:/'.url
	endif
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

function! WebBrowser(...)
	let browser = g:rc.env.browser
	let rawUrl = (a:0 == 0 || (a:0 == 1 && a:1 == '')) ? GetCurrentSelection() : join(a:000)
	let url = browser == 'vieb.exe' ? BuildViewUrl(rawUrl) : BuildFirefoxUrl(rawUrl)
	let cmd = printf('%s "%s"', browser, url)
	let s:job= job_start(cmd, {'cwd': g:rc.notes})
endfun
command! -nargs=* -range WebBrowser :call WebBrowser(<q-args>)
nnoremap <Leader>w :w!<CR>:WebBrowser <C-R>=substitute(expand('%:p'), '/', '\\', 'g')<CR><CR>
vnoremap <Leader>w :WebBrowser<CR>
command! -nargs=* -range WordreferenceFrEn :call WebBrowser('https://www.wordreference.com/fren/', <f-args>)
command! -nargs=* -range GoogleTranslateFrEn :call WebBrowser('https://translate.google.com/?hl=fr#view=home&op=translate&sl=fr&tl=en&text=', <f-args>)
nnoremap <Leader>t :WordreferenceFrEn 
vnoremap <Leader>t :GoogleTranslateFrEn<CR>
command! -nargs=* -range WordreferenceEnFr :call WebBrowser('https://www.wordreference.com/enfr/', <f-args>)
command! -nargs=* -range GoogleTranslateEnFr :call WebBrowser('https://translate.google.com/?hl=fr#view=home&op=translate&sl=en&tl=fr&text=', <f-args>)
nnoremap <Leader>T :WordreferenceEnFr 
vnoremap <Leader>T :GoogleTranslateEnFr<CR>


" Board & Work-in-progress
function! AreWipBuffersOpenInCurrentTab()
	return len(filter(range(1, winnr('$')), {_,x -> getbufvar(winbufnr(x), 'is_wip_buffer') == 1}))
endfunction

function! HideWipBuffers()
	let wipBuffers = filter(map(range(1, winnr('$')), {_,x -> winbufnr(x)}), {_,x -> getbufvar(x, 'is_wip_buffer') == 1})
	for bufnr in wipBuffers | exec 'bd' bufnr | endfor
	let adosUrlMenuBuffers = filter(map(range(1, winnr('$')), {_,x -> winbufnr(x)}), {_,x -> !empty(getbufvar(x, 'urlBuilders', []))})
	for bufnr in adosUrlMenuBuffers | exec 'bd' bufnr | endfor
endfunction

function! DisplayWipBuffers()
	silent exec 'tabedit +let\ b:is_wip_buffer=1' printf('%s/think.md', g:rc.notes)
	silent botright exec 'split +let\ b:is_wip_buffer=1' g:rc.wip
	silent exec 'resize' (0.5 * &lines)
	silent! keeppatterns g@\v\\\.[^\/]+\\?$@d _
	let t = timer_start(10, {_ -> execute('setl conceallevel=3')})
	silent nunmap <buffer> x
	silent nnoremap <silent> <buffer> x :call SetCurrentAdosWorkItemIdFromWip()<CR>
	silent exec '9split +let\ b:is_wip_buffer=1' printf('%s/.pending', g:rc.wip)
	silent exec float2nr(0.6 * &columns).'vsplit +let\ b:is_wip_buffer=1' printf('%s/.priority', g:rc.wip)
	2wincmd w
endfunction

function! SetCurrentAdosWorkItemIdFromWip()
	let workItem = fnamemodify(getline('.'), ':t:r')
	if workItem =~ '^\.'
		let workItem = workItem[1:]
	endif
	let workItemId = str2nr(workItem)
	if workItemId == get(g:, 'previousWorkItemId', -1)
		echomsg 'Current Ados item is already' workItem
		return
	endif
	let g:previousWorkItemId = workItemId
	echomsg 'Current Ados item set to' workItem
endfunction

function! ToggleWorkInProgress()
	if AreWipBuffersOpenInCurrentTab()
		call HideWipBuffers()
	else
		call DisplayWipBuffers()
	endif
endfunction
command! Wip call ToggleWorkInProgress()
nnoremap <leader>b :call ToggleWorkInProgress()<CR>

nnoremap <leader>B :exec 'WebBrowser' g:rc.env.adosBoard<CR>

function! BuildWipFileForWorkItem(workItemId)
	"echomsg 'workItemId' a:workItemId
	let filenameParts = js_decode(substitute(system(printf('curl -sLk -X GET -u:%s %s/%s/_apis/wit/workitems/%d?api-version=6.0 | jq -r "{id, title: .fields[\"System.Title\"], assignedTo: .fields[\"System.AssignedTo\"].displayName}"', g:rc.env.pat, g:rc.env.ados, g:rc.env.adosProject, a:workItemId)), '[\x0]', '', 'g'))
	if !empty(glob(g:rc.env.wip.'/'.filenameParts.id.'*.md'))
		echomsg 'There is already a file for workitem' a:workItemId
		return
	endif
	let workItem = printf('%d %s (%s).md', filenameParts.id, filenameParts.title, filenameParts.assignedTo)
	let filename = substitute(workItem, ':', ';', 'g')
	let filename = substitute(filename, '\', ';', 'g')
	let filename = substitute(filename, '/', ';', 'g')
	let filename = substitute(filename, '*', ';', 'g')
	let filename = substitute(filename, '?', ';', 'g')
	let filename = substitute(filename, '"', ';', 'g')
	let filename = substitute(filename, '<', 'lt;', 'g')
	let filename = substitute(filename, '>', 'gt;', 'g')
	let filename = substitute(filename, '|', ';', 'g')
	"Vieb limitation: https://github.com/Jelmerro/Vieb/issues/414
	let filepath = g:rc.env.wip.'/'.RemoveDiacritics(filename)
	let filecontent = [printf('# [%s](https://younitedcredit.visualstudio.com/Evaluation/_workitems/edit/%d)', filename, a:workItemId)]
	call add(filecontent, '')
	call add(filecontent, '## Make the implicits, explicit')
	call add(filecontent, '1. [ ] Stakeholders/Consumers are informed/equipped about the impacts of this implementation')
	call add(filecontent, '')
	call add(filecontent, '## Acceptance tests')
	call add(filecontent, '**Input fields**')
	call add(filecontent, '')
	call add(filecontent, '**Rules to test**')
	call add(filecontent, '')
	call add(filecontent, '**Test plan**')
	call add(filecontent, '')
	call add(filecontent, '**Resources readiness**')
	call add(filecontent, '')
	call add(filecontent, '## Codebase is ready')
	call add(filecontent, '1. [ ] Codebase has no warnings')
	call add(filecontent, '1. [ ] Naming is relevant')
	call add(filecontent, '1. [ ] Naming is consistent')
	call add(filecontent, '1. [ ] Layers are robust')
	call add(filecontent, '1. [ ] Files are well-organized')
	call add(filecontent, '')
	call add(filecontent, '## Listing of Red Integration Tests (pre-dev)')
	call add(filecontent, '')
	call add(filecontent, '| Test Name | Namespace | Reason why it''s red | Logs |')
	call add(filecontent, '| -- | -- | -- | -- |')
	call add(filecontent, '| | | | |')
	call add(filecontent, '')
	call add(filecontent, '## Codebase can be merged')
	call add(filecontent, '1. [ ] Codebase has no warnings')
	call add(filecontent, '1. [ ] Naming is relevant')
	call add(filecontent, '1. [ ] Naming is consistent')
	call add(filecontent, '1. [ ] Exposed contract is pristine')
	call add(filecontent, '1. [ ] Layers are robust')
	call add(filecontent, '1. [ ] Files are well-organized')
	call add(filecontent, '1. [ ] Resources & Permissions are created in every environment')
	call add(filecontent, '1. [ ] Integration tests run correctly locally')
	call add(filecontent, '1. [ ] Application receives input as expected')
	call add(filecontent, '1. [ ] Application handles errors as expected')
	call add(filecontent, '1. [ ] Client receives output/exceptions as expected')
	call add(filecontent, '')
	call add(filecontent, '## Listing of Red Integration Tests (post-dev)')
	call add(filecontent, '| Test Name | Namespace | Reason why it''s red | Logs |')
	call add(filecontent, '| -- | -- | -- | -- |')
	call add(filecontent, '| | | | |')
	call add(filecontent, '')
	call add(filecontent, '## Codebase is ready for test')
	call add(filecontent, '1. [ ] Integration tests run correctly in IC pipeline')
	call writefile(filecontent, filepath)
	echomsg 'File' "'".workItem."'" 'was successfully created.'
endfunction
command! -nargs=1 -complete=customlist,GetWorkItemsAssignedToMeInCurrentIteration Wip call BuildWipFileForWorkItem(str2nr(matchlist(<f-args>, '\d\{5,}')[0]))

" Dashboard: --------------------------{{{
cnoremap <C-B> <C-R>=gitbranch#name()<CR>

function! OpenDashboard()
	if IsInsideDashboard()
		return
	endif
	let cwd = getcwd()
	let alreadyExistingDashboard = !empty(filter(gettabinfo(), {_,x -> get(x.variables, 'is_dashboard_tabpage', 0)}))
	silent tab G
	RefreshGitLogBuffer
	if alreadyExistingDashboard | return | endif
	let t:is_dashboard_tabpage = 1
	normal gU
endfunction
command! -bar Dashboard call OpenDashboard()
nnoremap <silent> <Leader>m :Dashboard<CR>

function! RefreshGitLogBuffer()
	let originalWinId = win_getid()
	let logBuffers = map(filter(getbufinfo(), { _,x -> get(x.variables, 'fugitive_type', '') == 'temp'}), { _,x -> x.bufnr})
	if len(logBuffers) > 0
		for i in range(len(logBuffers))
			let bufnr = logBuffers[i]
			if index(tabpagebuflist(), bufnr) >= 0
				silent exec bufnr.'bwipeout'
				silent exec '$wincmd w'
			endif
		endfor
	endif
	silent Git log -20
	let logBuffers = map(filter(getbufinfo(), { _,x -> get(x.variables, 'fugitive_type', '') == 'temp'}), { _,x -> x.bufnr})
	let bufnr = logBuffers[0]
	set bt=nofile
	wincmd J
	resize 15
	nnoremap <buffer> <silent> t <Home>:Gtabedit <C-R><C-W><CR>:tabmove<CR>
	nnoremap <buffer> <silent> i <Home>:Gedit <C-R><C-W><CR>
	silent call win_gotoid(originalWinId)
endfunction
command! RefreshGitLogBuffer call RefreshGitLogBuffer()

function! GetCommitTypes(findstart, base)
	if a:findstart | return col('.') | endif

	if line('.') == 1 || col('.') == 1
		return [
			\{ 'word': '🏘 architecture',     'menu': 'Changes that affect the architectural layers                  (example scopes: persistence, logging, view-rendering, api-contract)'  } ,
			\{ 'word': '👷 build',            'menu': 'Changes that affect the build system                          (example scopes: msbuild, nswag)'                                      } ,
			\{ 'word': '🆗 ci|cd',            'menu': 'Changes to our CI configuration files, scripts or pipelines   (example scopes: azure-devops, github-actions)'                        } ,
			\{ 'word': '🧹 cleanup',          'menu': "Chores that do not affect the code's design                   (example scopes: code-warnings, filesystem, code-consistency)"         } ,
			\{ 'word': '👁️ comment',          'menu': 'Changes on comments'                                                                                                                 } ,
			\{ 'word': '🔧 config',           'menu': 'Changes on configuration files'                                                                                                      } ,
			\{ 'word': '🧩 contract-extend',  'menu': 'Changes that add elements to a contract'                                                                                             } ,
			\{ 'word': '🗃 data-structure',   'menu': 'Changes that add or modify a data structure'                                                                                         } ,
			\{ 'word': '🙅 deprecate',        'menu': 'Deprecating an element in the codebase                        (example scopes: exposed-method, payload-property)'                    } ,
			\{ 'word': '➕ deps-add',         'menu': 'Changes that add dependencies to the system                   (example scopes: mapping, fixture-generation, ioc)'                    } ,
			\{ 'word': '➖ deps-remove',      'menu': 'Changes that remove dependencies from the system              (example scopes: mapping, fixture-generation, ioc)'                    } ,
			\{ 'word': '⬆ deps-upgrade',      'menu': 'Changes that upgrade dependencies in the system               (example scopes: mapping, fixture-generation, ioc)'                    } ,
			\{ 'word': '⬇ deps-downgrade',    'menu': 'Changes that downgrade dependencies in the system             (example scopes: mapping, fixture-generation, ioc)'                    } ,
			\{ 'word': '📝 docs',             'menu': 'Documentation only'                                                                                                                  } ,
			\{ 'word': '🚀 feature',          'menu': 'One new green test with its attached production code'                                                                                } ,
			\{ 'word': '🐛 fix',              'menu': 'One new green test with its attached production code'                                                                                } ,
			\{ 'word': '🗡 kill-whole',       'menu': 'Killing something harmful in the whole codebase'                                                                                     } ,
			\{ 'word': '🗡 kill-partial',     'menu': 'Killing something harmful but not everywhere... Yet.'                                                                                } ,
			\{ 'word': '⛓ merge-files',      'menu': 'Changes that merge files'                                                                                                            } ,
			\{ 'word': '🎠 move-files',       'menu': 'Changes that move files'                                                                                                             } ,
			\{ 'word': '⚡️ perf',             'menu': 'Changes that improve performance'                                                                                                    } ,
			\{ 'word': '♻️ refactor',          'menu': 'Same behaviour, different design'                                                                                                    } ,
			\{ 'word': '🖋 renaming',         'menu': 'Different name, same responsability'                                                                                                 } ,
			\{ 'word': '🔙 revert',           'menu': 'Reverting some changes to a former version'                                                                                          } ,
			\{ 'word': '✂ split-files',       'menu': 'Changes that split files'                                                                                                            } ,
			\{ 'word': '💄 style',            'menu': 'Personal preferences in terms of how and where to write code'                                                                        } ,
			\{ 'word': '🧪 test-suite',       'menu': 'Adding missing tests or correcting existing tests             (example scopes: unit-tests, fearless-programming, integration-tests)' } ,
			\{ 'word': '🛡 test-framework',   'menu': 'Changes that affect existing and future tests                 (example scopes: unit-tests, fearless-programming, integration-tests)' } ,
			\{ 'word': '🔤 typo|wording',     'menu': 'Fixing typos/improving wording'                                                                                                      } ,
			\{ 'word': '🔖 versioning',       'menu': 'Changes that affect the product version                       (example scopes: api-version, client-version)'                         } ,
			\{ 'word': '🚧 work-in-progress', 'menu': 'Partial and possibly non-functional implementation'                                                                                  }
		\]
	elseif getline('.') =~ 'Motivation'
		return [
			\'keep code warnings exclusively as a tool for the dev-at-hand',
			\'le code mort au mieux pollue, au pire embrouille'
		\]
	endif

	return []
endfunc

function! OpenTabWithPullRequestDescription(...)
	let commitOrBranchName = ''
	if a:0
		let commitOrBranchName = a:1
	else
		let gitFlowDevBranches = filter(map(systemlist("git branch"), {_,x -> trim(x, '* ')}), 'v:val =~ "^develop.*"')
		if !empty(gitFlowDevBranches)
			let commitOrBranchName = 'origin/'.gitFlowDevBranches[0]
		else
			let commitOrBranchName = 'origin/'.trim(system("git remote show origin | sed -n '/HEAD branch/s/.*: //p'"))
		endif
	endif
	tabnew
	set ft=markdown
	call setline(1, BuildPullRequestDescription(commitOrBranchName))
endfunction
command! -nargs=? PullRequestDescription call OpenTabWithPullRequestDescription(<f-args>)

function! BuildPullRequestDescription(commitOrBranchName)
	let commitBodies = systemlist(printf('git log --format=++%%B %s..', a:commitOrBranchName))
	let commitBodies = filter(commitBodies, { _,x -> len(x) > 0})
	let commitsAsMarkdownTableRow = []
	let currentCommitAsRow = ''
	for i in range(len(commitBodies))
		let commitLine = commitBodies[i]
		let isNewCommit = stridx(commitLine, '++') == 0
		if isNewCommit
			if len(currentCommitAsRow) > 0 | call add(commitsAsMarkdownTableRow, FormatAsMarkdownTableRow(currentCommitAsRow)) | endif
			let currentCommitAsRow = commitLine
		else
			let currentCommitAsRow = currentCommitAsRow . ' èé ' . commitLine
		endif
	endfor
	call add(commitsAsMarkdownTableRow, FormatAsMarkdownTableRow(currentCommitAsRow))
	let descriptionLines = []
	let descriptionLines += ["## 🔨 Requested behavior's implementation"]
	let behaviorCommitsAsMarkdownTableRows = reverse(filter(copy(commitsAsMarkdownTableRow), {_,x -> x.type == 'behavior'}))
	if(empty(behaviorCommitsAsMarkdownTableRows))
		call extend(descriptionLines, [ "_Nothing._", "" ])
	else
		call extend(descriptionLines, [ "| Scope | Behavior | Notes |", "|-|-|-|" ])
		call extend(descriptionLines, empty(behaviorCommitsAsMarkdownTableRows) ? ['-'] : map(behaviorCommitsAsMarkdownTableRows, 'v:val.content'))
		call extend(descriptionLines, [ "", "## 🚦 Regression test suite", "| Scope | Behavior | Notes |", "|-|-|-|", "" ])
	endif
	call add(descriptionLines, "## ⚜ Clean Code's [Boy Scout Rule](https://www.oreilly.com/library/view/97-things-every/9780596809515/ch08.html)")
	let structureCommitsAsMarkdownTableRows = reverse(filter(copy(commitsAsMarkdownTableRow), {_,x -> x.type == 'structure'}))
	if(empty(structureCommitsAsMarkdownTableRows))
		call extend(descriptionLines, [ "_Nothing._", ""])
	else
		call extend(descriptionLines, [ "", "> If you find a mess on the ground, you clean it up regardless of who might have made it. You intentionally improve the environment for the next group of campers.", "" ])
		call extend(descriptionLines, [ "| Scope | (subjective) improvement type | Description |	Notes |", "|-|-|-|-|" ])
		call extend(descriptionLines, map(structureCommitsAsMarkdownTableRows, 'v:val.content'))
	endif
	return descriptionLines
endfunction

function! FormatAsMarkdownTableRow(commitBodyWithMarks)
	let startMark = '++'
	let newlineMark = ' èé '
	let commitBody = a:commitBodyWithMarks[len(startMark):]
	let subject = trim(commitBody[:stridx(commitBody, newlineMark)])
	let isWellStructured = (subject =~ '^. [a-zA-Z\-_|]\+ *([a-zA-Z\-_0-9]\+): *.*$')
	if !isWellStructured | return { 'type': 'behavior', 'content': printf('| %s | %s | %s |', '-', escape(subject, '|'), '-') } | endif
	let commitScope = escape(matchlist(subject, '(\zs.\{-1,}\ze)')[0], '|')
	let commitType = escape(subject[:match(subject, ' *(')], '|')
	let commitDescription = escape(subject[match(subject, '): ') + len('): '):], '|')
	let commitNotes = stridx(commitBody, newlineMark) >= 0
		\? escape(trim(join(mapnew(split(commitBody[stridx(commitBody, newlineMark) + len(newlineMark):], newlineMark), { _,x -> '▪ '. ((stridx(x, ': ') >=0) ? ('**'.x[:stridx(x, ': ')-1].'**'.x[stridx(x, ': '):]) : x) }), '<br/>'), newlineMark), '|')
		\: '-'
	if stridx(commitType, '🚀') >=0 || stridx(commitType, '🐛') >=0 || stridx(commitType, '🧩') >=0
		return { 'type': 'behavior', 'content': printf('| %s | %s | %s |', commitScope, substitute(commitDescription, 'should', 'will', ''), commitNotes) }
	else
		return { 'type': 'structure', 'content': printf('| %s | %s | %s | %s |', commitScope, commitType, commitDescription, commitNotes) }
	endif
endfunc

function! DisplayCommitFilesDiffs(from)
	if (a:from == 'fromFileHistoryBuffer') "git commit
		let currentLine = GetCurrentLineAsPath()
		let currentCommitHash = currentLine[:stridx(currentLine, ':')-1]
	else
		let isGitLogBuffer = bufname() =~ '\.tmp$'
		if (isGitLogBuffer)
			let currentLine = GetCurrentLineAsPath()
			let currentCommitHash = currentLine[:stridx(currentLine, ' ')-1]
		else
			let currentCommitHash = fnameescape(fugitive#Object(@%))
		endif
	endif
	$tabmove
	let difftoolCommand = printf('Git difftool -y %s^ %s', currentCommitHash, currentCommitHash)
	call execute(difftoolCommand)
endfunction

augroup dashboard
	au!
	autocmd FileType fugitive,git nnoremap <buffer> <silent> <LocalLeader>m :Git push --force-with-lease<CR>
	autocmd FileType fugitive,git nnoremap <buffer> <silent> R :RefreshGitLogBuffer<CR>
	autocmd FileType fugitive	   nmap <silent> <buffer> <space> =
	autocmd FileType fugitive	   nnoremap <silent> <buffer> <Leader>l <C-W>l
	autocmd FileType fugitive	   nnoremap <silent> <buffer> <Leader>h <C-W>h
	autocmd FileType fugitive	   nnoremap <silent> <buffer> <Leader>j <C-W>j
	autocmd FileType fugitive	   nnoremap <silent> <buffer> <Leader>k <C-W>k
	autocmd FileType fugitive	   nnoremap <silent> <buffer> <Leader>n gt
	autocmd FileType fugitive	   nnoremap <silent> <buffer> <Leader>p gT
	autocmd FileType fugitive	   nnoremap <silent> <buffer> <Leader>o :only<CR>
	autocmd FileType gitcommit    set completefunc=GetCommitTypes
	autocmd FileType gitcommit    set textwidth=0
	autocmd FileType gitcommit    call feedkeys("i\<C-X>\<C-U>")
	autocmd FileType gitcommit    set complete=.,w,b
	autocmd FileType		git nmap	   <silent> <buffer> l <CR>
	autocmd FileType		git nnoremap <silent> <buffer> h <C-O>
	autocmd FileType		git nmap <silent> <buffer> dd :call DisplayCommitFilesDiffs('fromGitLogOrGitCommitBuffer')<CR>
	autocmd FileType		git set foldmethod=syntax
augroup end

nnoremap <silent> <leader>d :0Gllog!<CR><C-W>j
nnoremap <silent> <leader>D :Gdiffsplit<CR>

" Drafts (Diagrams & Notes):-----------{{{
function! StartLiveNote()
	let cmd = printf('%s "%s"', 'MarkdownLivePreview.bat', expand('%:p'))
	let job = job_start(cmd, { 'in_mode': 'nl' })
	let b:livenote_job = job
	autocmd TextChangedI <buffer> :call FeedLiveNote()
endfunction
command StartLiveNote call StartLiveNote()

function! FeedLiveNote()
	let markdown = json_encode(join(getline(1, '$'), "\r\n"))
	let chunks = []
	let markdownLength = len(markdown)
	let remaining = markdown
	while (len(remaining) >= 4000) "👈 https://unix.stackexchange.com/questions/643777/is-there-any-limit-on-line-length-when-pasting-to-a-terminal-in-linux
		call add(chunks, remaining[:3999])
		let remaining = remaining[4000:]
	endwhile
	call add(chunks, remaining)
	for i in range(len(chunks))
		call ch_sendraw(b:livenote_job, chunks[i] . "\n")
	endfor
	call ch_sendraw(b:livenote_job, "<LiveNote>\n")
endfunction

function! StopLiveNote()
	autocmd! TextChangedI <buffer>
	call ch_sendraw(b:livenote_job, "\n\n")
	if job_status(b:livenote_job) != 'dead'
		call job_stop(b:livenote_job)
	endif
endfunction
command StopLiveNote call StopLiveNote()
command! ToggleLiveNote if has_key(b:, 'livenote_job') && job_status(b:livenote_job) == "run" | call StopLiveNote() | else | call StartLiveNote() | endif

function! LocListNotes()
	let cwd = getcwd()
	exec 'lcd' g:rc.notes
	exec 'Lgrep' '"^# "' '-g "*.md" -g "!*.withsvgs.md"' '--sort path'
	exec 'lcd' cwd
endfunction
nnoremap <silent> <leader>en :call LocListNotes()<CR>

function! LocListToDirectory(dir, title)
	let items = expand(fnamemodify(a:dir, ':p').'/*', 0, 1)
	if a:dir == g:rc.projects
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
nnoremap <silent> <leader>ep :call LocListToDirectory(g:rc.projects,  'Projects')<CR>

function! GetFilename()
	let line = getline('.')
	let filename = line[:match(line, '\s*|')-1]
	return fnamemodify(filename, ':p')
endfunction

function! SaveInFolderAs(path, filetype)
endfunc

function! Meeting(...)
		let meetingKind = a:0 && !empty(a:1) ? a:1 : 'meeting'
		let meetingKindInFilename = StringStartsWith(meetingKind, '.')
			\? printf('point_%s', trim(meetingKind, '.'))
			\: meetingKind
		let today = StrftimeFR('%Y-%m-%d-%A')
		let filename = printf('%s/%s.%s.md', g:rc.notes, meetingKindInFilename, today)
		let finalFilename = filename
		let c = 1
		while (filereadable(finalFilename) != 0)
			let c += 1
			let finalFilename = printf('%s-%d.md', fnamemodify(filename, ':r'), c)
		endwhile
		if &buftype != 'nofile' | exec winnr('$') == 1 ? 'vnew' : 'new' | endif
		exec 'set bt= ft=markdown'
		exec 'saveas' finalFilename
		let title = printf('%s %s', meetingKind, today)
		if (getline(1) !~ '^#')
			call append(0, GetMeetingKindTemplateLines(meetingKind))
			write
			normal! gg2j
		endif
		if (!has_key(b:, 'livenote_job') || job_status(b:livenote_job) != 'run')
			call StartLiveNote()
			GvimTweakToggleTransparency
		endif
endfunc
command! -nargs=? -complete=customlist,GetMeetingKinds Meeting call Meeting(<q-args>)
command! -nargs=? -complete=customlist,GetMeetingKinds M call Meeting(<q-args>)

function! GetMeetingKindTemplateLines(meetingKind)
	let templateFile = printf('%s/%s', g:rc.env.meetingKindsFolder, a:meetingKind)
	let lines = readfile(templateFile)
	let lines = map(lines, printf('substitute(v:val, "${FILENAME}", "%s", "g")', a:meetingKind))
	let lines = map(lines, printf('substitute(v:val, "${DATE}", "%s", "g")', StrftimeFR('%Y-%m-%d-%A')))
	return lines
endfunc

function! GetMeetingKinds(argLead, cmdLine, cursorPos)
	let meetingKindsTemplateFiles =
		\glob(printf('%s/*', g:rc.env.meetingKindsFolder), 1, 1)
		\+ glob(printf('%s/.[^.]*', g:rc.env.meetingKindsFolder), 1, 1)
	return filter(map(meetingKindsTemplateFiles, 'fnamemodify(v:val, ":t")'), 'v:val != "meeting"')
endfunc

function! Note(...)
	let args = ParseArgs(a:000, ['filetype', 'markdown'])
	let filetype = args.filetype
	let ext = get({
				\'markdown':	'md',
				\'json':		'json',
				\'xml':		'xml',
				\'puml_mindmap':	'puml_mindmap',
				\'puml_activity': 'puml_activity',
				\'puml_sequence': 'puml_sequence',
				\'puml_class':	'puml_class',
				\'puml_json':	'puml_json'
			\}, filetype, 'md')
	let filename = PromptUserForFilename('File name:', {n -> printf('%s/%s.%s', g:rc.notes, n, ext)})
	if trim(filename) == '' | return | endif
	if &buftype != 'nofile' | exec winnr('$') == 1 ? 'vnew' : 'new' | endif
	let newpath = printf('%s/%s.%s', g:rc.notes, filename, ext)
	exec 'set bt= ft='.filetype
	exec 'saveas' newpath
	if (ext == 'md' && getline(1) !~ '^#') | execute 'normal!' 'ggO# '.filename."\<esc>:w\<CR>j" | endif
endfunc
command! -nargs=? -complete=customlist,GetNoteFileTypes Note call Note(<q-args>)

function! GetNoteFileTypes(argLead, cmdLine, cursorPos)
	return ['markdown', 'puml_mindmap', 'puml_activity', 'puml_sequence', 'puml_class', 'puml_json']
endfunc

function! JobExitDiagramCompilationJob(outputfile, scratchbufnr, inputfile, channelInfos, status)
	if a:status != 0
		exec 'botright sbuffer' a:scratchbufnr 
		exec 'vnew' a:inputfile
		return
	endif
	let outputfile = a:outputfile
	if outputfile =~ '\.svg$'
		call system(printf(g:rc.gtools.'/mv "%s" "%s.html"', a:outputfile, a:outputfile))
		let outputfile.='.html'
	endif
	call WebBrowser('', substitute(outputfile, '/', '\', 'g'))
endfunc

function! CompileDiagramAndShowImageCommand(outputExtension, ...)
	let inputfile = expand('%:p')
	if substitute(inputfile, '\', '/', 'g') == g:rc.today
		let inputfile = g:rc.tmp.'/today.puml_mindmap'
		let diagram = uniq(getline(1, '$'))
		let emptyLine = ''
		let separatorBeforeWorld = index(diagram, emptyLine)
		let myself = diagram[:separatorBeforeWorld-1]
		let world = diagram[separatorBeforeWorld+1:]
		let diagram = ['@startmindmap']
		let diagram += ['title My life today with...']
		let diagram +=	['right side', '* **__MY INTERNAL WORLD__**'] + map(myself, '"*".v:val')
		let diagram += ['left side',  '** **__THE EXTERNAL WORLD__**'] + map(world, '"**".v:val')
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
		let inputfile = g:rc.tmp.'/markdown.md'
		exec 'write!' inputfile
	endif
	if (FileContainsPlantumlSnippets() || FileContainsD2Snippets())
		try
		let inputfile = CreateFileWithRenderedSvgs()
		catch
			echomsg v:exception
			return
		endtry
	endif
	let inputfile = substitute(inputfile, '/', '\\', 'g')
	exec 'WebBrowser' inputfile
endfunc
command! RenderMarkdownFile call RenderMarkdownFile()

augroup markdown
	au!
	autocmd FileType markdown nnoremap <buffer> <leader>w :RenderMarkdownFile<CR>
	autocmd FileType markdown nnoremap <buffer> <silent> <leader>W :ToggleLiveNote<CR>
	autocmd FileType markdown nnoremap <buffer> z! :BLines ^##<CR>
	autocmd FileType markdown nnoremap <buffer> Z! :BLines [<CR>
	autocmd FileType markdown nnoremap <buffer> zj /^#<CR>
	autocmd FileType markdown nnoremap <buffer> zk ?^#<CR>
	autocmd FileType markdown setlocal omnifunc=
	autocmd FileType markdown syn match markdownError "\w\@<=\w\@="
	"autocmd TextChangedI *.md :call UpdateAsync()
augroup END

function! UpdateAsync()
	if !has_key(b:, 'timers') | let b:timers = [] | endif
	let tid = timer_start(10, { timerid -> execute('update | call remove(b:timers, 0)') })
	if empty(b:timers) | call add(b:timers, tid) | endif
endfunc


function! FileContainsPlantumlSnippets()
	let file = join(getline(1,'$'))
	return stridx(file, '```puml_') != -1
endfunc

function! FileContainsD2Snippets()
	let file = join(getline(1,'$'))
	return stridx(file, '```d2') != -1
endfunc

function! GetPlantumlConfigFile(filepath)
	return ''
	let configfilebyft = #{
		\puml_activity:	   'styles',
		\puml_mindmap:	   'styles',
		\puml_sequence:	   'styles',
		\puml_workbreakdown: 'styles',
		\puml_class:	   'skinparams',
		\puml_component:	   'skinparams',
		\puml_entities:	   'skinparams',
		\puml_state:	   'skinparams',
		\puml_usecase:	   'skinparams',
		\puml_dot:	   'graphviz',
		\puml_json:	   'styles'
	\}
	let fileext = fnamemodify(a:filepath, ':e')
	if empty(configfilebyft[fileext])
		return ''
	endif
	return g:rc.desktop.'/config/my_plantuml_'.configfilebyft[fileext].'.config'
endfunction

function! CreateFileWithRenderedSvgs()
	let inputfile = expand('%:p')
	let inputfolder = fnamemodify(inputfile, ':h')
	let newinputfile = fnamemodify(inputfile, ':h').'/'.fnamemodify(inputfile, ':t:r').'.withsvgs.'.fnamemodify(inputfile, ':t:e')
	let lines = getline(1, '$')
	let start = '^\s*```puml'
	let stop = '^\s*```'
	let delimiter = start
	let lastStart = -1
	let lastStop = -1
	let textSplits = []
	for i in range(len(lines))
		if lines[i] =~ delimiter
			if delimiter == start
				if i > 0
					let textSplits += lines[lastStop+1:i-1]
				endif
				let lastStart = i
			else
				let diagram =lines[lastStart+1:i-1]
				let diagramtype = split(lines[lastStart], '_')[-1]
				call StartPlantumlToSvg(diagram, diagramtype, textSplits, len(textSplits))
				call add(textSplits, 'generated diagram')
				let lastStop = i
			endif
			let delimiter = (delimiter == start) ? stop : start
			if lines[i] =~ '^\s*```\s*$' && (i == line('$')-1 || lines[i+1] != '')
				let lines[i] = substitute(lines[i], '```', '```text', '')
			endif
		endif
	endfor
	let textSplits += lines[lastStop+2:]
	while !empty(filter(copy(textSplits), {_,x -> x == 'generated diagram'})) && empty(filter(copy(textSplits), {_,x -> x == 'DIAGRAM NOT GENERATED' }))
		sleep 50m
	endwhile
	if !empty(filter(copy(textSplits), {_,x -> x == 'DIAGRAM NOT GENERATED'}))
		throw "Diagram syntax error"
	endif
	call writefile(textSplits, newinputfile)
	return newinputfile
endfunc

function! StartPlantumlToSvg(diagram, diagramtype, array, pos)
	let pumlDelimiter = GetPlantumlDelimiter(a:diagramtype)
	let diagram = a:diagram
	if a:diagramtype == 'class'
		let diagram = CompleteClassPlantuml(diagram)
	endif
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
			\'exit_cb':  function('StartPlantumlToSvgCB', [a:array, a:pos, scratchbufnr, plantumlbufnr])
		\}
	\)
endfunction

function! CompleteClassPlantuml(diagram)
	let tree = []
	let currentIndentLevel = -1
	let pos = []
	let indentMinLengths = [len(matchstr(a:diagram[0], '^\s\+'))]
	let previousIndentLevel = -1
	for diagramLine in range(len(a:diagram))
		let line = a:diagram[diagramLine]
		let element = matchstr(line, '^\s*.* as \zs[^ ]\+\ze')
		if empty(element) | continue | endif
		let indentLength = len(matchstr(line, '^\s\+'))
		let indentLevel = 0
		for i in range(len(indentMinLengths))
			if indentLength >= indentMinLengths[i]
				if i < len(indentMinLengths) - 1
					if indentLength < indentMinLengths[i+1]
						let indentLevel = i
						break
					endif
				elseif indentLength == indentMinLengths[-1]
					let indentLevel = i
					break
				else
					call add(indentMinLengths, indentLength)
					let indentLevel = i+1
					break
				endif
			else
				let indentLevel = i
				break
			endif
		endfor
		if indentLevel > previousIndentLevel
			call CreateChildArrayAtLastKnownPosition(tree, element, pos)
		elseif indentLevel == previousIndentLevel
			call CreateSiblingArrayAtLastKnownPosition(tree, element, pos)
		else
			call CreateArrayAtGivenParentPosition(tree, element, pos, indentLevel)
		endif
		let previousIndentLevel = indentLevel
	endfor
	let arrows = []
	let firsts = []
	for arrayOrSingle in tree
		call add(firsts, (type(arrayOrSingle) == type([]) ? arrayOrSingle[0] : arrayOrSingle))
		for childrenArraysOrSingles in arrayOrSingle
			call GetSuccessivePairs(childrenArraysOrSingles, arrows)
		endfor
	endfor
	for i in range(len(firsts)-1)
		let aos1 = firsts[i]
		let aos2 = firsts[i+1]
		call add(arrows, { 'a': (type(aos1) == type([]) ? aos1[0] : aos1), 'b': (type(aos2) == type([]) ? aos2[0] : aos2) })
	endfor
	let finalDiagram = a:diagram + map(arrows, { _,x -> printf('%s -[hidden]> %s', x.a, x.b) })
	return finalDiagram
endfunction

function! GetSuccessivePairs(arrayOrSingle, arr)
	if type(a:arrayOrSingle) != type([]) | return | endif
	for i in range(len(a:arrayOrSingle)-1)
		let aos1 = a:arrayOrSingle[i]
		let aos2 = a:arrayOrSingle[i+1]
		call add(a:arr, { 'a': (type(aos1) == type([]) ? aos1[0] : aos1), 'b': (type(aos2) == type([]) ? aos2[0] : aos2) })
		call GetSuccessivePairs(aos1, a:arr)
	endfor
	call GetSuccessivePairs(a:arrayOrSingle[-1], a:arr)
endfunction

function! CreateChildArrayAtLastKnownPosition(tree, element, pos)
	if empty(a:tree)
		call add(a:tree, a:element)
		call add(a:pos, 0)
	else
		let treeNode = GetTreeNodeAt(a:tree, a:pos)
		let node = [treeNode.node, [a:element]]
		call remove(treeNode.parent, -1)
		call add(treeNode.parent, node)
		if a:pos[-1] == 0 || len(a:pos) == 1
			call add(a:pos, 1)
		else
			let a:pos[-1] += 1
		endif
		call add(a:pos, 0)
	endif
endfunction

function! CreateSiblingArrayAtLastKnownPosition(tree, element, pos)
	let parentNode = GetTreeNodeAt(a:tree, a:pos).parent
	call add(parentNode, a:element)
	let a:pos[-1] += 1
endfunction

function! CreateArrayAtGivenParentPosition(tree, element, pos, indentLevel)
	let nbIndexes = 1
	if a:indentLevel == 0
		let nbIndexes = 1
	else
		let nbIndexes = 1 + a:indentLevel * 2
	endif

	call remove(a:pos, nbIndexes, len(a:pos)-1)
	call CreateSiblingArrayAtLastKnownPosition(a:tree, a:element, a:pos)
endfunction

function! GetTreeNodeAt(tree, pos)
	let array = a:tree
	let parent = a:tree
	for i in range(len(a:pos))
		let index = a:pos[i]
		let parent = array
		let array = array[index]
	endfor
	return { 'node': array, 'parent': parent }
endfunction

function! StartPlantumlToSvgCB(array, pos, scratchbufnr, plantumlbufnr, job, status)
	if a:status != 0
		exec 'botright sbuffer' a:scratchbufnr 
		exec a:plantumlbufnr.'bdelete!'
		let a:array[a:pos] = "DIAGRAM NOT GENERATED"
		return
	endif
	call setbufvar(a:scratchbufnr, '&buftype', 'nofile')
	let output = getbufline(a:scratchbufnr, 1, '$')
	let firstDiagramLine = 0
	for lineNr in range(len(output))
		if stridx(output[lineNr], '<?xml') >= 0
			let firstDiagramLine = lineNr
			break
		endif
	endfor
	let svg = join(output[firstDiagramLine:], '\n')
	let svg = substitute(svg, ' style="', ' style="padding:8px;', '')
	let svg = substitute(svg, '\/svg>.*$', '/svg>', '')
	let svg = substitute(svg, '', '', 'g')
	if stridx(svg, '--></g></svg>') == -1
		let svg .= '--></g></svg>'
	endif
	let a:array[a:pos] = svg
	exec a:scratchbufnr.'bdelete!'
	exec a:plantumlbufnr.'bdelete!'
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
	autocmd BufRead,BufNewFile,BufWritePost *.puml_dot		set ft=plantuml_dot
	autocmd BufRead,BufNewFile,BufWritePost *.puml_activity	set ft=plantuml_activity
	autocmd BufRead,BufNewFile,BufWritePost *.puml_class		set ft=plantuml_class
	autocmd BufRead,BufNewFile,BufWritePost *.puml_component	set ft=plantuml_component
	autocmd BufRead,BufNewFile,BufWritePost *.puml_entities	set ft=plantuml_entities
	autocmd BufRead,BufNewFile,BufWritePost *.puml_mindmap	set ft=plantuml_mindmap
	autocmd BufRead,BufNewFile,BufWritePost *.puml_sequence	set ft=plantuml_sequence
	autocmd BufRead,BufNewFile,BufWritePost *.puml_state		set ft=plantuml_state
	autocmd BufRead,BufNewFile,BufWritePost *.puml_usecase	set ft=plantuml_usecase
	autocmd BufRead,BufNewFile,BufWritePost *.puml_workbreakdown	set ft=plantuml_workbreakdown
	autocmd BufRead,BufNewFile,BufWritePost *.puml_json		set ft=plantuml_json
	autocmd BufRead,BufNewFile,BufWritePost *.puml_*		silent nnoremap <buffer> <Leader>w :silent w<CR>
	autocmd BufWritePost	*.puml_*		     if line('$') > 1 | CompileDiagramAndShowImage svg | endif
	autocmd FileType		dirvish		     nnoremap <silent> <buffer> D :call CreateDiagramFile()<CR>
augroup END

" Notes:-------------------------------{{{
function! GenerateMarkdownForRequestResponse(title, responseLines, requestLines)
	let markdown =	['### '.a:title, '<div style="display: flex"><div style="flex: 50%; max-width: 50%;">', '', '**Request**', '```']
	let markdown += a:requestLines
	let markdown += ['```', '', '', '</div><div style="flex: 50%; max-width: 50%;">', '', '**Responses**', '', '```']
	let markdown += a:responseLines
	let markdown += ['```', '* Caused by this', '* Caused also by that', '</div></div>']
	return markdown
endfunc

function! TraceRequestResponseIntoFile(requestLines, responseLines, filename, title)
	let markdownLines = GenerateMarkdownForRequestResponse(a:title, a:requestLines, a:responseLines)
	call writefile(markdownLines, a:filename, "a")
endfunction
command! -nargs=1 Keep call TraceRequestResponseIntoFile(get(b:, 'scriptLines'), getline(1, '$'), get(g:, 'keepfile', g:rc.desktop.'/keep.md'), <q-args>)

" Debugging:---------------------------{{{
 let g:vimspector_enable_mappings = 'HUMAN'
	"sign define vimspectorBP text=o		texthl=WarningMsg
	"sign define vimspectorBPCond text=o?	texthl=WarningMsg
	"sign define vimspectorBPDisabled text=o!	texthl=LineNr
	"sign define vimspectorPC text=\ >		texthl=MatchParen
	"sign define vimspectorPCBP text=o>		texthl=MatchParen
	"sign define vimspectorCurrentThread text=>	texthl=MatchParen
	"sign define vimspectorCurrentFrame text=>	texthl=Special

function! ToggleBreakpoint()
	if NoBreakpointIsPresentOnCurrentLine()
		call vimspector#ToggleBreakpoint()
	elseif ActiveBreakpointIsPresentOnCurrentLine()
		call vimspector#ToggleBreakpoint()
		"call vimspector#ToggleBreakpoint()
	elseif DisabledBreakpointIsPresentOnCurrentLine()
		call vimspector#ToggleBreakpoint()
	endif
endfunction
command! ToggleBreakpoint call ToggleBreakpoint()

function! ToggleConditionalBreakpoint()
	if !NoBreakpointIsPresentOnCurrentLine()
		call ToggleBreakpoint()
	endif
	let condition = input('condition:')
	if trim(condition) != ''
		call vimspector#ToggleBreakpoint({'condition': condition})
	endif
	redraw
endfunction
command! ToggleConditionalBreakpoint call ToggleConditionalBreakpoint()

 function! IsDebuggingTab(...)
	let tabnr = a:0 ? a:1 : tabpagenr()
	return tabnr == get(get(g:, 'vimspector_session_windows', {}), 'tabpage', 0)
 endfunction
 
 function! IsDebuggingHappening()
	return get(get(g:, 'vimspector_session_windows', {}), 'tabpage', 99) <= tabpagenr('$')
 endfunction

	function! NoBreakpointIsPresentOnCurrentLine()
		return empty(sign_getplaced(bufnr(), #{group:'VimspectorBP', lnum: line(".")})[0].signs)
	endfunction

	function! ActiveBreakpointIsPresentOnCurrentLine()
		let signs = sign_getplaced(bufnr(), #{group:'VimspectorBP', lnum: line(".")})[0].signs
		return !empty(filter(signs, {_,x -> x.name == 'vimspectorBP' || x.name == 'vimspectorBPCond'}))
	endfunction

	function! DisabledBreakpointIsPresentOnCurrentLine()
		let signs = sign_getplaced(bufnr(), #{group:'VimspectorBP', lnum: line(".")})[0].signs
		return !empty(filter(signs, {_,x -> x.name == 'vimspectorBPDisabled'}))
	endfunction

function! Debug()
	if IsDebuggingHappening()
		exec 'normal!' g:vimspector_session_windows.tabpage.'gt'
	else
		"if NoBreakpointIsPresentOnCurrentLine() | call vimspector#ToggleBreakpoint() | endif
		let isTestFile = (expand('%:p') =~ 'test\|should')
		if isTestFile
			let omnisharp_up = get(OmniSharp#GetHost(), 'initialized', 0)
			if omnisharp_up
				OmniSharpDebugTest
			else
				echomsg 'OmniSharp server is not running. Please run it in order to debug a test.'
			endif
		else
			call vimspector#Launch()
		endif
	endif
endfunction
command! -bar Debug call Debug()

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
	call SetDebugMappings()
endfunction

augroup MyVimspectorUICustomistaion
	autocmd!
	autocmd User VimspectorUICreated call CustomiseUI()
	autocmd User VimspectorJumpedToFrame call SetDebugMappings()
	autocmd User VimspectorDebugEnded call RemoveDebugMappings()
augroup END

function! SetDebugMappings() abort
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
	nnoremap <silent> <buffer> <Leader>= <C-W>=99<C-W>w:resize 12<CR><C-W>p1<C-W>w:resize +4<CR>
endfunction

function! RemoveDebugMappings() abort
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
" Nuget: ------------------------------{{{
function! FindOrListNugets(...)
	let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'tmp/Nugets')
	if empty(a:000) && &ft == 'cs'
		let cmd = printf('dotnet list "%s" package', OmniSharp#GetHost().sln_or_dir)
		let cmd = 'cmd /C '.cmd
		echomsg cmd
		let s:job = job_start(cmd, {'out_io': 'buffer', 'out_buf': scratchbufnr, 'err_io': 'buffer', 'err_buf': scratchbufnr, 'exit_cb': { job, status -> execute('sbuffer '.scratchbufnr)}})
		return
	endif

	let tokens = flatten(map(copy(a:000), { _,x -> split(x, '\.') }))
	let cmd = 'nuget search '.join(tokens, '.').' -Take 20 -v q'
	if g:isWindows
		let cmd = 'cmd /C '.cmd
	endif
	let found = []
	let sources = []
	let s:job = job_start(
		\cmd,
		\{
			\'out_io': 'buffer',
			\'out_modifiable': 1,
			\'err_io': 'buffer',
			\'err_buf': scratchbufnr,
			\'err_modifiable': 1,
			\'in_io': 'null',
			\'callback': { chan,msg  -> execute('echo ''[cb] '.substitute(msg,"'","''","g").'''',  1)   },
			\'out_cb':   function('AddNugetIfMatches', [found, tokens, sources]),
			\'err_cb':   { chan,msg  -> execute('echohl Constant | echomsg '''.substitute(msg,"'","''","g").''' | echohl Normal',  1) },
			\'close_cb': { chan	 -> execute('echomsg ''[close] '.chan.'''', 1)},
			\'exit_cb':  function('FindOrListNugetsExitCb', [found, tokens, scratchbufnr])
		\}
	\)
endfunc
command! -nargs=* Nuget call FindOrListNugets(<f-args>)

function! AddNugetIfMatches(foundNugets, searchTokens, sources, channel, msg)
	if a:msg =~ '^source: '
		let source = a:msg[len('Source: '):]
		call add(a:sources, source)
		return
	endif
	let isMatch = 1
	let nuget = a:msg[len('> '):]
	for token in a:searchTokens
		if nuget !~ token
			let isMatch = 0
			break
		endif
	endfor
	if isMatch
		let currentSource = a:sources[-1]
		let foundNuget = nuget.' | '.currentSource
		call add(a:foundNugets, foundNuget)
	endif
endfunction

function! FindOrListNugetsExitCb(foundNugets, tokens, scratchbufnr, job, status)
	if a:status != 0
		exec 'botright sbuffer' a:scratchbufnr 
		return
	endif
	echomsg "[exit] ".a:status
	exec 'sbuffer' a:scratchbufnr
	0put =a:foundNugets
	SortByLengthBeforeFirstSpaceChar
	normal! gg"_dd
endfunction

" cs(c#): -----------------------------{{{
if has('win32') | let g:OmniSharp_server_path = g:rc.desktop . '/tools/omnisharp/OmniSharp.exe' | endif
let $DOTNET_NEW_LOCAL_SEARCH_FILE_ONLY=1
let g:OmniSharp_start_server = 0
let g:OmniSharp_server_stdio = 1
let g:ale_linters = { 'cs': ['OmniSharp'] }
let g:OmniSharp_timeout = 0.1
let g:OmniSharp_popup = 1
let g:OmniSharp_popup_position = 'center'
let g:OmniSharp_popup_options = {
\ 'highlight': 'Normal',
\ 'border': [1],
\ 'borderchars': [' '],
\ 'borderhighlight': ['Visual']
\}
let g:OmniSharp_popup_mappings = {
\ 'close': ['<Esc>', 'q'],
\ 'halfPageDown': ['<C-d>', 'd'],
\ 'halfPageUp': ['<C-u>', 'u']
\}
let g:OmniSharp_loglevel = 'none'
let g:OmniSharp_highlighting = 2
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_fzf_options = { 'window': 'botright 7new' }
let g:OmniSharp_want_snippet=1
let g:OmniSharp_diagnostic_overrides = { 'CS0618': { 'type': 'None'}, 'CS1062': { 'type': 'None'} } " obsolete attributes
let g:OmniSharp_diagnostic_showid = 1
let g:omnicomplete_fetch_full_documentation = 0
let g:OmniSharp_open_quickfix = 1
let g:OmniSharp_autoselect_existing_sln = 1

function! OmniSharpReloadProject()
	if !OmniSharp#proc#IsJobRunning(GetSln()) | return | endif
	call ch_sendraw(
		\OmniSharp#GetHost().job.job_id,
		\json_encode({ 'Seq': 999999, 'Arguments': [ { 'ChangeType': 'Change', 'FileName': GetCsproj() } ], 'Type': 'request', 'Command': '/filesChanged' }) . "\n")
endfunction

function! OmniSharpDeleteFile(...)
	if !OmniSharp#proc#IsJobRunning(GetSln()) | return | endif
	let filename = a:0 ? a:1 : expand('%:p')
	call ch_sendraw(
		\OmniSharp#GetHost().job.job_id,
		\json_encode({ 'Seq': 999999, 'Arguments': [ { 'ChangeType': 'Delete', 'FileName': filename } ], 'Type': 'request', 'Command': '/filesChanged' }) . "\n")
endfunction

function! GetCsproj()
	return GetNearestPathInCurrentFileParents('*.csproj')
endfunction

function! GetSln()
	return GetNearestPathInCurrentFileParents('*.sln')
endfunction

function! GetCurrentCsharpNamespace()
	let currentFolderAbs = expand('%:p:h')
	let slnFileAbs = GetNearestPathInCurrentFileParents('*.sln')
	if (empty(slnFileAbs))
		let currentFolder = expand('%:h')
		return substitute(currentFolder, '\', '.', 'g')
	else
		let slnFolder = fnamemodify(slnFileAbs, ':h')
		let currentFolderRelativeToSlnFolder = currentFolderAbs[len(slnFolder)+1:]
		return substitute(currentFolderRelativeToSlnFolder, '\', '.', 'g')
	endif
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

function! MyOmniSharpReloadProjectAndLinter()
	call OmniSharp#actions#project#Reload(GetCsproj())
	call ale#code_action#ReloadBuffer()
	call add([], timer_start(500, { timerid -> execute('call ale#code_action#ReloadBuffer()', '') }))
endfunction
command! MyOmniSharpReloadProjectAndLinter call MyOmniSharpReloadProjectAndLinter()

function! GetCodeUrlOnAzureDevops(...)
	let filepath = expand('%:p')
	let gitrootfolder = fnamemodify(gitbranch#dir(filepath), ':h:p')
	let gitpath = filepath[len(gitrootfolder)+(has('win32')?1:0):]
	let gitpath = '/' . substitute(gitpath, '\\', '/', 'g')
	let gitbranch = gitbranch#name()
	let gitproject = fnamemodify(gitrootfolder, ':t')
	let url = g:rc.env.ados.'/'.g:rc.env.adosSourceProject.'/_git/'.gitproject.'?path='.substitute(gitpath, '/', '%2F', 'g').'&version=GB'.substitute(gitbranch, '/', '%2F', 'g')
	if (a:0 == 0) || (a:1 == a:2)
		let url .= '&line='.line('.')
	else
		let url .= '&line='.a:1
		let url .= '&lineEnd='.a:2
	endif
	if a:0 == 0
		let url .= '&lineStartColumn=1&lineEndColumn=99'
	else
		let adostabstop=3
		let firstCol = max([getpos("'<")[2], 1]) + (getpos("'<")[2] == 1 ? 0 : adostabstop*(min([getpos("'<")[2],indent(line("'<"))])))
		let lastCol = min([getpos("'>")[2], len(getline("'>'"))]) + 1 + adostabstop*indent(line("'>"))
		let url .= '&lineStartColumn='.firstCol
		let url .= '&lineEndColumn='.lastCol
	endif
	return url
endfunction

function! GetCodeUrlOnGithub(...)
	let filepath = expand('%:p')
	let gitrootfolder = fnamemodify(gitbranch#dir(filepath), ':h:p')
	let gitpath = filepath[len(gitrootfolder)+(has('win32')?1:0):]
	let gitpath = substitute(gitpath, '\\', '/', 'g')
	let gitbranch = gitbranch#name()
	let gitproject = fnamemodify(gitrootfolder, ':t')
	let url = g:rc.env.ghOrganization.'/'.gitproject.'/blob/'.substitute(gitbranch, '/', '%2F', 'g').'/'.gitpath
	if (a:0 == 0) || (a:1 == a:2)
		let url .= '#L'.line('.')
	else
		let url .= '#L'.a:1
		let url .= '-L'.a:2
	endif
	return url
endfunction

function! GetCodeUrlOnGitRepoHost(...)
	if (g:rc.env.ados != '')
		return call(function('GetCodeUrlOnAzureDevops'), a:000)
	elseif (g:rc.env.ghOrganization != '')
		return call(function('GetCodeUrlOnGithub'), a:000)
	else
		throw 'Neither g:rc.env.ados nor g:rc.env.ghOrganization seem defined'
	endif
endfunction

function! CopyGitRepoHostCodeUrl() range
	let @+=GetCodeUrlOnGitRepoHost(a:firstline, a:lastline)
	echomsg 'Code URL copied!'
endfunction
command! -range CopyGitRepoHostCodeUrl <line1>,<line2>call CopyGitRepoHostCodeUrl()

function! CopyGitRepoHostCodeUrlForFullLine()
	let @+=GetCodeUrlOnGitRepoHost()
	echomsg 'Code URL copied!'
endfunction
command! CopyGitRepoHostCodeUrlForFullLine call CopyGitRepoHostCodeUrlForFullLine()

function! OpenGitRepoHostCodeUrl() range
	exec 'WebBrowser' GetCodeUrlOnGitRepoHost(a:firstline, a:lastline)
endfunction
command! -range OpenGitRepoHostCodeUrl <line1>,<line2>call OpenGitRepoHostCodeUrl()

function! OpenGitRepoHostCodeUrlForFullLine()
	exec 'WebBrowser' GetCodeUrlOnGitRepoHost()
endfunction
command! OpenGitRepoHostCodeUrlForFullLine call OpenGitRepoHostCodeUrlForFullLine()

function! MyOmniSharpNavigate(location, ...)
	if OmniSharp#locations#Navigate(a:location)
		Reframe
	endif
endfunction
command! MyOmniSharpNavigateUp	 call OmniSharp#actions#navigate#Up  (function('MyOmniSharpNavigate'))
command! MyOmniSharpNavigateDown call OmniSharp#actions#navigate#Down(function('MyOmniSharpNavigate'))

function! MyOmniSharpGoToDefinition(location, ...)
	if type(a:location) != type({}) " Check whether a dict was returned
		echo 'Not found'
		let found = 0
	else
		let found = OmniSharp#locations#Navigate(a:location, 'edit')
		if found
			Reframe
		endif
	endif
	return found
endfunction
command! MyOmniSharpGoToDefinition call OmniSharp#actions#definition#Find(function('MyOmniSharpGoToDefinition'))

function! MyOmniSharpCodeFormat(...)
	let formerIndentexpr = &indentexpr

	setlocal indentexpr=CSharpIndent()
	silent! normal! m'gg=G``
	exec 'setlocal indentexpr='.formerIndentexpr

	silent! call OmniSharp#actions#format#Format()
endfunction
command! MyOmniSharpCodeFormat call OmniSharp#actions#format#Format(function('MyOmniSharpCodeFormat'))

function! MyOmniSharpGlobalCodeCheck()
	let g:old_OmniSharp_diagnostic_exclude_paths = g:OmniSharp_diagnostic_exclude_paths
	let currentAppName = matchstr(fnamemodify(GetSln(), ':t:r'), '[^.]*$')
	let resourceCandidates = filter(items(g:rc.env.resources), { i,kvp => kvp[0] == currentAppName && kvp[1].type == 'git' })
	if (!empty(resourceCandidates))
		let appAsResource = resourceCandidates[0]
		let foldersToIgnore = appAsResource.foldersWithWarningsToIgnore
		let g:OmniSharp_diagnostic_exclude_paths = extendnew(g:OmniSharp_diagnostic_exclude_paths, foldersToIgnore)
	endif
	call OmniSharp#actions#diagnostics#CheckGlobal(function('MyOmniSharpGlobalCodeCheckCallback'))
endfunction

command! MyOmniSharpFindSymbols call OmniSharp#actions#symbols#Find(<q-args>)
command! MyOmniSharpFindType call OmniSharp#actions#symbols#FindType(<q-args>)

function! MyOmniSharpGlobalCodeCheckCallback(quickfixes, ...)
	let g:OmniSharp_diagnostic_exclude_paths = g:old_OmniSharp_diagnostic_exclude_paths
	if len(a:quickfixes) > 0
		call OmniSharp#locations#SetQuickfix(a:quickfixes, 'Code Check Messages')
	else
		echo 'No Code Check messages'
	endif
endfunction
command! MyOmniSharpGlobalCodeCheck call MyOmniSharpGlobalCodeCheck()

function! Map(variableName) range
	execute a:firstline.','.a:lastline 'normal!' '^d2W"vyeelC = '.a:variableName.".\<c-r>v,"
	execute a:lastline 'normal!' 'g_"_x'
endfunc
command! -nargs=1 -range Map <line1>,<line2>call Map(<f-args>)

function! Build()
	let slnFolder = GetNearestParentFolderContainingFile('*.sln')
	let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/buildSln')

	let cmd = 'dotnet build -v q --nologo /clp:NoSummary'
	let slnPathFromOmniSharp = get(OmniSharp#GetHost(), 'sln_or_dir', '')
	if !empty(slnPathFromOmniSharp)
		let cmd .= ' '.slnPathFromOmniSharp
	endif

	let cmd = 'cmd /C '.cmd
	let s:job = job_start(
		\cmd,
		\{
			\'cwd': slnFolder,
			\'out_io': 'buffer',
			\'out_buf': scratchbufnr,
			\'out_modifiable': 1,
			\'err_io': 'buffer',
			\'err_buf': scratchbufnr,
			\'err_modifiable': 1,
			\'in_io': 'null',
			\'exit_cb':  function('BuildCB', [scratchbufnr])
		\}
	\)
endfunction
function! BuildCB(scratchbufnr, job, status)
	echomsg a:status ? 'Build failed :D' : 'Build succeeded :)'
	if a:status || !empty(filter(getbufline(a:scratchbufnr, 1, '$'), {_,x-> x =~ 'warning\|error'}))
		exec 'silent! botright cbuffer' a:scratchbufnr
		let w:quickfix_title = 'Build'
	endif
endfunction
command! Build call Build()

augroup csharpfiles
	au!
	autocmd BufWrite *.cs,*.proto %s/^\(\s*\w\+\)\{0,6}\s\+class\s\+\zs\w\+\ze/\=uniq(sort(add(g:csClassesInChangedFiles, submatch(0))))/gne
	autocmd FileType cs set signcolumn=yes
	autocmd FileType cs set efm=%f(%l\\\,%c):\ %m\ [%.%#,%-G%.%#
	autocmd FileType cs if (expand('%:h') == WindowsPath(g:rc.tmp)[3:-2]) | setl foldmethod=expr foldexpr=getline(v:lnum)=~'^\\s*//'\ &&\ getline(v:lnum-1)=~'^\\s*//' foldtext=getline(v:foldstart+1).'\ '.trim(getline(v:foldstart+2),\ \"\\\t\ /\") | endif
	autocmd FileType cs nnoremap <buffer> <silent> <Leader>w :CopyGitRepoHostCodeUrlForFullLine<CR>
	autocmd FileType cs vnoremap <buffer> <silent> <Leader>w :CopyGitRepoHostCodeUrl<CR>
	autocmd FileType cs nnoremap <buffer> <silent> <Leader>W :OpenGitRepoHostCodeUrlForFullLine<CR>
	autocmd FileType cs vnoremap <buffer> <silent> <Leader>W :OpenGitRepoHostCodeUrl<CR>
	autocmd FileType cs nnoremap <buffer> <silent> <LocalLeader>m :Build<CR>
	autocmd FileType cs vnoremap <buffer> <LocalLeader>m :Map varname
	autocmd FileType cs nnoremap <buffer> <silent> <C-P> :MyOmniSharpNavigateUp<CR>
	autocmd FileType cs nnoremap <buffer> <silent> <C-N> :MyOmniSharpNavigateDown<CR>
	autocmd FileType cs nmap <buffer> z! :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_find_members)
	autocmd FileType cs nmap <buffer> gd :MyOmniSharpGoToDefinition<CR>
	autocmd FileType cs nmap <buffer> gD <Plug>(omnisharp_preview_definition)
	autocmd FileType cs nmap <buffer> <LocalLeader>i :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_find_implementations):Reframe<CR>
	autocmd FileType cs nmap <buffer> <LocalLeader>s :let g:lcd_qf = getcwd() \| let g:OmniSharp_selector_ui=''<CR>:MyOmniSharpFind<tab>
	autocmd FileType cs nmap <buffer> <LocalLeader>S <Plug>(omnisharp_signature_help)
	autocmd FileType cs nmap <buffer> <LocalLeader>u :let g:lcd_qf = getcwd()<CR><Plug>(omnisharp_find_usages)
	autocmd FileType cs nmap <buffer> <LocalLeader>d <Plug>(omnisharp_type_lookup)
	autocmd FileType cs nmap <buffer> <LocalLeader>D <Plug>(omnisharp_documentation)
	autocmd FileType cs nmap <buffer> <LocalLeader>c <Plug>(omnisharp_global_code_check)
	autocmd FileType cs nmap <buffer> <LocalLeader>q :let g:lcd_qf = getcwd() \| let g:OmniSharp_selector_ui='fzf'<CR><Plug>(omnisharp_code_actions)
	autocmd FileType cs xmap <buffer> <LocalLeader>q :<C-U>let g:lcd_qf = getcwd() \| let g:OmniSharp_selector_ui='fzf'<CR>gv<Plug>(omnisharp_code_actions)
	autocmd FileType cs nmap <buffer> <LocalLeader>r <Plug>(omnisharp_rename)
	autocmd FileType cs nmap <silent> <buffer> <LocalLeader>= :MyOmniSharpCodeFormat<CR>
	autocmd FileType cs nmap <buffer> <LocalLeader>f <Plug>(omnisharp_fix_usings)
	autocmd FileType cs nmap <buffer> <LocalLeader>n <Plug>(omnisharp_code_action_repeat)
	autocmd FileType cs nmap <buffer> <LocalLeader>R <Plug>(omnisharp_restart_server)
	autocmd FileType cs nnoremap <buffer> <LocalLeader>O :OmniSharpStartServer <C-R>=expand('%:h')<CR>
	autocmd FileType cs nmap <silent> <buffer> <LocalLeader>t :OmniSharpRunTest!<CR>
	autocmd FileType cs nmap <buffer> <LocalLeader>T <Plug>(omnisharp_run_tests_in_file)
	autocmd FileType cs nmap <silent> <buffer> <LocalLeader>U :set termwinsize=0*9999 \| ter ++hidden ++open dotnet test --nologo <C-R>=GetSln()<CR> --filter FullyQualifiedName!~IntegrationTest<CR>
	autocmd FileType cs nmap <silent> <buffer> <LocalLeader>I :set termwinsize=0*9999 \| ter ++hidden ++open dotnet test --nologo <C-R>=GetSln()<CR> --filter FullyQualifiedName~IntegrationTest<CR>
	autocmd FileType cs nmap <silent> <buffer> <LocalLeader>Q :Debug<CR>
	autocmd FileType cs nmap <silent> <buffer> <localleader>b :ToggleBreakpoint<CR>
	autocmd FileType cs nnoremap <silent> <buffer> <localleader>B :ToggleConditionalBreakpoint<CR>
	autocmd FileType cs nnoremap <silent> <buffer> <LocalLeader>L :call vimspector#ListBreakpoints()<CR>
	autocmd FileType cs nnoremap <silent> <buffer> <LocalLeader>C :call vimspector#ClearBreakpoints()<CR>
	autocmd FileType cs nnoremap <silent> <buffer> <LocalLeader>l :MyOmniSharpReloadProjectAndLinter<CR>

	" Messes with OmniSharpRename
	" autocmd FileType cs setlocal indentkeys+=.,=,:

	" Messes with Indent all parameters
	"autocmd FileType cs setlocal indentexpr=CSharpIndent() 
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
			let excmd = printf('terminal ++hidden ++kill=int %s.bat %s', a:name, join(a:000, ' '))
		else
			let excmd = printf('terminal ++hidden ++open ++kill=int %s.bat %s', a:name, join(a:000, ' '))
		endif
	else
		let excmd = printf('terminal ++curwin ++noclose ++kill=int %s.bat %s', a:name, join(a:000, ' '))
	endif
	set termwinsize=0*9999
	exec excmd
endfunction

for file in expand(printf('%s/*.bat', g:rc.scripts), 1, 1)
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
		if (empty(terminalbuffers))
			botright terminal ++rows=10
			return
		endif
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
			botright terminal ++rows=10
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
	let sln = a:0 ? a:1 : GetSln()
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

function! VsTestCB(testedAssembly, csprojsWithNbOccurrences, scratchbufnr, sln, buildAndTestJobs, job, status)
	if a:status != 0
		exec 'botright sbuffer' a:scratchbufnr 
		return
	endif
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

function! CascadeReferences(csprojs, csprojsWithNbOccurrences, reverseDependencyTree, scratchbufnr, modifiedClasses, previouslyBuiltCsproj, sln, buildAndTestJobs, job, status)
	if a:status != 0
		exec 'botright sbuffer' a:scratchbufnr 
		return
	endif
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
	let sln = a:0 ? a:1 : GetSln()
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
		let cmd = printf('"%s/find" "%s" -path "%s/obj" -prune -false -o -path "%s/bin" -prune -false -o -type f -newermt @%d -print0 -quit', g:rc.gtools, csprojFolder, csprojFolder, csprojFolder, g:csenvs[a:sln].projects[project].last_build_timestamp)
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
	let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/JobBuildTestCommit')
	for i in range(len(copy(a:modifiedCsprojs)))
		let csproj = a:modifiedCsprojs[i]
		call CascadeBuild(csproj, csprojsWithNbOccurrences, a:reverseDependencyTree, scratchbufnr, a:modifiedClasses, '', a:sln, a:buildAndTestJobs)
	endfor
endfunction

if !empty(glob($rce))
	source $rce
endif

function! GetCurrentTimestamp()
	return str2nr(system(printf('"%s/date" +%%s', g:rc.gtools)))
endfunction

function! GetAdosProjectNameAndIdMapping()
	let g:adosProjects = get(g:, 'adosProjects', BuildAdosProjectNameAndIdMapping())
	if empty(g:adosProjects)
		let g:adosProjects = BuildAdosProjectNameAndIdMapping()
	endif
	return g:adosProjects
endfunction

function! BuildAdosProjectNameAndIdMapping()
	let cmd = printf('curl -s --location -u:%s "%s/_apis/projects?api-version=5.0"', g:rc.env.pat, g:rc.env.ados)
	let cmd .= ' | jq "[.value[]|{id: .id, name: .name}]"'
	let v = system(cmd)
	let v = substitute(v, '[\x0]', '', 'g')
	let v = json_decode(v)
	let dict = {}
	for i in range(len(v))
		let dict[v[i].id] = v[i].name
	endfor
	return dict
endfunction

function! GetAdosRepositoriesNameAndIdMapping()
	let g:adosRepositories = get(g:, 'adosRepositories', BuildAdosRepositoriesNameAndIdMapping())
	if empty(g:adosRepositories)
		let g:adosRepositories = BuildAdosRepositoriesNameAndIdMapping()
	endif
	return g:adosRepositories
endfunction

function! BuildAdosRepositoriesNameAndIdMapping()
	let cmd = printf('curl -s --location -u:%s "%s/%s/_apis/git/repositories?api-version=5.0"', g:rc.env.pat, g:rc.env.ados, g:rc.env.adosSourceProject)
	let cmd .= ' | jq "[.value[]|{id: .id, name: .name}]"'
	let v = system(cmd)
	let v = substitute(v, '[\x0]', '', 'g')
	let v = json_decode(v)
	let dict = {}
	for i in range(len(v))
		let dict[v[i].id] = v[i].name
	endfor
	return dict

endfunction

function! ParseVsTfsUrl(url)
	let parsed = {}
	let ids = split(a:url, '/')[-1]
	let ids = split(ids, '%2F')
	let parsed.project = GetAdosProjectNameAndIdMapping()[ids[0]]
	let parsed.repository = GetAdosRepositoriesNameAndIdMapping()[ids[1]]
	if len(ids) > 2
		let parsed.id = ids[2]
	endif
	return parsed
endfunction

function! BuildAdosWorkItemUrl(...)
	let workItemId = a:0 ? a:1 : get(g:, 'previousWorkItemId')
	return printf('%s/_workitems/edit/%d', g:rc.env.ados, workItemId)
endfunction
command! -nargs=? -complete=customlist,GetWorkItemsAssignedToMeInCurrentIteration AdosWorkItem exec 'WebBrowser' BuildAdosWorkItemUrl(str2nr(<f-args>))

function! BuildAdosWorkItemParentUrl(...)
	let workItemId = a:0 ? a:1 : get(g:, 'previousWorkItemId')
	let cmd = printf(
		\'curl -s --location -u:%s "%s/_apis/wit/workitems/%s?api-version=5.0&$expand=relations" | jq ".relations[] | select (.attributes.name == \"Parent\").url"',
		\g:rc.env.pat,
		\g:rc.env.ados,
		\workItemId
	\)
	let v = substitute(system(cmd), '[\x0]', '', 'g')
	let v = trim(v, '"')
	let id = split(v, '/')[-1]
	return printf('%s/_workitems/edit/%d', g:rc.env.ados, id)
endfunction
command! -nargs=? -complete=customlist,GetWorkItemsAssignedToMeInCurrentIteration AdosParentItem exec 'WebBrowser' BuildAdosWorkItemParentUrl(str2nr(<f-args>))

function! BuildAdosKanbanBoardUrl()
	return g:rc.env.adosBoard
endfunction

function! BuildAdosPipelineOrBuildUrl()
	return g:rc.env.adosDeploymentPipeline
endfunction

function! BuildAdosLatestPullRequestWebUrl(...)
	let workItemId = a:0 ? a:1 : get(g:, 'previousWorkItemId')
	let cmd = printf(
		\'curl -s --location -u:%s "%s/_apis/wit/workitems/%s?api-version=5.0&$expand=relations" | jq "[.relations[] | select (.attributes.name == \"Pull Request\")] | max_by(.attributes.resourceCreatedDate).url"',
		\g:rc.env.pat,
		\g:rc.env.ados,
		\workItemId
	\)
	let vstfsUrl = substitute(system(cmd), '[\x0]', '', 'g')
	let vstfsUrl = trim(vstfsUrl, '"')
	let infos = ParseVsTfsUrl(vstfsUrl)
	let webUrl = printf('%s/%s/_git/%s/pullrequest/%s', g:rc.env.ados, infos.project, infos.repository, infos.id)
	return webUrl
endfunction
command! -nargs=? -complete=customlist,GetWorkItemsAssignedToMeInCurrentIteration AdosPullRequest exec 'WebBrowser' BuildAdosLatestPullRequestWebUrl(str2nr(<f-args>))

function! LocListToAdosBuilds()
	let repository = fnamemodify(GetNearestParentFolderContainingFile('.git'), ':t')
	let matchingRepositories = keys(filter(copy(GetAdosRepositoriesNameAndIdMapping()), {x,y -> stridx(y, repository) >=0}))
	if empty(matchingRepositories)
		echomsg repository 'is not a known repository on azuredevops.'
		return
	endif
	let matchingRepository = matchingRepositories[0]
	let cmd = printf(
		\'curl -s --location -u:%s "%s/%s/_apis/build/builds?requestedFor=Minh-Tam%%20Tran&repositoryType=TfsGit&repositoryId=%s&maxBuildsPerDefinition=5&queryOrder=startTimeDescending&api-version=5.0" | jq "[.value[] | {name:.buildNumber, status, result, url:._links.web.href, startTime, id}]"',
		\g:rc.env.pat,
		\g:rc.env.ados,
		\g:rc.env.adosProject,
		\matchingRepositore

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
	nnoremap <silent> <buffer> i :exec 'WebBrowser' b:urls[line('.')-1]<CR>
	nnoremap <silent> <buffer> o :exec 'WebBrowser' g:rc.env.mainBuildUrl<CR>
endfunction
command! AdosBuilds call LocListToAdosBuilds()
"nnoremap <Leader>A :AdosBuilds<CR>

function! BuildRepositoryPullRequestsWebUrl(...)
	return printf('%s/%s/_git/%s/pullrequests?_a=mine', g:rc.env.ados, g:rc.env.adosSourceProject, g:rc_context.repoName)
endfunction

function! GetWorkItemsAssignedToMeInCurrentIteration(...)
		try
			let cmd = printf('curl -s --location -u:%s "%s/%s/_apis/wit/wiql/%s" | jq "[.workItems[].id]"', g:rc.env.pat, g:rc.env.ados, g:rc.env.adosProject, g:rc.env.adosMyAssignedActiveWits)
			let v = system(cmd)
			let ids= js_decode(substitute(v, '[\x0]', '', 'g'))
			let list = js_decode(substitute(system(printf('curl -s --location -u:%s "%s/%s/_apis/wit/workitems?ids=%s&api-version=5.0" | jq "[.value[]|{id, title: .fields[\"System.Title\"], status: .fields[\"System.State\"], type: .fields[\"System.WorkItemType\"]}]"', g:rc.env.pat, g:rc.env.ados, g:rc.env.adosProject, join(ids, ','))), '[\x0]', '', 'g'))
			return map(list, {_,x -> printf('%s {%s-%s:%s}', x.id, x.type, x.status, x.title)})
		catch
			return []
		endtry
	endif
endfunction

function! LocListAdos(...)
	let workItemId = a:0 ? a:1 : get(g:, 'previousWorkItemId', 0)
	if workItemId == 0
		echomsg 'Invalid workItemId.'
	endif
	let g:previousWorkItemId = workItemId
	let existingLocLists = filter(map(tabpagebuflist(), {_,x -> {'bufnr':x, 'qftitle': getbufvar(x, 'quickfix_title', '')}}), {_,x -> x.qftitle =~'^wit#'})
	for i in range(len(existingLocLists))
		exec existingLocLists[i].bufnr.'bdelete'
	endfor
	let repository = fnamemodify(GetNearestParentFolderContainingFile('.git'), ':t')
	let items={
		\'Task':		      { 'order': 1, 'urlBuilder': function ('BuildAdosWorkItemUrl', [workItemId])},
		\'Parent':	      { 'order': 2, 'urlBuilder': function ('BuildAdosWorkItemParentUrl', [workItemId])},
		\'Kanban Board':	      { 'order': 3, 'urlBuilder': function ('BuildAdosKanbanBoardUrl')},
		\'Latest Pull Request': { 'order': 4, 'urlBuilder': function ('BuildAdosLatestPullRequestWebUrl', [workItemId])},
		\'My Pull Requests':	{ 'order': 5, 'urlBuilder': function ('BuildRepositoryPullRequestsWebUrl', [repository])},
		\'Deployment':	      { 'order': 6, 'urlBuilder': function ('BuildAdosPipelineOrBuildUrl')}
	\}
	exec len(items).'new'
	let b:urlBuilders = items
	set winfixheight
	silent put! =sort(keys(items), {a,b -> items[a].order - items[b].order})
	normal! Gddgg
	let b:is_custom_loclist = 1
	let b:quickfix_title = 'wit#'.filter(GetWorkItemsAssignedToMeInCurrentIteration(), {_,x -> x =~ '^'.workItemId})[0]
	set ft=qf bt=nofile
	nnoremap <silent> <buffer> i :exec 'WebBrowser' eval("b:urlBuilders[getline('.')].urlBuilder()")<CR>:q<CR>
	nnoremap <silent> <buffer> t :exec 'WebBrowser' eval("b:urlBuilders[getline(".b:urlBuilders['Task'].order.")].urlBuilder()")<CR>:q<CR>
	nnoremap <silent> <buffer> p :exec 'WebBrowser' eval("b:urlBuilders[getline(".b:urlBuilders['Latest Pull Request'].order.")].urlBuilder()")<CR>:q<CR>
	nnoremap <silent> <buffer> P :exec 'WebBrowser' eval("b:urlBuilders[getline(".b:urlBuilders['My Pull Requests'].order.")].urlBuilder()")<CR>:q<CR>
	nnoremap <silent> <buffer> b :exec 'WebBrowser' eval("b:urlBuilders[getline(".b:urlBuilders['Kanban Board'].order.")].urlBuilder()")<CR>:q<CR>
	nnoremap <silent> <buffer> d :exec 'WebBrowser' eval("b:urlBuilders[getline(".b:urlBuilders['Deployment'].order.")].urlBuilder()")<CR>:q<CR>
endfunction
nnoremap <silent> <Leader>a :if exists('g:previousWorkItemId') \| call LocListAdos() \| else \| call feedkeys(":Ados \<tab>") \| endif<CR>
command! -nargs=1 -complete=customlist,GetWorkItemsAssignedToMeInCurrentIteration Ados call LocListAdos(str2nr(<f-args>))
nnoremap <Leader>A :Ados <tab>

" Formatting: -------------------------{{{
augroup Formatting
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -
au FileType xml nnoremap <silent> <buffer> <LocalLeader>= :FormatEvenWhenStringified<CR>
au FileType json setlocal equalprg=jq\ .
au FileType json nnoremap <silent> <buffer> <LocalLeader>= :FormatEvenWhenStringified<CR>
augroup end

function! Jq(filter)
	echomsg a:filter
	return
	let lastLineOfLastParagraph = line('$')
	while (getline(lastLineOfLastParagraph) =~ '^\s*$' && lastLineOfLastParagraph >= 1) | let lastLineOfLastParagraph -= 1 | endwhile
	let firstLineOfLastParagraph = lastLineOfLastParagraph
	while (getline(firstLineOfLastParagraph) !~ '^\s*$' && firstLineOfLastParagraph >= 1) | let firstLineOfLastParagraph -= 1 | endwhile
	let firstLineOfLastParagraph += 1
	execute printf('%s,%s!jq "%s"', firstLineOfLastParagraph, lastLineOfLastParagraph, a:filter)
endfunction
command! -nargs=1 -complete=file Jq call Jq(<q-args>)

function! FormatEvenWhenStringified()
	let firstNonEmptyLine = 1
	while(empty(getline(firstNonEmptyLine))) |let firstNonEmptyLine += 1 | endwhile
	let lines = getline(firstNonEmptyLine, '$')
	if empty(lines) | return | endif
	let isString = stridx(trim(lines[0]), '"') == 0
	if isString
		silent normal! gg"vdG
		silent exec "let v = " @v
		silent put!=v | $d
	endif
	silent normal! gg=G
endfunction
command! FormatEvenWhenStringified call FormatEvenWhenStringified()

" Query rows :-------------------------{{{
let g:queryRowHistoryWidth = 48
augroup queryRow
	au!
	autocmd VimEnter *   let g:queryRowHeight = max([min([(&lines-5)/2, 20]), min([(&lines-7)/3, 25])])
	autocmd VimResized * let g:queryRowHeight = max([min([(&lines-5)/2, 20]), min([(&lines-7)/3, 25])])
augroup end

command! ToggleQueryRow if AreQueryRowsActive() | call RemoveSingleOrCurrentQueryRow() | else | call CreateQueryRow() | endif
nnoremap <silent> <Leader>q :ToggleQueryRow<CR>
nnoremap <silent> <Leader>Q :CreateQueryRow<CR>

function! CreateQueryRow()
	let cwd = getcwd()
	silent exec 'botright new' g:rc.queries
	let queryRowId = win_getid()	| call InitQueryRowWindow(queryRowId, cwd, 'query', 'history') | call ResizeAllRowsWindowsAfterCreatingNewRowWindow()
	silent vnew			| call InitQueryRowWindow(queryRowId, cwd, 'query', 'request', 0.5*(&columns-g:queryRowHistoryWidth))
	silent vnew			| call InitQueryRowWindow(queryRowId, cwd, 'query', 'response', 0.5*(&columns-g:queryRowHistoryWidth))
	let historyWinId = GetRowsWinIdsInCurrentTabPage(w:row.id, 'history')[0]
	if getwininfo(historyWinId)[0].botline == 1
		wincmd p
	else
		call win_gotoid(historyWinId)
		normal! gg
		DisplayQueryFilesFromHistoryWindow
		silent wincmd l
	endif
endfunction
command! CreateQueryRow call CreateQueryRow()

function! InitQueryRowWindow(rowId, cwd, rowType, windowContent, ...)
	if has_key(w:, 'row')
		if has_key(w:row, 'payloadEditionBufNr') | unlet! w:row.payloadEditionBufNr | endif
		if has_key(w:row, 'requestEditionBufNr') | unlet! w:row.requestEditionBufNr | endif
		if has_key(w:row, 'requestStructure')    | unlet! w:row.requestStructure    | endif
	else
		let w:row = {
			\'id': a:rowId,
			\'type': a:rowType,
			\'content': a:windowContent,
			\'cwd': a:cwd
		\}
	endif
	if a:0 | exec 'vert resize' a:1 | endif
	set winfixwidth
	set bt=nofile
	if a:windowContent == 'history'
		silent call InitQueryRowHistoryWindow()
	elseif a:windowContent == 'request'
		silent call InitQueryRowRequestWindow()
	elseif a:windowContent == 'response'
		silent call InitQueryRowResponseWindow()
	endif
endfunction

function! InitQueryRowHistoryWindow()
	normal R
	sort!
	let b:dirvish._c = b:changedtick
	nnoremap <silent> <buffer> <C-K> <C-W>l
	nnoremap <silent> <buffer> o :DisplayQueryFilesFromHistoryWindow<CR>
	nmap <silent> <buffer> <C-J> :if (line('$')-line('.')) >= 2 \| normal! '2jo' \| endif<CR>
	nmap <silent> <buffer> <C-K> :if (line('.')-1) >= 2 \| normal! '2ko' \| endif<CR>
	nnoremap <silent> <buffer> <Space> <C-W>l`V
endfunction

function! InitQueryRowRequestWindow()
	set filetype=zsh
	set omnifunc=GetUniversalAutocompletions
	nnoremap <silent> <buffer> <LocalLeader>m :RunQuery<CR>
	nnoremap <silent> <buffer> # :TogglePayloadEditor<CR>
	nnoremap <silent> <buffer> <Space> `V
	nnoremap <silent> <buffer> <C-J> :call MoveCursorInsideWindowAndExecuteCommands(w:row.id, {lnum -> lnum + 2}, 'DisplayQueryFilesFromHistoryWindow')<CR>
	nnoremap <silent> <buffer> <C-K> :call MoveCursorInsideWindowAndExecuteCommands(w:row.id, {lnum -> lnum - 2}, 'DisplayQueryFilesFromHistoryWindow')<CR>
	nnoremap <silent> <buffer> <LocalLeader>q gg"_dG:Snippets<CR>
	exec 'lcd' w:row.cwd
endfunction

function! TogglePayloadEditor()
	if search('--data', 'n') == 0
		echomsg 'Payload not found: keyword "--data" not found in the buffer'
		return
	endif
	let payloadEditionBufnr = get(w:row, 'payloadEditionBufNr', '')
	let w:row.requestEditionBufNr = bufnr()
	let w:row.requestStructure = GetRequestStructure()
	if !empty(payloadEditionBufnr)
		silent exec 'buffer' w:row.payloadEditionBufNr
		return
	endif
	silent enew | set bt=nofile | set ft=json
	silent call setline(1, ConvertRequestPayloadLinesToStringifiedJson(w:row.requestStructure.payload))
	silent FormatEvenWhenStringified
	silent Retab
	let w:row.payloadEditionBufNr = bufnr()
	nnoremap <silent> <buffer> # :ToggleRequestEditor<CR>
	nnoremap <silent> <buffer> <LocalLeader>m :ToggleRequestEditor<CR>:RunQuery<CR>
	nnoremap <silent> <buffer> <C-J> <C-W>h
	nnoremap <silent> <buffer> <C-K> <C-W>l
endfunction
command! TogglePayloadEditor call TogglePayloadEditor()

function! GetRequestStructure()
	let lines = getline(1, '$')
	call search('^\s*--data')
	let currentLine = line('.')
	if (stridx(getline('.'), '{') >= 0)
		silent normal! %
	else
		silent normal! j%
	endif
	let dataFirstLineInZeroBasedIndex = (currentLine + 1) - 1
	let dataEndLineInZeroBasedIndex = line('.')-1
	let payloadPre = lines[0:dataFirstLineInZeroBasedIndex-1]
	let payload = lines[dataFirstLineInZeroBasedIndex:dataEndLineInZeroBasedIndex]
	let payloadPost = lines[dataEndLineInZeroBasedIndex+1:line('$')-1]
	let payloadPreLastChar = matchstr(payloadPre[-1], '.$')
	if (payloadPreLastChar == '{')
		let payload = ['{'] + payload
		let payloadPre[-1] = payloadPre[-1][:-2]
	endif
	if (empty(payloadPost))
		let payloadPost = ['"']
	else
		let payloadPostFirstChar = matchstr(payloadPost[0], '^.')
		if (payloadPostFirstChar != '"')
			let payload[-1] = payload[-1][:-2]
			let payloadPost[0] = '"'.payloadPost[0]
		endif
	endif

	return {
		\'payloadPre': payloadPre,
		\'payload': payload,
		\'payloadPost': payloadPost
	\}
endfunction

function! ConvertRequestPayloadLinesToStringifiedJson(payloadLines)
	let len = len(a:payloadLines)
	if len == 0
		return a:payloadLines
	elseif len == 1
		return [ '"' . a:payloadLines[0] . '"' ]
	else
		return ['"'.a:payloadLines[0]] + a:payloadLines[1:-2] + [a:payloadLines[-1].'"']
	endif
endfunction

function! ConvertJsonToRequestPayload(json)
	return mapnew(a:json, {_,x -> substitute(escape(string(x)[1:-2], '\"'), "''", "'", 'g') })
endfunction

function! ToggleRequestEditor()
	let payload = getline(1, '$')
	let request = w:row.requestStructure
	if !empty(filter(copy(payload), { _,x ->  stridx(x, 'parse error') >= 0 }))
		let payload = request.payload
	endif
	silent call deletebufline(w:row.requestEditionBufNr, 1, '$')
	call setbufline(w:row.requestEditionBufNr, 1, request.payloadPre + ConvertJsonToRequestPayload(payload) + request.payloadPost)
	silent exec 'buffer' w:row.requestEditionBufNr
endfunction
command! ToggleRequestEditor call ToggleRequestEditor()

function! InitQueryRowResponseWindow()
	exec 'lcd' w:row.cwd
	let isCurlDashSmallI = getline(1) =~ '^HTTP/[^ ]\+ \d\{3\} \a\+$'
	let isDbFormatWhenMultipleObjects = (getline(1) =~ '^{ "count": \d\+, "duration": "\d\+ms", "_":\s*$')
	if (isCurlDashSmallI)
		let lastNonSpaceLine = 2
	elseif (isDbFormatWhenMultipleObjects)
		let lastNonSpaceLine = 1
	else
		let lastNonSpaceLine = line('$')
		while lastNonSpaceLine =~ '^\s*$' || lastNonSpaceLine != 1
			let lastNonSpaceLine -= 1
		endwhile
	endif
	let isXml = getline(lastNonSpaceLine) =~ '^<.*>$'
	let isJson = getline(lastNonSpaceLine) =~ '^\({\|\[\|}\|]\)'
	if isXml
		set ft=xml
	elseif isJson
		set ft=jsonc
	endif
	nnoremap <silent> <buffer> <Space> <C-W>h`V
	nnoremap <silent> <buffer> <C-J> :call MoveCursorInsideWindowAndExecuteCommands(w:row.id, {lnum -> lnum + 2}, 'DisplayQueryFilesFromHistoryWindow')<CR>
	nnoremap <silent> <buffer> <C-K> :call MoveCursorInsideWindowAndExecuteCommands(w:row.id, {lnum -> lnum - 2}, 'DisplayQueryFilesFromHistoryWindow')<CR>
endfunction

function! RemoveSingleOrCurrentQueryRow()
	let rowsWindows = GetRowsWinNrsInCurrentTabPage()
	if(len(rowsWindows) <= 3)
		while !empty(rowsWindows)
			exec rowsWindows[0].'wincmd c'
			let rowsWindows = GetRowsWinNrsInCurrentTabPage()
		endwhile
		call ResizeAllRowsWindowsAfterRemovingRowWindow()
	elseif index(rowsWindows, winnr()) >= 0
		let currentWindowRowId = w:row.id
		let currentRowWindows = GetRowsWinNrsInCurrentTabPage(currentWindowRowId)
		while !empty(currentRowWindows)
			exec currentRowWindows[0].'wincmd c'
			let currentRowWindows = GetRowsWinNrsInCurrentTabPage(currentWindowRowId)
		endwhile
		call ResizeAllRowsWindowsAfterRemovingRowWindow()
	endif
endfunction

function! GetRowsWinNrsInCurrentTabPage(...)
	if !a:0
		return map(GetRowsWinIdsInCurrentTabPage(), 'win_id2win(v:val)')
	elseif a:0 == 1 && type(a:1) == type(1)
		let historyWindowId = a:1
		return map(GetRowsWinIdsInCurrentTabPage(historyWindowId), 'win_id2win(v:val)')
	elseif a:0 == 1 && type(a:1) == type('a')
		let rowWindowContentType = a:1
		return map(GetRowsWinIdsInCurrentTabPage(rowWindowContentType), 'win_id2win(v:val)')
	elseif a:0 == 2 && type(a:1) == type(1) && type(a:2) == type('a')
		let historyWindowId = a:1
		let rowWindowContentType = a:2
		return map(GetRowsWinIdsInCurrentTabPage(historyWindowId, rowWindowContentType), 'win_id2win(v:val)')
	endif
endfunction

function! GetRowsWinIdsInCurrentTabPage(...)
	let Filter = { _,x -> has_key(getwininfo(x)[0].variables, 'row') }
	if (a:0 == 1 && type(a:1) == type(0))
		let historyWindowId = a:1
		let Filter = { _,x -> has_key(getwininfo(x)[0].variables, 'row') && getwininfo(x)[0].variables.row.id == historyWindowId }
	elseif (a:0 == 1 && type(a:1) == type('a'))
		let rowWindowContentType = a:1
		let Filter = { _,x -> has_key(getwininfo(x)[0].variables, 'row') && getwininfo(x)[0].variables.row.content == rowWindowContentType }
	elseif (a:0 == 2 && type(a:1) == type(0) && type(a:2) == type('a'))
		let historyWindowId = a:1
		let rowWindowContentType = a:2
		let Filter = { _,x -> has_key(getwininfo(x)[0].variables, 'row') && getwininfo(x)[0].variables.row.id == historyWindowId && getwininfo(x)[0].variables.row.content == rowWindowContentType }
	endif
	return filter(map(range(1, winnr('$')), 'win_getid(v:val)'), Filter)
endfunction

function! AreQueryRowsActive()
	return !empty(GetRowsWinIdsInCurrentTabPage())
endfunction

function! ResizeAllRowsWindowsAfterCreatingNewRowWindow(...)
	let rowsWindowsThatNeedsResizing = sort(GetRowsWinNrsInCurrentTabPage('history'), 'n')
	if empty(rowsWindowsThatNeedsResizing) | return | endif
	let windowBeforeFirstRow = rowsWindowsThatNeedsResizing[0] - 1
	exec windowBeforeFirstRow.'resize -'.(1 + g:queryRowHeight)
	for winnr in rowsWindowsThatNeedsResizing | exec winnr.'resize' g:queryRowHeight | endfor
endfunction

function! ResizeAllRowsWindowsAfterRemovingRowWindow(...)
	let rowsWindowsThatNeedsResizing = sort(GetRowsWinNrsInCurrentTabPage('history'), 'n')
	if empty(rowsWindowsThatNeedsResizing) | return | endif
	let windowBeforeFirstRow = rowsWindowsThatNeedsResizing[0] - 1
	exec windowBeforeFirstRow.'resize +'.(1 + g:queryRowHeight)
	for winnr in rowsWindowsThatNeedsResizing | exec winnr.'resize' g:queryRowHeight | endfor
endfunction

function! RunQuery()
	let requestLines = BuildRequestLinesFromCurrentBuffer()
	if requestLines[0] =~ '^curl'
		let requestLines[0] = EncodeUrl(requestLines[0])
	endif
	let title = BuildQueryTitle(requestLines)
	let queryFilenameWithoutExtension = BuildQueryOutputFilenameWithoutExtension(title)
	let shouldWipeOut = BufferIsEmpty()
	enew
	if shouldWipeOut
		silent! bwipeout! #
	endif
	call InitQueryRowRequestWindow()
	mark V
	silent pu!=requestLines | silent exec 'saveas' (queryFilenameWithoutExtension . '.script')
	call InitQueryRowWindow(w:row.id, w:row.cwd, 'query', w:row.content)
	let request = join(map(map(requestLines, 'ExpandEnvironmentVariables(v:val)'), 'EscapeBatchCharactersAsInBatchFile(v:val)'))
	echomsg request
	redraw | echomsg printf("❓ %s...", fnamemodify(queryFilenameWithoutExtension, ':t:r')[len('YYYY-MM-DD-ddd '):])
	let s:job = job_start(BuildCommandToRunAsJob(request), BuildQueryRowJobOptions(w:row, queryFilenameWithoutExtension))
endfunction
command! RunQuery call RunQuery()

function! EncodeUrl(lineWithUrl)
		let firstSlash = stridx(a:lineWithUrl, '$')
		if (firstSlash == -1)
			return a:lineWithUrl
		endif
		let nextCurlArg = stridx(a:lineWithUrl,' -', firstSlash)
		let modifiableUrlPart = (nextCurlArg == -1)
			\? a:lineWithUrl[firstSlash:]
			\: a:lineWithUrl[firstSlash:nextCurlArg]

		let encodedModifiableUrlPart = modifiableUrlPart
		let encodedModifiableUrlPart = substitute(encodedModifiableUrlPart, ' ', '%20', 'g')
		let encodedModifiableUrlPart = substitute(encodedModifiableUrlPart, 'é', '%C3%A9', 'g')
		let encodedModifiableUrlPart = substitute(encodedModifiableUrlPart, 'è', '%C3%A8', 'g')
		let encodedModifiableUrlPart = substitute(encodedModifiableUrlPart, 'à', '%C3%A0', 'g')
		let encodedModifiableUrlPart = substitute(encodedModifiableUrlPart, 'ù', '%%C3%B9', 'g')
		let encodedModifiableUrlPart = substitute(encodedModifiableUrlPart, 'ê', '%C3%AA', 'g')

		return (nextCurlArg == -1)
			\? a:lineWithUrl[:firstSlash-1] .. encodedModifiableUrlPart
			\: a:lineWithUrl[:firstSlash-1] .. encodedModifiableUrlPart .. a:lineWithUrl[nextCurlArg:]
endfunc
function! BuildRequestLinesFromCurrentBuffer()
	let requestLines = getbufline(bufnr(), 1, '$')
	call map(requestLines, 'v:val')
	call filter(requestLines, 'stridx(v:val, ''#'') != 0')
	call filter(requestLines, 'v:val !~ ''^\s*$''')
	return requestLines
endfunction

function! EscapeBatchCharactersAsInBatchFile(script)
	let script = a:script
	" 👇 https://www.robvanderwoude.com/escapechars.php
	"let script = substitute(script, '%', '%%', 'g')
	let script = substitute(script, '\^', '^^', 'g')
	let script = substitute(script, '&', '^&', 'g')
	let script = substitute(script, '<', '^<', 'g')
	let script = substitute(script, '>', '^>', 'g')

	let hasBothPipesToEscapeAndToUseWithoutEscaping = (stridx(script, '👉') >= 0)
	if hasBothPipesToEscapeAndToUseWithoutEscaping
	let script = substitute(script, '|', '^|', 'g')
	let script = substitute(script, '👉',  '|', 'g') " 👈  allow pipes in requests using a special character
	endif

	let script = substitute(script, "'", "^'", 'g')
	return script
endfunction

function! ExpandEnvironmentVariables(script)
	let mayHaveEnvironmentVars = (stridx(a:script, '$') > -1)
	if (!mayHaveEnvironmentVars) | return a:script | endif
	let script = a:script
	let environmentvars = sort(items(environ()), {a,b -> len(b[0]) - len(a[0])})
	for [key, value] in environmentvars
		if len(key) == 1
		 continue
		endif
		let var = '$'.key
		if (stridx(script, var) == -1)
			continue
		endif
		if (StringStartsWith(value, '[TO-FETCH-USING] '))
			let fetchCommand = value[len('[TO-FETCH-USING] '):]
			let fetchedValue = substitute(system(fetchCommand), '[\x0]', '', 'g')
			execute(printf('let %s = ''%s''', var, substitute(fetchedValue, "'", "''", "g")))
			for i in range(len(g:rc.env.universalAutocompletions))
				let resourceAutocompletion = g:rc.env.universalAutocompletions[i]
				if resourceAutocompletion.word == var
					let resourceAutocompletion.menu = printf('<FETCHED> %s', fetchedValue)
					break
				endif
			endfor
			let script = substitute(script, var, fetchedValue, 'g')
		elseif (StringStartsWith(value, '<FETCHED> '))
			let fetchedValue = value[len('<FETCHED> '):]
			let script = substitute(script, var, fetchedValue, 'g')
		else
			let script = substitute(script, var, value, 'g')
		endif
	endfor
	return script
endfunc

function! BuildCommandToRunAsJob(script)
	if !g:isWindows | echoerr 'Aborting: BuildCommandToRunAsJob currently available only for win32' | endif
	if len(a:script) < 8150 | return 'cmd /C '.a:script | endif
	return printf('%s %s %s',
		\executable('pwsh') ? 'pwsh' : 'powershell',
		\'-NoLogo -NoProfile -NonInteractive -Command remove-item alias:curl;',
		\substitute(substitute(a:script, "'", "`'", 'g'), '"', "'", 'g')
	\)
endfunction

function! BuildQueryRowJobOptions(row, queryFilenameWithoutExtension)
	let scratchbufnr = ResetScratchBuffer(g:rc.desktop.'/tmp/Job_Row_'.a:row.id)
	let historyBufNr = winbufnr(GetRowsWinIdsInCurrentTabPage(a:row.id, 'history')[0])
	let historyBufDirvishDirValue = get(getbufvar(historyBufNr, 'dirvish', {}), '_dir', '')
	return {
		\'cwd': getcwd(),
		\'out_io': 'buffer',
		\'out_buf': scratchbufnr,
		\'out_modifiable': 1,
		\'err_io': 'buffer',
		\'err_buf': scratchbufnr,
		\'err_modifiable': 1,
		\'in_io': 'null',
		\'close_cb':  function('DisplayQueryJobOutput', [scratchbufnr, historyBufDirvishDirValue, a:queryFilenameWithoutExtension, a:row.id])
	\}
endfunction

function! DisplayQueryJobOutput(bufnr, historyBufDirvishDirValue, queryFilenameWithoutExtension, rowId, channel)
	let responseWindowId = GetRowsWinIdsInCurrentTabPage(w:row.id, 'response')[0]
	call win_gotoid(responseWindowId)
	silent exec 'buffer' a:bufnr
	normal! gg
	if BufferIsEmpty() | call setline(1, 'NO-OUTPUT') | endif
	let firstLine = getline(1)
	let firstLineOfLastParagraph = line('$')
	while (getline(firstLineOfLastParagraph) !~ '^\s*$' && firstLineOfLastParagraph >= 1) | let firstLineOfLastParagraph -= 1 | endwhile
	let firstLineOfLastParagraph += 1
	let isCurlDashSmallI = getline(1) =~ '^HTTP/[^ ]\+ \d\{3\} \a\+$'
	if isCurlDashSmallI
		exec '2,'.(firstLineOfLastParagraph-1).'d'
		let firstLineOfLastParagraph = 2
	endif
	let isXml = getline(firstLineOfLastParagraph) =~ '^<.*>$'
	let isJson = getline(firstLineOfLastParagraph) =~ '^\({\|\[\|}\|]\)'
	let ext = 'output'
	if isXml
		if isCurlDashSmallI
			1d
			silent $!xmllint --format --recover --c14n -
			1pu!=firstLine
		else
			silent $!xmllint --format --recover --c14n -
		endif
		set ft=xml
		let ext = 'xml'
	elseif isJson
		let isDbFormatWhenMultipleObjects = (firstLine =~ '^{ "count": \d\+, "duration": "\d\+ms", "_":\s*$')
		if isDbFormatWhenMultipleObjects
			let lastLine = getline('$')
			1delete
			call setline('$', lastLine[0])
			silent! execute '%!jq "del(.[] .SCRIPT_MISE_A_JOUR_DOCUMENTATION, .[] .COLUMN_DESCRIPTION)"'
			1put!=firstLine
			call setline('$', lastLine)
		elseif isCurlDashSmallI
			1d
			silent! execute '%!jq .'
			1pu!=firstLine
		else
			silent! execute firstLineOfLastParagraph.',$!jq .'
		endif
		set ft=jsonc
		let ext = 'json'
	else
		echomsg printf('Neither xml nor json; first data line= %s', getline(firstLineOfLastParagraph))
	endif
	set bt=
	silent exec 'saveas' printf('%s.%s', a:queryFilenameWithoutExtension, ext)
	call InitQueryRowResponseWindow()
	call InitQueryRowHistoryWindows(a:rowId, a:historyBufDirvishDirValue)
	redraw | echomsg printf("👍 %s --> %s", fnamemodify(a:queryFilenameWithoutExtension, ':t:r')[len('YYYY-MM-DD-ddd '):], getline(1))
endfunction

function! InitQueryRowHistoryWindows(rowId, historyBufDirvishDirValue)
	let historyBufNr = winbufnr(GetRowsWinIdsInCurrentTabPage(a:rowId, 'history')[0])
	let dirvishbufvar = getbufvar(historyBufNr, 'dirvish', {})
	if get(dirvishbufvar, '_dir', '') == a:historyBufDirvishDirValue
		for bufnr in win_findbuf(historyBufNr)
			call win_execute(bufnr, 'call InitQueryRowHistoryWindow()')
		endfor
	endif
endfunction

function! BuildQueryOutputFilenameWithoutExtension(title)
	let date = StrftimeFR('%Y-%m-%d-%A')[:len('YYYY-MM-DD-ddd')-1]
	let index = len(expand(g:rc.queries.'/*.script', v:true, v:true))
	let index +=1
	let displayedEnv = get(g:rc.ctx, 'env', 'no-env')
	if a:title == 'curl'
		return printf('%s/%s %03d %s %s', g:rc.queries, date, index, displayedEnv, a:title)
	else
		return printf('%s/%s %03d %s', g:rc.queries, date, index, a:title)
	endif
endfunction

function! BuildQueryTitle(requestLines)
	let request = join(a:requestLines)
	let spaceIndex = stridx(request, ' ')
	if spaceIndex == -1 | return request | endif
	return request[:spaceIndex-1]
endfunction

function! DisplayQueryFilesFromHistoryWindow()
	let winid = win_getid()
	let queryFiles = ComputeQueryFiles()
	call DisplayQueryFile(queryFiles.request, 'request')
	call DisplayQueryFile(queryFiles.response, 'response')
	call win_gotoid(winid)
endfunction
command! DisplayQueryFilesFromHistoryWindow call DisplayQueryFilesFromHistoryWindow()

function! ComputeQueryFiles()
	let currentFile = GetCurrentLineAsPath()
	let filename = fnamemodify(currentFile, ':t:r')
	if line('.') == 1
		let below = GetNextLineAsPath()
		let pairedFile = (stridx(below, filename) >= 0) ? below : GetPreviousLineAsPath()
	else
		let above = GetPreviousLineAsPath()
		let pairedFile = (stridx(above, filename) >= 0) ? above : GetNextLineAsPath()
	endif
	return (fnamemodify(pairedFile, ':t:e') == 'script')
		\? { 'request': pairedFile, 'response': currentFile }
		\: { 'request': currentFile, 'response': pairedFile }
endfunction

function! DisplayQueryFile(file, content)
	let currentWinId = win_getid()
	let winid = GetRowsWinIdsInCurrentTabPage(w:row.id, a:content)[0]
	let bufferIsEmpty = (line('$', winid) == 1)
	call win_gotoid(winid)
	silent exec (bufferIsEmpty ? '0read' : 'edit') a:file
	call InitQueryRowWindow(w:row.id, w:row.cwd, 'query', a:content)
	normal! gg
	call win_gotoid(currentWinId)
endfunction

" Work environment config: ------------{{{
function! GetUniversalAutocompletions(findstart, base)
	if a:findstart
		if (PreviousCharacter() == '$') | return col('.')-2 | endif
		let currentLine = getline('.')
		let untilCursor = currentLine[:col('.')-1-1]
		let nbOfChars = len(untilCursor)
		let c = 1
		while(c < nbOfChars && untilCursor[nbOfChars-c] =~ '[a-zA-Z_]')
			let c = c+1
			if (untilCursor[nbOfChars-c] == '$')
				break
			endif
		endwhile
		return (untilCursor[nbOfChars-c] == '$')
			\? (nbOfChars-c)
			\: col('.')
	endif
	let filteredAutocompletions = empty(a:base)
		\? g:rc.env.universalAutocompletions
		\: filter(copy(g:rc.env.universalAutocompletions), { i,x-> StringStartsWith(x.word, a:base) })
	let maxWidth = g:rc.env.universalAutocompletionItemMaxWidth
	return mapnew(filteredAutocompletions, { _,x -> { 'word': x.word, 'menu': len(x.menu) > maxWidth ? printf('%s…', x.menu[:maxWidth-len('…')-1]) : x.menu } })
endfunction

augroup resources
	au!
	au BufWritePost $ua source $rce
augroup end

	" Desktop Integration:
" Plugins" ------------------------------------{{{

	function! MinpacInit()
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

	command! -bar MinPacInit call MinpacInit()
	command! -bar MinPacUpdate call MinpacInit()| call minpac#clean()| call minpac#update()

" ---------------------------------------------}}}
" First time" ---------------------------------{{{
if !isdirectory($VIM.'/pack/plugins')
		call system('git clone https://github.com/k-takata/minpac.git ' . $VIM . '/pack/packmanager/opt/minpac')
		call MinpacInit()
		call minpac#update()
		packloadall
	endif
" ---------------------------------------------}}}
" Duplicated/Generated files" -----------------{{{
	augroup duplicatefiles
		au!
		au BufWritePost my_keyboard.ahk exec '!Ahk2Exe.exe /in %:p /out ' . fnameescape($HOME . '/Desktop/tools/myAzertyKeyboard.RunMeAsAdmin.exe')
	augroup end
" ---------------------------------------------}}}

" General:
" Utils" --------------------------------------{{{
let $v = $VIM . '/_vimrc'
let $d = $HOME . '/Desktop'
let $p = $VIM . '/pack/plugins/start/'
let $c = $VIM . '/pack/plugins/start/vim-empower/colors/empower.vim'

function! KeepCurrentWinLine(keys)
	let winLineBefore=winline()
	execute printf('keepjumps normal! %s', a:keys)
	let winLineAfter=winline()
	
	if winLineAfter > winLineBefore
		execute printf("keepjumps silent normal! %d \<C-E>", (winLineAfter-winLineBefore))
	elseif winLineAfter < winLineBefore
		execute printf("keepjumps silent normal! %d \<C-Y>", (winLineBefore-winLineAfter))
	endif
endfunction
" ---------------------------------------------}}}
" Settings" -----------------------------------{{{
syntax on
filetype plugin indent on
language messages English_United states
set novisualbell
set langmenu=en_US.UTF-8
set encoding=utf8
set scrolloff=0
set backspace=indent,eol,start

" Use forward slash when expanding file names
set shellslash

" Backup files
set noswapfile
"set directory=$HOME/Desktop/tmp/vim
set backup
set backupdir=$HOME/Desktop/tmp/vim
set undofile
set undodir=$HOME/Desktop/tmp/vim

set cursorline

set relativenumber
set number

" Indentation & Tabs
set smartindent
set tabstop=1
set shiftwidth=1
nnoremap > >>
nnoremap < <<

command! -bar Spaces2Tabs set noet ts=2 |%retab!

" Leader keys
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
	set guioptions+=c  "console-style dialogs instead of popups
	set guifont=consolas:h11
	set termwintype=conpty

	" Plugin: gvimtweak" -------------------------{{{
	let g:gvimtweak#window_alpha=255 " alpha value (180 ~ 255) default: 245
	let g:gvimtweak#enable_alpha_at_startup=1
	let g:gvimtweak#enable_topmost_at_startup=0
	let g:gvimtweak#enable_maximize_at_startup=1
	let g:gvimtweak#enable_fullscreen_at_startup=1
	nnoremap <silent> ° :GvimTweakToggleFullScreen<CR>
" ---------------------------------------------}}}
	nnoremap <silent> <A-n> :GvimTweakSetAlpha 10<CR>
	nnoremap <silent> <A-p> :GvimTweakSetAlpha -10<CR>
endif
" ---------------------------------------------}}}

" FileTypes:
" vim" ----------------------------------------{{{
	augroup vimfiles
		au!
		au BufEnter *vimrc*,*.vim setlocal foldmethod=expr foldexpr=MyFoldExpr() foldtext=MyFoldText() commentstring=\"\ %s
		autocmd BufEnter *vimrc*,*.vim vnoremap <silent> zf :FoldCreate<CR>
	augroup END
" ---------------------------------------------}}}
" my" -----------------------------------------{{{
	augroup myfiletypedetect
		au!
		autocmd BufRead,BufNewFile my.* setfiletype my
		autocmd BufEnter my.* setlocal foldmethod=expr foldexpr=MyFoldExpr() commentstring=
		autocmd BufEnter my.* vnoremap <silent> zf :FoldCreate<CR>
	augroup END

	function! MyFoldExpr()
		let thisline=getline(v:lnum)
		return thisline =~ '-{{{\s*$' ? 'a1' : thisline =~ '-}}}\s*$' ? 's1' : '='
	endfunction

	function! MyFoldCreate() range
		let last_column_reached = 50
		let comment_string = &commentstring == '' ? '' : split(&commentstring, '%s')[0]
		let title_max_length = last_column_reached-len('{{{')-len(comment_string)-len('-')

		execute string(a:firstline)
		if col('$') > title_max_length
			echoerr 'The first selected line should be smaller than ' . title_max_length
			return
		endif

		execute(printf('normal! A%s%s{{{', comment_string, repeat('-', last_column_reached - len('{{{') - len(comment_string) - col('$') +1)))
		execute(printf("normal! %dGoT\<Esc>", a:lastline))
		execute(printf("normal! A\<BS>%s%s}}}", comment_string, repeat('-', last_column_reached - len(comment_string) - len('}}}') - len('$'))))
	endfunction
	command! -bar -range FoldCreate <line1>,<line2>call MyFoldCreate()

	" Pomodoro file-------------------------------{{{
	function! PomodoroFolds()"--------------------{{{
		let thisline = getline(v:lnum)

		if match(thisline, '^\s*$') >= 0
			return "0"
		endif

		if match(thisline, '^\S') >= 0
			return ">1"
		endif

		return "="
	endfunction
	"---------------------------------------------}}}
	augroup pomodorofiles
		autocmd!
		au BufEnter my.pomodoro setlocal foldmethod=expr
		au BufEnter my.pomodoro setlocal foldexpr=PomodoroFolds()
		au BufEnter my.pomodoro setlocal foldtext=foldtext()
	augroup end
	"---------------------------------------------}}}
	" Notes file----------------------------------{{{
	augroup notesfiles
		autocmd!
		au BufEnter *.notes setlocal foldmethod=marker
	augroup end
"----------------------------------------------}}}
" ---------------------------------------------}}}
" cs(c#)" -------------------------------------{{{
	" omnisharp options" -------------------------{{{
	"let g:OmniSharp_start_server = 0
	"let g:OmniSharp_start_without_solution = 1
	"let g:OmniSharp_loglevel = 'debug'
	let g:OmniSharp_server_stdio = 1
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
" ---------------------------------------------}}}
	let g:fold_levels = []
	function! CsFoldExpr()" ----------------------{{{
		let bufnr=bufnr('%')
		if v:lnum ==1
			let nb_lines = line('$')
			let g:fold_levels = map(range(nb_lines+1), {x-> '='})
			let g:fold_levels[nb_lines] = 0
			let g:fold_levels[nb_lines-1] = 0
			let fold = -2
			let recent_member_declaration = 1
			let pat_member_declaration_beginning                             = '\v^%(' . repeat('\t', 3) . '*|' . repeat('\ ', 2*&tabstop+1) . '*)%(private|protected|public)' 
			let pat_member_declaration_end_if_right_before_another_beginning = '\v%(^.*})|;\s*$'
			let pat_attribute_or_comment                                     = '\v^%(' . repeat('\t', 3) . '*|' . repeat('\ ', 2*&tabstop+1) . '*)%(/|[).*$'

			for i in range(nb_lines-2, 1, -1)
				let line = getline(i)

				if line =~ pat_member_declaration_beginning
					let recent_member_declaration = 1
					if line =~pat_member_declaration_end_if_right_before_another_beginning
						let g:fold_levels[i] = '='
					else
						let g:fold_levels[i] = 'a1'
					endif
				elseif line =~ pat_member_declaration_end_if_right_before_another_beginning && recent_member_declaration
					let g:fold_levels[i] = 's1'
					let recent_member_declaration = 0
				elseif line =~ pat_attribute_or_comment	&& g:fold_levels[i+1] == 'a1'
					let g:fold_levels[i+1] = '='
					let g:fold_levels[i] = 'a1'
				endif
			endfor
	endif

	let res = g:fold_levels[v:lnum]

		return res
	endfunction
" ---------------------------------------------}}}
	function! CsFoldText()" ----------------------{{{
		let titleLineNr = v:foldstart
		let line = getline(titleLineNr)

		while (match(line, '\v^\s+([|\<)') >= 0 && titleLineNr < v:foldend)
			let titleLineNr = titleLineNr + 1
			let line = getline(titleLineNr)
		endwhile

		let ts = repeat(' ',&tabstop)
		"let line = substitute(line, '\t', ts, 'g')
		"let foldsize = v:foldend - v:foldstart + 1
		let foldsize = v:foldend - titleLineNr - 1
		return line . ' [' . foldsize . ' line' . (foldsize > 1 ? 's' : '') . ']'
	endfunction
" ---------------------------------------------}}}
		function! LcdToSlnOrCsproj(...)" ------------{{{
			let omnisharp_host = getbufvar(bufnr('%'), 'OmniSharp_host')
			if empty(omnisharp_host)
				return
			endif
			let srcRoot = fnamemodify(omnisharp_host.sln_or_dir, ':h')
			execute(printf('lcd %s', srcRoot))
		endfunc
" ---------------------------------------------}}}
	augroup csharpfiles
		au!
		autocmd BufEnter *.cs setlocal foldmethod=expr foldexpr=CsFoldExpr() foldtext=CsFoldText()
		autocmd BufEnter *.cs silent call LcdToSlnOrCsproj()
		autocmd BufEnter *.cs setlocal errorformat=\ %#%f(%l\\\,%c):\ %m
		autocmd BufEnter *.cs setlocal makeprg=dotnet\ build\ /p:GenerateFullPaths=true
		autocmd BufEnter *.cs nnoremap <LocalLeader>M :!dotnet run<CR>
		autocmd BufWritePost *.cs OmniSharpFixUsings | OmniSharpCodeFormat
		autocmd FileType cs nnoremap <buffer> ( :OmniSharpNavigateUp<CR>zz
		autocmd FileType cs nnoremap <buffer> ) :OmniSharpNavigateDown<CR>zz
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

	"---------------------------------------------}}}

" AZERTY Keyboard:
" AltGr keys" ---------------------------------{{{
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
" ---------------------------------------------}}}
" Arrows" -------------------------------------{{{
inoremap <C-J> <Left>|  cnoremap <C-J> <Left>|  tnoremap <C-J> <Left>
inoremap <C-K> <Right>| cnoremap <C-K> <Right>| tnoremap <C-K> <Right>
" ---------------------------------------------}}}
" Home,End" -----------------------------------{{{
inoremap ^j <Home>| cnoremap ^j <Home>| tnoremap ^j <Home>
inoremap ^k <End>|  cnoremap ^k <End>|  tnoremap ^k <End>
" ---------------------------------------------}}}
" Backspace,Delete" ---------------------------{{{
tnoremap <C-L> <Del>
inoremap <C-L> <Del>|   cnoremap <C-L> <Del>
" ---------------------------------------------}}}

" Graphical Layout:
" Colorscheme, Highlight groups" --------------{{{
colorscheme empower
nnoremap <LocalLeader>h :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<CR>
nnoremap <LocalLeader>H :OmniSharpHighlightEchoKind<CR>
" ---------------------------------------------}}}
" Buffers, Windows & Tabs" --------------------{{{
set hidden
set splitbelow
set splitright
set previewheight=25
set showtabline=0

" List/Open Buffers
nnoremap <Leader>b :History<CR>
nnoremap <Leader>B :Buffers<CR>

" Close Buffers
function! DeleteHiddenBuffers()"---------------{{{
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
"----------------------------------------------}}}
nnoremap <Leader>c :silent! call DeleteHiddenBuffers()<CR>:ls<CR>

" Open/Close Window or Tab
nnoremap <Leader>s :split<CR>
nnoremap <Leader>v :vsplit<CR>
nnoremap K :q<CR>
nnoremap <Leader>o :let bufnr=bufnr('%')\|tabedit\|cd $d\|call BuildMyLayout(bufnr)<CR>
nnoremap <Leader>O mW:tabnew<CR>`W
nnoremap <silent> <Leader>x :tabclose<CR>
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
function! SwapWindowContents(hjkl_keys)"-------{{{
	mark V
	let originalWinNr = winnr()

	for hjkl_key in split(a:hjkl_keys, '\zs') | silent! execute('wincmd ' . hjkl_key) | endfor
	mark W
	normal! `V

	execute(originalWinNr.'wincmd w')
 normal! `W
	delmarks VW
endfunction
"----------------------------------------------}}}
command! -nargs=1 -bar SwapWindows call SwapWindowContents(<f-args>)
nnoremap SJ :SwapWindows j<CR> | nnoremap SJJ :SwapWindows jj<CR> | nnoremap SJK :SwapWindows jk<CR> | nnoremap SJH :SwapWindows jh<CR> | nnoremap SJL :SwapWindows jl<CR> 
nnoremap SK :SwapWindows k<CR> | nnoremap SKJ :SwapWindows kj<CR> | nnoremap SKK :SwapWindows kk<CR> | nnoremap SKH :SwapWindows kh<CR> | nnoremap SKL :SwapWindows kl<CR>
nnoremap SH :SwapWindows h<CR> | nnoremap SHJ :SwapWindows hj<CR> | nnoremap SHK :SwapWindows hk<CR> | nnoremap SHH :SwapWindows hh<CR> | nnoremap SHL :SwapWindows hl<CR>
nnoremap SL :SwapWindows l<CR> | nnoremap SLJ :SwapWindows lj<CR> | nnoremap SLK :SwapWindows lk<CR> | nnoremap SLH :SwapWindows lh<CR> | nnoremap SLL :SwapWindows ll<CR>

" Position Window
nnoremap <Leader>H <C-W>H
nnoremap <Leader>J <C-W>J
nnoremap <Leader>K <C-W>K
nnoremap <Leader>L <C-W>L
nnoremap <Leader>r <C-W>r

" Resize Window
nnoremap <silent> <A-h> :vert res -2<CR>
nnoremap <silent> <A-l> :vert res +2<CR>
nnoremap <silent> <A-j> :res -2<CR>
nnoremap <silent> <A-k> :res +2<CR>
nnoremap <silent> <A-m> <C-W>=

" Alternate file fast switching
nnoremap <Leader>d :b #<CR>
" ---------------------------------------------}}}
" Status bar" ---------------------------------{{{
set laststatus=2
function! FileSizeAndRows() abort" ------------{{{
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

	return printf('%drows[%s]', rows, size)
endfunction
" ---------------------------------------------}}}
function! MyFilePathIndicator() abort" --------{{{
	let file_path_absolute = expand('%:p')
	let git_path_absolute = fnamemodify(gitbranch#dir(file_path_absolute), ':h')
	
	if git_path_absolute == '.'
		let file_path_relative_to_git_path = expand('%')
		let git_path_indicator = ''
	else
		let file_path_relative_to_git_path = file_path_absolute[len(git_path_absolute)+1:]
		let git_path_indicator = printf('%s[%s/%s]', gitbranch#name(), fnamemodify(git_path_absolute, ':h:t'), fnamemodify(git_path_absolute, ':t'))
	endif

	let path = ''
	if git_path_indicator != ''
		let path.= printf('%s ', git_path_indicator)
	endif

	let current_directory = getcwd()
	let current_directory_filename = fnamemodify(current_directory, ':t')
	if stridx(path, current_directory_filename) == -1
		let path .= printf('%s/%s ', fnamemodify(current_directory, ':h:t'), fnamemodify(current_directory, ':t'))
	endif

	let path.= file_path_relative_to_git_path
	return substitute(path, current_directory_filename, '(&)', '')
endfunction
" ---------------------------------------------}}}
function! MyFilePathIndicatorWithoutPwd()" ----{{{
	let file_path_absolute = expand('%:p')
	let git_path_absolute = fnamemodify(gitbranch#dir(file_path_absolute), ':h')
	
	if git_path_absolute == '.'
		let file_path_relative_to_git_path = expand('%')
		let git_path_indicator = ''
	else
		let file_path_relative_to_git_path = file_path_absolute[len(git_path_absolute)+1:]
		let git_path_indicator = printf('%s[%s/%s]', gitbranch#name(), fnamemodify(git_path_absolute, ':h:t'), fnamemodify(git_path_absolute, ':t'))
	endif

	let path = ''
	if git_path_indicator != ''
		let path.= printf('%s:', git_path_indicator)
	endif

	let path.= file_path_relative_to_git_path
	return path
endfunction
" ---------------------------------------------}}}

let g:lightline = {
	\ 'colorscheme': 'deus',
	\ 'component_function': { 'filesize_and_rows': 'FileSizeAndRows', 'mypathinfo': 'MyFilePathIndicator', 'mypathinfo2': 'MyFilePathIndicatorWithoutPwd' },
	\ 'active': {   'left':  [ [ 'mode', 'paste', 'readonly', 'modified' ], [ 'mypathinfo' ] ],
				\   'right': [ [ 'filesize_and_rows' ] ] },
	\ 'inactive': {   'left':  [  ],
				\   'right': [ [ 'mypathinfo2', 'modified', 'readonly' ] ] }
				\ }
" ---------------------------------------------}}}

" Motions:
" Browsing File Architecture" -----------------{{{
"
function! BrowseLayoutDown()" -----------------{{{
	if &diff
		keepjumps execute 'silent! normal! ]c'
	elseif len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')) > 0
		keepjumps silent! cnext
	else
		keepjumps execute 'silent! normal! }}{j'
	endif
endfunction
" ---------------------------------------------}}}
nnoremap <silent> <C-J> :call BrowseLayoutDown()<CR>

function! BrowseLayoutUp()" -------------------{{{
	if &diff
		keepjumps execute 'silent! normal! [c'
	elseif len(filter(range(1, winnr('$')), 'getwinvar(v:val, "&ft") == "qf"')) > 0
		keepjumps silent! cprev
	else
		keepjumps execute 'silent! normal! {{j'
	endif
endfunction
" ---------------------------------------------}}}
nnoremap <silent> <C-K> :call BrowseLayoutUp()<CR>

" ---------------------------------------------}}}
" Current Line" -------------------------------{{{

function! ExtendedHome()" ---------------------{{{
    let column = col('.')
    normal! ^
    if column == col('.')
        normal! 0
    endif
endfunction
" ---------------------------------------------}}}
nnoremap <silent> <Home> :call ExtendedHome()<CR>
vnoremap <silent> <Home> <Esc>:call ExtendedHome()<CR>mvgv`v
onoremap <silent> <Home> :call ExtendedHome()<CR>

function! ExtendedEnd()" ----------------------{{{
    let column = col('.')
    normal! g_
    if column == col('.') || column == col('.')+1
        normal! $
    endif
endfunction
" ---------------------------------------------}}}
nnoremap <silent> <End> :call ExtendedEnd()<CR>
vnoremap <silent> <End> <Esc>:call ExtendedEnd()<CR>mvgv`v
onoremap <silent> <End> :call ExtendedEnd()<CR>

function! MoveCursorToNext(pattern)" ----------{{{
	let match =	 searchpos(a:pattern, 'z', line('.'))
	call setpos('.', match)
endfunction
" ---------------------------------------------}}}
function! MoveCursorToLast(pattern)" ----------{{{
	let match = searchpos(a:pattern, 'bz', line('.'))
	call setpos('.', match)
endfunction
" ---------------------------------------------}}}
" nnoremap <silent> Ö :call MoveCursorToNext('\d')<CR>
" nnoremap <silent> Ü :call MoveCursorToNext('A-Z')<CR>
" nnoremap <silent> Ï :call MoveCursorToNext('_')<CR>
" ---------------------------------------------}}}
" Text objects" -------------------------------{{{

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

" ---------------------------------------------}}}
" Jump list" ----------------------------------{{{

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

" ---------------------------------------------}}}

" Text Operations:
" Visualization" ------------------------------{{{

" Current, trimmed line
nnoremap vv ^vg_

" Last inserted text
nnoremap vI `[v`]h

" ---------------------------------------------}}}
" Copy & Paste" -------------------------------{{{

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
cnoremap <C-V> <C-R>+| inoremap <C-C> <C-V>
tnoremap <C-V> <C-W>"+

" Cursor position after yanking in Visual mode
vnoremap gy y`]

" Allow pasting several times when replacing visual selection
vnoremap p "0p
vnoremap P "0P

" Select the text that was pasted
nnoremap <expr> vp '`[' . strpart(getregtype(), 0, 1) . '`]'

" ---------------------------------------------}}}
" Macros and Repeat-Last-Action" --------------{{{

" Repeat last action
nnoremap ù .

" Record macro
nnoremap <Leader>m q

" Replay macro
nnoremap à @@

" Repeat last Ex command
nnoremap . @:

" ---------------------------------------------}}}
" Whitespace characters Handler" --------------{{{
set listchars=tab:▸\ ,eol:¬,extends:>,precedes:<
set list
" ---------------------------------------------}}}
" Vertical Alignment" -------------------------{{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" ---------------------------------------------}}}

" Vim Functionalities:
" Wild Menu" ----------------------------------{{{

set wildmenu
set wildcharm=<Tab>
set wildignorecase
set wildmode=full

function! EnterSubdir()"-----------------------{{{
    call feedkeys("\<Down>", 't')
    return ''
endfunction
"----------------------------------------------}}}
cnoremap <expr> j (wildmenumode() == 1) ? EnterSubdir() : "j"

function! MoveUpIntoParentdir()"---------------{{{
    call feedkeys("\<Up>", 't')
    return ''
endfunction
"----------------------------------------------}}}
cnoremap <expr> k (wildmenumode() == 1) ? MoveUpIntoParentdir() : "k"

cnoremap <expr> h (wildmenumode() == 1) ? "\<s-Tab>" : "h"
cnoremap <expr> l (wildmenumode() == 1) ? "\<Tab>"   : "l"

"cnoremap <expr> <Esc> (wildmenumode() == 1) ? " \<BS>"   : "\<Esc>"
"----------------------------------------------}}}
" Expanded characters" ------------------------{{{

" Folder of current file
cnoremap µ <C-R>=expand('%:p:h')<CR>\

"----------------------------------------------}}}
" Sourcing" -----------------------------------{{{

" Run a line/selected text composed of vim script
vnoremap <silent> <Leader>S y:execute @@<CR>
nnoremap <silent> <Leader>S ^vg_y:execute @@<CR>

" Write output of a vim command in a buffer
nnoremap ç :put=execute('')<Left><Left>

augroup vimsourcing
	au!
	" Prevent screen from redrawing after re-sourcing vimrc
	autocmd BufWritePost _vimrc GvimTweakToggleFullScreen | so % | GvimTweakToggleFullScreen
augroup end

"----------------------------------------------}}}
" Find, Grep, Make, Equal" --------------------{{{

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ $*

nnoremap <Leader>f :Files <C-R>=fnamemodify('.', ':p')<CR><CR>
nnoremap <Leader>F :Files <C-R>=fnamemodify('.', ':p')<CR>
nnoremap <Leader>g :Agrep --no-ignore-parent  <C-R>=fnamemodify('.', ':p')<CR><Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>
vnoremap <Leader>g "vy:Agrep --no-ignore-parent  <C-R>=fnamemodify('.', ':p')<CR><Home><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><C-R>v
nnoremap <LocalLeader>m :Amake<CR>

"----------------------------------------------}}}
" Registers" ----------------------------------{{{

command! ClearRegisters for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

"----------------------------------------------}}}
" Terminal" -----------------------------------{{{

set termwinsize=12*0

tnoremap <C-s>h <C-W>h
tnoremap <C-s>j <C-W>j
tnoremap <C-s>k <C-W>k
tnoremap <C-s>l <C-W>l

" The following line breaks fugitive.vim
" set shell=powershell\ -NoLogo



" Delete last word while typing a command line
tnoremap <C-W><C-W> <C-W>.

"----------------------------------------------}}}
" Folding" ------------------------------------{{{

nnoremap <silent> zj :keepjumps execute 'silent! normal! zczjztkzCkzC2jzO'<CR>
nnoremap <silent> zk :keepjumps execute 'silent! normal! zczk[zkztkzCkzC2jzO'<CR>

function! MyFoldText()" -----------------------{{{
	let line = getline(v:foldstart)
	let foldedlinecount = v:foldend - v:foldstart - 1
	let end_of_title = stridx(line, (&commentstring == '' ? '-' : split(&commentstring, '%s')[0]), match(line, '\a'))-1

	return printf('%s%s%d', line[:end_of_title], repeat('-', winwidth(0) - &foldcolumn - &number*&numberwidth - len(string(foldedlinecount))), foldedlinecount)

endfunction
" ---------------------------------------------}}}
set foldtext=MyFoldText()

nnoremap <silent> zr :call KeepCurrentWinLine('zr')<CR>
nnoremap <silent> zR :call KeepCurrentWinLine('zR')<CR>
nnoremap <silent> zm :call KeepCurrentWinLine('zm')<CR>
nnoremap <silent> zM :call KeepCurrentWinLine('zM')<CR>

" Toggle current fold
nnoremap <silent> <Space> :silent! call KeepCurrentWinLine('za')<CR>

" Close all folds except the one cursor is in
nnoremap <silent> zo :call KeepCurrentWinLine('zMzv')<CR>

"----------------------------------------------}}}
" Search" -------------------------------------{{{
set hlsearch
set incsearch
set ignorecase

" Display '1 out of 23 matches' when searching
set shortmess=filnxtToO

nnoremap ! :call KeepCurrentWinLine('zR')<CR>/
nnoremap q! q/
nnoremap z! :call :BLines <C-R>=split(&foldmarker, ",")[0]<CR><CR>
" Display current cursor position in red (error color) for more visibility

function! HLNext (blinktime)"------------------{{{
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction
"----------------------------------------------}}}
nnoremap <silent> n :silent! call execute('keepjumps normal! n') \| call KeepCurrentWinLine('zMzv')\| call HLNext(0.15)<cr>
nnoremap <silent> N :silent! call execute('keepjumps normal! N') \| call KeepCurrentWinLine('zMzv')\| call HLNext(0.15)<cr>

" search selected text
vnoremap * "vy/\V<C-R>v\C<cr>:call KeepCurrentWinLine('zMzv')\| call HLNext(0.15)<cr>
"----------------------------------------------}}}
" Autocompletion (Insert Mode)" ---------------{{{

" <Enter> confirms selection
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" <Esc> cancels popup menu
inoremap <expr> <Esc> pumvisible() ? "\<C-E>" : "\<Esc>"

" <C-N> for omnicompletion, <C-P> for context completion
inoremap <expr> <C-N> pumvisible() ? "\<C-N>" : "\<C-X>\<C-O>"

"----------------------------------------------}}}
" Diff" ---------------------------------------{{{

set diffopt+=algorithm:histogram,indent-heuristic

augroup diff
	au!
	au OptionSet diff let &cursorline=!v:option_new
augroup end

"----------------------------------------------}}}
" Calculator" ---------------------------------{{{

inoremap <C-B> <C-O>yiW<End>=<C-R>=<C-R>0<CR>

"----------------------------------------------}}}
" QuickFix window" ----------------------------{{{

" Always show at the bottom of other windows
augroup quickfix
	au!
	autocmd QuickFixCmdPost [^l]* nested cwindow
	autocmd FileType qf wincmd J
augroup end

" Automatically open, but do not go to (if there are errors).Also close it when is has become empty.

"----------------------------------------------}}}
" Preview window--" ---------------------------{{{

" Close preview window on leaving the insert mode
augroup autocompletion
	autocmd!
	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end

"----------------------------------------------}}}
" Location window" ----------------------------{{{

" Automatically open, but do not go to (if there are errors).Also close it when is has become empty.
autocmd QuickFixCmdPost	l* nested lwindow

"----------------------------------------------}}}

" Additional Functionalities:
" My Layout" ----------------------------------{{{

function! BuildMyLayout(...) abort" -----------{{{
	if a:0 > 3
		echoerr 'Too many arguments (' . a:0 . ') for BuildMyLayout'
		return
	endif
	
	if winnr('$') != 1
		echoerr 'Use this function only in a tab that has only one window. Maybe use `:tabnew` before?'
		return
	endif
	
	lcd $d

	if exists ('a:2')
		let commandTemplate = type(a:2) == type(0) ? 'buffer #%d' : 'buffer %s'
		silent execute(printf(commandTemplate, a:2))
	endif
	silent vertical 50split my.resources| split my.happyzone | split my.drivenzone | split my.knowledge | wincmd k | wincmd k | wincmd k | resize 12 | wincmd j | resize 12 | wincmd j | resize 12 |wincmd h 
	
	let bigHeight= &lines-9
	if !exists('a:1')
		execute(printf('%dnew', bigHeight)) 
	else
		let commandTemplate = type(a:1) == type(0) ? '%dnew #%d' : '%dnew %s'	
		silent execute(printf(commandTemplate, bigHeight, a:1))
	endif
	silent wincmd k | resize 9 

	if !exists('a:3')
		98vnew
	else
		let commandTemplate = type(a:3) == type(0) ? 'vertical 98new #%d' : 'vertical 98new %s'	
		silent execute(printf(commandTemplate, a:3))
	endif

	silent wincmd h | wincmd j
endfunction
" ---------------------------------------------}}}
command! -bar Layout call BuildMyLayout(<f-args>)

function! ResizeLayoutWithSideBanner()" -------{{{
	let current_pos = getpos('.')
	wincmd l | wincmd l | wincmd l | vertical resize 50
	wincmd h | wincmd k | wincmd h | vertical resize 98 | resize 9

	call setpos('.', current_pos)
endfunction
" ---------------------------------------------}}}
command! -bar ResizeLayoutWithSideBanner call ResizeLayoutWithSideBanner()

" ---------------------------------------------}}}
" Time & Tab Info" ----------------------------{{{

let g:zindex = 50
function! DisplayPopupTime(...)" --------------{{{
	if empty(prop_type_get('time'))
		call prop_type_add('time', #{highlight: 'PopupTime'})
	endif

	let text = printf('%s  %s  %s', printf('[Tab%s(%s)]', tabpagenr(), tabpagenr('$')), strftime('%A %d %B'), strftime('[%Hh%M]'))
	let text_length = len(text)
	call popup_create([#{text: text, props:[#{type: 'time', col:1, end_col:1+text_length}]}], #{time:20000, line:&lines+2, col:&columns + 1 - text_length, zindex:g:zindex})
endfunction
" ---------------------------------------------}}}
augroup timedisplay
	au!
	autocmd VimEnter * call DisplayPopupTime() | let t = timer_start(20000, 'DisplayPopupTime', {'repeat':-1})
	autocmd TabLeave,TabEnter * let g:zindex+=1 | call DisplayPopupTime()
augroup end

" ---------------------------------------------}}}
" Pomodoro" -----------------------------------{{{
let preparation_ms = 5000 * 60
let pomodoro_session_ms = 10000 *60
let pomodoro_break_ms = 5000" *60
let nb_pomodoros_in_a_day = 24
let g:current_cycle_nr = 0

function! DisplayPopupPomodoro(title, ...)" ----------{{{
	if empty(prop_type_get('time')) | call prop_type_add('time', #{highlight: 'PopupTime'}) | endif

	let content = [strftime('[%Hh%M] - %A %d %B'), ''] + a:000 + ['', 'La petite citation du jour:', printf('  %s', qotd#getquoteoftheday())]
	call popup_create(
		\ content,
		\ { 
		\ 'title': printf(' %s ', a:title),
		\ 'close':'button',
		\ 'zindex':g:zindex,
		\ 'highlight':'Normal',
		\ 'border':[],
		\ 'borderhighlight':repeat(['csharpClassName'], 4),
		\ 'padding':[1,1,1,2]
		\ }
	\)

	let g:zindex+=1
endfunction
" --------------------------------------------}}}
function! DisplayPomodoroIntroduction()" ------{{{
	call DisplayPopupPomodoro(
		\ 'Un nouveau soleil se lève...',
		\ 'Bonjour :D',
		\ '',
		\ "Essayons d'avoir une journée productive!",
		\ '',
		\ "L'objectif est de gérer notre énergie cognitive en ne se perdant pas dans un sujet trop longtemps!",
		\ '',
		\ "Commençons par prendre [5 minutes] pour se mettre dans le bain et planifier les objectifs de la journée :)"
	\)
endfunction
" --------------------------------------------}}}
function! DisplayPomodoroEnding(nb, ...)" -----{{{
	call DisplayPopupPomodoro(
		\ "Le soleil n'ira pas plus haut aujourd'hui!",
		\ 'Maintenant, le plus dur...',
		\ '',
		\ printf("%d pomodoros se sont déroulés aujourd'hui. ", a:nb),
		\ '',
		\ 'Il est temps de faire autre chose !! :)',
		\ '',
		\ "Ressource tes énergies pour demain au lieu de forcer dessus pour rien!"
		\)
endfunction
" --------------------------------------------}}}
function! DisplayPomodoroSessionStart(cycle_nr, nb_pomodoros_in_a_day, ...)" ---{{{
	call DisplayPopupPomodoro(
		\ printf('[%d/%d] Une nouvelle session démarre...', a:cycle_nr, a:nb_pomodoros_in_a_day),
		\ 'Tu viens de passer 5 minutes complètes à te préparer à te re-concentrer sur un problème.',
		\ '',
		\ 'Il est temps de passer [25 minutes] sur un nombre restreint de problèmes sans dérangement!'
	\)
endfunction
" --------------------------------------------}}}
function! DisplayPomodoroBreakStart(cycle_nr, nb_pomodoros_in_a_day, ...)" -----{{{
	call DisplayPopupPomodoro(
		\ printf('[%d/%d] Fin de la session Pomodoro!', a:cycle_nr, a:nb_pomodoros_in_a_day),
		\ 'Tu viens de passer 25 minutes complètes sur un nombre restreint de problèmes.',
		\ '',
		\ 'Il est temps de passer [5 minutes] sur des choses qui n''ont rien à voir pour te changer les idées! ',
		\ '',
		\ 'Tu as passé suffisamment de moments dans le passé à coder en faisant plein de fautes d''étourderie',
		\ 'pour savoir ce que la qualité de tes implémentations va évoluer sans pause mentale ;)',
		\ '',
		\ 'Je te recommande de commencer par célébrer tes progrès :)'
	\)
endfunction
" --------------------------------------------}}}

function! InitPomodoroDay(preparation_duration, session_duration, break_duration, nb_pomodoros_in_a_day)
	call DisplayPomodoroIntroduction()
	let l:timer_cycles = timer_start(a:preparation_duration, function('StartPomodoroCycles', [a:session_duration, a:break_duration, a:nb_pomodoros_in_a_day]))
	let l:timer_end = timer_start(a:preparation_duration + a:nb_pomodoros_in_a_day * (a:session_duration+a:break_duration), function('DisplayPomodoroEnding', [a:nb_pomodoros_in_a_day]))
endfunction

function! StartPomodoroCycles(session_duration, break_duration, nb_pomodoros_in_a_day, ...)
	call StartPomodoroCycle(a:session_duration, a:nb_pomodoros_in_a_day)
	let l:timer = timer_start(a:session_duration+a:break_duration, function('StartPomodoroCycle', [a:session_duration, a:nb_pomodoros_in_a_day]), {'repeat': a:nb_pomodoros_in_a_day-1})
endfunction

function! StartPomodoroCycle(session_ms, nb_pomodoros_in_a_day, ...)
		let g:current_cycle_nr += 1
		call DisplayPomodoroSessionStart(g:current_cycle_nr, a:nb_pomodoros_in_a_day)
		let l:timer = timer_start(a:session_ms, function('DisplayPomodoroBreakStart', [g:current_cycle_nr, a:nb_pomodoros_in_a_day]))
endfunction

augroup pomodoro
	au!
	autocmd VimEnter * call InitPomodoroDay(preparation_ms, pomodoro_session_ms,pomodoro_break_ms,nb_pomodoros_in_a_day)
augroup end
" ---------------------------------------------}}}
" File explorer (graphical)" ------------------{{{

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

" ---------------------------------------------}}}
" Web Browsing" -------------------------------{{{
function! WeatherInNewTab()" ------------------{{{
	tabnew
	let buf = term_start([&shell, '/k', 'chcp 65001 | start /wait /b curl http://wttr.in'], {'exit_cb': {... -> execute('tabclose')}, 'curwin':1})
endfunction
" ---------------------------------------------}}}
command! Weather :call WeatherInNewTab()

function! OpenWebUrl(firstPartOfUrl,...)" -----{{{
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
" ---------------------------------------------}}}
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

" ---------------------------------------------}}}
" Snippets" -----------------------------------{{{
augroup ultisnips
	au!
	autocmd User UltiSnipsEnterFirstSnippet mark '
augroup end

let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories=[$VIM . "/pack/plugins/start/vim-snippets/ultisnips", $HOME . "/Desktop/snippets"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

nnoremap su :UltiSnipsEdit!<CR>G
" ---------------------------------------------}}}
" Git" ----------------------------------------{{{
augroup gitstatus
	autocmd!
	autocmd FileType fugitive set previewwindow
augroup END

augroup gitcommit
	autocmd!
	autocmd FileType gitcommit startinsert
	"autocmd FileType gitcommit execute('Snippets')
augroup END

nnoremap <silent> <Leader>G :Gtabedit :<CR>

" ---------------------------------------------}}}

# Vim

## Fugitive
http://vimcasts.org/episodes/fugitive-vim---a-complement-to-command-line-git/
http://vimcasts.org/episodes/fugitive-vim-working-with-the-git-index/
http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/
http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
http://vimcasts.org/episodes/fugitive-vim-exploring-the-history-of-a-git-repository/

https://stackoverflow.com/questions/18109625/writing-whole-alphabet-in-vim
	> set nrformats+=alpha
	> allows for <C-A> and <C-X> to increment/decrement alphabetically

https://vim.fandom.com/wiki/Making_a_list_of_numbers
	> g<C-A>
	> Increments first number of each line of the selection

:help :cexpr
	> cexpr system('dir')
	> createse a quickfix list using the result of system('dir')

:help i_CTRL-G_S
> <C-G>S, <C-S>, <C-S><C-S> for smart bracket completion
> provided by vim-surround

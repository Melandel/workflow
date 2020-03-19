## What is this? ##
This project is a help for setting up my desktop environment.

## Why did you design this? ##
As a C# developer, I spent 4 years using the Visual Studio IDE (up to the 2019 version, with ReSharper). My day-to-day workflow made me unhappy:
* Most of the things were of a point-and-click nature - which felt painfully repetitive
* Having to switch to Notepad++ for my drafts meant a lot of going back and forth between windows
* Working with two files side by side on one screen felt like too many drag-and-drops to perform
* The sheer amount of elements from the graphical interface (task bar, menus, and docked window anchors mainly) made it look like there was a lot of complexity, tools and settings in my way of working
* I consistently had several file explorers open at the same time. Lots of goingback back and forth between windows again
* Some things took more time than I would have liked: startup (especially with ReSharper), running the unit tests, upgrading the IDE, ...

I'm pretty sure I can get to a workflow with:
* Minimal back and forth jumping between graphical elements/windows
* Minimal point-and-click
* Lightweight, fast and cross-platform tooling

## Design ##

### Root Folder ###

The `$HOME/Desktop` folder is the root folder for my desktop environment. The main point being that one doesn't have to open a file explorer in order to access it.

The desktop environment consists of:
* one `tmp` folder for backup files, logs, archives and other sandbox projects
* one `tools` folder for programs, scripts and config files
* one `my.pomodoro` file to use for tracking daily activity and celebrate progress
* one `my.notes` file to use for drafts, note taking, resource links, and overall knowledge database

### Tools ###

These tools go in the `tools` folder and they must individually be put into the environment variable `$PATH`


| Functionality          | Program/Script                                                                    |
| ---------------        | -------                                                                           |
| Text editor            | [Vim](https://www.vim.org/)                                                       |
| g/re/p                 | [ripgrep](https://github.com/BurntSushi/ripgrep)                                  |
| Text Previewer         | [bat](https://github.com/sharkdp/bat)                                             |
| Text Fuzzy finder      | [fzf](https://github.com/junegunn/fzf)                                            |
| Versioning Control     | [git](https://git-scm.com/)                                                       |
| Keyboard optimization  | [AutoHotKey](https://www.autohotkey.com/)                                         |
| Terminal Pager         | [less](http://gnuwin32.sourceforge.net/packages/less.htm)                         |
| Nuget explorer/fetcher | [nuget](https://docs.microsoft.com/en-us/nuget/reference/nuget-exe-cli-reference) |
| File explorer GUI      | [vifm](https://vifm.info/)                                                        |

#### Notes about tools ####

* Put `AutoHotkey`'s `Compiler` subfolder into `Path`
	* We'll use it to rebuild Autohotkey's executable file every time we edit `my.ahk`
* Set `gvim.exe` to always run as Administrator
	* `gvim.exe` reacts much quicker than its terminal version on Windows!
* To place the different `my.*` files in the correct locations:
	* create the folder `$HOME/tools/vim/pack/plugins/start/vim-empower/colors`
	* Edit and save `my.vimrc` and `my.colorscheme`
* To create the AutoHotkey executable `tools/myAzertyKeyboard.RunMeAsAdmin.exe`, edit `my.ahk` with vim once and `:w` it.
	* Set `tools/myAzertyKeyboard.RunMeAsAdmin.exe` to always run as Administrator as well

### Vim plugins ###

These github projects must be cloned into the `tools/vim/pack/plugins/start` folder

| Functionality              | Plugin                                                                     |
| ---------------            | -------                                                                    |
| Text Linting               | [ale](https://github.com/dense-analysis/ale)                               |
| Fuzzy Finder               | [fzf.vim](https://github.com/junegunn/fzf.vim)                             |
| Fuzzy Finder               | [fzf.core.vim](https://github.com/junegunn/fzf/blob/master/plugin/fzf.vim) |
| Status Line                | [lightline.vim](https://github.com/itchyny/lightline.vim)                  |
| Status Line                | [vim-gitbranch](https://github.com/itchyny/vim-gitbranch)                  |
| Intellisense               | [omnisharp-vim](https://github.com/OmniSharp/omnisharp-vim)                |
| Argument Text Objects      | [targets.vim](https://github.com/wellle/targets.vim)                       |
| Indentation Text Objects   | [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object)    |
| Snippets                   | [ultisnips](https://github.com/SirVer/ultisnips)                           |
| File explorer              | [vifm.vim](https://github.com/vifm/vifm.vim)                               |
| Asynchronous Make and Grep | [vim-amake.vim](https://github.com/edkolev/vim-amake)                      |
| Database Querying          | [vim-dadbod](https://github.com/tpope/vim-dadbod)                          |
| Vertical Alignment         | [vim-easy-align](https://github.com/junegunn/vim-easy-align)               |
| Versioning Control         | [vim-fugitive](https://github.com/tpope/vim-fugitive)                      |
| Google Query               | [vim-g](https://github.com/szw/vim-g)                                      |
| Session Saving             | [vim-obsession](https://github.com/tpope/vim-obsession)                    |

#### Notes about plugins ####

* fzf has two vim scripts: one from fzf's repository(the core wrapper), and one from fzf.vim's repository (which defines several commands)
* Ultisnips requires Python to be installed and in path.
	* the python version can be found by opening gvim.exe with a text editor and searching for the word `python`
	* use the same 64x or 86x bit version of python as vim's
* Ultisnips also allows us to create our own snippets in a given folder
* vim-g might need help to detect your browser by default. Don't hesitate to hardwire your browser's path in the plugin
* vim-g doesn't handle the `%` sign. Consider adding `let query = escape(query, '%')` in the script


### Startup programs ###

`gvim`, `tools/myAzertyKeyboard.exe` and your internet browser should be run when the system starts up.

#### Windows ####
For each program that should be run at startup:
Start > run > shell:startup > create a file with `.vbs` extension that looks like this example for firefox:

```vbs
Set WshShell = CreateObject("WScript.Shell" )
WshShell.Run """C:\Program Files\Mozilla Firefox\firefox.exe""", 0 'Must quote command if it has spaces; must escape quotes
Set WshShell = Nothing
```

### Task Bar Icons ###

Don't forget to set the target of the task bar icon to `$HOME\Desktop\tools\vim\gvim.exe -S` and its startup directory to `$HOME` in order to use and locate Vim's session file properly!

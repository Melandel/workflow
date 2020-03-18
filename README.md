## What is this? ##
This project is a help for setting up my desktop environment.

## Why did you design this? ##
As a C# developer, I spent 4 years using the Visual Studio IDE (up to the 2019 version, with ReSharper). My day-to-day workflow made me unhappy:
* Most of the things were of a point-and-click nature - which felt painfully repetitive
* Having to switch to Notepad++ for my drafts meant lots of going back and forth between windows
* the menus, docked window anchors, and overall graphical layout took enough space to prevent me from working with two files vertically aligned on the same screen
* I consistently had several file explorers open at the same time. Lots of goingback back and forth between windows again
* Some things took more time than I would have liked: startup (especially with ReSharper), running the unit tests, upgrading the IDE, ...

Coding is mainly editing text files, compiling and running. I'm pretty sure I can do these with a lightweight, fast, cross-platform tool with minimal UI!

## Design ##

### Root Folder ###

The `$HOME/Desktop` folder is the root folder for my desktop environment. The main point being that one doesn't have to open a file explorer in order to access it.

The desktop environment consists of:
* a `tmp` folder for backup files, logs, archives
* a `tools` folder for programs and scripts
* a `my.pomodoro` file for tracking daily activity
* a `my.notes` files for drafts, note taking, resource links, and overall knowledge database

### Tools ###

These tools go in the `tools` folder and they must individually be put into the environment variable `$PATH`


| Functionality          | Program/Script |
| ---------------        | -------        |
| Text editor            | Vim            |
| g/re/p                 | ripgrep        |
| Text Previewer         | bat            |
| Text Fuzzy finder      | fzf            |
| Versioning Control     | git            |
| Keyboard optimization  | AutoHotKey     |
| Terminal Pager         | less           |
| Nuget explorer/fetcher | nuget          |
| File explorer GUI      | vifm           |

### Vim plugins ###

These github projects must be cloned into the `tools/vim/pack/plugins/start` folder

| Functionality            | Plugin                                                                     |
| ---------------          | -------                                                                    |
| Text Linting             | [ale](https://github.com/dense-analysis/ale)                               |
| Fuzzy Finder             | [fzf.vim](https://github.com/junegunn/fzf.vim)                             |
| Fuzzy Finder             | [fzf.vim.core](https://github.com/junegunn/fzf/blob/master/plugin/fzf.vim) |
| Status Line              | [lightline.vim](https://github.com/itchyny/lightline.vim)                  |
| Status Line              | [vim-gitbranch](https://github.com/itchyny/vim-gitbranch)                  |
| Intellisense             | [omnisharp-vim](https://github.com/OmniSharp/omnisharp-vim)                |
| Argument Text Objects    | [targets.vim](https://github.com/wellle/targets.vim)                       |
| Indentation Text Objects | [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object)    |
| Snippets                 | [ultisnips](https://github.com/SirVer/ultisnips)                           |
| Snippets                 | [vim-snippets](https://github.com/honza/vim-snippets)                      |
| File explorer            | [vifm.vim](https://github.com/vifm/vifm.vim)                               |
| Asynchronous Make        | [vim-amake.vim](https://github.com/edkolev/vim-amake)                      |
| Database Querying        | [vim-dadbod](https://github.com/tpope/vim-dadbod)                          |
| Vertical Alignment       | [vim-easy-align](https://github.com/junegunn/vim-easy-align)               |
| Versioning Control       | [vim-fugitive](https://github.com/tpope/vim-fugitive)                      |
| Google Query             | [vim-g](https://github.com/szw/vim-g)                                      |
| Session Saving           | [vim-obsession](https://github.com/tpope/vim-obsession)                    |

#### Notes about plugins ####

* fzf has two vim scripts: one from fzf's repository(the core wrapper), and one from fzf.vim's repository (which defines several commands)
* Ultisnips requires Python to be installed and in path.
	* the python version can be found by opening gvim.exe with a text editor and searching for the word `python`
* Ultisnips also allows us to create our own snippets in a given folder
	* currently, the folder is `tools/vim/pack/plugins/start/vim-snippets-perso`
* vim-g might need help to detect your browser by default. Don't hesitate to hardwire your browser's path in the plugin
* vim-g doesn't handle the `%` sign. Consider adding `let query = escape(query, '%')` in the script


### Startup programs ###

`vim`, `autohotkey` and your internet browser should be run when the system starts up.

#### Windows ####
For each program that should be run at startup:
Start > run > shell:startup > create a file with `.vbs` extension that looks like this example for firefox:

```vbs
Set WshShell = CreateObject("WScript.Shell" )
WshShell.Run """C:\Program Files\Mozilla Firefox\firefox.exe""", 0 'Must quote command if it has spaces; must escape quotes
Set WshShell = Nothing
```

### Task Bar Icons ###

Don't forget to set the target of the task bar icon to `C:\Users\tranm\Desktop\tools\vim\gvim.exe -S` and its startup directory to `$HOME` in order to use and locate Vim's session file properly!

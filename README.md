Welcome to Melandel's desktop setup! ^-^

## What is this? ##
This project is a help for setting up my desktop environment on new workstations!

## Why did you design this? ##
As a C# developer, I spent 4 years using the Visual Studio IDE (up to the 2019 version, with ReSharper). My day-to-day workflow made me unhappy:
* Switching to another window always disrupted my focus
* Point-and-clicking sometimes felt painful, especially on common operations that required several steps
* Switching from the IDE back and forth to Notepad++ felt inefficient, like having 2 tools to do the job of 1
* Working with two files side by side on one screen implied too many drag-and-drops so I never worked like that
* All these collapsed, docked windows were visual pollution yet still better than browsing the menus
* Disruptive waiting time. While firing up the IDE/ReSharper, while firing up the unit tests, while upgrading the IDE

## So what did you want? ##
I want an environment that allows a certain workflow where I can remain focused as long as possible. That workflow:
* Should feel fast and lightweight
* Should not make me feel like juggling between different contexts and tools
* Should expose me to the minimal amount of information I need
* Should offer search capabilities that mainly require my fingers, not my eyes
* Should be reachable on Windows, Unix, and MacOS

## Design ##

### Root Folder ###

The `$HOME/Desktop` folder is the root folder for my desktop environment. The main point is that accessing it doesn't require a file explorer

The desktop environment consists of:
* a `tools` folder for programs integrated in the workflow
* a `my.pomodoro` file to use for tracking daily activity and celebrate progress. Also a todolist.
* a `my.notes` file to use for writing drafts, taking notes, storing resource links, basically aknowledge database
* a `tmp` folder for backup files, logs, archived diffs and other sandbox projects
* a `snippets` folder 

### Tools ###

These tools go in the `tools` folder if possible, as well as in the environment variable `$PATH`


| Functionality          | Program/Script                                                                                               | Notes                                                                                  |
| ---------------        | -------                                                                                                      | -----                                                                                  |
| Keyboard optimization  | [AutoHotKey](https://www.autohotkey.com/)                                                                    | Re-run the installer to change the installation folder to `$HOME/tools`.               |
|                        |                                                                                                              | Put also its `Compiler` subfolder into `Path`                                          |
|                        |                                                                                                              | Generate the `exe` by editing & saving `setup/my_keyboard.ahk` inside Vim              |
| Versioning Control     | [git](https://git-scm.com/downloads)                                                                         |                                                                                        |
| Text editor            | [Vim](https://github.com/vim/vim-win32-installer/releases)                                                   | Pick x64 or x86. Set `gvim.exe` to run as Administrator                                |
| File explorer GUI      | [vifm](https://vifm.info/downloads.shtml)                                                                    |                                                                                        |
| g/re/p                 | [ripgrep](https://github.com/BurntSushi/ripgrep/releases)                                                    |                                                                                        |
| Text Previewer         | [bat](https://github.com/sharkdp/bat/releases)                                                               |                                                                                        |
| Fuzzy finder           | [fzf](https://github.com/junegunn/fzf-bin/releases)                                                          |                                                                                        |
| Terminal Pager         | [less](https://github.com/Pscx/Pscx/blob/81b76cfdb1343f84880e0e2cd647db5c56cf354b/Imports/Less-394/less.exe) |                                                                                        |
| Nuget explorer/fetcher | [nuget](https://www.nuget.org/downloads)                                                                     |                                                                                        |
| Scripting language     | [python (needed by vim's plugin UltiSnips)](https://www.python.org/downloads/windows/)                       | Be sure you install the same version (x64 or x86) as vim                               |
|                        |                                                                                                              | To know which python you need, enter insert mode inside vim and read the error message |

### Vim plugins ###

The plugins are automatically installed when running vim for the first time after running `:source ~/Desktop/setup/my_vimrc.vim`

| Functionality              | Plugin                                                                                                                         |
| ---------------            | -------                                                                                                                        |
| Text Linting               | [ale](https://github.com/dense-analysis/ale)                                                                                   |
| Fuzzy Finder               | [fzf.vim](https://github.com/junegunn/fzf.vim) & [fzfcore.vim](https://github.com/junegunn/fzf/blob/master/plugin/fzf.vim)     |
| Status Line                | [lightline.vim](https://github.com/itchyny/lightline.vim) & [vim-gitbranch](https://github.com/itchyny/vim-gitbranch)          |
| C# Intellisense            | [omnisharp-vim](https://github.com/OmniSharp/omnisharp-vim)                                                                    |
| Text Objects               | [targets.vim](https://github.com/wellle/targets.vim) & [vim-indent-object](https://github.com/michaeljsmith/vim-indent-object) |
| Snippets                   | [ultisnips](https://github.com/SirVer/ultisnips)                                                                               |
| File explorer              | [vifm.vim](https://github.com/vifm/vifm.vim)                                                                                   |
| Asynchronous Make and Grep | [vim-amake.vim](https://github.com/edkolev/vim-amake)                                                                          |
| Database Querying          | [vim-dadbod](https://github.com/tpope/vim-dadbod)                                                                              |
| Vertical Alignment         | [vim-easy-align](https://github.com/junegunn/vim-easy-align)                                                                   |
| Git workflow               | [vim-fugitive](https://github.com/tpope/vim-fugitive)                                                                          |
| Google Query               | [vim-g](https://github.com/szw/vim-g)                                                                                          |
| Session Management         | [vim-obsession](https://github.com/tpope/vim-obsession)                                                                        |

### Startup programs ###

`gvim`, `tools/myAzertyKeyboard.RunMeAsAdmin.exe` and your internet browser should be run when the system starts up.

On Windows, for each program that should be run at startup:
Start > run > shell:startup > create a file with `.vbs` extension that looks like this example for firefox:

```vbs
Set WshShell = CreateObject("WScript.Shell" )
WshShell.Run """C:\Users\tranm\Desktop\tools\firefox\firefox.exe""", 0 'Must quote command if it has spaces; must escape quotes
Set WshShell = Nothing
```

### Task Bar Icons ###

Don't forget to set the target of the task bar icon to `$HOME\Desktop\tools\vim\gvim.exe -S` and its startup directory to `$HOME` in order to use and locate Vim's session file properly!

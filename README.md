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
* a `setup` folder for backup files, logs, archived diffs and other sandbox projects
* a `snippets` folder 

### Tools ###

These tools go in the `tools` folder if possible, as well as in the environment variable `$PATH`


| Functionality          | Program/Script                                                                                               | Notes                                                                                      |
| ---------------        | -------                                                                                                      | -----                                                                                      |
| Keyboard optimization  | [AutoHotKey](https://www.autohotkey.com/)                                                                    | Re-run the installer to change the installation folder to `$HOME/tools`.                   |
|                        |                                                                                                              | Put also its `Compiler` subfolder into `Path`                                              |
|                        |                                                                                                              | Generate the `exe` by editing & saving `setup/my_keyboard.ahk` inside Vim                  |
| Web Browser            | [Firefox](https://www.mozilla.org/en-US/firefox/new/)                                                        | Go to `Advanced install options` to choose the install folder                              |
| Versioning Control     | [git](https://git-scm.com/downloads)                                                                         |                                                                                            |
| Text editor            | [Vim](https://github.com/vim/vim-win32-installer/releases)                                                   | Pick x64 or x86. Set `gvim.exe` to run as Administrator                                    |
|                        |                                                                                                              | The plugins are automatically installed when `:source ~/Desktop/setup/my_vimrc.vim` in vim |
| g/re/p                 | [ripgrep](https://github.com/BurntSushi/ripgrep/releases)                                                    |                                                                                            |
| Text Previewer         | [bat](https://github.com/sharkdp/bat/releases)                                                               |                                                                                            |
| Fuzzy finder           | [fzf](https://github.com/junegunn/fzf-bin/releases)                                                          |                                                                                            |
| Terminal Pager         | [less](https://github.com/Pscx/Pscx/blob/81b76cfdb1343f84880e0e2cd647db5c56cf354b/Imports/Less-394/less.exe) |                                                                                            |
| Filesystem Tree Viewer | [tree](http://gnuwin32.sourceforge.net/packages/tree.htm)                                                    |                                                                                            |
| Nuget explorer/fetcher | [nuget](https://www.nuget.org/downloads)                                                                     |                                                                                            |
| Scripting language     | [python (needed by vim's plugin UltiSnips)](https://www.python.org/downloads/windows/)                       | Be sure you install the same version (x64 or x86) as vim                                   |
| C# REPL                | [dotnet-script](https://github.com/filipw/dotnet-script)                                                     | Install as a dotnet tool (`dotnet tool install`)                                           |
| Zip Utility            | [7-zip](https://www.7-zip.org/download.html)                                                                 |                                                                                            |

### Config files ###


| File                    | Notes                                                                                                       |
| ---------------         | -------                                                                                                     |
| setup/my_keyboard.ahk   | Autohotkey script. Remaps CAPS LOCK to Ctrl/Esc and all AltGr keys to using caret (^), amongst other things |
| setup/my_vimrc.vim      | vim config file. Create a symbolic link `$HOME/Desktop/tools/vim/_vimrc` referring to it                    |
| setup/my_vimium.json    | Firefox web-extension Vimium's config file. In the extension panel, import this file                        |
| setup/my_omnisharp.json | omnisharp server config file. Copy it to `$HOME/.omnisharp/omnisharp.json`                                  |

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

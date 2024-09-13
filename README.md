## Melandel's workflow ##
Hi, my name is Melandel and this project was born from my desire to feel as efficient as possible while developping software.

The main criteria for me is **minimizing context switches**.

## Background ##
As a C# developer, I spent 4 years using the Visual Studio IDE (up to the 2019 version, with ReSharper). My day-to-day workflow made me unhappy. It involved:

|                                                                 |                                                                                            |
| -                                                               | -                                                                                          |
| **Searching with my eyes**                                      | for the feature I was looking for on the screen                                            |
| **Scrolling**                                                   | to the data I was looking for                                                              |
| **Clicking link after link**                                    | to finally reach the page with button or input I was looking for                           |
| **Using both an IDE and a text editor**                         | the first for the code, the second for drafts and notes                                    |
| **Having multiple file explorer windows**                       | for copypasta, for diffs, for downloads, for exploration                                   |
| **Switching back and forth between the keyboard and the mouse** | when working with two splits on the same screen                                            |
| **Visual pollution taking space on the screen**                 | buttons, menus, docked windows I have no _immediate_ use for                               |
| **Disruptive waiting times**                                    | while firing up the IDE/ReSharper, while firing up the unit tests, while upgrading the IDE |

## The Problem ##
All these issues seemed to point to one main pain point:

| Context switching |
| ----------------- |
| My brain's _**PROBLEM-SOLVING**_ mode was constantly disrupted by some _**FIND-WHAT-YOU-ARE-LOOKING-FOR**_ or _**BROWSE-TO-YOUR-DESTINATION**_ process. |

## What to look for then ? ##
So now I know I want an environment that lets me stay in _**PROBLEM-SOLVING**_ mode as _**consistently**_ as possible.  What could it involved ?

| Keeping up with the speed of my thoughts                                                   |
| -                                                                                          |
| Fast and lightweight commands                                                              |
| One interface for every tool                                                               |
| Requests to a search engine over scrolling/following links/parsing the screen with my eyes |
| Display only what I need in the immediate moment on the screen                             |

I also want to be able to use it from any operating system.

## A Solution - that works for me ##

### Files and Folders ###
My experience suggests that the following files/folders address my different needs:

|                     |                                                                                 |
| -                   | -                                                                               |
| `[…]/todo`          | Keeps track of my **todo list**, what I want done at the end of the current day |
| `[…]/done`          | Keeps track of how **productive** I have been lately                            |
| `[…]/achievements`  | Keeps track of the **major steps** that my productivity allowed me to reach     |
| `[…]/projects/**`   | Regroups all the **source code** I'm editing                                    |
| `[…]/config/*`      | Regroups all the **config files** I'm using for all my tools                    |
| `[…]/tmp/*`         | Regroups stuff that I need at the moment but **don't care** afterwards          |
| `[…]/notes/*`       | Regroups stuff that I want to **keep** somewhere                                |
| `[…]/notes/media/*` | Regroups pictures (or other resources) I want to display in my markdown notes   |
| `[…]/snippets/*`    | Regroups all the **text snippets** I create                                     |
| `[…]/templates/**`  | Regroups all the **folder structure templates** I create                        |
| `[…]/tools/**`      | Regroups all the **tools** I use as part of my workflow                         |

### Tool box ###
I went with a dev environment made mostly from **vim**.
||
|-|
|Vim is **fast**. |
|Vim is **lightweight**. |
|Vim offers **a universal interface for every tool** (read: a cursor positioned on a text buffer). |
|Vim offers **minimal graphical artifacts**.  |
|Last but not least, Vim offers **_INSANE_** customization capabilities. |

Also, VIM will easily ask one year of your lifetime hahaha. Ha...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_Contemplates the horizon, far away, for an instant..._

But here, I'm also using VIM (and I know and understand many whom think this is very wrong) a cement for my whole **toolbox**:

| Tool                                               | Main Feature                                                          | Usage                                                                                                              |
| -                                                  | -                                                                     | -                                                                                                                  |
| **Autohotkey**                                     | Keyboard remappings                                                   | Use CapsLock for Esc/Ctrl, use alphabetical keys for arrows/home/end/AltGr keys, CapsLock+I/M for Tab/Enter        |
| **Git**                                            | Version Control System                                                | Helps me add values little by little but more frequently                                                           |
| **Firefox**                                        | Web browser                                                           | Web browser & Image/pdf/markdown viewer                                                                            |
| &nbsp;&nbsp;&nbsp;&nbsp;**Vimium**                 | vim-like keyboard **shortcuts**                                       |                                                                                                                    |
| &nbsp;&nbsp;&nbsp;&nbsp;**AutoFullscreen**         | set window as **fullscreen** at startup                               |                                                                                                                    |
| &nbsp;&nbsp;&nbsp;&nbsp;**Markdown Viewer Webext** | render **markdown** files                                             |                                                                                                                    |
| &nbsp;&nbsp;&nbsp;&nbsp;**Homify**                 | Add a quote and the current **time & date** at the bottom of pictures | Use images as background wallpapers                                                                                |
| **Fzf**                                            | fuzzy finder                                                          | Allows me to organize commands/folders by groups with fast selection                                               |
| **Ripgrep**                                        | (fast) Search tool                                                    | Fast search for word in file contents                                                                              |
| **OmniSharp-roslyn**                               | C# language server                                                    | Intellisense for C#                                                                                                |
| **PlantUML**                                       | Text-file-based diagram generation                                    | Helps me build a thought or keep a visual representation of an idea                                                |
| **Tree**                                           | directory listing                                                     | Shows the structure of a project                                                                                   |
| **Nuget**                                          | package manager for .NET                                              | Search for nugets names to add to current project                                                                  |
| **VIM**                                            | Text edition                                                          | Edit text, use keyboard for everything, split the screen, select intput and send it to command-line-friendly tools |
| &nbsp;&nbsp;&nbsp;&nbsp;**editorconfig-vim**       | Consistent **style** in a project                                     | tabs vs spaces, `CR`/`LF`/`CRLF`                                                                                   |
| &nbsp;&nbsp;&nbsp;&nbsp;**ale**                    | Asynchronous **Linting** Engine                                       | Show errors and warnings on current file in real time                                                              |
| &nbsp;&nbsp;&nbsp;&nbsp;**fzf.vim**                | **Fzf** wrapper for vim                                               | Offer fast selection of commands or files/folders                                                                  |
| &nbsp;&nbsp;&nbsp;&nbsp;**lightline.vim**          | Lightweight **status line** customization                             | Show time & date, path-from-git-root, parent sln-or-csproj, window/tab number                                      |
| &nbsp;&nbsp;&nbsp;&nbsp;**omnisharp-vim**          | Provides vim commands for **C# intellisense**                         | Go to Definition, Find Symbol, Find usages, Get Documentation, Fix Usings, Run Tests, etc.                         |
| &nbsp;&nbsp;&nbsp;&nbsp;**vimspector**             | **Debugger** inside vim                                               | Toggle Breakpoint, Add Breakpoint with condition, Start/Stop/Re-run debugging session, Step In/Out/Over, etc.      |
| &nbsp;&nbsp;&nbsp;&nbsp;**ultisnips**              | Ability to use **snippets** in vim                                    | `cls+` → `public class                                                                                             | { }` |
| &nbsp;&nbsp;&nbsp;&nbsp;**vim-dirvish**            | Path **navigator**                                                    | File explorer (similar usage from vifm)                                                                            |
| &nbsp;&nbsp;&nbsp;&nbsp;**vim-dadbod**             | **Database** interaction from vim                                     | database querying                                                                                                  |
| &nbsp;&nbsp;&nbsp;&nbsp;**vim-surround**           | delete, change, add **surroundings** (`{[(<"'>)]}`)                   |                                                                                                                    |
| &nbsp;&nbsp;&nbsp;&nbsp;**tabular**                | Vertical **alignment**                                                | Markdown tables, C# property mappings, etc.                                                                        |
| &nbsp;&nbsp;&nbsp;&nbsp;**vim-fugitive**           | **Git** in vim                                                        | git operations (log/commit/add/push/checkout/merge)                                                                |
| &nbsp;&nbsp;&nbsp;&nbsp;**vim-obsession**          | **Session** in vim                                                    | Start with everyone left the way they were when leaving vim the last time                                          |
| &nbsp;&nbsp;&nbsp;&nbsp;**vim-css-color**          | Show hex **colors** in background highlighting                        | When tweaking my color theme mainly                                                                                |
| &nbsp;&nbsp;&nbsp;&nbsp;**targets.vim**            | Improved **text objects**                                             | Argument text object, next/2nd next/last/2nd last text object                                                      |
| &nbsp;&nbsp;&nbsp;&nbsp;**vim-empower**            | My **colorscheme**                                                    | Feel in an empowering environment all day                                                                          |
| &nbsp;&nbsp;&nbsp;&nbsp;**gvimtweak**              | Handle **opacity/fullscreen** features in (windows?) gVim             |                                                                                                                    |
| **7-zip**                                          | compression/decompression                                             | Install binaries on Windows                                                                                        |
| **WSL2**                                           | Windows Subsystem for Linux 2                                         | Feel in an efficient and comfortable environment under my control                                                  |
| **Windows Terminal**                               | A Decent terminal on Windows                                          | Emoji support, several tabs in one window in Windows                                                               |

## Installation Details ##
### Windows ###
#### Utilities
Install:
* [jq](https://jqlang.github.io/jq/download/)
* [xmllint](https://code.google.com/archive/p/xmllint/downloads)

#### Using config/vimfiles
Add environment variable:
* `VIMINIT` to `source %HOMEPATH%\Desktop\config\my_vimrc.vim`
* `VIEB_CONFIG_FILE` to `%HOMEPATH%\Desktop\config\my_viebrc.vieb`
* `VIEB_DATAFOLDER` to `%HOMEPATH%\Desktop\config\viebfiles\`
* `D2_LAYOUT` to `tala`

Also:
```txt
cd %homepath%
mklink /d vimfiles %HOMEPATH%\Desktop\config\myVim
mkdir vimfiles
mklink /J vimfiles/ultisnips %homepath%\Desktop\config\myVim\UltiSnips
```
#### Startup programs ####
`gvim`, `tools/myAzertyKeyboard.RunMeAsAdmin.exe` and your internet browser should be run when the system starts up.

On Windows, for each program that should be run at startup:
Start > run > shell:startup > create a file with `.vbs` extension that looks like this example for firefox:

```vbs
Set WshShell = CreateObject("WScript.Shell" )
WshShell.Run """C:\Users\tranm\Desktop\tools\vieb\Vieb.exe""", 0 'Must quote command if it has spaces; must escape quotes
Set WshShell = Nothing
```

`Windows Terminal` has a particular configuration item `"startOnUserLogin": true`.

#### Task Bar Icons ####
Don't forget to set the target of the task bar icon to `$HOME\Desktop\tools\vim\gvim.exe -S` and its startup directory to `$HOME` in order to use and locate Vim's session file properly!

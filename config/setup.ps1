$scriptpath = $MyInvocation.MyCommand.Path
$cd = Split-Path $scriptpath

$toolsFolder= Join-Path $HOME '/Desktop/tools'
	if (-Not (Test-Path $toolsFolder)) {
		New-Item -ItemType Directory -Force -Path $toolsFolder | Out-Null
	}
Set-Location $toolsFolder

function Download-File([string]$Uri, [string]$Target) {
	$targetFolder = Split-Path -Path $Target -Parent
	$targetFilename = Split-Path -Path $Target -Leaf
	if (-Not (Test-Path $targetFolder)) {
		New-Item -ItemType Directory -Force -Path $targetFolder | Out-Null
	}
	$absoluteTarget = Join-Path (Resolve-Path $targetFolder).Path $targetFilename

	Write-Host -NoNewLine 'Downloading...'
	$wc =New-Object System.Net.WebClient
	# Autohotkey[403]
	$wc.Headers.Add('User-Agent', 'foo')

	$wc.DownloadFile($Uri, $absoluteTarget)

	if (Test-Path $absoluteTarget) {
		Write-Host -NoNewLine 'OK.'
	}
	else {
		Write-Host 'There was an issue. Aborting.'
		Write-Host "url=$Uri"
		Write-Host "target=$absoluteTarget"
		return
	}
}

function Add-Path([string]$Uri) {
	$uriToAdd = (Resolve-Path -Path $Uri).Path
	if (Test-Path -PathType Leaf -Path $Uri){
		$uriToAdd = Split-Path -Path $Uri -Parent
	}
	if ([Environment]::GetEnvironmentVariable('Path', 'User').Indexof($uriToAdd)  -eq -1){
		Write-Host -NoNewLine "Added to PATH."
	[Environment]::SetEnvironmentVariable( 'Path', [Environment]::GetEnvironmentVariable('Path','User') + ";$uriToAdd", 'User')
	}
}

if ($null -eq (Get-Command '7z.exe' -ErrorAction SilentlyContinue)) {
	Write-Host '7z.exe not found.'
    $7zipFolder = Join-Path $toolsFolder '/7-Zip'
    $7zipInstaller = Join-Path $7zipFolder '/installer/7z.exe'
	Download-File -Uri 'https://www.7-zip.org/a/7z1900-x64.exe' -Target $7zipInstaller
    $7zipFolder = Join-Path $toolsFolder '/7-Zip/'
    & $7zipInstaller /S "/D=$7zipFolder"
    Set-Alias 7z (Join-Path $7zipFolder '7z.exe')
	Add-Path('./7-zip')
	Write-Host "`n"
}

if ($null -eq (Get-Command "Ahk2Exe.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Autohotkey not found.'
	Download-File -Uri 'https://www.autohotkey.com/download/ahk.zip' -Target "./autohotkey/ahk.zip"
	7z x ('-o' +'autohotkey') './autohotkey/ahk.zip' | Out-Null
	Add-Path('./autohotkey/Compiler')
	Write-Host "`n"
}

if ($null -eq (Get-Command "firefox.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Firefox not found.'
	Download-File -Uri 'https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=fr' -Target './firefox/installer.exe'
	& './firefox/installer.exe' /S /InstallDirectoryPath=(Join-Path (Get-Location) 'firefox')
	Add-Path('./firefox')
	Write-Host "`n"
}

if ($null -eq (Get-Command "git.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Git not found.'
	$tmp = (Join-Path $toolsFolder 'git.latestreleases.html')
	(Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/latest').Content > $tmp
	$gitRelativeUri = (Select-String -Path $tmp -Pattern 'href="(.*download.*64.*\.exe?)"' -List).Matches.Groups[1].Value
	Download-File -Uri "https://github.com$gitRelativeUri" -Target './git/installer.exe'
	& './git/installer.exe' ('/Dir=' + (Resolve-Path './git').Path) /Group=git /VERYSILENT
	# Add-Path('./git/bin'); We do this later on
	Remove-Item $tmp
	Write-Host "`n"
}

if ($null -eq (Get-Command "vim.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Vim not found.'
	$tmp = (Join-Path $toolsFolder 'vim.latestreleases.html')
	(Invoke-WebRequest -Uri 'https://github.com/vim/vim-win32-installer/releases/latest').Content > $tmp
	$vimUri = (Select-String -Path $tmp -Pattern 'href="(.*download.*64.*\.zip?)">' -List).Matches.Groups[1].Value
	Download-File -Uri $vimUri -Target './vim/vim.zip'
	7z x ('-o' +'vim') './vim/vim.zip' | Out-Null
	$installFolder = Split-Path (Get-ChildItem -Recurse -Path './vim' vim.exe).FullName
	Move-Item "$installFolder/*" './vim'
	Remove-Item	-Recurse './vim/vim'
	New-Item -ItemType SymbolicLink -Path (Join-Path './vim' '_vimrc') -Target (Join-Path $env:HOMEPATH 'Desktop/config/my_vimrc.vim') | Out-Null
	Add-Path('./vim')
    $vimrc = Join-Path $toolsFolder '_vimrc'
    $my_vimrc = Join-Path $env:HOMEPATH 'Desktop/config/my_vimrc.vim'
    New-Item -ItemType Junction -Path "$vimrc" -Target "$my_vimrc"
    $ultisnips = Join-Path $env:HOMEPATH 'vimfiles/ultisnips'
    $my_ultisnips= Join-Path $env:HOMEPATH 'Desktop/snippets'
    New-Item -ItemType Junction -Path "$ultisnips" -Target "$my_ultisnips"
	Remove-Item $tmp
	Write-Host "`n"
}

if ($null -eq (Get-Command "rg.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Ripgrep not found.'
	$tmp = (Join-Path $toolsFolder 'ripgrep.latestreleases.html')
	(Invoke-WebRequest -Uri 'https://github.com/BurntSushi/ripgrep/releases/latest').Content > $tmp
	$rgUri = (Select-String -Path $tmp -Pattern 'href="(.*download.*64.*windows.*msvc.*\.zip?)"' -List).Matches.Groups[1].Value
	Download-File -Uri "https://github.com$rgUri" -Target './ripgrep/ripgrep.zip'
	7z x ('-o' +'ripgrep') './ripgrep/ripgrep.zip' | Out-Null
	$installFolder = Split-Path (Get-ChildItem -Recurse -Path './ripgrep' rg.exe).FullName
	Move-Item "$installFolder/*" './ripgrep'
	Remove-Item	-Recurse './ripgrep/ripgrep-*'
	Add-Path('./ripgrep')
	Remove-Item $tmp
	Write-Host "`n"
}

if ($null -eq (Get-Command "fzf.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Fzf not found.'
	$tmp = (Join-Path $toolsFolder 'fzf.latestreleases.html')
	(Invoke-WebRequest -Uri 'https://github.com/junegunn/fzf-bin/releases/latest').Content > $tmp
	$fzfUri = (Select-String -Path $tmp -Pattern 'href="(.*download.*windows.*64.*\.zip?)"' -List).Matches.Groups[1].Value
	Download-File -Uri "https://github.com$fzfUri" -Target './fzf/fzf.zip'
	7z x ('-o' +'fzf') './fzf/fzf.zip' | Out-Null
	Add-Path('./fzf')
	Remove-Item $tmp
	Write-Host "`n"
}

if ($null -eq (Get-Command "less.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Less not found.'
	Download-File -Uri 'https://downloads.sourceforge.net/project/gnuwin32/less/394/less-394-bin.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fgnuwin32%2Ffiles%2Fless%2F394%2Fless-394-bin.zip%2Fdownload%3Fuse_mirror%3Dkumisystems%26download%3D&ts=1598032639' -Target './less/less.zip'
	7z x ('-o' +'less') './less/less.zip' | Out-Null
	Download-File -Uri 'https://downloads.sourceforge.net/project/gnuwin32/less/394/less-394-dep.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fgnuwin32%2Ffiles%2Fless%2F394%2Fless-394-dep.zip%2Fdownload%3Fuse_mirror%3Dmaster%26download%3D&ts=1598033278' -Target './less/less.deps.zip'
	7z x ('-o' +'less') './less/less.deps.zip' | Out-Null
	Add-Path('./less/bin')
	Write-Host "`n"
}

if ($null -eq (Get-Command "tree.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Tree not found.'
	Download-File -Uri 'https://downloads.sourceforge.net/project/gnuwin32/tree/1.5.2.2/tree-1.5.2.2-bin.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fgnuwin32%2Ffiles%2Ftree%2F1.5.2.2%2Ftree-1.5.2.2-bin.zip%2Fdownload%3Fuse_mirror%3Dnetcologne&ts=1598033561' -Target './tree/tree.zip'
	7z x ('-o' +'tree') './tree/tree.zip' | Out-Null
	Add-Path('./tree/bin')
	Write-Host "`n"
}

if ($null -eq (Get-Command "nuget.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Nuget not found.'
	Download-File -Uri 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -Target './nuget/nuget.exe'
	Add-Path('./nuget')
	Write-Host "`n"
}

if ($null -eq (Get-Command "python3.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Python3 not found.'
	$vimPythonThreeVersionInfo = (vim --version | Select-String -Pattern '-DDYNAMIC_PYTHON3_DLL=\\"python(\d)(\d)\.dll\\"' -List).Matches
	$vimPythonMajorVersion = $vimPythonThreeVersionInfo.Groups[1].Value
	$vimPythonMinorVersion = $vimPythonThreeVersionInfo.Groups[2].Value
	$tmp = (Join-Path $toolsFolder 'python3.latestreleases.html')
	(Invoke-WebRequest -Uri 'https://www.python.org/downloads/windows/').Content > $tmp
	$python3Uri = (Select-String -Path $tmp -Pattern "href=`"(.*python-$vimPythonMajorVersion\.$vimPythonMinorVersion.*64.*\.exe?)`"" -List).Matches.Groups[1].Value
	Download-File -Uri $python3Uri -Target './python3/installer.exe'
	& './python3/installer.exe' /quiet InstallAllUsers=0 PrependPath=1 Include_test=0 ('TargetDir=' + (Join-Path (Get-Location) 'python3'))
	Write-Host "`n"
}

if ($null -eq (Get-Command "OmniSharp.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'OmniSharp not found.'
	$tmp = (Join-Path $toolsFolder 'omnisharp.latestreleases.html')
	(Invoke-WebRequest -Uri 'https://github.com/OmniSharp/omnisharp-roslyn/releases/latest').Content > $tmp
	$omnisharpUri = (Select-String -Path $tmp -Pattern "href=`"(.*omnisharp.*win.*64.*\.zip?)`"" -List).Matches.Groups[1].Value
	Download-File -Uri "https://www.github.com$omnisharpUri" -Target './omnisharp/omnisharp.zip'
	7z x ('-o' +'omnisharp') './omnisharp/omnisharp.zip' | Out-Null
	Add-Path('./omnisharp')
	Remove-Item $tmp
	Write-Host "`n"
}

if ($null -eq (Get-Command "plantuml.jar" -ErrorAction SilentlyContinue)) {
	Write-Host 'Plantuml not found.'
	Download-File -Uri 'http://beta.plantuml.net/plantuml.jar' -Target './plantuml/plantuml.jar'
	Add-Path('./plantuml')
	Write-Host "`n"
}

if ($null -eq (Get-Command "dot.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Graphviz not found.'
	$tmp = (Join-Path $toolsFolder 'graphviz.releases.html')
	(Invoke-WebRequest -Uri 'https://www2.graphviz.org/Packages/stable/windows/10/msbuild/Release/Win32').Content > $tmp
    $fileName = (Select-String -Path $tmp -Pattern "href=`"(.*graphviz.*)`"" -List).Matches.Groups[1].Value
	Download-File -Uri "https://www2.graphviz.org/Packages/stable/windows/10/msbuild/Release/Win32/$fileName" -Target './graphviz/graphviz.zip'
	7z x ('-o' +'graphviz') './graphviz/graphviz.zip' | Out-Null
	$installFolder = (Split-Path (Get-ChildItem -Recurse -Path './graphviz' dot.exe).FullName -Parent) | Split-Path -Parent
	Move-Item "$installFolder/*" './graphviz'
	Remove-Item	-Recurse './graphviz/Graphviz'
	Add-Path('./graphviz/bin')
	Write-Host "`n"
}

if ($null -eq (Get-Command "yes.exe" -ErrorAction SilentlyContinue)) {
	Write-Host 'Gnu CoreUtils not found.'
    $installer = Join-Path $toolsFolder '/coreutils/installer.exe'
	Download-File -Uri 'https://downloads.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-setup.exe?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fgnuwin32%2Ffiles%2Flatest%2Fdownload&ts=1605993279' -Target "$installer"
	$folder = [IO.Path]::Combine($env:HOMEDRIVE, $env:HOMEPATH, 'Desktop/tools/coreutils')
    & $installer /VERYSILENT "/D=`"$folder`""
    New-Item -ItemType Junction -Path "$(Join-Path $toolsFolder 'coreutils/bin/expandtabs.exe')" -Target "$(Join-Path $toolsFolder 'coreutils/bin/expand.exe')"
	Write-Host "`n"
}

Add-Path('./coreutils/bin')
Add-Path('./git/bin')
Remove-Item './autohotkey/ahk.zip' -ErrorAction SilentlyContinue
Remove-Item './firefox/installer.exe' -ErrorAction SilentlyContinue
Remove-Item './git/installer.exe' -ErrorAction SilentlyContinue
Remove-Item './vim/vim.zip' -ErrorAction SilentlyContinue
Remove-Item './ripgrep/ripgrep.zip' -ErrorAction SilentlyContinue
Remove-Item './fzf/fzf.zip' -ErrorAction SilentlyContinue
Remove-Item './less/less.zip' -ErrorAction SilentlyContinue
Remove-Item './less/less.deps.zip' -ErrorAction SilentlyContinue
Remove-Item './tree/tree.zip' -ErrorAction SilentlyContinue
Remove-Item './python3/installer.exe' -ErrorAction SilentlyContinue
Remove-Item './omnisharp/omnisharp.zip' -ErrorAction SilentlyContinue
Remove-Item './graphviz/graphviz.zip' -ErrorAction SilentlyContinue
Remove-Item	'./coreutils/installer.exe' -ErrorAction SilentlyContinue

Set-Location $cd
Write-Host 'Over.'

Write-Host 'BUT. YOU. STILL. NEED. TO. MANUALLY. INSTALL. JAVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
read-host 'Say you are happy'

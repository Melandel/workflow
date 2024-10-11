vim9script

g:rc.env.browser = "firefox.exe"
g:rc.env.resources = js_decode(join(readfile(g:rc.env.resourcesFile)))

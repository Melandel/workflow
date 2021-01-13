"let $api = 'http://localhost:5051/smartlinx/api/v1'

function! GetCompilerFor(path)
	return get({
	\},
	\a:path,
	\'"C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\MSBuild.exe" -nologo -verbosity:quiet'
\)
endfunc


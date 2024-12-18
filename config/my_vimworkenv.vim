vim9script

g:rc.env.browser = "firefox.exe"
g:rc.env.meetingKinds = [ ".dev", ".archi" ]

def BuildUniversalAutocompletions(jsonFile: string): list<any>
	var config = ParseUniversalAutocompletion(jsonFile)
	var autocompletionsList = []
	for [name, value] in items(config.dynamicallyGeneratedEnvironmentVariables)
		var autocompletionItem = { 'word': printf('$%s', name), 'menu': value}
		call add(autocompletionsList, autocompletionItem)
		var scriptGeneratingEnvironmentVariable = printf('$%s = ''%s''', name, substitute(value, "'", "''", 'g'))
		execute(scriptGeneratingEnvironmentVariable)
	endfor
	sort(autocompletionsList)
	return autocompletionsList
enddef

def ParseUniversalAutocompletion(resourcesFile: string): dict<any>
	var universalAutocompletionJson = js_decode(join(readfile(resourcesFile)))
	var parsed = {
		deploymentEnvironments: [],
		dynamicallyGeneratedEnvironmentVariables: {}
	}
	for [completionNamePart, completionItem] in items(universalAutocompletionJson)
		for [completionItemKey, completionItemValue] in items(completionItem)
			var environmentVariables = {}
			var currentPrefixes = [RemoveDiacritics(completionNamePart), RemoveDiacritics(completionItemKey)]
			environmentVariables = BuildEnvironmentVariablesFromLeafItems(completionItemValue, environmentVariables, currentPrefixes)
			for [variableName, variableValue] in items(environmentVariables)
				parsed.dynamicallyGeneratedEnvironmentVariables[variableName] = variableValue
			endfor
		endfor
	endfor
	return parsed
enddef

def BuildEnvironmentVariablesFromLeafItems(node: any, environmentVariables: dict<string>, currentPrefixes: list<string>): dict<string>
	if type(node) != type({})
		var environmentVariableName = join(currentPrefixes, '_')
		var environmentVariableValue = node
		environmentVariables[environmentVariableName] = environmentVariableValue
		return environmentVariables
	endif
	for [key, value] in items(node)
		if (key == 'fetchables')
			BuildFetchableEnvironmentVariablesFromLeafItems(value, environmentVariables, currentPrefixes)
		else
			var normalizedKey = RemoveDiacritics(key)
			add(currentPrefixes, normalizedKey)
			BuildEnvironmentVariablesFromLeafItems(value, environmentVariables, currentPrefixes)
			remove(currentPrefixes, index(currentPrefixes, normalizedKey))
		endif
	endfor
	return environmentVariables
enddef

def BuildFetchableEnvironmentVariablesFromLeafItems(node: any, environmentVariables: dict<string>, currentPrefixes: list<string>): dict<string>
	if type(node) != type({})
		var environmentVariableName = join(currentPrefixes, '_')
		var environmentVariableValue = printf('[TO-FETCH-USING] %s', node)
		environmentVariables[environmentVariableName] = environmentVariableValue
		return environmentVariables
	endif
	for [key, value] in items(node)
		var normalizedKey = RemoveDiacritics(key)
		add(currentPrefixes, normalizedKey)
		BuildFetchableEnvironmentVariablesFromLeafItems(value, environmentVariables, currentPrefixes)
		remove(currentPrefixes, index(currentPrefixes, normalizedKey))
	endfor
	return environmentVariables
enddef

def RemoveDiacritics(str: string): string
	var diacs = 'áâãàçéêèïíóôõüúù' #lowercase diacritical signs
	diacs = diacs .. toupper(diacs)
	var repls = 'aaaaceeeiiooouuu' #corresponding replacements
	repls = repls .. toupper(repls)
	return tr(str, diacs, repls)
enddef


g:rc.env.universalAutocompletions = BuildUniversalAutocompletions(g:rc.env.universalAutocompletionFile)

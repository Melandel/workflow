vim9script

g:rc.env.browser = "firefox.exe"
g:rc.env.resources = js_decode(join(readfile(g:rc.env.resourcesFile)))

var parsedFromResources = {
	deploymentEnvironments: [],
	dynamicallyGeneratedEnvironmentVariables: {},
}
for [resourceName, resourceProperties] in items(g:rc.env.resources)
	for [propertyName, property] in items(resourceProperties)
		var isEnvironmentProperty = index(['type', 'aliases', 'descr'], propertyName) == -1
		if (isEnvironmentProperty)
			var env = propertyName
			var envProperty = property
			if (index(parsedFromResources.deploymentEnvironments, env) == -1) | call add(parsedFromResources.deploymentEnvironments, env) | endif
			for [envPropertyName, envPropertyValue] in items(envProperty)
				if (envPropertyName == 'fetchables')
					var fetchables = envPropertyValue
					for [fetchableName, fetchCommand] in items(fetchables)
						var environmentVariableName = printf('%s_%s_%s', resourceName, env, fetchableName)
						var environmentVariableValue = printf('[TO-FETCH-USING] %s', fetchCommand)
						parsedFromResources.dynamicallyGeneratedEnvironmentVariables[environmentVariableName] = environmentVariableValue
					endfor
				else
						var environmentVariableName = (envPropertyName == 'url')
							? printf('%s_%s', resourceName, env)
							: printf('%s_%s_%s', resourceName, env, envPropertyName)
						var environmentVariableValue = envPropertyValue
						parsedFromResources.dynamicallyGeneratedEnvironmentVariables[environmentVariableName] = environmentVariableValue
				endif
			endfor
	   endif
   endfor
endfor

g:rc.env.resourcesAutocompletion = []
for [name, value] in items(parsedFromResources.dynamicallyGeneratedEnvironmentVariables)
	call add(g:rc.env.resourcesAutocompletion, { 'word': printf('$%s', name), 'menu': value})

	var scriptGeneratingEnvironmentVariable = printf('$%s = ''%s''', name, substitute(value, "'", "''", 'g'))
	execute(scriptGeneratingEnvironmentVariable)
endfor

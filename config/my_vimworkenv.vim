vim9script

g:rc.env.browser = "firefox.exe"
g:rc.env.resources = js_decode(join(readfile(g:rc.env.resourcesFile)))

def ParseDeploymentEnvironmentResource(envResourceName: string, envResourceProperties: any): void
	for [envPropertyName, envPropertyValue] in items(envResourceProperties)
		if (index(['type', 'aliases', 'descr'], envPropertyName) >= 0)
			continue
		endif
		if (envPropertyName == 'fetchables')
			var fetchables = envPropertyValue
			for [fetchableName, fetchCommand] in items(fetchables)
				var environmentVariableValue = printf('[TO-FETCH-USING] %s', fetchCommand)
				var environmentVariableName = printf('%s_%s', envResourceName, fetchableName)
				parsedFromResources.dynamicallyGeneratedEnvironmentVariablesWithoutAliases[environmentVariableName] = environmentVariableValue
			endfor
		else
			var environmentVariableValue = envPropertyValue
			var environmentVariableName = printf('%s_%s', envResourceName, envPropertyName)
			parsedFromResources.dynamicallyGeneratedEnvironmentVariablesWithoutAliases[environmentVariableName] = environmentVariableValue
		endif
	endfor
enddef

def ParseResource(resourceName: string, resourceProperties: any): void
	var aliases = []
	for [propertyName, property] in items(resourceProperties)
		if propertyName == 'aliases'
			aliases = property
		endif
		var isEnvironmentProperty = index(['type', 'aliases', 'descr'], propertyName) == -1
		if (isEnvironmentProperty)
			var env = propertyName
			var envProperty = property
			if (index(parsedFromResources.deploymentEnvironments, env) == -1) | call add(parsedFromResources.deploymentEnvironments, env) | endif
			for [envPropertyName, envPropertyValue] in items(envProperty)
				if (envPropertyName == 'fetchables')
					var fetchables = envPropertyValue
					for [fetchableName, fetchCommand] in items(fetchables)
						var environmentVariableValue = printf('[TO-FETCH-USING] %s', fetchCommand)
						var environmentVariableName = printf('%s_%s_%s', resourceName, env, fetchableName)
						parsedFromResources.dynamicallyGeneratedEnvironmentVariablesWithoutAliases[environmentVariableName] = environmentVariableValue
						for alias in aliases
							var environmentVariableNameUsingAlias = printf('%s_%s_%s', alias, env, fetchableName)
							parsedFromResources.dynamicallyGeneratedEnvironmentVariablesWithAliases[environmentVariableNameUsingAlias] = environmentVariableValue
						endfor
					endfor
				else
					var environmentVariableValue = envPropertyValue
					var environmentVariableName = (envPropertyName == 'url')
						? printf('%s_%s', resourceName, env)
						: printf('%s_%s_%s', resourceName, env, envPropertyName)
					parsedFromResources.dynamicallyGeneratedEnvironmentVariablesWithoutAliases[environmentVariableName] = environmentVariableValue
					for alias in aliases
						var environmentVariableNameWithAlias = (envPropertyName == 'url')
							? printf('%s_%s', alias, env)
							: printf('%s_%s_%s', alias, env, envPropertyName)
						parsedFromResources.dynamicallyGeneratedEnvironmentVariablesWithAliases[environmentVariableNameWithAlias] = environmentVariableValue
					endfor
				endif
			endfor
		endif
	endfor
enddef

var parsedFromResources = {
	deploymentEnvironments: [],
	dynamicallyGeneratedEnvironmentVariablesWithoutAliases: {},
	dynamicallyGeneratedEnvironmentVariablesWithAliases: {}
}
for [resourceName, resourceProperties] in items(g:rc.env.resources)
	var isDeploymentEnvironmentResource = resourceProperties.type == 'env'
	if isDeploymentEnvironmentResource
		ParseDeploymentEnvironmentResource(resourceName, resourceProperties)
	else
		ParseResource(resourceName, resourceProperties)
	endif
endfor

g:rc.env.resourcesAutocompletion = []
g:rc.env.resourcesAutocompletionWithAliases = []
for [name, value] in items(parsedFromResources.dynamicallyGeneratedEnvironmentVariablesWithoutAliases)
	call add(g:rc.env.resourcesAutocompletion, { 'word': printf('$%s', name), 'menu': value})
	var scriptGeneratingEnvironmentVariable = printf('$%s = ''%s''', name, substitute(value, "'", "''", 'g'))
	execute(scriptGeneratingEnvironmentVariable)

	call add(g:rc.env.resourcesAutocompletionWithAliases, { 'word': printf('$%s', name), 'menu': value})
endfor

for [name, value] in items(parsedFromResources.dynamicallyGeneratedEnvironmentVariablesWithAliases)
	call add(g:rc.env.resourcesAutocompletionWithAliases, { 'word': printf('$%s', name), 'menu': value})
	var scriptGeneratingEnvironmentVariable = printf('$%s = ''%s''', name, substitute(value, "'", "''", 'g'))
	execute(scriptGeneratingEnvironmentVariable)
endfor

sort(g:rc.env.resourcesAutocompletion)
sort(g:rc.env.resourcesAutocompletionWithAliases)

-- Global configuration
vim.g.rc = vim.g.rc or {}
vim.g.rc.env = vim.g.rc.env or {}

vim.g.rc.env.browser = "firefox.exe"
vim.g.rc.env.meetingKinds = { ".dev", ".archi" }

local function remove_diacritics(str)
    local from = "áâãàçéêèïíóôõüúùÁÂÃÀÇÉÊÈÏÍÓÔÕÜÚÙ"
    local to   = "aaaaceeeiiooouuuAAAACEEEIIOOOUUU"

    return vim.fn.tr(str, from, to)
end

local function build_fetchable_environment_variables(node, env, prefixes)
    if type(node) ~= "table" then
        env[table.concat(prefixes, "_")] = "[TO-FETCH-USING] " .. tostring(node)
        return env
    end

    for key, value in pairs(node) do
        local normalized = remove_diacritics(key)
        table.insert(prefixes, normalized)
        build_fetchable_environment_variables(value, env, prefixes)
        table.remove(prefixes)
    end

    return env
end

local function build_environment_variables(node, env, prefixes)
    if type(node) ~= "table" then
        env[table.concat(prefixes, "_")] = node
        return env
    end

    for key, value in pairs(node) do
        if key == "fetchables" then
            build_fetchable_environment_variables(value, env, prefixes)
        else
            local normalized = remove_diacritics(key)
            table.insert(prefixes, normalized)
            build_environment_variables(value, env, prefixes)
            table.remove(prefixes)
        end
    end

    return env
end

local function parse_universal_autocompletion(resources_file)
    local json = table.concat(vim.fn.readfile(resources_file), "\n")
    local decoded = vim.json.decode(json)

    local parsed = {
        deploymentEnvironments = {},
        dynamicallyGeneratedEnvironmentVariables = {},
    }

    for completion_name, completion_item in pairs(decoded) do
        for completion_key, completion_value in pairs(completion_item) do
            local env = build_environment_variables(
                completion_value,
                {},
                {
                    remove_diacritics(completion_name),
                    remove_diacritics(completion_key),
                }
            )

            for name, value in pairs(env) do
                parsed.dynamicallyGeneratedEnvironmentVariables[name] = value
            end
        end
    end

    return parsed
end

local function build_universal_autocompletions(json_file)
    local config = parse_universal_autocompletion(json_file)
    local completions = {}

    for name, value in pairs(config.dynamicallyGeneratedEnvironmentVariables) do
        table.insert(completions, {
            word = "$" .. name,
            menu = value,
        })

        vim.env[name] = tostring(value)
    end

    table.sort(completions, function(a, b)
        return a.word < b.word
    end)
    return completions
end

local function write_into_global_dictionary(table)
  -- Note that setting dictionary fields directly will not write them back into Nvim.
  -- This is because the index into the namespace simply returns a copy.
  local globalRc = vim.g.rc
  globalRc.env.universalAutocompletions = table
  -- Instead the whole dictionary must be written as one.
  vim.g.rc = globalRc
end

local universal_autocompletions = build_universal_autocompletions(vim.g.rc.env.universalAutocompletionFile)
write_into_global_dictionary(universal_autocompletions)

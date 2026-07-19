

vim.pack.add({
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/itchyny/lightline.vim' },
  { src = 'https://github.com/itchyny/vim-gitbranch' },
  { src = 'https://github.com/Olical/vim-enmasse' },
  { src = 'https://github.com/SirVer/ultisnips' },
  { src = 'https://github.com/honza/vim-snippets' },
  { src = 'https://github.com/justinmk/vim-dirvish' },
  { src = 'https://github.com/tpope/vim-surround' },
  { src = 'https://github.com/godlygeek/tabular' },
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/tpope/vim-obsession' },
  { src = 'https://github.com/wellle/targets.vim' },
  { src = 'https://github.com/kevinhwang91/nvim-bqf' },
  { src = "https://github.com/junegunn/fzf" },
  { src = 'https://github.com/zigford/vim-powershell' },
  { src = "https://github.com/Melandel/vim-empower" },
-- C#
  { src = 'https://github.com/romus204/tree-sitter-manager.nvim' },
  { src = "https://github.com/seblyng/roslyn.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/nsidorenco/neotest-vstest" },
-- Debug
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/thehamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("1.*")  },
})

vim.env.FZF_PREVIEW_COLUMNS = tostring(math.floor(vim.o.columns/2))
local FzfLua = require("fzf-lua")
FzfLua.setup({
  actions = {
    files = {
      ["enter"] = FzfLua.actions.file_edit_or_qf,
      ["ctrl-t"] = FzfLua.actions.file_tabedit,
      ["ctrl-i"] = FzfLua.actions.file_edit_or_qf,
      ["ctrl-a"] = FzfLua.actions.file_split,
      ["ctrl-o"] = FzfLua.actions.file_vsplit,
    }
  },
  keymap = {
    builtin = { --<C-N> is natively understood by nvim ; just de-map <C-N> from <Up> in terminal mode somewhere else
                --<C-P> is natively understood by nvim ; just de-map <C-P> from <Down> in terminal mode somewhere else
                --[[<C-,> (autohotkey)]]  ["<Down>"] = "preview-down",
                --[[<C-;> (autohotkey)]]  ["<Up>"] = "preview-up",
      ["<C-E>"] = "preview-down",
      ["<C-Y>"] = "preview-up",
      ["<C-F>"] = "preview-half-page-down", -- vim-iso back-up
      ["<C-B>"] = "preview-half-page-up",
      ["<C-Q>"] = "toggle-preview",         -- vim-iso back-up
    },
    fzf = {     --[[<C-,> (autohotkey)]]  ["down"] = "preview-down",
                --[[<C-;> (autohotkey)]]  ["up"] = "preview-up",
      ["ctrl-e"] = "preview-down", -- vim-iso back-up if arrows don't reach fzf
      ["ctrl-y"] = "preview-up",   -- vim-iso back-up if arrows don't reach fzf
      ["ctrl-f"] = "preview-half-page-down",
      ["ctrl-b"] = "preview-half-page-up",
      ["ctrl-q"] = "toggle-preview", -- used by code_actions with previewer = 'codeaction_native' (native == fzf)
    }
  },
  ui_select = function(_, items)
    local min_h, max_h = 0.20, 0.70
    local h = (#items + 5)/ vim.o.lines
    if h < min_h then
      h = min_h
    elseif h > max_h then
      h = max_h
    end
    return { winopts = { height = h, width = 0.60, row = 0.40 } }
  end,
  lsp = {
    code_actions = {
      winopts = {
        preview = {
          hidden = true,
          vertical = "up:95",
          layout = "vertical",
        },
      },
      previewer = 'codeaction_native',
      preview_pager = "delta --tabs 1 --hunk-header-style='omit' --file-style='omit'",
    },
  }
})
local BufferPreviewer = require("fzf-lua.previewer.builtin").buffer_or_file:extend()
function BufferPreviewer:new(o, opts, fzf_win)
  BufferPreviewer.super.new(self, o, opts, fzf_win)
  setmetatable(self, BufferPreviewer)
  return self
end
function BufferPreviewer:parse_entry(entry)
  local bufnr = tonumber(entry:match("^(%d+):"))

  return {
    bufnr = bufnr,
  }
end
FzfLua.filesCS = function(opts)
    FzfLua.fzf_exec(coroutine.wrap(function(fzf_cb)
      local co = coroutine.running()
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        vim.schedule(function()
          local name = vim.api.nvim_buf_get_name(b)
          name = #name > 0 and name or "[No Name]"
          local csExtension = ".cs"
          if  string.sub(name, -#csExtension) == csExtension then
            fzf_cb(b .. ":" .. name, function() coroutine.resume(co) end)
          end
        end)
        coroutine.yield()
      end
      fzf_cb()
    end), { previewer = BufferPreviewer })
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == 'fzf' then
      -- 👇 Call fzf-lua.redraw() after calling fzf-lua
      -- Justification: fzf items, strangely, do not display on Windows without redrawing
      vim.defer_fn(function()
        require("fzf-lua").redraw()
      end, 10)
    end
  end,
})

require("tree-sitter-manager").setup()

require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})

require("mason-lspconfig").setup({ })
require("roslyn").setup({
  config = {
    settings = {
      ["csharp|inlayHints"] = {
        enableForParameters = true,
      },
    },
  },
})

vim.lsp.config("roslyn", {
  cmd = { "roslyn", "--stdio" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.enable("roslyn")
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local filetype = args.match
    local lang = vim.treesitter.language.get_lang(filetype)
    if lang and vim.treesitter.language.add(lang) then
      vim.treesitter.start()
    end
  end
})

vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    -- Go to declaration / definition
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<LocalLeader>s', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<LocalLeader>i', vim.lsp.buf.implementation, opts)

    vim.keymap.set('n', '<LocalLeader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<LocalLeader>S", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbols" })
    vim.keymap.set('n', '<LocalLeader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<LocalLeader>c', vim.lsp.buf.workspace_diagnostics, opts)
    vim.keymap.set('n', "<LocalLeader>f", vim.diagnostic.setloclist)

    -- Symbols

    -- Type definition, Rename, and Code Actions
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<LocalLeader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<LocalLeader>q', vim.lsp.buf.code_action, opts)

    -- References and Formatting
    vim.keymap.set('n', '<LocalLeader>u', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<LocalLeader>=', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "🌱",
      [vim.diagnostic.severity.WARN]  = "🌱",
      [vim.diagnostic.severity.INFO]  = "🌱",
      [vim.diagnostic.severity.HINT]  = "🌱",
    },
  },
})

vim.diagnostic.config({
  float = {
    header = "",
    border = "rounded", -- Options: "none", "single", "double", "shadow", or a custom border array
    prefix = function(diagnostic, i, total)
      local preprefix = "➜  "
      if total <= 1 or i == 1 then
        return preprefix, 'NormalFloat'
      end

      -- vertical alignment
      local prefix = string.rep(' ', vim.fn.strchars(preprefix)) .. preprefix
      local first_message_char = vim.fn.strcharpart(diagnostic.message, 0, 1)
      if string.match(first_message_char, '[%a_{(["]') then -- Leave all the 'foo', the <bar> where they are
        prefix = prefix .. " "                              -- And let the rest start one character after
      end

      return prefix, 'NormalFloat'
    end,
  },
})

local function set_terminal_opacity(value)
  local path = vim.fn.expand(
    "~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
  )

  local file = io.open(path, "r")
  if not file then
    vim.notify("Could not open Windows Terminal settings", vim.log.levels.ERROR)
    return
  end

  local content = file:read("*a")
  file:close()

  -- Requires Neovim 0.10+ for vim.json
  local ok, settings = pcall(vim.json.decode, content)
  if not ok then
    vim.notify("Failed to parse settings.json", vim.log.levels.ERROR)
    return
  end

  settings.profiles = settings.profiles or {}
  settings.profiles.defaults = settings.profiles.defaults or {}
  settings.profiles.defaults.opacity = value

  local out = io.open(path, "w")
  out:write(vim.json.encode(settings))
  out:close()
end


local saved = {}

local groups = {
  "Normal",
  "Special",
  "Delimiter",
  "Constant",
  "NormalNC",
  "LineNr",
  "CursorLineNr",
  "SignColumn",
  "FoldColumn",
  "EndOfBuffer",
}

local transparent = false

local function toggle_highlights()
  for _, group in ipairs(groups) do
    if not saved[group] then
      saved[group] = vim.api.nvim_get_hl(0, { name = group, link = false })
    end

    if transparent then
      vim.api.nvim_set_hl(0, group, saved[group])
    else
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    end
  end

  transparent = not transparent
end

local opacity = 100
set_terminal_opacity(opacity)
vim.api.nvim_create_user_command("ChangeOrToggleOpacity", function(opts)
  local trigger_transparency_toggle = false
  if opts.args == "" then
    trigger_transparency_toggle = true
    if opacity ~= 100 then
      opacity = 100
    else
      opacity = 20
    end
  elseif tonumber(opts.args) ~= nil then
    local newOpacity = tonumber(opts.args)
    trigger_transparency_toggle = newOpacity ~= opacity and (newOpacity == 100 or opacity == 100)
    opacity = newOpacity
  else
    if opacity == 100 then
      trigger_transparency_toggle = true
    end

    local deltaDirection = opts.args
    if deltaDirection == "-" then
      opacity = opacity - 20
      if opacity <= 0 then
        opacity = opacity + 100
      end
    elseif deltaDirection == "+" then
      opacity = opacity + 20
      if opacity > 100 then
        opacity = opacity - 100
      end
    else
    end

    if opacity == 100 then
      trigger_transparency_toggle = true
    end
  end

  set_terminal_opacity(opacity)
  if trigger_transparency_toggle then
    toggle_highlights()
  end
  -- vim.notify("Opacity: " .. opacity .. "%")
end, { nargs = '?' })

vim.keymap.set('n', '<A-n>', ':ChangeOrToggleOpacity -<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-p>', ':ChangeOrToggleOpacity +<CR>', { noremap = true, silent = true })

require('bqf').setup({
  --auto_resize_height = true,
  preview = {
    auto_preview = false,
  },
  func_map = {
    ptoggleauto = 'q',
    fzffilter = '<space>',
    pscrollup = '<C-B>',
    pscrolldown = '<C-F>',
  },
  filter = {
    -- need to unmap C-N from Down in FileType fzf
    fzf = {
      extra_opts = {
        "--bind",
        table.concat({
          -- 👇 Mappings for fzf-actions 'preview-down" & "preview-up" are defined although they do not trigger anything
          -- Justification: At this moment, it seems nvim-bqf does not translate these fzf-actions to fzf
          --   I'm still letting those here in case one day support happens
          "ctrl-e:preview-down", -- vim-iso back-up if arrows don't reach fzf
          "ctrl-y:preview-up",   -- vim-iso back-up if arrows don't reach fzf
          --[[<C-,> (autohotkey)]]  "down:preview-down",
          --[[<C-;> (autohotkey)]]  "up:preview-up",
          --
          "ctrl-f:preview-half-page-down",
          "ctrl-b:preview-half-page-up",
          "ctrl-q:toggle-preview",
          "ctrl-h:backward-delete-char",
          "ctrl-l:delete-char",
        }, ",")
      },
      action_for = {
        ["enter"] = "tabedit",
        ["ctrl-t"] = "tabedit",
        ["ctrl-o"] = "vsplit",
        ["ctrl-a"] = "split",
      },
    }
  }
})

function _G.is_covered_by_roslyn_lsp()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name == "roslyn" then
      return true
    end
  end
  return false
end

function _G.toggle_treesitter_fold()
  if vim.o.foldmethod ~= "expr" then
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
  else
    vim.o.foldmethod = "manual"
  end
end

function _G.document_methods_to_qf()
  local params = { textDocument = vim.lsp.util.make_text_document_params() }

  vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result)
    if err or not result then
      vim.notify("No document symbols", vim.log.levels.WARN)
      return
    end

    local fields = {}
    local properties = {}
    local methods = {}
    local SymbolKind = vim.lsp.protocol.SymbolKind
    local bufnr = vim.api.nvim_get_current_buf()
    local function add(symbol)
      if symbol.kind == SymbolKind.Field or symbol.kind == SymbolKind.Property or symbol.kind == SymbolKind.Method then
        local range = symbol.selectionRange or symbol.location.range
        local tableToAppend = symbol.kind == SymbolKind.Field and fields
          or symbol.kind == SymbolKind.Property and properties
          or symbol.kind == SymbolKind.Method and methods

        table.insert(tableToAppend, {
          bufnr = bufnr,
          lnum = range.start.line + 1,
          col = range.start.character + 1,
          text = symbol.name,
        })
      end
      if symbol.children then
        for _, child in ipairs(symbol.children) do
          add(child)
        end
      end
    end

    for _, symbol in ipairs(result) do
      add(symbol)
    end

    local items = {}
    for _, f in ipairs(fields) do table.insert(items, f) end
    for _, p in ipairs(properties) do table.insert(items, p) end
    for _, m in ipairs(methods) do table.insert(items, m) end

    vim.fn.setqflist({}, " ", {
      title = "Document Methods",
      items = items,
    })

    vim.cmd.copen()
  end)
end

-- 👇 Required for parsing tests using neotest-vstest
if not vim.treesitter.language.add("c_sharp") then
  vim.cmd("TSInstall c_sharp")
end
-- 👇 Required for watching tests using neotest
vim.treesitter.language.register("c_sharp", "cs")

vim.g.neotest_vstest = {
  dap_settings = {
    type = "coreclr",
  },
}
require("neotest").setup({
  -- log_level = vim.log.levels.DEBUG,
  adapters = {
    require("neotest-vstest")
  },
  highlights = {
    parameterized = "NeotestTest"
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    dir = "📂",
    expanded = "╮",
    failed = "🚩",
    file = "📄",
    final_child_indent = " ",
    final_child_prefix = "╰",
    namespace = "👀",
    non_collapsible = "─",
    notify = "🔔",
    passed = "✔️",
    running = "🕔",
    running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
    skipped = "✋",
    test = "🧪",
    unknown = "❓",
    watching = "🧐",
    parameterized = "🔀"
  },
  -- status = {
  --   enabled = true,
  --   signs = true,
  --   virtual_text = false
  -- },
  quickfix = {
    enabled = false, -- Creates duplicate trees inside summary due to window jumping that modifies lcd
    open = true,
  },
  summary = {
    animated = true,
    count = true,
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      help = "?",

      expand = "<space>",
      expand_all = "e",
      jumpto = { "<CR>", "i" },

      attach = "a",

      target = "f", -- filter scope
      clear_target = "F", -- reset scope

      run = "r",
      debug = "d",
      stop = "c", -- cancel

      output = "o",
      short = "O", -- short version of the output

      mark = "m",
      run_marked = "R",
      debug_marked = "D",
      clear_marked = "M",


      next_failed = "<Down>", -- <C-,> (autohotkey)
      prev_failed = "<Up>",   -- <C-;> (autohotkey)

      next_sibling = "<C-N>",
      prev_sibling = "<C-P>",

      parent = "P",

      -- No treesitter query for detecting relationship between implem/test files for C#
      -- watch = "w"
    },
    open = "botright vsplit | vertical resize 50"
  },
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cs", "neotest-summary" },
  callback = function(event)
    vim.keymap.set("n", "<LocalLeader>t", function()
      require("neotest").summary.toggle()
    end, {
      buffer = event.buf,
      silent = true,
      desc = "Toggle Neotest summary",
    })
  end,
})

local sign = "neotest_parameterized"
if vim.tbl_isempty(vim.fn.sign_getdefined(sign)) then
  vim.fn.sign_define(sign, {
    text = "🔀",
    texthl = "DiagnosticInfo",
    linehl = "",
    numhl = "",
  })
end

local dap = require("dap")
dap.adapters.coreclr = {
  type = 'executable',
  command = vim.g.rc.desktop .. '/tools/netcoredbg/netcoredbg.exe',
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll: ', vim.fn.fnamemodify(vim.fn.GetCsproj(), ':r') .. '/bin/Debug/', 'file')
    end,
  },
}
vim.fn.sign_define("DapBreakpoint", {
  text = "●",
  texthl = "DapBreakpoint",
  linehl = "",
  numhl = "",
})

vim.fn.sign_define("DapBreakpointCondition", {
  text = "◆",
  texthl = "DapBreakpointCondition",
  linehl = "",
  numhl = "",
})

vim.fn.sign_define("DapBreakpointRejected", {
  text = "😁",
  texthl = "DapBreakpointRejected",
  linehl = "",
  numhl = "",
})

vim.fn.sign_define("DapLogPoint", {
  text = "✏️",
  texthl = "DapLogPoint",
  linehl = "",
  numhl = "",
})

vim.fn.sign_define("DapStopped", {
  text = "🙂",
  texthl = "DapStopped",
  linehl = "DapStoppedLine",
  numhl = "DapStopped",
})
vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "DapLogPoint", { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "DapStopped", { link = "DiagnosticOk" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "Visual" })
vim.keymap.set("n", "<LocalLeader>b",       "<cmd>DapToggleBreakpoint<CR>",                                                                 { desc = "DAP: Toggle breakpoint" })
vim.keymap.set("n", "<LocalLeader>B",       function() require("dap").toggle_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, { desc = "DAP: Toggle logpoint" })
vim.keymap.set("n", "<LocalLeader>Q",       "<cmd>DapNew<CR>",                                                                              { desc = "DAP: Start debugger" })
vim.keymap.set("n", "<LocalLeader><space>", function() require("dap").run_to_cursor() end,                                                  { desc = "DAP: Run to Cursor" })
vim.keymap.set("n", "<LocalLeader>j",       function() require("dap").step_into() end,                                                      { desc = "DAP: Step into" })
vim.keymap.set("n", "<LocalLeader>k",       function() require("dap").step_out() end,                                                       { desc = "DAP: Step out" })
vim.keymap.set("n", "<LocalLeader>l",       function() require("dap").continue() end,                                                       { desc = "DAP: Continue" })
vim.keymap.set("n", "<LocalLeader>h",       function() require("dap").restart() end,                                                        { desc = "DAP: Restart" })
vim.keymap.set("n", "<LocalLeader>H",       function() require("dap").stop() end,                                                           { desc = "DAP: Stop" })
vim.keymap.set("n", "<LocalLeader>L",       function() require("dap").goto_() end,                                                          { desc = "DAP: Go to current pause" })

require("dap-view").setup()

vim.keymap.set("n", "<LocalLeader>T", "<cmd>DapViewToggle<CR>", { desc = "Toggle DAP View" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", {
      link = "Normal",
    })
  end,
})

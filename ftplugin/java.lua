-- jdtls is started here (once per Java buffer) rather than through mason-lspconfig,
-- because nvim-jdtls needs a per-project workspace and extended capabilities.
local ok, jdtls = pcall(require, 'jdtls')
if not ok then
  return
end

local mason_packages = vim.fn.stdpath 'data' .. '/mason/packages'
local jdtls_path = mason_packages .. '/jdtls'
local launcher = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
if launcher == '' then
  vim.notify('jdtls is not installed yet, run :MasonToolsInstall', vim.log.levels.WARN)
  return
end

-- jdtls itself needs Java 21+, even though projects may target older JDKs.
-- Every sdkman JDK is registered as a project runtime; `current` is the default.
local sdkman_java = vim.env.HOME .. '/.sdkman/candidates/java'
local current_jdk = vim.uv.fs_realpath(sdkman_java .. '/current')
local jdtls_java = vim.env.JDTLS_JAVA or 'java'
local runtimes_by_name = {}
for _, jdk in ipairs(vim.fn.glob(sdkman_java .. '/[0-9]*', true, true)) do
  local major = tonumber(vim.fn.fnamemodify(jdk, ':t'):match '^(%d+)')
  if major >= 21 and not vim.env.JDTLS_JAVA then
    jdtls_java = jdk .. '/bin/java'
  end
  local name = 'JavaSE-' .. major
  local is_current = vim.uv.fs_realpath(jdk) == current_jdk
  -- one runtime per major version, preferring `current` over other patch releases
  if not (runtimes_by_name[name] and runtimes_by_name[name].default) then
    runtimes_by_name[name] = { name = name, path = jdk, default = is_current }
  end
end
local runtimes = vim.tbl_values(runtimes_by_name)

-- java-debug and java-test (installed by Mason) are loaded into jdtls as plugins
local bundles = vim.fn.glob(mason_packages .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true, true)
for _, jar in ipairs(vim.fn.glob(mason_packages .. '/java-test/extension/server/*.jar', true, true)) do
  local name = vim.fn.fnamemodify(jar, ':t')
  if name ~= 'com.microsoft.java.test.runner-jar-with-dependencies.jar' and name ~= 'jacocoagent.jar' then
    table.insert(bundles, jar)
  end
end

local root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }) or vim.fn.getcwd()
-- Name the workspace after the project folder plus a hash of its full path, so
-- two projects with the same folder name (e.g. two `demo`s) don't share one
local workspace_name = vim.fn.fnamemodify(root_dir, ':t') .. '-' .. vim.fn.sha256(root_dir):sub(1, 8)
local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. workspace_name

-- Register the Java debug adapter (apply code changes to a running debug session on save)
jdtls.setup_dap { hotcodereplace = 'auto' }

jdtls.start_or_attach {
  cmd = {
    jdtls_java,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. jdtls_path .. '/lombok.jar',
    '-jar',
    launcher,
    '-configuration',
    jdtls_path .. '/config_linux',
    '-data',
    workspace_dir,
  },
  root_dir = root_dir,
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  settings = {
    java = {
      signatureHelp = { enabled = true },
      maven = { downloadSources = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      inlayHints = { parameterNames = { enabled = 'all' } },
      format = { enabled = false },
      configuration = { runtimes = runtimes },
    },
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
}

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
end

-- Opens the code action picker filtered to actions whose title matches `title`
local function code_action(title)
  return function()
    vim.lsp.buf.code_action {
      filter = function(action)
        return action.title:match(title) ~= nil
      end,
    }
  end
end

map('n', '<leader>co', jdtls.organize_imports, 'Organize Imports')
map('n', '<leader>crv', jdtls.extract_variable, 'Extract Variable')
map('v', '<leader>crv', '<Esc><Cmd>lua require("jdtls").extract_variable(true)<CR>', 'Extract Variable')
map('n', '<leader>crc', jdtls.extract_constant, 'Extract Constant')
map('v', '<leader>crc', '<Esc><Cmd>lua require("jdtls").extract_constant(true)<CR>', 'Extract Constant')
map('v', '<leader>crm', '<Esc><Cmd>lua require("jdtls").extract_method(true)<CR>', 'Extract Method')

map('n', '<leader>cgs', function()
  jdtls.organize_imports()
  code_action 'Generate Getters and Setters'()
end, 'Generate Getters and Setters')
map('n', '<leader>cgg', code_action 'Generate Getter', 'Generate Getter')
map('n', '<leader>cgS', code_action 'Generate Setter', 'Generate Setter')
map('n', '<leader>cgc', code_action 'Generate Constructor', 'Generate Constructor')
map('n', '<leader>cgt', code_action 'Generate toString', 'Generate toString()')
map('n', '<leader>cgh', code_action 'Generate hashCode', 'Generate hashCode() and equals()')

-- Tests (JUnit/TestNG) run under the debugger, so breakpoints work
map('n', '<leader>ct', require('jdtls.dap').test_class, '[T]est class')
map('n', '<leader>cm', require('jdtls.dap').test_nearest_method, 'Test nearest [M]ethod')

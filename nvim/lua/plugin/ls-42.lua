
-- lua/user/null-ls-norm.lua
-- Null-ls config tailored to "La Norma" (42) based on es.norm.pdf
-- Writes a .clang-format if missing and registers clang-format + a custom diagnostics generator.

local ok, null_ls = pcall(require, "null-ls")
if not ok then
  vim.notify("null-ls no está instalado", vim.log.levels.WARN)
  return
end

local u = require("null-ls.utils").make_conditional_utils()
local methods = require("null-ls").methods

-- 1) Create a .clang-format file in project root if it doesn't exist
local function ensure_clang_format(root)
  local path = root .. "/.clang-format"
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return
  end

  local clang_content = [[
# .clang-format generated to match "La Norma" (42)
BasedOnStyle: LLVM
UseTab: ForIndent
TabWidth: 4
IndentWidth: 4
ColumnLimit: 80
BreakBeforeBraces: Allman
AllowShortFunctionsOnASingleLine: false
PointerAlignment: Right
DerivePointerAlignment: false
SpacesBeforeTrailingComments: 1
KeepEmptyLinesAtTheStartOfBlocks: false
]]

  local wf = io.open(path, "w")
  if not wf then
    vim.notify("No se pudo crear .clang-format en: " .. path, vim.log.levels.ERROR)
    return
  end
  wf:write(clang_content)
  wf:close()
  vim.notify(".clang-format creado para adaptarse a la Norma (si no existía).", vim.log.levels.INFO)
end

-- 2) Custom diagnostics generator implementing several Norm checks
--    Heuristics:
--      - lines > 80
--      - trailing spaces
--      - double spaces
--      - forbidden keywords: for, do...while, switch, case, goto
--      - ternary operator '?'
--      - function length > 25 lines (heuristic using brace depth)
local function norm_diagnostics_generator(params, done)
  local diagnostics = {}
  local lines = params.content
  local in_multiline_comment = false

  -- helper to push a diagnostic
  local function push(severity, row, col, msg, code)
    table.insert(diagnostics, {
      row = row,
      col = col,
      end_row = row,
      end_col = col + 1,
      message = msg,
      severity = severity, -- 1=Error 2=Warning 3=Information 4=Hint (null-ls uses 1..4)
      code = code or "NORM",
      source = "norm-ls",
    })
  end

  -- detect functions by finding a line that looks like a function header followed by '{'
  local i = 1
  while i <= #lines do
    local line = lines[i]

    -- simple comment block tracker
    if line:match("/%*") then in_multiline_comment = true end
    if line:match("%*/") then in_multiline_comment = false end

    -- 1) trailing spaces
    if line:match("%s+$") then
      push(2, i, #line, "Trailing whitespace (no se permiten espacios al final de línea).", "TRAILING_SPACES")
    end

    -- 2) consecutive two spaces (no dos espacios seguidos en ningún sitio)
    if line:find("  ") then
      -- allow one instance if it's indentation (tabs) — but we check literal double spaces
      push(3, i, (line:find("  ") or 1), "Se encontraron dos espacios consecutivos. Evitar doble espacio.", "DOUBLE_SPACE")
    end

    -- 3) lines > 80 (ColumnLimit)
    if #line > 80 then
      push(2, i, 81, ("Línea con más de 80 columnas (%d)."):format(#line), "LINE_LENGTH")
    end

    -- 4) forbidden keywords (skip if inside comment or string naive)
    if not in_multiline_comment then
      -- avoid matching inside quotes crudely
      local naked = line:gsub('".-"', ""):gsub("'.-'", "")

      if naked:match("%f[%w]for%f[%W]") then
        push(2, i, naked:find("for") or 1, "Uso de 'for' prohibido por la Norma.", "NO_FOR")
      end
      if naked:match("%f[%w]switch%f[%W]") then
        push(2, i, naked:find("switch") or 1, "Uso de 'switch' prohibido por la Norma.", "NO_SWITCH")
      end
      if naked:match("%f[%w]case%f[%W]") then
        push(2, i, naked:find("case") or 1, "Uso de 'case' (switch-case) prohibido por la Norma.", "NO_CASE")
      end
      if naked:match("%f[%w]goto%f[%W]") then
        push(1, i, naked:find("goto") or 1, "Uso de 'goto' prohibido por la Norma.", "NO_GOTO")
      end
      if naked:find("%?") then
        push(2, i, naked:find("%?") or 1, "Operador ternario '?' prohibido por la Norma.", "NO_TERNARY")
      end
      if naked:match("%f[%w]do%f[%W]") and naked:match("%f[%w]while%f[%W]") then
        push(2, i, naked:find("do") or 1, "Uso de 'do..while' prohibido por la Norma.", "NO_DO_WHILE")
      end
    end

    -- 5) function length heuristic: detect a function start and count until matching braces
    --    We check a line that contains a '(' and then a '{' on same line or following lines
    local function_header = line:match("%S") and (line:match("%(.*%)") and (line:find("{") or lines[i+1] and lines[i+1]:find("{")))
    if function_header then
      local depth = 0
      local started = false
      local start_i = i
      local j = i
      while j <= #lines do
        local l = lines[j]
        -- naive skip comments (not perfect)
        if l:match("{") then
          depth = depth + select(2, l:gsub("{", "{"))
          started = true
        end
        if l:match("}") then
          depth = depth - select(2, l:gsub("}", "}"))
        end
        if started and depth <= 0 then
          -- function ends at j
          local func_len = j - start_i - 1 -- exclude braces lines roughly
          if func_len > 25 then
            push(2, start_i, 1, ("Función demasiado larga: %d líneas (máx 25)."):format(func_len), "FUNC_LONG")
          end
          break
        end
        j = j + 1
      end
      i = j -- skip ahead
    else
      i = i + 1
    end
  end

  done(diagnostics)
end

-- register builtin formatter (clang-format) and our diagnostics generator
null_ls.register({
  name = "norm_null_ls",
  -- ensure .clang-format exists when a file from a project is opened
  on_attach = function(client, bufnr)
    local root = vim.fn.getcwd()
    ensure_clang_format(root)
  end,
  -- formatting: clang-format
  sources = {
    null_ls.builtins.formatting.clang_format.with({
      filetypes = { "c", "cpp", "h", "hpp" },
      extra_args = function(params)
        -- Prefer project .clang-format; if not present, the ensure function created one.
        return {}
      end,
    }),
    -- diagnostics generator
    null_ls.generator({
      name = "norm_heuristic_checker",
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { "c", "h" },
      generator = function(params, done)
        -- run in protected mode
        local ok, res = pcall(norm_diagnostics_generator, params, done)
        if not ok then
          vim.notify("norm diagnostics generator error: " .. tostring(res), vim.log.levels.ERROR)
          done({})
        end
      end,
    }),
  },
})

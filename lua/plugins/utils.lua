local function gen_random(len)
  local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:,.<>?"
  local result = {}
  math.randomseed(os.time())
  for _ = 1, len do
    local idx = math.random(1, #chars)
    table.insert(result, chars:sub(idx, idx))
  end
  return table.concat(result)
end

vim.api.nvim_create_user_command("GenRandom", function(opts)
  local len = tonumber(opts.args) or 25
  if len < 1 then
    vim.notify("Usage: :GenRandom [number of chars]", vim.log.levels.ERROR)
    return
  end

  local str = gen_random(len)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "i" then
    vim.api.nvim_put({ str }, "c", true, true)
  else
    vim.fn.setreg("+", str)
    vim.notify("Copied to clipboard: " .. str)
  end
end, { nargs = "?" })

-- Gera um NIF válido a partir de um prefixo fixo (1 ou 2 dígitos).
-- Os dígitos restantes (posições prefixo+1 até 8) são aleatórios.
-- O 9.º dígito é calculado pelo algoritmo oficial AT.
local function gen_nif_with_prefix(prefix)
  math.randomseed(os.time())
  local digits = {}

  for i = 1, #prefix do
    digits[i] = tonumber(prefix:sub(i, i))
  end

  for i = #prefix + 1, 8 do
    digits[i] = math.random(0, 9)
  end

  local sum = 0
  for i = 1, 8 do
    sum = sum + digits[i] * (10 - i)
  end
  local remainder = sum % 11
  local check = (remainder < 2) and 0 or (11 - remainder)
  digits[9] = check

  local parts = {}
  for _, d in ipairs(digits) do
    parts[#parts + 1] = tostring(d)
  end
  return table.concat(parts)
end

-- Tipos de NIF portugueses conforme definidos pela AT / Wikipedia.
-- get_prefix() devolve o prefixo a usar na geração do NIF.
local nif_types = {
  {
    text = "1-3  · Pessoa singular",
    get_prefix = function()
      return tostring(math.random(1, 3))
    end,
  },
  {
    text = "45   · Pessoa singular não residente (retenção definitiva)",
    get_prefix = function() return "45" end,
  },
  {
    text = "5    · Pessoa colectiva (RNPC)",
    get_prefix = function() return "5" end,
  },
  {
    text = "6    · Administração Pública Central, Regional ou Local",
    get_prefix = function() return "6" end,
  },
  {
    text = "70   · Herança Indivisa (autor não era empresário)",
    get_prefix = function() return "70" end,
  },
  {
    text = "71   · Não residentes colectivos (retenção definitiva)",
    get_prefix = function() return "71" end,
  },
  {
    text = "72   · Fundos de investimento",
    get_prefix = function() return "72" end,
  },
  {
    text = "74   · Herança Indivisa",
    get_prefix = function() return "74" end,
  },
  {
    text = "75   · Herança Indivisa (cônjuge com rendimentos comerciais)",
    get_prefix = function() return "75" end,
  },
  {
    text = "77   · Atribuição Oficiosa de NIF",
    get_prefix = function() return "77" end,
  },
  {
    text = "78   · Não residentes - VAT REFUND",
    get_prefix = function() return "78" end,
  },
  {
    text = "79   · Regime excepcional - Expo 98",
    get_prefix = function() return "79" end,
  },
  {
    text = "8    · Empresário em nome individual (obsoleto)",
    get_prefix = function() return "8" end,
  },
  {
    text = "90   · Condomínios / Sociedades Irregulares / Heranças",
    get_prefix = function() return "90" end,
  },
  {
    text = "91   · Heranças Indivisas (autor era empresário individual)",
    get_prefix = function() return "91" end,
  },
  {
    text = "98   · Não residentes sem estabelecimento estável",
    get_prefix = function() return "98" end,
  },
  {
    text = "99   · Sociedades civis sem personalidade jurídica",
    get_prefix = function() return "99" end,
  },
}

vim.api.nvim_create_user_command("Nif", function()
  local mode = vim.api.nvim_get_mode().mode

  Snacks.picker.pick({
    title = "Tipo de NIF",
    items = nif_types,
    format = "text",
    layout = { preset = "select" },
    confirm = function(picker, item)
      picker:close()
      if not item then return end
      local nif = gen_nif_with_prefix(item.get_prefix())
      if mode == "i" then
        vim.schedule(function()
          vim.api.nvim_put({ nif }, "c", true, true)
        end)
      else
        vim.fn.setreg("+", nif)
        vim.notify("NIF copiado: " .. nif)
      end
    end,
  })
end, {})

return {}

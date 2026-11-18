-- Inline rendering of mermaid blocks in markdown buffers.
-- Chain: mermaid-cli (`mmdc`) -> diagram.nvim -> image.nvim -> terminal graphics.
--
-- The graphics backend differs per machine, and image.nvim does not auto-detect
-- (its default is "kitty"), so it is chosen at runtime:
--   * kitty            -> native graphics protocol
--   * Windows Terminal -> sixel (WT >= 1.22, running under WSL)
-- KITTY_WINDOW_ID is used rather than TERM=xterm-kitty because TERM is rewritten
-- to tmux-256color when nvim runs inside tmux on the home machine. Both
-- WT_SESSION and WT_PROFILE_ID are checked because Windows Terminal exports them
-- through WSLENV, and depending on how the process is started only one of the
-- two may make it into the WSL environment.
-- `vim.g.diagram_backend` (set from lua/plugins/local.lua) overrides detection.
--
-- The whole feature is gated on the external tools, so a machine without them
-- simply does not get it instead of erroring at startup.
local function image_backend()
  if vim.g.diagram_backend then
    return vim.g.diagram_backend
  elseif vim.env.KITTY_WINDOW_ID then
    return "kitty"
  elseif vim.env.WT_SESSION or vim.env.WT_PROFILE_ID then
    return "sixel"
  end
end

local missing = {}
if vim.fn.executable("mmdc") == 0 then
  table.insert(missing, "mmdc (`npm i -g @mermaid-js/mermaid-cli`)")
end
if vim.fn.executable("magick") == 0 then
  table.insert(missing, "magick (ImageMagick)")
end

local backend = image_backend()
if not backend then
  table.insert(missing, "a graphics-capable terminal (kitty, or Windows Terminal for sixel)")
end

local enabled = #missing == 0
if not enabled then
  -- Deferred so it lands after startup instead of blocking it.
  vim.schedule(function()
    vim.notify("diagram.nvim not loaded: missing " .. table.concat(missing, ", "), vim.log.levels.WARN)
  end)
end

return {
  {
    "3rd/image.nvim",
    cond = enabled,
    opts = {
      backend = backend,
      processor = "magick_cli", -- shell out to the `magick` binary; avoids the magick luarock
      integrations = {}, -- let diagram.nvim own markdown, not image.nvim's md integration
      only_render_image_at_cursor = true, -- sixel is slower; render on demand
      only_render_image_at_cursor_mode = "popup",
      -- Default height cap is 50% of the window, so tall diagrams get scaled down
      -- hard and the labels turn tiny. Allow the full window height (this only
      -- *shrinks* to fit -> normal/short diagrams are unaffected).
      max_width_window_percentage = 100,
      max_height_window_percentage = 100,
    },
  },
  {
    "3rd/diagram.nvim",
    -- Same gate as image.nvim: a disabled dependency is pruned from the plugin
    -- graph entirely, so diagram.nvim would otherwise load alone and error out
    -- the first time a markdown file is opened.
    cond = enabled,
    dependencies = { "3rd/image.nvim" },
    ft = { "markdown" },
    -- opts as a function: lazy evaluates this only after diagram.nvim is on the
    -- runtimepath, so require() here resolves (a plain table would run at startup,
    -- before the plugin is installed -> "module not found").
    opts = function()
      return {
        integrations = { require("diagram.integrations.markdown") },
        renderer_options = {
          mermaid = {
            theme = "forest",
            -- Pin an installed font so mmdc's headless Chromium doesn't race a
            -- late-loading web font and screenshot blank labels. See mermaid-font.css.
            cli_args = { "--cssFile", vim.fn.stdpath("config") .. "/mermaid-font.css" },
          },
        },
      }
    end,
  },
}

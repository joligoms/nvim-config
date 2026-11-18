-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

AUTO_FORMAT = true

vim.opt.number = true
vim.opt.relativenumber = false

vim.g.lazyvim_prettier_needs_config = false

vim.g.autoformat = true

if vim.fn.has("wsl") == 1 and vim.fn.executable("win32yank.exe") == 1 then
  -- Use Neovim's built-in win32yank provider (same -i --crlf / -o --lf flags).
  -- Pinned explicitly because WSLg exposes WAYLAND_DISPLAY/DISPLAY, so auto-detection
  -- would pick wl-copy/xclip (WSLg's clipboard bridge) before win32yank.
  -- Unlike a custom table with `cache_enabled = 0`, the built-in provider copies
  -- asynchronously (jobstart): yanks don't block on the ~1s WSL→Windows process
  -- spawn, and a paste issued while the copy is still in flight is served from
  -- Neovim's cache.
  --
  -- The executable check matters: naming "win32yank" here registers the provider
  -- *unconditionally* (provider/clipboard.vim does not verify it, unlike the
  -- auto-detect path), so on a WSL box without win32yank.exe every yank would
  -- error instead of falling back to wl-copy.
  vim.g.clipboard = "win32yank"
end

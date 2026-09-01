-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "gx", function()
  local file = ""

  -- Check if the cursor is currently inside the Neo-tree sidebar
  if vim.bo.filetype == "neo-tree" then
    -- Grab the real path from Neo-tree's internal state
    local state = require("neo-tree.sources.manager").get_state("filesystem")
    local node = state.tree:get_node()
    if node then
      file = node.path
    end
  else
    -- Standard behavior for normal text buffers
    file = vim.fn.expand("<cfile>:p")
  end

  -- Ensure a file was found before proceeding
  if file and file ~= "" then
    if file:match("%.pdf$") then
      local file_uri = "file://" .. file
      vim.fn.jobstart({ "cmux", "browser", "open-split", file_uri })
    else
      vim.ui.open(file)
    end
  end
end, { desc = "Open file (Neo-tree aware, routes PDFs to cmux)" })

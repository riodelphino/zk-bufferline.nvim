local M = {}

local defaults = {
  ---@param buf table
  ---@return string?
  name_formatter = function(buf)
    local ext = vim.fn.fnamemodify(buf.path, ":e")
    if ext == "md" then
      local note = vim.b[buf.bufnr].zk
      return note and (note.title or note.filenameStem or note.filename)
    end
  end,
}

M.options = defaults

return M

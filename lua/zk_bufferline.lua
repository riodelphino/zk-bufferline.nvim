local M = {}

---@param user_opts table?
function M.setup(user_opts)
  local config = require("zk_bufferline.config")
  config.options = vim.tbl_deep_extend("force", config.options, user_opts or {})
  require("zk_bufferline.core").override_name_formatter()
end

return M

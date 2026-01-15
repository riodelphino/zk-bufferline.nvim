local M = {}

---Set & override name_formatter in bufferline.nvim
function M.override_name_formatter()
  local opts = require("zk_bufferline.config").options
  ---@type bufferline.UserConfig
  ---@diagnostic disable-next-line: assign-type-mismatch
  local bufferline_config = require("bufferline.config").get() or {}
  local override_config = {
    options = {
      name_formatter = opts.name_formatter,
    },
  }
  -- Merge with current bufferline.nvim config
  local merged_config = vim.tbl_deep_extend("force", bufferline_config, override_config)
  require("bufferline").setup(merged_config)
end

return M

# zk-bufferline.nvim

An extension for [zk-org/zk-nvim](https://github.com/zk-org/zk-nvim) that displays ZK note info in [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) buffer names.

While this can be configured manually, the plugin makes it easier to format buffer names using ZK note info.  
No additional config is required if you just want to display ZK titles as buffer names.


## Requirements

- [zk-org/zk](https://github.com/zk-org/zk)
- [zk-org/zk-nvim](https://github.com/zk-org/zk-nvim)
- [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- [riodelphino/zk-buf-cache.nvim](https://github.com/riodelphino/zk-buf-cache.nvim)


## Installation

via [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "riodelphino/zk-bufferline.nvim",
  dependencies = { "zk-org/zk-nvim", "akinsho/bufferline.nvim", "riodelphino/zk-buf-cache.nvim" },
  opts = {},
}
```

## Config

Defaults:
```lua
require("zk_bufferline").setup({
  ---@param buf table
  ---@return string?
  name_formatter = function(buf)
    local ext = vim.fn.fnamemodify(buf.path, ":e")
    if ext == "md" then
      local note = vim.b[buf.bufnr].zk
      return note and (note.title or note.filenameStem or note.filename)
    end
  end,
})
```

Ensure that using zk fields are set in `select` option of `zk-buf-cache.nvim`:
```lua
require("zk_buf_cache").setup({
  select = { "filename", "filenameStem", "title" },
})
```

### Config Examples

#### Switch title format by tags

This example shows how to:
- Use user-defined YAML frontmatter to generate buffer names.
- Switch the title format based on whether a specific tag is present.

YAML frontmatter:
```markdown
---
title      : Awesome Note Taking
author     : John Davis
published  : 2025
tags       : [book]
---
```
Config:
```lua
require("zk_buf_cache").setup({
  select = { "filename", "filenameStem", "title", "tags", "metadata" }, -- Add tags and metadata
})

require("zk_bufferline").setup({
  name_formatter = function(buf)
    local ext = vim.fn.fnamemodify(buf.path, ":e")
    if ext == "md" then
      local note = vim.b[buf.bufnr].zk
      if note then
        local tags = note.tags or {}
        local metadata = note.metadata or {}
        if vim.tbl_contains(tags, "book") then
          local title = metadata.title or '[NO TITLE]'
          local author = metadata.author or '[NO AUTHOR]'
          local published = metadata.published or '?'
          return string.format("%s / %s (%s)", title, author, published)
        else
          return note.title or note.filenameStem or note.id
        end
      end
    end
  end,
})
```
After this sample setup, the buffer name is: `Awesome Note Taking / John Davis (2025)`

> [!NOTE]
> As shown in the code above, `metadata` contains all the YAML frontmatter, including user defined fields.

> [!NOTE]
> `note.metadata.title` captures only YAML title, while `note.title` can capture either the YAML title or a `# heading`.
> Therefore, including `title` in select table and using `note.title` is a safer fallback to catch the title in any positions.


#### Combine zk(markdown) and other filetypes

If you want to customize buffer names for ZK notes and other filetypes at the same time, it is recommended to configure `bufferline.nvim` directly.

This avoids conflicts and keeps all naming logic in one place.

```lua
require("zk_buf_cache").setup({
  select = { "filename", "filenameStem", "title" },
})

require("bufferline").setup({ -- Note that this is `bufferline` config
  options = {
    name_formatter = function(buf)
      local ext = vim.fn.fnamemodify(buf.path, ":e")
      if ext == "md" then
        local note = vim.b[buf.bufnr].zk
        return note and (note.title or note.filenameStem or note.filename)
      elseif ext == "neorg" then
        -- add your own formatter for other filetypes
      end
    end,
  },
})
```
Keep `zk-buf-cache.nvim` enabled, but disable or uninstall `zk-bufferline.nvim`. 


## Technical Info

### It just overrides name_formatter

This plugin simply overrides the `name_formatter` option in `bufferline.nvim`.  
(The same logic can also be used directory in your own bufferline's `name_fomatter` configuration.)

### Overhead to re-setup bufferline.nvim

Internally it calls bufferline's `setup()` again, but the redraw and re-setup overhead is minimal.


## License

MIT license. See [LICENSE](LICENSE)


## Related

- [zk-org/zk](https://github.com/zk-org/zk)
- [zk-org/zk-nvim](https://github.com/zk-org/zk-nvim)
- [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- [riodelphino/zk-buf-cache.nvim](https://github.com/riodelphino/zk-buf-cache.nvim)


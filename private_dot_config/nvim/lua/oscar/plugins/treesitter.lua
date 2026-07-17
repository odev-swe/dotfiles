-- treesitter (main branch): the rewrite, which is the version built for Neovim 0.12+.
-- The `master` branch does NOT support 0.12. The new API has no `configs` module:
-- you install parsers via .install() and turn on highlighting yourself.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = {
      -- lua / vim (for editing this config)
      "lua", "vim", "vimdoc",
      -- go
      "go", "gomod", "gosum", "gowork",
      -- javascript / typescript / web
      "javascript", "typescript", "tsx", "html", "css",
      "json", "graphql", "svelte",
      -- devops
      "bash", "dockerfile", "terraform", "hcl", "yaml", "toml", "make", "sql",
      -- misc / docs
      "markdown", "markdown_inline", "gitignore", "git_config", "gitcommit", "regex",
    }

    -- install any missing parsers (async; safe to call every startup)
    require("nvim-treesitter").install(parsers)

    -- enable treesitter highlighting when a buffer's filetype has a parser.
    -- (in the main branch you start highlighting yourself; it's not automatic.)
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("oscar-treesitter", { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang and vim.treesitter.language.add(lang) then
          vim.treesitter.start(ev.buf, lang)
          -- treesitter-based indentation (experimental but handy)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}

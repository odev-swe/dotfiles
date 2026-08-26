-- OpenTofu filetypes. Two gaps in Neovim's builtin detection:
--   *.tofu (OpenTofu 1.8+ native extension) maps to nothing at all.
--   *.tf goes through content sniffing (detect.tf) that returns "terraform"
--   only once a non-comment line exists -- so a brand-new empty .tf file gets
--   filetype "tf" and tofu_ls (filetypes: opentofu/opentofu-vars/terraform)
--   never attaches for that session, exactly when completion matters most.
-- User extension rules win over the builtin table, so both become "terraform",
-- which already has a treesitter parser, tofu_ls, and tofu_fmt wired up.
vim.filetype.add({
  extension = {
    tf = "terraform",
    tofu = "terraform",
  },
})

-- Open SVGs in the macOS image viewer instead of showing raw XML.
-- BufReadCmd intercepts the load, so the file is never read into the buffer
-- and nvim renders no image: near-zero RAM/CPU, no plugins, no ImageMagick.
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.svg",
  callback = function(ev)
    -- Hand off to the OS viewer (Preview/QuickLook) asynchronously.
    vim.fn.jobstart({ "open", ev.file }, { detach = true })

    -- Leave a throwaway buffer with a hint, not the XML source.
    vim.bo[ev.buf].buftype = "nofile"
    vim.bo[ev.buf].bufhidden = "wipe"
    vim.bo[ev.buf].swapfile = false
    vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, {
      "Opened " .. vim.fn.fnamemodify(ev.file, ":t") .. " in the macOS viewer.",
      "",
      "To edit the SVG source instead:  :noautocmd edit " .. ev.file,
    })
  end,
})

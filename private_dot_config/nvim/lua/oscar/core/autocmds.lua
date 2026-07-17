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

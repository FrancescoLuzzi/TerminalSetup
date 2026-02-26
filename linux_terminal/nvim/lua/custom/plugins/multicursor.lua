return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    set({ "x" }, "I", mc.visualToCursors)
    -- Add or skip adding a new cursor by matching word/selection
    set({ "n", "x" }, "<c-n>", function()
      local mode = vim.api.nvim_get_mode().mode
      if mode == "n" then
        vim.cmd("normal! viw")
      end
      mc.matchAddCursor(1)
    end)
    mc.addKeymapLayer(function(layerSet)
      -- Delete the main cursor.
      layerSet({ "n", "x" }, "<c-q>", mc.toggleCursor)
      set({ "n", "x" }, "<c-s>", function() mc.matchSkipCursor(1) end)
      -- Enable and clear cursors using escape.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end
}

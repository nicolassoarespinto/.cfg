-- UI utility functions

-- Toggle lualine visibility
local lualine_visible = true

function ToggleLualine()
    if lualine_visible then
        -- Hide lualine by disabling it
        require("lualine").hide()
        lualine_visible = false
    else
        -- Show lualine by re-enabling it
        require("lualine").hide({ unhide = true })
        lualine_visible = true
    end
    vim.g.lualine_visible = lualine_visible
end

-- Create a user command for easy access
vim.api.nvim_create_user_command("ToggleLualine", ToggleLualine, {
    desc = "Toggle lualine visibility",
})

-- Optional: Add a keymap (uncomment if desired)
vim.keymap.set("n", "<F4>", ToggleLualine, { desc = "Toggle lualine" })

--
-- -- hide lua line when starting neovim
-- vim.api.nvim_create_autocmd("VimEnter", {
--     callback = function()
--         require("lualine").hide()
--     end
-- })

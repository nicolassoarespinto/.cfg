return {
    "stevearc/oil.nvim",
    config = function()
        -- Helper: fzf-based directory picker for Oil buffers
        local function oil_fzf_dir_picker()
            if vim.fn.executable("fzf") == 0 then
                vim.notify("fzf not found in PATH", vim.log.levels.ERROR)
                return
            end
            local ok, oil = pcall(require, "oil")
            if not ok then return end

            local root = oil.get_current_dir() or vim.loop.cwd()
            local tmpfile = vim.fn.tempname()
            local skip_list = table.concat({ "__pycache__", "miniconda", ".venv" }, ",")
            local cmd = string.format(
                [[cd %s && fzf --walker dir --walker-root %s --walker-skip %s --height=100%% --reverse --border > %s]],
                vim.fn.shellescape(root),
                vim.fn.shellescape(root),
                vim.fn.shellescape(skip_list),
                vim.fn.shellescape(tmpfile)
            )

            -- Create a small floating terminal for fzf (visually distinct from Oil)
            local buf = vim.api.nvim_create_buf(false, true)
            local ui = vim.api.nvim_list_uis()[1]
            local width = math.floor(ui.width * 0.85)
            local height = math.floor(ui.height * 0.6)
            local row = math.floor((ui.height - height) / 2)
            local col = math.floor((ui.width - width) / 2)
            local win = vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = width,
                height = height,
                row = row,
                col = col,
                style = "minimal",
                border = "single",
            })

            vim.fn.termopen({ "bash", "-c", cmd }, {
                on_exit = function(_, code)
                    vim.schedule(function()
                        if vim.api.nvim_win_is_valid(win) then
                            vim.api.nvim_win_close(win, true)
                        end
                        if code == 0 and vim.fn.filereadable(tmpfile) == 1 then
                            local selection = vim.fn.readfile(tmpfile)[1]
                            if selection and selection ~= "" then
                                oil.open(selection)
                            end
                        end
                        pcall(vim.fn.delete, tmpfile)
                    end)
                end,
            })
            vim.api.nvim_buf_set_option(buf, "filetype", "fzf")
            vim.cmd.startinsert()
        end

        require("oil").setup({
        default_file_explorer = true,
        columns = {"icon", 
                -- {"mtime", format = "%Y-%m-%d %H:%M"}
            },
        keymaps = {
        ["?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-r>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["<C-q>"] = { "actions.send_to_qflist", mode="n" },
      },
    use_default_keymaps=false,
      view_options = {
        show_hidden = true,
      }
    })
    vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>", { noremap = true, silent = true })

    -- In Oil buffers, map `z` to open the zoxide Telescope picker with a distinct, slightly smaller layout.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function(event)
        local ok, zoxide = pcall(require, "custom.telescope.zoxide")
        if not ok then return end
        vim.keymap.set("n", "z", function()
          zoxide({
            layout_strategy = "vertical",
            layout_config = { width = 0.8, height = 0.7 },
          })
        end, { buffer = event.buf, desc = "Zoxide (Telescope)" })
        vim.keymap.set("n", "f", oil_fzf_dir_picker, { buffer = event.buf, desc = "FZF dir picker (Oil)" })
      end,
    })
  end,
}

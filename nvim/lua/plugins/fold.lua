return {

	-- lazy.nvim
	{
		"chrisgrieser/nvim-origami",
		event = "VeryLazy",
		opts = {}, -- needed even when using default config

		-- recommended: disable vim's auto-folding
		init = function()
			vim.opt.foldlevel = 99
			vim.opt.foldlevelstart = 99
		end,
		config = function()
			-- default settings
			require("origami").setup {
				useLspFoldsWithTreesitterFallback = true,
				pauseFoldsOnSearch = true,
				foldtext = {
					enabled = true,
					padding = 3,
					lineCount = {
						template = "%d lines", -- `%d` is replaced with the number of folded lines
						hlgroup = "Comment",
					},
					diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
					gitsignsCount = true, -- requires `gitsigns.nvim`
					disableOnFt = { "snacks_picker_input" }, ---@type string[]
				},
				autoFold = {
					enabled = true,
					kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
				},
				foldKeymaps = {
					setup = true, -- modifies `h`, `l`, `^`, and `$`
					closeOnlyOnFirstColumn = false, -- `h` and `^` only close in the 1st column
				},
			}
		end
	},

	-- UFO folding
	-- {
	--     "kevinhwang91/nvim-ufo",
	--     dependencies = {
	--         "kevinhwang91/promise-async",
	--         {
	--             "luukvbaal/statuscol.nvim",
	--             config = function()
	--                 local builtin = require("statuscol.builtin")
	--                 require("statuscol").setup({
	--                     relculright = true,
	--                     segments = {
	--                         { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
	--                         { text = { "%s" },                  click = "v:lua.ScSa" },
	--                         { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
	--                     },
	--                 })
	--             end,
	--         },
	--     },
	--     -- event = "BufReadPost",
	--     enabled=False,
	--     opts = {
	--         provider_selector = function()
	--             return { "treesitter", "indent" }
	--         end,
	--     },
	--
	--     init = function()
	--         -- UFO folding
	--         vim.o.foldcolumn = "1"    -- '0' is not bad
	--         vim.o.foldlevel = 99      -- Using ufo provider need a large value, feel free to decrease the value
	--         vim.o.foldlevelstart = 99 -- Start with all folds open
	--         vim.o.foldenable = true
	--         vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
	--     end,
	--     config = function()
	--         require('ufo').setup()
	--
	--         -- Remove the z operator and keep only some subcommands
	--         -- we do this to avoid setting foldlevel=0 with zM
	--         local z_commands = {
	--             -- Vertical positioning
	--             "zz", "zt", "zb",
	--             -- Folds
	--             "zc", "zo", "za", "zd", "zO", "zA", "zC", "zD", "zE",
	--             "zj", "zk", -- Fold navigation
	--             -- Spelling
	--             "zg", "zw", "z=",
	--             -- Horizontal scrolling
	--             "zh", "zl", "zH", "zL"
	--         }
	--
	--         for _, key in ipairs(z_commands) do
	--             -- Using pcall ensures that if a key doesn't exist in your version, it won't crash
	--             pcall(vim.keymap.set, "n", key, key, { noremap = true })
	--         end
	--
	--
	--         vim.keymap.set("n", "z", "<Nop>", { noremap = true })
	--
	--         vim.keymap.set('n', "zR", function() require("ufo").openAllFolds() end,
	--             { desc = "open all folds", silent = true, noremap = true })
	--         vim.keymap.set('n', "zM", function()
	--                 require("ufo").closeAllFolds()
	--             end,
	--             { desc = "close all folds", silent = true, noremap = true })
	--         vim.keymap.set('n', "zr", function() require("ufo").openFoldsExceptKinds() end,
	--             { desc = "open folds except kinds", silent = true, noremap = true })
	--         vim.keymap.set('n', "zm", function() require("ufo").closeFoldsWith() end,
	--             { desc = "close folds with", silent = true, noremap = true })
	--     end
	-- }
}

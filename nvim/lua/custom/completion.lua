local opts = {
    keymap = { 
    preset = "default" ,
    ['<F12>'] = {'show' ,'show_documentation', 'hide_documentation'},
    ['<C-h>'] = {'show' ,'show_documentation', 'hide_documentation'},
    ['<C-f>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-b>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-y>'] = { 'accept_and_enter', 'fallback' },
    ["<S-Tab>"] = {
      function(cmp)
        -- if vim.b[vim.api.nvim_get_current_buf()].nes_state then
          -- cmp.hide()
          -- return (
                -- require("copilot-lsp.nes").apply_pending_nes() 
                -- and require("copilot-lsp.nes").walk_cursor_end_edit()
            -- )
        -- end
        if cmp.snippet_active() then
            return cmp.accept()
        else
            return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },


    },
    completion = {
      ghost_text = { enabled = true },
      list = { selection = { auto_insert = false } },
      documentation = { auto_show = false, window = { border = "rounded" } },
      menu = {
        draw = {
          padding = 0,
          columns = { { "kind_icon", gap = 1 }, { gap = 1, "label" }, { "kind", gap = 2 } },
          components = {
            kind_icon = {
              text = function(ctx)
                return " " .. ctx.kind_icon .. " "
              end,
              highlight = function(ctx)
                return "BlinkCmpKindIcon" .. ctx.kind
              end,
            },
            kind = {
              text = function(ctx)
                return " " .. ctx.kind .. " "
              end,
            },
          },
        },
      },
    },
    sources = {
      default = {"lazydev", "buffer", "snippets", "path" , "copilot",  "lsp"},
      -- default = { "copilot", "lsp", "snippets", "path" ,"buffer", "dictionary" },
      per_filetype = {
        markdown = { "lsp"},
        AvanteInput = {},
        Avante = {},
      },
      providers = {
        dictionary = {
          module = "blink-cmp-dictionary",
          min_keyword_length = 3,
        },
        lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
        },
        copilot = {
            name = "Copilot",
            module = "blink-copilot",
            enabled = function()
                -- Copilot is disabled by default; only enabled explicitly via
                -- <leader>co or :ToggleAI (see nvim/plugin/ai.lua).
                return vim.g.blink_cmp_copilot_enabled == true
            end,
            -- max_completions=5,
            -- score_offset = 100,
            deduplicate = {
                enabled = true,
            },
            async = true,
        }
    }
    },
    fuzzy = { implementation = "prefer_rust" },
}


require("blink.cmp").setup(opts)

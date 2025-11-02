


local old_config = {
{
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "Kaiser-Yang/blink-cmp-dictionary",
  },
  version = '1.*',
  opts = {
    keymap = { 
    preset = "default" ,
    ['<F12>'] = {'show' ,'show_documentation', 'hide_documentation'},
    ['<C-h>'] = {'show' ,'show_documentation', 'hide_documentation'},
    ['<C-f>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-b>'] = { 'scroll_documentation_down', 'fallback' },
    

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
      default = { "lsp", "snippets","path", "buffer", "dictionary", "copilot"  },
      providers = {
        dictionary = {
          module = "blink-cmp-dictionary",
          min_keyword_length = 3,
        },
      }
    },
    fuzzy = { implementation = "prefer_rust" },
  },
  opts_extend = { "sources.default" },
}
}


return {
{
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.compat",
      "fang2hou/blink-copilot",
      "copilotlsp-nvim/copilot-lsp",
      "rafamadriz/friendly-snippets",
      "Kaiser-Yang/blink-cmp-dictionary",
    },
    version = '1.*',
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("custom.blink")
    end,
}
}



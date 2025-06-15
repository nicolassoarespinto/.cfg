return {
   'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante", "quarto" },
        heading = {
          --  border_virtual = true,
         --   border_prefix = false,
        },
        code = {
            enabled = true,
            style = "normal",
            border = "thin",
        },
        pipe_table = {
        style = 'normal'
    },
        render_modes = true,
    },
    dependencies = {
    "nvim-tree/nvim-web-devicons",
    },
}

return {
   'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
        heading = {
          --  border_virtual = true,
         --   border_prefix = false,
        },
        code = {
            enabled = true,
            style = "normal",
        }
      },
    dependencies = {
    "nvim-tree/nvim-web-devicons",
    },
}

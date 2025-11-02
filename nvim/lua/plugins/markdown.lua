return {
{
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    file_types = { "markdown", "Avante", "quarto" },
    heading = {
      --  border_virtual = true,
      --   border_prefix = false,
    },
    ignore = function(buf)
        local bufsize = vim.api.nvim_buf_line_count(buf)
        if bufsize > 5000 then
            vim.notify("buffer too large: " .. bufsize .. " lines")
            vim.notify("buffer: " .. vim.api.nvim_buf_get_name(buf))
            return true
        end
        return false
    end,
      code = {
      enabled = true,
      style = "normal",
      border = "thin",
    },
    pipe_table = {
      style = 'normal'
    },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
},
{"ellisonleao/glow.nvim", config = true, cmd = "Glow"}
}

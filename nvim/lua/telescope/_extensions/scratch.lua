local scratch = require("custom.telescope.scratch")

return require("telescope").register_extension({
  exports = {
    files = scratch.files,
    grep = scratch.grep,
  },
})

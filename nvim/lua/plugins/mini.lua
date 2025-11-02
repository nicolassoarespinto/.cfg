return {
{
    'nvim-mini/mini.surround',
    version = '*',
    keys = {
      { 'sa', desc = 'Add surrounding', mode = { 'n', 'v' } },
      { 'sd', desc = 'Delete surrounding' },
      { 'sf', desc = 'Find right surrounding' },
      { 'sF', desc = 'Find left surrounding' },
      { 'sh', desc = 'Highlight surrounding' },
      { 'sr', desc = 'Replace surrounding' },
    },
    opts = {
      -- Number of lines within which surrounding is searched
      n_lines = 50,
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
      },
    },
  }
}

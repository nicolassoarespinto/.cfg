-- Function to insert a new Marimo cell


function ToggleNotebookMode()
    if vim.g.notebook_target == nil or vim.g.notebook_target == 'marimo' then
        vim.g.notebook_target = 'quarto'
        vim.notify('Notebook set to quarto')
    else
        vim.g.notebook_target = 'marimo'
        vim.notify('Notebook set to marimo')
    end
end

function InsertCodeCell()
  -- Ensure notebook_target is set
  if vim.g.notebook_target == nil then
      ToggleNotebookMode()
  end

  -- Define the cell template
  local marimo_cell_template = {
    "```python {.marimo}",
    "",
    "```",
  }
  local quarto_cell_template = {
    "```{python} ",
    "  #| echo: false",
    "",
    "```",
  }

    local cell_template = vim.g.notebook_target == 'marimo' and marimo_cell_template or quarto_cell_template
  -- Insert the cell template at the current cursor position
  vim.api.nvim_put(cell_template, 'l', true, true)
end




-- Create a custom command for inserting a Marimo cell
vim.api.nvim_create_user_command('InsertMarimoCell', InsertCodeCell, { desc = 'Insert a new Marimo cell' })

-- Create a custom command for toggling notebook mode
vim.api.nvim_create_user_command('ToggleNotebookMode', ToggleNotebookMode, { desc = 'Toggle between Marimo and Quarto modes' })

-- Map <M-T> to toggle notebook mode
vim.api.nvim_set_keymap('n', '<M-T>', ':ToggleNotebookMode<CR>', { noremap = true, silent = true })

-- Map <M-I> to insert a new Marimo cell
vim.api.nvim_set_keymap('n', '<M-I>', ':InsertMarimoCell<CR>', { noremap = true, silent = true })
















-- Function to insert a new Marimo cell
function InsertMarimoCell()
  -- Define the cell template
  local cell_template = {
	"```python {.marimo}",
	"",
	"```",
	}
  -- Insert the cell template at the current cursor position
  vim.api.nvim_put(cell_template, 'l', true, true)
end




-- Create a custom command for inserting a Marimo cell
vim.api.nvim_create_user_command('InsertMarimoCell', InsertMarimoCell, { desc = 'Insert a new Marimo cell' })

-- Map <leader>mc to insert a new Marimo cell
vim.api.nvim_set_keymap('n', '<M-I>', ':InsertMarimoCell<CR>', { noremap = true, silent = true })
















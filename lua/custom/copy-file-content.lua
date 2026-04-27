-- ~/.config/nvim-vscode/lua/custom/copy-file-content.lua
-- VS CODE NEOVIM IMPLEMENTATION

--- Copies the entire content of the current file to the clipboard
-- by running a JavaScript snippet in the VS Code host.
local function copy_entire_file_content_vscode()
  local vscode = require 'vscode'

  -- This JavaScript snippet runs inside VS Code and has access to its full API.
  local js_code = [[
      const editor = vscode.window.activeTextEditor;
      if (!editor) { return false; } // Should not happen
      const fileContent = editor.document.getText();
      await vscode.env.clipboard.writeText(fileContent);
      return true; // Return a success signal
  ]]

  -- vscode.eval runs the JavaScript and returns the result.
  local success, err = vscode.eval(js_code)

  if err or not success then
    vim.notify('VSCode: Failed to copy file content.', vim.log.levels.ERROR)
  end
end

-- Create a user command that we can call from our keymap
vim.api.nvim_create_user_command('CopyFileContent', copy_entire_file_content_vscode, { desc = 'Copy the entire file content to the clipboard via VSCode API' })

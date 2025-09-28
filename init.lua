-- ~/.config/nvim/vscode-init.lua
-- This is a dedicated config for the vscode-neovim extension.

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with our plugins
require("lazy").setup({
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		-- Use `main` and `opts` for a more robust setup with lazy.nvim
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"typescript",
				"javascript",
				"css",
				"json",
				"tsx",
				"svelte",
				"rust",
				"go",
				"gomod",
				"gowork",
				"gosum",
			},
			auto_install = true,
			highlight = {
				enable = false, -- Let VS Code handle highlighting
			},
			indent = {
				enable = false, -- Let VS Code handle indentation
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
						["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
						["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
						["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
						["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
						["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
						["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
						["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
						["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
						["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
						["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
						["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
						["am"] = {
							query = "@function.outer",
							desc = "Select outer part of a method/function definition",
						},
						["im"] = {
							query = "@function.inner",
							desc = "Select inner part of a method/function definition",
						},
						["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>na"] = "@parameter.inner",
						["<leader>n:"] = "@property.outer",
						["<leader>nm"] = "@function.outer",
					},
					swap_previous = {
						["<leader>pa"] = "@parameter.inner",
						["<leader>p:"] = "@property.outer",
						["<leader>pm"] = "@function.outer",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = { query = "@call.outer", desc = "Next function call start" },
						["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
						["]c"] = { query = "@class.outer", desc = "Next class start" },
						["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
						["]l"] = { query = "@loop.outer", desc = "Next loop start" },
					},
					goto_next_end = {
						["]F"] = { query = "@call.outer", desc = "Next function call end" },
						["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
						["]C"] = { query = "@class.outer", desc = "Next class end" },
						["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
						["]L"] = { query = "@loop.outer", desc = "Next loop end" },
					},
					goto_previous_start = {
						["[f"] = { query = "@call.outer", desc = "Prev function call start" },
						["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
						["[c"] = { query = "@class.outer", desc = "Prev class start" },
						["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
						["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
					},
					goto_previous_end = {
						["[F"] = { query = "@call.outer", desc = "Prev function call end" },
						["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
						["[C"] = { query = "@class.outer", desc = "Prev class end" },
						["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
						["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
					},
				},
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "gnp",
					scope_incremental = "gns",
					node_decremental = "gnm",
				},
			},
		},
		-- This config function will run AFTER the plugin has been setup with the `opts` table.
		config = function(_, opts)
			-- We need to call setup again here to apply the opts.
			require("nvim-treesitter.configs").setup(opts)

			-- Keymaps for repeatable textobject motions
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
		end,
	},
})

-- The most important line: allows Neovim to talk to VS Code.
local vscode = require("vscode")

-- Set a leader key. Space is a common and good choice.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -----------------------------------------------------------------
-- Essential Options
-- -----------------------------------------------------------------
vim.opt.clipboard = "unnamedplus" -- CRITICAL: Use system clipboard for copy/paste
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.number = true -- Show the absolute number on the current line

vim.opt.ignorecase = true -- Case-insensitive searching...
vim.opt.smartcase = true -- ...unless you type a capital letter

vim.opt.hlsearch = true -- Highlight all search results
vim.opt.incsearch = true -- Show search results as you type

-- Make j and k move by visual lines when word wrap is on
vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("v", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("v", "k", "gk", { noremap = true, silent = true })

-- -----------------------------------------------------------------
-- What NOT to put here:
-- -----------------------------------------------------------------
-- 1. Plugin managers (lazy.nvim, packer)
-- 2. UI plugins (NvimTree, Telescope, Lualine)
-- 3. Colorschemes (tokyonight, etc.)
-- 4. LSP clients (lspconfig, mason)
-- 5. Autocompletion engines (nvim-cmp)
--
-- Let VS Code handle all of that! We just want Neovim for its text editing power.

-- -----------------------------------------------------------------
-- Keymaps: The heart of the integration!
-- We map Vim keys to execute VS Code commands.
-- -----------------------------------------------------------------
local map = vim.keymap.set

-- Save File: Ctrl+S
-- See the vscode keybindings.json

-- Quit Editor/Tab: Ctrl+Q
-- This tells Neovim to ask VS Code to close the current editor tab.
map({ "n", "i", "v", "c" }, "<C-q>", function()
	vscode.action("workbench.action.closeActiveEditor")
end, { desc = "VSCode Close Editor" })

-- Indentation: Tab and Shift+Tab
-- In Normal and Visual mode, we want Tab/S-Tab to trigger VS Code's indent commands.
map("n", "<Tab>", function()
	vscode.action("editor.action.indentLines")
end, { desc = "VSCode Indent Line" })
map("n", "<S-Tab>", function()
	vscode.action("editor.action.outdentLines")
end, { desc = "VSCode Outdent Line" })
map("v", "<Tab>", function()
	vscode.action("editor.action.indentLines")
end, { desc = "VSCode Indent Selection" })
map("v", "<S-Tab>", function()
	vscode.action("editor.action.outdentLines")
end, { desc = "VSCode Outdent Selection" })

-- Go to Start/End of Line (Alt+H, Alt+L)
-- These mappings are triggered by the passthrough rules in keybindings.json
-- We map them to Neovim's native motions to preserve composition (e.g., d$, c^).
map({ "n", "v" }, "<A-h>", "^", { desc = "Go/Select to First Non-Blank" })
map({ "n", "v" }, "<A-l>", "$", { desc = "Go/Select to End of Line" })

-- =================================================================
-- LSP & Diagnostics Mappings
-- =================================================================

-- Show Hover Information (<leader>k)
-- This tells Neovim to ask VS Code to show its hover/LSP information.
map("n", "<leader>k", function()
	vscode.action("editor.action.showHover")
end, { desc = "VSCode Show Hover Info" })

-- Navigate Diagnostics (]d and [d)
-- These tell Neovim to ask VS Code to jump to the next/previous problem.
map("n", "]d", function()
	vscode.action("editor.action.marker.next")
end, { desc = "Go to Next Diagnostic (Current File)" })

map("n", "[d", function()
	vscode.action("editor.action.marker.prev")
end, { desc = "Go to Previous Diagnostic (Current File)" })

-- Go to Definition
map({ "n", "v", "i" }, "<F12>", function()
	vscode.action("editor.action.revealDefinition")
end, { desc = "Go to Definition" })

-- Rename Symbol
map({ "n", "v", "i" }, "<F2>", function()
	vscode.action("editor.action.rename")
end, { desc = "Rename Symbol" })

-- =================================================================
-- Clipboard Mappings (SIMPLE AND CORRECT)
-- =================================================================

-- In NORMAL mode, map Ctrl+C to yank the current line.
map("n", "<C-c>", "yy", { desc = "Copy Line to System Clipboard" })

-- In VISUAL mode, map Ctrl+C to a simple yank and escape macro.
map("v", "<C-c>", "y<Esc>", { desc = "Copy Selection and Exit Visual Mode" })

-- Paste mappings.
map("n", "<C-v>", "p", { desc = "Paste from System Clipboard" })
map("v", "<C-v>", "p", { desc = "Paste over Selection from System Clipboard" })

-- Cut mappings.
map("n", "<C-x>", "dd", { desc = "Cut Line to System Clipboard" })
map("v", "<C-x>", "d", { desc = "Cut Selection to System Clipboard" })

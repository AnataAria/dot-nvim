local capabilities = {
	offsetEncoding = { "utf-16" },
	textDocument = {
		foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		},

		completion = {
			dynamicRegistration = false,
			completionItem = {
				snippetSupport = true,
				commitCharactersSupport = true,
				deprecatedSupport = true,
				preselectSupport = true,
				tagSupport = {
					valueSet = {
						1, -- Deprecated
					},
				},
				insertReplaceSupport = true,
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
				insertTextModeSupport = {
					valueSet = {
						1, -- asIs
						2, -- adjustIndentation
					},
				},
				labelDetailsSupport = true,
			},
			contextSupport = true,
			insertTextMode = 1,
			completionList = {
				itemDefaults = {
					"commitCharacters",
					"editRange",
					"insertTextFormat",
					"insertTextMode",
					"data",
				},
			},
		},
	},
}

local servers = {
	clangd = {},
	cssls = {},
	cssmodules_ls = {},
	emmet_language_server = {
		filetypes = {
			"templ",
			"css",
			"eruby",
			"html",
			"javascript",
			"javascriptreact",
			"less",
			"sass",
			"scss",
			"svelte",
			"pug",
			"typescriptreact",
			"vue",
			-- 'rust'
		},
	},
	html = {},
	jsonls = {},
	zls = {},
	bashls = {},
	dockerls = {},
	svelte = {},
	eslint = {},
	vtsls = {},
	tinymist = {
		settings = {
			exportPdf = "onType",
		},
	},
	templ = {},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = { neededFileStatus = { ["codestyle-check"] = "Any" } },
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						[vim.fn.stdpath("data") .. "/lazy/emmylua-nvim"] = true,
					},
					maxPreload = 100000,
				},
				hint = {
					enable = true,
				},
			},
		},
	},
}
local on_attach = function(client, bufnr)
	local lsp_util = require("util.lsp")
	-- lsp_util.code_lens_attach(client, bufnr)
	require("util.lsp").inlay_hint_attach(client, bufnr)

	vim.keymap.set("n", "<leader>lf", "<cmd>Lspsaga finder<CR>", {
		buffer = bufnr,
	})
	vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>", {
		buffer = bufnr,
	})
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
		buffer = bufnr,
	})
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
		buffer = bufnr,
	})
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
		buffer = bufnr,
	})
	vim.keymap.set({ "n", "v" }, "<leader>fm", require("util.lsp").format, {
		buffer = bufnr,
	})
	vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", {
		buffer = bufnr,
	})
	vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", {
		buffer = bufnr,
	})
	vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", {
		buffer = bufnr,
	})
	vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {
		buffer = bufnr,
	})
	if client.name == "eslint" then
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end
	if client.name == "sqls" then
		require("sqls").on_attach(client, bufnr)
	end
end
return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = servers,
			lazy = false,
			config = function(_, opts)
				for server, server_opts in pairs(servers) do
					server_opts.capabilities = capabilities
					require("lspconfig")[server].setup(server_opts)
				end

				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(args)
						if not (args.data and args.data.client_id) then
							return
						end

						local bufnr = args.buf
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						on_attach(client, bufnr)
					end,
				})
				require("lspconfig.ui.windows").default_options.border = "rounded"
			end,
		},
	},
	{
		"nvim-java/nvim-java",
		config = false,
		dependencies = {
			{
				"neovim/nvim-lspconfig",
				opts = {
					servers = {
						jdtls = {
							settings = {
								java = {
									configuration = {},
								},
							},
							root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml" }),
						},
					},
					setup = {
						jdtls = function()
							require("java").setup({
								root_markers = {
									"settings.gradle",
									"settings.gradle.kts",
									"pom.xml",
									"build.gradle",
									"mvnw",
									"gradlew",
									"build.gradle",
									"build.gradle.kts",
								},
								cmd = {
									"java",
									"-Declipse.application=org.eclipse.jdt.ls.core.id1",
									"-Dosgi.bundles.defaultStartLevel=4",
									"-Declipse.product=org.eclipse.jdt.ls.core.product",
									"-Dlog.protocol=true",
									"-Dlog.level=ALL",
									"-Xmx1g",
									"--add-modules=ALL-SYSTEM",
									"--add-opens",
									"java.base/java.util=ALL-UNNAMED",
									"--add-opens",
									"java.base/java.lang=ALL-UNNAMED",
								},
								init_options = {
									useProjectReferences = false,
								},
							})
						end,
					},
				},
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
		init = function()
			vim.g.rustaceanvim = {
				tools = { inlay_hints = { auto = false } },
				server = {
					capabilities = capabilities,
					on_attach = function(_, bufnr)
						vim.keymap.set("n", "<leader>cR", function()
							vim.cmd.RustLsp("codeAction")
						end, { desc = "Code Action", buffer = bufnr })
						vim.keymap.set("n", "<leader>dr", function()
							vim.cmd.RustLsp("debuggables")
						end, { desc = "Rust Debuggables", buffer = bufnr })
					end,
					settings = {
						["rust-analyzer"] = {
							checkOnSave = {
								command = "clippy",
							},
							diagnostics = {
								enable = true,
								experimental = { enable = true },
							},
							procMacro = {
								enable = true,
								ignored = {
									["async-trait"] = { "async-trait" },
									["napi-derive"] = { "napi" },
									["async-recursion"] = { "async-recursion" },
								},
							},
							files = {
								excludeDirs = {
									".direnv",
									".git",
									".github",
									".gitlab",
									"bin",
									"node_modules",
									"target",
									"venv",
									".venv",
								},
							},
						},
					},
				},
			}
		end,
	},
	{
		"mfussenegger/nvim-ansible",
		ft = {},
		keys = {
			{
				"<leader>ta",
				function()
					require("ansible").run()
				end,
				desc = "Ansible Run Playbook/Role",
				silent = true,
			},
		},
	},
}

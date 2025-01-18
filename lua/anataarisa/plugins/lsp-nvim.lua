return {
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
		ft = "rust",
		init = function()
			vim.g.rustaceanvim = {
				tools = { inlay_hints = { auto = false } },
				server = {
					settings = {
						["rust-analyzer"] = {
							checkOnSave = {
								command = "clippy",
							},
							diagnostics = {
								enable = true,
								experimental = { enable = true },
							},
						},
					},
				},
			}
		end,
	},
}

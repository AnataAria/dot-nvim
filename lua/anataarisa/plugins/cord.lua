return {
	'vyfor/cord.nvim',
        build = './build || .\\build',
        event = 'VeryLazy',
        opts = {
            display = {
                show_time = true,            -- Display start timestamp
                show_repository = true,      -- Display 'View repository' button linked to repository url, if any
                show_cursor_position = true, -- Display line and column number of cursor's position
                swap_fields = false,         -- If enabled, workspace is displayed first
                swap_icons = false,          -- If enabled, editor is displayed on the main image
                workspace_blacklist = {},    -- List of workspace names that will hide rich presence
            },
        },              
}

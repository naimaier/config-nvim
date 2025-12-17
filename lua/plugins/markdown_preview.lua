return {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    config = function ()
        vim.cmd [[
            let g:mkdp_theme = 'light'
            let g:mkdp_command_for_global = 1
        ]]
    end
}

local lsp = require('lsp-zero').preset("minimal")
local lsp_signature = require("lsp_signature")

lsp_signature.setup({
    bind = true,
    handler_opts = {
        border = "single"
    },
    select_signature_key = "<M-n>"
})

lsp.ensure_installed({
    'clangd',
    'lua_ls'
})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    local opts = {buffer = bufnr, remap = false, silent = true}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<C-O>", ":ClangdSwitchSourceHeader<CR>", opts)
    vim.keymap.set('n', '<leader>pp', function () vim.diagnostic.open_float() end, opts)

    if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, bufnr)
    end

end)

lsp.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

lsp.set_server_config({
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    },
    general = {
      positionEncodings = { 'utf-16' },
    },
    offsetEncoding = {'utf-16'}
  },
  offsetEncoding = {'utf-16'}
})

require('lspconfig').clangd.setup{
    cmd={"clangd", "--background-index", "--clang-tidy", "--completion-style=bundled", "--header-insertion=never", "--suggest-missing-includes", "--cross-file-rename", "--enable-config", "--limit-results=0", "--header-insertion-decorators", "-j=8", "--folding-ranges"}
}

require('lspconfig').glsl_analyzer.setup{}


lsp.setup()



local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
        -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
})


local lspkind = require('lspkind')
cmp.setup({
    window = {
        completion = cmp.config.window.bordered({
            border = 'rounded',
            winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenu,CursorLine:CmpSelect,Search:None',
        }),
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

        })
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
    },
    mapping = cmp_mappings,
})



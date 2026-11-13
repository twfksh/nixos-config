-- Buffer-local LSP navigation.
--
-- Neovim 0.12 already provides grn (rename), gra (code action), grr
-- (references), gri (implementation), grt (type definition) and gO (document
-- symbol). What is missing is gd/gD, which without this only search tags
-- files. Jumps that resolve to several locations go through vim.ui.select,
-- which fzf-lua handles (see the ui_select option in init.lua).
local M = {}

local maps = {
    { 'gd', 'textDocument/definition', vim.lsp.buf.definition, 'Go to definition' },
    { 'gD', 'textDocument/declaration', vim.lsp.buf.declaration, 'Go to declaration' },
}

-- Only map what the attached servers can answer. Mapping unconditionally would
-- shadow Vim's tags lookup in buffers where no client supports the request.
local function supports(bufnr, method)
    for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
        if client:supports_method(method, bufnr) then
            return true
        end
    end
    return false
end

function M.setup()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_mappings', { clear = true }),
        callback = function(args)
            for _, map in ipairs(maps) do
                local lhs, method, rhs, desc = map[1], map[2], map[3], map[4]
                if supports(args.buf, method) then
                    vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
                end
            end
        end,
    })

    -- Diagnostics are not an LSP command, but they are the other half of the
    -- same workflow. `gl` is end of line here, so use the bracket pairs.
    vim.keymap.set('n', ']d', function()
        vim.diagnostic.jump { count = 1 }
    end, { desc = 'Next diagnostic' })
    vim.keymap.set('n', '[d', function()
        vim.diagnostic.jump { count = -1 }
    end, { desc = 'Previous diagnostic' })
end

return M

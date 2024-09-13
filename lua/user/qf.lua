
local fn = vim.fn

local namespace = vim.api.nvim_create_namespace('qf_highlight')

function _G.qftf(info)
    local items
    local ret = {}
    local highlights = {}
    -- The name of item in list is based on the directory of quickfix window.
    -- Change the directory for quickfix window make the name of item shorter.
    -- It's a good opportunity to change current directory in quickfixtextfunc :)
    --
    -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
    -- local root = getRootByAlterBufnr(alterBufnr)
    -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
    --
    local qf
    if info.quickfix == 1 then
        qf = fn.getqflist({id = info.id, items = 0, qfbufnr = 0})
        items = qf.items
    else
        qf = fn.getloclist(info.winid, {id = info.id, items = 0}).items
        items = qf.items
    end
    local limit = 31
    local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
    local validFmt = '%s │%5d:%-3d│%s %s'
    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local fname = ''
        local str
        if e.valid == 1 then
            if e.bufnr > 0 then
                fname = fn.bufname(e.bufnr)
                if fname == '' then
                    fname = '[No Name]'
                else
                    fname = fname:gsub('^' .. vim.env.HOME, '~')
                end
                -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
                if #fname <= limit then
                    fname = fnameFmt1:format(fname)
                else
                    fname = fnameFmt2:format(fname:sub(1 - limit))
                end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, e.text)
            if e.type == 'e' or e.type == 'f' then
                table.insert(highlights, {line= i-1, len=#str, hl="DiagnosticError"})
            elseif e.type == 'w' then
                table.insert(highlights, {line= i-1, len=#str, hl="DiagnosticWarn"})
            elseif e.type == 'i' then
                table.insert(highlights, {line= i-1, len=#str, hl="DiagnosticInfo"})
            elseif e.type == 'h' then
                table.insert(highlights, {line= i-1, len=#str, hl="DiagnosticHint"})
            else
                print('unknown type', e.type, e.text)
            end
        else
            str = e.text
            table.insert(highlights, {line=i-1, len=#str, hl="Normal"})
        end
        str = str:gsub("\r", "")
        table.insert(ret, str)
    end

    vim.schedule(function()
        for _, h in ipairs(highlights) do
            vim.highlight.range(qf.qfbufnr, namespace, h.hl, {h.line, 0}, {h.line, h.len})
        end
    end)
    return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'

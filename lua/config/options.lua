local o = vim.opt

o.termguicolors = true
o.clipboard = "unnamedplus"
o.mouse = "a"
o.number = true
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.smartindent = true
o.expandtab = true -- replace tab with spaces
o.wrap = true
-- o.backspace = "indent, eol, start" -- check
o.belloff = "all"
o.encoding = "utf-8"
o.fileencoding = "utf-8"
o.scrolloff = 5
o.laststatus = 3
o.title = true
o.splitbelow = true
o.splitright = true
o.smartcase = true

o.gdefault = true -- Never have to type /g at the end of search / replace again
o.ignorecase = true
o.hlsearch = false
o.incsearch = true
o.showmatch = true

o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevel = 99

o.background = "dark"
o.cursorline = true

o.undofile = true -- persistent undo

o.cindent = true
--cinoptions = "g0"

o.signcolumn = "number" -- prevent text from being shifted when a diagnostic appears
o.updatetime = 300

o.viewoptions:remove({ "options" })

o.showtabline = 0

o.showmode = false -- we use lualine for this, so disablig it makes noice only show macro recording in the statusline
o.tildeop = true

-- o.cmdheight = 0


if vim.fn.has("win32") == 1 then
    o.shell = "c:\\windows\\system32\\windowspowershell\\v1.0\\powershell.exe"
    o.shellcmdflag = "-nologo -noprofile -executionpolicy remotesigned -command"
    o.shellquote = ""
    o.shellxquote = ""
end

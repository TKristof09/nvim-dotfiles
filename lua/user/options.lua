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
--o.backspace = "indent, eol, start" -- check
o.belloff = "all"
o.encoding = "utf-8"
o.fileencoding = "utf-8"
o.scrolloff = 5
o.laststatus = 2
o.title = true
o.splitbelow = true
o.splitright = true
o.smartcase = true

o.gdefault = true -- Never have to type /g at the end of search / replace again
o.ignorecase = true
o.hlsearch = true
o.incsearch = true
o.showmatch = true

o.foldmethod = "indent"
o.foldlevel = 99

o.background = "dark"
o.cursorline = true

o.undofile = true -- persistent undo

o.cindent = true
--cinoptions = "g0"

o.signcolumn = "number" -- prevent text from being shifted when a diagnostic appears
o.updatetime = 300

o.viewoptions:remove({"options"})

o.showtabline = 0

o.showmode = false -- we use lualine for this, so disablig it makes noice only show macro recording in the statusline


o.shell = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
o.shellquote = ""
o.shellxquote = ""

-- disable background color erase
vim.cmd [[
    if $TERM == "xterm-kitty"
	  let &t_ut=''
	  set termguicolors
				let &t_8f = "\e[38;2;%lu;%lu;%lum"
				let &t_8b = "\e[48;2;%lu;%lu;%lum"
		hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
		let &t_ti = &t_ti . "\033]10;#f6f3e8\007\033]11;#242424\007"
		let &t_te = &t_te . "\033]110\007\033]111\007"
	endif
    ]]

vim.g.undotree_SetFocusWhenToggle = 1

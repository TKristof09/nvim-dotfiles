local white       = "#E8E8E3"
local white2      = "#d8d8d3"
local black       = "#272822"
local lightblack  = "#2D2E27"
local lightblack2 = "#383a3e"
local lightblack3 = "#3f4145"
local darkblack   = "#211F1C"
local grey        = "#8F908A"
local lightgrey   = "#575b61"
local darkgrey    = "#64645e"
local warmgrey    = "#75715E"

local pink        = "#F92772"
local green       = "#A6E22D"
local aqua        = "#66d9ef"
local yellow      = "#E6DB74"
local orange      = "#FD9720"
local purple      = "#ae81ff"
local red         = "#e73c50"
local purered     = "#ff0000"
local darkred     = "#5f0000"

local addfg       = "#d7ffaf"
local addbg       = "#5f875f"
local delbg       = "#f75f5f"
local changefg    = "#d7d7ff"
local changebg    = "#5f5f87"

local cyan        = "#A1EFE4"
local br_green    = "#9EC400"
local br_yellow   = "#E7C547"
local br_blue     = "#7AA6DA"
local br_purple   = "#B77EE0"
local br_cyan     = "#54CED6"
local br_white    = "#FFFFFF"

local bg_blue     = "#252732"
local bg_cmp      = "#3c3f51"
local greenish    = "#68d966"
local greenishblue ="#17ffb9"
local blue        = "#178fff"
local darkblue    = "#3b8af7"

local addbg       = "#2C7027"
local delbg       = "#822325"
-- Highlighting
-- ------------

-- editor
vim.api.nvim_set_hl(0, "Normal",        { fg = white,      bg = bg_blue })
vim.api.nvim_set_hl(0, "ColorColumn",   {                     bg = lightblack })
vim.api.nvim_set_hl(0, "Cursor",        { fg = black,      bg = white })
vim.api.nvim_set_hl(0, "CursorColumn",  {                     bg = lightblack2 })
vim.api.nvim_set_hl(0, "CursorLine",    {                     bg = lightblack2 })
vim.api.nvim_set_hl(0, "QuickFixLine",  {                     bg = lightgrey })
vim.api.nvim_set_hl(0, "NonText",       { fg = lightgrey })
vim.api.nvim_set_hl(0, "StatusLine",    { fg = warmgrey,   bg = black,        reverse = true })
vim.api.nvim_set_hl(0, "StatusLineNC",  { fg = darkgrey,   bg = warmgrey,     reverse = true })
vim.api.nvim_set_hl(0, "TabLine",       { fg = white,      bg = darkblack,    reverse = true })
vim.api.nvim_set_hl(0, "Visual",        {                     bg = lightgrey })
vim.api.nvim_set_hl(0, "Search",        { fg = black,      bg = br_yellow })
vim.api.nvim_set_hl(0, "MatchParen",    { fg = purple,                           underline = true,bold = true, })
vim.api.nvim_set_hl(0, "Question",      { fg = yellow })
vim.api.nvim_set_hl(0, "ModeMsg",       { fg = yellow })
vim.api.nvim_set_hl(0, "MoreMsg",       { fg = yellow })
vim.api.nvim_set_hl(0, "ErrorMsg",      { fg = black,      bg = red,          standout = true })
vim.api.nvim_set_hl(0, "WarningMsg",    { fg = red })
vim.api.nvim_set_hl(0, "VertSplit",     { fg = darkgrey,   bg = darkblack })
vim.api.nvim_set_hl(0, "LineNr",        { fg = grey,       bg = bg_blue })
vim.api.nvim_set_hl(0, "CursorLineNr",  { fg = orange,     bg = bg_blue })
vim.api.nvim_set_hl(0, "SignColumn",    {                     bg = bg_blue })
vim.api.nvim_set_hl(0, "Conceal",       { fg = grey})

-- spell
vim.api.nvim_set_hl(0, "SpellBad",      { fg = red,                              underline = true })
vim.api.nvim_set_hl(0, "SpellCap",      { fg = purple,                           underline = true })
vim.api.nvim_set_hl(0, "SpellRare",     { fg = aqua,                             underline = true })
vim.api.nvim_set_hl(0, "SpellLocal",    { fg = pink,                             underline = true })

-- misc
vim.api.nvim_set_hl(0, "SpecialKey",    { fg = pink })
vim.api.nvim_set_hl(0, "Title",         { fg = yellow })
vim.api.nvim_set_hl(0, "Directory",     { fg = aqua })

-- diff
vim.api.nvim_set_hl(0, "DiffAdd",       { fg = addfg,      bg = addbg })
vim.api.nvim_set_hl(0, "DiffDelete",    { fg = black,      bg = delbg })
vim.api.nvim_set_hl(0, "DiffChange",    { fg = changefg,   bg = changebg })
vim.api.nvim_set_hl(0, "DiffText",      { fg = black,      bg = aqua })

-- fold
vim.api.nvim_set_hl(0, "Folded",        { fg = warmgrey,   bg = darkblack })
vim.api.nvim_set_hl(0, "FoldColumn",    {                     bg = darkblack })
--        Incsearch"

-- popup menu
vim.api.nvim_set_hl(0, "Pmenu",         { fg = white2,     bg = lightblack3 })
vim.api.nvim_set_hl(0, "PmenuSel",      { fg = aqua,       bg = lightblack3,        reverse = true, bold = true })
vim.api.nvim_set_hl(0, "PmenuThumb",    { fg = lightblack, bg = grey })
--        PmenuSbar"

-- Generic Syntax Highlighting
-- ---------------------------

vim.api.nvim_set_hl(0, "Constant",      { fg = purple })
vim.api.nvim_set_hl(0, "Number",        { fg = purple })
vim.api.nvim_set_hl(0, "Float",         { fg = purple })
vim.api.nvim_set_hl(0, "Boolean",       { fg = purple })
vim.api.nvim_set_hl(0, "Character",     { fg = yellow })
vim.api.nvim_set_hl(0, "String",        { fg = yellow })

vim.api.nvim_set_hl(0, "Type",          { fg = darkblue })
vim.api.nvim_set_hl(0, "Structure",     { fg = aqua })
vim.api.nvim_set_hl(0, "StorageClass",  { fg = aqua })
vim.api.nvim_set_hl(0, "Typedef",       { fg = aqua })

vim.api.nvim_set_hl(0, "Identifier",    { fg = green })
vim.api.nvim_set_hl(0, "Function",      { fg = green })

vim.api.nvim_set_hl(0, "Statement",     { fg = pink })
vim.api.nvim_set_hl(0, "Operator",      { fg = pink })
vim.api.nvim_set_hl(0, "Label",         { fg = pink })
vim.api.nvim_set_hl(0, "Keyword",       { fg = pink })
--        Conditional"
--        Repeat"
--        Exception"

vim.api.nvim_set_hl(0, "PreProc",       { fg = green })
vim.api.nvim_set_hl(0, "Include",       { fg = pink })
vim.api.nvim_set_hl(0, "Define",        { fg = pink })
vim.api.nvim_set_hl(0, "Macro",         { fg = green })
vim.api.nvim_set_hl(0, "PreCondit",     { fg = green })

vim.api.nvim_set_hl(0, "Special",       { fg = purple })
vim.api.nvim_set_hl(0, "SpecialChar",   { fg = pink })
vim.api.nvim_set_hl(0, "Delimiter",     { fg = pink })
vim.api.nvim_set_hl(0, "SpecialComment",{ fg = aqua })
vim.api.nvim_set_hl(0, "Tag",           { fg = pink })
--        Debug"

vim.api.nvim_set_hl(0, "Todo",          { fg = orange,   bold = true,italic = true })
vim.api.nvim_set_hl(0, "Comment",       { fg = warmgrey, italic = true })

vim.api.nvim_set_hl(0, "Ignore",        {})
vim.api.nvim_set_hl(0, "Error",         { fg = red, bg = darkred })

vim.api.nvim_set_hl(0, "@variable", {link = "Normal"})
vim.api.nvim_set_hl(0, "@function.builtin", {link = "Function"})
vim.api.nvim_set_hl(0, "@constructor", {link = "Structure"})
vim.api.nvim_set_hl(0, "@type.python", {link = "Structure"})
vim.api.nvim_set_hl(0, "@type.qualifier", {link = "Keyword"})
vim.api.nvim_set_hl(0, "@type.builtin", {link = "Type"})
vim.api.nvim_set_hl(0, "@variable.builtin", {link = "Keyword"})
vim.api.nvim_set_hl(0, "@attribute.cpp", {link = "Normal"})

vim.api.nvim_set_hl(0, "@lsp.type.class", {link = "Structure"})
vim.api.nvim_set_hl(0, "@lsp.type.variable", {link = "Normal"})
vim.api.nvim_set_hl(0, "@lsp.type.paramater", {link = "Normal"})
vim.api.nvim_set_hl(0, "@lsp.type.property", {link = "Normal"})
vim.api.nvim_set_hl(0, "@lsp.typemod.class.defaultLibrary", {link = "Type"})
vim.api.nvim_set_hl(0, "@lsp.type.operator", {link = "Operator"})
vim.api.nvim_set_hl(0, "@lsp.type.enum.cpp", {link = "Structure"})
vim.api.nvim_set_hl(0, "@lsp.typemod.function.defaultLibrary", { fg = greenish })
vim.api.nvim_set_hl(0, "LspInlayHint",            { fg = grey, italic = true})

-- c
vim.api.nvim_set_hl(0, "cLabel",                      { fg = pink })
vim.api.nvim_set_hl(0, "cStructure",                  { fg = aqua })
vim.api.nvim_set_hl(0, "cStorageClass",               { fg = pink })
vim.api.nvim_set_hl(0, "cInclude",                    { fg = pink })
vim.api.nvim_set_hl(0, "cDefine",                     { fg = pink })
vim.api.nvim_set_hl(0, "cSpecial",                    { fg = purple })
-- we use lsp for errors so disable basic syntax error from vim
vim.api.nvim_set_hl(0, "cError", {link = "None"})

vim.api.nvim_set_hl(0, "cppModifier",					{ fg = pink })
vim.api.nvim_set_hl(0, "cppStructure",				{ fg = pink })

-- vulkan
vim.api.nvim_set_hl(0, "vkFunction",					{ fg = greenish})
vim.api.nvim_set_hl(0, "vkType",                      { fg = greenishblue})



vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",            { fg = red})
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", {link = "CmpItemAbbrMatch"})

vim.api.nvim_set_hl(0, "CmpItemKindClass", {link = "Structure"})
vim.api.nvim_set_hl(0, "CmpItemKindStruct", {link = "Structure"})
vim.api.nvim_set_hl(0, "CmpItemKindFunction", {link = "Function"})
vim.api.nvim_set_hl(0, "CmpItemKindMethod", {link = "Method"})
vim.api.nvim_set_hl(0, "CmpItemKindConstructor", {link = "Structure"})
vim.api.nvim_set_hl(0, "CmpItemKindVariable", {link = "Variable"})
vim.api.nvim_set_hl(0, "CmpItemKindField", {link = "Field"})
vim.api.nvim_set_hl(0, "CmpItemKindProperty", {link = "Property"})
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", {link = "Keyword"})

vim.api.nvim_set_hl(0, "CmpMenu",                     { fg = white, bg = bg_cmp})
vim.api.nvim_set_hl(0, "CmpSelect",                   { fg = black, bg = blue})
vim.api.nvim_set_hl(0, "NormalFloat", {link = "CmpMenu"})
vim.api.nvim_set_hl(0, "FloatBorder", {link = "CmpMenu"})

vim.api.nvim_set_hl(0, "IblIndent",         { fg = darkgrey})
vim.api.nvim_set_hl(0, "IblWhitespace",    { fg = darkgrey})
vim.api.nvim_set_hl(0, "IblScope", { fg = darkgrey})


vim.api.nvim_set_hl(0, "NeogitDiffAdd", { bg = addbg})
vim.api.nvim_set_hl(0, "NeogitDiffDelete", { bg = delbg})


vim.api.nvim_set_hl(0, "DiagnosticError", { fg = red})
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = orange})
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = aqua})
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = green})

vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", {fg = aqua})
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", {fg = aqua})
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", {fg = aqua})
vim.api.nvim_set_hl(0, "NoiceConfirmBorder", {fg = aqua})
vim.api.nvim_set_hl(0, "NoiceCmdlineIconSearch", {fg = orange})
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", {fg = orange})


vim.api.nvim_exec(
    [[
call wilder#enable_cmdline_enter()
set wildcharm=<Tab>
cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"

call wilder#set_option('modes', ['/', '?', ':'])

call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({ 'left': [wilder#popupmenu_devicons(), wilder#popupmenu_buffer_flags({ 'flags': ' a + ', 'icons': {'+': '', 'a': '', 'h': ''}, }), ' '], 'right': [' ', wilder#wildmenu_index(), wilder#popupmenu_scrollbar()], 'highlighter': wilder#basic_highlighter(), 'empty_message': wilder#popupmenu_empty_message_with_spinner(), 'highlights': { 'border': 'Normal', }, 'border': 'rounded', })))
]],
    false
)

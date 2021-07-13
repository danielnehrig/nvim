local saga = require("lspsaga")

saga.init_lsp_saga {
    code_action_prompt = {
        enable = true,
        sign = true,
        sign_priority = 20,
        virtual_text = false
    },
    error_sign = "", -- 
    warn_sign = "",
    hint_sign = "",
    infor_sign = ""
}

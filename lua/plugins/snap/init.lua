local snap = require("snap")
-- local remap = vim.api.nvim_set_keymap
-- local opt = {noremap = true, silent = true}

SN = {}

function SN.find()
    snap.run {
        producer = snap.get "consumer.fzf"(snap.get "producer.ripgrep.file"),
        select = snap.get "select.file".select,
        multiselect = snap.get "select.file".multiselect,
        views = {snap.get "preview.file"}
    }
end

function SN.grep()
    snap.run {
        producer = snap.get "producer.ripgrep.vimgrep",
        select = snap.get "select.vimgrep".select,
        multiselect = snap.get "select.vimgrep".multiselect,
        views = {snap.get "preview.vimgrep"}
    }
end

-- remap("n", "<Leader>ff", ":lua SN.find()<CR>", opt)
-- remap("n", "<Leader>fg", ":lua SN.grep()<CR>", opt)

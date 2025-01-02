local M = {}

M.init = function()
  require("which-key").add({
    { "<leader>c", group = "ChatGPT" },
    {
      mode = { "n", "v" },
      { "<leader>cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
      {
        "<leader>ce",
        "<cmd>ChatGPTEditWithInstruction<CR>",
        desc = "Edit with instruction",
      },
      {
        "<leader>cg",
        "<cmd>ChatGPTRun grammar_correction<CR>",
        desc = "Grammar Correction",
      },
      { "<leader>ct", "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
      { "<leader>ck", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
      { "<leader>cd", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
      { "<leader>ca", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
      {
        "<leader>co",
        "<cmd>ChatGPTRun optimize_code<CR>",
        desc = "Optimize Code",
      },
      { "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
      { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
      {
        "<leader>cx",
        "<cmd>ChatGPTRun explain_code<CR>",
        desc = "Explain Code",
      },
      {
        "<leader>cr",
        "<cmd>ChatGPTRun roxygen_edit<CR>",
        desc = "Roxygen Edit",
      },
      {
        "<leader>cl",
        "<cmd>ChatGPTRun code_readability_analysis<CR>",
        desc = "Code Readability Analysis",
      },
    },
    { "<leader>]", group = "TS Textobj" },
    { "<leader>b", group = "Build/Run/Test" },
    { "<leader>c", group = "Commented" },
    { "<leader>d", group = "Debug" },
    { "<leader>f", group = "File" },
    { "<leader>g", group = "Lsp and Grammar" },
    { "<leader>h", group = "Gitsigns" },
    { "<leader>l", group = "LocList" },
    { "<leader>o", group = "Orgmode" },
    { "<leader>q", group = "QuickfixList" },
    { "<leader>t", group = "Tab Nav" },
    { "<leader>u", group = "Utils" },
  })
end

return M

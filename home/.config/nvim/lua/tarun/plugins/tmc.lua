return {
  "ukonhattu/tmc.vim",
  cmd = {
    "TmcLogin",
    "TmcPickCourse",
    "TmcRunTests",
    "TmcSubmit",
    "TmcCourses",
  },
  keys = {
    { "<leader>tt", "<cmd>TmcRunTests<cr>", desc = "TMC: Run Tests" },
    { "<leader>ts", "<cmd>TmcSubmit<cr>", desc = "TMC: Submit Exercise" },
  },
  init = function()
    -- Point directly to the binary to skip auto-downloading & checksums
    vim.g.tmc_cli_path = vim.fn.expand("~/.local/bin/tmc-langs-cli")
  end,
  config = function()
    vim.env.TMC_LANGS_DEFAULT_PROJECTS_DIR = vim.fn.expand("~/tmc-exercises")
  end,
}

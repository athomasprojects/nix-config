local ls = require("luasnip")

local f = ls.function_node

local s = ls.snippet

-- date -> Tue 16 Nov 2021 09:43:49 AM EST
ls.add_snippets("all", {
  s({ trig = "date" }, {
    f(function()
      return string.format(string.gsub(vim.bo.commentstring, "%%s", " %%s"), os.date())
    end, {}),
  }),
})

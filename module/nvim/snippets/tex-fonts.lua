local ls = require("luasnip")

local fmta = require("luasnip.extras.fmt").fmta

local s = ls.snippet
local d = ls.dynamic_node
local i = ls.insert_node
local f = ls.function_node
local sn = ls.snippet_node

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, ""))
  end
end

-- Math context detection
local tex = {}
tex.in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

-- Return snippet tables
ls.add_snippets("tex", {

  -- Typewriter i.e. \\texttt
  s(
    {
      trig = "([^%a])sd",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      priority = 2000,
      name = "typewriter",
      desc = "typewriter i.e. \\texttt",
    },
    fmta("<>\\texttt{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_text }
  ),

  -- Italic i.e. \\textit
  s(
    {
      trig = "([^%a])tii",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "italic",
      desc = "italic i.e. \\textit",
    },
    fmta("<>\\textit{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Bold i.e. \\textbf
  s(
    { trig = "tbb", snippetType = "autosnippet", name = "bold", desc = "bold i.e. \\textbf" },
    fmta("\\textbf{<>}", {
      d(1, get_visual),
    })
  ),

  -- Math roman i.e. \mathrm
  s(
    {
      trig = "([^%a])rmm",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "math roman",
      desc = "math roman i.e. \\mathrm",
    },
    fmta("<>\\mathrm{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Math caligraphy i.e. \mathcal
  s(
    {
      trig = "([^%a])mcc",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "math calligraphy",
      desc = "math caligraphy i.e. \\mathcal",
    },
    fmta("<>\\mathcal{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Math boldface i.e. \mathbf
  s(
    {
      trig = "([^%a])mbf",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "math bold",
      desc = "math boldface i.e. \\mathbf",
    },
    fmta("<>\\mathbf{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Math blackboard i.e. \mathbb
  s(
    {
      trig = "([^%a])mbb",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "math blackboard",
      desc = "math blackboard i.e. \\mathbb",
    },
    fmta("<>\\mathbb{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Regular text i.e. \\text (in math environments)
  s(
    {
      trig = "([^%a])tee",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "text math env",
      desc = "regular text i.e. \\text (in math environments)",
    },
    fmta("<>\\text{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
})

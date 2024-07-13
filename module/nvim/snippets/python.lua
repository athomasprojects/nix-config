-- This clears my python snippets, so when I source this file
-- I can try the snippets again, without restarting neovim.

-- This can be useful if you are trying to do something a bit more
-- complicated or just exploring random snippet ideas.
require("luasnip.session.snippet_collection").clear_snippets("python")

local fmta = require("luasnip.extras.fmt").fmta
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local ls = require("luasnip")
local s = ls.snippet
local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local t = ls.text_node
local sn = ls.snippet_node

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, ""))
  end
end

-- Print f-string
ls.add_snippets("python", {
  s(
    {
      trig = "ppf",
      name = "print f-string",
      snippetType = "autosnippet",
      desc = "print f-string",
      docstring = "print(f'{}')",
    },
    fmta([[print(f"<>")]], {
      d(1, get_visual),
    })
    -- { condition = line_begin }
  ),

  -- `main` function
  s(
    { trig = "mnn", name = "main", docstring = "if __name__ == __main__" },
    fmta(
      [[
      if __name__ == "__main__":
          <>
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Function definition with choice node docstring.
  -- The idea is to let you choose if you want to use the docstring or not.
  s(
    { trig = "ff", name = "func def", desc = "function definition with choice node docstring" },
    -- "ff",
    fmta(
      [[
      def <func>(<args>):
          <doc_str><body>
      ]],
      {
        func = i(1),
        args = i(2),
        doc_str = c(3, { sn(nil, { t({ '"""', "" }), t("    "), i(1, ""), t({ "", '    """', "    " }) }), t("") }),
        -- t("    "),
        body = d(4, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- `__init__` method/constructor
  s(
    { trig = "init", name = "init", desc = "init method" },
    fmta(
      [[
        def __init__(self<args>):
            <body>
      ]],
      {
        args = i(1),
        body = d(2, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- `if` statement
  s(
    { trig = "iff", snippetType = "autosnippet", desc = "if statement" },
    fmta(
      [[
        if <cond>:
            <body>
      ]],
      {
        cond = i(1),
        body = i(2),
        -- body = d(2, get_visual),
      }
    )
  ),

  -- `if/else` statement
  s(
    { trig = "ifelse", desc = "if/else statement" },
    fmta(
      [[
        if <>:
            <>
        else:
            <>
      ]],
      {
        i(1),
        i(2),
        i(0),
      }
    )
  ),

  -- `return` statement
  s(
    { trig = ";r", name = "return", snippetType = "autosnippet", desc = "return statement", docstring = "return" },
    { t("return") },
    { condition = line_begin }
  ),

  -- `self` (for use in classes)
  s({ trig = ";s", name = "self", snippetType = "autosnippet", desc = "self", docstring = "self" }, { t("self") }),

  -- Matplotlib Snippets
  -- new figure, axes
  s(
    -- { trig = "fx", snippetType = "autosnippet", desc = "new figure, axes" },
    {
      trig = "fx",
      name = "fig/ax",
      -- snippetType = "autosnippet",
      desc = "new figure, axes",
      docstring = "fig = plt.figure()\nax = fig.add_subplot(111)",
    },
    -- { trig = "fx", name = "fig/ax", desc = "new figure, axes" },
    fmta(
      [[
          fig = plt.figure()
          ax = fig.add_subplot(111)
        ]],
      {}
    ),
    -- If we make this snippet triggered by expansion only then we don't need to worry about whether we're at the beginning of the line or not.
    { condition = line_begin }
  ),

  -- Axis plot
  s(
    -- { trig = "xp", snippetType = "autosnippet", desc = "ax.plot" },
    { trig = "xp", name = "axes plot", desc = "ax.plot" },
    fmta([[ax.plot(<x>, <y>, color=<colour>, linewidth=<lw>, label=r"<lbl>")]], {
      -- d(1, get_visual),
      x = i(1),
      y = i(2),
      colour = i(3),
      lw = i(4),
      lbl = i(5),
    }),
    { condition = line_begin }
  ),

  -- Axis set_xlabel
  s(
    { trig = "xxl", name = "set x-label", desc = "ax.set_xlabel" },
    fmta([[ax.set_xlabel(<>)]], {
      d(1, get_visual),
    }),
    { condition = line_begin }
  ),

  -- Axis set_ylabel
  s(
    { trig = "xyl", name = "set y-label", snippetType = "autosnippet", desc = "ax.set_ylabel" },
    fmta([[ax.set_ylabel(<>)]], {
      d(1, get_visual),
    }),
    { condition = line_begin }
  ),

  -- Axis set_title
  s(
    { trig = "xt", snippetType = "autosnippet", desc = "ax.set_title" },
    fmta([[ax.set_title(<>)]], {
      d(1, get_visual),
    }),
    { condition = line_begin }
  ),

  -- Legend
  s(
    { trig = "lg", snippetType = "autosnippet", desc = "ax.legend" },
    fmta([[ax.legend(<>)]], {
      d(1, get_visual),
    }),
    { condition = line_begin }
  ),

  -- Tight layout
  s(
    { trig = "ttl", name = "tight layout", snippetType = "autosnippet", desc = "plt.tight_layout" },
    { t("plt.tight_layout()") }
    -- { condition = line_begin }
  ),

  -- Stem plot
  s(
    {
      trig = "stem",
      name = "stem plot",
      desc = "stem plot",
      docstring = "(markers, stemlines, baseline) = ax.stem({})\nplt.setp(markers, marker='o', markerfacecolor={}, markeredgecolor='none', markersize=6)\nplt.setp(baseline, color={}, linestyle='-')\nplt.setp(stemlines, linestyle='--', color={}, linewidth=2)",
    },
    fmta(
      [[
          (markers, stemlines, baseline) = ax.stem(<>)
          plt.setp(markers, marker='o', markerfacecolor=<>, markeredgecolor="none", markersize=6)
          plt.setp(baseline, color=<>, linestyle="-")
          plt.setp(stemlines, linestyle="--", color=<>, linewidth=2)
        ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      }
    ),
    { condition = line_begin }
  ),

  -- Remove spine function
  s(
    { trig = "spines", name = "remove spines", desc = "remove spines top and right spines from plot" },
    fmta(
      [[
        def remove_spines(ax):
            ax.spines['top'].set_visible(False)
            ax.spines['right'].set_visible(False)
            ax.get_xaxis().tick_bottom()
            ax.get_yaxis().tick_left()
        ]],
      {}
    ),
    { condition = line_begin }
  ),

  -- Docstring Snippets
  -- Function parameters for use in docstrings, with heading
  s(
    { trig = "PP", name = "docstring func params", snippetType = "autosnippet", desc = "parameters docstring" },
    fmta(
      [[
      Parameters
      ----------
      <> : <>
          <>
      ]],
      {
        i(1, "name"),
        i(2, "data_type"),
        d(3, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Function returns for use in docstrings, with heading
  s(
    {
      trig = "RR",
      name = "docstring return args",
      snippetType = "autosnippet",
      desc = "Python return arguments docstring",
    },
    fmta(
      [[
      Returns
      ----------
      <> : <>
          <>
      ]],
      {
        i(1, "name"),
        i(2, "data_type"),
        d(3, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Function parameter for use in docstrings
  s(
    { trig = "::", name = "docstring func params", snippetType = "autosnippet", desc = "generic docstring section" },
    fmta(
      [[
      <name> : <data_type>
          <dscr>
      ]],
      {
        name = i(1, "name"),
        data_type = i(2, "data_type"),
        dscr = d(3, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Long string of dasHES FOR COMMENTS
  s(
    { trig = "d--", name = "dashes", snippetType = "autosnippet", desc = "long string of dashes for comments" },
    { t("# -------------------------------------------------------------------- #") },
    { condition = line_begin }
  ),
})

require("luasnip.session.snippet_collection").clear_snippets("tex")

-- Math context detection
local tex = {}
tex.in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex.in_text = function()
  return not tex.in_mathzone()
end

local ls = require("luasnip")

local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local s = ls.snippet
local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local sn = ls.snippet_node

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local get_date = function()
  -- return os.date "%Y-%m-%d"
  return os.date()
end

local get_visual = function(args, parent)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, ""))
  end
end

-- Add snippets
ls.add_snippets("tex", {
  -- DELIMITERS:
  -- Left/right parens
  s(
    {
      trig = "([^%a])l%(",
      regTrig = true,
      wordTrig = false,
      name = "parentheses",
      snippetType = "autosnippet",
      desc = "Left/right parentheses",
    },
    fmta("<>\\left(<>\\right)", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Left/right square brace
  s(
    {
      trig = "([^%a])l%[",
      regTrig = true,
      wordTrig = false,
      name = "brackets",
      snippetType = "autosnippet",
      desc = "Left/right square braces",
    },
    fmta("<>\\left[<>\\right]", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Left/right curly braces
  s(
    {
      trig = "([^%a])l%{",
      regTrig = true,
      wordTrig = false,
      name = "curly braces",
      snippetType = "autosnippet",
      desc = "Left/right curly braces",
    },
    fmta("<>\\left\\{<>\\right\\}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Big parentheses
  s(
    {
      trig = "([^%a])b%(",
      regTrig = true,
      wordTrig = false,
      name = "big parentheses",
      snippetType = "autosnippet",
      desc = "Big parentheses",
    },
    fmta("<>\\big(<>\\big)", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Big square braces
  s(
    {
      trig = "([^%a])b%[",
      regTrig = true,
      wordTrig = false,
      name = "big brackets",
      snippetType = "autosnippet",
      desc = "Big square braces",
    },
    fmta("<>\\big[<>\\big]", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Big curly braces,
  s(
    {
      trig = "([^%a])b%{",
      regTrig = true,
      wordTrig = false,
      name = "big curly braces",
      snippetType = "autosnippet",
      desc = "Big curly braces",
    },
    fmta("<>\\big\\{<>\\big\\}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Escaped curly braces
  s(
    {
      trig = "([^%a])\\%{",
      regTrig = true,
      wordTrig = false,
      name = "escaped curly braces",
      snippetType = "autosnippet",
      priority = 2000,
      desc = "escaped curly braces",
    },
    fmta("<>\\{<>\\}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- LaTeX quotation mark
  s(
    { trig = "``", name = "backtick", snippetType = "autosnippet", desc = "LaTeX quotation mark" },
    fmta("``<>''", {
      d(1, get_visual),
    })
  ),

  -- ENVIRONMENTS:
  -- Generic environment
  s(
    {
      trig = "new",
      name = "generic environment",
      snippetType = "autosnippet",
      desc = "Generic environment",
      docstring = [[
        \begin{<>}
            <>
        \end{<>}
      ]],
    },
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),

  -- Environment with one extra argument
  s(
    {
      trig = "n2",
      name = "generic environment",
      snippetType = "autosnippet",
      desc = "Environment with one extra argument",
    },
    fmta(
      [[
        \begin{<>}{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),

  -- Environment with two extra arguments
  s(
    {
      trig = "n3",
      name = "generic environment",
      snippetType = "autosnippet",
      desc = "Environment with two extra arguments",
    },
    fmta(
      [[
        \begin{<>}{<>}{<>}
            <>
        \end{<>}
      ]],
      {
        i(1),
        i(2),
        i(3),
        d(4, get_visual),
        rep(1),
      }
    ),
    { condition = line_begin }
  ),

  -- Topic environment (my custom tcbtheorem environment)
  s(
    {
      trig = "nt",
      name = "custom topic environment",
      snippetType = "autosnippet",
      desc = "Topic environment (custom tcbtheorem environment)",
      docstring = [[
        \begin{topic}{<>}{<>}
            <>
        \end{topic}
      ]],
    },
    fmta(
      [[
        \begin{topic}{<>}{<>}
            <>
        \end{topic}
      ]],
      {
        i(1),
        i(2),
        d(3, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Equation
  s(
    {
      trig = "nn",
      name = "equation env",
      snippetType = "autosnippet",
      desc = "Equation",
      docstring = [[
        \begin{equation*}
            <>
        \end{equation*}
      ]],
    },
    fmta(
      [[
        \begin{equation*}
            <>
        \end{equation*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),

  -- Equation with label
  s(
    {
      trig = "nl",
      name = "equation env",
      snippetType = "autosnippet",
      desc = "Equation with label",
      docstring = [[
        \begin{equation*}
        \label{eq: <>}
            <>
        \end{equation*}
      ]],
    },
    fmta(
      [[
        \begin{equation}
        \label{eq: <>}
            <>
        \end{equation}
      ]],
      {
        i(1),
        d(2, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Split equation
  s(
    {
      trig = "ss",
      name = "split eqn env",
      snippetType = "autosnippet",
      desc = "Split equation",
      docstring = [[
        \begin{equation*}
            \begin{split}
                <>
            \end{split}
        \end{equation*}
      ]],
    },
    fmta(
      [[
        \begin{equation*}
            \begin{split}
                <>
            \end{split}
        \end{equation*}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Split equation
  s(
    {
      trig = "spn",
      name = "split equation env",
      snippetType = "autosnippet",
      desc = "Split equation",
      docstring = [[
        \begin{equation}
            \begin{split}
                <>
            \end{split}
        \end{equation}
      ]],
    },
    fmta(
      [[
        \begin{equation}
            \begin{split}
                <>
            \end{split}
        \end{equation}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Align
  s(
    {
      trig = "all",
      name = "align eqn env",
      snippetType = "autosnippet",
      desc = "Align equation",
      docstring = [[
        \begin{align*}
            <>
        \end{align*}
      ]],
    },
    fmta(
      [[
        \begin{align*}
            <>
        \end{align*}
      ]],
      {
        i(1),
      }
    ),
    { condition = line_begin }
  ),

  -- Itemize
  s(
    {
      trig = "itt",
      name = "item env",
      snippetType = "autosnippet",
      desc = "Itemize",
      docstring = [[
        \begin{itemize}
            \item <>
        \end{itemize}
      ]],
    },
    fmta(
      [[
        \begin{itemize}
            \item <>
        \end{itemize}
      ]],
      {
        i(0),
      }
    ),
    { condition = line_begin }
  ),

  -- Enumerate
  s(
    {
      trig = "enn",
      name = "enum env",
      snippetType = "autosnippet",
      desc = "Enumerate",
      docstring = [[
        \begin{enumerate}
            \item <>
        \end{enumerate}
      ]],
    },
    fmta(
      [[
        \begin{enumerate}
            \item <>
        \end{enumerate}
      ]],
      {
        i(0),
      }
    )
  ),

  -- Inline math
  s(
    {
      trig = "([^%l])mm",
      regTrig = true,
      wordTrig = false,
      name = "inline math eqn",
      snippetType = "autosnippet",
      desc = "Inline math",
    },
    fmta("<>$<>$", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  -- Inline math on new line
  s(
    {
      trig = "^mm",
      regTrig = true,
      wordTrig = false,
      name = "inline math eqn",
      snippetType = "autosnippet",
      desc = "Inline math on new line",
    },
    fmta("$<>$", {
      i(1),
    })
  ),

  -- Figure
  s(
    {
      trig = "fig",
      desc = "Figure",
      docstring = [[
        \begin{figure}[htb!]
          \centering
          \includegraphics[width=<>\linewidth]{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
        ]],
    },
    fmta(
      [[
        \begin{figure}[htb!]
          \centering
          \includegraphics[width=<>\linewidth]{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
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

  -- Figgen
  s(
    {
      trig = "fgen",
      snippetType = "autosnippet",
      name = "fig gen",
      desc = "Generate formatted figure with caption (see my custom `figgen` macro)",
      docstring = "\\figgen{}{}{}{} ",
    },
    fmta(
      [[
        \figgen{<>}{<>}{<>}{<>}
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

  -- MATH:
  -- Superscript
  s(
    {
      trig = "([%w%)%]%}])'",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "math superscript",
      desc = "math environment superscript",
    },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- Subscript
  s(
    {
      trig = "([%w%)%]%}]);",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "math subscript",
      desc = "math environment subscript",
    },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),
  -- Subscript and superscript
  s(
    {
      trig = "([%w%)%]%}])__",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "math subscript and superscript",
      desc = "math environment subscript and superscript",
    },
    fmta("<>^{<>}_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Text subscript
  s({
    trig = "sd",
    snippetType = "autosnippet",
    wordTrig = false,
    name = "math text subscript",
    desc = "text subscript when in math environment",
  }, fmta("_{\\mathrm{<>}}", { d(1, get_visual) }), { condition = tex.in_mathzone }),

  -- Superscript shortcut
  -- Places the first alphanumeric character after the trigger into a superscript.
  s(
    {
      trig = '([%w%)%]%}])"([%w])',
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "superscript",
      desc = "Places the first alphanumeric character after the trigger into a superscript.",
    },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),
  -- Subscript shortcut
  -- Places the first alphanumeric character after the trigger into a subscript.
  s(
    {
      trig = "([%w%)%]%}]):([%w])",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "subscript",
      desc = "Places the first alphanumeric character after the trigger into a subscript.",
    },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Euler's number superscript shortcut
  s(
    {
      trig = "([^%a])ee",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "Euler's number",
      desc = "Euler's number superscript shortcut",
    },
    fmta("<>e^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Zero subscript shortcut
  s(
    {
      trig = "([%a%)%]%}])00",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "zero subscript",
      desc = "zero subscript shortcut",
    },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("0"),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Minus one superscript shortcut
  s(
    {
      trig = "([%a%)%]%}])11",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "-1 superscript",
      desc = "minus one superscript shortcut",
    },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("-1"),
    }),
    { condition = tex.in_mathzone }
  ),

  -- J Subscript shortcut (since jk triggers snippet jump forward)
  s(
    {
      trig = "([%a%)%]%}])JJ",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "j subscript",
      desc = "j subscript shortcut (since jk triggers snippet jump forward)",
    },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("j"),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Plus superscript shortcut
  s(
    {
      trig = "([%a%)%]%}])%+%+",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "plus superscript",
      desc = "plus superscript shortcut",
    },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("+"),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Complement superscript
  s(
    {
      trig = "([%a%)%]%}])CC",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "complement superscript",
      desc = "complement superscript",
    },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("\\complement"),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Conjugate (star) superscript shortcut

  s(
    {
      trig = "([%a%)%]%}])%*%*",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "conjugate",
      desc = "conjugate (star) superscript shortcut",
    },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      t("*"),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Vector, i.e. \vec
  s(
    {
      trig = "([^%a])vv",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "vector",
      desc = "vector, i.e. \vec",
    },
    fmta("<>\\vec{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Default unit vector with subscript, i.e. \unitvector_{}
  s(
    {
      trig = "([^%a])ue",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "default unit vector",
      desc = "default unit vector with subscript, i.e. \\unitvector_{}",
    },
    fmta("<>\\unitvector_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Unit vector with hat, i.e. \uvec{}
  s(
    {
      trig = "([^%a])uv",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "unit vector + hat",
      desc = "unit vector with hat, i.e. \\uvec{}",
    },
    fmta("<>\\uvec{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Matrix, i.e. \vec
  s(
    {
      trig = "([^%a])mt",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "matrix",
      desc = "matrix, i.e. \vec",
    },
    fmta("<>\\mat{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Fraction
  s(
    {
      trig = "([^%a])ff",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "fraction",
      desc = "fraction",
    },
    fmta("<>\\frac{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Angle
  s(
    {
      trig = "([^%a])gg",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "angle",
      desc = "angle",
    },
    fmta("<>\\ang{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Absolute value
  s(
    {
      trig = "([^%a])aa",
      regTrig = true,
      wordTrig = false,
      snippetType = "autosnippet",
      name = "abs value",
      desc = "absolute value",
    },
    fmta("<>\\abs{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Square root
  s(
    {
      trig = "([^%\\])sq",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "square root",
      desc = "square root",
    },
    fmta("<>\\sqrt{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Binomial symbol
  s(
    {
      trig = "([^%\\])bnn",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      nmae = "binonamial",
      desc = "binomial symbol",
    },
    fmta("<>\\binom{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Logarithm with base subscript
  s(
    {
      trig = "([^%a%\\])ll",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "log with base",
      desc = "logarithm with base subscript",
    },
    fmta("<>\\log_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Derivative with denominator only
  s(
    {
      trig = "([^%a])dV",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "derivative denom",
      desc = "derivative with denominator only",
    },
    fmta("<>\\dvOne{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Derivative with numerator and denominator
  s(
    {
      trig = "([^%a])dvv",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "derivative",
      desc = "derivative with numerator and denominator",
    },
    fmta("<>\\dv{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Derivative with numerator, denominator, and higher-order argument
  s(
    {
      trig = "([^%a])ddv",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "higher order derivative",
      desc = "derivative with numerator, denominator, and higher-order argument",
    },
    fmta("<>\\dvN{<>}{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
      i(3),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Partial derivative with denominator only
  s(
    {
      trig = "([^%a])pV",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "partial derivative denom",
      desc = "partial derivative WITH DENOMINATOR ONLY",
    },
    fmta("<>\\pdvOne{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Partial derivative with numerator and denominator
  s(
    {
      trig = "([^%a])pvv",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "partial derivative",
      desc = "partial derivative WITH NUMERATOR AND DENOMINATOR",
    },
    fmta("<>\\pdv{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Partial derivative with numerator, denominator, and higher-order argument
  s(
    {
      trig = "([^%a])ppv",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "higher order partial derivative",
      desc = "partial derivative with numerator, denominator, and higher-order argument",
    },
    fmta("<>\\pdvN{<>}{<>}{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
      i(3),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Sum with lower limit
  s(
    {
      trig = "([^%a])sM",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "sum (lower lim)",
      desc = "sum with lower limit",
    },
    fmta("<>\\sum_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Sum with upper and lower limit
  s(
    {
      trig = "([^%a])smm",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      name = "sum with limits",
      desc = "sum with upper and lower limit",
    },
    fmta("<>\\sum_{<>}^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Integral with upper and lower limit
  s(
    {
      trig = "([^%a])intt",
      wordTrig = false,
      regTrig = true,
      name = "definite integral",
      snippetType = "autosnippet",
      desc = "integral with upper and lower limit",
    },
    fmta("<>\\int_{<>}^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Boxed command
  s(
    {
      trig = "([^%a])bb",
      wordTrig = false,
      regTrig = true,
      snippetType = "autosnippet",
      desc = "boxed command",
      name = "boxed",
    },
    fmta("<>\\boxed{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    }),
    { condition = tex.in_mathzone }
  ),

  -- Differential, i.e. \diff
  s({
    trig = "df",
    snippetType = "autosnippet",
    desc = "differential, i.e. \\diff",
    name = "diff",
  }, {
    t("\\diff"),
  }, { condition = tex.in_mathzone }),

  -- Basic integral symbol, i.e. \int
  s({ trig = "in1", snippetType = "autosnippet", desc = "basic integral symbol, i.e. \\int", name = "int" }, {
    t("\\int"),
  }, { condition = tex.in_mathzone }),

  -- Double integral, i.e. \iint
  s({ trig = "in2", snippetType = "autosnippet", desc = "double integral, i.e. \\iint", name = "iint" }, {
    t("\\iint"),
  }, { condition = tex.in_mathzone }),

  -- Triple integral, i.e. \iiint
  s({ trig = "in3", snippetType = "autosnippet", desc = "triple integral, i.e. \\iiint", name = "iiint" }, {
    t("\\iiint"),
  }, { condition = tex.in_mathzone }),

  -- Closed single integral, i.e. \oint
  s({ trig = "oi1", snippetType = "autosnippet", desc = "CLOSED SINGLE INTEGRAL, i.e. \\oint", name = "oint" }, {
    t("\\oint"),
  }, { condition = tex.in_mathzone }),

  -- Closed double integral, i.e. \oiint
  s({ trig = "oi2", snippetType = "autosnippet", desc = "closed double integral, i.e. \\oiint", name = "oiint" }, {
    t("\\oiint"),
  }, { condition = tex.in_mathzone }),

  -- Nabla operator, i.e. \nabla
  s({ trig = "nbb", snippetType = "autosnippet", desc = "NABLA OPERATOR, i.e. \nabla", name = "nabla" }, {
    t("\\nabla "),
  }, { condition = tex.in_mathzone }),

  -- Gradient operator, i.e. \grad
  s({ trig = "gdd", snippetType = "autosnippet", desc = "gradient operator, i.e. \\grad", name = "grad" }, {
    t("\\grad "),
  }, { condition = tex.in_mathzone }),

  -- Curl operator, i.e. \curl
  s({ trig = "cll", snippetType = "autosnippet", desc = "CURL OPERATOR, i.e. \\curl", name = "curl" }, {
    t("\\curl "),
  }, { condition = tex.in_mathzone }),

  -- Divergence operator, i.e. \divergence
  s({
    trig = "DI",
    snippetType = "autosnippet",
    desc = "divergence operator, i.e. \\divergence",
    name = "divergence",
  }, {
    t("\\div "),
  }, { condition = tex.in_mathzone }),

  -- Laplacian operator, i.e. \laplacian
  s({
    trig = "DI",
    snippetType = "autosnippet",
    desc = "divergence operator, i.e. \\divergence",
    name = "laplacian",
  }, {
    t("\\laplacian "),
  }, { condition = tex.in_mathzone }),

  -- Parallel symbol, i.e. \parallel
  s({
    trig = "||",
    snippetType = "autosnippet",
    desc = "parallel symbol, i.e. \\parallel",
    name = "parallel",
  }, {
    t("\\parallel"),
  }),

  -- Cdots, i.e. \cdots
  s({ trig = "cdd", snippetType = "autosnippet", desc = "cdots, i.e. \\cdots", name = "cdots" }, {
    t("\\cdots"),
  }),

  -- Ldots, i.e. \ldots
  s({ trig = "ldd", snippetType = "autosnippet", desc = "ldots, i.e. \\ldots", name = "ldots" }, {
    t("\\ldots"),
  }),

  -- Equiv, i.e. \equiv
  s({ trig = "eqq", snippetType = "autosnippet", desc = "equiv, i.e. \\equiv", name = "equivalent" }, {
    t("\\equiv "),
  }),

  -- Setminus, i.e. \setminus
  s({ trig = "stm", snippetType = "autosnippet", desc = "setminus, i.e. \\setminus", name = "setminus" }, {
    t("\\setminus "),
  }),

  -- Subset, i.e. \subset
  s({ trig = "sbb", snippetType = "autosnippet", desc = "subset, i.e. \\subset", name = "subset" }, {
    t("\\subset "),
  }),

  -- Approx, i.e. \approx
  s({ trig = "px", snippetType = "autosnippet", desc = "approx, i.e. \\approx", name = "approx" }, {
    t("\\approx "),
  }, { condition = tex.in_mathzone }),

  -- Propto, i.e. \propto
  s({ trig = "pt", snippetType = "autosnippet", desc = "propto, i.e. \\propto", name = "proportional to" }, {
    t("\\propto "),
  }, { condition = tex.in_mathzone }),

  -- Colon, i.e. \colon
  s({ trig = "::", snippetType = "autosnippet", desc = "colon, i.e. \\colon", name = "colon" }, {
    t("\\colon "),
  }),

  -- Implies, i.e. \implies
  s({ trig = ">>", snippetType = "autosnippet", desc = "implies, i.e. \\implies", name = "implies" }, {
    t("\\implies "),
  }),

  -- Dot product, i.e. \cdot
  s({ trig = ",.", snippetType = "autosnippet", desc = "dot product, i.e. \\cdot", name = "dot" }, {
    t("\\cdot "),
  }),

  -- Cross product, i.e. \times
  s({ trig = "xx", snippetType = "autosnippet", desc = "cross product, i.e. \\times", name = "cross product" }, {
    t("\\times "),
  }),

  -- STATIC:
  s({ trig = "LL", snippetType = "autosnippet", name = "ampersand", desc = "&" }, {
    t("& "),
  }),

  s({
    trig = "qu",
    name = "quad",
    desc = "inserts horizontal space equal to the witth of the 'M' character in the current font",
  }, {
    t("\\quad"),
  }),

  s({ trig = "qq", snippetType = "autosnippet", name = "double quad", desc = "inserts two quads" }, {
    t("\\qquad"),
  }),

  s({ trig = "np", name = "new page", desc = "inserts new page" }, {
    t("\\newpage"),
  }, { condition = line_begin }),

  s({ trig = "which", snippetType = "autosnippet", name = "for which", docstring = "\\text{ for which } " }, {
    t("\\text{ for which } "),
  }, { condition = tex.in_mathzone }),

  s({ trig = "all", snippetType = "autosnippet", name = "for all", docstring = "\\text{ for all } " }, {
    t("\\text{ for all } "),
  }, { condition = tex.in_mathzone }),

  s({ trig = "and", snippetType = "autosnippet", name = "quad and quad", docstring = "\\quad \\text{and} \\quad" }, {
    t("\\quad \\text{and} \\quad"),
  }, { condition = tex.in_mathzone }),

  s({ trig = "forall", snippetType = "autosnippet", name = "for all", docstring = "\\text{ for all } " }, {
    t("\\text{ for all } "),
  }, { condition = tex.in_mathzone }),

  s({ trig = "toc", snippetType = "autosnippet", name = "toc", desc = "table of contents" }, {
    t("\\tableofcontents"),
  }, { condition = line_begin }),

  s({ trig = "inff", snippetType = "autosnippet", name = "infinity", docstring = "\\infty" }, {
    t("\\infty"),
  }),

  s({ trig = "ii", snippetType = "autosnippet", name = "item", docstring = "\\item" }, {
    t("\\item "),
  }, { condition = line_begin }),
  s(
    { trig = "it", name = "item", docstring = [[\item[<>]] },
    fmta(
      [[
      \item[<>]
      ]],
      {
        i(1),
      }
    )
  ),

  s(
    { trig = "d--", snippetType = "autosnippet", name = "line of dashes", desc = "Commented line of dashes" },
    { t("% --------------------------------------------- %") },
    { condition = line_begin }
  ),

  -- Hline with extra vertical space
  s({
    trig = "hl",
    name = "hline extra",
    desc = "hline with extra vertical space",
    docstring = "\\hline {\\rule{0pt}{2.5ex}} \\hspace{-7pt}",
  }, { t("\\hline {\\rule{0pt}{2.5ex}} \\hspace{-7pt}") }, { condition = line_begin }),

  -- SYSTEM:
  -- Subfile
  s(
    { trig = "sbf", snippetType = "autosnippet", name = "subfile" },
    fmta(
      [[
        \documentclass[<>../main.tex]{subfiles}
      ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Annotate (custom command for annotating equation derivations)
  s(
    { trig = "ann", name = "annotate", docstring = [[\annotate{<>}{<>}]] },
    fmta(
      [[
      \annotate{<>}{<>}
      ]],
      {
        i(1),
        d(2, get_visual),
      }
    )
  ),

  -- Reference
  s(
    { trig = " RR", snippetType = "autosnippet", wordTrig = false, name = "reference" },
    fmta(
      [[
      ~\ref{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  -- Use a LaTeX package
  s(
    { trig = "pack", snippetType = "autosnippet", name = "use package" },
    fmta(
      [[
        \usepackage{<>}
        ]],
      {
        d(1, get_visual),
      }
    ),
    { condition = line_begin }
  ),

  -- Input a LaTeX file
  s(
    { trig = "iN", snippetType = "autosnippet", name = "input tex file" },
    fmta(
      [[
        \input{<><>}
        ]],
      {
        --i(1, "~/dotfiles/config/latex/templates/"),
        i(1, "src/"),
        i(2),
      }
    ),
    { condition = line_begin }
  ),

  -- Input a LaTeX Subfile
  s(
    { trig = "isb", snippetType = "autosnippet", name = "input subfile" },
    fmta(
      [[
      \subfile{<><>}
      ]],
      {
        i(1, "src/"),
        i(2),
      }
    ),
    { condition = line_begin }
  ),

  -- Label
  s(
    { trig = "lbl", snippetType = "autosnippet", name = "label" },
    fmta(
      [[
      \label{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  -- H-phantom
  s(
    { trig = "hpp", snippetType = "autosnippet", name = "hphantom" },
    fmta(
      [[
      \hphantom{<>}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  -- Todo
  s(
    { trig = "TODOO", snippetType = "autosnippet", name = "TODO" },
    fmta([[\TODO{<>}]], {
      d(1, get_visual),
    })
  ),

  -- New command
  s(
    { trig = "nc", name = "new command" },
    fmta([[\newcommand{<>}{<>}]], {
      i(1),
      i(2),
    }),
    { condition = line_begin }
  ),

  -- SI unitx
  s(
    { trig = "sii", snippetType = "autosnippet", name = "SI unitx", docstring = [[\si{<>}]] },
    fmta([[\si{<>}]], {
      i(1),
    })
  ),

  -- SI unitx
  s(
    { trig = "SI", name = "SI unitx", docstring = [[\SI{<>}{<>}]] },
    fmta([[\SI{<>}{<>}]], {
      i(1),
      i(2),
    })
  ),

  -- Url
  s(
    { trig = "url", name = "url" },
    fmta([[\url{<>}]], {
      d(1, get_visual),
    })
  ),

  -- Vspace
  s(
    { trig = "vs", name = "vspace", desc = "Inserts vertical space" },
    fmta([[\vspace{<>}]], {
      d(1, get_visual),
    })
  ),

  -- Section
  s(
    { trig = "h1", snippetType = "autosnippet", name = "section", desc = "Section heading" },
    fmta([[\section{<>}]], {
      d(1, get_visual),
    })
  ),

  -- Subsection
  s(
    { trig = "h2", snippetType = "autosnippet", name = "subsection", desc = "Subsection heading" },
    fmta([[\subsection{<>}]], {
      d(1, get_visual),
    })
  ),

  -- Subsubsection
  s(
    { trig = "h3", snippetType = "autosnippet", name = "subsubsection", desc = "Subsubsection heading" },
    fmta([[\subsubsection{<>}]], {
      d(1, get_visual),
    })
  ),

  -- Reference - \cref
  s(
    { trig = "crf", snippetType = "autosnippet", name = "cref" },
    fmta([[\cref{<>}]], {
      d(1, get_visual),
    })
  ),

  -- Reference - \crefrange
  s(
    { trig = "crr", snippetType = "autosnippet", name = "crefrange" },
    fmta([[\crefrange{<>}{<>}]], {
      d(1, get_visual),
      d(2, get_visual),
    })
  ),

  -- Reference - \crefpage
  s(
    { trig = "crp", snippetType = "autosnippet", name = "crefpage" },
    fmta([[\crefpage{<>}]], {
      d(1, get_visual),
    })
  ),

  -- Reference - \Cref
  s(
    { trig = "Crf", snippetType = "autosnippet", name = "Cref" },
    fmta([[\Cref{<>}]], {
      d(1, get_visual),
    })
  ),

  -- TMP:
  s(
    { trig = "upack", name = "use package", desc = "use LaTeX package with options" },
    fmta(
      [[
        \usepackage<>{<>}
      ]],
      {
        -- c(1, {t(""), sn(nil, {t("["), i(1, "options"), t("]")})}),
        c(1, { sn(nil, { t("["), i(1, "options"), t("]") }), t("") }),
        i(2, "name"),
      }
    ),
    { condition = line_begin }
  ),

  -- Equation, choice for labels
  s(
    {
      trig = "beq",
      name = "equation choice",
      desc = "Expands 'beq' into an equation environment, with a choice for labels",
      snippetType = "autosnippet",
    },
    fmta(
      [[
        \begin{equation}<>
          <>
        \end{equation}
      ]],
      {
        c(1, {
          sn(
            2, -- Choose to specify an equation label
            {
              t("\\label{eq:"),
              i(1),
              t("}"),
            }
          ),
          t([[]]), -- Choose no label
        }, {}),
        i(2),
      }
    )
  ),

  -- Figure environment with options
  s(
    { trig = "foofig", name = "fig env + options", desc = "Use 'fig' for figure environmennt, with options" },
    fmta(
      [[
        \begin{figure}<>
          \centering
          \includegraphics<>{<>}
          \caption{<>}
          \label{fig:<>}
        \end{figure}
      ]],
      {
        -- Optional [htbp] field
        c(1, {
          t([[]]), -- Choice 1, empty
          t("[htbp]"), -- Choice 2, this may be turned into a snippet
        }, {}),
        -- Options for includegraphics
        c(2, {
          t([[]]), -- Choice 1, empty
          sn(
            3, -- Choice 2, this may be turned into a snippet
            {
              t("[width="),
              i(1),
              t("\\textwidth]"),
            }
          ),
        }, {}),
        i(3, "filename"),
        i(4, "text"),
        i(5, "label"),
      }
    ),
    { condition = line_begin }
  ),

  -- GREEK LETTERS:
  s({ trig = ";a", snippetType = "autosnippet", name = "alpha" }, {
    t("\\alpha"),
  }),

  s({ trig = ";A", snippetType = "autosnippet", name = "Alpha" }, {
    t("\\Alpha"),
  }),

  s({ trig = ";b", snippetType = "autosnippet", name = "beta" }, {
    t("\\beta"),
  }),

  s({ trig = ";g", snippetType = "autosnippet", name = "gamma" }, {
    t("\\gamma"),
  }),

  s({ trig = ";G", snippetType = "autosnippet", name = "Gamma" }, {
    t("\\Gamma"),
  }),

  s({ trig = ";d", snippetType = "autosnippet", name = "delta" }, {
    t("\\delta"),
  }),

  s({ trig = ";D", snippetType = "autosnippet", name = "Delta" }, {
    t("\\Delta"),
  }),

  s({ trig = ";e", snippetType = "autosnippet", name = "epsilon" }, {
    t("\\epsilon"),
  }),

  s({ trig = ";ve", snippetType = "autosnippet", name = "varepsilon" }, {
    t("\\varepsilon"),
  }),

  s({ trig = ";z", snippetType = "autosnippet", name = "zeta" }, {
    t("\\zeta"),
  }),

  s({ trig = ";h", snippetType = "autosnippet", name = "eta" }, {
    t("\\eta"),
  }),

  s({ trig = ";o", snippetType = "autosnippet", name = "theta" }, {
    t("\\theta"),
  }),

  s({ trig = ";vo", snippetType = "autosnippet", name = "vartheta" }, {
    t("\\vartheta"),
  }),

  s({ trig = ";O", snippetType = "autosnippet", name = "Theta" }, {
    t("\\Theta"),
  }),

  s({ trig = ";k", snippetType = "autosnippet", name = "kappa" }, {
    t("\\kappa"),
  }),

  s({ trig = ";l", snippetType = "autosnippet", name = "lambda" }, {
    t("\\lambda"),
  }),

  s({ trig = ";L", snippetType = "autosnippet", name = "Lambda" }, {
    t("\\Lambda"),
  }),

  s({ trig = ";m", snippetType = "autosnippet", name = "mu" }, {
    t("\\mu"),
  }),

  s({ trig = ";n", snippetType = "autosnippet", name = "nu" }, {
    t("\\nu"),
  }),

  s({ trig = ";x", snippetType = "autosnippet", name = "xi" }, {
    t("\\xi"),
  }),

  s({ trig = ";X", snippetType = "autosnippet", name = "Xi" }, {
    t("\\Xi"),
  }),

  s({ trig = ";i", snippetType = "autosnippet", name = "pi" }, {
    t("\\pi"),
  }),

  s({ trig = ";I", snippetType = "autosnippet", name = "Pi" }, {
    t("\\Pi"),
  }),

  s({ trig = ";r", snippetType = "autosnippet", name = "rho" }, {
    t("\\rho"),
  }),

  s({ trig = ";s", snippetType = "autosnippet", name = "sigma" }, {
    t("\\sigma"),
  }),

  s({ trig = ";S", snippetType = "autosnippet", name = "Sigma" }, {
    t("\\Sigma"),
  }),

  s({ trig = ";t", snippetType = "autosnippet", name = "tau" }, {
    t("\\tau"),
  }),

  s({ trig = ";f", snippetType = "autosnippet", name = "phi" }, {
    t("\\phi"),
  }),

  s({ trig = ";vf", snippetType = "autosnippet", name = "varphi" }, {
    t("\\varphi"),
  }),

  s({ trig = ";F", snippetType = "autosnippet", name = "Phi" }, {
    t("\\Phi"),
  }),

  s({ trig = ";c", snippetType = "autosnippet", name = "chi" }, {
    t("\\chi"),
  }),

  s({ trig = ";p", snippetType = "autosnippet", name = "psi" }, {
    t("\\psi"),
  }),

  s({ trig = ";P", snippetType = "autosnippet", name = "Psi" }, {
    t("\\Psi"),
  }),

  s({ trig = ";w", snippetType = "autosnippet", name = "omega" }, {
    t("\\omega"),
  }),

  s({ trig = ";W", snippetType = "autosnippet", name = "Omega" }, {
    t("\\Omega"),
  }),

  s({ trig = ";u", snippetType = "autosnippet", name = "upsilon" }, {
    t("\\upsilon"),
  }),

  s({ trig = ";U", snippetType = "autosnippet", name = "Upsilon" }, {
    t("\\Upsilon"),
  }),

  -- DATE
  -- Today's date in YYYY-MM-DD (ISO 8601) format
  s(
    { trig = "iso" },
    { f(get_date) }
    -- {f(get_ISO_8601_date)}
  ),

  -- FONTS:
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

  -- generic siunitx \qty
  s(
    {
      trig = "qtt",
      name = "siunitx qty",
      desc = "\\qty[<>=<>]{<>}{<>}",
    },
    fmta(
      [[
        \qty[<>=<>]{<>}{<>}
      ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      }
    ),
    {}
  ),

  -- siunitx \qty - cycle through commonly used modes
  s(
    {
      trig = "qt",
      name = "siunitx qty macros",
      desc = "\\<>[<>=<>]{<>}{<>}",
    },
    fmta(
      [[
        \<>[<>=<>]{<>}{<>}
      ]],
      {
        c(1, {
          t("qty"),
          t("qtylist"),
          t("qtyrange"),
          t("qtyproduct"),
          t("num"),
          t("numlist"),
          t("numrange"),
          t("numproduct"),
          i(1),
        }, {}),
        c(2, {
          t("mode"),
          t("per-mode"),
        }, {}),
        c(3, {
          t("text"),
          t("symbol"),
          i(3),
        }, {}),
        i(4),
        c(5, {
          t("\\centi\\meter^{-3}"),
          t("\\centi\\meter^{-2}"),
          t("\\electronvolt"),
          i(5),
        }, {}),
      }
    ),
    {}
  ),

  -- siunitx units only
  s(
    {
      trig = "un",
      name = "siunitx units",
      desc = "\\unit[<>=<>]{<>}",
    },
    fmta(
      [[
      \unit<mode>{<unit>}
      ]],
      {
        mode = c(1, { t(""), sn(nil, { t("["), i(1), t("="), i(2), t("]") }) }, {}),
        unit = c(2, {
          t("\\centi\\meter^{-3}"),
          t("\\centi\\meter^{-2}"),
          t("\\electronvolt"),
          i(2),
        }, {}),
      }
    ),
    {}
  ),
})

-- -- FONTS:
-- local fonts = require("custom.fonts")
-- ls.add_snippets("tex", fonts)

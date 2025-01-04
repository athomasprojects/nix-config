local set = vim.opt_local

set.shiftwidth = 2

-- Todo: Figure out how to setup dune developer preview with nix so that we can use ocaml.nvim
-- vim.keymap.set("n", "<space>cp", require("ocaml.mappings").dune_promote_file, { buffer = 0 })
-- vim.keymap.set("n", "<space>cd", require("ocaml.mappings").destruct, { buffer = 0 })
--
-- -- Use <leader>out to update the type
-- vim.keymap.set("n", "<leader>out", require("ocaml.actions").update_interface_type, { desc = "[O]caml [U]pdate [T]ype" })

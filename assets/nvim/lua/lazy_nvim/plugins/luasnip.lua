-- if true then
--   return {}
-- end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
 "L3MON4D3/LuaSnip",
 dependencies = {
   "rafamadriz/friendly-snippets",
 },
 config = function()
   local ls = require("luasnip")
   local s = ls.snippet
   local t = ls.text_node
   local i = ls.insert_node
   local f = ls.function_node
   local fmt = require("luasnip.extras.fmt").fmt

   -- Load friendly-snippets
   require("luasnip.loaders.from_vscode").lazy_load()

   -- Add custom snippets
   ls.add_snippets("all", {
     -- name expansion
     s("ha", {
       t("Harrison Anderson"),
     }),

     -- email expansion
     s("mmgmail", {
       t("mingmillennium@gmail.com"),
     }),
     
     -- function template with placeholders
     s("fn", fmt([[
       function {}({})
         {}
       end
     ]], {
       i(1, "name"),
       i(2, "params"),
       i(3, "-- TODO"),
     })),

     -- current date
     s("date", {
       f(function() 
         return os.date("%Y-%m-%d")
       end),
     }),
   })

   -- Basic configuration
   ls.config.set_config({
     history = true, -- Remember last snippet jump position
     updateevents = "TextChanged,TextChangedI", -- Enable snippet auto-update
     enable_autosnippets = true,
     ext_opts = {
       [require("luasnip.util.types").choiceNode] = {
         active = {
           virt_text = { { "●", "GruvboxOrange" } },
         },
       },
     },
   })
 end,
}

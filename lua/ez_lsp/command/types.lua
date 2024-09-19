---@class ez_lsp.lsp.Subcommand
---@field impl fun(args:string[], opts: ez_lsp.command.UserCommandArgs)
---@field complete? fun(arg_lead: string, cmdline: string, cursor_position: integer): string[]

---@class ez_lsp.command.UserCommandArgs
---@field name string
---@field args? string
---@field fargs? string[] The args split by unescaped whitespace
---@field nargs number Number of arguments
---@field bang boolean
---@field line1 number The starting line of the command range
---@field line2 number The final line of the command range
---@field range number The number of items in the command range: 0, 1, or 2
---@field count number Any count supplied
---@field reg? string The optional register, if specified
---@field mods string Command modifiers, if any
---@field smods table Command modifiers in a structured format.

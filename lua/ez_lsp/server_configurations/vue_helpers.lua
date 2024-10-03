local VueHelpersModule = {}

local _vue_project_indicators = {
    "app.vue",
    "nuxt.config.ts",
    "nuxt.config.js",
}

---@return boolean
function VueHelpersModule.is_part_of_vue_project() return #vim.fs.find(_vue_project_indicators, { upward = true }) ~= 0 end

---@return boolean
function VueHelpersModule.is_not_part_of_vue_project() return not VueHelpersModule.is_part_of_vue_project() end

return VueHelpersModule

---@meta

---@class PluginInterfacePacker
---@field [1]? string
---@field requires? string[] | string | PluginInterfacePacker[]
---@field config fun()
---@field cmd? string | string[]
---@field event? string | string[]
---@field ft? string | string[]
---@field opt? boolean
---@field keys? string | string[]
---@field setup? fun()
---@field wants? string | string[]
---@field after? string | string[]
---@field disable? boolean
---@field rocks? string | string[]
---@field run? string | string[]
---@field as? string
---@field cond? string | string[]
---@field module? string | string[]

---@class PluginInterfaceLazy
---@field [1] string
---@field dependencies? string | string[] | PluginInterfaceLazy[]
---@field config fun()
---@field cmd? string | string[]
---@field event? string | string[]
---@field ft? string | string[]
---@field lazy? boolean?
---@field keys? string | string[]
---@field init? fun(LazyPlugin)
---@field enabled? boolean | fun():boolean
---@field build? string | string[]
---@field cond? string | string[]
---@field priority? integer
---@field dir? string
---@field url? string
---@field name? string
---@field dev? boolean
---@field optional? boolean

---@class PluginInterfaceMerged : PluginInterfacePacker, PluginInterfaceLazy

---@meta
--- https://github.com/folke/lazy.nvim/blob/main/lua/lazy/types.lua

---@class PluginInterfacePacker
---@field [1]? string
---@field requires? string[] | string | PluginInterfacePacker[]
---@field config fun() | boolean
---@field cmd? string | string[]
---@field event? string | string[]
---@field ft? string | string[]
---@field opt? boolean
---@field keys? string | string[] | LazyKeys[]
---@field setup? fun()
---@field wants? string | string[]
---@field after? string | string[]
---@field disable? boolean
---@field rocks? string | string[]
---@field run? string | string[]
---@field as? string
---@field cond? string | string[]
---@field module? string | string[]

---@module 'lazy.types'

---@class PluginInterfaceMerged : PluginInterfacePacker, LazyPluginSpec

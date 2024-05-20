--- @class Array<T>: { [integer]: T}

--- @class Dashboard
--- @field width number
--- @field height number
--- @field colors boolean
--- @field ascii string

--- @class Config
--- @field dashboards Array<Dashboard>

--- @type Dashboard
local m = {
	width = 1,
	height = 1,
	colors = false,
	ascii = "",
}

return m

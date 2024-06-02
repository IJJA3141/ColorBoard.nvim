--- @class dashboard
--- @field width number
--- @field height number
--- @field colors boolean
--- @field ascii string[]

--- @class keybind
--- @field icon string
--- @field key string
--- @field description string
--- @field func string | function

--- @class config
--- @field top_margin number | nil
--- @field center_margin number | nil
--- @field bottom_min_margin number | nil
--- @field keybinds keybind[] | nil
--- @field keybind_max_width number | nil
--- @field keybind_padding number | nil
--- @field dashboards dashboard[] | nil

--- @class line
--- @field icon string
--- @field left string
--- @field right string

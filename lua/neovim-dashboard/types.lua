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

--- @class strict_config
--- @field top_margin number
--- @field center_margin number
--- @field bottom_min_margin number
--- @field keybinds keybind[]
--- @field keybind_max_width number
--- @field keybind_padding number
--- @field dashboards dashboard[]

--- @class config: strict_config | nil

--- @class line
--- @field icon string
--- @field left string
--- @field right string

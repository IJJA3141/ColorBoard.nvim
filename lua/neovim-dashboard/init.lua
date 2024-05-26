-- utils
local utils = {}
function utils.buf_is_empty(bufnr)
	bufnr = bufnr or 0
	return vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == ""
end

-- file
local M = {}

---@type config
local default_opts = {
	keybinds = {
		{
			icon = "!",
			key = "g",
			description = "say something ?",
			func = function()
				print("hello world !")
			end,
		},
	},
	dashboards = {
		{
			width = 1,
			height = 1,
			colors = false,
			ascii = { "No config ?" },
		},
		{
			width = 10,
			height = 22,
			colors = false,
			ascii = {
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠻⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢀⣤⡈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⣿⣥⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣶⣿⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡿⡿⠿⡿⠿⡿⢿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⢿⢻⣫⣫⣵⣪⣞⣞⢮⣳⣳⡳⣢⣢⣠⡀⠤⣉⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣼⣿⣿⢿⢛⡭⢖⣟⢯⢷⢷⡿⣷⣷⣽⢵⣳⡳⣝⣗⢗⡵⡯⣻⡲⣄⢂⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣋⡵⡚⡵⡕⢟⢮⢯⡫⣗⡽⣝⡮⡯⣗⢷⣫⢗⢷⢽⢝⢽⣕⢯⢾⢝⡦⣖⡬⣉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⡭⡺⢨⡴⡫⣋⡮⡯⣳⢯⢞⢗⣕⢷⢽⢝⣞⣗⢽⢽⢹⡸⣮⣻⢮⢯⢫⣗⢽⣺⢝⡽⣝⢦⣙⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢛⡴⣫⠗⡼⣝⠞⣡⢷⢝⣽⡺⡵⣋⢮⡺⣝⡵⣻⡺⣪⠯⡡⢪⣞⡵⣳⢫⣘⢸⣪⢳⢯⢿⢾⢿⣿⣾⣢⡙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⡰⣝⣼⢣⢾⢽⠝⣸⢽⢵⣻⣪⢾⢑⢸⣸⢽⣕⡏⡼⣽⠚⡰⢡⣟⡼⡺⣱⣿⣿⡘⣮⡳⣝⡵⡯⣳⡳⣵⢳⡱⡈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢣⢺⣽⣿⢃⡾⡽⡺⢨⡳⡽⣕⣗⣗⢑⢰⢱⣳⣳⡳⢸⣝⢎⢰⠃⡧⣗⠟⣸⣿⣿⣿⡇⢳⣳⡱⣝⢾⢵⣻⣪⢯⣳⡱⡘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⡅⣯⣿⣿⡏⣼⢽⢝⠇⡇⡯⡯⣺⣺⠂⡌⢆⣟⣞⢮⢎⢗⡝⡄⡇⢪⢞⡗⣽⣿⣟⢿⡿⣗⢅⢗⣗⡕⡽⣕⣗⢷⢝⣮⣳⡐⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣰⣽⣿⣿⣿⢐⣯⡳⣯⠡⡇⣯⢏⣞⢎⠄⡇⡱⣵⡳⣏⢎⢾⢢⡗⡕⣸⡝⣼⣿⣿⣿⣶⣾⣿⡆⢝⣞⢾⡸⡪⣞⢽⣝⢞⣞⢮⠐⣿⣿⣿⢿⣻⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣰⣿⣿⣿⣿⡇⢎⡷⡽⣺⠨⡪⡾⡰⢽⢸⡌⣖⠸⣚⣪⣍⣬⣵⣾⣿⣾⣶⣽⣿⣧⣋⣻⣿⣿⣿⣿⡔⡱⣳⢽⣜⢬⢳⣳⣫⢞⡵⡅⠽⢩⡴⣶⢭⡙⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⢑⣾⣿⣿⣿⣿⠅⣣⢯⣫⢾⡅⢇⢿⡀⢏⠼⢗⣚⣛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⢿⣿⣿⣿⣷⡌⠪⣗⣗⣗⣕⡢⡝⡳⢽⡃⣼⢙⢉⠊⢯⢷⡌⢿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⡯⣸⣿⣿⣿⣿⡿⢠⢯⡳⢵⣳⡃⣦⠹⣸⠌⠀⠀⠹⣿⣿⣎⢻⣿⣿⣯⣛⣽⣿⣿⡿⠉⠀⠳⣷⣦⣝⢻⣿⣿⣆⠱⡱⢧⣳⣝⢮⢮⣲⠱⡡⡺⢼⡹⣜⢗⣿⡜⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⡇⣾⣿⣿⣿⡿⢃⣯⠳⡫⣺⣺⢐⣿⣿⡦⡀⠀⢀⣼⣿⣿⣿⣇⢻⣿⣿⣿⣿⣿⣟⠀⠀⠀⢀⣿⣿⣿⣦⢻⣿⣿⣧⠌⢷⢼⣸⣙⡝⡮⡮⢂⡯⡲⡑⠵⡱⣟⡧⣺⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⢟⡡⡟⢎⠰⣇⢺⣺⢰⣿⣿⡪⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⢸⣷⣴⣴⣿⣿⣿⣿⣿⡌⣿⣿⣿⡦⡱⣩⠤⠬⡙⢵⠃⣸⢎⢎⡯⡎⡂⡗⡽⣾⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⡮⢋⠕⣊⣭⡶⢃⠏⡃⣪⢗⢸⣿⣿⡆⣿⣿⣿⣿⣿⣿⣿⡿⢸⣿⣿⣿⣿⣗⢽⣿⣿⣿⣿⣿⣿⣿⣿⢇⣿⣿⣿⡏⣰⢽⣶⡵⡜⢆⠡⢽⠪⡪⡯⣳⠀⡇⡏⢸⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢟⢓⣊⣋⡨⢺⢕⠘⣿⣿⣷⡸⣿⣿⣿⣿⣿⣿⢣⣿⣿⣿⣿⣿⣿⡸⣿⣿⣿⣿⣿⣿⣿⣿⢡⣿⣿⣿⣷⣯⢹⣿⣿⣾⡬⠀⣿⠡⣳⣫⡻⢨⢪⡢⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣫⣵⣾⣿⣿⣯⣉⢇⢽⢕⢅⢻⣿⣿⣷⣌⡻⠿⠿⡛⣥⣞⢏⣿⣿⣿⣿⣿⣧⡛⣿⣿⣿⣿⣿⠿⣑⣾⣿⣿⣿⣿⢋⣠⠾⢟⢟⡜⣰⢽⢅⡳⣵⢋⡼⢢⢣⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣷⡣⣿⣿⣿⣿⣟⢿⣿⡆⢽⣂⠶⣿⣿⠿⣿⡿⣿⣿⣾⣿⣿⣟⢨⣿⣿⣿⣿⣿⣿⣿⣦⣭⣭⣭⣶⣾⣿⣿⣿⣿⡟⠹⣴⣶⠟⠋⡡⣪⢮⢺⡕⢼⣣⢞⣨⡐⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⡂⣿⣿⣿⣿⣿⣿⣮⡇⢽⢈⣳⡘⣿⣿⣦⣿⣿⣿⣿⣿⣿⣿⣦⣿⣿⣿⣿⣿⣿⣎⣛⣻⣿⣿⣿⣿⣿⣿⡟⢿⠷⠴⢋⣥⡞⡡⠲⡵⡻⡔⢯⡚⡞⢴⡱⡅⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢺⣿⣿⣿⣿⣿⣿⡇⡫⠀⣧⡓⢌⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣩⣽⠿⡉⣠⣶⣷⣿⣿⣿⠅⢢⢫⢯⣫⠇⣇⠯⢣⢣⣻⠠⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⢿⣿⣯⣿⣿⣿⣷⠠⡱⡸⡏⡝⣼⣲⠈⣍⣛⠛⠟⠿⠿⠿⢿⢿⢿⢿⠿⡿⢿⠯⠿⠛⡋⡍⡦⣯⠃⣿⣿⣿⣿⣿⣿⡅⢜⢸⣝⡞⢸⢃⢕⢕⡯⠎⣼⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡌⣿⣿⡽⣿⣿⣿⡂⡣⢱⡁⢾⡵⠃⢐⣿⣿⣿⣅⢿⠾⡶⡳⠒⣂⣴⣾⣾⣷⣿⠏⢀⠇⢪⢺⡺⢨⣿⣿⣿⣿⢷⣿⣇⢸⢜⡮⡇⢜⡔⡋⣩⣴⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡜⣿⣿⢽⣿⢽⣷⡙⡔⠬⡂⢄⠁⢜⣿⣿⠟⡧⠹⣶⢕⠸⡜⢿⣿⣿⣿⣿⢏⠀⡔⡑⡅⢪⢯⢸⣿⣿⣿⢯⣿⣿⣿⠈⡎⣯⡂⢕⢝⣵⠘⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡘⣿⣗⢿⣟⢺⢉⠞⡆⠪⡪⠀⠽⢋⣶⡀⢫⡣⣿⣸⠗⢋⣄⢿⣿⣿⢏⠂⢠⠣⡱⡘⣨⡗⢸⣿⣿⡯⣿⣿⣿⠏⣴⡘⢜⠎⢰⣝⢮⠇⣻⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡘⣿⣇⢷⠇⢜⠄⠣⠱⡘⡠⡑⢌⣿⣧⠘⠔⠏⡠⣲⣿⣿⣎⢻⡟⠔⠠⡡⡃⡪⢂⠎⣗⠐⡿⣟⣾⣟⠿⢃⣼⣿⡿⢖⡰⣯⣺⠝⣡⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡘⢯⣪⠑⡠⡨⡑⡔⢅⠇⡕⢐⢿⢋⠁⠀⠸⣽⣿⣿⣿⣿⡧⠁⡐⡱⡨⡪⠨⡒⠅⠎⡠⣟⣾⣿⠟⣡⣮⣩⡒⢺⡪⢛⢊⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣔⠳⢀⠪⡰⡨⡊⡢⡃⢎⠔⢠⠂⠂⠀⡈⣿⣿⣿⣿⠛⡈⡊⠜⡐⠅⢆⢣⠪⡈⠔⠄⣪⠟⣡⣾⣿⣿⣿⡏⡾⡨⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢐⠕⡌⡢⡱⡨⡊⠎⢀⠂⠌⡔⠁⣧⢸⡿⡋⡔⡡⢪⢘⢄⠠⡑⡕⢅⢣⢱⢁⠅⢴⣿⣿⣿⣿⣿⣿⣇⡃⢅⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢨⠪⡐⢕⠌⡆⡪⠂⠅⠀⠰⣇⠀⠟⢀⠢⡑⢔⢜⠌⡆⢇⢕⢱⢘⢌⢆⠣⡃⢰⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⢐⢑⢜⠰⡱⢨⠪⡘⠀⢜⢐⠩⠀⠊⡰⢨⢊⢎⠢⡑⡕⢅⢣⠪⡘⡔⢅⢣⢑⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡃⡐⡱⢨⠪⡨⡂⡇⢕⠀⡇⢕⢕⠀⢕⢜⠌⢆⢣⠱⡑⡜⡌⡆⢕⡑⢜⢌⠪⡂⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
			},
		},
		{
			width = 10,
			colors = true,
			height = 10,
			ascii = {
				"[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;183;109;110m⠐[0m[38;2;0;0;0m⠀[0m[38;2;164;61;86m⠐[0m[38;2;239;135;156m⡑[0m[38;2;154;49;78m⠄[0m[38;2;248;140;171m⠨[0m[38;2;148;38;84m⡀[0m[38;2;148;39;94m⠂[0m[38;2;133;27;62m⠀[0m[38;2;249;145;168m⡑[0m[38;2;138;32;68m⠈[0m[38;2;247;145;169m⠢[0m[38;2;217;114;145m⡁[0m[38;2;230;124;155m⠢[0m[38;2;238;136;155m⡑[0m[38;2;238;137;156m⢌[0m[38;2;198;92;111m⠄[0m[38;2;250;223;214m⣟[0m[38;2;249;232;219m⣷[0m[38;2;252;234;225m⣻[0m[38;2;252;235;225m⣗[0m[38;2;252;235;225m⣯[0m[38;2;252;235;225m⢿[0m[38;2;252;235;225m⡽[0m[38;2;252;235;225m⣯[0m[38;2;254;234;225m⢷[0m[38;2;254;234;225m⣻[0m[38;2;252;235;225m⢾[0m[38;2;252;235;225m⡽[0m[38;2;252;235;225m⣯[0m[38;2;252;235;225m⡯[0m[38;2;254;234;227m⣿[0m[38;2;254;234;227m⢽[0m[38;2;254;234;227m⡯[0m[38;2;254;234;227m⡿[0m[38;2;252;234;229m⡽[0m[38;2;252;234;229m⣯[0m[38;2;253;235;230m⢿[0m[38;2;250;231;225m⡽[0m[38;2;249;229;222m⡾[0m[38;2;247;225;219m⡝[0m[38;2;213;171;178m⠀[0m[38;2;151;48;84m⠀[0m[38;2;226;123;139m⡅[0m[38;2;219;119;138m⡑[0m[38;2;235;133;155m⢌[0m[38;2;240;138;161m⠌[0m[38;2;120;15;46m⠀[0m[38;2;247;142;159m⢕[0m[38;2;223;117;135m⠈[0m[38;2;149;39;89m⠀[0m[38;2;51;24;28m⠀[0m[38;2;0;0;0m⠀[0m[38;2;188;118;122m⠄[0m[38;2;0;0;0m⠀[0m",
				"[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;41;25;21m⠠[0m[38;2;34;21;21m⠀[0m[38;2;218;123;141m⠨[0m[38;2;234;136;149m⡊[0m[38;2;123;55;70m⠀[0m[38;2;200;98;140m⠂[0m[38;2;152;45;92m⡀[0m[38;2;148;40;90m⠁[0m[38;2;177;71;108m⠠[0m[38;2;146;39;87m⠁[0m[38;2;154;51;86m⠈[0m[38;2;249;147;166m⢢[0m[38;2;138;30;82m⠀[0m[38;2;243;139;166m⢊[0m[38;2;244;141;158m⠢[0m[38;2;244;140;156m⡁[0m[38;2;177;129;128m⠨[0m[38;2;255;241;234m⡓[0m[38;2;251;233;229m⠷[0m[38;2;252;234;228m⣻[0m[38;2;253;234;227m⣞[0m[38;2;253;234;227m⣯[0m[38;2;253;234;226m⢿[0m[38;2;253;234;226m⡽[0m[38;2;253;234;226m⣯[0m[38;2;253;234;226m⢿[0m[38;2;253;234;226m⡽[0m[38;2;253;234;227m⣯[0m[38;2;251;237;228m⢿[0m[38;2;241;216;211m⣊[0m[38;2;255;244;236m⣏[0m[38;2;254;234;227m⣯[0m[38;2;254;234;227m⢿[0m[38;2;254;234;227m⣽[0m[38;2;252;234;229m⣻[0m[38;2;252;234;229m⣽[0m[38;2;252;234;229m⠯[0m[38;2;253;233;229m⠟[0m[38;2;252;236;231m⠍[0m[38;2;176;141;149m⠐[0m[38;2;154;45;90m⠈[0m[38;2;127;21;39m⡐[0m[38;2;223;120;137m⠀[0m[38;2;233;135;153m⡸[0m[38;2;245;145;163m⠀[0m[38;2;144;41;84m⠀[0m[38;2;137;41;48m⠀[0m[38;2;239;135;156m⡢[0m[38;2;182;78;101m⠂[0m[38;2;148;46;88m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;68;42;36m⠀[0m[38;2;0;0;0m⠀[0m",
				"[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;1;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;184;100;113m⠈[0m[38;2;177;106;112m⠄[0m[38;2;75;41;49m⡀[0m[38;2;147;39;90m⠀[0m[38;2;150;43;93m⡈[0m[38;2;142;35;85m⠀[0m[38;2;140;33;81m⠄[0m[38;2;102;50;67m⠁[0m[38;2;136;42;70m⠀[0m[38;2;218;118;153m⠅[0m[38;2;153;48;93m⡀[0m[38;2;195;91;128m⠈[0m[38;2;240;137;155m⠪[0m[38;2;167;63;74m⡀[0m[38;2;245;175;163m⠘[0m[38;2;236;174;161m⡌[0m[38;2;200;145;135m⢆[0m[38;2;217;194;182m⢪[0m[38;2;255;245;237m⢙[0m[38;2;251;236;230m⢝[0m[38;2;252;234;229m⠯[0m[38;2;252;234;229m⡿[0m[38;2;252;234;229m⣽[0m[38;2;252;234;229m⡽[0m[38;2;252;234;229m⣯[0m[38;2;252;234;229m⣟[0m[38;2;255;239;237m⣞[0m[38;2;250;232;227m⣷[0m[38;2;253;234;230m⡻[0m[38;2;252;234;230m⠽[0m[38;2;250;231;227m⠚[0m[38;2;255;242;236m⠉[0m[38;2;239;221;217m⠄[0m[38;2;143;75;95m⠂[0m[38;2;130;46;66m⠀[0m[38;2;114;50;67m⠀[0m[38;2;144;37;91m⢀[0m[38;2;118;17;43m⠐[0m[38;2;221;133;141m⠀[0m[38;2;80;38;44m⠁[0m[38;2;220;116;152m⡀[0m[38;2;147;43;89m⠂[0m[38;2;124;35;47m⠀[0m[38;2;45;26;23m⠀[0m[38;2;252;152;167m⠆[0m[38;2;136;29;66m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m",
				"[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;1;0;0m⢀[0m[38;2;0;0;0m⣤[0m[38;2;34;14;12m⣦[0m[38;2;66;29;28m⣶[0m[38;2;103;50;48m⣶[0m[38;2;99;38;39m⣦[0m[38;2;70;25;25m⣦[0m[38;2;50;19;20m⡢[0m[38;2;12;5;5m⢤[0m[38;2;0;0;0m⡠[0m[38;2;17;14;14m⡠[0m[38;2;45;38;37m⡀[0m[38;2;25;19;17m⡀[0m[38;2;126;62;78m⡀[0m[38;2;136;33;65m⢀[0m[38;2;149;46;86m⡰[0m[38;2;87;38;50m⢸[0m[38;2;224;188;197m⢱[0m[38;2;161;86;104m⢢[0m[38;2;148;40;72m⠢[0m[38;2;157;48;93m⡀[0m[38;2;168;60;98m⠈[0m[38;2;166;65;86m⢀[0m[38;2;214;138;128m⠈[0m[38;2;227;167;154m⠪[0m[38;2;230;166;154m⡢[0m[38;2;229;167;154m⡑[0m[38;2;231;170;157m⡅[0m[38;2;234;169;157m⢕[0m[38;2;205;148;136m⠌[0m[38;2;193;163;150m⢆[0m[38;2;240;226;217m⠍[0m[38;2;255;247;240m⣙[0m[38;2;255;239;232m⣊[0m[38;2;255;240;234m⠋[0m[38;2;230;212;205m⠀[0m[38;2;154;93;120m⠂[0m[38;2;135;29;69m⠁[0m[38;2;181;95;118m⠌[0m[38;2;150;47;91m⢀[0m[38;2;146;44;83m⠐[0m[38;2;149;40;85m⡀[0m[38;2;49;28;30m⠀[0m[38;2;126;47;62m⠀[0m[38;2;141;42;69m⠀[0m[38;2;15;11;12m⠀[0m[38;2;45;31;29m⠀[0m[38;2;152;38;87m⡁[0m[38;2;138;35;68m⢀[0m[38;2;44;28;28m⠀[0m[38;2;0;0;0m⠀[0m[38;2;127;57;55m⠌[0m[38;2;177;101;107m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m",
				"[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;1;0;0m⠀[0m[38;2;40;15;14m⣴[0m[38;2;253;246;247m⣿[0m[38;2;247;248;244m⣿[0m[38;2;254;255;253m⣻[0m[38;2;252;252;249m⢿[0m[38;2;252;252;249m⣟[0m[38;2;253;253;251m⣿[0m[38;2;252;253;251m⣿[0m[38;2;255;255;255m⣿[0m[38;2;227;220;225m⣷[0m[38;2;203;184;195m⣧[0m[38;2;205;188;198m⣇[0m[38;2;207;190;204m⡏[0m[38;2;211;191;209m⡮[0m[38;2;211;194;213m⡺[0m[38;2;152;116;133m⡘[0m[38;2;211;189;201m⡜[0m[38;2;198;175;187m⣎[0m[38;2;196;170;184m⢎[0m[38;2;210;187;205m⢧[0m[38;2;213;189;204m⢫[0m[38;2;186;147;150m⡪[0m[38;2;224;164;149m⣌[0m[38;2;193;108;113m⣂[0m[38;2;141;44;66m⠢[0m[38;2;134;34;68m⠢[0m[38;2;174;94;101m⡠[0m[38;2;240;172;163m⡑[0m[38;2;235;172;159m⢌[0m[38;2;228;165;152m⠢[0m[38;2;230;165;153m⡣[0m[38;2;229;164;152m⡑[0m[38;2;192;126;120m⡨[0m[38;2;225;196;208m⡪[0m[38;2;208;187;206m⡪[0m[38;2;222;194;213m⡳[0m[38;2;125;55;63m⡐[0m[38;2;142;72;86m⢤[0m[38;2;11;10;8m⢢[0m[38;2;139;46;69m⢄[0m[38;2;99;41;56m⡢[0m[38;2;107;42;42m⡔[0m[38;2;91;45;47m⡔[0m[38;2;127;67;69m⡖[0m[38;2;163;100;104m⡎[0m[38;2;178;119;122m⡦[0m[38;2;130;55;67m⣪[0m[38;2;184;142;160m⣾[0m[38;2;254;248;250m⣿[0m[38;2;252;244;248m⣿[0m[38;2;222;202;201m⣷[0m[38;2;148;97;90m⣶[0m[38;2;31;16;15m⣤[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m[38;2;0;0;0m⠀[0m",
			},
		},
	},
}

function M:show()
	local mode = vim.api.nvim_get_mode()
	if mode == "i" or not vim.bo.modifiable then
		return
	end

	if not vim.o.hidden and vim.bo.modified then
		--save before open
		vim.cmd.write()
		return
	end

	if not utils.buf_is_empty(0) then
		self.bufnr = vim.api.nvim_create_buf(false, true)
	else
		self.bufnr = vim.api.nvim_get_current_buf()
	end

	self.winid = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(self.winid, self.bufnr)

	self.user_cursor_line = vim.opt.cursorline:get()

	local opts = {
		["bufhidden"] = "wipe",
		["colorcolumn"] = "",
		["foldcolumn"] = "0",
		["matchpairs"] = "",
		["buflisted"] = false,
		["cursorcolumn"] = false,
		["cursorline"] = false,
		["list"] = false,
		["number"] = false,
		["relativenumber"] = false,
		["spell"] = false,
		["swapfile"] = false,
		["readonly"] = false,
		["filetype"] = "dashboard",
		["wrap"] = false,
		["signcolumn"] = "no",
		["winbar"] = "",
	}
	for opt, val in pairs(opts) do
		vim.opt_local[opt] = val
	end

	vim.api.nvim_create_autocmd("VimResized", {
		buffer = self.bufnr,
		callback = function()
			vim.bo[self.bufnr].modifiable = true
			print(".2.")
			require("test.init"):render()
			vim.bo[self.bufnr].modifiable = false
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(opt)
			local bufs = vim.api.nvim_list_bufs()
			bufs = vim.tbl_filter(function(k)
				return vim.bo[k].filetype == "dashboard"
			end, bufs)
			if #bufs == 0 then
				pcall(vim.api.nvim_del_autocmd, opt.id)
			end
		end,
		desc = "[Dashboard] clean dashboard data reduce memory",
	})

	self:render()
	vim.bo[self.bufnr].modifiable = false
end

function M:render()
	self:get_valid()

	if #self.valid == 0 then
		print("not matching dashboard );")
	else
		self:draw(self.valid[math.random(1, #self.valid)])
	end
end

function M:get_valid()
	self.valid = {}

	for _, dashboard in ipairs(self.opts.dashboards) do
		if dashboard.width <= vim.api.nvim_win_get_width(0) then
			if dashboard.height <= vim.api.nvim_win_get_height(0) - (#self.opts.keybinds * 2 + 1) then
				table.insert(self.valid, dashboard)
			end
		end
	end
end

function M:draw(dashboard)
	--vim.api.nvim_buf_set_text(self.bufnr, 0, 0, 10, 10, dashboard.ascii)
	if dashboard.colors then
		local baleia = require("baleia").setup({})
		baleia.buf_set_lines(self.bufnr, 0, -1, true, dashboard.ascii)
	else
		vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, true, dashboard.ascii)
	end
end

function M.setup(opts)
	opts = opts or {}
	M.opts = vim.tbl_deep_extend("force", default_opts, opts)
end

return M

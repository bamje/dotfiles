local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ===== Tema e palette
config.color_scheme = "Catppuccin Macchiato"
local mac = {
	crust = "#181926",
	mantle = "#1e2030",
	yellow = "#eed49f",
	green = "#a6da95",
	teal = "#8bd5ca",
	sky = "#91d7e3",
	sapphire = "#7dc4e4",
	blue = "#8aadf4",
	lavender = "#b7bdf8",
}

-- ===== Font
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"JetBrainsMono Nerd Font Mono",
	"Fira Code",
	"DejaVu Sans Mono",
})
config.font_size = 12
config.line_height = 1.15

-- ===== Finestra minimal
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 6, bottom = 6 }
config.enable_scroll_bar = false

-- ===== Renderer stabile
config.enable_wayland = false
config.front_end = "OpenGL"
config.max_fps = 60

-- ===== Barra tab sempre attiva (come status bar)
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false -- sempre visibile
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.status_update_interval = 1000

-- Colori tab bar uniformi (sfondo giallo, testo giallo -> tab invisibili)
config.colors = config.colors or {}
config.colors.tab_bar = {
	background = mac.mantle,
	active_tab = { bg_color = mac.mantle, fg_color = mac.green },
	inactive_tab = { bg_color = mac.mantle, fg_color = mac.yellow },
	inactive_tab_hover = { bg_color = mac.yellow, fg_color = mac.yellow },
	new_tab = { bg_color = mac.yellow, fg_color = mac.yellow },
	new_tab_hover = { bg_color = mac.yellow, fg_color = mac.yellow },
}

-- ===== Helper per segmenti status bar
local function seg(txt, fg, bg)
	return {
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = " " .. txt .. " " },
		{ ResetAttributes = {} },
	}
end

-- ===== Status bar tmux-like
wezterm.on("update-status", function(window, pane)
	local ws = window:active_workspace() or "0"
	local tab = window:active_tab()
	local idx = tab and (tab:get_index() or 0) or 0
	local title = (tab and tab:get_title()) or pane:get_title() or "shell"
	local left_text = string.format(" [%s] %d:%s* ", ws, idx, title)

	local clock = wezterm.strftime("%H:%M  %d-%b-%y")
	local host = wezterm.hostname()
	local right_text = string.format(' "%s"  %s ', host, clock)

	window:set_left_status(wezterm.format(seg(left_text, mac.crust, mac.yellow)))
	window:set_right_status(wezterm.format(seg(right_text, mac.crust, mac.yellow)))
end)

-- ===== Keybindings base (ALT per split, pane, tab)
config.keys = {
	-- Gestione pane
	{ key = "|", mods = "ALT|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "_", mods = "ALT|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "q", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },

	{ key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },

	-- Gestione tab
	{ key = "c", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
	{
		key = "r",
		mods = "ALT",
		action = wezterm.action.PromptInputLine({
			description = "Rinomina tab",
			action = wezterm.action_callback(function(win, _, line)
				if line then
					win:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Selezione tab con Alt + numero
	{ key = "1", mods = "ALT", action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = wezterm.action.ActivateTab(4) },
	{ key = "6", mods = "ALT", action = wezterm.action.ActivateTab(5) },
	{ key = "7", mods = "ALT", action = wezterm.action.ActivateTab(6) },
	{ key = "8", mods = "ALT", action = wezterm.action.ActivateTab(7) },
	{ key = "9", mods = "ALT", action = wezterm.action.ActivateTab(8) },
}

-- ===== Scroll e campanella
config.scrollback_lines = 10000
config.audible_bell = "Disabled"

return config

-- Catppuccin Mocha + Qtile uyumlu renk paleti
-- Qtile config.py'deki renkleri birebir korur.

local theme = {}

-- === Fontlar ===
theme.font        = "JetBrainsMono Nerd Font 10"
theme.font_bold   = "JetBrains Mono Bold 10"
theme.font_group  = "JetBrains Mono Bold 12"

-- === Bar ===
theme.bar_bg     = "#0f0f14"   -- Qtile: BAR_BG
theme.bar_height = 22

-- === Qtile'dan gelen renkler ===
theme.active     = "#2dd4bf"   -- ACTIVE_WORKSPACE
theme.inactive   = "#4b5563"   -- INACTIVE_WORKSPACE
theme.text       = "#f3f4f6"   -- TEXT_COLOR
theme.widget     = "#2dd4bf"   -- WIDGET_COLOR
theme.separator  = "#374151"   -- SEP_COLOR
theme.window     = "#ffffff"   -- WINDOW_NAME_COLOR
theme.danger     = "#f38ba8"

-- === Beautiful varsayılanları ===
theme.bg_normal   = theme.bar_bg
theme.bg_focus    = theme.active
theme.bg_urgent   = theme.danger
theme.bg_minimize = theme.inactive
theme.fg_normal   = theme.text
theme.fg_focus    = theme.bar_bg
theme.fg_urgent   = theme.text
theme.fg_minimize = theme.text

theme.border_width  = 0
theme.border_normal = theme.inactive
theme.border_focus  = theme.active
theme.border_marked = theme.danger

-- === Tag list ===
theme.taglist_font      = theme.font_group
theme.taglist_fg_focus    = theme.active
theme.taglist_fg_occupied = theme.text
theme.taglist_fg_empty    = theme.inactive
theme.taglist_bg_focus    = theme.bar_bg
theme.taglist_bg_occupied = theme.bar_bg
theme.taglist_bg_empty    = theme.bar_bg

-- === Task list ===
theme.tasklist_font      = theme.font_bold
theme.tasklist_fg_normal = theme.window
theme.tasklist_fg_focus  = theme.window
theme.tasklist_bg_normal = theme.bar_bg
theme.tasklist_bg_focus  = theme.bar_bg

-- === Menü ===
theme.menu_height   = 24
theme.menu_width    = 200
theme.menu_fg_normal = theme.text
theme.menu_bg_normal = theme.bar_bg
theme.menu_fg_focus  = theme.bar_bg
theme.menu_bg_focus  = theme.active
theme.menu_border_color = theme.separator
theme.menu_border_width = 1

-- === Bildirim / Tooltip ===
theme.notify_font   = theme.font
theme.notify_fg     = theme.text
theme.notify_bg     = theme.bar_bg
theme.notify_border = theme.separator

theme.tooltip_font   = theme.font
theme.tooltip_fg     = theme.text
theme.tooltip_bg     = theme.bar_bg
theme.tooltip_border_color = theme.separator
theme.tooltip_border_width = 1

-- === Systray ===
theme.systray_icon_spacing = 4

-- === Hotkeys popup ===
theme.hotkeys_font              = theme.font
theme.hotkeys_description_font  = theme.font
theme.hotkeys_bg                = theme.bar_bg
theme.hotkeys_fg                = theme.text
theme.hotkeys_modifiers_fg      = theme.active
theme.hotkeys_border_color      = theme.separator
theme.hotkeys_border_width      = 1
theme.hotkeys_group_margin      = 10

-- === Wallpaper ===
theme.wallpaper = os.getenv("HOME") .. "/dotfiles/wallpaper.png"

return theme

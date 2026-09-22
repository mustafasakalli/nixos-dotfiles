-- AwesomeWM ana yapılandırma dosyası
-- Qtile'dan uyarlanmıştır.

-- Standart kütüphaneler
local gears     = require("gears")
local awful     = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local menubar   = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Modüllerimiz
local theme = require("theme")
local keys  = require("keys")
local mybar = require("bar")

-- === Hata yönetimi ===
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title  = "Başlangıç hatası!",
        text   = awesome.startup_errors,
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title  = "Hata!",
            text   = tostring(err),
        })
        in_error = false
    end)
end

-- === Beautiful tema ===
beautiful.init(theme)

-- === Layout'lar (Qtile: Columns + Max) ===
awful.layout.layouts = {
    awful.layout.suit.tile,       -- Qtile'daki Columns
    awful.layout.suit.max,        -- Qtile'daki Max
    awful.layout.suit.floating,   -- Qtile'daki Floating
}

-- === Menü ===
local mymainmenu = awful.menu({
    items = {
        { "Yardım",    function () hotkeys_popup.show_help(nil, awful.screen.focused()) end },
        { "Terminal",  "alacritty" },
        { "Firefox",   "firefox" },
        { "Rofi",      "rofi -show drun" },
        { "Geany",     "geany" },
        { "Yeniden Başlat", awesome.restart },
        { "Çıkış",     awesome.quit },
    }
})

menubar.utils.terminal = "alacritty"

-- === Root tuş ve fare bağlamaları ===
root.keys(keys.globalkeys)
root.buttons(gears.table.join(
    awful.button({}, 3, function () mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- === Her ekran için kurulum ===
awful.screen.connect_for_each_screen(function (s)
    -- Wallpaper
    gears.wallpaper.maximized(theme.wallpaper, s, true)

    -- Tag'ler
    awful.tag({ "1", "2", "3", "4", "5", "6" }, s, awful.layout.layouts[1])

    -- Bar
    mybar.create(s)
end)

-- === Client sinyalleri ===
client.connect_signal("manage", function (c)
    c:buttons(keys.clientbuttons)
    c:keys(keys.clientkeys)

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("mouse::enter", function (c)
    c:activate { context = "mouse_enter", raise = false }
end)

client.connect_signal("focus",   function (c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)

-- === Autostart (Qtile'daki startup_hook karşılığı) ===
-- Sistem tepsisi için ağ yöneticisi applet'i (opsiyonel)
awful.spawn.once("nm-applet")

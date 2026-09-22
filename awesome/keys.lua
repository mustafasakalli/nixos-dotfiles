-- Qtile'daki tüm tuş ve fare bağlamalarının AwesomeWM karşılıkları.

local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")

local mod = "Mod4"
local terminal = "alacritty"
local browser  = "firefox"
local launcher = "rofi -show drun"

local M = {}

-- =========================================================================
-- GLOBAL TUŞ BAĞLAMALARI
-- =========================================================================
M.globalkeys = gears.table.join(
    -- AwesomeWM
    awful.key({ mod }, "s", function ()
        hotkeys_popup.show_help(nil, awful.screen.focused())
    end, { description = "Yardım menüsü", group = "AwesomeWM" }),

    -- Uygulama başlatma
    awful.key({ mod }, "Return", function () awful.spawn(terminal) end,
        { description = "Terminal aç", group = "Launcher" }),
    awful.key({ mod }, "b", function () awful.spawn(browser) end,
        { description = "Firefox aç", group = "Launcher" }),
    awful.key({ mod }, "d", function () awful.spawn(launcher) end,
        { description = "Rofi aç", group = "Launcher" }),

    -- Pencere yönetimi
    awful.key({ mod }, "q", function (c) c:kill() end,
        { description = "Pencereyi kapat", group = "Client" }),
    awful.key({ mod }, "t", function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "Tam ekran", group = "Client" }),
    awful.key({ mod }, "f", function (c) c.floating = not c.floating end,
        { description = "Pencereyi yüzdür", group = "Client" }),

    -- Layout değiştirme (Qtile'daki mod+Tab)
    awful.key({ mod }, "Tab", function () awful.layout.inc(1) end,
        { description = "Sonraki layout", group = "Layout" }),
    awful.key({ mod, "Shift" }, "Tab", function () awful.layout.inc(-1) end,
        { description = "Önceki layout", group = "Layout" }),
    awful.key({ mod }, "n", awful.tag.incnmaster(1, nil, true),
        { description = "Master pencere sayısını artır", group = "Layout" }),

    -- Odaklanma (vim tarzı)
    awful.key({ mod }, "j", function () awful.client.focus.global_bydirection("down") end,
        { description = "Aşağı pencereye geç", group = "Client" }),
    awful.key({ mod }, "k", function () awful.client.focus.global_bydirection("up") end,
        { description = "Yukarı pencereye geç", group = "Client" }),
    awful.key({ mod }, "h", function () awful.client.focus.global_bydirection("left") end,
        { description = "Sol pencereye geç", group = "Client" }),
    awful.key({ mod }, "l", function () awful.client.focus.global_bydirection("right") end,
        { description = "Sağ pencereye geç", group = "Client" }),

    -- Pencere taşıma (mod+shift+h/j/k/l)
    awful.key({ mod, "Shift" }, "j", function () awful.client.swap.global_bydirection("down") end,
        { description = "Pencereyi aşağı taşı", group = "Client" }),
    awful.key({ mod, "Shift" }, "k", function () awful.client.swap.global_bydirection("up") end,
        { description = "Pencereyi yukarı taşı", group = "Client" }),
    awful.key({ mod, "Shift" }, "h", function () awful.client.swap.global_bydirection("left") end,
        { description = "Pencereyi sola taşı", group = "Client" }),
    awful.key({ mod, "Shift" }, "l", function () awful.client.swap.global_bydirection("right") end,
        { description = "Pencereyi sağa taşı", group = "Client" }),

    -- Pencere boyutu (mod+ctrl+h/j/k/l) - Qtile'daki grow
    awful.key({ mod, "Control" }, "j", function () awful.client.incwfact(0.05) end,
        { description = "Pencereyi büyüt", group = "Client" }),
    awful.key({ mod, "Control" }, "k", function () awful.client.incwfact(-0.05) end,
        { description = "Pencereyi küçült", group = "Client" }),

    -- Reload / Restart (Qtile'daki mod+ctrl+r)
    awful.key({ mod, "Control" }, "r", awesome.restart,
        { description = "AwesomeWM'i yeniden başlat", group = "AwesomeWM" }),
    awful.key({ mod, "Control" }, "q", awesome.quit,
        { description = "AwesomeWM'den çık", group = "AwesomeWM" }),

    -- Tag navigasyonu (Qtile'daki mod+shift+Left/Right)
    awful.key({ mod, "Shift" }, "Right", awful.tag.viewnext,
        { description = "Sonraki masaüstü", group = "Tag" }),
    awful.key({ mod, "Shift" }, "Left", awful.tag.viewprev,
        { description = "Önceki masaüstü", group = "Tag" }),

    -- Sistem tuşları
    awful.key({}, "XF86AudioRaiseVolume", function () awful.spawn("pamixer -i 5") end,
        { description = "Ses +", group = "Media" }),
    awful.key({}, "XF86AudioLowerVolume", function () awful.spawn("pamixer -d 5") end,
        { description = "Ses -", group = "Media" }),
    awful.key({}, "XF86AudioMute", function () awful.spawn("pamixer -t") end,
        { description = "Sessiz", group = "Media" }),
    awful.key({}, "XF86MonBrightnessUp", function () awful.spawn("brightnessctl set +10%") end,
        { description = "Parlaklık +", group = "Media" }),
    awful.key({}, "XF86MonBrightnessDown", function () awful.spawn("brightnessctl set 10%-") end,
        { description = "Parlaklık -", group = "Media" })
)

-- Tag'lere 1-6 tuşlarıyla direkt erişim (Qtile'daki mod+1..6)
for i = 1, 6 do
    M.globalkeys = gears.table.join(M.globalkeys,
        awful.key({ mod }, "#" .. (i + 9), function ()
            local s = awful.screen.focused()
            local t = s.tags[i]
            if t then t:view_only() end
        end, { description = "Masaüstü " .. i, group = "Tag" }),
        awful.key({ mod, "Shift" }, "#" .. (i + 9), function ()
            if client.focus then
                local t = client.focus.screen.tags[i]
                if t then client.focus:move_to_tag(t) end
            end
        end, { description = "Pencereyi masaüstü " .. i .. "'e taşı", group = "Tag" })
    )
end

-- =========================================================================
-- CLIENT (pencere) TUŞ BAĞLAMALARI
-- =========================================================================
M.clientkeys = gears.table.join(
    awful.key({ mod }, "q", function (c) c:kill() end,
        { description = "Pencereyi kapat", group = "Client" }),
    awful.key({ mod }, "t", function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "Tam ekran", group = "Client" }),
    awful.key({ mod }, "f", function (c) c.floating = not c.floating end,
        { description = "Yüzdür", group = "Client" }),
    awful.key({ mod, "Control" }, "Return", function (c)
        c:swap(awful.client.getmaster())
    end, { description = "Master ile yer değiştir", group = "Client" })
)

-- =========================================================================
-- FARE BAĞLAMALARI (Qtile mouse= karşılığı)
-- =========================================================================
M.clientbuttons = gears.table.join(
    awful.button({}, 1, function (c) c:activate { context = "mouse_click" } end),
    awful.button({ mod }, 1, function (c)
        c:activate { context = "mouse_click", action = "mouse_move" }
    end),
    awful.button({ mod }, 3, function (c)
        c:activate { context = "mouse_click", action = "mouse_resize" }
    end)
)

return M

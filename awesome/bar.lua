-- Qtile bar'ının AwesomeWM karşılığı.
-- Konum: alt, yükseklik: 26px, renk: #0f0f14

local awful   = require("awful")
local wibox   = require("wibox")
local gears   = require("gears")
local beautiful = require("beautiful")
local theme   = require("theme")

local M = {}

-- === Yardımcı: ayraç (Qtile'daki TextBox "|" karşılığı) ===
local function separator()
    return wibox.widget {
        markup = "<span foreground='" .. theme.separator .. "'>|</span>",
        widget = wibox.widget.textbox,
        font   = theme.font,
        align  = "center",
        valign = "center",
    }
end

-- === Tag list (Qtile'daki GroupBox) ===
local function create_taglist(s)
    local taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({ mod }, 1, function(t)
            if client.focus then client.focus:move_to_tag(t) end
        end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

    return awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout  = {
            spacing = 12,
            layout  = wibox.layout.fixed.horizontal,
        },
        style = {
            font = theme.font_group,
        },
    }
end

-- === Task list (Qtile'daki WindowName) ===
local function create_tasklist(s)
    return awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = {
            awful.button({}, 1, function (c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({}, 5, function() awful.client.focus.byidx(1) end),
        },
        layout = {
            spacing = 8,
            layout  = wibox.layout.fixed.horizontal,
        },
    }
end

-- === Network widget (Qtile'daki widget.Net) ===
local function create_net_widget()
    local widget = wibox.widget {
        markup = "<span foreground='" .. theme.widget .. "'>🌐 -- ↓↑ --</span>",
        widget = wibox.widget.textbox,
        font   = theme.font,
        align  = "center",
        valign = "center",
        forced_width = 140,
    }

    local prev_rx, prev_tx, prev_time = 0, 0, os.time()
    local iface = ""

    -- Aktif arayüzü tespit et
    awful.spawn.easy_async_with_shell(
        "ip route | awk '/default/ {print $5; exit}'",
        function(stdout)
            iface = stdout:gsub("%s+$", "")
        end
    )

    local t = gears.timer({ timeout = 2 })
    t:connect_signal("timeout", function ()
        if iface == "" then return end
        awful.spawn.easy_async_with_shell(
            "cat /sys/class/net/" .. iface .. "/statistics/rx_bytes " ..
            "/sys/class/net/" .. iface .. "/statistics/tx_bytes",
            function(stdout)
                local rx, tx = stdout:match("(%d+)%s+(%d+)")
                if not rx then return end
                rx, tx = tonumber(rx), tonumber(tx)

                local now = os.time()
                local dt  = now - prev_time

                if dt > 0 and prev_rx > 0 then
                    local down = (rx - prev_rx) / dt / 1024
                    local up   = (tx - prev_tx) / dt / 1024

                    local function fmt(v)
                        if v < 1000 then
                            return string.format("%.1fKB", v)
                        else
                            return string.format("%.1fMB", v / 1024)
                        end
                    end

                    widget.markup = "<span foreground='" .. theme.widget .. "'>🌐 " ..
                        fmt(down) .. " ↓↑ " .. fmt(up) .. "</span>"
                end

                prev_rx, prev_tx, prev_time = rx, tx, now
            end
        )
    end)
    t:start()

    return widget
end

-- === CPU widget (Qtile'daki widget.CPU) ===
local function create_cpu_widget()
    local widget = wibox.widget {
        markup = "<span foreground='" .. theme.widget .. "'>⚙ CPU: --%</span>",
        widget = wibox.widget.textbox,
        font   = theme.font,
        align  = "center",
        valign = "center",
        forced_width = 90,
    }

    awful.widget.watch(
        "sh -c \"top -bn1 | grep 'Cpu(s)' | awk '{print \\$2}'\"",
        3,
        function(_, stdout)
            local cpu = stdout:match("([%d%.]+)")
            if cpu then
                widget.markup = "<span foreground='" .. theme.widget ..
                    "'>⚙ CPU: " .. string.format("%.0f", tonumber(cpu)) .. "%</span>"
            end
        end
    )

    return widget
end

-- === Memory widget (Qtile'daki widget.Memory) ===
local function create_mem_widget()
    local widget = wibox.widget {
        markup = "<span foreground='" .. theme.widget .. "'>RAM: --/--</span>",
        widget = wibox.widget.textbox,
        font   = theme.font,
        align  = "center",
        valign = "center",
    }

    awful.widget.watch(
        "sh -c \"free -h | awk '/^Mem:/ {print \\$3\\\"/\\\"\\$2}'\"",
        3,
        function(_, stdout)
            local mem = stdout:gsub("%s+$", "")
            if mem ~= "" then
                widget.markup = "<span foreground='" .. theme.widget ..
                    "'>RAM: " .. mem .. "</span>"
            end
        end
    )

    return widget
end

-- === Clock (Qtile'daki widget.Clock) ===
local function create_clock()
    local clock = wibox.widget.textclock(
        "<span foreground='" .. theme.widget .. "'>🕒 %d/%m/%Y - %H:%M</span>",
        60
    )
    clock.font   = theme.font
    clock.align  = "center"
    clock.valign = "center"
    return clock
end

-- === QuickExit (Qtile'daki widget.QuickExit) ===
-- Qtile'da olduğu gibi: sol tık 5 saniye geri sayım başlatır, sağ tık iptal eder.
local function create_quickexit(text, cmd, countdown_format)
    local widget = wibox.widget {
        markup = "<span foreground='" .. theme.danger .. "'>" .. text .. "</span>",
        widget = wibox.widget.textbox,
        font   = theme.font,
        align  = "center",
        valign = "center",
    }

    local countdown = 0
    local timer = nil

    local function reset()
        if timer then timer:stop() ; timer = nil end
        countdown = 0
        widget.markup = "<span foreground='" .. theme.danger .. "'>" .. text .. "</span>"
    end

    widget:buttons(gears.table.join(
        awful.button({}, 1, function ()
            if timer then reset() ; return end
            countdown = 5
            widget.markup = "<span foreground='" .. theme.danger .. "'>" ..
                string.format(countdown_format, countdown) .. "</span>"
            timer = gears.timer({ timeout = 1 })
            timer:connect_signal("timeout", function ()
                countdown = countdown - 1
                if countdown <= 0 then
                    timer:stop()
                    awful.spawn(cmd)
                else
                    widget.markup = "<span foreground='" .. theme.danger .. "'>" ..
                        string.format(countdown_format, countdown) .. "</span>"
                end
            end)
            timer:start()
        end),
        awful.button({}, 3, function () reset() end)
    ))

    return widget
end

-- =========================================================================
-- BAR'ı OLUŞTUR
-- =========================================================================
function M.create(s)
    local taglist  = create_taglist(s)
    local tasklist = create_tasklist(s)
    local net      = create_net_widget()
    local cpu      = create_cpu_widget()
    local mem      = create_mem_widget()
    local clock    = create_clock()

    local reboot   = create_quickexit("⏻ Reboot",     "systemctl reboot",   "[%d] sn")
    local shutdown = create_quickexit("[X] Shutdown", "systemctl poweroff", "[%d] Kapanıyor")

    local systray = wibox.widget.systray()
    systray:set_base_size(16)

    local bar = awful.wibar {
        position = "bottom",
        height   = theme.bar_height,
        bg       = theme.bar_bg,
        screen   = s,
    }

    bar:setup {
        layout = wibox.layout.align.horizontal,
        -- Sol taraf
        {
            layout  = wibox.layout.fixed.horizontal,
            spacing = 4,
            taglist,
            separator(),
            tasklist,
        },
        -- Orta (boş)
        nil,
        -- Sağ taraf
        {
            layout  = wibox.layout.fixed.horizontal,
            spacing = 4,
            systray,
            separator(),
            net,
            separator(),
            cpu,
            separator(),
            mem,
            separator(),
            clock,
            separator(),
            reboot,
            separator(),
            shutdown,
        },
    }

    return bar
end

return M

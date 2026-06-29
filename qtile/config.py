import os
from collections.abc import Callable

import libqtile.resources
from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Output, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = guess_terminal()

# Tüm widget'larda ortak font kullanmak için
DEFAULT_FONT = "JetBrains Mono"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "b", lazy.spawn("firefox"), desc="firefox"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Start rofi"),
    
    # Shift + Mod + Sağ/Sol Ok Tuşları ile Masaüstleri (Workspace) Arasında Geziş
    Key([mod, "shift"], "Right", lazy.screen.next_group(), desc="Sonraki masaüstüne geç"),
    Key([mod, "shift"], "Left", lazy.screen.prev_group(), desc="Önceki masaüstüne geç"),

]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "123456"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrains Mono",
    fallback="JetBrains Mono",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")

# Yüksek Kontrastlı Koyu Tema Renkleri
BAR_BG = "#0f0f14"           # Tamamen koyu, derin siyah/gri arka plan
ACTIVE_WORKSPACE = "#2dd4bf"     # Parlak ve net mavi (Aktif masaüstü)
INACTIVE_WORKSPACE = "#4b5563"   # Daha belirgin gri (Aktif olmayanlar)
TEXT_COLOR = "#f3f4f6"       # Canlı beyaz (Pencere isimleri için)
WIDGET_COLOR = "#2dd4bf"     # Canlı turkuaz/neon yeşil (Saat ve Sistem bilgileri)
SEP_COLOR = "#374151"        # Ayraçlar için koyu gri
WINDOW_NAME_COLOR = "#ffffff" # Koyu beyaz

screens = [
    Screen(
        # Çubuğumuz en üstte
        bottom=bar.Bar(
            [
                # Sayfa/Masaüstü Numaraları
                widget.GroupBox(
                    font=DEFAULT_FONT,
                    fontsize=14,
                    margin_y=3,
                    margin_x=0,
                    padding_y=5,
                    padding_x=8,
                    borderwidth=3,
                    active=ACTIVE_WORKSPACE,
                    inactive=INACTIVE_WORKSPACE,
                    rounded=False,
                    highlight_color=BAR_BG,
                    highlight_method="line",
                    this_current_screen_border=ACTIVE_WORKSPACE,
                ),
                widget.TextBox(text="|", foreground=SEP_COLOR, padding=10, fontsize=14),
                # Mevcut pencerenin adı
                widget.WindowName(foreground=WINDOW_NAME_COLOR, font="JetBrains Mono Bold", fontsize=14, padding=5, width=bar.CALCULATED,),
                widget.Spacer(),
                # Sistem Çekmecesi (İkonlar)
                widget.Systray(padding=5),
                widget.TextBox(text="|", foreground=SEP_COLOR, padding=10, fontsize=14),
                
                # YENİ WIDGET 1: Canlı İnternet Hızı (Sabit Genişlikli)
                widget.Net(
                    foreground=WIDGET_COLOR,
                    font=DEFAULT_FONT,
                    fontsize=12,
                    format="🌐 {down:.1f}{down_suffix} ↓↑ {up:.1f}{up_suffix}",
                    width=140,              # Widget'ın genişliğini 180 piksele sabitler
                    width_is_max=True,       # Bu genişliğin maksimum sınır olduğunu belirtir
                    text_alignment="center", # Yazıyı bu 180 piksellik alanın ortasına hizalar
                ),
                widget.TextBox(text="|", foreground=SEP_COLOR, padding=10, fontsize=14),
                
                # YENİ WIDGET 2: CPU Kullanımı
                widget.CPU(
                    foreground=WIDGET_COLOR,
                    font=DEFAULT_FONT,
                    fontsize=12,
                    format="⚙ CPU: {load_percent}%",
                    width=90,                # Rakamlar kaç hane olursa olsun genişlik 90px kalır
                    width_is_max=True,
                    text_alignment="center", # Sağ sol titremesini önlemek için ortaladık
                ),
                widget.TextBox(text="|", foreground=SEP_COLOR, padding=10, fontsize=14),
                
                # RAM Kullanımı
                widget.Memory(
                    foreground=WIDGET_COLOR,
                    font=DEFAULT_FONT,
                    fontsize=12,
                    format="RAM: {MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}",
                ),
                widget.TextBox(text="|", foreground=SEP_COLOR, padding=10, fontsize=14),
                
                # Saat ve Tarih
                widget.Clock(
                    foreground=WIDGET_COLOR,
                    font=DEFAULT_FONT,
                    fontsize=12,
                    format="🕒 %d/%m/%Y - %H:%M",
                ),
                widget.TextBox(text="|", foreground=SEP_COLOR, padding=10, fontsize=14),
                
                # ORİJİNAL GERİ SAYIMLI SİSTEM KONTROLÜ (QuickExit)
                # Tıkladığında "reboot" yazar, bir daha basınca 5 saniye geri sayar
                widget.QuickExit(
                    foreground="#f38ba8", # Dikkat çekmesi için kırmızı/pembe tonu
                    font = DEFAULT_FONT,
                    fontsize=12,
                    default_text="⏻ Reboot",
                    countdown_format="[{}] saniye", # Geri sayım esnasında "[5] saniye" şeklinde görünür
                    countdown_start=5, # 5'ten geriye sayar
                    default_cmd="systemctl reboot", # Tetiklenecek sistem komutu (Yeniden başlatma)
                ),
                widget.TextBox(text="|", foreground=SEP_COLOR, padding=10, fontsize=14),
                
                widget.QuickExit(
                    foreground="#f38ba8", # Kırmızı tonu
                    font=DEFAULT_FONT,
                    fontsize=12,
                    default_text="[X] Shutdown", # Kare/boş görünmez, her fontta çalışır
                    countdown_format="[{}] Kapanıyor", 
                    countdown_start=5,
                    default_cmd="systemctl poweroff",
                ),
            ],
            26,
            background=BAR_BG,
        ),
    ),
]

# Instead of screens, you can define a function here to specify which Screen
# should correspond to which Output.

fake_screens: list[Screen] | None = None

# Instead of screens or fake screens, you can define a function here that
# returns a list of Screen objects based on the list of Outputs; that way you
# can decide based on e.g. the number of screens, or which ports are plugged
# in exactly what do render in each bar for each screen.
generate_screens: Callable[[list[Output]], list[Screen]] | None = None

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

idle_timers = []  # type: list
idle_inhibitors = []  # type: list

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

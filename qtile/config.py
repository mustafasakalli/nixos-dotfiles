import os
from collections.abc import Callable

import libqtile.resources
from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Output, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = guess_terminal()

# Tüm widget'larda ortak kullanılacak Nerd Font tanımı
DEFAULT_FONT = "JetBrainsMono Nerd Font"

# r/unixporn dünyasının en popüler pastel renk paleti (Catppuccin Mocha)
colors = {
    "bg":       "#1e1e2e",  # Koyu Arka Plan (Mocha Base)
    "fg":       "#cdd6f4",  # Ön Plan Yazı Rengi
    "crust":    "#11111b",  # En koyu ton
    "cyan":     "#89dceb",  # Taglar / Pencereler için
    "pink":     "#f5c2e7",  # RAM için
    "mauve":    "#cba6f7",  # CPU için
    "green":    "#a6e3a1",  # Saat/Tarih için
    "blue":     "#89b4fa",  # İnternet hızı için
    "red":      "#f38ba8",  # Kapatma butonları için
}

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    
    # Move windows between left/right columns or move up/down in current stack.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    
    # Grow windows.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
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
            Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
            # mod + shift + group number = switch to & move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc=f"Switch to & move focused window to group {i.name}"),
        ]
    )

layouts = [
    layout.Columns(border_focus=colors["mauve"], border_normal=colors["crust"], border_width=3, margin=6),
    layout.Max(),
]

widget_defaults = dict(
    font=DEFAULT_FONT,
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")

screens = [
    Screen(
        # Barımız ekranın altında, havada asılı (floating) duruyor
        bottom=bar.Bar(
            [
                # ---------------- WORKSPACES CAPSULE (Sol Taraf) ----------------
                widget.TextBox(text="", foreground=colors["cyan"], background="#00000000", fontsize=22, padding=0),
                widget.GroupBox(
                    font=DEFAULT_FONT,
                    fontsize=13,
                    margin_y=3,
                    margin_x=0,
                    padding_y=5,
                    padding_x=8,
                    borderwidth=0,
                    active=colors["bg"],           # Aktif sayfadaki yazı rengi (Koyu)
                    inactive=colors["crust"],      # Aktif olmayan sayfa rengi (Hafif silik)
                    background=colors["cyan"],     # Kapsülün içi tamamen cyan
                    rounded=False,
                    highlight_method="text",       # Temiz bir metin vurgusu
                    this_current_screen_border=colors["crust"],
                ),
                widget.TextBox(text="", foreground=colors["cyan"], background="#00000000", fontsize=22, padding=0),
                
                widget.Spacer(length=15),
                
                # Mevcut aktif pencerenin adı (Zarif ve minimalist durması için)
                widget.WindowName(foreground=colors["fg"], font="JetBrainsMono Nerd Font Bold", fontsize=12, padding=5, width=bar.CALCULATED),
                
                # Sol taraf bitti, tüm widgetları sağa yaslamak için esnek boşluk atıyoruz
                widget.Spacer(),
                
                # Sistem Çekmecesi (İkonlar arka plana uyum sağlasın diye boşlukta süzülüyor)
                widget.Systray(padding=5),
                widget.Spacer(length=15),
                
                # ---------------- INTERNET CAPSULE ----------------
                widget.TextBox(text="", foreground=colors["blue"], background="#00000000", fontsize=22, padding=0),
                widget.Net(
                    background=colors["blue"],
                    foreground=colors["bg"],
                    font=DEFAULT_FONT,
                    fontsize=12,
                    format="🌐 {down:.1f}{down_suffix} ↓↑ {up:.1f}{up_suffix}",
                ),
                widget.TextBox(text="", foreground=colors["blue"], background="#00000000", fontsize=22, padding=0),
                
                widget.Spacer(length=12),
                
                # ---------------- CPU CAPSULE ----------------
                widget.TextBox(text="", foreground=colors["mauve"], background="#00000000", fontsize=22, padding=0),
                widget.CPU(
                    background=colors["mauve"],
                    foreground=colors["bg"],
                    font=DEFAULT_FONT,
                    fontsize=12,
                    format="⚙ CPU: {load_percent}%",
                ),
                widget.TextBox(text="", foreground=colors["mauve"], background="#00000000", fontsize=22, padding=0),
                
                widget.Spacer(length=12),
                
                # ---------------- RAM CAPSULE ----------------
                widget.TextBox(text="", foreground=colors["pink"], background="#00000000", fontsize=22, padding=0),
                widget.Memory(
                    background=colors["pink"],
                    foreground=colors["bg"],
                    font=DEFAULT_FONT,
                    fontsize=12,
                    format=" RAM: {MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}",
                ),
                widget.TextBox(text="", foreground=colors["pink"], background="#00000000", fontsize=22, padding=0),
                
                widget.Spacer(length=12),
                
                # ---------------- CLOCK CAPSULE ----------------
                widget.TextBox(text="", foreground=colors["green"], background="#00000000", fontsize=22, padding=0),
                widget.Clock(
                    background=colors["green"],
                    foreground=colors["bg"],
                    font=DEFAULT_FONT,
                    fontsize=12,
                    format="🕒 %d/%m/%Y - %H:%M",
                ),
                widget.TextBox(text="", foreground=colors["green"], background="#00000000", fontsize=22, padding=0),
                
                widget.Spacer(length=12),
                
                # ---------------- POWER CAPSULE (Reboot & Shutdown Tek Kapsülde) ----------------
                widget.TextBox(text="", foreground=colors["red"], background="#00000000", fontsize=22, padding=0),
                widget.QuickExit(
                    background=colors["red"],
                    foreground=colors["bg"],
                    font=DEFAULT_FONT,
                    fontsize=12,
                    default_text="⏻ Reboot",
                    countdown_format="[{}]s",
                    countdown_start=5,
                    default_cmd="systemctl reboot",
                ),
                # İki buton arası küçük bir iç boşluk
                widget.TextBox(text="  ", background=colors["red"], padding=0),
                widget.QuickExit(
                    background=colors["red"],
                    foreground=colors["bg"],
                    font=DEFAULT_FONT,
                    fontsize=12,
                    default_text="󰐥 Shutdown",
                    countdown_format="[{}]s",
                    countdown_start=5,
                    default_cmd="systemctl poweroff",
                ),
                widget.TextBox(text="", foreground=colors["red"], background="#00000000", fontsize=22, padding=0),
            ],
            30,                     # Bar yüksekliği (Kapsüller sığsın diye 30 yaptık)
            background="#00000000", # Arka plan tamamen şeffaf! Böylece kapsüller havada uçuyor hissi veriyor
            margin=[0, 15, 8, 15],  # Havada asılı durma efekti: alt ve yanlardan boşluk bırakır
        ),
    ),
]

fake_screens: list[Screen] | None = None
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
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
idle_timers = []  # type: list
idle_inhibitors = []  # type: list
wmname = "LG3D"

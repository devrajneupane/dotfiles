# TODO: make floating windows more convinient to use with keyboard and touchpad
# TODO: i want toggleable borders around window. i mostly don't need them but sometimes i loose my mind
# TODO: may be i'm understimating key chord, how about S+Space b for browser S+Space d for discord and so on?
# TODO: uniform spacing between widgets
# TODO: May be i also want to change the bar bosition whenever i want
# TODO: How about reopening recently closed window?
# TODO: May be i want a weather widget
# TODO: I want a mail widget too. i'm missing so many mails

import subprocess
from pathlib import Path

from libqtile import bar, hook, layout, qtile, widget
from libqtile.backend import base
from libqtile.config import Click, Drag, DropDown, Group, Key, Match, ScratchPad, Screen
from libqtile.core.manager import Qtile
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# from libqtile.log_utils import logger

mod = "mod4"  # SUPER key
alt = 'mod1'
ctrl = 'control'
shift = 'shift'

terminal = guess_terminal()
home = Path('~').expanduser()
screenshot = "~/Pictures/Screenshots/{}_$(date +%F-%H-%M-%S-%N).png"
rofi_theme = "~/.config/rofi/launchers/type-1/style-5.rasi"
# sticky_windows = []


@hook.subscribe.startup_once
def autostart():
    subprocess.run(Path(__file__).parent / "autostart.sh")


# @lazy.function
# def toggle_sticky(qtile: Qtile) -> None:
#     window = qtile.current_screen.group.current_window
#     if window in sticky_windows:
#         sticky_windows.remove(window)
#     else:
#         sticky_windows.append(window)
@lazy.window.function
def resize_floating_window(window, width: int = 0, height: int = 0):
    window.set_size_floating(window.width + width, window.height + height)

@lazy.window.function
def move_floating_window(window, x: int = 0, y: int = 0):
    window.set_position_floating(window.float_x + x, window.float_y + y)

# TODO: while swithcing group put focus on windows other than sticky
# @hook.subscribe.setgroup
# def move_sticky_windows():
#     for window in sticky_windows:
#         window.togroup()

    # lazy.group.focus_back()
    # lazy.group.next_window()

@lazy.function
def toggle_minimize_all(qtile):
    """hide/show all the windows in a group"""
    for window in qtile.current_group.windows:
        if hasattr(window, "toggle_minimize"):
            window.toggle_minimize()


@hook.subscribe.client_focus
def win_focus(client):
    # if client in sticky_windows:
    #     lazy.group.next_window()

    # Keep Static windows on top
    for window in qtile.windows_map.values():
        if isinstance(window, base.Static):
            window.bring_to_front()

# @hook.subscribe.client_killed
# def remove_sticky_window(client):
#     if client in sticky_windows:
#         sticky_windows.remove(client)


@hook.subscribe.client_new
def client_new(client):
    match client.window.get_wm_class():
        case ["discord" | "protonvpn", *_]:
            client.togroup("5")
            return
        case ["qpwgraph" | "pavucontrol", *_]:
            client.togroup("4")
            return
        case ["libreoffice", *_]:
            client.togroup("3")
            return
        case _:
            if client.name in {"Picture in picture", "Picture-in-picture"}:
                # sticky_windows.append(client)
                client.resize_floating(10, 15)
                client.static()


@lazy.function
def float_to_front(qtile: Qtile) -> None:
    """Bring floating windows in current group to front"""
    group = qtile.current_screen.group
    for window in group.windows:
        if window.floating:
            window.bring_to_front()


# I rather want to generate the keybind help on the fly
# to make the help list dynamic
def keybinds() -> str:
    """Generate qtile keybinds"""
    key_desc = ""
    for key in keys:
        keybind = ""
        for mod in key.modifiers:
            if mod == "mod4":
                keybind += " + "
            elif mod == "mod1":
                keybind += "Alt + "
            else:
                keybind += mod.capitalize() + " + "

        keybind += key.key
        key_desc += f"{keybind:<30} {key.desc.capitalize()}\n"
        help = key_desc.split('\n')
        help.sort()

    return '\n'.join(help[1:])


keys = [
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
    Key(
        [mod, "control"],
        "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window down"
    ),
    Key(
        [mod, "control"],
        "k",
        lazy.layout.grow_up(),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window up"
    ),
    Key([mod, "shift", "control"], "h", lazy.layout.swap_column_left().when(layout=["columns"]), desc="Swap column left"),
    Key([mod, "shift", "control"], "l", lazy.layout.swap_column_right().when(layout=["columns"]), desc="Swap column right"),

    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "u", lazy.next_urgent(), desc="Focus next window with urgent hint"),
    Key([mod], "o", lazy.window.up_opacity(), desc="Inscrease the window opacity"),
    Key([mod, "control"], "o", lazy.window.down_opacity(), desc="Decrease the window opacity"),

    # test resize and move floating window
    Key([mod, ctrl], "comma", resize_floating_window(width = 5, height = 5), desc="Increase the floating window"),
    Key([mod, ctrl], "period", resize_floating_window(width = -5, height = -5), desc="Decrease the floating window"),
    Key([mod, alt], "w", move_floating_window(y=-10), desc="Resize floating window"),
    Key([mod, alt], "a", move_floating_window(x=-10), desc="Resize floating window"),
    Key([mod, alt], "s", move_floating_window(y=10), desc="Resize floating window"),
    Key([mod, alt], "d", move_floating_window(x=10), desc="Resize floating window"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),

    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Toggle previous layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="shutdown qtile"),
    Key([mod], "m", lazy.window.toggle_maximize(), desc="toggle minimize"),
    Key([mod, "shift"], "m", lazy.window.toggle_minimize(), desc="toggle maximize"),
    Key([mod, "control"], "m", toggle_minimize_all(), desc="toggle maximize"),
    Key([mod], "f", lazy.window.toggle_floating(), desc="toggle floating"),
    Key([mod, "shift"], "f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
    Key([mod, "control"], "f", float_to_front(), desc="Bring floating windows to front"),
    Key(["mod1"], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
    # Key([mod, "shift"], "s", toggle_sticky(), desc="Toggle state of sticky for current window"),
    Key([mod, "control"], "s", lazy.window.static(), desc="Make window static"),

    # Launch applications
    Key([mod], "Return", lazy.spawn(f"prime-run {terminal}"), desc="Launch terminal"),
    Key([mod, "mod1"], "Return", lazy.spawn(guess_terminal("wezterm")), desc="Launch wezterm"),
    Key([mod], "e", lazy.spawn("nautilus"), desc="Launch nautilus"),
    Key([mod, "control"], "t", lazy.layout.rotate(), lazy.layout.flip(), desc="test"),
    Key([mod], "b", lazy.hide_show_bar(), desc="Toggle qtile bar"),

    # Launch rofi widgets
    Key([mod], "s",
        lazy.spawn(str(home) + "/.config/rofi/launchers/type-1/launcher.sh"),
        desc="Launch rofi application launcher",
    ),
    Key(["mod1"], "F4", lazy.spawn(str(home) + "/.config/rofi/scripts/powermenu_t1"), desc="Launch rofi powermenu"),
    Key([mod], "period", lazy.spawn(f"rofi  -modi emoji -theme {rofi_theme} -show emoji"), desc="Launch rofi emoji"),
    Key([mod], "v",
        lazy.spawn(f"rofi -modi 'paste:~/.local/bin/greenclip' -theme {rofi_theme} -show paste"),
        desc="Launch greenclip",
    ),
    Key([mod, "mod1"], "v",
        lazy.spawn("pkill greenclip && greenclip clear && greenclip daemon &", shell=True),
        desc="Clear clipboard history",
    ),
    Key([mod, "shift"], "i", lazy.layout.increase_ratio(), desc="increase ratio"),
    Key([mod], "XF86AudioRaiseVolume", lazy.spawn("vol pulsemic up"), desc="Increase mic volume"),
    Key([mod], "XF86AudioLowerVolume", lazy.spawn("vol pulsemic down"), desc="Decrease mic volume"),

    # INFO: for future reference, what if i become a  music fanatic?
    # Key([], "XF86AudioNext", lazy.spawn("mpc next")),
    # Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),
    # Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
    # Key([], "XF86AudioStop", lazy.spawn("mpc stop")),

    Key([mod], "c", lazy.spawn("gsimplecal"), desc="launch gsimplecal"),
    Key([mod], "z", lazy.spawn("betterlockscreen -l & systemctl suspend -i", shell=True), desc="Suspend and lock"),

    # Screenshot
    Key([mod], "Print",
        lazy.spawn(f"maim --hidecursor { screenshot.format('screen') }", shell=True),
        desc="Capure full screen",
    ),
    Key([mod, "shift"], "Print",
        lazy.spawn(f"maim --select { screenshot.format('area') }", shell=True),
        desc="Capture selected area",
    ),
    Key([mod, "control"], "Print",
        lazy.spawn(
            f"maim --hidecursor --window $(xdotool getactivewindow) { screenshot.format('window') }", shell=True
        ),
        desc="Capture active window",
    ),
]

groups = [Group(i, label=i) for i in "12345"]
groups.append(
    ScratchPad(
        "9",
        [
            DropDown(
                "term",
                f"{terminal} --class=dropdown -e tmux new -As Dropdown",
                opacity=1,
                height=0.6,
                on_focus_lost_hide=False,
            ),
            DropDown(
                "qshell",
                f"{terminal} --class=qshell -e qtile shell",
                y=0.4,
                opacity=1,
                height=0.6,
                on_focus_lost_hide=False,
            ),
            # FIX: make it appear like term
            # INFO: there is `match` key to identify spawned window and move it to scratchpad instead of relying on windows PID
            DropDown(
                "chatgpt",
                "brave --app=https://chat.openai.com",
                x = 0.3,
                y = 0.1,
                width = 0.40,
                height=0.6,
                opacity=1,
                on_focus_lost_hide=False,
            ),
        ],
        single=True,
    )
)

for i in groups:
    keys.extend(
        [
            Key([mod], i.name, lazy.group[i.name].toscreen(toggle=True), desc=f"Switch to group { i.name }"),
            Key([mod, "shift"], i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            Key([mod, "control"], i.name, lazy.window.togroup(i.name), desc=f"move focused window to group {i.name}"),
        ]
    )


keys.extend(
    [
        Key([mod, "shift"], "d", lazy.group["9"].dropdown_toggle("term"), desc="toggle dropdown terminal"),
        Key([mod, "control"], "d", lazy.group["9"].dropdown_toggle("qshell"), desc="toggle qtile shell"),
        Key([mod, "shift"], "c", lazy.group["9"].dropdown_toggle("chatgpt"), desc="toggle chatgpt"),
        Key([mod], "slash",
            lazy.spawn(
                f"printf '{keybinds()}' | rofi -theme-str 'window {{width: 780px;}}' -dmenu -theme {rofi_theme}",
                shell=True,
            ),
            desc="Print qtile bindings",
        ),
    ]
)

colors = [
    ["#24283b", "#24283b"],  # 0 background
    ["#d8dee9", "#d8dee9"],  # 1 foreground
    ["#414868", "#414868"],  # 2 background lighter
    ["#bf616a", "#bf616a"],  # 3 red
    ["#419F70", "#419F70"],  # 4 green
    ["#ebcb8b", "#ebcb8b"],  # 5 yellow
    ["#81a1c1", "#81a1c1"],  # 6 blue
    ["#b48ead", "#b48ead"],  # 7 magenta
    ["#88c0d0", "#88c0d0"],  # 8 cyan
    ["#e5e9f0", "#e5e9f0"],  # 9 white
    ["#4c566a", "#4c566a"],  # 10 grey
    ["#d08770", "#d08770"],  # 11 orange
    ["#8fbcbb", "#8fbcbb"],  # 12 super cyan
    ["#5e81ac", "#5e81ac"],  # 13 super blue
    ["#242831", "#242831"],  # 14 super dark background
    ["#7dc4e4", "#7dc4e4"],  # 15 sapphire
    ["#363a4f", "#363a4f"],  # 16 surface0
    ["#24273a", "#24273a"],  # 17 base
    ["#008080", "#008080"],  # 18 teal
    ["#CAA9E0", "#CAA9E0"],  # 19 idk
]

layout_theme = {
    "border_width": 1,
    "border_focus": colors[14],
    "border_normal": colors[17],
    "font": "FiraCode Nerd Font",
    "grow_amount": 2,
}

layouts = [
    layout.Columns(
        **layout_theme,
        border_on_single=False,
        fair=False,
        insert_position=0,
        margin_on_single=None,
        num_columns=2,
        split=True,
        wrap_focus_columns=True,
        wrap_focus_rows=True,
        wrap_focus_stacks=True,
    ),
    layout.Max(
        **layout_theme,
    ),
    layout.MonadTall(**layout_theme),
    layout.Floating(**layout_theme),
    # layout.Bsp(**layout_theme, fair=True),
    # layout.Tile(**layout_theme),
    # layout.Spiral(**layout_theme),
    # layout.Stack(**layout_theme, num_stacks=2),
    # layout.Matrix(**layout_theme),
    # layout.MonadWide(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.TreeTab(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Zoomy(**layout_theme),
]

widget_defaults = dict(
    font="FiraCode Bold",
    fontsize=25,
    padding=5,
    background=colors[0],
    fullscreen_border_width=0,
    max_border_width=0,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper="~/Pictures/wallpaper/wallpaper.png",
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.GroupBox(
                    active=colors[4],
                    block_highlight_text_color=colors[3],
                    borderwidth=3,
                    disable_drag=True,
                    fontsize = 18,
                    highlight_method = "line",
                    highlight_color = colors[0],
                    inactive=colors[18],
                    this_current_screen_border=colors[3],
                    rounded=True,
                    urgent_alert_method="block",
                    padding=1,
                    hide_unused=True,
                ),
                widget.Sep(foreground=colors[2]),
                widget.TaskList(
                    active=colors[4],
                    borderwidth=0,
                    foreground=colors[12],
                    fontsize=12,
                    padding=3,
                    parse_text=lambda _: "",
                    spacing=0,
                    txt_floating="󰄶",
                    txt_maximized="",
                    txt_minimized="󰖰",
                ),
                widget.Spacer(length=bar.STRETCH),
                widget.Systray(icon_size=24),
                widget.Sep(
                    foreground=colors[2],
                    padding=15
                ),
                widget.PulseVolume(
                    emoji=True,
                    emoji_list=["󰝟", "󰕿", "󰖀", "󰕾"],
                    foreground=colors[15],
                    limit_max_volume=True,
                    mouse_callbacks={
                        "Button1": lazy.spawn("pavucontrol"),
                        "Button3": lazy.spawn("qpwgraph"),
                    },
                    volume_app="pavucontrol"
                ),
                widget.PulseVolume(
                    foreground=colors[6],
                    fontsize=14,
                    limit_max_volume=True,
                    mouse_callbacks={
                        # "Button1": lazy.spawn("pavucontrol"),
                        "Button3": lazy.spawn("qpwgraph"),
                    },
                    volume_app="pavucontrol",
                ),
                widget.TextBox(text="󰻠", foreground=colors[8]),
                # INFO: best way to spawn htop is using it with terminal like "alacritty -e htop"
                # but i want the mouse callback to open htop on scratchpad idk how to do that
                widget.CPU(
                    format="{freq_current}GHz {load_percent}%",
                    foreground=colors[8],
                    fontsize=14,
                    mouse_callbacks={
                        "Button1": lazy.spawn("htop"),
                    },
                    scroll = True,
                    scroll_fixed_width = True,
                    width = 97,
                ),
                widget.TextBox(
                    text="󰍛",
                    foreground=colors[11],
                    mouse_callbacks={
                        "Button1": lambda: qtile.spawn("htop"),
                    },
                ),
                widget.Memory(
                    format="{MemUsed: .0f}{mm}",
                    foreground=colors[11],
                    fontsize=14,
                    mouse_callbacks={
                        "Button1": lambda: qtile.spawn("htop"),
                    }
                ),
                widget.WidgetBox(
                    foreground=colors[12],
                    text_closed="",  # 
                    text_open=" ",  # 
                    padding=0,
                    widgets=[
                        widget.TextBox(text="󰻠", foreground=colors[8]),
                        widget.ThermalZone(
                            zone="/sys/class/thermal/thermal_zone1/temp",
                            foreground=colors[4],
                            fontsize=14,
                        ),
                        widget.TextBox(text="", foreground=colors[8]),
                        widget.ThermalSensor(
                            fontsize=14,
                            foreground=colors[4],
                        ),
                        widget.TextBox(text="󰏈", foreground=colors[6]),
                        widget.NvidiaSensors(
                            threshold=60,
                            fontsize=14,
                            foreground=colors[4],
                        ),
                    ],
                ),
                widget.Battery(
                    full_char = "󰁹",
                    empty_char  = "󰂃",
                    discharge_char = "󰂀",
                    charge_char = "󰂄",
                    unknown_char="",
                    fontsize=18,
                    foreground=colors[3],
                    format="{char}",
                    low_percentage=0.3,
                    mouse_callbacks={
                        "Button1": lazy.spawn(".config/rofi/applets/bin/battery.sh"),
                        "Button3": lazy.spawn(".config/rofi/scripts/powermenu_t1"),
                    },
                    notify_below=30,
                    update_interval=1,
                    show_short_text=False,
                    default_text="",
                ),
                widget.Battery(
                    fontsize=14,
                    foreground=colors[3],
                    format="{percent:2.0%}",
                    low_percentage=0.3,
                    mouse_callbacks={
                        "Button1": lazy.spawn(".config/rofi/applets/bin/battery.sh"),
                        "Button3": lazy.spawn(".config/rofi/scripts/powermenu_t1"),
                    },
                    notify_below=30,
                    update_interval=2,
                    show_short_text=True,
                    default_text="",
                ),
                widget.TextBox(
                    text=" ",
                    foreground=colors[15],
                    fontsize=18,
                    padding=2,
                    mouse_callbacks={"Button1": lazy.spawn("networkmanager_dmenu")},
                ),
                widget.Net(
                    interface=None,  # None to display all active NICs combined
                    foreground=colors[15],
                    format="{down:.2f}{down_suffix:<2} {up:.2f}{up_suffix:<2}",
                    fontsize=14,
                    max_chars=20,
                    scroll=True,
                    scroll_fixed_width = True,
                    width=120,
                    mouse_callbacks={"Button1": lazy.spawn("networkmanager_dmenu")},
                ),
                widget.Clock(
                    fontsize=14,
                    foreground=colors[19],
                    format="%b %d %H:%M",
                    mouse_callbacks={"Button1": lazy.spawn("gsimplecal")},
                ),
                widget.CurrentLayoutIcon(
                    padding=2,
                    scale=0.55,
                ),
                widget.WindowCount(
                    fontsize=14,
                    foreground=colors[18],
                    max_chars=2,
                    # TODO: kinda ugly refine it or remove it
                    mouse_callbacks={
                        "Button1": lazy.spawn(
                            "rofi -show windowcd -theme-str 'window {location: northeast; anchor: northeast;}' -theme ~/.config/rofi/launchers/type-1/style-3.rasi",
                            shell=True
                        )
                    }
                ),
            ],
            30,
            margin=[10, 0, 0, 0],
            background=colors[17],
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod, "mod1"], "Button1", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    # Drag([mod, "shift"], "Button1", lazy.screen.group_slide(), start=lazy.screen.start_group_slide(scale=2.5),),
    Click([mod], "Button1", lazy.window.bring_to_front()),
]

floating_layout = layout.Floating(
    border_focus=colors[17],
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="nm-connection-editor"),  # ssh-askpass
        Match(wm_class="pavucontrol"),  # pulseaudio volume control
        Match(wm_class="protonvpn"),  # VPN
        Match(wm_class="scrcpy"),  # scrcpy
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        # INFO: following two line are actually not necessary, they are handled by default
        Match(func=lambda c: bool(c.is_transient_for())),  # child of another window
        Match(func=lambda c: c.window.get_wm_type() == 'dialog'),
    ],
)

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = "floating_only"
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

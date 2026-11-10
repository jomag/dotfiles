-- This is a Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/configuring/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki.

-- You can split this configuration into multiple files.
-- Create your files separately and require them from this file, for example:
-- require("myColors")


-------------------
--- MONITORS ------
-------------------

-- See https://wiki.hypr.land/0.57.0/configuring/core/monitors/
-- List monitors: hyprctl monitors all

-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })

-- Config, home office
hl.monitor({
    output = "eDP-1",
    mode = "preferred",
    position = "0x0",
    scale = 1,
})

-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "3840x0", scale = 1 })

hl.monitor({
    output = "DP-6",
    mode = "preferred",
    position = "-3840x-1000",
    scale = 1,
})
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "0x0", scale = 1 })
-- hl.monitor({ output = "DP-3", mode = "preferred", position = "0x0", scale = 1 })
-- hl.monitor({ output = "DP-5", mode = "preferred", position = "0x0", scale = 1 })
-- hl.env("MON_PRIMARY", "model:LG ULTRAFINE")
-- hl.env("MON_SECONDARY", "model:AU Optronics")

-- DisplayLink config at client office
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "-1920x0", scale = 1 })
-- hl.monitor({ output = "DVI-I-2", mode = "preferred", position = "0x0", scale = 1 })
-- hl.monitor({ output = "DVI-I-1", mode = "preferred", position = "2561x0", scale = 1, transform = 0 })
-- hl.env("MON_PRIMARY", "model:LG ULTRAFINE")
-- hl.env("MON_SECONDARY", "eDP-1")


---------------------
--- MY PROGRAMS -----
---------------------

local terminal = "ghostty"
local fileManager = "nautilus --new-window"
local browser = "firefox --new-window"
local menu = "rofi -show drun"
local windowmgr = "rofi -show window"
local music = "spotify-launcher"
local passwordmgr = "1password"
local messenger = "signal-desktop"
local webapp = browser .. " --app"
local calc = "rofi -show calc -modi calc -no-show-match -no-sort"


-----------------
--- AUTOSTART ---
-----------------

-- exec-once == run once when Hyprland starts
hl.on("hyprland.start", function()
    hl.exec_cmd("update-hypridle-power.sh")
    hl.exec_cmd("mako & fcitx5")
    -- hl.exec_cmd("awww-daemon")
    hl.exec_cmd("~/bin/battery-warning.py")
    hl.exec_cmd("waybar")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("wallpaper")
end)


-----------------------------
--- ENVIRONMENT VARIABLES ----
-----------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Force all apps to use Wayland (from Omarchy)
hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")


------------------
--- PERMISSIONS ---
------------------

-- See https://wiki.hypr.land/configuring/core/advanced-configuration/permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({ ecosystem = { enforce_permissions = true } })

-- hl.permission({ binary = "/usr/(bin|local/bin)/grim", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })


---------------------------
--- LOOK AND FEEL ---------
---------------------------

-- https://wiki.hypr.land/0.57.0/configuring/core/ (general, decoration)

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        -- col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,
        -- Please see https://wiki.hypr.land/0.57.0/extra/tearing before you turn this on
        allow_tearing = false,
        layout = "dwindle",
    },
})

hl.config({
    decoration = {
        rounding = 0,
        rounding_power = 2,
        -- Change transparency of focused and unfocused windows
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 2,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
})

-- https://wiki.hypr.land/0.57.0/configuring/core/animations/
-- conf: enabled = no, please :)
-- The Lua config has no single master switch: disabling the `global` leaf
-- disables everything, since every animation leaf inherits from it.
hl.animation({ leaf = "global", enabled = false })

-- Default animations (curves)
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

-- The per-leaf lines below would re-enable animations (last definition of a
-- leaf wins), so they stay commented out to preserve "no, please :)" behavior.
-- hl.animation({ leaf = "global",     enabled = true, speed = 1,    bezier = "default" })
-- hl.animation({ leaf = "border",     enabled = true, speed = 5.39, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "windows",    enabled = true, speed = 4.79, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "windowsIn",  enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
-- hl.animation({ leaf = "fadeIn",     enabled = true, speed = 1.73, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeOut",    enabled = true, speed = 1.46, bezier = "almostLinear" })
-- hl.animation({ leaf = "fade",       enabled = true, speed = 3.03, bezier = "quick" })
-- hl.animation({ leaf = "layers",     enabled = true, speed = 3.81, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "layersIn",   enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
-- hl.animation({ leaf = "layersOut",  enabled = true, speed = 1.5,  bezier = "linear", style = "fade" })
-- hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
-- hl.animation({ leaf = "workspaces",  enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

-- "Smart gaps" / "No gaps when only"
-- w[tv1] = workspaces with exactly 1 tiled visible window; f[1] = maximized workspace
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

hl.window_rule({
    name = "no-border-for-single-window-workspaces",
    match = {
        float = false,
        workspace = "w[tv1]",
    },
    border_size = 0,
    rounding = 0,
})

---------------------------
--- LAYOUTS ---------------
---------------------------

-- See https://wiki.hypr.land/0.57.0/configuring/layouts/dwindle-layout/ for more
hl.config({
    dwindle = {
        -- pseudotile is no longer available. not sure what the alternative is...
        -- pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below

        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/0.57.0/configuring/layouts/master-layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- https://wiki.hypr.land/0.57.0/configuring/core/config-options/#misc
hl.config({
    misc = {
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})

---------------------------
--- INPUT -----------------
---------------------------

-- https://wiki.hypr.land/0.57.0/configuring/core/config-options/#input
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_rules = "",
        kb_options = "custom:super_sv,lv3:ralt_switch,caps:escape",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- FIXME: this option seems to no longer be supported?
-- (confirmed: `workspace_swipe` is gone in 0.57.0; only workspace_swipe_* tuning knobs remain)
-- hl.config({ gestures = { workspace_swipe = false } })

-- Example per-device config
-- See https://wiki.hypr.land/0.57.0/configuring/core/devices for more
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------------
--- KEYBINDINGS -----------
---------------------------

-- See https://wiki.hypr.land/0.57.0/configuring/core/binds/
-- (mainMod = "SUPER" is defined at the top of this file)
mainMod = "SUPER"

-- Bindings to start default apps
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(music))

hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.kill())

-- Annoying! Kills the whole session!
-- hl.bind(mainMod .. " + M", hl.dsp.exit())

-- Toggle visibility of Waybar
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("pkill -USR1 waybar"))

hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + tab", hl.dsp.exec_cmd(windowmgr))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd(calc .. " | wl-copy"))
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"))

-- Requires playerctl
-- hl.bind("XF86Wakeup + d", hl.dsp.exec_cmd("playerctl next"), { locked = true })
-- hl.bind("XF86Wakeup + space", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86Wakeup + a", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Swedish characters (requires wtype, pacman -S wtype)
-- hl.bind("SUPER + bracketleft", hl.dsp.exec_cmd("wtype å"))
-- hl.bind("SUPER + SHIFT + bracketleft", hl.dsp.exec_cmd("wtype Å"))
-- hl.bind("SUPER + apostrophe", hl.dsp.exec_cmd("wtype ä"))
-- hl.bind("SUPER + SHIFT + apostrophe", hl.dsp.exec_cmd("wtype Ä"))
-- hl.bind("SUPER + semicolon", hl.dsp.exec_cmd("wtype ö"))
-- hl.bind("SUPER + SHIFT + semicolon", hl.dsp.exec_cmd("wtype Ö"))

-- Cycle through all applications
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())

-- Fullscreen
hl.bind("SUPER + RETURN", hl.dsp.window.fullscreen())


---------------------------
--- WORKSPACES ------------
---------------------------

-- See https://wiki.hypr.land/0.57.0/configuring/core/rules/workspace-rules/
-- MON_PRIMARY / MON_SECONDARY are commented out in the MONITORS section, so
-- os.getenv() returns nil and the monitor key is omitted — same as $MON_PRIMARY
-- expanding to empty in the conf.
hl.workspace_rule({
    workspace = "1",
    monitor = os.getenv("MON_PRIMARY"),
    persistent = true,
    default_name = "term",
    default = true,
})
hl.workspace_rule({
    workspace = "2",
    monitor = os.getenv("MON_PRIMARY"),
    persistent = true,
    default_name = "web",
})
hl.workspace_rule({
    workspace = "3",
    monitor = os.getenv("MON_PRIMARY"),
    persistent = true,
    default_name = "obisidan",
})
hl.workspace_rule({
    workspace = "4",
    monitor = os.getenv("MON_PRIMARY"),
    persistent = true,
    default_name = "chat",
})
hl.workspace_rule({
    workspace = "5",
    monitor = os.getenv("MON_PRIMARY"),
    persistent = true,
    default_name = "music",
})
hl.workspace_rule({
    workspace = "6",
    monitor = os.getenv("MON_PRIMARY"),
    persistent = true,
})
hl.workspace_rule({
    workspace = "10",
    monitor = os.getenv("MON_SECONDARY"),
    persistent = true,
    default = true,
})


---------------------------
--- WINDOWS AND WORKSPACES
---------------------------

-- See https://wiki.hypr.land/0.57.0/configuring/core/rules/window-rules/ for more
-- See https://wiki.hypr.land/0.57.0/configuring/core/rules/workspace-rules/ for workspace rules

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name = "ignore-maximize-requests",
    suppress_event = "maximize",
    match = {
        class = ".*",
    },
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name = "fix-dragging-issues",
    no_focus = true,
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
})

-- Gnome Calculator should be floating
hl.window_rule({
    name = "floating-gnome-calculator",
    float = true,
    match = {
        class = "org.gnome.Calculator",
    },
})


---------------------------
--- SET DARK MODE ---------
---------------------------

-- Copied/inspired by this Reddit post:
-- https://www.reddit.com/r/hyprland/comments/1h4abmt/how_do_i_apply_dark_theme/

-- For gtk3 apps you need to install adw-gtk3 theme (sudo pacman -S adw-gtk-theme)
hl.dispatch(hl.dsp.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"'))
hl.dispatch(hl.dsp.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"'))

-- For kde apps you need to install: sudo pacman -S qt5ct qt6ct kvantum kvantum breeze-icons
-- you will need to set dark theme for qt apps from kde more difficult thans with gnome :D:
-- hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")   -- for Qt apps # Theme

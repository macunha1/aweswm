# AwesomeWM Config

An AWESOME config: simple, minimalistic, and fast.

<p align="center">
  <img src="/../screenshots/preview.png?raw=true" height="512" />
</p>

## Install

Clone it as the AwesomeWM config directory:

```sh
git clone --recurse-submodules git@github.com:macunha1/aweswm.git \
  "${HOME}/.config/awesome"
```

Already cloned?

```sh
git submodule update --init --recursive
```

Start AwesomeWM:

```sh
awesome
```

## Runtime Assumptions

This config expects the usual AwesomeWM Lua libraries plus the vendored
submodules in [.gitmodules](./.gitmodules): `lain`, `awesome-freedesktop`,
`calendar`, `awesomewm-memory-notifier`, and `awesomewm-media-player-widget`.

It also shells out to tools I use locally:

- `alacritty`
- `chromium` (or `$BROWSER`)
- `emacs`, `vim` (or `$EDITOR`)
- `pcmanfm`
- `rofi`
- `xfce4-screenshooter`
- `xbacklight`
- `amixer`, `alsamixer`
- `wpexec`
- `~/.local/bin/screenlock.sh`

MPRIS media controls need `lua-dbus_proxy`.

## Change The Basics

The main defaults are near the top of [rc.lua](./rc.lua):

```lua
local theme        = "yin-yang"
local terminal     = "alacritty"
local gui_editor   = "emacs"
local browser      = os.getenv("BROWSER") or "chromium"
local media_player = "spotify"
```

Available themes:

- `yin-yang`
- `retrowave`

Theme files live in [themes](./themes). Icons live in [icons/simplicity](./icons/simplicity).

## Useful Bindings

- `Mod4 + Return`: terminal
- `Mod4 + e`: file manager
- `Mod4 + w`: Awesome menu
- `Mod4 + Home`: lock screen
- `Mod4 + h/j/k/l`: focus by direction
- `Mod4 + Space`: next layout
- `Mod4 + Shift + Space`: previous layout
- `Mod4 + Shift + n/r/d`: add, rename, delete tag
- `Mod4 + z`: dropdown terminal
- `Print`: screenshot
- `XF86Audio*`: media and volume controls

The full keymap is in [rc.lua](./rc.lua).

<h1 align="center">Awesome WM rc.lua</h1>

Awesome configuration for Awesome WM. User interface might not be so shiny and
beautiful as the [polybar](https://github.com/polybar/polybar) is. However it
works nice and is:

  + properly polished with async calls, using the best practices of Lua coding
    and Awesome awful methods;
  + UI was built to be simple, distraction-free and minimalistic;

Additionally, this repository contains a fully modularized AwesomeWM + Lua
setup, using "plugins" through Git submodules. As most of my configurations, it
aims for a clean, tiny and self-contained implementation
[[1]](https://github.com/macunha1/definitely-not-vimrc)
[[2]](https://github.com/macunha1/configuration.nix)

## Dependencies

AwesomeWM Media Player Widget used in the wibar depends on [Lua D-Bus
Proxy](https://github.com/stefano-m/lua-dbus_proxy) to handle connections with
D-Bus interface. Further instructions [available here](https://github.com/macunha1/awesomewm-media-player-widget#installation)

## Installation

Once the dependencies are installed, you just simply need to clone this
repository and its submodules

``` sh
git clone https://github.com/macunha1/awesomewm-configuration \
    ~/.config/awesome

cd ~/.config/awesome
git submodule sync --recursive .
```

Then you're good to go (:

``` sh
awesome
```

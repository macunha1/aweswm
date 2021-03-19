<h1 align="center">Awesome WM rc.lua</h1>

_An Aweswm configuration_ for the AwesomeWM!

Fully async setup using the best-practices from Awesome documentation about
awful implementation. Containing a fully modularized setup (through git
submodules) as an "package manager" implementation, to easy support updates.

<p align="center">
  <span><img src="/../screenshots/preview.png?raw=true" height="512" /></span>
</p>

User interface aimed for a tiny, minimalistic and performatic setup. Using pure Lua
code, together with AwesomeWM libraries:

  + properly polished with async calls, using the best practices of Lua coding
    and Awesome awful methods;
  + UI was built to be simple, distraction-free and minimalistic;

## Dependencies

AwesomeWM Media Player Widget used in the wibar depends on [Lua D-Bus
Proxy](https://github.com/stefano-m/lua-dbus_proxy) to handle connections with
D-Bus interface. Further instructions [available here](https://github.com/macunha1/awesomewm-media-player-widget#installation)

## Installation

Once the dependencies are installed, you just simply need to clone this
repository and its submodules

``` sh
git clone git@github.com:macunha1/aweswm.git \
  --recurse-submodules \
  "${HOME}/.config/awesome"
```

Further configurations are available [[here]](https://github.com/macunha1/configuration.nix)

Then you're good to go (:

``` sh
awesome
```

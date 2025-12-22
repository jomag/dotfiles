
MacOS
-----

This directory contains .keylayout's created using Ukelele.

UsForSwedes.keylayout is my preferred layout, which is a regular
US keyboard but with Swedish characters åäö where they are found
on a Swedish keyboard, in combination with Option or Command key.

The layouts are installed by copying them to `~/Library/Keyboard Layouts/`
and them select them as MacOS keyboard input source. I've found that it
requires a restart of the computer (not just signing out) for it to be
found. The layout will be found in the "Other" category.

It may not be possible to remove all previous layouts from the list
of input sources. Here's a discussion about how it can be done:

https://superuser.com/questions/712306

Windows
-------

The equivalent configuration for Windows is in the AutoHotKey script
UsForSwedes.ahk. Install AutoHotKey and double click the script file.

Linux
-----

I tried using wtype and keyd, but neither works well, and it's inconsistent,
both between identical computers and depending on app.

Instead, I've added some keyboard layout options.

Some tips:

When debugging layout issues, run this command to check for errors in the layout:

```
xbkcli compile-keymap --rules evdev --model pc105 --layout us --options custom:super_sv
```

To find what key id's to use (ie `<AC11>`), use `xkbcli` (Wayland):

```
xkbcli interactive-wayland
```

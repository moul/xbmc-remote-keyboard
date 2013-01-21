xbmc-remote-keyboard
====================

<img width="600px" src="https://raw.github.com/moul/xbmc-remote-keyboard/screenshots/images/verbose.png" /> 

Send local keyboard presses to a remote XBMC through JSON RPC api

This program needs a terminal with ncurses support (works on linux and Mac OS X)

It is like the Android and IOS remote controler apps but in a shell with a real keyboard

Usage
-----

Usage

```bash
$ xbmc-remote-keyboard -h

  Usage: xbmc-remote-keyboard [options] hostname/ip[:port]

  Options:

    -h, --help                 output usage information
    -V, --version              output the version number
    -v, --verbose              verbose
    -d, --debug                debug
    -c, --config <file>        config file
    -u, --username <username>  username
    -P, --password <password>  password
    -s, --host <host>          hostname/ip
    -w, --save                 save config file
    -p, --port <port>          port
    -S, --silent               do not send message
    -a, --agent <agent>        user agent

```

Connecting to localhost

```bash
$ xbmc-remote-keyboard 127.0.0.1
```

Connect to localhost and port 9090

```bash
$ xbmc-remote-keyboard 127.0.0.1:9090
```

You can also save your settings for later

```bash
$ xbmc-remote-keyboard --save 127.0.0.1:9090
```

Then, you do not need arguments anymore

```bash
$ xbmc-remote-keyboard
```

Install
-------

```bash
[sudo] npm install -g xbmc-remote-keyboard
```

Debug
-----

By passing `-d` option, you can see the JSON-RPC api calls

```bash
$ xbmc-remote-keyboard -d 127.0.0.1
```

<img width="600px" src="https://raw.github.com/moul/xbmc-remote-keyboard/screenshots/images/debug.png" />

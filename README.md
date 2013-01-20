xbmc-remote-keyboard
====================

Send local keyboard presses to a remote XBMC through JSON RPC api

Usage
-----

Usage

```bash
$ xbmc-remote-keyboard 

  Usage: xbmc-remote-keyboard [options] hostname/ip[:port]

  Options:

    -h, --help           output usage information
    -V, --version        output the version number
    -v, --verbose        verbose
    -d, --debug          debug
    -s, --silent         do not send message on connection
    -a, --agent <agent>  user agent
```

Connecting to localhost

```bash
$ xbmc-remote-keyboard 127.0.0.1
```

Connect to localhost and port 9090

```bash
$ xbmc-remote-keyboard 127.0.0.1:9090
```

Install
-------

```bash
[sudo npm install -g xbmc-remote-keyboard
```

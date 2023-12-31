# Purpose

IPC via stream-based UNIX domain sockets.

# Build

```sh
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ../
make
sudo make install
```

# Usage

You can test running daemon from command line:

`./bin/daemon`

When you run `./bin/daemon` with the parameter `--daemon` or `-d`, then
it will become the real UNIX daemon.

## Start daemon by using systemd
```sh
systemctl start simple-daemon
systemctl status simple-daemon
systemctl reload simple-daemon
systemctl stop simple-daemon
```

# Remove files

```
sudo xargs rm < install_manifest.txt
```
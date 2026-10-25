# scoop-bucket

Personal Scoop bucket for Windows tools.

## Install

```powershell
scoop bucket add asonas https://github.com/asonas/scoop-bucket
scoop install asonas/cwrsync
```

## Update

```powershell
scoop update
scoop update cwrsync
```

The GitHub Actions workflow checks the official cwRsync website daily and can also
be run manually. It updates the manifest using the publisher's SHA256, installs
the package, and verifies a local file copy and bundled SSH startup before
committing the new version. It does not update installations on your computer.

Only `rsync` is added to PATH through a Scoop shim. The bundled SSH tools remain
under `scoop/apps/cwrsync/current/bin` without replacing your existing SSH command.
For example, use `-e` with that directory's `ssh.exe` when bundled SSH is needed.

The tests do not connect to a remote server. Check your usual remote transfer
after upgrading, especially when changing rsync or SSH versions.

Downloads and release information: <https://itefix.net/cwrsync/>.
Software licenses remain those of cwRsync and its bundled components.


- [Custom Actions](#custom-actions)
For example, if you have a folder containing images, you could check the above-mentioned menu item for it and click the "Thumbnail View" toolbar button. Then, that folder will always show big thumbnails of images (their size can be changed in Preferences → Display → Size of thumbnails), while other folders will have the default view mode.



### Bulk Renaming

Bulk Renaming is a method of renaming multiple files without getting a prompt dialog for each one.

To rename files in bulk, select them and press `SHIFT + F2` or click `Edit → Bulk Rename`. A dialog will show up, in which you could choose a name that is suffixed by `#`. `#` will be replaced by consecutive numbers, starting from 0 or any number you might choose in the spin-box of the Bulk Rename dialog. You could also put `#` at the start of the name or inside it.

If you confirm the dialog by pressing OK or `Enter`, the selected files will be renamed according to your chosen pattern, while their extensions, if any, will be preserved.

### Changing Folder Icons

The icon of a folder can be changed in the *File Properties* dialog. Show *File Properties* by right clicking the folder and clicking *Properties* or by selecting it and pressing `Alt + Enter/Return`. There is a button on the top left of the `General` page. If you click it, a file dialog will be opened inside your active icon theme, where you could choose a customized icon for that folder.

To remove the customized icon of a folder, open it, show the hidden files inside it and delete the hidden file named `.directory`.

You can also edit the hidden file `.directory` and put any image path in front of `Icon=`. The path can be relative to the current folder.

Icons of files cannot be changed because they show their mime types; they depend on the active icon theme.

### Emblems

The first tab of File Properties dialog has a button for adding an emblem to a file — or a selection of files — and another button for clearing it. Emblems are small icons that appear at the bottom right corner of the main icon and should be chosen from the active icon theme. They require GVFS.

Emblems are user-specific. They are not really added to files but are attributed to them by the current user. So, they are not preserved when files are copied or transferred.

GVFS allows multiple emblems for each file but the File Properties dialog only sets one because the other corners of a file's icon are preserved for other purposes (like the symlink emblem).

Emblems can be used to distinguish certain files visually, especially non-folder files, whose icons cannot be changed.

### Hiding Files/Folders without Renaming Them

A really hidden file has a name that starts with a dot. But, sometimes, you may not want to rename a file to make it hidden, e.g., when that file is used by an app. Also, folders like `lost+found` belong to root and should not be renamed.

Some file managers have a way of making files "virtually hidden". Technically, those files are not hidden but only treated as hidden by the file managers in question.

PCManFM-Qt has the above-mentioned functionality. To hide files without renaming them, create the file `.hidden` inside their parent directory and add to it the names of the files you want to hide in separate lines.

For example, you may create `~/.hidden` as:

```
Public
Templates
Certain File
```

Then, the folders `Public` and `Templates` as well as the file `Certain File` inside your home directory are treated as hidden by PCManFM-Qt and some other file managers.

*NOTE:* Editing `.hidden` does not have an immediate effect because `GLib` (which does the file management in PCManFM-Qt) uses cache. It will take effect the next time its containing folder is opened. You could also wait a few seconds and reload the folder.

### Thumbnails

PCManFM-Qt (actually, `libfm-qt`) creates thumbnails of images internally — installation of `qt-imageformats` and [`kimageformats`](https://api.kde.org/frameworks/kimageformats/html/index.html) can extend the range of its supported formats considerably — but it can also use external thumbnailers for other formats or kinds of files.

User-defined thumbnailers can be created inside the directory `~/.local/share/thumbnailers`. For each new thumbnailer to be seen, PCManFM-Qt needs to be restarted from *LXQt Session Settings* → *Desktop*.

The following examples show how to add user-defined thumbnailers for DjVu and PDF files. You can use them as a guide for creating other kinds of thumbnailers.

To have thumbnails for DjVu files, create a file like `~/.local/share/thumbnailers/djvu-djvu.thumbnailer` as,

```
[Thumbnailer Entry]
Exec=ddjvu -format=tiff -page=1 -size=%sx%s %i %o
MimeType=image/vnd.djvu+multipage;image/vnd.djvu;
```

Then restart PCManFM-Qt. Of course, you need `ddjvu`, which belongs to `djvulibre`.

For PDF files, you can install `graphicsmagick` and create `~/.local/share/thumbnailers/graphicsmagick-pdf.thumbnailer` as,

```
[Thumbnailer Entry]
Exec=gm convert -quality 100 -thumbnail %s -flatten %i[0] %o
MimeType=application/pdf;application/x-pdf;image/pdf;application/x-gzpostscript;application/postscript;application/vnd.ms-xpsdocument;
```

Again, restart PCManFM-Qt.

The file can have any name but its extension should be `.thumbnailer`. It should start with `[Thumbnailer Entry]` and have two keys, namely, `Exec` and `MimeType`.

The value of the `MimeType` key tells which file types should have thumbnails.

The value of the `Exec` key tells how thumbnails are created. It is a command-line that depends on the thumbnailing application but it always includes three elements: `%s` for the image size, `%i` for the "input" (the file whose thumbnail should be created), and `%o` for the "output" (the thumbnail itself). You need to be familiar with the thumbnailing application to know how it can create an image with a specific size out of a file. Then replace input, output and image size with `%i`, `%o` and `%s` in its command-line respectively and put it in front of `Exec=`.

In rare cases, you may want to disable a thumbnailer, which is installed as root, without removing its application. To do so, copy it from `/usr/share/thumbnailers/` (or `/usr/local/share/thumbnailers/`) to `~/.local/share/thumbnailers/`, change its `MimeType` line to something like `MimeType=application/nothing;`, and restart PCManFM-Qt.

### "Admin Mode" vs. Root Instance

PCManFM-Qt can be launched as root under X11. The menu-item that does that is `Tools → Open Tab in Root Instance`. The command in `Preferences → Advanced → Switch user command` should be something like this:

```
lxsudo dbus-run-session -- %s
```

But a root instance may not be safe for various reasons. Moreover, no root instance is possible under Wayland. If you only want to transfer files that are owned by root, you could use the admin mode instead. Its menu-item is `Tools → Open Tab in Admin Mode`. The admin mode requires GVFS.

You cannot open files in the admin mode, unless the associated applications support it. Most apps do not, especially Qt apps (however, FeatherPad can open text files in the admin mode if the user has the reading permission). But it can be useful with file transference.

Because the admin mode is provided by GVFS, PCManFM-Qt just calls it, without having control over it. For example, it has a time-out, after which, the root password will be asked again. PCManFM-Qt cannot change that.

### Trusting Executables

By default, executable files are not "trusted", which means that a prompt dialog will be shown if the user (double) clicks them. Desktop entries (files whose real names end with `.desktop`), that are not inside `~/.local/share/applications` or `/usr/share/applications`, may have a special emblem on their icons, showing that they are not trusted. The emblem depends on the icon set but, usually, it is like an exclamation mark. Other kinds of executables do not have this emblem.

You can select the option `Preferences → Behavior → Launch executable files without prompt` to remove the prompt for all executables but, by doing so, you might compromise your system because you might click a suspicious executable unintentionally.

There is a safer way of trusting executables: you could right click them and check "Trust this executable" (or "Trust selected executables" in the case of multiple selection) if you really trust them. If an executable is a desktop entry, its special emblem will disappear.

Like some other important properties, trusting executables requires GVFS. Without GVFS, the trust state will be lost in the next session.

### Profiles

PCManFM-Qt has a `--profile` option, which can be used for having different configurations when needed. For example, this command starts the desktop module with the profile `myProfile`:

```sh
pcmanfm-qt --desktop --profile=myProfile
```

Users usually do not need to set it. It is set to `lxqt` when the desktop module is started by the LXQt Session and is `default` when omitted.

When PCManFM-Qt is started with a profile `xyz`, it (creates and) uses the configuration files inside the folder `~/pcmanfm-qt/xyz/`. In this way, the application can be started with different configurations under different desktop environments. Please note that only the LXQt Session sets it automatically. If you need a specific profile for another DE, you should set it explicitly, e.g., in front of `Exec=` in a desktop entry that you may make for that DE.

### Using Desktop under Wayland

Since its version 2.0.0, PCManFM-Qt's desktop is fully functional under Wayland compositors which implement the `wl-layer-shell` protocol, e.g., KWin and `wlroots`-based compositors like LabWC, Wayfire,…

For avoiding the current problems of multi-screen desktops under Wayland, each screen is given its separate desktop with a separate items layout in version 2.1.0.

Unfortunately, Qt cannot distinguish between the desktop geometry and the *available* desktop geometry under Wayland yet. The latter is the geometry excluding the areas reserved by the window manager for panels, task bars, etc. For this reason, you may need to change margins in `Desktop Preferences → General → Spacing → Margins of work area`, such that the desktop items do not go under the reserved areas.

***

However, if you set up your Wayland desktop, your X11 desktop will also be affected, and conversely. If you switch between X11 and Wayland frequently, you might not want that. PCManFM-Qt's `--profile` option can solve this problem inside an LXQt session:

 1. Make an executable script `lxqt-desktoploader` like this, which uses another profile on Wayland:

```sh
#!/bin/sh

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    exec pcmanfm-qt --desktop --profile=lxqtwayland
else
    exec pcmanfm-qt --desktop --profile=lxqt
fi
```

 2. Put `/etc/xdg/autostart/lxqt-desktop.desktop` into the folder `~/.config/autostart/`, and change the value of its `Exec=` to the path of `lxqt-desktoploader`.
 3. Copy the folder `~/.config/pcmanfm-qt/lxqt` as `~/.config/pcmanfm-qt/lxqtwayland` to transfer your settings from X11 to Wayland.
 4. Log out and log in.

Then the X11 and Wayland settings of PCManFM-Qt will be separate from each other and will not interfere with each other.

***

Like in X11, PCManFM-Qt's destop draws the background under Wayland. But, since version 2.1.0, you can also let a Wayland wallpaper/background app draw the background of PCManFM-Qt's desktop. To do so, first set PCManFM-Qt's wallpaper to any transparent image — the simplest transparent image can be an SVG file like

```xml
<svg width="200" version="1.1" xmlns="http://www.w3.org/2000/svg" height="200" viewBox="0 0 200 200"/>

```

Then make sure that the wallpaper app starts *before* PCManFM-Qt's desktop — with a Wayland LXQt session, that will happen automatically if it is auto-started by the Wayland compositor. With this setup, PCManFM-Qt will draw desktop items, while the background will be drawn by the app.

### Custom Actions

Custom actions are explained separately. See [Custom Actions](https://github.com/lxqt/pcmanfm-qt/wiki/custom_actions).

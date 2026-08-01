# Themes, Backgrounds, and Fonts

Read this before changing themes, backgrounds, fonts, or theme colors.

## Theme Commands

```bash
omaniri theme list              # Show available themes
omaniri theme current           # Show current theme
omaniri theme set <name>        # Apply theme ("Tokyo Night" and "tokyo-night" both work)
omaniri theme bg next           # Cycle background
omaniri theme install <url>     # Install from git repo
```

## Making a New Theme

1. Create a directory under `~/.config/omaniri/themes`.
2. See how an existing theme is done via `/usr/share/omaniri/themes/catppuccin`.
3. Download a matching background (or several) from the internet and put them in `~/.config/omaniri/themes/<name-of-new-theme>/backgrounds/`.
4. When done with the theme, run `omaniri theme set "Name of new theme"`.

Additional user backgrounds for any theme (stock or custom) go in
`~/.config/omaniri/backgrounds/<theme-slug>/`.

## Customizing a Stock Theme

Never edit stock themes under `/usr/share/omaniri/themes/` — changes are lost
on update. Two safe options:

**Overlay (preferred for small tweaks):** create a user theme directory with
the SAME slug containing only the files you want to change. When the theme is
applied, the stock theme is copied first and your files win on top:

```bash
mkdir -p ~/.config/omaniri/themes/catppuccin
cp /usr/share/omaniri/themes/catppuccin/colors.toml ~/.config/omaniri/themes/catppuccin/
# Edit the copied colors.toml, then re-apply:
omaniri theme set catppuccin
```

**Fork:** copy the whole stock theme under a new name for a fully independent
variant:

```bash
cp -r /usr/share/omaniri/themes/catppuccin ~/.config/omaniri/themes/catppuccin-custom
# Edit ~/.config/omaniri/themes/catppuccin-custom/, then:
omaniri theme set catppuccin-custom
```

## Fonts

```bash
omaniri font list               # Available fonts
omaniri font current            # Current font
omaniri font set <name>         # Change font
```

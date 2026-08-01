-- Define terminal tag so themes and bindings can single terminals out. Omaniri
-- launches TUIs and its own terminal windows under dedicated app-ids
-- (org.omaniri.btop, org.omaniri.terminal, TUI.float, ...), so match those too.
-- The class is matched in full, so foot's other app-id needs spelling out.
o.window(
  "(Alacritty|kitty|com.mitchellh.ghostty|foot|org\\.codeberg\\.dnkl\\.foot|wezterm|org\\.omaniri\\..*|TUI\\..*)",
  { tag = "+terminal" }
)

# Fonts

Fonts are installed and configured in `modules/features/fonts.nix`.

## Installed

- **Ubuntu Sans**: GNOME UI font.
- **JetBrains Mono**: terminal and editor monospace.
- **Maple Mono NF**: alternative editor/terminal font; bundles Nerd Font icons.
- **Symbols Nerd Font Mono**: icon glyph fallback for JetBrains Mono.
- **Noto fonts** (`noto-fonts`): Bengali (Noto Sans/Serif Bengali) and every
  other non-CJK Noto script, including Arabic, Devanagari, Thai and Hebrew.
- **Noto CJK** (`noto-fonts-cjk-sans`, `noto-fonts-cjk-serif`): Chinese,
  Japanese and Korean.
- **Noto Color Emoji** and **Noto Emoji** (monochrome).
- **Unifont**: last-resort coverage for rare scripts and symbols.

## Fallback order

fontconfig is configured in the same module:

| Generic family | Order |
|---|---|
| `sans-serif` | Ubuntu Sans → Noto Sans → Noto Sans Bengali |
| `serif` | Noto Serif → Noto Serif Bengali |
| `monospace` | JetBrains Mono → Noto Sans Mono → Noto Sans Bengali |
| `emoji` | Noto Color Emoji |

`fonts.fontconfig.localConf` also appends Symbols Nerd Font Mono and Noto Sans
Bengali to JetBrains Mono, and Noto Sans Bengali to Ubuntu Sans. Appended
families are only used for glyphs the requested family is missing. Noto is
preferred over FreeSans and Unifont for Bengali because those have Bengali
glyphs but do not shape conjuncts and matras correctly.

Ghostty adds Noto Sans Bengali to `font-family` in
`modules/features/terminal.nix`. Zed on Linux uses system fontconfig, so it
needs no per-application font setting.

## Verify

```sh
fc-list :lang=bn family | sort -u
fc-match ':lang=bn' -f '%{family}\n'
printf 'বাংলা: ক্ষ জ্ঞ শ্রী সংখ্যা র্যাব\n😀 日本語 العربية हिन्दी\n'
```

The list should include Noto Sans Bengali and Noto Serif Bengali, and the sample
text should shape correctly in GNOME apps, Firefox and Ghostty.

## Adding another script

Most scripts are already covered by `noto-fonts`. If a glyph is still missing:

1. Add the font package to `fonts.packages`.
2. If it must win over a fallback with poor shaping, append it to the relevant
   family in `fonts.fontconfig.localConf`, following the Bengali rules.

Bengali typing needs an input method (IBus + OpenBangla Keyboard); fonts alone
only cover display.

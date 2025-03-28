#!/bin/bash

# This script sets custom keybindings in GNOME using dconf.
# Each keybinding is defined with a name, command, and key combination.
# Usage: Run this script to apply the custom keybindings.

# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "[
# '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/',
# '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/',
# '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/'
# ]"
#
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Primary><Super><Alt>a'"
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'alacrrity'"
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'Alacrrity'"
#
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Primary><Super><Alt>v'"
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'code'"
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'VS Code'"
#
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding "'<Primary><Super><Alt>c'"
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command "'gnome-calculator'"
# dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name "'Launch Calculator'"

keybindings_file="shortcuts.ini"

# Parse the INI file and apply the keybindings
custom_keybindings=()
while IFS='=' read -r key value; do
  if [[ $key == \[*] ]]; then
    section=${key:1:-1}
    custom_keybindings+=("/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$section/")
  elif [[ $key == "binding" ]]; then
    dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$section/binding" "$value"
  elif [[ $key == "command" ]]; then
    dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$section/command" "$value"
  elif [[ $key == "name" ]]; then
    dconf write "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/$section/name" "$value"
  fi
done <"$keybindings_file"

# Write the list of custom keybindings
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "[$(printf "'%s'," "${custom_keybindings[@]}" | sed 's/,$//')]"

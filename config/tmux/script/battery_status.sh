#!/bin/bash

# Obtain battery information and display charge status and remaining charge
get_battery_status() {
  if command -v acpi &>/dev/null; then
    # Linux (acpi)
    STATUS=$(acpi -b | awk -F', ' '{print $2}')
    PERCENTAGE=$(acpi -b | grep -o '[0-9]\+%' | tr -d '%')

    if [[ "$STATUS" == "Charging" ]]; then
      ICON="🔌"
    else
      ICON="🔋"
    fi

  elif command -v pmset &>/dev/null; then
    # macOS (pmset)
    STATUS=$(pmset -g batt | grep -oE "charging|discharging|charged")
    PERCENTAGE=$(pmset -g batt | grep -o '[0-9]\+%' | tr -d '%')

    if [[ "$STATUS" == "charging" ]]; then
      ICON="🔌"
    else
      ICON="🔋"
    fi

  else
    echo "No battery info available"
    exit 1
  fi

  echo "$ICON $PERCENTAGE%"
}

get_battery_status

# VIA/QMK Keyboard Settings Example

## Replacing CapsLock with a Mod-Tap Key

1. Open the [VIA app](https://www.usevia.app/).
2. Click **Authorize device +**.
3. Click the `CapsLock` key in the layout.
4. From the **SPECIAL** category (at the end of the list), select **Any** key.
5. Enter the following QMK keycode:
   `MT(MOD_LCTL, KC_ESC)`

> [!NOTE]
> If authorization fails on Linux, try using Chrome and check the device log at `chrome://device-log`.

If necessary, adjust device permissions with the following commands:

```bash
sudo chmod a+rw /dev/hidraw1
```

After use, you can restore permissions:

```bash
sudo chmod 600 /dev/hidraw1
```

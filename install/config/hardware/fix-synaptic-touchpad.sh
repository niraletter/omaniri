# Enable Synaptics InterTouch for confirmed touchpads if not already loaded

if grep -qi synaptics /proc/bus/input/devices \
   && ! lsmod | grep -q '^psmouse'; then
    sudo modprobe -r psmouse
    sudo modprobe psmouse synaptics_intertouch=1
fi

# Persist the option across reboots.
if grep -qi synaptics /proc/bus/input/devices; then
    echo "options psmouse synaptics_intertouch=1" | sudo tee /etc/modprobe.d/99-omaniri-synaptics.conf >/dev/null
fi

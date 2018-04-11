# Disable access control
xhost +SI:localuser:$USER

# Make Java applications aware this is a non-reparenting window manager.
export _JAVA_AWT_WM_NONREPARENTING=1

# Fallback cursor
xsetroot -cursor_name left_ptr

# Keyboard repeat rate
xset r rate 200 60

# Configure touchpad
synclient TapButton1=1
synclient TapButton2=3
synclient TapButton3=2
synclient TouchpadOff=1

# Some applications
tint2 &
nm-applet &
volumeicon &
xscreensaver &
parcellite &

# For some wird reason, Pulseaudio needs to be killed and restarted to work. 
pulseaudio -k
pulseaudio --start

# Start Emacs
exec dbus-launch --exit-with-session emacs


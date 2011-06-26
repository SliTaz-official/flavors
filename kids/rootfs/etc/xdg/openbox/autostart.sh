# This shell script is run before Openbox launches.
# Environment variables set here are passed to the Openbox session.

# DBUS message bus (automount removable devices)
dbus-launch --exit-with-session &

# Set the background image.
nitrogen --restore &

# Tint2 panel task bar.
tint2 &

# Start Wbar icons bar.
(sleep 3 && wbar) &

# Desktop effects composer.
#xcompmgr &

# Desktop clock (need xcompmgr running).
#cairo-clock &

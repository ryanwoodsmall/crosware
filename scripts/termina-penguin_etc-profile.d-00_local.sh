test -z "${DBUS_SESSION_BUS_ADDRESS}" && export DBUS_SESSION_BUS_ADDRESS="/run/user/${UID}/bus"
test -z "${DISPLAY_LOW_DENSITY}" && DISPLAY_LOW_DENSITY=":1"
test -z "${DISPLAY}" && export DISPLAY=":0"
test -z "${WAYLAND_DISPLAY_LOW_DENSITY}" && WAYLAND_DISPLAY_LOW_DENSITY="wayland-1"
test -z "${WAYLAND_DISPLAY}" && WAYLAND_DISPLAY="wayland-0"
test -z "${XCURSOR_SIZE_LOW_DENSITY}" && XCURSOR_SIZE_LOW_DENSITY="15"
test -z "${XCURSOR_SIZE}" && XCURSOR_SIZE="30"
test -z "${XDG_RUNTIME_DIR}" && export XDG_RUNTIME_DIR="/run/user/${UID}"

for p in /usr/local/sbin /usr/sbin /sbin ; do
  echo "${PATH}" | tr ':' '\n' | grep -q "^${p}$" || PATH="${PATH}:${p}"
done
unset p
export PATH

#!/usr/bin/env bash
: ${cwtop:="/usr/local/crosware"}
export PATH="$(echo $PATH | tr ':' '\n' | grep -v "${cwtop}/" | paste -s -d: -)"
for e in CFLAGS CPPFLAGS CXXFLAGS LDFLAGS PKG_CONFIG_LIBDIR PKG_CONFIG_PATH ; do
  unset "${e}"
done
unset e
test -e "${cwtop}/etc/profile" && . "${cwtop}/etc/profile" || true

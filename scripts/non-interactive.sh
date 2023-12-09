#!/usr/bin/env bash
#
# cleanse the environment of crosware, moving crosware paths to the end
# suitable for "i just want the commands somewhere" installs
# this can be installed/symlinked to e.g. ${cwtop}/etc/local.d/zz-non-interactive.sh
# should be safe to call from /etc/profile.d/ too? maybe? not trying it
#
# XXX - spaces in ${PATH}? no. please. just don't do it. use a symlink or something
#
if [ ! -z "${BASH_VERSION}" ] ; then
  export CW_OLD_PATH="${PATH}"
  if [[ $- =~ i ]] ; then
    unset AR AS CC CFLAGS CPP CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG_LIBDIR PKG_CONFIG_PATH
    unset a y n p
    declare -a a y n p
    readarray -t a < <(printf '%s\n' "${PATH}" | tr ':' '\n')
    for i in ${!a[@]} ; do
      d="${a[${i}]}"
      if [[ ${d} =~ ${cwsw} ]] ; then
        y+=( "${d}" )
      else
        n+=( "${d}" )
      fi
    done
    for i in ${!n[@]} ; do
      p+=( "${n[${i}]}" )
    done
    for i in ${!y[@]} ; do
      p+=( "${y[${i}]}" )
    done
    export PATH=$(for i in ${!p[@]} ; do printf '%s\n' "${p[${i}]}" ; done | paste -s -d : -)
  fi
  unset a y n p i d
fi
# vim: ft=bash

#
# XXX - netbsdcurses looks painful?
# XXX - https://github.com/hishamhm/htop/issues/643
#
# XXX - options...
#  os-release file:           /etc/os-release
#  (Linux) proc directory:    /proc
#  (Linux) openvz:            no
#  (Linux) vserver:           no
#  (Linux) ancient vserver:   no
#  (Linux) delay accounting:  no
#  (Linux) sensors:           no
#  (Linux) capabilities:      no
#  unicode:                   yes
#  affinity:                  yes
#  unwind:                    no
#  hwloc:                     no
#  debug:                     no
#  static:                    yes
#

rname="htop"
rver="3.4.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rurl="https://github.com/htop-dev/${rname}/releases/download/${rver}/${rfile}"
rsha256="feaabd2d31ca27c09c367a3b1b547ea9f96105fc41f4dfa799e2f49daad5de29"
rreqs="make ncurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null
  ./configure ${cwconfigureprefix} \
    --enable-static \
    --disable-capabilities \
    --disable-dependency-tracking \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

#
# XXX - netbsdcurses looks painful?
# XXX - https://github.com/hishamhm/htop/issues/643
#

rname="htop"
rver="3.2.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rurl="https://github.com/htop-dev/${rname}/releases/download/${rver}/${rfile}"
rsha256="e0f645d4ac324f2c4c48aaa7a3a96d007b95516559550be0b56e423fc5b6d783"
rreqs="make ncurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-static \
    --disable-dependency-tracking \
      CC=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

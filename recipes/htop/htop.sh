#
# XXX - netbsdcurses looks painful?
# XXX - https://github.com/hishamhm/htop/issues/643
#

rname="htop"
rver="3.1.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rurl="https://github.com/htop-dev/${rname}/releases/download/${rver}/${rfile}"
rsha256="884bce5b58cb113127860b9e368609019e92416a81550fdf0752052f3a64b388"
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

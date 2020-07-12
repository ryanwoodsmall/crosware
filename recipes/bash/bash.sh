rname="bash"
rver="5.0.18"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}-${rver%.*}"
rfile="${rname}-${rver%.*}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d"
rreqs="make byacc sed netbsdcurses patch"
# patches file
bpfile="${cwrecipe}/${rname}/${rname}.patches"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make strip
  make install
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/${rname}5\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/sh\"
  popd >/dev/null 2>&1
}
"

unset bpfile

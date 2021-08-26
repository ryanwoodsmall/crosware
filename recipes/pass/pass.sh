rname="pass"
rver="1.7.4"
rdir="${rname}word-store-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="cfa9faf659f2ed6b38e7a7c3fb43e177d00edbacc6265e6e32215ff40e3793c0"
rreqs="make tree pinentry gnupg"

. "${cwrecipe}/common.sh"

local f
for f in configure make ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install PREFIX=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

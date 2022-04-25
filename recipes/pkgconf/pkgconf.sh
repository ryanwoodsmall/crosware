#
# XXX - opt-in only for now
#

rname="pkgconf"
rver="1.0.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rdir}/${rfile}"
rsha256="45ce2f6ab032451345185b800badd77c054040879bd2e56225dafc7fbe583cf1"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts}
  popd >/dev/null 2>&1
}
"

#
# XXX - arrow keys generate raw chars in insert mode by design, not my fave
#

rname="xvi"
rver="2.50.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://martinwguy.github.io/${rname}/download/${rfile}"
rsha256="455ea9afe106a3e20eee019553401517f1d7c7abf0d0e5a12c2b461a192c9617"
rreqs="make netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make \
    INSTALLROOT=\"${ridir}\" \
    CC=\"\${CC} \${CFLAGS} -I${cwsw}/netbsdcurses/current/include\" \
    LDFLAGS=\"-static -L${cwsw}/netbsdcurses/current/lib\" \
    LIBS=\"-lcurses -lterminfo -static\" \
    CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install INSTALLROOT=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'export XVINIT=\"source \${HOME}/.exrc\"' >> \"${rprof}\"
}
"

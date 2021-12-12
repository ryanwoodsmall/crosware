#
# XXX - default to libressl since this is a portable version of an openbsd project!
# XXX - openssl variant
# XXX - netbsdcurses has issues
# XXX - need a mirror in github?
# XXX - /usr/bin/ssh path is hardcoded in lib/dial.c as GOT_DIAL_PATH_SSH with execv used by default
#

rname="got"
rver="0.64"
rdir="${rname}-portable-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://gameoftrees.org/releases/portable/${rfile}"
rsha256="5887573b7687c2786985ab0f684db160a88092b048bc8c4dcfd6c76a1dda2fe2"
rreqs="make byacc zlib pkgconfig libressl e2fsprogs ncurses libmd libbsd"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat lib/dial.c > lib/dial.c.ORIG
  sed -i s,/usr/bin/ssh,ssh,g lib/dial.c
  sed -i s,execv,execvp,g lib/dial.c
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    LIBS='-lpanelw -lncursesw -lz' \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':' )\" \
    YACC=\"${cwsw}/byacc/current/bin/byacc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo ': \${TOG_COLORS:=\"default\"}' > \"${rprof}\"
  echo 'export TOG_COLORS' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"

rname="njs"
rver="0.6.0"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/nginx/${rname}/archive/refs/tags/${rfile}"
rsha256="9060272f24bede008931aefd2badc476553af4cdfd34557884bc021e8d9fe7b5"
rreqs="make pcre netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure \
    --cc-opt=\"\${CFLAGS} \$(echo -I${cwsw}/{pcre,netbsdcurses}/current/include)\" \
    --ld-opt=\"\$(echo -L${cwsw}/{pcre,netbsdcurses}/current/lib) -static\"
  sed -i.ORIG 's/-lreadline/-lreadline -lcurses -lterminfo/g' build/Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"build/${rname}\"
  install -m 0755 \"build/${rname}\" \"${ridir}/bin/\"
  popd >/dev/null 2>&1
}
"


eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

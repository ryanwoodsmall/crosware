#
# XXX - openssl variant (perl, hmm)
#

rname="njs"
rver="0.7.1"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/nginx/${rname}/archive/refs/tags/${rfile}"
rsha256="f5493b444ef54f1edba85c7adcbb1132e61c36d47de8f7a8d351965cad6d5486"
rreqs="make pcre2 netbsdcurses libressl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure \
    --cc-opt=\"\${CFLAGS} \$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    --ld-opt=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\"
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

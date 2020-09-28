rname="gambit"
rver="4.9.3"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/${rname}/${rname}/archive/${rfile}"
rsha256="a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"
rreqs="make configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    CFLAGS='-Wl,-static -fPIC' \
    CXXFLAGS='-Wl,-static -fPIC' \
    LDFLAGS='-static' \
    CPPFLAGS=''
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf \"${rtdir}/current/bin/gsi\" \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

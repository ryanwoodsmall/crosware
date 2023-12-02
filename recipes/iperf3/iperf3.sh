rname="iperf3"
rver="3.16"
rdir="iperf-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/esnet/${rname}/archive/${rfile}"
rsha256="be859e7168d0c867029e7013a8de273a169b4842ec7c24cd6570af75d5080aa3"
rreqs="make openssl configgit zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG 's/-pg//g' src/Makefile.in
  ./configure ${cwconfigureprefix} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"

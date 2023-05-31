#
# XXX
#   libgit2 support down the road...
#   slibtool works, necessary?
# XXX - remove fetch/patch workaround for mbedtls type conflicts/redefinition errors!
#
rname="libssh2"
rver="1.11.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/${rdir}/${rfile}"
rsha256="3736161e41e2693324deb38c26cfdc3efe6209d634ba4258db1cecff6a5ad461"
rreqs="make openssl zlib"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetchcheck \
    \"https://raw.githubusercontent.com/libssh2/libssh2/c317e06faaee580e450f44cf3fca0b9e76f14ee5/src/mbedtls.h\" \
    \"${cwdl}/${rname}/mbedtls.h\" \
    \"6443d11fb44d861a2bf60afe777eda77a608c9ec31058e63d8b302c1d3e97607\"
  cwfetchcheck \
    \"https://raw.githubusercontent.com/libssh2/libssh2/c317e06faaee580e450f44cf3fca0b9e76f14ee5/src/mbedtls.c\" \
    \"${cwdl}/${rname}/mbedtls.c\" \
    \"f06ca7b1282040380590e5413cd7165e967e7c4bd97b5998a1cc0ccf4a1788df\"
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat \"${cwdl}/${rname}/mbedtls.h\" > src/mbedtls.h
  cat \"${cwdl}/${rname}/mbedtls.c\" > src/mbedtls.c
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-{,{sshd,docker}-}tests \
    --disable-examples-build \
    --with-crypto=openssl \
    --with-libz \
    --with-libssl-prefix=\"${cwsw}/openssl/current\" \
    --with-libz-prefix=\"${cwsw}/zlib/current\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  sed -i.ORIG 's/Requires.private/Requires/g' libssh2.pc
  sed -i.ORIG \"s#\$(cwidir_${rname})#${rtdir}/current#g\" libssh2.pc
  sed -i.ORIG '/^Libs:/s|\$| -L${cwsw}/openssl/current/lib -lssl -lcrypto -L${cwsw}/zlib/current/lib -lz|g' libssh2.pc
  grep -ril '<sys/poll.h>' . | xargs sed -i.ORIG 's#<sys/poll.h>#<poll.h>#g'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"

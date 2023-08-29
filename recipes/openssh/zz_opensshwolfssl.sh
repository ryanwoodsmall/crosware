rname="opensshwolfssl"
rver="9.0p1"
rdir="wolfssl-osp-openssh-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/wolfssl/osp/${rfile}"
rsha256="ed453c84db60fea145bec05c8f449210fd5f3928ed3db08c4210ea8896d2394b"
rreqs="make zlib netbsdcurses libeditnetbsdcurses wolfssl"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local r
  sed -i.ORIG 's/ ge(/ internal_ge(/g' fe25519.c
  for r in \
    HAVE_DH_GET0_KEY \
    HAVE_DH_GET0_PQG \
    HAVE_DH_SET0_KEY \
    HAVE_DH_SET0_PQG \
    HAVE_DH_SET_LENGTH \
    HAVE_DSA_GET0_KEY \
    HAVE_DSA_GET0_PQG \
    HAVE_DSA_SET0_KEY \
    HAVE_DSA_SET0_PQG \
    HAVE_DSA_SIG_GET0 \
    HAVE_DSA_SIG_SET0 \
    HAVE_ECDSA_SIG_GET0 \
    HAVE_ECDSA_SIG_SET0 \
    HAVE_EVP_CIPHER_CTX_GET_IV \
    HAVE_EVP_CIPHER_CTX_SET_IV \
    HAVE_EVP_MD_CTX_FREE \
    HAVE_EVP_MD_CTX_NEW \
    HAVE_EVP_PKEY_GET0_RSA \
    HAVE_RSA_GET0_CRT_PARAMS \
    HAVE_RSA_GET0_FACTORS \
    HAVE_RSA_GET0_KEY \
    HAVE_RSA_METH_FREE \
    HAVE_RSA_METH_GET_FINISH \
    HAVE_RSA_METH_SET_FINISH \
    HAVE_RSA_METH_SET_PRIV_DEC \
    HAVE_RSA_METH_SET_PRIV_ENC \
    HAVE_RSA_SET0_CRT_PARAMS \
    HAVE_RSA_SET0_FACTORS \
    HAVE_RSA_SET0_KEY
  do
    sed -i \"/ifndef.*\${r}/s,.*,#if 0,g\" openbsd-compat/libressl-api-compat.c
  done
  unset r
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-wolfssl=\"${cwsw}/wolfssl/current\" \
    --without-pie \
    --without-zlib-version-check \
    --with-libedit=\"${cwsw}/libeditnetbsdcurses/current\" \
    --sysconfdir=\"${cwetc}/openssh\" \
    --with-privsep-path=\"${cwtmp}/empty\" \
    --with-mantype=man \
      CFLAGS=\"\${CFLAGS}\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"-L\$(cwidir_${rname})/lib \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      LIBS='-lwolfssl -lz -lcrypt -ledit -lcurses -lterminfo -static -s' \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  ln -sf ssh \"\$(cwidir_${rname})/bin/openssh\"
  for p in \$(cwidir_${rname})/{bin,sbin}/s* ; do
    s=\"\$(basename \${p})\"
    d=\"\$(dirname \${p})\"
    t=\"\${d}/openssh-\${s}\"
    ln -sf \"\${s}\" \"\${t}\"
  done
  unset p t s d
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"

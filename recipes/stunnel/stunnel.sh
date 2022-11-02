rname="stunnel"
rver="5.67"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="3086939ee6407516c59b0ba3fbf555338f9d52f459bcab6337c0f00e91ea8456"
rreqs="make openssl zlib toybox perl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  grep -ril '/usr/bin/perl' . \
  | xargs sed -i \"s#/usr/bin/perl#${cwsw}/perl/current/bin/perl#g\"
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-fips \
    --disable-libwrap \
    --disable-systemd \
    --with-ssl=\"${cwsw}/openssl/current\" \
      LIBS='-lz'
  find . -type f -name Makefile -exec sed -i 's/-fPIE/-fPIC/g' {} \;
  find . -type f -name Makefile -exec sed -i 's/-pie//g' {} \;
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

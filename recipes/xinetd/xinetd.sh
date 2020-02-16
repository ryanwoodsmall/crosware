rname="xinetd"
rver="2.3.15.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/openSUSE/${rname}/releases/download/${rver}/${rfile}"
rsha256="2baa581010bc70361abdfa37f121e92aeb9c5ce67f9a71913cebd69359cc9654"
rreqs="make slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's#/usr/bin/perl#/usr/bin/env perl#g' src/xconv.pl
  sed -i.ORIG 's#/etc/#${rtdir}/current/etc/#g' contrib/xinetd.conf src/xconfig.h
  sed -i.ORIG 's/-pie//g' configure
  sed -i 's/-Wl,-z,relro//g' configure
  sed -i 's/-fPIE//g' configure
  sed -i 's/-Wl,-z,now//g' configure
  ./configure ${cwconfigureprefix} \
    --without-labeled-networking \
    --without-libwrap \
    --without-loadavg \
    --without-rpc \
      CC=\"\${CC} \${CFLAGS} -static --static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"

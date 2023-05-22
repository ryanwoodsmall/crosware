#
# XXX - tcp seems sketchy? udp works?
# XXX - write an exports file: echo '/usr/local/crosware 0.0.0.0/0(ro)' | tee ${cwtop}/tmp/exports
# XXX - start with: unfsd -d -e ${cwtop}/tmp/exports -i /tmp/unfsd.pid -u -n 2049 -m 2049 -p -s
# XXX - mount with: mount -t nfs -o udp,rw,port=2049,mountport=2049 10.11.12.13:/usr/local/crosware /mnt/tmp
#

rname="unfs3"
rver="0.10.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/unfs3/unfs3/releases/download/${rdir}/${rfile}"
rsha256="9bc6568fba2e43f3e2181f1d1802afec41929c1e55a6e53da982aacc7ce79ebb"
rreqs="make byacc flex libtirpc pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat configure > configure.ORIG
  sed -i '/LDFLAGS=/ s,-R/usr/ucblib,,' ./configure
  env PATH=\"${cwsw}/byacc/current/bin:${cwsw}/flex/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      CC=\"\${CC} \${CFLAGS} -fcommon -I${cwsw}/libtirpc/current/include/tirpc\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LEX=\"${cwsw}/flex/current/bin/flex\" \
      YACC=\"${cwsw}/byacc/current/bin/byacc\" \
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make LDFLAGS=\"-L${cwsw}/libtirpc/current/lib -L${cwsw}/flex/current/lib -ltirpc -lfl -static\" CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

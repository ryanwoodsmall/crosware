#
# XXX - move to official github? https://github.com/unfs3/unfs3
# XXX - tcp seems sketchy? udp works?
# XXX - write an exports file: echo '/usr/local/crosware 0.0.0.0/0(ro)' | tee ${cwtop}/tmp/exports
# XXX - start with: unfsd -d -e ${cwtop}/tmp/exports -i /tmp/unfsd.pid -u -n 2049 -m 2049 -p -s
# XXX - mount with: mount -t nfs -o udp,rw,port=2049,mountport=2049 10.11.12.13:/usr/local/crosware /mnt/tmp
#

rname="unfs3"
rver="0.9.22"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="482222cae541172c155cd5dc9c2199763a6454b0c5c0619102d8143bb19fdf1c"
rreqs="make byacc flex libtirpc"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat configure > configure.ORIG
  sed -i '/LDFLAGS=/ s,-R/usr/ucblib,,' ./configure
  sed -i 's/rpcsoc/tirpc/g' ./configure
  env PATH=\"${cwsw}/byacc/current/bin:${cwsw}/flex/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      CC=\"\${CC} \${CFLAGS} -fcommon -I${cwsw}/libtirpc/current/include/tirpc\" \
      LDFLAGS=\"-L${cwsw}/libtirpc/current/lib -L${cwsw}/flex/current/lib -static\" \
      LIBS='-ltirpc' \
      LEX=\"${cwsw}/flex/current/bin/flex\" \
      YACC=\"${cwsw}/byacc/current/bin/byacc\" \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make LDFLAGS=\"-L${cwsw}/libtirpc/current/lib -L${cwsw}/flex/current/lib -ltirpc -lfl -static\" CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

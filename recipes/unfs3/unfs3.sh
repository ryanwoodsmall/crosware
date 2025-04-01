#
# XXX - tcp seems sketchy? udp works?
# XXX - write an exports file: echo '/usr/local/crosware 0.0.0.0/0(ro)' | tee ${cwtop}/tmp/exports
# XXX - start with: unfsd -d -e ${cwtop}/tmp/exports -i /tmp/unfsd.pid -u -n 2049 -m 2049 -p -s
# XXX - mount with: mount -t nfs -o udp,rw,port=2049,mountport=2049 10.11.12.13:/usr/local/crosware /mnt/tmp
# XXX - custom cwclean_ to workaround weird `pop_var_context: head of shell_variables not a function context` error w/bash 5.2+/readline 8.2+
# XXX - --enable-cluster and --enable-year2038 configure options
#

rname="unfs3"
rver="0.11.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/unfs3/unfs3/releases/download/${rdir}/${rfile}"
rsha256="42ef63cd949b65a4ead30bee269703059a8c4269bef6aa1533215ad1c2a26d6f"
rreqs="make byacc flex libtirpc pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwclean_${rname}() {
  (
    pushd \"${cwbuild}\"
    rm -rf \"${rbdir}\"
    popd >/dev/null 2>&1
  ) &>/dev/null || true
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat configure > configure.ORIG
  sed -i '/LDFLAGS=/ s,-R/usr/ucblib,,' ./configure
  env PATH=\"${cwsw}/byacc/current/bin:${cwsw}/flex/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      CC=\"\${CC} \${CFLAGS} -fcommon -I${cwsw}/libtirpc/current/include/tirpc\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LEX=\"${cwsw}/flex/current/bin/flex\" \
      YACC=\"${cwsw}/byacc/current/bin/byacc\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make LDFLAGS=\"-L${cwsw}/libtirpc/current/lib -L${cwsw}/flex/current/lib -ltirpc -lfl -static\" CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"

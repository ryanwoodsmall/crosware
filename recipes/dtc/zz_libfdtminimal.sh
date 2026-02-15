#
# XXX - no idea if this works
#
rname="libfdtminimal"
rver="$(cwver_dtc)"
rdir="$(cwdir_dtc)"
rfile="$(cwfile_dtc)"
rdlfile="$(cwdlfile_dtc)"
rurl="$(cwurl_dtc)"
rsha256="$(cwsha256_dtc)"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="make flex byacc"

. "${cwrecipe}/common.sh"

for f in fetch clean extract configure ; do
  eval "function cw${f}_${rname}() { cw${f}_dtc ; }"
done
unset f

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/^extern int yylex/d' dtc-parser.y
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    export LDFLAGS=-static
    make libfdt STATIC_BUILD=1 NO_PYTHON=1 BISON=\"${cwsw}/byacc/current/bin/byacc\" PREFIX=\"\$(cwidir_${rname})\"
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    cd libfdt/
    rm -rf \$(cwidir_${rname})/{include,lib}
    cwmkdir \$(cwidir_${rname})/include
    cwmkdir \$(cwidir_${rname})/lib
    for i in fdt.h libfdt.h libfdt_env.h ; do
      install -m 0644 \${i} \$(cwidir_${rname})/include/\${i}
    done
    install -m 0644 libfdt.a \$(cwidir_${rname})/lib/libfdt.a
  )
  popd &>/dev/null
}
"

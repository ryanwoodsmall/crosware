#
# XXX - maybe install shared lib .so(s) in ${ridir}/dl? need something similar for lua?
# XXX - jpm moved to separate project in 1.17.x: https://github.com/janet-lang/jpm
# XXX - jpm probably needs to be a commit hash with a 'git' wrapper for rev-parse HEAD and get-url on install
#

rname="janet"
rver="1.31.0"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/janet-lang/${rname}/archive/refs/tags/${rfile}"
rsha256="1f5064b97313b93f282e36584dfb7d491dd13d6ccf4f6550281232e77ccef780"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

: ${jpm_ver:="master"}
: ${jpm_dir:="jpm-${jpm_ver}"}
: ${jpm_file:="${jpm_dir}.zip"}
: ${jpm_dlfile:="${cwdl}/${rname}/${jpm_file}"}

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetch \"https://github.com/${rname}-lang/jpm/archive/refs/heads/${jpm_ver}.zip\" \"${jpm_dlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i \"s,^PREFIX.*,PREFIX=\$(cwidir_${rname}),g\" Makefile
  sed -i '/\\(cp\\|ln\\).*\\.so/s,\\(cp\\|ln\\),echo \\1,g' Makefile
  if [[ ${karch} =~ ^riscv64 ]] ; then
    sed -i.ORIG 's/defined(__aarch64__).*/__riscv_xlen == 64/g' src/include/janet.h
    echo '#undef JANET_ARCH_NAME' >> src/conf/janetconf.h
    echo '#define JANET_ARCH_NAME riscv64' >> src/conf/janetconf.h
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} CPPFLAGS= LDFLAGS=-static PKG_CONFIG_LDFLAGS= PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool} CPPFLAGS= LDFLAGS=-static PKG_CONFIG_LDFLAGS= PKG_CONFIG_PATH=
  \$(\${CC} -dumpmachine)-strip \"\$(cwidir_${rname})/bin/${rname}\"
  if hash git >/dev/null 2>&1 ; then
    rm -rf \"${jpm_dir}\"
    unzip \"${jpm_dlfile}\"
    cd \"${jpm_dir}\"
    env {JANET_,}PREFIX=\"\$(cwidir_${rname})\" PATH=\"\$(cwidir_${rname})/bin:\${PATH}\" \"\$(cwidir_${rname})/bin/${rname}\" bootstrap.janet
    sed -i \"s,\$(cwidir_${rname}),${rtdir}/current,g\" \"\$(cwidir_${rname})/bin/jpm\"
    cd -
  else
    cwscriptecho \"'git' not found - not installing jpm\"
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export JANET_PREFIX=\"${rtdir}/current\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"

unset jpm_ver jpm_dir jpm_file jpm_dlfile

#
# XXX - maybe install shared lib .so(s) in ${ridir}/dl? need something similar for lua?
# XXX - jpm moved to separate project in 1.17.x: https://github.com/janet-lang/jpm
# XXX - jpm probably needs to be a commit hash with a 'git' wrapper for rev-parse HEAD and get-url on install
#

rname="janet"
rver="1.18.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/janet-lang/${rname}/archive/refs/tags/${rfile}"
rsha256="bfc29c11a070cc175666f74eb99ea992276d6e269701ba9558a72cef05ac80b4"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

: ${jpm_ver:="master"}
: ${jpm_dir:="jpm-${jpm_ver}"}
: ${jpm_file:="${jpm_dir}.zip"}
: ${jpm_dlfile:="${cwdl}/${rname}/${jpm_file}"}

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetch \"https://github.com/${rname}-lang/jpm/archive/refs/heads/${jpm_ver}.zip\" \"${jpm_dlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat Makefile > Makefile.ORIG
  sed -i 's,^PREFIX.*,PREFIX=${ridir},g' Makefile
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} CPPFLAGS= LDFLAGS=-static PKG_CONFIG_LDFLAGS= PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool} CPPFLAGS= LDFLAGS=-static PKG_CONFIG_LDFLAGS= PKG_CONFIG_PATH=
  \$(\${CC} -dumpmachine)-strip \"${ridir}/bin/${rname}\"
  if hash git >/dev/null 2>&1 ; then
    rm -rf \"${jpm_dir}\"
    unzip \"${jpm_dlfile}\"
    cd \"${jpm_dir}\"
    env {JANET_,}PREFIX=\"${ridir}\" PATH=\"${ridir}/bin:\${PATH}\" \"${ridir}/bin/${rname}\" bootstrap.janet
    sed -i \"s,${ridir},${rtdir}/current,g\" \"${ridir}/bin/jpm\"
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

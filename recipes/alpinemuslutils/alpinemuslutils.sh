#
# XXX - include __stack_chk_fail_local.c?
# XXX - looks like an libssp_nonshared.a can be built from it?
#
rname="alpinemuslutils"
rver="3.21.3"
rdir="${rname}-${rver}"
rfile="getconf.c"
rurl="https://raw.githubusercontent.com/alpinelinux/aports/v${rver}/main/musl/${rfile}"
rsha256=""
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  local -a dlfiles=()
  local -A dlshasums=()
  dlfiles=( 'getconf.c' 'getent.c' 'iconv.c' )
  dlshasums+=( ['getconf.c']='d87d0cbb3690ae2c5d8cc218349fd8278b93855dd625deaf7ae50e320aad247c' )
  dlshasums+=( ['getent.c']='b25f32d306d542246e9358ef65cd67c12b3e3a77656bc467853d3b0c76b5fbbd' )
  dlshasums+=( ['iconv.c']='f79a2930a2e5bb0624321589edf8b889d1e9b603e01e6b7ae214616605b3fdd7' )
  for f in \${dlfiles[@]} ; do
    dlurl=\"${rurl%${rfile}}\${f}\"
    dlfile=\"${rdlfile%${rfile}}\${f}\"
    cwfetchcheck \"\${dlurl}\" \"\${dlfile}\" \"\${dlshasums[\${f}]}\"
  done
  unset f dlfiles dlshasums dlurl dlfile
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"\$(cwidir_${rname})/bin\"
  for p in getconf getent iconv ; do
    cwscriptecho \"compiling alpine-\${p} from \${p}.c\"
    \${CC} \${CFLAGS} \"${rdlfile%${rfile}}\${p}.c\" -o \"\$(cwidir_${rname})/bin/alpine-\${p}\" -static
  done
  ln -sf alpine-getconf \"\$(cwidir_${rname})/bin/getconf\"
  ln -sf alpine-getent \"\$(cwidir_${rname})/bin/getent\"
  unset p
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

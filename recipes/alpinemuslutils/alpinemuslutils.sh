rname="alpinemuslutils"
rver="3.15.0"
rdir="${rname}-${rver}"
rfile="getconf.c"
rurl="https://raw.githubusercontent.com/alpinelinux/aports/v${rver}/main/musl/${rfile}"
rsha256=""
rreqs=""

. "${cwrecipe}/common.sh"

for f in extract configure make ; do
  eval "function cw${f}_${rname}() { true ; }"
done
unset f

eval "
function cwfetch_${rname}() {
  cwmkdir \"${ridir}/bin\"
  local -a dlfiles=()
  local -A dlshasums=()
  dlfiles=( 'getconf.c' 'getent.c' 'iconv.c' )
  dlshasums+=( ['getconf.c']='d87d0cbb3690ae2c5d8cc218349fd8278b93855dd625deaf7ae50e320aad247c' )
  dlshasums+=( ['getent.c']='002c1a216f6bed0f816ab1cfebde94a0b127193ef410c36b2190599983e015b8' )
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
  cwmkdir \"${ridir}/bin\"
  for p in getconf getent iconv ; do
    cwscriptecho \"compiling alpine-\${p} from \${p}.c\"
    \${CC} \${CFLAGS} \"${rdlfile%${rfile}}\${p}.c\" -o \"${ridir}/bin/alpine-\${p}\" -static
  done
  ln -sf alpine-getconf \"${ridir}/bin/getconf\"
  ln -sf alpine-getent \"${ridir}/bin/getent\"
  unset p
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

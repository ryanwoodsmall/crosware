rname="rlwrapminimal"
rver="$(cwver_rlwrap)"
rdir="$(cwdir_rlwrap)"
rfile="$(cwfile_rlwrap)"
rdlfile="$(cwdlfile_rlwrap)"
rurl="$(cwurl_rlwrap)"
rsha256="$(cwsha256_rlwrap)"
rreqs="bootstrapmake configgit readlineminimal"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_rlwrap)\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CC=\"\${CC} -g0 -Os -Wl,-s\" \
    CFLAGS=\"\${CFLAGS} -g0 -Os -Wl,-s\" \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
    LIBS='-lreadline -ltermcap' \
    PKG_CONFIG_{LIBDIR,PATH}=
  sed -i.ORIG 's/pod2man/echo pod2man/g' filters/Makefile
  echo '#include <stdbool.h>' >> config.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%minimal}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"

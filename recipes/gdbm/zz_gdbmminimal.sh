rname="gdbmminimal"
rver="$(cwver_gdbm)"
rdir="$(cwdir_gdbm)"
rbdir="$(cwbdir_gdbm)"
rfile="$(cwfile_gdbm)"
rdlfile="$(cwdlfile_gdbm)"
rurl="$(cwurl_gdbm)"
rsha256="$(cwsha256_gdbm)"
rreqs="bootstrapmake configgit"

. "${cwrecipe}/common.sh"

for f in clean fetch extract patch ; do
  eval "function cw${f}_${rname} { cw${f}_${rname%minimal} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --disable-nls \
      --enable-libgdbm-compat \
      --without-readline \
        LDFLAGS='-static -s'
  )
  popd &>/dev/null
}
"

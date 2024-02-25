#
# XXX - 1.7 has r/w locks explicitly disabled; _think_ this should work with musl but need to investigate more
# XXX - this builds...
# XXX - error... npth.c:392:21: error: unknown type name 'npth_rwlock_t'; did you mean 'npth_cond_t'?
#
rname="npth"
rver="1.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="8589f56937b75ce33b28d312fccbf302b3b71ec3f3945fde6aaa74027914ad05"
rreqs="make slibtool configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-tests \
    --enable-install-npth-config \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  sed -i.ORIG 's,^#undef _NPTH_NO_RWLOCK,#define _NPTH_NO_RWLOCK 1,' src/npth.h
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"

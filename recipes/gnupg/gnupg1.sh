rname="gnupg1"
rver="1.4.23"
rdir="${rname%1}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname%1}/${rfile}"
rsha256="c9462f17e651b6507848c08c430c791287cd75491f8b5a8b50c6ed46b12678ba"
rreqs="make zlib bzip2 netbsdcurses readlinenetbsdcurses slibtool configgit"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --program-suffix=1 \
    --disable-ldap \
    --disable-nls \
    --without-libcurl \
    --with-bzip2=\"${cwsw}/bzip2/current\" \
    --with-readline=\"${cwsw}/readlinenetbsdcurses/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      LIBS='-lreadline -lterminfo -lcurses -static'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  rm -f \"${cwetcprofd}/${rname}.sh\"
  echo 'append_path \"${cwsw}/gnupg/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${cwsw}/gnupg/current/sbin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"

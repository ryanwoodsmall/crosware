#
# opt-in only
#
rname="gettext"
rver="0.23.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/gettext/${rfile}"
rsha256="52a578960fe308742367d75cd1dff8552c5797bd0beba7639e12bdcda28c0e49"
rreqs="bashtiny gawk sed make busybox toybox"

rnewpath=""
for p in ${rreqs} ; do
  rnewpath="${rnewpath}:${cwsw}/${p}/current/bin"
done
unset p
export rnewpath="${cwsw}/ccache4/current/bin:${cwsw}/ccache/current/bin:${cwsw}/statictoolchain/current/bin:${rnewpath#:}"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat gettext-tools/Makefile.in > gettext-tools/Makefile.in.ORIG
  sed -i '/^SUBDIRS.*examples/s,examples,,g' gettext-tools/Makefile.in
  sed -i '/^install-data-am.*:.*examples/s, install-examplesbuildauxDATA, ,g' gettext-tools/Makefile.in
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset {C{,PP,XX},LD}FLAGS PKG_CONFIG_{LIBDIR,PATH}
    export C{,XX}FLAGS='-fPIC -Wl,-static -Wl,-s -g0 -Os'
    export LDFLAGS='-static -s'
    export PATH=\"${rnewpath}\"
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      --disable-acl \
      --disable-curses \
      --disable-dependency-tracking \
      --disable-java \
      --disable-nls \
      --disable-openmp \
      --disable-xattr \
      --enable-threads=posix \
      --with-included-libunistring \
      --with-included-libxml \
      --with-included-regex \
      --without-emacs \
        C{,XX}FLAGS='-fPIC -Wl,-static -Wl,-s -g0 -Os' \
        LDFLAGS='-static -s'
  )
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset {C{,PP,XX},LD}FLAGS PKG_CONFIG_{LIBDIR,PATH}
    export PATH=\"${rnewpath}\"
    make -j${cwmakejobs} ${rlibtool}
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset {C{,PP,XX},LD}FLAGS PKG_CONFIG_{LIBDIR,PATH}
    export PATH=\"${rnewpath}\"
    make install ${rlibtool}
  )
  popd &>/dev/null
}
"

unset rnewpath

#
# XXX - dynamic, leave as-is for now
# XXX - posix/editline/lib/dump/regex/socket/... options?
# XXX - editline could replace readline? not sure
# XXX - build script generator? http://people.csail.mit.edu/jaffer/buildscm.html
#
# more detailed installation in docs:
# - https://people.csail.mit.edu/jaffer/scm/Installing-SCM.html#Installing-SCM
#   - https://people.csail.mit.edu/jaffer/scm/GNU-configure-and-make.html#GNU-configure-and-make
#     - https://people.csail.mit.edu/jaffer/scm/Making-scmlit.html#Making-scmlit
#     - https://people.csail.mit.edu/jaffer/scm/Makefile-targets.html#Makefile-targets
#   - https://people.csail.mit.edu/jaffer/scm/Building-SCM.html#Building-SCM
#     - https://people.csail.mit.edu/jaffer/scm/Invoking-Build.html#Invoking-Build
#     - https://people.csail.mit.edu/jaffer/scm/Build-Options.html#Build-Options
#     - https://people.csail.mit.edu/jaffer/scm/Compiling-and-Linking-Custom-Files.html#Compiling-and-Linking-Custom-Files
#
rname="scm"
rver="5f4-$(cwver_slib)"
rbdir="${cwbuild}/${rname}"
rdir="${rname}-${rver}"
rfile="${rname}-${rver%-*}.zip"
rurl="http://groups.csail.mit.edu/mac/ftpdir/${rname}/${rfile}"
rsha256="d3426dff809d80b49bf2e9f7f3bab21183ef920323fc53f5ac58310137d4269e"
rreqs="make texinfo readline ncurses slib"

if ! command -v rsync &>/dev/null ; then
  rreqs+=" rsyncminimal"
fi

. "${cwrecipe}/common.sh"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf \"${rname}\"
  rm -rf \"slib\"
  popd &>/dev/null
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract_slib
}
"

eval "
function cwconfigure_${rname}() {
  (
    export PATH=\"${cwsw}/ccache/current/bin:${cwsw}/ccache4/current/bin:${cwsw}/statictoolchain/current/bin:\${PATH}\"
    export CFLAGS=-fPIC
    export CPPFLAGS=\"\$(echo -I${cwsw}/{ncurses,readline}/current/include{,/ncurses{,w}})\"
    export LDFLAGS=\"\$(echo -L${cwsw}/{ncurses,readline}/current/lib)\"
    export PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{ncurses,readline}/current/lib/pkgconfig | tr ' ' ':')\"
    pushd \"\$(cwbdir_${rname})\" &>/dev/null
    ./configure ${cwconfigureprefix}
    cat Makefile > Makefile.ORIG
    sed -i \"/^#CC/s,.*,CC=\${CC} \$(echo -I${cwsw}/{ncurses,readline}/current/include{,/ncurses{,w}}) \$(echo -L${cwsw}/{ncurses,readline}/current/lib),\" Makefile
    sed -i \"/^#LIBS/s,.*,LIBS=\$(echo -L${cwsw}/{readline,ncurses}/current/lib) -lreadline -lncurses,\" Makefile
    sed -i \"/^#CFLAGS/s,.*,CFLAGS=-fPIC,\" Makefile
    cat build.scm > build.scm.ORIG
    sed -i \"s,/lib/libncurses.so,${cwsw}/ncurses/current/lib/libncurses.a,g\" build.scm
    sed -i \"s,/usr/lib/libcurses.a,${cwsw}/ncurses/current/lib/libncurses.a,g\" build.scm
    sed -i \"s,/usr/lib/libtermcap.a,${cwsw}/ncurses/current/lib/libncurses.a,g\" build.scm
    sed -i \"s,/usr/lib/libreadline.a,${cwsw}/readline/current/lib/libreadline.a,g\" build.scm
    sed -i \"/-lcurses/s,-lcurses,-lncurses,g\" build.scm
    sed -i \"/-ltermcap/s,-ltermcap,-lncurses,g\" build.scm
    sed -i 's,\"cc\",\"gcc\",g' build.scm
    sed -i 's,\"-shared\",\"-shared\" \"-L${cwsw}/readline/current/lib\" \"-L${cwsw}/ncurses/current/lib\",g' build.scm
    sed -i.ORIG '/#.*include.*getpagesize.*/d' gmalloc.c unexec.c
    popd &>/dev/null
    pushd \"${cwbuild}/slib\" &>/dev/null
    ./configure ${cwconfigureprefix}
    popd &>/dev/null
  )
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"${cwsw}/ccache/current/bin:${cwsw}/ccache4/current/bin:${cwsw}/statictoolchain/current/bin:\${PATH}\"
    export CFLAGS=-fPIC
    export CPPFLAGS=\"\$(echo -I${cwsw}/{ncurses,readline}/current/include{,/ncurses{,w}})\"
    export LDFLAGS=\"\$(echo -L${cwsw}/{ncurses,readline}/current/lib)\"
    export PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{ncurses,readline}/current/lib/pkgconfig | tr ' ' ':')\"
    make scmlit
    make all
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  (
    export PATH=\"${cwsw}/ccache/current/bin:${cwsw}/ccache4/current/bin:${cwsw}/statictoolchain/current/bin:\${PATH}\"
    export CFLAGS=-fPIC
    export CPPFLAGS=\"\$(echo -I${cwsw}/{ncurses,readline}/current/include{,/ncurses{,w}})\"
    export LDFLAGS=\"\$(echo -L${cwsw}/{ncurses,readline}/current/lib)\"
    export PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{ncurses,readline}/current/lib/pkgconfig | tr ' ' ':')\"
    pushd \"${cwbuild}/slib\" &>/dev/null
    env PATH=\"${rbdir}:\${PATH}\" make install
    popd &>/dev/null
    pushd \"\$(cwbdir_${rname})\" &>/dev/null
    make install
    popd &>/dev/null
    local initfile=\"\$(cwidir_${rname})/lib/scm/Init\$(cwver_${rname} | cut -f1 -d-).scm\"
    cat \${initfile} > \${initfile}.ORIG
    echo '(load \"/usr/local/crosware/software/scm/current/lib/scm/edline.so\")' >> \${initfile}
    echo '(load \"/usr/local/crosware/software/scm/current/lib/scm/Iedline.scm\")' >> \${initfile}
    unset initfile
  )
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

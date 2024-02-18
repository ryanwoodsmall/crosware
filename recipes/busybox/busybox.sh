#
# XXX - move config script download to versioned based on git commit, move to cwfetch_
# XXX - busybox should be reproducible; use KCONFIG_NOTIMESTAMP=1 ??? - what else? BB_EXTRA_VERSION is the biggie, taken care of below...
# XXX - see... https://github.com/osresearch/linux-builder/blob/main/modules/busybox
# XXX - reproducible: based on statictoolchain version, also need to account for/probably include...
#       - busybox version (nah, already included?)
#       - busybox config script version - _must_ get this versioned/checksummed like toybox
#       - karch/host triplet? - simplest, just use "${CC} -dumpmachine"
# XXX - might want to make toybox a prereq - would get tar bzip support (would need to compress statictoolchain w/gzip though!)
#

rname="busybox"
rver="1.36.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
#rurl="http://${rname}.net/downloads/${rfile}"
rsha256="b8cc24c9574d809e7279c3be349795c5d5ceb6fdf19ca709f80cde50e47de314"
rreqs="bootstrapmake toybox bashtiny bzip2"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"${cwsw}/bashtiny/current/bin:${cwsw}/toybox/current/bin:${cwsw}/bzip2/current/bin:\${PATH}\"
    chmod -R u+w .
    csu=\"https://raw.githubusercontent.com/ryanwoodsmall/${rname}-misc/master/scripts/bb_config_script.sh\"
    cs=\"\$(basename \${csu})\"
    cwfetch \"\${csu}\" \"\$(cwbdir_${rname})/\${cs}\"
    sed -i.ORIG 's/^make/#make/g;s/^test/#test/g' \"\${cs}\"
    make defconfig HOSTCC=\"\${CC} -static\"
    bash \"\${cs}\" -m -s
    make oldconfig HOSTCC=\"\${CC} -static\"
    cat include/libbb.h > include/libbb.h.ORIG
    echo '#undef BB_EXTRA_VERSION' >> include/libbb.h
    echo -n '#define BB_EXTRA_VERSION \" (' >> include/libbb.h
    echo -n \"\$(cwver_statictoolchain)\" >> include/libbb.h
    echo -n ')\"' >> include/libbb.h
    echo >> include/libbb.h
  )
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"${cwsw}/bashtiny/current/bin:${cwsw}/toybox/current/bin:${cwsw}/bzip2/current/bin:\${PATH}\"
    make -j${cwmakejobs} \
      CC=\"\${CC} -Wl,-static\" \
      HOSTCC=\"\${CC} -static -Wl,-static\" \
      CFLAGS=\"\${CFLAGS}\" \
      HOSTCFLAGS=\"\${CFLAGS}\" \
      LDFLAGS=-static \
      HOSTLDFLAGS=-static
  )
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"${cwsw}/bashtiny/current/bin:${cwsw}/toybox/current/bin:${cwsw}/bzip2/current/bin:\${PATH}\"
    cwmkdir \"\$(cwidir_${rname})/bin\"
    rm -f \"\$(cwidir_${rname})/bin/${rname}\"
    cp -a \"${rname}\" \"\$(cwidir_${rname})/bin\"
    local a=''
    for a in \$(./${rname} --list) ; do
      ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/\${a}\"
    done
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'export PAGER=\"less\"' >> \"${rprof}\"
  echo 'export MANPAGER=\"less -R\"' >> \"${rprof}\"
}
"

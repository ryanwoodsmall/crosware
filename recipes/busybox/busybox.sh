#
# XXX - move config script download to versioned based on git commit, move to cwfetch_
# XXX - busybox should be reproducible; use KCONFIG_NOTIMESTAMP=1 ??? - what else? BB_EXTRA_VERSION is the biggie, taken care of below...
# XXX - see... https://github.com/osresearch/linux-builder/blob/main/modules/busybox
# XXX - reproducible: based on statictoolchain version, also need to account for/probably include...
#       - busybox version (nah, already included?)
#       - busybox config script version - _must_ get this versioned/checksummed like toybox
#       - karch/host triplet? - simplest, just use "${CC} -dumpmachine"
#

rname="busybox"
rver="1.37.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
#rurl="http://${rname}.net/downloads/${rfile}"
rsha256="3311dff32e746499f4df0d5df04d7eb396382d7e108bb9250e7b519b837043a4"
rreqs="bootstrapmake bashtiny alpinemuslutils toybox"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  cwscriptecho \"extracting \$(cwdlfile_${rname}) to ${cwbuild} using toybox\"
  \"${cwsw}/toybox/current/bin/toybox\" bzcat \"\$(cwdlfile_${rname})\" | \"${cwsw}/toybox/current/bin/toybox\" tar -C \"${cwbuild}\" -xf -
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"\$(echo ${cwsw}/{bashtiny,bootstrapmake,toybox,ccache{{4,},3},statictoolchain}/current/bin | paste -s -d: -):\${PATH}\"
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
    export PATH=\"\$(echo ${cwsw}/{bashtiny,bootstrapmake,toybox,ccache{{4,},3},statictoolchain}/current/bin | paste -s -d: -):\${PATH}\"
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
    export PATH=\"\$(echo ${cwsw}/{bashtiny,bootstrapmake,toybox,ccache{{4,},3},statictoolchain}/current/bin | paste -s -d: -):\${PATH}\"
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

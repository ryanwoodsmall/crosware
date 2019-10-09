rname="bsdvis"
rver="1.25"
rdir="${rname}-${rver}"
rfile="${rdir}.fake"
rurl="http://cvsweb.netbsd.org/bsdweb.cgi/src/usr.bin/vis/"
rsha256="42d16bc5b8807085d8e585e6a6631fb472d6e9d20ffd3aac7abc7097009ed382"
rreqs="libbsd pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/vis/vis.c?rev=${rver}\" \"${cwdl}/${rname}/vis.c\"    \"${rsha256}\"
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/vis/extern.h?rev=1.1\"  \"${cwdl}/${rname}/extern.h\" \"52e0a8970a05cd795ce25521820010d9450bf829bb064d4e0c37d1c79ed1c019\"
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/vis/foldit.c?rev=1.7\"  \"${cwdl}/${rname}/foldit.c\" \"8dbf69a76874bf316c739adb68f434e1ce97a32f68b3b722e2a47bec6f1a7ec4\"
  cwfetchcheck \"http://cvsweb.netbsd.org/bsdweb.cgi/~checkout~/src/usr.bin/vis/vis.1?rev=1.23\"    \"${cwdl}/${rname}/vis.1\"    \"eb201ef23852529006fd60616d4c5d34b50251af7e79fbeead90e7eba190e114\"
}
"

eval "
function cwextract_${rname}() {
  cwmkdir \"${rbdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  \${CC} -DLIBBSD_NETBSD_VIS -I${cwdl}/${rname} ${cwdl}/${rname}/{foldit,vis}.c -o vis \$(pkg-config --cflags --libs libbsd-overlay) -static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -s -m 0755 vis \"${ridir}/bin/\"
  install -m 0644 \"${cwdl}/${rname}/vis.1\" \"${ridir}/share/man/man1/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

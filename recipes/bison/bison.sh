#
# XXX - --enable-relocatable configure option?
#

rname="bison"
rver="3.5.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="2bf85b5f88a5f2fa8069aed2a2dfc3a9f8d15a97e59c713e3906e5fdd982a7c4"
rreqs="make m4 flex perl sed gawk"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"

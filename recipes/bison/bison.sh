#
# XXX - --enable-relocatable configure option?
#

rname="bison"
rver="3.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="6f3582cce1bb040fa09cfa238d6ee8643c03c79e34d0d203a7466b8cc1038efa"
rreqs="make m4 flex perl sed gawk"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"

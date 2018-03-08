rname="less"
rver="530"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="503f91ab0af4846f34f0444ab71c4b286123f0044a4964f1ae781486c617f2e2"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

# XXX - add -R for default pager?
eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'export PAGER=\"less -Q -L\"' >> \"${rprof}\"
  echo 'alias less=\"less -Q -L\"' >> \"${rprof}\"
}
"

#
# XXX - tmux-nodes.sh broke with tmux 3.4, tmux-local-nodes.sh
#
rname="tmuxmisc"
rver="master"
rdir="${rname//xm/x-m}-${rver}"
rfile="${rver}.zip"
rurl="https://github.com/ryanwoodsmall/${rname//xm/x-m}/archive/refs/heads/${rfile}"
rsha256=""
rreqs=""

. "${cwrecipe}/common.sh"

for f in clean configure make ; do
  eval "
  function cw${f}_${rname}() {
    true
  }
  "
done
unset f

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwextract_${rname}() {
  rm -rf \"${ridir}/${rdir}\" || true
  cwextract \"${rdlfile}\" \"${ridir}\"
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \"${ridir}/bin\"
  pushd \"${ridir}\" >/dev/null 2>&1
  local p
  for p in tmux-local-node.sh tmux-nodes.sh ; do
    ln -sf \"${rtdir}/current/${rdir}/bin/\${p}\" \"${ridir}/bin/\${p}\"
  done
  unset p
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

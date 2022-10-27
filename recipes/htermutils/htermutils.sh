#
# XXX - gitiles instance, sha256 inconsistent
# XXX - xclip wrapper for i.e. pass?
#

rname="htermutils"
rver="7caa0788bdf94c399092c069ab79aaf2874222f2"
rdir="${rname}-${rver}"
rfile="etc.tar.gz"
rurl="https://chromium.googlesource.com/apps/libapps/+archive/${rver}/hterm/${rfile}"
rsha256=""
rreqs=""

if ! command -v unzip &>/dev/null ; then
  rreqs="${rreqs} busybox"
fi

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  cwfetch \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}/\$(cwdir_${rname})\"
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local jstcopy=\"\$(cwidir_${rname})/bin/jstcopy\"
  mkdir -p \"\$(cwidir_${rname})/bin\"
  mkdir -p \"\$(cwidir_${rname})/share\"
  install -m 0755 *.sh \"\$(cwidir_${rname})/bin/\"
  install -m 0644 *.el *.vim \"\$(cwidir_${rname})/share/\"
  echo -n > \"\${jstcopy}\"
  echo '#!/usr/bin/env bash' > \"\${jstcopy}\"
  echo '# XXX - broken with tmux 3.3?' >> \"\${jstcopy}\"
  echo '# XXX - env TERM=tmux osc52.sh --force \"\${@}\"' >> \"\${jstcopy}\"
  echo 'test -z \"\${TMUX}\" || tmux set -s set-clipboard on &>/dev/null || true' >> \"\${jstcopy}\"
  echo 'env TMUX= TERM=vt100 osc52.sh --force \"\${@}\"' >> \"\${jstcopy}\"
  chmod 755 \"\${jstcopy}\"
  unset jstcopy
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

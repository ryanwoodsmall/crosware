#
# XXX - pcap is super iffy, particulary static, don't bother with it, use a tap/tun device
# XXX - is busybox necessary?
# XXX - github repo went, ah, something and started adding metadata to disk images
# XXX - http://simh.trailing-edge.com/ - 3.x branch updated by bob supnik 2022
# XXX - https://github.com/open-simh/simh - open fork
# XXX - https://github.com/simh/simh/issues/1059
# XXX - https://groups.io/g/simh/topic/new_license/91108560
# XXX - https://www.reddit.com/r/programming/comments/usv5nv/maintainer_of_open_source_emulation_software_simh/
#

rreqs="opensimh"
rname="simh"
rver="$(cwver_${rreqs%% .*})"
rdir="$(cwdir_${rreqs%% .*})"
rfile="/dev/null"
rurl="file:///dev/null"
rsha256=""

. "${cwrecipe}/common.sh"

for f in clean fetch extract configure make ; do
  eval "function cw${f}_${rname}() { true ; }"
done
unset f

eval "
function cwmakeinstall_${rname}() {
  local b t
  cwmkdir \"\$(cwidir_${rname})/bin\"
  rm -rf \"\$(cwidir_${rname})/share\"
  ln -sf \"${cwsw}/${rreqs%% .*}/current/share\" \"\$(cwidir_${rname})/share\"
  for b in \$(find \"${cwsw}/${rreqs%% .*}/current/bin/\" -type f) ; do
    t=\"\$(basename \${b})\"
    t=\"${rname}-\${t#${rreqs%% .*}-}\"
    t=\"\$(cwidir_${rname})/bin/\${t}\"
    ln -sf \"\${b}\" \"\${t}\"
  done
  unset b t
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

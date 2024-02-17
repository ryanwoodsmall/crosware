#
# XXX - this is an example function template that can be sourced
#
: ${rname:="fake"}
: ${rfuncname:="example"}
: ${rfuncbody:=": noop"}

eval "
function cw${rfuncname}_${rname}() {
  pushd \$(cwidir_${rname}) &>/dev/null
  ${rfuncbody}
  popd &>/dev/null
}
"

#
# XXX - this is an example function template that can be sourced
# XXX - this is explicitly for recipes - i.e., they need a valid cwbdir_${rname} function by default
# XXX - could use with cwprependfunc/cwappendfunc to programmatically programmatically
#
: ${rname:="fake"}
: ${rfuncname:="example"}
: ${rfuncbody:=": noop"}
: ${rdirtype:="b"}

eval "
function cw${rfuncname}_${rname}() {
  pushd \$(cw${rdirtype}dir_${rname}) &>/dev/null
  ${rfuncbody}
  popd &>/dev/null
}
"

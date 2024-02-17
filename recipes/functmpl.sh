#
# XXX - this is an example function template that can be sourced
# XXX - this is explicitly for recipes - i.e., they need a valid cwbdir_${rname} function by default
# XXX - could use with cwstubfunc/cwprependfunc/cwappendfunc to programmatically create functions
#
# example - must come after ${cwtop}/recipes/common.sh or custom cwinstall_${rname} function
# - build a custom directory type
# - build a hook function
# - insert hook into an existing function at the begining and end
#
#    rfuncname=extra
#    rfuncbody='echo hello from $(cwmyfuncname) ; pwd ; ls -la'
#    rdirtype=tmp
#    eval "function cwtmpdir_${rname}() { echo \${cwtop}/tmp ; }"
#    . ${cwtop}/recipes/functmpl.sh
#    cwprependfunc cwinstall_${rname} 'echo before' cw${rfuncname}_${rname}
#    cwappendfunc cwinstall_${rname} 'echo after' cw${rfuncname}_${rname}
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

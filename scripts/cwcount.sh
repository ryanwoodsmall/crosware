#!/usr/bin/env bash
#
# self-modifying function example
#
# XXX - started down this path...
# XXX - needs (self-referencing) template vars of some sort!
# function cwcount() {
#   local i=0
#   echo ${i}
#   eval "
#   function cwcount() {
#     local i=\$(cwcount)
#     echo \${i}
#     eval 'function cwcount() {
#   ...
#   }
#   "
# }
#
# another option would be "cwprependfunc blah 'echo ... ; return'
# templates too
# uggy
#
# these all get really ugly with nesting
# operate on the textual form of the function
# cheating (insider knowledge), but easier, faster, and perfectly valid
#

function cwcount() {
  local i=0
  echo ${i}
  ((i++))
  local -a fa
  readarray -t fa < <(declare -f "${FUNCNAME[0]}")
  fa[2]="local i=${i}"
  source /dev/stdin < <(for i in ${!fa[@]} ; do printf '%s\n' "${fa[${i}]}" ; done)
}

cwcount
cwcount
cwcount
cwcount
cwcount
cwcount
for i in {1..20} ; do cwcount ; done | paste -s -d ' ' -

# vim: set ft=bash:

rver="5.1.5"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv

rver="5.3.6"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="fc5fd69bb8736323f026672b1b7235da613d7177e72558893a0bdcd320466d60"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv

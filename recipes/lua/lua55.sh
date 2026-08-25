rver="5.5.1"
sv="${rver%.*}"
sv="${sv//./}"
rname="lua${sv}"
rsha256="1c4b4068d67061f2a2231ad2b5422e77acea1487ea9890f6320af614f4373dce"
. "${cwrecipe}/${rname%${sv}}/${rname%${sv}}.sh.common"
unset sv

rname="unzip"
rver="60"
rdir="${rname}${rver}"
rfile="${rdir}.tar.gz"
rurl="https://sourceforge.net/projects/infozip/files/UnZip%206.x%20%28latest%29/UnZip%206.0/${rfile}/download"
rsha256="036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
rreqs="make"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/info${rname##un}/info${rname##un}.sh.common"

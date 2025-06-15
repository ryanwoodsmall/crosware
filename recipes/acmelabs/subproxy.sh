#
# XXX - fork to only CONNECT, build in automatic http:// -> https:// protocol upgrade
# XXX - cryanc 'carl -p' proxy mode can do this too, i think? only 'GET http://...' style though
# XXX - combine this (or micro_proxy) with microsocks and front with sslh. ssl with socat? or nc?
# XXX - C -> header file conversion for html templates w/(f|)printf
#
rname="subproxy"
rsha256="ec2243629892d8901160ea33f40719153c29e6afff967f17b0303cf54114ab76"
. "${cwrecipe}/acmelabs/acmelabs.sh.common"

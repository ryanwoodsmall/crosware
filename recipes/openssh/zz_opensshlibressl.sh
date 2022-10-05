#
# XXX - odd crash in sshbuf_free->explicit_bzero->memset with openssh portable 8.9/9.0/9.1/... on libressl 3.5.3
# XXX - doesn't seem related to musl version? 1.1.x, 1.2.1 w/oldmalloc, 1.2.3 w/mallocng all crash
#
# gdb...
#   Program received signal SIGSEGV, Segmentation fault.
#   memset () at src/string/x86_64/memset.s:55
#   55      src/string/x86_64/memset.s: No such file or directory.
#   (gdb) bt
#   #0  memset () at src/string/x86_64/memset.s:55
#   #1  0x00000000005da10e in explicit_bzero (d=<optimized out>, n=<optimized out>) at src/string/explicit_bzero.c:6
#   #2  0x00000000004325cd in sshbuf_free (buf=0x8c98a0) at sshbuf.c:166
#   #3  0x000000000045a7f7 in ssh_packet_close_internal (ssh=0x8c8240, do_close=1) at packet.c:598
#   #4  0x000000000045ab72 in ssh_packet_close (ssh=0x8c8240) at packet.c:653
#   #5  0x0000000000406316 in main (ac=0, av=0x8ab058) at ssh.c:1704
#

rname="opensshlibressl"
rver="$(cwver_openssh)"
rdir="$(cwdir_openssh)"
rfile="$(cwfile_openssh)"
rdlfile="$(cwdlfile_openssh)"
rurl="$(cwurl_openssh)"
rsha256=""

sslprov="libressl"

. "${cwrecipe}/${rname%${sslprov}}/${rname%${sslprov}}.sh.common"

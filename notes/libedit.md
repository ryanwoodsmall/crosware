with musl, **libedit** needs a definition in its ```CFLAGS```:

```
-D__STDC_ISO_10646__=201103L
```

from: http://lists.busybox.net/pipermail/buildroot/2016-January/149100.html

error in question on compilation with musl gcc is: ```"error: #error wchar_t must store ISO 10646 characters"```

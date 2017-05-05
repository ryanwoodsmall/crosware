Chrome OS has /tmp mounted noexec.

This breaks Jython installation.

Need to investigate:

- remounting /tmp w/exec (requires passwordless sudo)
- set TMPDIR/TMP/TEMPDIR/TMP to /usr/local/...
- use _JAVA_OPTIONS/JAVA_TOOL_OPTIONS to set java.io.tmpdir

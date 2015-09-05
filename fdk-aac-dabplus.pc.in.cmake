prefix=@LIBFDK-AAC_PC_PREFIX@
exec_prefix=@LIBFDK-AAC_PC_EXEC_PREFIX@
libdir=@LIBFDK-AAC_PC_LIBDIR@
includedir=@LIBFDK-AAC_PC_INCLUDEDIR@

Name: Fraunhofer FDK AAC Codec Library with DAB+ Encoder
Description: AAC codec library with DAB+ Encoder
Version: @LIBFDK-AAC_PC_VERSION@
URL: http://opendigitalradio.org
Cflags: -I${includedir}/fdk-aac @LIBFDK-AAC_PC_CFLAGS@
Libs: -L${libdir}/ @LIBFDK-AAC_PC_LIBS@
Libs.private: @LIBFDK-AAC_PC_PRIV_LIBS@

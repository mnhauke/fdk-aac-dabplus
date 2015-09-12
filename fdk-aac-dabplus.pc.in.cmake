prefix=@LIBFDK-AAC-DABPLUS_PC_PREFIX@
exec_prefix=@LIBFDK-AAC-DABPLUS_PC_EXEC_PREFIX@
libdir=@LIBFDK-AAC-DABPLUS_PC_LIBDIR@
includedir=@LIBFDK-AAC-DABPLUS_PC_INCLUDEDIR@

Name: Fraunhofer FDK AAC Codec Library with DAB+ Encoder
Description: AAC codec library with DAB+ Encoder
Version: @LIBFDK-AAC-DABPLUS_PC_VERSION@
URL: http://opendigitalradio.org
Cflags: -I${includedir}/fdk-aac @LIBFDK-AAC-DABPLUS_PC_CFLAGS@
Libs: -L${libdir}/ @LIBFDK-AAC-DABPLUS_PC_LIBS@
Libs.private: @LIBFDK-AAC-DABPLUS_PC_PRIV_LIBS@

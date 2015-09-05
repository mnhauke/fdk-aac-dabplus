########################################################################
# Project setup
########################################################################
cmake_minimum_required(VERSION 2.8)
project(fdk-aac-dabplus C CXX)

# Select the release build type by default to get optimization flags
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
    message(STATUS "Build type not specified: defaulting to release.")
endif(NOT CMAKE_BUILD_TYPE)
set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)

if(NOT LIB_INSTALL_DIR)
    set(LIB_INSTALL_DIR lib)
endif()


########################################################################
# Version information
########################################################################
set(VERSION_INFO_MAJOR  0)
set(VERSION_INFO_MINOR  0)
set(VERSION_INFO_PATCH  0)

if(NOT DEFINED VERSION_INFO_EXTRA)
    set(VERSION_INFO_EXTRA "git")
endif()
include(Version)

if(NOT DEFINED VERSION)
    #set(VERSION "\"${VERSION_INFO_MAJOR}.${VERSION_INFO_MINOR}.${VERSION_INFO_PATCH}\"")
    set(VERSION "\"${VERSION_INFO}\"")
endif()

set(SOVERSION "0.0.4")

set(GITVERSION "\"${VERSION_INFO}\"")
set(PACKAGE_VERSION "\"${VERSION_INFO}\"")
set(PACKAGE_NAME "\"fdk-aac-dabplus\"")
set(PACKAGE "\"fdk-aac-dabplus\"")

#add_definitions(-DVERSION="${VERSION_INFO}")
#add_definitions(-DGITVERSION="${VERSION_INFO}")
#add_definitions(-DPACKAGE="fdk-aac-dabplus")
#add_definitions(-DPACKAGE_NAME="fdk-aac-dabplus")


########################################################################
# Compiler specific setup
########################################################################
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANGCXX)
    add_definitions(-Wall)
    add_definitions(-std=c++11)
    add_definitions(-Wno-narrowing)
    add_definitions(-fno-exceptions)
    add_definitions(-fno-rtti)
    add_definitions(-Wno-unused-parameter)
    add_definitions(-Wno-unused)
endif()


########################################################################
# Find build dependencies
########################################################################
find_package(PkgConfig)
# threads
find_package(Threads REQUIRED)
# libzmq
pkg_check_modules(ZMQ libzmq>=4.0 REQUIRED)
# fec
pkg_check_modules(FEC libfec)
# libjack
pkg_check_modules(JACK jack)
# libvlc
pkg_check_modules(VLC libvlc)
# MagickWand
pkg_check_modules(MAGICKWAND MagickWand)
#include_directories(${MAGICKWAND_INCLUDE_DIRS})
# alsa
find_package(ALSA)


########################################################################
# Options
########################################################################

# TODO


########################################################################
# config.h
########################################################################
add_definitions(-DHAVE_CONFIG_H)

# Checks for functions
include(CheckFunctionExists)
check_function_exists("clock_gettime"      HAVE_CLOCK_GETTIME)

configure_file ("${PROJECT_SOURCE_DIR}/cmakeconfig.h.in" "${PROJECT_BINARY_DIR}/config.h" )
include_directories(${PROJECT_BINARY_DIR})


########################################################################
# Setup apps
########################################################################
include_directories(
    ${CMAKE_SOURCE_DIR}/libAACdec/include
    ${CMAKE_SOURCE_DIR}/libAACenc/include
    ${CMAKE_SOURCE_DIR}/libSBRdec/include
    ${CMAKE_SOURCE_DIR}/libSBRenc/include
    ${CMAKE_SOURCE_DIR}/libMpegTPDec/include
    ${CMAKE_SOURCE_DIR}/libMpegTPEnc/include
    ${CMAKE_SOURCE_DIR}/libSYS/include
    ${CMAKE_SOURCE_DIR}/libFDK/include
    ${CMAKE_SOURCE_DIR}/libPCMutils/include
    )

# dabplus-enc
list(APPEND dabplus_enc_SOURCES
    src/dabplus-enc.cpp
    src/FileInput.cpp
    src/AlsaInput.cpp
    src/JackInput.cpp
    src/VLCInput.cpp
    src/encryption.c
    src/zmq.hpp
    src/utils.c
    src/wavreader.c
    )


# mot-encoder
list(APPEND mot_encoder_SOURCES
    src/mot-encoder.cpp
    contrib/lib_crc.c
    )


list(APPEND AACDEC_SRC
    libAACdec/src/aacdec_drc.cpp
    libAACdec/src/aacdec_hcr.cpp
    libAACdec/src/aacdecoder.cpp
    libAACdec/src/aacdec_pns.cpp
    libAACdec/src/aac_ram.cpp
    libAACdec/src/block.cpp
    libAACdec/src/channelinfo.cpp
    libAACdec/src/ldfiltbank.cpp
    libAACdec/src/rvlcbit.cpp
    libAACdec/src/rvlc.cpp
    libAACdec/src/aacdec_hcr_bit.cpp
    libAACdec/src/aacdec_hcrs.cpp
    libAACdec/src/aacdecoder_lib.cpp
    libAACdec/src/aacdec_tns.cpp
    libAACdec/src/aac_rom.cpp
    libAACdec/src/channel.cpp
    libAACdec/src/conceal.cpp
    libAACdec/src/pulsedata.cpp
    libAACdec/src/rvlcconceal.cpp
    libAACdec/src/stereo.cpp
    )

list(APPEND AACENC_SRC
    libAACenc/src/aacenc.cpp
    libAACenc/src/aacEnc_ram.cpp
    libAACenc/src/band_nrg.cpp
    libAACenc/src/block_switch.cpp
    libAACenc/src/grp_data.cpp
    libAACenc/src/metadata_main.cpp
    libAACenc/src/pre_echo_control.cpp
    libAACenc/src/quantize.cpp
    libAACenc/src/tonality.cpp
    libAACenc/src/aacenc_hcr.cpp
    libAACenc/src/aacEnc_rom.cpp
    libAACenc/src/bandwidth.cpp
    libAACenc/src/channel_map.cpp
    libAACenc/src/intensity.cpp
    libAACenc/src/ms_stereo.cpp
    libAACenc/src/psy_configuration.cpp
    libAACenc/src/sf_estim.cpp
    libAACenc/src/transform.cpp
    libAACenc/src/aacenc_lib.cpp
    libAACenc/src/aacenc_tns.cpp
    libAACenc/src/bit_cnt.cpp
    libAACenc/src/chaosmeasure.cpp
    libAACenc/src/line_pe.cpp
    libAACenc/src/noisedet.cpp
    libAACenc/src/psy_main.cpp
    libAACenc/src/spreading.cpp
    libAACenc/src/aacenc_pns.cpp
    libAACenc/src/adj_thr.cpp
    libAACenc/src/bitenc.cpp
    libAACenc/src/dyn_bits.cpp
    libAACenc/src/metadata_compressor.cpp
    libAACenc/src/pnsparam.cpp
    libAACenc/src/qc_main.cpp
    )

list(APPEND FDK_SRC
    libFDK/src/autocorr2nd.cpp
    libFDK/src/dct.cpp
    libFDK/src/FDK_bitbuffer.cpp
    libFDK/src/FDK_core.cpp
    libFDK/src/FDK_crc.cpp
    libFDK/src/FDK_hybrid.cpp
    libFDK/src/FDK_tools_rom.cpp
    libFDK/src/FDK_trigFcts.cpp
    libFDK/src/fft.cpp
    libFDK/src/fft_rad2.cpp
    libFDK/src/fixpoint_math.cpp
    libFDK/src/mdct.cpp
    libFDK/src/qmf.cpp
    libFDK/src/scale.cpp
    )

list(APPEND MPEGTPDEC_SRC
    libMpegTPDec/src/tpdec_adif.cpp
    libMpegTPDec/src/tpdec_adts.cpp
    libMpegTPDec/src/tpdec_asc.cpp
    libMpegTPDec/src/tpdec_latm.cpp
    libMpegTPDec/src/tpdec_lib.cpp
    )

list(APPEND MPEGTPENC_SRC
    libMpegTPEnc/src/tpenc_adif.cpp
    libMpegTPEnc/src/tpenc_adts.cpp
    libMpegTPEnc/src/tpenc_asc.cpp
    libMpegTPEnc/src/tpenc_dab.cpp
    libMpegTPEnc/src/tpenc_latm.cpp
    libMpegTPEnc/src/tpenc_lib.cpp
    )

list(APPEND PCMUTILS_SRC
    libPCMutils/src/pcmutils_lib.cpp
    )

list(APPEND SBRDEC_SRC
    libSBRdec/src/env_calc.cpp
    libSBRdec/src/env_dec.cpp
    libSBRdec/src/env_extr.cpp
    libSBRdec/src/huff_dec.cpp
    libSBRdec/src/lpp_tran.cpp
    libSBRdec/src/psbitdec.cpp
    libSBRdec/src/psdec.cpp
    libSBRdec/src/psdec_hybrid.cpp
    libSBRdec/src/sbr_crc.cpp
    libSBRdec/src/sbr_deb.cpp
    libSBRdec/src/sbr_dec.cpp
    libSBRdec/src/sbrdec_drc.cpp
    libSBRdec/src/sbrdec_freq_sca.cpp
    libSBRdec/src/sbrdecoder.cpp
    libSBRdec/src/sbr_ram.cpp
    libSBRdec/src/sbr_rom.cpp
    )

list(APPEND SBRENC_SRC
    libSBRenc/src/bit_sbr.cpp
    libSBRenc/src/env_bit.cpp
    libSBRenc/src/fram_gen.cpp
    libSBRenc/src/mh_det.cpp
    libSBRenc/src/ps_bitenc.cpp
    libSBRenc/src/ps_encode.cpp
    libSBRenc/src/resampler.cpp
    libSBRenc/src/sbr_encoder.cpp
    libSBRenc/src/sbr_ram.cpp
    libSBRenc/src/ton_corr.cpp
    libSBRenc/src/code_env.cpp
    libSBRenc/src/env_est.cpp
    libSBRenc/src/invf_est.cpp
    libSBRenc/src/nf_est.cpp
    libSBRenc/src/ps_main.cpp
    libSBRenc/src/sbrenc_freq_sca.cpp
    libSBRenc/src/sbr_misc.cpp
    libSBRenc/src/sbr_rom.cpp
    libSBRenc/src/tran_det.cpp
    )

list(APPEND SYS_SRC
    libSYS/src/cmdl_parser.cpp
    libSYS/src/conv_string.cpp
    libSYS/src/genericStds.cpp
    libSYS/src/wav_file.cpp
    )

# libfdk_aac
list(APPEND libfdk_aac_SOURCES
    ${AACDEC_SRC}
    ${AACENC_SRC}
    ${MPEGTPDEC_SRC}
    ${MPEGTPENC_SRC}
    ${SBRDEC_SRC}
    ${SBRENC_SRC}
    ${PCMUTILS_SRC}
    ${FDK_SRC}
    ${SYS_SRC}
    )

list(APPEND libfdk_aac_include_HEADERS
    libSYS/include/machine_type.h
    libSYS/include/genericStds.h
    libSYS/include/FDK_audio.h
    libAACenc/include/aacenc_lib.h
    libAACdec/include/aacdecoder_lib.h
    )


################################################################################
# Generate pkg-config file
################################################################################
foreach(inc ${LIBFDK-AAC_INCLUDE_DIR})
    list(APPEND LIBFDK-AAC_PC_CFLAGS "-I${inc}")
endforeach()

foreach(lib ${LIBFDK-AAC_LIBRARY_DIRS})
    list(APPEND LIBFDK-AAC_PC_PRIV_LIBS "-L${lib}")
endforeach()

set(LIBFDK-AAC_PC_PREFIX ${CMAKE_INSTALL_PREFIX})
set(LIBFDK-AAC_PC_EXEC_PREFIX \${prefix})
set(LIBFDK-AAC_PC_LIBDIR \${exec_prefix}/${LIB_INSTALL_DIR})
set(LIBFDK-AAC_PC_INCLUDEDIR \${prefix}/include/fdk-aac)
set(LIBFDK-AAC_PC_VERSION ${VERSION})
set(LIBFDK-AAC_PC_LIBS "-lfdk-aac")

# Use space-delimiter in the .pc file, rather than CMake's semicolon separator
string(REPLACE ";" " " LIBFDK-AAC_PC_CFLAGS "${LIBFDK-AAC_PC_CFLAGS}")
string(REPLACE ";" " " LIBFDK-AAC_PC_LIBS "${LIBFDK-AAC_PC_LIBS}")

# Unset these to avoid hard-coded paths in a cross-environment
if(CMAKE_CROSSCOMPILING)
    unset(LIBFDK-AAC_PC_CFLAGS)
    unset(LIBFDK-AAC_PC_LIBS)
endif()

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/fdk-aac-dabplus.pc.in.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/fdk-aac-dabplus.pc
    @ONLY
)

install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/fdk-aac-dabplus.pc
    DESTINATION ${LIB_INSTALL_DIR}/pkgconfig/
)


########################################################################
# Setup apps and libraries
########################################################################
add_library(libfdk_aac_shared SHARED ${libfdk_aac_SOURCES})
set_target_properties(libfdk_aac_shared PROPERTIES OUTPUT_NAME fdk-aac)
set_target_properties(libfdk_aac_shared PROPERTIES SOVERSION ${SOVERSION})

# FIXME - properly export symbols
# set_target_properties(libfdk_aac_shared PROPERTIES LINK_FLAGS "-export-symbols ${CMAKE_SOURCE_DIR}/fdk-aac.sym")

install(TARGETS libfdk_aac_shared
    DESTINATION lib)

install(FILES ${libfdk_aac_include_HEADERS}
    DESTINATION include/fdk-aac)


## mot-encoder
#include_directories(${CMAKE_SOURCE_DIR}/contrib)
##set_source_files_properties(${mot_encoder_SOURCES} PROPERTIES LANGUAGE "CXX")
#add_executable(mot-encoder ${mot_encoder_SOURCES})
#target_link_libraries(mot-encoder ${MAGICKWAND_LIBRARIES})
#
##add_executable(dabplus-enc ${dabplus_enc_SOURCES})
###target_link_libraries(dabplus-enc)
##
#install(TARGETS
#    mot-encoder
#    dabplus-enc
#    DESTINATION bin)


########################################################################
# Create uninstall target
########################################################################
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)


########################################################################
# Print Summary
########################################################################
message(STATUS "")
message(STATUS "##########################################################")
message(STATUS "## Building version: ${VERSION}")
message(STATUS "## Using install prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "##########################################################")
message(STATUS "")


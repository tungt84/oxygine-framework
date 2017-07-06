cmake_minimum_required (VERSION 2.6)
project (OXYGINE)


set(OX_HAVE_LIBJPEG 0)
set(OX_HAVE_LIBPNG 0)
set(OX_HAVE_LIBCURL 0)
set(OX_HAVE_HTTP 0)
set(OX_USE_SDL2 1)


find_package(OpenGL)

if (EMSCRIPTEN)
	#don't need SDL2
elseif (WIN32)	
	#hardcoded path to SDL2 on windows
	set(SDL2_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/../SDL/include)
else(WIN32)
	find_path(SDL2_INCLUDE_DIRS NAMES SDL2/SDL.h)
	message(STATUS ${SDL2_INCLUDE_DIRS_FOUND})

	if (SDL2_INCLUDE_DIRS)		
		set(SDL2_INCLUDE_DIRS ${SDL2_INCLUDE_DIRS}/SDL2)
		message(STATUS "found")		
	else()
		message(STATUS "SDL not found")
		set(SDL2_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/../SDL/include)					
	endif()

	find_package(CURL)
endif(EMSCRIPTEN)


set(OXYGINE_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/oxygine)
set(OXYGINE_SRC ${OXYGINE_ROOT}/src)

set(FOLDERS src src/closure src/minizip src/core
			src/core/gl src/dev_tools src/minizip 
			src/math src/pugixml src/json src/res 
			src/text_utils src/utils src/winnie_alloc)


if (EMSCRIPTEN)
	set(PLATFORM emscripten)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux") 	
	set(PLATFORM linux)
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
	set(PLATFORM ios)
elseif(MSVC)
	set(PLATFORM win32)
elseif(MINGW)	
	set(PLATFORM win32_mingw)
endif()


set(THIRD_PARTY ${OXYGINE_ROOT}/third_party/${PLATFORM})



if (EMSCRIPTEN)
	set(OX_HAVE_LIBPNG 1)
	set(OX_HAVE_HTTP 1)	
	set(OX_USE_SDL2 1)

	set(SOURCES ${OXYGINE_SRC}/core/emscripten/HttpRequestEmscriptenTask.cpp)


	file(GLOB OXYGINE_JS_LIBRARIES ${OXYGINE_SRC}/core/emscripten/*.js)

	set(OXYGINE_CXX_FLAGS "${OXYGINE_CXX_FLAGS} -s USE_SDL=2 -s USE_LIBPNG=1 -s USE_ZLIB=1 -s FULL_ES2=1 ")	
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -s USE_ZLIB=1")#for minizip.c

elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux") 	
	
	set(OX_HAVE_LIBJPEG 1)
	set(OX_HAVE_LIBPNG 1)

elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
elseif(MSVC)

	set(OX_HAVE_LIBJPEG 1)
	set(OX_HAVE_LIBPNG 1)	
	set(OX_HAVE_LIBCURL 1)
	set(OX_HAVE_HTTP 1)

	set(libprefix lib)

	set(OX_DEFINITIONS	${OX_DEFINITIONS} -D_CRT_SECURE_NO_WARNINGS)

elseif(MINGW)	

	set(libprefix lib)

	set(OX_HAVE_LIBPNG 1)	
	set(OX_HAVE_LIBCURL 1)
	set(OX_HAVE_HTTP 1)

endif()

if (OX_HAVE_LIBCURL)	
	set(FOLDERS ${FOLDERS} src/core/curl)
	include_directories(${THIRD_PARTY}/curl/)
	set(OX_DEFINITIONS ${OX_DEFINITIONS} -DOX_HAVE_LIBCURL)
endif(OX_HAVE_LIBCURL)	



if (NOT OX_HAVE_HTTP)
	set(OX_DEFINITIONS ${OX_DEFINITIONS} -DOX_NO_HTTP)
endif(NOT OX_HAVE_HTTP)

if (EMSCRIPTEN)
	set(OX_DEFINITIONS ${OX_DEFINITIONS} -DOX_NO_MT)
endif(EMSCRIPTEN)

foreach(ITEM ${FOLDERS})
	file(GLOB FLS
		${OXYGINE_ROOT}/${ITEM}/*.cpp
		${OXYGINE_ROOT}/${ITEM}/*.c
		${OXYGINE_ROOT}/${ITEM}/*.h)
	set(SOURCES ${SOURCES} ${FLS})	
	string(REPLACE / \\ SGROUP ${ITEM})
	source_group(${SGROUP} FILES ${FLS})
endforeach(ITEM)


set(OXYGINE_INCLUDE_DIRS 
	${OXYGINE_SRC}
	${THIRD_PARTY}/pthreads/include/
	${THIRD_PARTY}/zlib)


set(OXYGINE_LIBRARY_DIRS
	${OXYGINE_LIBRARY_DIRS}
	${OXYGINE_SOURCE_DIR}/libs
	${THIRD_PARTY}/libraries)

if(TIZEN)
set(OXYGINE_INCLUDE_DIRS 
	${OXYGINE_INCLUDE_DIRS}
	${OXYGINE_ROOT}/third_party/tizen/libpng/include
	${OXYGINE_ROOT}/third_party/tizen/libjpeg/include
	${CMAKE_SYSROOT}/usr/include/evas-1
	${CMAKE_SYSROOT}/usr/include/efl-1
	${CMAKE_SYSROOT}/usr/include/eina-1/eina
	${CMAKE_SYSROOT}/usr/include/eina-1
	${CMAKE_SYSROOT}/usr/include/eo-1
	${CMAKE_SYSROOT}/usr/include/emile-1
	${CMAKE_SYSROOT}/usr/include/appfw
	${CMAKE_SYSROOT}/usr/include/elementary-1
	${CMAKE_SYSROOT}/usr/include/eet-1
	${CMAKE_SYSROOT}/usr/include/ecore-1
	${CMAKE_SYSROOT}/usr/include/ecore-evas-1
	${CMAKE_SYSROOT}/usr/include/ecore-file-1
	${CMAKE_SYSROOT}/usr/include/ecore-input-1
	${CMAKE_SYSROOT}/usr/include/ecore-imf-1
	${CMAKE_SYSROOT}/usr/include/ecore-con-1
	${CMAKE_SYSROOT}/usr/include/edje-1
	${CMAKE_SYSROOT}/usr/include/eldbus-1
	${CMAKE_SYSROOT}/usr/include/efreet-1
	${CMAKE_SYSROOT}/usr/include/ethumb-client-1
	${CMAKE_SYSROOT}/usr/include/ethumb-1
	${CMAKE_SYSROOT}/usr/include/system
	${CMAKE_SYSROOT}/usr/include/efl-extension
	${CMAKE_SYSROOT}/usr/include/dlog)

set(OXYGINE_LIBRARY_DIRS
	${OXYGINE_LIBRARY_DIRS}
	${OXYGINE_ROOT}/third_party/tizen/libpng/lib
	${OXYGINE_ROOT}/third_party/tizen/libjpeg/lib
	${CMAKE_SYSROOT}/usr/lib)
set(OX_DEFINITIONS
	${OX_DEFINITIONS}
	-DTIZEN)

set(CORE_LIBS 
	${CORE_LIBS} 
	BrokenLocale accounts-svc anl appcore-agent attach-panel badge base-utils-i18n bundle cairo calendar-service2 capi-appfw-alarm capi-appfw-app-common capi-appfw-app-control capi-appfw-application capi-appfw-app-manager capi-appfw-event capi-appfw-package-manager capi-appfw-preference capi-appfw-widget-application capi-base-common capi-content-media-content capi-content-mime-type capi-geofence-manager capi-maps-service capi-media-audio-io capi-media-camera capi-media-codec capi-media-controller capi-mediademuxer capi-media-image-util capi-media-metadata-editor capi-media-metadata-extractor capi-mediamuxer capi-media-player capi-media-radio capi-media-recorder capi-media-screen-mirroring capi-media-sound-manager capi-media-streamer capi-media-streamrecorder capi-media-thumbnail-util capi-media-tone-player capi-media-tool capi-media-video-util capi-media-vision capi-media-wav-player capi-messaging-email capi-messaging-messages capi-network-bluetooth capi-network-connection capi-network-http capi-network-mtp capi-network-nfc capi-network-smartcard capi-network-wifi-manager capi-network-wifi capi-system-device capi-system-info capi-system-media-key capi-system-runtime-info capi-system-sensor capi-system-system-settings capi-system-usbhost capi-telephony capi-ui-efl-util capi-ui-inputmethod-manager capi-ui-inputmethod capi-vpnsvc capi-web-url-download cbhm chromium-ewk cidn contacts-service2 context core-context-manager core-sync-client crypto crypt c csr-client curl dali-adaptor dali-core dali-toolkit data-control dlog dl dpm ebluez econnman0_7x ecore_buffer ecore_con ecore_evas ecore_file ecore_imf_evas ecore_imf ecore_input_evas ecore_input ecore_ipc ecore edbus edje eet efl-extension efreet_mime efreet efreet_trash ehal eina eio eldbus elementary embryo enotify eofono eom eo ethumb_client ethumb eukit evas exif feedback fido-client fontconfig freetype gio-2.0 glib-2.0 gmodule-2.0 gobject-2.0 gthread-2.0 harfbuzz-icu harfbuzz iotcon json-glib-1.0 key-manager-client message-port minicontrol-provider minicontrol-viewer minizip m notification nsd-dns-sd nsd-ssdp nsl nss_compat nss_dns nss_files nss_hesiod nss_nisplus nss_nis oauth2 oauth openal phonenumber-utils privilege-info pthread push resolv rt service-adaptor-client shortcut sqlite3 ssl storage stt_engine stt tbm thread_db ttrace tts_engine tts tzsh_common tzsh_quickpanel ui-viewmgr util vc-elm vc widget_service widget_viewer_dali widget_viewer_evas wifi-direct xml2 yaca)	
endif()


if (FORCE_GLES)
	set(OPENGL_LIBRARIES libGLESv2.lib)
endif(FORCE_GLES)


if (MINGW) 
	set(CORE_LIBS ${CORE_LIBS}	mingw32)
endif(MINGW)


set(CORE_LIBS 
	${CORE_LIBS}
	oxygine-framework	
	${OPENGL_LIBRARIES}		
)


if (OX_USE_SDL2)
	set(CORE_LIBS ${CORE_LIBS}
		SDL2main SDL2)
	set(OXYGINE_INCLUDE_DIRS ${OXYGINE_INCLUDE_DIRS} ${SDL2_INCLUDE_DIRS})
endif(OX_USE_SDL2)	


if (WIN32)
	set(CORE_LIBS ${CORE_LIBS}
		pthreadVCE2
		libcurl_imp
		ws2_32)
elseif(EMSCRIPTEN)	
else(WIN32)
	set(CORE_LIBS ${CORE_LIBS} pthread)
endif(WIN32)



if (OX_HAVE_LIBPNG)		
	set(OX_DEFINITIONS	${OX_DEFINITIONS} -DOX_HAVE_LIBPNG)

	if (EMSCRIPTEN)
		
	else(EMSCRIPTEN)

		include_directories(${THIRD_PARTY}/libpng)
		set(LIBPNG ${libprefix}png)

		if (MSVC)		
			if(NOT (MSVC_VERSION LESS 1900))
				set(LIBPNG ${LIBPNG}-2015)
			endif()
		endif()		
	
		set(CORE_LIBS ${CORE_LIBS} ${LIBPNG})

	endif(EMSCRIPTEN)

endif(OX_HAVE_LIBPNG)


if (OX_HAVE_LIBJPEG)	
	set(OX_DEFINITIONS	${OX_DEFINITIONS} -DOX_HAVE_LIBJPEG)
	include_directories(${THIRD_PARTY}/libjpeg)
	set(LIBJPEG ${libprefix}jpeg)
	
	if (MSVC)
		if(NOT (MSVC_VERSION LESS 1900))
			set(LIBJPEG ${LIBJPEG}-2015)
		endif()	
	endif()

	set(CORE_LIBS ${CORE_LIBS} ${LIBJPEG})
endif(OX_HAVE_LIBJPEG)


if (NOT EMSCRIPTEN)
	set(CORE_LIBS ${CORE_LIBS}
		${libprefix}z${libprefix})
endif(NOT EMSCRIPTEN)


if (NOT MSVC)
	set(OXYGINE_CXX_FLAGS "${OXYGINE_CXX_FLAGS} -std=c++11 ")
endif(NOT MSVC)

set(CMAKE_CXX_FLAGS ${OXYGINE_CXX_FLAGS})

add_definitions(${OX_DEFINITIONS})
include_directories(${OXYGINE_INCLUDE_DIRS})
add_library(oxygine-framework STATIC ${SOURCES})


set(OXYGINE_LIBRARY_DIRS
	${OXYGINE_LIBRARY_DIRS}
	PARENT_SCOPE)

set(OXYGINE_CORE_LIBS	
	${CORE_LIBS} 
	PARENT_SCOPE)

set(OXYGINE_DEFINITIONS
	${OX_DEFINITIONS}
	PARENT_SCOPE)

set(OXYGINE_INCLUDE_DIRS
	${OXYGINE_INCLUDE_DIRS}
	PARENT_SCOPE)

set(OXYGINE_JS_LIBRARIES
	${OXYGINE_JS_LIBRARIES}
	PARENT_SCOPE)

set(OXYGINE_CXX_FLAGS
	${OXYGINE_CXX_FLAGS}
	PARENT_SCOPE)



message(STATUS "SDL includes: ${SDL2_INCLUDE_DIRS}")
message(STATUS "Libs:     ${CORE_LIBS}")
message(STATUS "Platform: ${PLATFORM}")

set(CMAKE_INSTALL_PREFIX ../libs)
install(TARGETS oxygine-framework CONFIGURATIONS Debug DESTINATION ./debug)
install(TARGETS oxygine-framework CONFIGURATIONS Release DESTINATION ./release)

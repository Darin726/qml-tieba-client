#############################################################################
# Makefile for building: tbclient
# Generated by qmake (2.01a) (Qt 4.7.4) on: ?? ??? 18 00:10:36 2012
# Project:  tbclient.pro
# Template: app
# Command: e:\application\qtsdk\symbian\sdks\symbiansr1qt474\bin\qmake.exe -spec ..\..\..\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\mkspecs\symbian-sbsv2 CONFIG+=release -after  OBJECTS_DIR=obj MOC_DIR=moc UI_DIR=ui RCC_DIR=rcc -o bld.inf tbclient.pro
#############################################################################

MAKEFILE          = Makefile
QMAKE             = e:\application\qtsdk\symbian\sdks\symbiansr1qt474\bin\qmake.exe
DEL_FILE          = del /q 2> NUL
DEL_DIR           = rmdir
CHK_DIR_EXISTS    = if not exist
MKDIR             = mkdir
MOVE              = move
DEBUG_PLATFORMS   = winscw gcce armv5 armv6
RELEASE_PLATFORMS = gcce armv5 armv6
MAKE              = make
SBS               = sbs

DEFINES	 = -DSYMBIAN -DUNICODE -DQT_KEYPAD_NAVIGATION -DQT_SOFTKEYS_ENABLED -DQT_USE_MATH_H_FLOATS -DVER="\"0.7.6\"" -DQ_COMPONENTS_SYMBIAN -DHAVE_MOBILITY -DQT_NO_DEBUG -DQT_DECLARATIVE_LIB -DQT_WEBKIT_LIB -DQT_GUI_LIB -DQT_NETWORK_LIB -DQT_CORE_LIB
INCPATH	 =  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/include/QtCore"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/include/QtNetwork"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/include/QtGui"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/include/QtWebKit"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/include/QtDeclarative"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/include"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/mkspecs/common/symbian"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/stdapis"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/stdapis/sys"  -I"E:/QtProject/tbclient/symbian3/qmlapplicationviewer"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/mw"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/platform/mw"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/platform"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/platform/loc"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/platform/mw/loc"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/platform/loc/sc"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/platform/mw/loc/sc"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/include/stdapis/stlportv5"  -I"E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/include/QtXmlPatterns"  -I"E:/QtProject/tbclient/symbian3/moc"  -I"E:/QtProject/tbclient/symbian3"  -I"E:/QtProject/tbclient/symbian3/rcc"  -I"E:/QtProject/tbclient/symbian3/ui" 
first: default

all: debug release

default: debug-winscw
qmake:
	$(QMAKE) "E:/QtProject/tbclient/symbian3/tbclient.pro"  -spec ..\..\..\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\mkspecs\symbian-sbsv2 CONFIG+=release -after  OBJECTS_DIR=obj MOC_DIR=moc UI_DIR=ui RCC_DIR=rcc

bld.inf: E:/QtProject/tbclient/symbian3/tbclient.pro
	$(QMAKE) "E:/QtProject/tbclient/symbian3/tbclient.pro"  -spec ..\..\..\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\mkspecs\symbian-sbsv2 CONFIG+=release -after  OBJECTS_DIR=obj MOC_DIR=moc UI_DIR=ui RCC_DIR=rcc

e:\QtProject\tbclient\symbian3\tbclient.loc: 
	$(QMAKE) "E:/QtProject/tbclient/symbian3/tbclient.pro"  -spec ..\..\..\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\mkspecs\symbian-sbsv2 CONFIG+=release -after  OBJECTS_DIR=obj MOC_DIR=moc UI_DIR=ui RCC_DIR=rcc

debug: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c winscw_udeb.mwccinc -c arm.v5.udeb.gcce4_4_1 -c arm.v6.udeb.gcce4_4_1
clean-debug: bld.inf
	$(SBS) reallyclean --toolcheck=off -c winscw_udeb.mwccinc -c arm.v5.udeb.gcce4_4_1 -c arm.v6.udeb.gcce4_4_1
freeze-debug: bld.inf
	$(SBS) freeze -c winscw_udeb.mwccinc -c arm.v5.udeb.gcce4_4_1 -c arm.v6.udeb.gcce4_4_1
release: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c arm.v5.urel.gcce4_4_1 -c arm.v6.urel.gcce4_4_1
clean-release: bld.inf
	$(SBS) reallyclean --toolcheck=off -c arm.v5.urel.gcce4_4_1 -c arm.v6.urel.gcce4_4_1
freeze-release: bld.inf
	$(SBS) freeze -c arm.v5.urel.gcce4_4_1 -c arm.v6.urel.gcce4_4_1

debug-winscw: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c winscw_udeb.mwccinc
clean-debug-winscw: bld.inf
	$(SBS) reallyclean -c winscw_udeb.mwccinc
freeze-debug-winscw: bld.inf
	$(SBS) freeze -c winscw_udeb.mwccinc
debug-gcce: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c arm.v5.udeb.gcce4_4_1
clean-debug-gcce: bld.inf
	$(SBS) reallyclean -c arm.v5.udeb.gcce4_4_1
freeze-debug-gcce: bld.inf
	$(SBS) freeze -c arm.v5.udeb.gcce4_4_1
debug-armv5: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c armv5_udeb
clean-debug-armv5: bld.inf
	$(SBS) reallyclean -c armv5_udeb
freeze-debug-armv5: bld.inf
	$(SBS) freeze -c armv5_udeb
debug-armv6: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c armv6_udeb
clean-debug-armv6: bld.inf
	$(SBS) reallyclean -c armv6_udeb
freeze-debug-armv6: bld.inf
	$(SBS) freeze -c armv6_udeb
release-gcce: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c arm.v5.urel.gcce4_4_1
clean-release-gcce: bld.inf
	$(SBS) reallyclean -c arm.v5.urel.gcce4_4_1
freeze-release-gcce: bld.inf
	$(SBS) freeze -c arm.v5.urel.gcce4_4_1
release-armv5: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c armv5_urel
clean-release-armv5: bld.inf
	$(SBS) reallyclean -c armv5_urel
freeze-release-armv5: bld.inf
	$(SBS) freeze -c armv5_urel
release-armv6: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c armv6_urel
clean-release-armv6: bld.inf
	$(SBS) reallyclean -c armv6_urel
freeze-release-armv6: bld.inf
	$(SBS) freeze -c armv6_urel
debug-armv5-gcce4.4.1: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c arm.v5.udeb.gcce4_4_1
clean-debug-armv5-gcce4.4.1: bld.inf
	$(SBS) reallyclean -c arm.v5.udeb.gcce4_4_1
freeze-debug-armv5-gcce4.4.1: bld.inf
	$(SBS) freeze -c arm.v5.udeb.gcce4_4_1
release-armv5-gcce4.4.1: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c arm.v5.urel.gcce4_4_1
clean-release-armv5-gcce4.4.1: bld.inf
	$(SBS) reallyclean -c arm.v5.urel.gcce4_4_1
freeze-release-armv5-gcce4.4.1: bld.inf
	$(SBS) freeze -c arm.v5.urel.gcce4_4_1
debug-armv6-gcce4.4.1: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c arm.v6.udeb.gcce4_4_1
clean-debug-armv6-gcce4.4.1: bld.inf
	$(SBS) reallyclean -c arm.v6.udeb.gcce4_4_1
freeze-debug-armv6-gcce4.4.1: bld.inf
	$(SBS) freeze -c arm.v6.udeb.gcce4_4_1
release-armv6-gcce4.4.1: e:\QtProject\tbclient\symbian3\tbclient.loc bld.inf
	$(SBS) -c arm.v6.urel.gcce4_4_1
clean-release-armv6-gcce4.4.1: bld.inf
	$(SBS) reallyclean -c arm.v6.urel.gcce4_4_1
freeze-release-armv6-gcce4.4.1: bld.inf
	$(SBS) freeze -c arm.v6.urel.gcce4_4_1

export: bld.inf
	$(SBS) export -c winscw_udeb.mwccinc -c arm.v5.udeb.gcce4_4_1 -c arm.v6.udeb.gcce4_4_1 -c arm.v5.urel.gcce4_4_1 -c arm.v6.urel.gcce4_4_1

cleanexport: bld.inf
	$(SBS) cleanexport -c winscw_udeb.mwccinc -c arm.v5.udeb.gcce4_4_1 -c arm.v6.udeb.gcce4_4_1 -c arm.v5.urel.gcce4_4_1 -c arm.v6.urel.gcce4_4_1

freeze: freeze-release

check: first

run:
	call E:/Application/QtSDK/Symbian/SDKs/SymbianSR1Qt474/epoc32/release/winscw/udeb/tbclient.exe $(QT_RUN_OPTIONS)

runonphone: sis
	runonphone $(QT_RUN_ON_PHONE_OPTIONS) --sis tbclient.sis tbclient.exe $(QT_RUN_OPTIONS)

tbclient_template.pkg: E:/QtProject/tbclient/symbian3/tbclient.pro
	$(MAKE) -f $(MAKEFILE) qmake

tbclient_installer.pkg: E:/QtProject/tbclient/symbian3/tbclient.pro
	$(MAKE) -f $(MAKEFILE) qmake

tbclient_stub.pkg: E:/QtProject/tbclient/symbian3/tbclient.pro
	$(MAKE) -f $(MAKEFILE) qmake

sis: tbclient_template.pkg
	$(if $(wildcard .make.cache), $(MAKE) -f $(MAKEFILE) ok_sis MAKEFILES=.make.cache , $(if $(QT_SIS_TARGET), $(MAKE) -f $(MAKEFILE) ok_sis , $(MAKE) -f $(MAKEFILE) fail_sis_nocache ) )

ok_sis:
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\createpackage.bat -g $(QT_SIS_OPTIONS) tbclient_template.pkg $(QT_SIS_TARGET) $(QT_SIS_CERTIFICATE) $(QT_SIS_KEY) $(QT_SIS_PASSPHRASE)

unsigned_sis: tbclient_template.pkg
	$(if $(wildcard .make.cache), $(MAKE) -f $(MAKEFILE) ok_unsigned_sis MAKEFILES=.make.cache , $(if $(QT_SIS_TARGET), $(MAKE) -f $(MAKEFILE) ok_unsigned_sis , $(MAKE) -f $(MAKEFILE) fail_sis_nocache ) )

ok_unsigned_sis:
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\createpackage.bat -g $(QT_SIS_OPTIONS) -o tbclient_template.pkg $(QT_SIS_TARGET)

tbclient.sis:
	$(MAKE) -f $(MAKEFILE) sis

installer_sis: tbclient_installer.pkg sis
	$(MAKE) -f $(MAKEFILE) ok_installer_sis

ok_installer_sis: tbclient_installer.pkg
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\createpackage.bat $(QT_SIS_OPTIONS) tbclient_installer.pkg - $(QT_SIS_CERTIFICATE) $(QT_SIS_KEY) $(QT_SIS_PASSPHRASE)

unsigned_installer_sis: tbclient_installer.pkg unsigned_sis
	$(MAKE) -f $(MAKEFILE) ok_unsigned_installer_sis

ok_unsigned_installer_sis: tbclient_installer.pkg
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\createpackage.bat $(QT_SIS_OPTIONS) -o tbclient_installer.pkg

fail_sis_nocache:
	$(error Project has to be built or QT_SIS_TARGET environment variable has to be set before calling 'SIS' target)

stub_sis: tbclient_stub.pkg
	$(if $(wildcard .make.cache), $(MAKE) -f $(MAKEFILE) ok_stub_sis MAKEFILES=.make.cache , $(if $(QT_SIS_TARGET), $(MAKE) -f $(MAKEFILE) ok_stub_sis , $(MAKE) -f $(MAKEFILE) fail_sis_nocache ) )

ok_stub_sis:
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\createpackage.bat -s $(QT_SIS_OPTIONS) tbclient_stub.pkg $(QT_SIS_TARGET) $(QT_SIS_CERTIFICATE) $(QT_SIS_KEY) $(QT_SIS_PASSPHRASE)

deploy: sis
	call tbclient.sis

mocclean: compiler_moc_header_clean compiler_moc_source_clean

mocables: compiler_moc_header_make_all compiler_moc_source_make_all

compiler_moc_header_make_all: moc\moc_utility.cpp moc\moc_tbsettings.cpp moc\moc_tbnetworkaccessmanagerfactory.cpp moc\moc_scribblearea.cpp moc\moc_httpuploader.cpp moc\moc_downloadmanager.cpp moc\moc_customwebview.cpp moc\moc_qmlapplicationviewer.cpp
compiler_moc_header_clean:
	-$(DEL_FILE) moc\moc_utility.cpp moc\moc_tbsettings.cpp moc\moc_tbnetworkaccessmanagerfactory.cpp moc\moc_scribblearea.cpp moc\moc_httpuploader.cpp moc\moc_downloadmanager.cpp moc\moc_customwebview.cpp moc\moc_qmlapplicationviewer.cpp
moc\moc_utility.cpp: utility.h
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\moc.exe $(DEFINES) $(INCPATH) -DSYMBIAN e:\QtProject\tbclient\symbian3\utility.h -o e:\QtProject\tbclient\symbian3\moc\moc_utility.cpp

moc\moc_tbsettings.cpp: tbsettings.h
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\moc.exe $(DEFINES) $(INCPATH) -DSYMBIAN e:\QtProject\tbclient\symbian3\tbsettings.h -o e:\QtProject\tbclient\symbian3\moc\moc_tbsettings.cpp

moc\moc_tbnetworkaccessmanagerfactory.cpp: tbnetworkaccessmanagerfactory.h
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\moc.exe $(DEFINES) $(INCPATH) -DSYMBIAN e:\QtProject\tbclient\symbian3\tbnetworkaccessmanagerfactory.h -o e:\QtProject\tbclient\symbian3\moc\moc_tbnetworkaccessmanagerfactory.cpp

moc\moc_scribblearea.cpp: scribblearea.h
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\moc.exe $(DEFINES) $(INCPATH) -DSYMBIAN e:\QtProject\tbclient\symbian3\scribblearea.h -o e:\QtProject\tbclient\symbian3\moc\moc_scribblearea.cpp

moc\moc_httpuploader.cpp: httpuploader.h
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\moc.exe $(DEFINES) $(INCPATH) -DSYMBIAN e:\QtProject\tbclient\symbian3\httpuploader.h -o e:\QtProject\tbclient\symbian3\moc\moc_httpuploader.cpp

moc\moc_downloadmanager.cpp: downloadmanager.h
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\moc.exe $(DEFINES) $(INCPATH) -DSYMBIAN e:\QtProject\tbclient\symbian3\downloadmanager.h -o e:\QtProject\tbclient\symbian3\moc\moc_downloadmanager.cpp

moc\moc_customwebview.cpp: customwebview.h
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\moc.exe $(DEFINES) $(INCPATH) -DSYMBIAN e:\QtProject\tbclient\symbian3\customwebview.h -o e:\QtProject\tbclient\symbian3\moc\moc_customwebview.cpp

moc\moc_qmlapplicationviewer.cpp: qmlapplicationviewer\qmlapplicationviewer.h
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\moc.exe $(DEFINES) $(INCPATH) -DSYMBIAN e:\QtProject\tbclient\symbian3\qmlapplicationviewer\qmlapplicationviewer.h -o e:\QtProject\tbclient\symbian3\moc\moc_qmlapplicationviewer.cpp

compiler_rcc_make_all: rcc\qrc_picsource.cpp
compiler_rcc_clean:
	-$(DEL_FILE) rcc\qrc_picsource.cpp
rcc\qrc_picsource.cpp: picsource.qrc \
		gfx\switch_windows_inverted.svg \
		gfx\write_at_n.png \
		gfx\photo.png \
		gfx\edit_inverted.svg \
		gfx\pb_reply.png \
		gfx\mark_icon.png \
		gfx\popup.9.png \
		gfx\ok_inverted.svg \
		gfx\sign_in_inverted.svg \
		gfx\tb_close_stop.svg \
		gfx\tb_close_stop_inverted.svg \
		gfx\write_image_n.png \
		gfx\frs_post_top.png \
		gfx\calendar_week.svg \
		gfx\pull_down_inverse.svg \
		gfx\list_default_inverse.svg \
		gfx\home_grade_1.png \
		gfx\edit.svg \
		gfx\download.svg \
		gfx\male.png \
		gfx\messaging.svg \
		gfx\contacts_inverted.svg \
		gfx\download_inverted.svg \
		gfx\toolbox_inverted.svg \
		gfx\ok.svg \
		gfx\splash.png \
		gfx\list_default.svg \
		gfx\bookmark_inverted.svg \
		gfx\bookmark.svg \
		gfx\add_bookmark.svg \
		gfx\toolbox.svg \
		gfx\write_face_n.png \
		gfx\write_face_s.png \
		gfx\home_grade_4.png \
		gfx\icon.svg \
		gfx\switch_windows.svg \
		gfx\add_bookmark_inverted.svg \
		gfx\contacts.svg \
		gfx\frs_post_ding.png \
		gfx\home_grade_2.png \
		gfx\sign_in.svg \
		gfx\write_at_s.png \
		gfx\photos.svg \
		gfx\write_image_s.png \
		gfx\female.png \
		gfx\messaging_inverted.svg \
		gfx\pull_down.svg \
		gfx\home_grade_3.png \
		gfx\frs_post_good.png \
		pics\lt_0031.gif \
		pics\write_face_12.png \
		pics\w_0021.gif \
		pics\ali_034.png \
		pics\b_0016.gif \
		pics\b56.png \
		pics\w_0046.gif \
		pics\b_0023.gif \
		pics\lt_0023.gif \
		pics\write_face_44.png \
		pics\w_0053.gif \
		pics\ali_002.png \
		pics\yz_006.png \
		pics\b_0059.gif \
		pics\ali_051.png \
		pics\t_0005.gif \
		pics\b_0007.png \
		pics\write_face_09.png \
		pics\yz_014.png \
		pics\b21.png \
		pics\b_0010.png \
		pics\t_0037.gif \
		pics\ali_016.png \
		pics\b38.png \
		pics\image_emoticon11.png \
		pics\lt_0034.gif \
		pics\w_0024.gif \
		pics\b_0005.gif \
		pics\image_emoticon26.png \
		pics\write_face_22.png \
		pics\w_0031.gif \
		pics\image_emoticon9.png \
		pics\b_0026.gif \
		pics\bd_0009.png \
		pics\lt_0016.gif \
		pics\b_0033.gif \
		pics\lt_0008.gif \
		pics\t_0008.gif \
		pics\b03.png \
		pics\bd_0028.png \
		pics\t_0015.gif \
		pics\b_0017.png \
		pics\w_0002.gif \
		pics\yz_044.png \
		pics\b31.png \
		pics\b_0020.png \
		pics\bd_0036.png \
		pics\ali_046.png \
		pics\image_emoticon21.png \
		pics\b_0008.gif \
		pics\b48.png \
		pics\w_0034.gif \
		pics\b_0015.gif \
		pics\lt_0011.gif \
		pics\bd_0004.png \
		pics\write_face_32.png \
		pics\w_0041.gif \
		pics\b_0036.gif \
		pics\lt_0026.gif \
		pics\b_0043.gif \
		pics\ali_063.png \
		pics\lt_0003.gif \
		pics\t_0018.gif \
		pics\image_emoticon.png \
		pics\yz_026.png \
		pics\b13.png \
		pics\t_0025.gif \
		pics\bd_0018.png \
		pics\ali_028.png \
		pics\b_0027.png \
		pics\w_0012.gif \
		pics\yz_034.png \
		pics\b41.png \
		pics\b_0030.png \
		pics\write_face_18.png \
		pics\ali_036.png \
		pics\b_0018.gif \
		pics\b58.png \
		pics\lt_0014.gif \
		pics\w_0044.gif \
		pics\b_0025.gif \
		pics\lt_0021.gif \
		pics\write_face_42.png \
		pics\w_0051.gif \
		pics\ali_004.png \
		pics\b_0046.gif \
		pics\yz_008.png \
		pics\ali_053.png \
		pics\b_0053.gif \
		pics\t_0003.gif \
		pics\b_0009.png \
		pics\t_0028.gif \
		pics\write_face_07.png \
		pics\yz_016.png \
		pics\ali_021.png \
		pics\b23.png \
		pics\t_0035.gif \
		pics\ali_018.png \
		pics\b_0037.png \
		pics\lt_0032.gif \
		pics\write_face_11.png \
		pics\w_0022.gif \
		pics\b_0040.png \
		pics\b51.png \
		pics\write_face_50.png \
		pics\write_face_28.png \
		pics\image_emoticon7.png \
		pics\b_0028.gif \
		pics\lt_0024.gif \
		pics\b_0035.gif \
		pics\yz_001.png \
		pics\b_0056.gif \
		pics\lt_0006.gif \
		pics\t_0006.gif \
		pics\b_0063.gif \
		pics\b05.png \
		pics\t_0013.gif \
		pics\write_face_04.png \
		pics\b_0019.png \
		pics\image_emoticon35.png \
		pics\t_0038.gif \
		pics\yz_046.png \
		pics\ali_011.png \
		pics\b33.png \
		pics\ali_048.png \
		pics\b_0002.gif \
		pics\b_0047.png \
		pics\write_face_21.png \
		pics\w_0032.gif \
		pics\image_emoticon4.png \
		pics\b61.png \
		pics\b_0050.png \
		pics\bd_0006.png \
		pics\write_face_38.png \
		pics\b_0038.gif \
		pics\ali_065.png \
		pics\b_0045.gif \
		pics\lt_0001.gif \
		pics\bd_0021.png \
		pics\t_0016.gif \
		pics\yz_028.png \
		pics\image_emoticon30.png \
		pics\b15.png \
		pics\t_0023.gif \
		pics\image_emoticon45.png \
		pics\b_0029.png \
		pics\w_0010.gif \
		pics\yz_036.png \
		pics\ali_041.png \
		pics\b43.png \
		pics\write_face_16.png \
		pics\ali_038.png \
		pics\b_0012.gif \
		pics\lt_0012.gif \
		pics\write_face_31.png \
		pics\w_0042.gif \
		pics\write_face_48.png \
		pics\ali_006.png \
		pics\b_0048.gif \
		pics\lt_0004.gif \
		pics\b_0055.gif \
		pics\ali_055.png \
		pics\t_0001.gif \
		pics\yz_021.png \
		pics\b_0003.png \
		pics\t_0026.gif \
		pics\bd_0011.png \
		pics\yz_018.png \
		pics\ali_023.png \
		pics\b25.png \
		pics\image_emoticon40.png \
		pics\t_0033.gif \
		pics\b_0039.png \
		pics\image_emoticon15.png \
		pics\lt_0030.gif \
		pics\w_0020.gif \
		pics\ali_031.png \
		pics\b_0001.gif \
		pics\b53.png \
		pics\write_face_26.png \
		pics\b_0022.gif \
		pics\lt_0022.gif \
		pics\write_face_41.png \
		pics\w_0052.gif \
		pics\yz_003.png \
		pics\b_0058.gif \
		pics\t_0004.gif \
		pics\b07.png \
		pics\b_0006.png \
		pics\t_0011.gif \
		pics\write_face_02.png \
		pics\yz_011.png \
		pics\image_emoticon33.png \
		pics\b_0013.png \
		pics\t_0036.gif \
		pics\ali_013.png \
		pics\image_emoticon10.png \
		pics\b35.png \
		pics\b_0049.png \
		pics\image_emoticon25.png \
		pics\b_0004.gif \
		pics\w_0030.gif \
		pics\image_emoticon2.png \
		pics\b_0011.gif \
		pics\bd_0008.png \
		pics\write_face_36.png \
		pics\b_0032.gif \
		pics\ali_067.png \
		pics\t_0014.gif \
		pics\bd_0023.png \
		pics\b17.png \
		pics\b_0016.png \
		pics\t_0021.gif \
		pics\w_0009.gif \
		pics\yz_041.png \
		pics\b_0023.png \
		pics\image_emoticon43.png \
		pics\bd_0031.png \
		pics\yz_038.png \
		pics\ali_043.png \
		pics\image_emoticon20.png \
		pics\b45.png \
		pics\b_0014.gif \
		pics\lt_0010.gif \
		pics\w_0040.gif \
		pics\b_0021.gif \
		pics\write_face_46.png \
		pics\ali_008.png \
		pics\ali_060.png \
		pics\b_0042.gif \
		pics\lt_0002.gif \
		pics\ali_057.png \
		pics\yz_023.png \
		pics\b10.png \
		pics\b_0005.png \
		pics\bd_0013.png \
		pics\t_0024.gif \
		pics\ali_025.png \
		pics\b27.png \
		pics\b_0026.png \
		pics\t_0031.gif \
		pics\w_0019.gif \
		pics\yz_031.png \
		pics\b_0033.png \
		pics\image_emoticon13.png \
		pics\write_face_15.png \
		pics\ali_033.png \
		pics\b55.png \
		pics\b_0024.gif \
		pics\lt_0020.gif \
		pics\w_0050.gif \
		pics\ali_001.png \
		pics\b_0031.gif \
		pics\yz_005.png \
		pics\b_0052.gif \
		pics\ali_050.png \
		pics\t_0002.gif \
		pics\b09.png \
		pics\b_0008.png \
		pics\write_face_08.png \
		pics\yz_013.png \
		pics\b20.png \
		pics\b_0015.png \
		pics\image_emoticon39.png \
		pics\t_0034.gif \
		pics\ali_015.png \
		pics\b37.png \
		pics\b_0036.png \
		pics\w_0029.gif \
		pics\image_emoticon23.png \
		pics\b_0043.png \
		pics\write_face_25.png \
		pics\image_emoticon8.png \
		pics\b_0034.gif \
		pics\ali_069.png \
		pics\b_0041.gif \
		pics\b_0062.gif \
		pics\b02.png \
		pics\bd_0025.png \
		pics\t_0012.gif \
		pics\write_face_01.png \
		pics\image_emoticon34.png \
		pics\b19.png \
		pics\b_0018.png \
		pics\w_0007.gif \
		pics\yz_043.png \
		pics\b_0025.png \
		pics\image_emoticon49.png \
		pics\b30.png \
		pics\bd_0033.png \
		pics\ali_045.png \
		pics\b47.png \
		pics\b_0046.png \
		pics\w_0039.gif \
		pics\b_0053.png \
		pics\bd_0001.png \
		pics\write_face_35.png \
		pics\image_emoticon50.png \
		pics\b_0044.gif \
		pics\ali_062.png \
		pics\b_0051.gif \
		pics\ali_059.png \
		pics\bd_0020.png \
		pics\yz_025.png \
		pics\ali_070.png \
		pics\b12.png \
		pics\t_0022.gif \
		pics\bd_0015.png \
		pics\ali_027.png \
		pics\b29.png \
		pics\b_0028.png \
		pics\image_emoticon44.png \
		pics\w_0017.gif \
		pics\yz_033.png \
		pics\image_emoticon19.png \
		pics\b40.png \
		pics\b_0035.png \
		pics\write_face_13.png \
		pics\ali_035.png \
		pics\b57.png \
		pics\b_0056.png \
		pics\w_0049.gif \
		pics\write_face_45.png \
		pics\ali_003.png \
		pics\yz_007.png \
		pics\ali_052.png \
		pics\b_0054.gif \
		pics\b_0061.gif \
		pics\b_0002.png \
		pics\write_face_06.png \
		pics\bd_0010.png \
		pics\yz_015.png \
		pics\ali_020.png \
		pics\image_emoticon37.png \
		pics\b22.png \
		pics\t_0032.gif \
		pics\ali_017.png \
		pics\b_0038.png \
		pics\image_emoticon14.png \
		pics\b39.png \
		pics\write_face_10.png \
		pics\w_0027.gif \
		pics\b50.png \
		pics\b_0045.png \
		pics\image_emoticon29.png \
		pics\write_face_23.png \
		pics\image_emoticon6.png \
		pics\lt_0019.gif \
		pics\b04.png \
		pics\t_0010.gif \
		pics\bd_0027.png \
		pics\b_0012.png \
		pics\image_emoticon32.png \
		pics\w_0005.gif \
		pics\yz_045.png \
		pics\ali_010.png \
		pics\image_emoticon47.png \
		pics\b32.png \
		pics\bd_0035.png \
		pics\ali_047.png \
		pics\image_emoticon24.png \
		pics\b_0007.gif \
		pics\b49.png \
		pics\b_0048.png \
		pics\write_face_20.png \
		pics\w_0037.gif \
		pics\b_0010.gif \
		pics\b60.png \
		pics\b_0055.png \
		pics\bd_0003.png \
		pics\write_face_33.png \
		pics\lt_0029.gif \
		pics\ali_064.png \
		pics\bd_0022.png \
		pics\yz_027.png \
		pics\b14.png \
		pics\b_0001.png \
		pics\t_0020.gif \
		pics\bd_0017.png \
		pics\w_0008.gif \
		pics\ali_029.png \
		pics\b_0022.png \
		pics\image_emoticon42.png \
		pics\bd_0030.png \
		pics\w_0015.gif \
		pics\yz_035.png \
		pics\ali_040.png \
		pics\b42.png \
		pics\image_emoticon17.png \
		pics\write_face_19.png \
		pics\ali_037.png \
		pics\b_0017.gif \
		pics\b59.png \
		pics\write_face_30.png \
		pics\w_0047.gif \
		pics\b_0020.gif \
		pics\write_face_43.png \
		pics\ali_005.png \
		pics\yz_009.png \
		pics\ali_054.png \
		pics\yz_020.png \
		pics\b_0004.png \
		pics\bd_0012.png \
		pics\yz_017.png \
		pics\ali_022.png \
		pics\b24.png \
		pics\b_0011.png \
		pics\t_0030.gif \
		pics\w_0018.gif \
		pics\ali_019.png \
		pics\image_emoticon12.png \
		pics\b_0032.png \
		pics\lt_0035.gif \
		pics\w_0025.gif \
		pics\ali_030.png \
		pics\image_emoticon27.png \
		pics\b52.png \
		pics\write_face_29.png \
		pics\b_0027.gif \
		pics\lt_0017.gif \
		pics\write_face_40.png \
		pics\b_0030.gif \
		pics\yz_002.png \
		pics\lt_0009.gif \
		pics\t_0009.gif \
		pics\b06.png \
		pics\write_face_05.png \
		pics\bd_0029.png \
		pics\yz_010.png \
		pics\b_0014.png \
		pics\image_emoticon38.png \
		pics\w_0003.gif \
		pics\ali_012.png \
		pics\b34.png \
		pics\b_0021.png \
		pics\t_0040.gif \
		pics\w_0028.gif \
		pics\ali_049.png \
		pics\b_0042.png \
		pics\image_emoticon22.png \
		pics\b_0009.gif \
		pics\w_0035.gif \
		pics\image_emoticon5.png \
		pics\b62.png \
		pics\bd_0005.png \
		pics\write_face_39.png \
		pics\b_0037.gif \
		pics\lt_0027.gif \
		pics\b_0040.gif \
		pics\ali_066.png \
		pics\t_0019.gif \
		pics\bd_0024.png \
		pics\yz_029.png \
		pics\b16.png \
		pics\bd_0019.png \
		pics\w_0006.gif \
		pics\yz_040.png \
		pics\image_emoticon48.png \
		pics\b_0024.png \
		pics\bd_0032.png \
		pics\w_0013.gif \
		pics\yz_037.png \
		pics\ali_042.png \
		pics\b44.png \
		pics\b_0031.png \
		pics\write_face_17.png \
		pics\w_0038.gif \
		pics\ali_039.png \
		pics\b_0019.gif \
		pics\b_0052.png \
		pics\lt_0015.gif \
		pics\w_0045.gif \
		pics\write_face_49.png \
		pics\ali_007.png \
		pics\b_0047.gif \
		pics\b_0050.gif \
		pics\ali_056.png \
		pics\yz_022.png \
		pics\t_0029.gif \
		pics\bd_0014.png \
		pics\yz_019.png \
		pics\ali_024.png \
		pics\b26.png \
		pics\w_0016.gif \
		pics\yz_030.png \
		pics\b_0034.png \
		pics\image_emoticon18.png \
		pics\lt_0033.gif \
		pics\write_face_14.png \
		pics\w_0023.gif \
		pics\ali_032.png \
		pics\b54.png \
		pics\b_0041.png \
		pics\write_face_27.png \
		pics\w_0048.gif \
		pics\b_0029.gif \
		pics\lt_0025.gif \
		pics\yz_004.png \
		pics\b_0057.gif \
		pics\lt_0007.gif \
		pics\t_0007.gif \
		pics\b_0060.gif \
		pics\b08.png \
		pics\write_face_03.png \
		pics\yz_012.png \
		pics\image_emoticon36.png \
		pics\t_0039.gif \
		pics\w_0001.gif \
		pics\ali_014.png \
		pics\b36.png \
		pics\w_0026.gif \
		pics\image_emoticon28.png \
		pics\b_0003.gif \
		pics\b_0044.png \
		pics\write_face_24.png \
		pics\w_0033.gif \
		pics\image_emoticon3.png \
		pics\b_0051.png \
		pics\lt_0018.gif \
		pics\bd_0007.png \
		pics\write_face_37.png \
		pics\b_0039.gif \
		pics\ali_068.png \
		pics\b01.png \
		pics\t_0017.gif \
		pics\bd_0026.png \
		pics\image_emoticon31.png \
		pics\b18.png \
		pics\w_0004.gif \
		pics\yz_042.png \
		pics\image_emoticon46.png \
		pics\bd_0034.png \
		pics\w_0011.gif \
		pics\yz_039.png \
		pics\ali_044.png \
		pics\b_0006.gif \
		pics\b46.png \
		pics\w_0036.gif \
		pics\b_0013.gif \
		pics\b_0054.png \
		pics\bd_0002.png \
		pics\lt_0013.gif \
		pics\write_face_34.png \
		pics\w_0043.gif \
		pics\lt_0028.gif \
		pics\write_face_47.png \
		pics\ali_009.png \
		pics\b_0049.gif \
		pics\ali_061.png \
		pics\lt_0005.gif \
		pics\ali_058.png \
		pics\yz_024.png \
		pics\b11.png \
		pics\bd_0016.png \
		pics\t_0027.gif \
		pics\ali_026.png \
		pics\image_emoticon41.png \
		pics\b28.png \
		pics\w_0014.gif \
		pics\yz_032.png \
		pics\image_emoticon16.png
	e:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\rcc.exe -name picsource e:\QtProject\tbclient\symbian3\picsource.qrc -o e:\QtProject\tbclient\symbian3\rcc\qrc_picsource.cpp

compiler_image_collection_make_all: ui\qmake_image_collection.cpp
compiler_image_collection_clean:
	-$(DEL_FILE) ui\qmake_image_collection.cpp
compiler_moc_source_make_all: moc\httpuploader.moc
compiler_moc_source_clean:
	-$(DEL_FILE) moc\httpuploader.moc
moc\httpuploader.moc: httpuploader.h \
		httpuploader.cpp
	E:\Application\QtSDK\Symbian\SDKs\SymbianSR1Qt474\bin\moc.exe $(DEFINES) $(INCPATH) -DSYMBIAN e:\QtProject\tbclient\symbian3\httpuploader.cpp -o e:\QtProject\tbclient\symbian3\moc\httpuploader.moc

compiler_uic_make_all:
compiler_uic_clean:
compiler_yacc_decl_make_all:
compiler_yacc_decl_clean:
compiler_yacc_impl_make_all:
compiler_yacc_impl_clean:
compiler_lex_make_all:
compiler_lex_clean:
compiler_clean: compiler_moc_header_clean compiler_rcc_clean compiler_moc_source_clean 

dodistclean:
	-@ if EXIST "e:\QtProject\tbclient\symbian3\tbclient_template.pkg" $(DEL_FILE)  "e:\QtProject\tbclient\symbian3\tbclient_template.pkg"
	-@ if EXIST "e:\QtProject\tbclient\symbian3\tbclient_stub.pkg" $(DEL_FILE)  "e:\QtProject\tbclient\symbian3\tbclient_stub.pkg"
	-@ if EXIST "e:\QtProject\tbclient\symbian3\tbclient_installer.pkg" $(DEL_FILE)  "e:\QtProject\tbclient\symbian3\tbclient_installer.pkg"
	-@ if EXIST "e:\QtProject\tbclient\symbian3\Makefile" $(DEL_FILE)  "e:\QtProject\tbclient\symbian3\Makefile"
	-@ if EXIST "e:\QtProject\tbclient\symbian3\tbclient_exe.mmp" $(DEL_FILE)  "e:\QtProject\tbclient\symbian3\tbclient_exe.mmp"
	-@ if EXIST "e:\QtProject\tbclient\symbian3\tbclient_reg.rss" $(DEL_FILE)  "e:\QtProject\tbclient\symbian3\tbclient_reg.rss"
	-@ if EXIST "e:\QtProject\tbclient\symbian3\tbclient.rss" $(DEL_FILE)  "e:\QtProject\tbclient\symbian3\tbclient.rss"
	-@ if EXIST "e:\QtProject\tbclient\symbian3\bld.inf" $(DEL_FILE)  "e:\QtProject\tbclient\symbian3\bld.inf"

distclean: clean dodistclean

clean: bld.inf
	-$(SBS) reallyclean --toolcheck=off -c winscw_udeb.mwccinc -c arm.v5.udeb.gcce4_4_1 -c arm.v6.udeb.gcce4_4_1 -c arm.v5.urel.gcce4_4_1 -c arm.v6.urel.gcce4_4_1



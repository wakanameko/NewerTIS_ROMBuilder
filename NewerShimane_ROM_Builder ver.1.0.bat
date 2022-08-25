@echo off
Setlocal EnableDelayedExpansion
 
::begin
:BEGIN
cls
echo ========================================
echo  ===== NewerShimane ISO Patcher =======
echo ========================================

SET MODINPUT=1

IF %MODINPUT%==1 (
	SET MOD=DMR
	GOTO VERSELECT
	)

:VERSELECT

SET VERINPUT=0

IF %VERINPUT%==0 (
	SET BASEVER=AUTO
	GOTO EXTSELECT
	)

GOTO INPUTERROR

:EXTSELECT

SET EXTINPUT=2

IF %EXTINPUT%==2 (
	SET FILEEXT=wbfs
	GOTO SAVESELECT
	)

GOTO INPUTERROR

:SAVESELECT

SET SLOTINPUT=2

IF %SLOTINPUT%==2 (
	SET SLOT=Custom-Shared
	GOTO DOUBLECHECK
	)

GOTO INPUTERROR

:DOUBLECHECK
cls
echo ==============Review Settings=============
echo Selected NSMBW Mod      : NewerShimane
echo Selected Base Version   : %BASEVER%
echo Selected Language       : Japanese
echo Selected Output Filetype: %FILEEXT%
echo Selected Save "Slot"    : %SLOT%
) ELSE (
echo.
echo ===========Is this selection ok?==========
echo 1. Yes, continue
echo 2. No, change settings
echo (Anything else). exit
echo ==========================================
SET AREYOUSURE=
SET /P AREYOUSURE=Enter Number and press Enter:

IF %AREYOUSURE%==1 GOTO EXTRACT
IF %AREYOUSURE%==2 GOTO iguzitto

GOTO INPUTERROR

:INPUTERROR
echo Invalid option selected, exiting...
pause
exit

:DETECTEDVER
::Exit if supported version is not found (BASEVER not reset)
IF %BASEVER%==AUTO (
	echo Unsupported ISO version detected, exiting...
	rmdir nsmb.d /s /q
	pause
	exit
	)

echo.
echo Autodetected Base ISO Version: %BASEVER%
GOTO CONTINUE

:EXTRACT
:: Check for Mod contents folder and riivolution xml before anything
echo.
echo Checking for %MOD% resources...
IF %MOD%==DMR (
	SET MODFOLDER=NewerSuperMarioTourismInShimane
	SET MODFOLSRC=NewerSuperMarioTourismInShimane.zip\NewerFiles\NewerSuperMarioTourismInShimane\
	SET XML=NSMTIS
	)

IF NOT EXIST "%MODFOLDER%\" (
	echo.
	echo Cannot find the "%MODFOLDER%" folder containing %MOD% files, exiting...
	echo.
	echo Please make sure you have "%MODFOLDER%" in the same directory
	echo as this builder pack.
	echo [%MODFOLSRC%] ^<- This one!
	echo.
	pause
	exit
	) ELSE (
	echo.
	echo %MOD% files found, continuing...
	)
	
IF /I NOT EXIST riivolution\%XML%.xml (
	echo.
	echo Cannot find \riivolution\%XML%.xml containing %MOD% patches, exiting...
	echo.
	pause
	exit
	) ELSE (
	echo.
	echo %MOD% patches found, continuing...
	)

:SKIPXMLCHECK
:: extract image
:: Autodetect
IF %BASEVER%==AUTO (
echo.
echo Unpacking original game...
wit\wit extract -s ../ -1 -n SMN.01 . nsmb.d --psel=DATA -ovv

:Detect version and assign BASEVER
IF EXIST nsmb.d\files\COPYDATE_LAST_2009-10-03_232911 (
	SET BASEVER=EURv1
	SET GAMEID=SMNP01
	)
IF EXIST nsmb.d\files\COPYDATE_LAST_2010-01-05_152101 (
	SET BASEVER=EURv2
	SET GAMEID=SMNP01
	)
IF EXIST nsmb.d\files\COPYDATE_LAST_2009-10-03_232303 (
	SET BASEVER=USAv1
	SET GAMEID=SMNE01
	)
IF EXIST nsmb.d\files\COPYDATE_LAST_2010-01-05_143554 (
	SET BASEVER=USAv2
	SET GAMEID=SMNE01
	)
IF EXIST nsmb.d\files\COPYDATE_LAST_2009-10-03_231655 (
	SET BASEVER=JPNv1
	SET GAMEID=SMNJ01
	)
GOTO DETECTEDVER
) ELSE (
:: Not Autodetect
echo.
echo Unpacking original game...
wit\wit extract -s ../ -1 -n %GAMEID% . nsmb.d --psel=DATA -ovv
)

:CONTINUE
IF %MOD%==DMR (
IF %GAMEID%==SMNP01 SET XML=NSMTIS
IF %GAMEID%==SMNE01 SET XML=NSMTIS
IF %GAMEID%==SMNJ01 SET XML=NSMTIS
IF /I NOT EXIST riivolution\!XML!.xml (
	echo Cannot find \riivolution\!XML!.xml containing %MOD% patches, exiting...
	rmdir nsmb.d /s /q
	pause
	exit
	)
)

IF %SLOTINPUT%==3 (
	SET MSGPATH=MessagePatches\
	IF %GAMEID%==SMNP01 SET RG=EU
	IF %GAMEID%==SMNE01 SET RG=US
	IF %GAMEID%==SMNJ01 SET RG=JP
	)

:: many copy commands
echo.
echo Copying %MOD% files over originals...
IF %MOD%==DMR GOTO DMR

:DMR
copy /b NewerSuperMarioTourismInShimane\Tilesets\ nsmb.d\files\Stage\Texture\
copy /b NewerSuperMarioTourismInShimane\TitleReplay\ nsmb.d\files\Replay\title\
copy /b NewerSuperMarioTourismInShimane\BGs\ nsmb.d\files\Object\
copy /b NewerSuperMarioTourismInShimane\SpriteTex\ nsmb.d\files\Object\

mkdir nsmb.d\files\Sound\new
copy /b NewerSuperMarioTourismInShimane\Music\ nsmb.d\files\Sound\new\
mkdir nsmb.d\files\Sound\new\sfx
copy /b NewerSuperMarioTourismInShimane\Music\sfx\ nsmb.d\files\Sound\new\sfx\
copy /b NewerSuperMarioTourismInShimane\Music\stream nsmb.d\files\Sound\stream\
copy /b NewerSuperMarioTourismInShimane\Music\rsar\ nsmb.d\files\Sound\

IF %GAMEID%==SMNP01 (
copy /b NewerSuperMarioTourismInShimane\Font\ nsmb.d\files\EU\EngEU\Font\
copy /b NewerSuperMarioTourismInShimane\Font\ nsmb.d\files\EU\FraEU\Font\
copy /b NewerSuperMarioTourismInShimane\Font\ nsmb.d\files\EU\GerEU\Font\
copy /b NewerSuperMarioTourismInShimane\Font\ nsmb.d\files\EU\ItaEU\Font\
copy /b NewerSuperMarioTourismInShimane\Font\ nsmb.d\files\EU\SpaEU\Font\
copy /b NewerSuperMarioTourismInShimane\Message\ nsmb.d\files\EU\EngEU\Message\
copy /b NewerSuperMarioTourismInShimane\Message\ nsmb.d\files\EU\FraEU\Message\
copy /b NewerSuperMarioTourismInShimane\Message\ nsmb.d\files\EU\GerEU\Message\
copy /b NewerSuperMarioTourismInShimane\Message\ nsmb.d\files\EU\ItaEU\Message\
copy /b NewerSuperMarioTourismInShimane\Message\ nsmb.d\files\EU\SpaEU\Message\
copy /b NewerSuperMarioTourismInShimane\OthersP\ nsmb.d\files\EU\Layout\openingTitle\
copy /b NewerSuperMarioTourismInShimane\Layouts\ nsmb.d\files\Layout\
)

IF %GAMEID%==SMNE01 (
copy /b NewerSuperMarioTourismInShimane\Font\ nsmb.d\files\US\EngUS\Font\
copy /b NewerSuperMarioTourismInShimane\Font\ nsmb.d\files\US\FraUS\Font\
copy /b NewerSuperMarioTourismInShimane\Font\ nsmb.d\files\US\SpaUS\Font\
copy /b NewerSuperMarioTourismInShimane\Message\ nsmb.d\files\US\EngUS\Message\
copy /b NewerSuperMarioTourismInShimane\Message\ nsmb.d\files\US\FraUS\Message\
copy /b NewerSuperMarioTourismInShimane\Message\ nsmb.d\files\US\SpaUS\Message\
copy /b NewerSuperMarioTourismInShimane\OthersE\ nsmb.d\files\US\Layout\openingTitle\
copy /b NewerSuperMarioTourismInShimane\Layouts\ nsmb.d\files\Layout\
)

IF %GAMEID%==SMNJ01 (
copy /b NewerSuperMarioTourismInShimane\Font\JP\ nsmb.d\files\JP\Font\ >nul
copy /b NewerSuperMarioTourismInShimane\Message\JP\ nsmb.d\files\JP\Message\ >nul
copy /b NewerSuperMarioTourismInShimane\OthersJ\ nsmb.d\files\JP\Layout\openingTitle\
copy /b NewerSuperMarioTourismInShimane\Layouts\JP\ nsmb.d\files\Layout\
)

mkdir nsmb.d\files\NewerRes

IF %GAMEID%==SMNJ01 (
copy /b NewerSuperMarioTourismInShimane\NewerRes\JP\ nsmb.d\files\NewerRes\
mkdir nsmb.d\files\LevelSamples
)

IF %GAMEID%==SMNE01 (
copy /b NewerSuperMarioTourismInShimane\NewerRes\ nsmb.d\files\NewerRes\
mkdir nsmb.d\files\LevelSamples
)

IF %GAMEID%==SMNP01 (
copy /b NewerSuperMarioTourismInShimane\NewerRes\ nsmb.d\files\NewerRes\
mkdir nsmb.d\files\LevelSamples
)

copy /b NewerSuperMarioTourismInShimane\LevelSamples\ nsmb.d\files\LevelSamples\
copy /b NewerSuperMarioTourismInShimane\Others\charaChangeSelectContents.arc nsmb.d\files\Layout\charaChangeSelectContents\charaChangeSelectContents.arc
copy /b NewerSuperMarioTourismInShimane\Others\characterChange.arc nsmb.d\files\Layout\characterChange\characterChange.arc
copy /b NewerSuperMarioTourismInShimane\Others\continue.arc nsmb.d\files\Layout\continue\continue.arc
copy /b NewerSuperMarioTourismInShimane\Others\controllerInformation.arc nsmb.d\files\Layout\controllerInformation\controllerInformation.arc
copy /b NewerSuperMarioTourismInShimane\Others\corseSelectMenu.arc nsmb.d\files\Layout\corseSelectMenu\corseSelectMenu.arc
copy /b NewerSuperMarioTourismInShimane\Others\corseSelectUIGuide.arc nsmb.d\files\Layout\corseSelectUIGuide\corseSelectUIGuide.arc
copy /b NewerSuperMarioTourismInShimane\Others\dateFile.arc nsmb.d\files\Layout\dateFile\dateFile.arc
copy /b NewerSuperMarioTourismInShimane\Others\dateFile_OLD.arc nsmb.d\files\Layout\dateFile\dateFile_OLD.arc
copy /b NewerSuperMarioTourismInShimane\Others\easyPairing.arc nsmb.d\files\Layout\easyPairing\easyPairing.arc
copy /b NewerSuperMarioTourismInShimane\Others\extensionControllerNunchuk.arc nsmb.d\files\Layout\extensionControllerNunchuk\extensionControllerNunchuk.arc
copy /b NewerSuperMarioTourismInShimane\Others\extensionControllerYokomochi.arc nsmb.d\files\Layout\extensionControllerYokomochi\extensionControllerYokomochi.arc
copy /b NewerSuperMarioTourismInShimane\Others\fileSelectBase.arc nsmb.d\files\Layout\fileSelectBase\fileSelectBase.arc
copy /b NewerSuperMarioTourismInShimane\Others\fileSelectBase_OLD.arc nsmb.d\files\Layout\fileSelectBase\fileSelectBase_OLD.arc
copy /b NewerSuperMarioTourismInShimane\Others\fileSelectPlayer.arc nsmb.d\files\Layout\fileSelectPlayer\fileSelectPlayer.arc
copy /b NewerSuperMarioTourismInShimane\Others\gameScene.arc nsmb.d\files\Layout\gameScene\gameScene.arc
copy /b NewerSuperMarioTourismInShimane\Others\infoWindow.arc nsmb.d\files\Layout\infoWindow\infoWindow.arc
copy /b NewerSuperMarioTourismInShimane\Others\miniGameCannon.arc nsmb.d\files\Layout\miniGameCannon\miniGameCannon.arc
copy /b NewerSuperMarioTourismInShimane\Others\miniGameWire.arc nsmb.d\files\Layout\miniGameWire\miniGameWire.arc
copy /b NewerSuperMarioTourismInShimane\Others\pauseMenu.arc nsmb.d\files\Layout\pauseMenu\pauseMenu.arc
copy /b NewerSuperMarioTourismInShimane\Others\pointResultDateFile.arc nsmb.d\files\Layout\pointResultDateFile\pointResultDateFile.arc
copy /b NewerSuperMarioTourismInShimane\Others\pointResultDateFileFree.arc nsmb.d\files\Layout\pointResultDateFileFree\pointResultDateFileFree.arc
copy /b NewerSuperMarioTourismInShimane\Others\preGame.arc nsmb.d\files\Layout\preGame\preGame.arc
copy /b NewerSuperMarioTourismInShimane\Others\select_cursor.arc nsmb.d\files\Layout\select_cursor\select_cursor.arc
copy /b NewerSuperMarioTourismInShimane\Others\sequenceBG.arc nsmb.d\files\Layout\sequenceBG\sequenceBG.arc
copy /b NewerSuperMarioTourismInShimane\Others\staffCredit.arc nsmb.d\files\Layout\staffCredit\staffCredit.arc
copy /b NewerSuperMarioTourismInShimane\Others\stockItem.arc nsmb.d\files\Layout\stockItem\stockItem.arc
copy /b NewerSuperMarioTourismInShimane\Others\stockItemShadow.arc nsmb.d\files\Layout\stockItemShadow\stockItemShadow.arc
copy /b NewerSuperMarioTourismInShimane\Others\yesnoWindow.arc nsmb.d\files\Layout\yesnoWindow\yesnoWindow.arc

mkdir nsmb.d\files\Maps
copy /b NewerSuperMarioTourismInShimane\Maps\ nsmb.d\files\Maps\
mkdir nsmb.d\files\Maps\Texture
copy /b NewerSuperMarioTourismInShimane\Maps\Texture\ nsmb.d\files\Maps\Texture\
copy /b NewerSuperMarioTourismInShimane\Stages\ nsmb.d\files\Stage\

::set mod-specific variables before patching and building
SET PATCH=NR
IF %GAMEID%==SMNP01 (
	SET XML=NSMTIS
	SET GAMEID=SMNP03
	)
IF %GAMEID%==SMNE01 (
	SET XML=NSMTIS
	SET GAMEID=SMNE03
	)
IF %GAMEID%==SMNJ01 (
	SET XML=NSMTIS
	SET GAMEID=SMNJ03
	)
SET MODNAME=NewerSuperMarioTourismInShimane

IF %SLOTINPUT%==3 (
	SET SLOT=KMN
	copy /b SaveBanners\Newer\%RG%\save_banner\ nsmb.d\files\%RG%\save_banner\
	)

GOTO PATCH

:XMLMOD
for /f "tokens=* delims=" %%f in ('type riivolution\%XML%.xml') do CALL :DOREPLACE "%%f"

EXIT /b
:DOREPLACE
SET INPUT=%*
SET OUTPUT=%INPUT:80001800=803482C0%

for /f "tokens=* delims=" %%g in ('ECHO %OUTPUT%') do ECHO %%~g>>nsmb.d\%XML%-mod.xml
EXIT /b

:PATCH
:: patch main.dol before rebuilding
echo.
echo Applying %MOD% patches to main executable...

CALL :XMLMOD
wit\wit dolpatch nsmb.d/sys/main.dol ^
xml=../nsmb.d/!XML!-mod.xml -s ../%MODFOLDER%/ ^
xml=../patch/%PATCH%.xml ^
xml=../patch/AP.xml

:REBUILD

::copy custom .bnr to game directory if available
echo Searching for and copying custom banner over original...

IF EXIST banners\%GAMEID%.bnr (
	echo Custom banner found.
	echo.
	echo Checking banner file for empty 0 byte file corruption made by wget 404 error...
	for %%x in ("banners\%GAMEID%.bnr") do IF %%~zx equ 0 (
		echo.
		echo Banner %GAMEID%.bnr is empty 0 byte file, deleting...
		echo Original game's banner will be used instead.
		del banners\%GAMEID%.bnr
		) ELSE (
		echo Does not seem to be an empty 0 byte file, continuing...
		copy /b banners\%GAMEID%.bnr nsmb.d\files\opening.bnr
		)
	) ELSE (
	echo Custom Banner not found, using original game's banner instead...
	)

IF %SLOTINPUT%==1 SET SLOT=S
IF %SLOTINPUT%==2 SET SLOT=K

IF %FILEEXT%==iso (
SET DESTPATH=../%MOD%_%GAMEID%_%BASEVER%_%SLOT%-sav.%FILEEXT%
)

IF %FILEEXT%==wbfs (
	mkdir "%MODNAME% [%GAMEID%]"
	SET DESTPATH=../%MODNAME% [%GAMEID%]/%GAMEID%.%FILEEXT%
	)

echo.
echo Rebuilding NSMBW Mod [%MODNAME%] as %FILEEXT%...
wit\wit copy nsmb.d "%DESTPATH%" -ovv --disc-id=%GAMEID% --tt-id=%SLOT% --name "%MODNAME%"

:: clean up working directory
echo.
echo Cleaning up working directory files...
rmdir nsmb.d /s /q

echo.
echo ======================
echo       All done!
echo ======================
echo.

:: wait to make errors visible
pause

:iguzitto
exit
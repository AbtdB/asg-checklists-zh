@echo off

if not defined ASG_HOME (
    (echo ASG_HOME not found!)
    goto EOF
)

set SRC_DIR=%ASG_HOME%\Data
set SRC_FILENAME=Checklists_en.xml
set OUT_DIR=release
set OUT_FILENAME=Checklists_zh.xml
set DOC_FILES="README.md" "CHANGELOG.md" "LICENSE"

set TIKAL_BAT=okapi_bin\tikal.bat
set OT_TGT_DIR=omegat\target
set FPRM=okf_xml@asgChecklists

(echo === Copying doc files ===)
for %%i in (%DOC_FILES%) do (
    (echo %%~i)
    copy %%i "%OUT_DIR%\%%~i"
)

(echo === Cleaning old builds ===)
del "%OUT_DIR%\%OUT_FILENAME%"

(echo === Merging XLIFF ===)
call %TIKAL_BAT% -m "%OT_TGT_DIR%\%SRC_FILENAME%.xlf" -sd "%SRC_DIR%" -od "%OUT_DIR%" -fc %FPRM% -sl en-us -tl zh-cn
if %ERRORLEVEL% neq 0 (
    (echo === BUILD FAILED ===)
    goto EOF
)
ren "%OUT_DIR%\%SRC_FILENAME%" "%OUT_FILENAME%"

(echo === Deploying to ASG ===)
(echo %ASG_HOME%\%OUT_FILENAME%)
copy "%OUT_DIR%\%OUT_FILENAME%" "%SRC_DIR%\%OUT_FILENAME%"

(echo === DONE ===)
goto EOF

:EOF

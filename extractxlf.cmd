@echo off

cd /d "%~dp0"

if not defined ASG_HOME (
    (echo ASG_HOME not found!)
    exit /b 1
)

set SRC_FILENAME=Checklists_en.xml
set SRC_FILE=%ASG_HOME%\Data\%SRC_FILENAME%

set TIKAL_BAT=okapi_bin\tikal.bat
set OT_SRC_DIR=omegat\source
set FPRM=okf_xml@asgChecklists

(echo === Extract XLIFF to OmegaT project ===)
call %TIKAL_BAT% -x "%SRC_FILE%" -od "%OT_SRC_DIR%" -fc %FPRM% -sl en-us -tl zh-cn -safe
if %ERRORLEVEL% neq 0 (
    (echo !!! EXTRACT FAILED !!!)
    exit /b 1
)

(echo === XLIFF Extract Complete ===)

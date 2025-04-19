@echo off
mode con: cols=80 lines=25
cls

:: Hiển thị tiêu đề căn giữa
echo.
echo ======================== OBS ACTION APP MAKE BY MANGNEK ========================
echo =========================== APP WILL CHECK UPDATE ==============================
echo.
echo  ###############################################################################
echo  ###########################      MANGNEK APP        ###########################
echo  ###############################################################################

echo.
echo CHECK UPDATE.....
timeout /t 2 >nul

:: Xác định thư mục chứa repo Git (thư mục hiện tại)
set REPO_PATH=%~dp0

:: Xác định thư mục chứa ứng dụng
set APP_PATH=%REPO_PATH%App\

:: File flag để báo rằng đã update
set FLAG_FILE=%APP_PATH%update_flag.txt

:: Nếu flag tồn tại, chỉ mở app mà không kiểm tra Git
if exist "%FLAG_FILE%" (
    del "%FLAG_FILE%"
    cd /d "%APP_PATH%"
    start OBS_ACTION.exe --skip-update
    exit
)

:: Kiểm tra Git có tồn tại không
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo Vui lòng cài đặt Git để có thể cập nhật các phiên bản mới từ nhà phát hành.
    timeout /t 5 /nobreak >nul
    cd /d "%APP_PATH%"
    start OBS_ACTION.exe
    exit
)

:: Kiểm tra repo Git có tồn tại không
if not exist "%REPO_PATH%\.git" (
    cd /d "%APP_PATH%"
    start OBS_ACTION.exe
    exit
)

:: Thực hiện cập nhật
cd /d "%REPO_PATH%"

:: Bỏ qua theo dõi appsettings.json để tránh xung đột khi pull
git update-index --assume-unchanged App\appsettings.json

:: Kiểm tra phiên bản
git fetch origin main >nul 2>nul
for /f %%i in ('git rev-parse HEAD') do set LOCAL=%%i
for /f %%i in ('git rev-parse origin/main') do set REMOTE=%%i

if "%LOCAL%"=="%REMOTE%" (
    echo Ứng dụng đã cập nhật mới nhất.
) else (
    git pull origin main >nul 2>nul
    echo updated > "%FLAG_FILE%"
)

:: Quay lại thư mục chứa ứng dụng và mở app
cd /d "%APP_PATH%"
start OBS_ACTION.exe --skip-update
exit

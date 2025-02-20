@echo off
cd /d %~dp0
echo Kiểm tra Git...

:: Xác định thư mục chứa repo Git (chính là thư mục hiện tại)
set REPO_PATH=%~dp0

:: Xác định thư mục chứa ứng dụng
set APP_PATH=%REPO_PATH%App\

:: File flag để báo rằng đã update
set FLAG_FILE=%APP_PATH%update_flag.txt

:: Nếu flag tồn tại, chỉ mở app mà không kiểm tra Git
if exist "%FLAG_FILE%" (
    echo Ứng dụng đã được cập nhật trước đó. Mở ứng dụng...
    del "%FLAG_FILE%"
    cd /d "%APP_PATH%"
    start OBS_ACTION.exe --skip-update
    exit
)

:: Kiểm tra Git có tồn tại không
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo Git không được cài đặt. Mở ứng dụng bình thường...
    cd /d "%APP_PATH%"
    start OBS_ACTION.exe
    exit
)

:: Kiểm tra xem thư mục repo có tồn tại không
if not exist "%REPO_PATH%\.git" (
    echo Không phải Git repository. Mở ứng dụng bình thường...
    cd /d "%APP_PATH%"
    start OBS_ACTION.exe
    exit
)

:: Fetch từ Git
cd /d "%REPO_PATH%"
git fetch origin main

:: Kiểm tra commit mới
for /f %%i in ('git rev-parse HEAD') do set LOCAL=%%i
for /f %%i in ('git rev-parse origin/main') do set REMOTE=%%i

if "%LOCAL%"=="%REMOTE%" (
    echo Không có cập nhật mới. Mở ứng dụng...
) else (
    echo Có bản cập nhật mới! Đang cập nhật...
    git pull origin main
    echo updated > "%FLAG_FILE%"
    echo Cập nhật xong.
)

:: Quay lại thư mục chứa ứng dụng và mở app
cd /d "%APP_PATH%"
echo Đang mở ứng dụng...
start OBS_ACTION.exe --skip-update
exit

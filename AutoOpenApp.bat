@echo off
setlocal

:: Đường dẫn đến TikFinity shortcut
set "tikfinity_path=C:\Users\trung\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\zerody\TikFinity.lnk"

:: Kiểm tra file shortcut có tồn tại không
if not exist "%tikfinity_path%" (
    echo TikFinity Can't Not Find !!!!
    exit /b
)

:: Kiểm tra xem TikFinity đã chạy chưa
tasklist /FI "IMAGENAME eq TikFinity.exe" | find /I "TikFinity.exe" >nul
if %errorlevel%==0 (
    echo TikFinity Will Open !!!.
) else (
    echo TikFinity Will Open In The Secon!!!...
    start "" "%tikfinity_path%"
)

:: Tìm cửa sổ TikFinity và thu nhỏ nó bằng PowerShell
@REM powershell -Command "& { $app = Get-Process | Where-Object { $_.MainWindowTitle -match 'TikFinity' }; if ($app) { $sig = '[DllImport(\"user32.dll\")]public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'; $win32 = Add-Type -MemberDefinition $sig -Name 'Win32ShowWindowAsync' -Namespace 'Win32' -PassThru; $win32::ShowWindowAsync($app.MainWindowHandle, 2) } }"

exit

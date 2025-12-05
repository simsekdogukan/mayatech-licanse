@echo off
REM Pencere boyutunu buyuterek daha fazla bilginin sigmasini sagla
MODE CON: COLS=120 LINES=50
title Windows Bilgi ve Lisans Sorgulama ARACI - CENK KARAKOL(V.1)
REM Renk kodu 0A: Siyah Arka Plan, Açık Yeşil Yazı
color 0A
setlocal enabledelayedexpansion

REM ******************************************
REM ** VERSİYON BİLGİSİ: 4.2 (MAC/IP Eklendi) **
REM ******************************************

REM ******************************************
REM ** Ekran Temizligi ve Baslik            **
REM ******************************************
cls
echo ============================================================================
echo *** WINDOWS BILGI VE LISANS SORGULAMA ARACI - MAYATECH BILGI ISLEM (V.1) ***
echo ============================================================================

REM ******************************************
REM ** GENEL SISTEM BILGILERI               **
REM ******************************************
echo.
echo *** GENEL SISTEM BILGILERI ***
echo Bilgisayar Adi:      %computername%
echo Aktif Kullanici:     %username%

REM Seri Numarasini Powershell komutu ile al
set "SERIAL_NO=?"
for /f "tokens=*" %%a in ('powershell -command "Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty SerialNumber"') do (
    set "SERIAL_NO=%%a"
)
if not defined SERIAL_NO set "SERIAL_NO=Bulunamadi"
echo Seri Numarasi:       !SERIAL_NO!

REM PC Marka (Manufacturer) ve Model bilgisini Powershell ile al
set "PC_MARKA=?"
set "PC_MODEL=?"
for /f "tokens=*" %%a in ('powershell -command "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty Manufacturer"') do (
    set "PC_MARKA=%%a"
)
for /f "tokens=*" %%a in ('powershell -command "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty Model"') do (
    set "PC_MODEL=%%a"
)
if not defined PC_MARKA set "PC_MARKA=Bulunamadi"
if not defined PC_MODEL set "PC_MODEL=Bulunamadi"
echo Marka/Uretici:       !PC_MARKA!
echo Model:               !PC_MODEL!

REM ******************************************
REM ** İŞLEMCİ (CPU) BİLGİSİ                **
REM ******************************************
set "CPU_NAME=?"
for /f "tokens=*" %%a in ('powershell -command "Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty Name"') do (
    set "CPU_NAME=%%a"
    goto :CPU_BILGISI_ALINDI
)
:CPU_BILGISI_ALINDI
if not defined CPU_NAME set "CPU_NAME=Bulunamadi"
echo Islemci:             !CPU_NAME!

REM ******************************************
REM ** RAM VE SLOT BILGISI EKLEME           **
REM ******************************************
set "RAM_GB=?"
set "SLOT_TOPLAM=?"
set "SLOT_DOLU=?"
set "SLOT_BOS=?"

REM Toplam RAM
for /f "tokens=*" %%a in ('powershell -command "$ram = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory; [math]::Ceiling($ram / 1GB)"') do (
    set "RAM_GB=%%a"
)
set "RAM_GB=!RAM_GB: =!"
echo Yuklu RAM:           !RAM_GB! GB

REM RAM Slotlari Hesabi
for /f "tokens=*" %%a in ('powershell -command "(Get-CimInstance -ClassName Win32_PhysicalMemoryArray).MemoryDevices"') do (
    set "SLOT_TOPLAM=%%a"
    goto :SLOT_BILGISI_ALINDI
)
:SLOT_BILGISI_ALINDI

for /f "tokens=*" %%a in ('powershell -command "(Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object).Count"') do (
    set "SLOT_DOLU=%%a"
)

if "!SLOT_TOPLAM!" neq "?" if "!SLOT_DOLU!" neq "?" (
    set /a SLOT_BOS=!SLOT_TOPLAM! - !SLOT_DOLU!
) else (
    set "SLOT_BOS=?"
)

echo RAM Slotlari:        Toplam: !SLOT_TOPLAM!, Dolu: !SLOT_DOLU!, Bos: !SLOT_BOS!

REM RAM HIZ (FREKANS) DETAYI
echo.
echo RAM Modulleri (Hiz):
powershell -command "Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object BankLabel, Manufacturer, @{Name='Boyut';Expression={[math]::Round($_.Capacity / 1GB)}}, Speed | Format-Table -AutoSize | Out-String -Width 4096" | findstr /v /r /c:"^ *$"

REM ******************************************
REM ** DISK BILGISI (SSD/HDD ve Arayuz)     **
REM ******************************************
echo.
echo *** DISK BILGISI ***
echo Disk/Diskler:
powershell -command "Get-PhysicalDisk | Select-Object @{Name='Disk Adi';Expression={$_.FriendlyName}}, @{Name='Boyut';Expression={([math]::Round($_.Size / 1000000000)).ToString() + ' GB'}}, @{Name='Tip';Expression={$_.MediaType}}, @{Name='Arayuz';Expression={if ($_.BusType -eq 11) {'NVMe (PCIe)'} elseif ($_.BusType -eq 3) {'SATA'} else {'Diger (' + $_.BusType + ')'}}} | Format-Table -AutoSize | Out-String -Width 4096" | findstr /v /r /c:"^ *$"

REM ******************************************
REM ** ETKI ALANI BILGISI                   **
REM ******************************************
echo.
echo *** ETKI ALANI BILGISI ***
set "PART_OF_DOMAIN=?"
set "DOMAIN_OR_WORKGROUP=?"

for /f "tokens=*" %%a in ('powershell -command "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty PartOfDomain"') do (
    set "PART_OF_DOMAIN=%%a"
)
for /f "tokens=*" %%a in ('powershell -command "Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty Domain"') do (
    set "DOMAIN_OR_WORKGROUP=%%a"
)

if /i "!PART_OF_DOMAIN!"=="True" (
    echo Etki Alani Durumu:   DOMAIN
    echo Etki Alani Adi:      !DOMAIN_OR_WORKGROUP!
) else (
    echo Etki Alani Durumu:   WORKGROUP
    echo Calisma Grubu Adi:   !DOMAIN_OR_WORKGROUP!
)

REM ******************************************
REM ** AĞ BİLGİLERİ (IP ve MAC ADRESLERİ)   **
REM ******************************************
echo.
echo *** AG BILGILERI ***
echo.
echo Aktif Ag Baglantilari:
echo ----------------------------------------

REM Aktif network adapter bilgilerini detayli goster
powershell -command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | ForEach-Object { $adapter = $_; $ipConfig = Get-NetIPAddress -InterfaceIndex $adapter.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue | Select-Object -First 1; if ($ipConfig) { Write-Output ('Arayuz Adi     : ' + $adapter.Name); Write-Output ('MAC Adresi     : ' + $adapter.MacAddress); Write-Output ('IP Adresi      : ' + $ipConfig.IPAddress); Write-Output ('Durum          : ' + $adapter.Status); Write-Output '----------------------------------------' } }"

REM Ek olarak Gateway bilgisi
echo.
echo Gateway Bilgisi:
powershell -command "Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Select-Object -First 1 | ForEach-Object { Write-Output ('Varsayilan Gateway: ' + $_.NextHop) }"

REM DNS Sunuculari
echo.
echo DNS Sunuculari:
powershell -command "Get-DnsClientServerAddress | Where-Object {$_.ServerAddresses.Count -gt 0 -and $_.AddressFamily -eq 2} | Select-Object -First 1 | ForEach-Object { $_.ServerAddresses | ForEach-Object { Write-Output ('DNS: ' + $_) } }"

REM ******************************************
REM ** ISLETIM SISTEMI BILGISI              **
REM ******************************************
echo.
set "OS_Adi=?"
for /f "tokens=*" %%a in ('systeminfo ^| findstr /C:"Isletim Sistemi Adi" /C:"OS Name"') do (
    set "OS_Raw=%%a"
    goto :OS_BILGISI_ALINDI
)
:OS_BILGISI_ALINDI
if defined OS_Raw (
    for /f "tokens=*" %%b in ('powershell -command "('!OS_Raw:*:=!').Trim()"') do (
        set "OS_Adi=%%b"
    )
) else (
    set "OS_Adi=Bulunamadi"
)
echo Isletim Sistemi:     !OS_Adi!

REM ******************************************
REM ** WINDOWS LISANS BILGISI               **
REM ******************************************
echo.
echo *** WINDOWS LISANS BILGISI ***
cscript //nologo "%SystemRoot%\system32\slmgr.vbs" -dli | findstr /v /r /c:"^ *$"

echo.
echo =================================================================
echo Bilgiler goruntulenmistir. Kapatmak icin bir tusa basin...
pause >nul

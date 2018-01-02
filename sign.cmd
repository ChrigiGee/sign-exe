@echo off
::                                                        Unicode support for console content and file-names.
call chcp 65001 2>nul >nul

::                                                        Tools (by architecture)
set "FILE_MAKECERT=%~dp0x86\makecert.exe"
set "FILE_SIGNTOOL=%~dp0x86\signtool.exe"
if ["%PROCESSOR_ARCHITECTURE%"] == ["AMD64"] (
  set "FILE_MAKECERT=%~dp0x64\makecert.exe"
  set "FILE_SIGNTOOL=%~dp0x64\signtool.exe"
)


::========================================================================================================
set "CERT_FILE=%~dp0testing_certificate"
set STORE_NAME=testing_certificate

set ARGS=
::---------------------------------------------------------Create a self signed certificate.
set ARGS=%ARGS% -r
::---------------------------------------------------------Private key is exportable.
set ARGS=%ARGS% -pe
::---------------------------------------------------------Private key file (PVK), created if not present.
::set ARGS=%ARGS% -sv "%CERT_FILE%.pvk" 
::---------------------------------------------------------Store-name for the certificate.
set ARGS=%ARGS% -ss  "%STORE_NAME%"
::---------------------------------------------------------Store-location [CurrentUser(default)|LocalMachine].
set ARGS=%ARGS% -sr  "LocalMachine"
::---------------------------------------------------------Certificate subject X500 name.
::set ARGS=%ARGS% -n "CN=*, OU=*, O=*, L=*, S=*, C=*" ::::fails on error converting the name.
::set ARGS=%ARGS% -n "CN=*; OU=*; O=*; L=*; S=*; C=*" ::::fails on error converting the name.
::set ARGS=%ARGS% -n "CN=* OU=* O=* L=* S=* C=*"      ::::wrong - everything sits in CN.
::set ARGS=%ARGS% -n "CN=*"                           ::::ok
set ARGS=%ARGS% -n "CN=*,OU=*,O=*,L=*,S=*"
::---------------------------------------------------------Comma separated enhanced key usage OIDs
set ARGS=%ARGS% -eku "1.3.6.1.5.5.7.3.3"
::---------------------------------------------------------Algorithm [md5|sha1(default)|sha256|sha384|sha512].
set ARGS=%ARGS% -a   "sha1"
::---------------------------------------------------------Start of the validity period (default to now).
set ARGS=%ARGS% -b   "01/01/2018"
::---------------------------------------------------------End of validity period (default is 2039).
set ARGS=%ARGS% -e   "01/01/2100"
::---------------------------------------------------------Key type [signature|exchange|<integer>].
set ARGS=%ARGS% -sky "exchange"
::---------------------------------------------------------CryptoAPI provider-name.
set ARGS=%ARGS% -sp  "Microsoft RSA SChannel Cryptographic Provider"
::---------------------------------------------------------CryptoAPI provider-type.
set ARGS=%ARGS% -sy  "12"
::---------------------------------------------------------Key length in bits.
set ARGS=%ARGS% -len "2048"

del /f /q "%CERT_FILE%"  2>nul >nul
call "%FILE_MAKECERT%" %ARGS% "%CERT_FILE%.cer"
::========================================================================================================



::  call keytool.exe  -genkeypair                                     ^
::                    -alias       alias_name                       ^
::                    -keyalg      RSA                              ^
::                    -keysize     2048                             ^
::                    -sigalg      SHA1withRSA                      ^
::                    -validity    10000                            ^
::                    -keypass     111111                           ^
::                    -keystore    foo.keystore                     ^
::                    -storepass   111111                           ^
::                    -dname       CN=*, OU=*, O=*, L=*, S=*, C=*   ^
::                    -v







::------------------------------------------------------------------------------Notes: eku extensions.
::  1.3.6.1.5.5.7.3.1   id-kp-serverAuth
::                        - TLS WWW server authentication
::                        - Key usage bits that may be consistent: digitalSignature,
::                        - keyEncipherment or keyAgreement
::  1.3.6.1.5.5.7.3.2   id-kp-clientAuth
::                        - TLS WWW client authentication.
::                        - Key usage bits that may be consistent: digitalSignature.
::                        - and/or keyAgreement.
::  1.3.6.1.5.5.7.3.3   id-kp-codeSigning
::                        - Signing of downloadable executable code
::                        - Key usage bits that may be consistent: digitalSignature
::  1.3.6.1.5.5.7.3.4   id-kp-emailProtection
::                        - E-mail protection
::                        - Key usage bits that may be consistent: digitalSignature,
::                        - nonRepudiation, and/or (keyEncipherment or keyAgreement)
::  1.3.6.1.5.5.7.3.5   id-kp-timeStamping
::                        - Binding the hash of an object to a time
::                        - Key usage bits that may be consistent: digitalSignature
::                        - and/or nonRepudiation
::  1.3.6.1.5.5.7.3.6   id-kp-OCSPSigning
::                        - Signing OCSP responses
::                        - Key usage bits that may be consistent: digitalSignature
::                        - and/or nonRepudiation
::  
::  also available:
::  -nscp               Include Netscape client auth extension
::  


::UI for installing certificate:   "C:\Windows\system32\rundll32.exe" cryptext.dll,CryptExtOpenCER C:\Users\Elad\Desktop\cert-exe\testing_certificate.cer


pause
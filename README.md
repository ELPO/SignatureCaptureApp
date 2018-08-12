# SignatureCaptureApp

Project Requires Qt 5.10.0 and MSVC2017 64B with Windows as OS (developed and tested in Windows 10 64B). 

QMake should generate a fully functional build (I made It to automatically call windeployqt and copy the openssl dlls) in the SignatureCaptureApp\builds\SignatureCaptureApp\release(or debug)\bin directory.

The app should met the requeriments, including the optional goals (variable width based on speed and POST request) aswell.
I have included an options menu that allows the user the change between POST or stdout and some visual options in real time in addition to offering me the possibility of showing some Q_PROPERTY usage.

For the UI I have tried to keep it simple basing it in the color scheme of the company.

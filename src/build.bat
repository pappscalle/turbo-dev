@echo off
REM FreeDOS-compatible loop over Pascal files (to make it work with dosemu2)
for %%F in (*.pas) do call C:\TP7\BIN\TPC.EXE %%F -B -Q
echo.
exit

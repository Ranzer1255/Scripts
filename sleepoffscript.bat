@echo off
title Student 3040 micro
echo  ******************************************************************************
echo  *                                                                            *
echo  *                       Post image Installer script                          *
echo  *                 cancel any installer you dont want/need                    *
echo  *                                                                            *
echo  *              Note: Do NOT restart the computer during the scrip            *
echo  *                     the scrip will handle that for you                     *
echo  *                                                                            *
echo  *                                Ver. 1.2                                    *
echo  *                                                                            *
echo  *                           Written By Bobby D!                              *
echo  *                                                                            *
echo  ******************************************************************************
pause

rem Disables Sleep mode so that VNC can always connect
echo Disableing Sleep
powercfg -x -standby-timeout-ac 0
powercfg -x -monitor-timeout-ac 15


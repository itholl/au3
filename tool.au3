#AutoIt3Wrapper_UseX64 =n
#include <GuiToolbar.au3>
#include <WinAPI.au3>
#include <Memory.au3>
#include <GuiButton.au3>  
#include <Array.au3>

;_ToolMain()
ConsoleWrite(_IPGIsFileEncrypt(@DesktopDir&"\12.txt"))
;����main
Func _ToolMain()
   ;MsgBox(0,"test",_IPGGetSDAgentStatus())
   ;_IPGInstAgent("C:\Documents and Settings\VM-XP\����\3.59.138.513.exe")
	$apid = _IPGGetAgentPid()
	For $i = 1 To $apid[0]
		ConsoleWrite($apid[$i]&@crlf)
	Next
EndFunc   ;==>_Main

; #FUNCTIONS# ===========================================================================================================
; _ReadFile                 ; -->_ReadFile($sFileName)	��ȡָ���ĵ��������ĵ�����
; _RegDM                    ; -->_RegDM($dll_path)	ע���Į��������ش�Į�������
;_GetLocalMAC   			; -->_GetLocalMAC()	��ȡ����mac������mac��ַ������������0
;_FindWindowEx  			; -->_FindWindowEx($hPWnd,$hCWnd,$sClassName,$sWindowName)
;								�ú������һ�����ڵľ�����ô��ڵ������ʹ�������������ַ�����ƥ�䡣
;                 				������������Ӵ��ڣ������ڸ������Ӵ��ں������һ���Ӵ��ڿ�ʼ
;_IsToolBarTextExist		; -->_IsToolBarTextExist($hWnd,$sText)	�жϹ�������ť�ı��Ƿ����
;_GetToolBarText				; -->_GetToolBarText($hWnd)	��ȡ�������ı�
;_IsTrayTextExist			; -->_IsTrayTextExist($sText)	�ж������ı��Ƿ����
;_FileListEx				; -->_FileListEx($sDir)	����ָ��·���������ļ��������ļ�·��,"|"�ָ��ļ�·��
;_FindFile					; -->_FindFile($sDir,$sFileName)	���ļ�,�����ļ����ַ�����"|"�ָ�
;_WriteFile					; -->_WriteFile($sDir,$sCon)	����д���ļ�
;_WriteFileLine					; -->_WriteFileLine($sDir,$sCon)	���һ�н�����д���ļ�β��
;_FileReadLineToArray		; -->_FileReadLineToArray($sDir)		��ÿ�ж�ȡ�ĵ�������д������
;_ProcesCmdline				; -->_ProcesCmdline($sPid)		����pid��ȡ����cmdline
; =======================================================================================================================

; #IPG_FUNCTIONS# =======================================================================================================
;_IPGLoginConsole				; -->_IPGLoginConsole($sDir,$sIp,$sAccount,$sPasswd)	��¼����̨
;_IPGGetAgentVersion            ; -->_IPGGetAgentVersion()		��ȡ�ͻ��˰汾��
;_IPGGetSDAgentStatus			; -->_IPGGetSDAgentStatus()		��ȡ���ܿͻ���״̬
;_IPGInstAgent					; -->_IPGInstAgent($sDir,$bReboot)		��װ�ͻ���,��װ����������
;_IPGGetAgentPid				; -->_IPGGetAgentPid() 			��ȡ�ͻ���pid
;_IPGIsFileEncrypt				; -->_IPGIsFileEncrypt($sFileName)		�ж��ļ��Ƿ����
; =======================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......:��ȡָ���ĵ��������ĵ�����
; ===============================================================================================================================
Func _ReadFile($sFileName)
   Local $file = FileOpen($sFileName, 0)
   ; �����ֻ���򿪵��ļ�
   If $file = -1 Then Return 0
   If @error Then Return SetError(@error, @extended, 0)
   Local $sContent = FileRead($file)
   FileClose($file)
   Return $sContent
EndFunc   ;==>_ReadFile

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......:ע���Į���
; ===============================================================================================================================
Func _RegDM($dll_path)
   Local $obj = ObjCreate("dm.dmsoft")
   If Not IsObj($obj) Then
	  RunWait(@ComSpec & ' /c regsvr32 /s ' & FileGetShortName($dll_path), '', @SW_HIDE)
	  $obj = ObjCreate("dm.dmsoft")
   EndIf
   Return $obj
EndFunc   ;==>_RegDM

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......:��ȡ����mac������mac��ַ������������0
; ===============================================================================================================================
Func _GetLocalMAC()
    Global Const $wbemFlagReturnImmediately = 0x10
	Global Const $wbemFlagForwardOnly = 0x20
    Local $strComputer, $objWMIService, $colItems, $Output,$sRet
    $colItems = ""
    $strComputer = "localhost"
    $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
    $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled != 0", "WQL", _
            $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    Local $check2 = '', $check1 = ''
    If IsObj($colItems) Then
        For $objItem In $colItems
            $Output = "MAC��ַ�� " & $objItem.MACAddress & @CRLF
			$sRet = $sRet&$Output
            $Output = ""
            $check1 = $objItem.MACAddress
            If $check1 = $check2 Then
                If $check1 = '' Then Return 0
                ExitLoop
            EndIf
        Next
	 EndIf
	 Return $sRet
EndFunc   ;==>_GetLocalMAC

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......:�ú������һ�����ڵľ�����ô��ڵ������ʹ�������������ַ�����ƥ�䡣
;                 ������������Ӵ��ڣ������ڸ������Ӵ��ں������һ���Ӵ��ڿ�ʼ
; ===============================================================================================================================
Func _FindWindowEx($hPWnd,$hCWnd,$sClassName,$sWindowName)
   	Local $aResult = DllCall("user32.dll", "hwnd", "FindWindowExW","hwnd",$hPWnd,"hwnd",$hCWnd,"wstr", $sClassName, "wstr", $sWindowName)
	If @error Then
	   Return SetError(@error, @extended, 0)
	EndIf
	Return $aResult[0]
EndFunc   ;==>_FindWindowEx

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......:�жϹ�������ť�ı��Ƿ����
; ===============================================================================================================================
Func _IsToolBarTextExist($hWnd,$sText)
   Local $iButtonCount = _GUICtrlToolbar_ButtonCount($hWnd) ;���ع�������ť��
   Local $bRet
   For $i = 0 To $iButtonCount-1
	  $iIndex = _GUICtrlToolbar_IndexToCommand($hWnd,$i)
	  $sButtonText = _GUICtrlToolbar_GetButtonText ($hWnd,$iIndex)
	  If StringInStr($sButtonText,$sText) <> 0 Then
		 $bRet = True
		 ExitLoop
	  ElseIf (($sText == "") And ($i == $iButtonCount-1) )Then
		 $bRet = False
	  EndIf
   Next
   Return $bRet
EndFunc   ;==>_IsToolBarTextExist

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......:��ȡ��������ť�ı�
; ===============================================================================================================================
Func _GetToolBarText($hWnd)
   Local $iButtonCount = _GUICtrlToolbar_ButtonCount($hWnd) ;���ع�������ť��
   Local $bRet
   For $i = 0 To $iButtonCount-1
	  $iIndex = _GUICtrlToolbar_IndexToCommand($hWnd,$i)
	  $sButtonText = _GUICtrlToolbar_GetButtonText ($hWnd,$iIndex)
	  $bRet = $bRet&"|"&$sButtonText
   Next
   Return $bRet
EndFunc

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......:�ж������ı��Ƿ����
; ===============================================================================================================================
Func _IsTrayTextExist($sText)
   ;��ȡ��ͨ���������ھ��
   Local $hNTrayWnd = ControlGetHandle("[CLASS:Shell_TrayWnd]","","[CLASS:ToolbarWindow32; INSTANCE:1]")
   ;��ȡ������������ھ��
   Local $hOTrayWnd = ControlGetHandle("[CLASS:NotifyIconOverflowWindow]","","[CLASS:ToolbarWindow32; INSTANCE:1]")
   Local $bRet
   $bRet = _IsToolBarTextExist($hNTrayWnd,$sText) OR _IsToolBarTextExist($hOTrayWnd,$sText)
   Return $bRet
EndFunc   ;==>_IsTrayTextExist

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......: ����ָ��·���������ļ��������ļ�·��,"|"�ָ��ļ�·��
; ===============================================================================================================================
Func _FileListEx($sDir)
   If StringInStr(FileGetAttrib($sDir),"D")=0 Then Return SetError(1,0,"")

   Local $oFSO = ObjCreate("Scripting.FileSystemObject")
   Local $objDir
   Local $aDir = StringSplit($sDir, "|", 2)
   Local $iCnt = 0
   Local $sFiles = ""
   Do
	  $objDir = $oFSO.GetFolder($aDir[$iCnt])
	  For $aItem In $objDir.SubFolders
		 ;��չӦ�ø������, ��ָ���ļ��� If StringInStr($aItem.Name, "XXX") Then
		 $sDir &= "|" & $aItem.Path
		 ;�ļ��в�������ͨ�� StringReplace($aItem.Path, "\", "", 0, 1)��@extendedֵ���ж�
	  Next
	  ;��������ļ���,�����ļ�,$sFiles����䶼����,����� Return $sDir
	  For $aItem In $objDir.Files
		 ;��չӦ�ø��������
		 $sFiles &= $aItem.Path & "|"
		 ;����Ҫ���ļ����а���"kb"(���ִ�Сд),��Ϊ: if StringInStr($aItem.Name, "kb") Then $sFiles &= $aItem.Path & "|"
		 ;����Ӧ������������޸�: $aItem.XXX
		 ;Attributes        ���û򷵻��ļ����ļ��е�����
		 ;DateCreated   ����ָ�����ļ����ļ��еĴ������ں�ʱ�䡣ֻ��
		 ;DateLastAccessed ����ָ�����ļ����ļ��е��ϴη�������(��ʱ��)��ֻ��
		 ;DateLastModified ����ָ�����ļ����ļ��е��ϴ��޸����ں�ʱ�䡣ֻ��
		 ;ShortName   ���ذ�������8.3�ļ�����Լ��ת���Ķ��ļ���
		 ;ShortPath   ���ذ�������8.3����Լ��ת���Ķ�·����
		 ;Size    �����ļ�����ָ���ļ����ֽ����������ļ��У������ļ������е��ļ��к����ļ��е��ֽ���
		 ;Type    �����ļ����ļ��е�������Ϣ
	  Next
	  $iCnt += 1
	  If UBound($aDir) <= $iCnt Then $aDir = StringSplit($sDir, "|", 2)
   Until UBound($aDir) <= $iCnt
   If $sFiles Then $sFiles = StringTrimRight($sFiles, 1);ȥ�����ұ�"|"
   Return $sFiles
EndFunc   ;==>_FileListEx

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......: ���ļ�,�����ļ����ַ�����"|"�ָ�
; ===============================================================================================================================
Func _FindFile($sDir,$sFileName)
   Local $sFiles = _FileListEx($sDir)
   Local $aFiles = StringSplit($sFiles, "|")
   Local $sFileNametemp
   Local $iFileLoca
   Local $iFileLen
   Local $sFileRet = ""
   For $iLen = 1 To $aFiles[0] Step 1
	  ;��ȡ�ļ���(·��)����
	  $iFileLen = StringLen($aFiles[$iLen])
	  ;��ȡ�ļ�����ʼλ��
	  $iFileLoca = StringInStr($aFiles[$iLen],"\",0,-1)
	  ;��ȡ�ļ���
	  $sFileNametemp = StringRight($aFiles[$iLen],$iFileLen-$iFileLoca)
	  ;�ж��ļ����Ƿ����
	  If(StringInStr($sFileNametemp,$sFileName)) Then $sFileRet &= $aFiles[$iLen] & "|"
   Next
   If $sFileRet Then $sFileRet = StringTrimRight($sFileRet, 1)
   Return $sFileRet
EndFunc

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......: ����д���ļ�
; ===============================================================================================================================
Func _WriteFile($sDir,$sCon)
   Local $file = FileOpen($sDir, 1)

   ; ����ļ��Ƿ���д��ģʽ��
   If $file = -1 Then
	  MsgBox(0, "����", "�޷����ļ�.")
	  Exit
   EndIf

   FileWrite($file, $sCon)
   FileClose($file)
EndFunc

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......: ���һ�н�����д���ļ�β��
; ===============================================================================================================================
Func _WriteFileLine($sDir,$sCon)
   Local $file = FileOpen($sDir, 1)

   ; ����ļ��Ƿ���д��ģʽ��
   If $file = -1 Then
	  MsgBox(0, "����", "�޷����ļ�.")
	  Exit
   EndIf

   FileWriteLine($file, $sCon)
   FileClose($file)
EndFunc

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......: ��ÿ�ж�ȡ�ĵ�������д������
; ===============================================================================================================================
Func _FileReadLineToArray($sDir)
   Local $sText,$aTextArray
   Local $file = FileOpen($sDir, 0)
   ; �����ֻ���򿪵��ļ�
   If $file = -1 Then
	  MsgBox(0, "����", "�޷����ļ�.")
	  Exit
   EndIf
   ; �����ı���ֱ���ļ�����(EOF)
   While 1
	  Local $line = FileReadLine($file)
	  If @error = -1 Then ExitLoop
	  $sText &= $line&"|"
   Wend
   FileClose($file)
   $sText = StringLeft($sText,StringLen($sText)-1)
   $aTextArray = StringSplit($sText,"|")
   Return $aTextArray
EndFunc

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......: �����ƶ��ļ�N��
; ===============================================================================================================================
Func _CopyFile($sFileName, $sCopyPath, $iTimes = 1)
	If FileExists($sFileName) Then
		Local $sName,$sType,$atemp
		$sName = StringRight($sFileName, StringLen($sFileName)-StringInStr($sFileName, "\" , 0, -1))
		$atemp = StringSplit($sName , ".")
		If $atemp[0] == 2 Then
			$sName = $atemp[1]
			$sType = $atemp[2]
		EndIf
		DirCreate($sCopyPath)
		For $i = 1 To $iTimes
			FileCopy($sFileName, $sCopyPath&"\"&$sName&"_"&$i&"."&$sType, 0)
		Next
	Else
		Return 0
	EndIf	
EndFunc

; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......: �޸ı���word�ĵ�
; ===============================================================================================================================
Func _ModifyWord($sPath)
	For $i = 1 To 100
		Sleep(10000)
		ShellExecute($sPath&"modify_"&$i&".doc")
		Sleep(2000)
		WinWaitActive("modify_"&$i&".doc [����ģʽ] - Microsoft Word")
		Sleep(500)
		Send($i)
		Send("{Enter}")
		Sleep(500)
		Send("!{F4}")
		WinWaitActive("[CLASS:#32770]")
		ControlClick("[CLASS:#32770]","","[CLASS:Button; INSTANCE:1]")
	Next
EndFunc
	
; #FUNCTION# ====================================================================================================================
; Author ........: yexh
; Modified.......: 2016.06.21
; Function.......: ����pid��ȡ����cmdline
; ===============================================================================================================================
Func _ProcesCmdline($sPid)
	Local $cmdpath
	$strComputer = "."
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("Select * FROM Win32_Process Where ProcessId = "&$sPid)
	
	For $objItem In $colItems
		$cmdpath = $cmdpath& $objItem.CommandLine &"|"
		;$exepath = $objItem.ExecutablePath
	Next
	$cmdpath = StringLeft($cmdpath, StringLen($cmdpath)-1)
	Return $cmdpath
EndFunc

; #IPG_FUNCTION# ================================================================================================================
; Author ........: yexh
; Modified.......: 2016.04.28
; Function.......: ��¼����̨
; ===============================================================================================================================
Func _IPGLoginConsole($sDir,$sIp,$sAccount,$sPasswd)
   Run($sDir)
   WinWaitActive("��¼")
   ;����IP���˺ţ����롣��¼
   ControlSetText("��¼","","[CLASS:Edit;INSTANCE:1]",$sIp)
   ControlSetText("��¼","","[CLASS:Edit;INSTANCE:2]",$sAccount)
   ControlSetText("��¼","","[CLASS:Edit;INSTANCE:3]",$sPasswd)
   ControlClick ( "��¼", "ȷ��","[CLASS:Button; INSTANCE:1]")
   Sleep(2000)
   If WinExists("IP-guard V3 ����̨","��Ʒʣ��") Then
	  ControlClick("IP-guard V3 ����̨", "ȷ��", "[CLASS:Button; INSTANCE:1]")
	  Sleep(2000)
   EndIf
   If WinExists("IP-guard V3 ����̨","�����µĿ���̨") Then
	  ControlClick("IP-guard V3 ����̨", "", "[CLASS:Button; INSTANCE:2]")
	  Sleep(2000)
   EndIf
   WinWaitActive("IP-guard V3 ����̨")
   Sleep(10000)
EndFunc

; #IPG_FUNCTION# ================================================================================================================
; Author ........: yexh
; Modified.......:
; Function.......: ��ȡ�ͻ��˰汾
; ===============================================================================================================================
Func _IPGGetAgentVersion()
   Local $sVersion = FileGetVersion(@SystemDir&"\winoav3.dll")
   Return $sVersion
EndFunc

; #IPG_FUNCTION# ================================================================================================================
; Author ........: yexh
; Modified.......: 2016.04.28
; Function.......: ��ȡ���ܿͻ���״̬
; ===============================================================================================================================
Func _IPGGetSDAgentStatus()
   Local $sRet,$hNTrayWnd,$hOTrayWnd,$sText
   ;��ȡ��ͨ���������ھ��
   $hNTrayWnd = ControlGetHandle("[CLASS:Shell_TrayWnd]","","[CLASS:ToolbarWindow32; INSTANCE:1]")
   ;��ȡ������������ھ��
   $hOTrayWnd = ControlGetHandle("[CLASS:NotifyIconOverflowWindow]","","[CLASS:ToolbarWindow32; INSTANCE:1]")
   $sText = _GetToolBarText($hNTrayWnd)&_GetToolBarText($hOTrayWnd)
   If StringInStr($sText,"����ϵͳ����������") Then
	  $sRet = "�Զ��ӽ���"
   ElseIf	StringInStr($sText,"����ϵͳδ��������˫��ͼ��������ϵͳ") Then
	  $sRet = "ע������ϵͳ"
   ElseIf	StringInStr($sText,"����ϵͳδ����") Then
	  $sRet = "���ü���ϵͳ"
   ElseIf	StringInStr($sText,"����ϵͳ����������(ֻ��ģʽ)") Then
	  $sRet = "ֻ��ģʽ"
   ElseIf	StringInStr($sText,"����ϵͳ��������״̬�����ܹ�����ͣ") Then
	  $sRet = "����"
   ElseIf	StringInStr($sText,"����ϵͳ�ѽ��뱸��ģʽ") Then
	  $sRet = "����ģʽ"
   ElseIf	StringInStr($sText,"����ϵͳ����������Ȩ״̬") Then
	  $sRet = "������Ȩ����"
   ElseIf	StringInStr($sText,"����ϵͳ��������״̬�����ܹ�����ͣ����˫��ͼ�����������Ȩ") Then
	  $sRet = "������Ȩ�ǳ�"
   Else
	  $sRet = "���ܿͻ���δ����"
   EndIf
   Return $sRet
EndFunc

; #IPG_FUNCTION# ================================================================================================================
; Author ........: yexh
; Modified.......: 2016.06.20
; Function.......: ��װ�ͻ���
; ===============================================================================================================================
Func _IPGInstAgent($sDir,$bReboot = True)
	Local $sAgentType,$bAgent,$hPWnd,$hCWnd,$hGWnd
	$bAgent = False
	$sAgentType = StringRight($sDir, StringLen($sDir)-StringInStr($sDir, ".", 0, -1))
	If StringInStr($sAgentType, "exe") Then
		Run($sDir)
		$bAgent = True
	ElseIf StringInStr($sAgentType, "e32") Then
		Run(@ComSpec & ' /c "' & $sDir & '" -gui', "", @SW_HIDE)
		$bAgent = True
	EndIf
	If $bAgent Then
		WinWaitActive("��װ - �ͻ���")
		While WinExists("��װ - �ͻ���")
			If ControlCommand("��װ - �ͻ���", "", "[CLASS:Button; INSTANCE:2]", "IsEnabled") Then 
				If (StringInStr(ControlGetText("��װ - �ͻ���", "", "[CLASS:Button; INSTANCE:2]"), "���") And (Not $bReboot)) Then
					$hPWnd = _WinAPI_FindWindow("#32770" , "��װ - �ͻ���")
					$hCWnd = _FindWindowEx($hPWnd,0,"#32770","")
					For $i = 1 To 3
						$hCWnd = _WinAPI_GetWindow($hCWnd, 2)
					Next
					$hGWnd = _FindWindowEx($hCWnd,0,"Button","�����Ժ����������������")	
					_GUICtrlButton_Click($hGWnd)
				EndIf
				ControlClick("��װ - �ͻ���", "", "[CLASS:Button; INSTANCE:2]")
			EndIf
			Sleep(500)
		WEnd
	EndIf
	Return $bAgent
EndFunc

; #IPG_FUNCTION# ================================================================================================================
; Author ........: yexh
; Modified.......: 2016.06.20
; Function.......: ��ȡ�ͻ��˽���pid
; ===============================================================================================================================
Func _IPGGetAgentPid()
	Local $aTmp,$aPid[1],$aAgentMod[4] = ["WINRDLV3.EXE", "OSgwAgent.exe", "ONacAgent.exe", "sdhelper2.exe"],$smod,$scmdline,$icount
	For $i = 0 To 3
		If StringInStr($aAgentMod[$i], "WINRDLV3.EXE", 0) Then
			Local $aTmp = ProcessList($aAgentMod[$i])
			For $j = 1 To $aTmp [0][0]
				$scmdline = _ProcesCmdline($aTmp[$j][1])
				$smod = StringMid($scmdline, StringInStr($scmdline," ", 0)+1, StringInStr($scmdline,",", 0)-StringInStr($scmdline," ", 0)-1)
				_ArrayAdd($aPid, $aTmp [$j][1]&","&$smod)
				$icount += 1
			Next
		Else
			If ProcessExists($aAgentMod[$i]) Then
				_ArrayAdd($aPid, ProcessExists($aAgentMod[$i])&","&$aAgentMod[$i])
				$icount += 1
			EndIf
		EndIf
	Next
	$aPid[0] = $icount
	Return $aPid
EndFunc

; #IPG_FUNCTION# ================================================================================================================
; Author ........: yexh
; Modified.......: 2016.10.17
; Function.......: �ж��ļ��Ƿ����
; ===============================================================================================================================
Func _IPGIsFileEncrypt($sFileName)
	Local $sContent,$sTsdHead,$bRet
	$bRet = False
	$sContent = _ReadFile($sFileName)
	$sTsdHead = StringLeft($sContent, 16)
	If (StringCompare($sTsdHead, "%TSD-Header-###%") == 0) Then $bRet = True
	Return $bRet
EndFunc
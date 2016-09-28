Type PROCESSENTRY32
    dwSize As Long
    cntUsage As Long
    th32ProcessID As Long
    th32DefaultHeapID As Long
    th32ModuleID As Long
    cntThreads As Long
    th32ParentProcessID As Long
    pcPriClassBase As Long
    dwFlags As Long
    szexeFile As String * 260
End Type

'-------------------------------------------------------

Declare Function OpenProcess Lib "kernel32.dll" (ByVal dwDesiredAccess As Long, _
ByVal blnheritHandle As Long, ByVal dwAppProcessId As Long) As Long

Declare Function ProcessFirst Lib "kernel32.dll" Alias "Process32First" (ByVal hSnapshot As Long, _
uProcess As PROCESSENTRY32) As Long

Declare Function ProcessNext Lib "kernel32.dll" Alias "Process32Next" (ByVal hSnapshot As Long, _
uProcess As PROCESSENTRY32) As Long

Declare Function CreateToolhelpSnapshot Lib "kernel32.dll" Alias "CreateToolhelp32Snapshot" ( _
ByVal lFlags As Long, lProcessID As Long) As Long

Declare Function TerminateProcess Lib "kernel32.dll" (ByVal ApphProcess As Long, _
ByVal uExitCode As Long) As Long

Declare Function CloseHandle Lib "kernel32.dll" (ByVal hObject As Long) As Long

Function RunningProcess(NameProcess As String) As Boolean
    'E.G. NameProcess = "Quick Access Toolkit.exe"
    
    Const PROCESS_ALL_ACCESS = &H1F0FFF
    Const TH32CS_SNAPPROCESS As Long = 2&
    Dim uProcess  As PROCESSENTRY32
    Dim RProcessFound As Long
    Dim hSnapshot As Long
    Dim SzExename As String
    Dim ExitCode As Long
    Dim MyProcess As Long
    Dim AppKill As Boolean
    Dim AppCount As Integer
    Dim i As Integer
    Dim WinDirEnv As String
         
        If NameProcess <> "" Then
           AppCount = 0

           uProcess.dwSize = Len(uProcess)
           
           'Takes a snapshot of the specified processes, as well as the heaps, modules, and threads used by these processes
           'https://msdn.microsoft.com/en-us/library/windows/desktop/ms682489(v=vs.85).aspx
           hSnapshot = CreateToolhelpSnapshot(TH32CS_SNAPPROCESS, 0&)
           
           'Get the first process off the heap
           'RProcessFound is simply a boolean - 'Was a process found?'
           'hSnapshot is the handle to the heap
           'uProcess is the process variable type
           RProcessFound = ProcessFirst(hSnapshot, uProcess)
              
           Do
             'find character(0) in returned process executable
             i = InStr(1, uProcess.szexeFile, Chr(0))
             
             'Trim to get process name
             SzExename = LCase$(Left$(uProcess.szexeFile, i - 1))
             
             'Get path of "WINDOWS" folder i.e. "C:\WINDOWS"
             WinDirEnv = Environ("Windir") + "\"
             WinDirEnv = LCase$(WinDirEnv)
             
             'if name of process = szexeFile of uProcess then the process is running
             If Right$(SzExename, Len(NameProcess)) = LCase$(NameProcess) Then
                RunningProcess = True
                Exit Function
             End If
             
             'Get the next process off the heap - Similar as before
             RProcessFound = ProcessNext(hSnapshot, uProcess)
           
           'Continue while a process has been found
           Loop While RProcessFound
           
           'Close handle to the heap
           Call CloseHandle(hSnapshot)
        End If
End Function

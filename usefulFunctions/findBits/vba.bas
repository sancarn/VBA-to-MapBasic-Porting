

Function findBits(k as Variant)
  'Function can cause a long hang!!
  k = 0
  While True
    On Error GoTo EndSub
      k=k+1
    On Error GoTo 0
  Wend
  Exit Function
EndSub:
  findBits = Log(Int(k-1)) / Log(2)
End Function

Sub testK()
  Dim k as Integer
  Debug.print findBits(k)
End Sub

SetCapsLockState AlwaysOff
SetTitleMatchMode, 2

; £ -> Remapping:On/Off
LShift & $::Suspend

; § <-> Switch in and out of vim
vkA0 & vkDF::
if WinActive("Ubuntu") || WinActive("melandel@")  || WinActive(" - VIM") {
	Send !{Tab}
} else if WinActive("GVIM"){
	Send ^z
} else {
	Send #{vk31}
}
return

;;; CAPSLOCK ;;;
; CapsLock -> Escape
; #If is necessary, otherwise using remote desktop with ahk on both local and remote sends esc every time capslock key is up (because of the double send of esc, one from the local, one from the remote)
#If  !WinActive("Remote Desktop Connection")
CapsLock::Send {esc}
#If

; CapsLock + Key -> Ctrl + Key
CapsLock & $::Send ^$
CapsLock & a::Send ^a
CapsLock & b::Send ^b
CapsLock & c::Send ^c
CapsLock & d::Send ^d
CapsLock & e::Send ^e
CapsLock & f::Send ^f
CapsLock & g::Send ^g
CapsLock & h::Send ^h
CapsLock & i::Send ^i
#If !(WinActive("GVIM") || WinActive("Ubuntu") || WinActive("melandel@") || WinActive(" - VIM"))
CapsLock & i::Send {Tab}
#If
CapsLock & j::Send ^j
CapsLock & k::Send ^k
CapsLock & l::Send ^l
CapsLock & m::Send ^m
CapsLock & n::Send ^n
CapsLock & o::Send ^o
#If !(WinActive("GVIM") || WinActive("Ubuntu") || WinActive("melandel@") || WinActive(" - VIM"))
CapsLock & o::Send +{Tab}
#If
CapsLock & p::Send ^p
CapsLock & q::Send ^q
#If WinActive("Guild Wars")
CapsLock & q::Send {esc}
#If
CapsLock & r::Send ^r
CapsLock & s::Send ^s
CapsLock & t::Send ^t
CapsLock & u::Send ^+{Home}{Backspace}
#If (WinActive("GVIM") || WinActive("Ubuntu") || WinActive("melandel@") || WinActive(" - VIM"))
CapsLock & u::Send ^u
#If
CapsLock & v::Send ^v
CapsLock & w:: Send ^+{Left}{Backspace}
#If (WinActive("GVIM") || WinActive("Ubuntu") || WinActive("melandel@") || WinActive(" - VIM"))
CapsLock & w::Send ^w
#If
CapsLock & x::Send ^x
CapsLock & y::Send ^y
CapsLock & z::Send ^z
CapsLock & Tab::
If  GetKeyState("Shift")
	Send ^+{Tab}
Else
	Send ^{Tab}
return

; CapsLock + Alphanumeric key <=> Windows + Alphanumeric key
CapsLock & vk31::Send #{vk31}
CapsLock & vk32::Send #{vk32}
CapsLock & vk33::Send #{vk33}
CapsLock & vk34::Send #{vk34}
CapsLock & vk35::Send #{vk35}
CapsLock & vk36::Send #{vk36}
CapsLock & vk37::Send #{vk37}
CapsLock & vk38::Send #{vk38}
CapsLock & vk39::Send #{vk39}
CapsLock & vk30::Send #{vk30}

; Capslock & ù <-> Windows
CapsLock & vkC0::Send {LWin down}{LWin up}

; CapsLock + [,/;] <=> Down/Up
CapsLock & vkBC::Send {Down}
CapsLock & vkBE::Send {Up}

; ² -> Screenshot
#If !WinActive("Warcraft III")
vkDE::Send {PrintScreen}
#If

#If !(WinActive("GVIM") || WinActive("Ubuntu") || WinActive("melandel@") || WinActive(" - VIM"))
; Close window
CapsLock & q::Send !{F4}

; Enter, Arrows, Backspace / Del
CapsLock & m::Send {Enter}
CapsLock & h::Send {Backspace}
CapsLock & x::Send {Del}
CapsLock & l::Send {Del}
CapsLock & n::
If GetKeyState("Shift", "P")
 Send ^+{Down}
Else
	Send {Down}
Return
CapsLock & p::
If GetKeyState("Shift", "P")
 Send ^+{Up}
Else
	Send {Up}
Return
CapsLock & j::
If GetKeyState("Shift", "P")
 Send ^+{Left}
Else
	Send {Left}
Return
CapsLock & k::
If GetKeyState("Shift", "P")
 Send ^+{Right}
Else
	Send {Right}
Return
#If

;;; caret (^) ;;;
$vkDD::
	if waitingForNextKey
	{
		SendInput, {vkDD}{vkDD}
		waitingForNextKey := false
	}
	else
	{
		SetTimer TriggerTimeout, -200
		waitingForNextKey := true
	}
return
TriggerTimeout:
	waitingForNextKey := false
return
#If waitingForNextKey
j::
	SendInput, {Home}
	waitingForNextKey := false
return
k::
	SendInput, {End}
	waitingForNextKey := false
return
q::
	SendInput, {LCtrl down}{RAlt down}{vk34}{RAlt up}{LCtrl up}
	waitingForNextKey := false
	;{
return
s::
	SendInput, {LCtrl down}{RAlt down}{vk35}{RAlt up}{LCtrl up}
	waitingForNextKey := false
	;[
return
d::
	SendInput, {LCtrl down}{RAlt down}{vkDB}{RAlt up}{LCtrl up}
	waitingForNextKey := false
	;]
return
f::
	SendInput, {LCtrl down}{RAlt down}{vkBB}{RAlt up}{LCtrl up}
	waitingForNextKey := false
	;}
return
g::
	SendInput, {LCtrl down}{RAlt down}{vk37}{LCtrl up}{RAlt up}{space}
	waitingForNextKey := false
	;`
return
h::
	SendInput, .
	waitingForNextKey := false
	;@@
return
l::
	SendInput, {`%}
	waitingForNextKey := false
return
w::
	SendInput, {LCtrl down}{RAlt down}{vk32}{RAlt up}{LCtrl up}{space}
	waitingForNextKey := false
	;~
return
x::
	SendInput, {LCtrl down}{RAlt down}{vk33}{RAlt up}{LCtrl up}
	waitingForNextKey := false
	;#
return
c::
	SendInput, {LCtrl down}{RAlt down}{vk36}{RAlt up}{LCtrl up}
	waitingForNextKey := false
	;|
return
v::
	Send, /
	waitingForNextKey := false
return
b::
	SendInput, {LCtrl down}{RAlt down}{vk38}{RAlt up}{LCtrl up}
	waitingForNextKey := false
	;\
return
n::
	Send {LCtrl down}{RAlt down}{vk30}{RAlt up}{LCtrl up}
	waitingForNextKey := false
	;@
return
$a::
	Send, {vkDD}a
	waitingForNextKey := false
return
$e::
	Send, {vkDD}e
	waitingForNextKey := false
return
u::
	Send, {vkDD}u
	waitingForNextKey := false
return
i::
	Send, {vkDD}i
	waitingForNextKey := false
return
$o::
	send, {vkDD}o
	waitingfornextkey := false
return
$Space::
	send, {vkDD}{Space}
	waitingfornextkey := false
return
z::
if WinActive("MozillaWindowClass") {
	Send !{Tab}
} else {
	Send, #{vk32}
}
waitingfornextkey := false
return
r::
	send, {LCtrl down}{RAlt down}{Tab}{RAlt up}{LCtrl up}
	waitingfornextkey := false
return
t::
 send, #d
	waitingfornextkey := false
return
p::
	SendInput, {LCtrl down}{RAlt down}{vk30}{vk30}{RAlt up}{LCtrl up}
	waitingfornextkey := false
	;@@
return
m::
	SendInput, {LCtrl down}{RAlt down}{vk03 down}{vk03 up}{RAlt up}{LCtrl up}
	waitingfornextkey := false
return
#If

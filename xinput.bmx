SuperStrict

Module Pub.XInput
Import Pub.Win32

Rem
//
// Flags For XINPUT_CAPABILITIES
//
#define XINPUT_CAPS_VOICE_SUPPORTED     0x0004

//
// Constants For gamepad buttons
//
#define XINPUT_GAMEPAD_DPAD_UP          0x0001
#define XINPUT_GAMEPAD_DPAD_DOWN        0x0002
#define XINPUT_GAMEPAD_DPAD_LEFT        0x0004
#define XINPUT_GAMEPAD_DPAD_RIGHT       0x0008
#define XINPUT_GAMEPAD_START            0x0010
#define XINPUT_GAMEPAD_BACK             0x0020
#define XINPUT_GAMEPAD_LEFT_THUMB       0x0040
#define XINPUT_GAMEPAD_RIGHT_THUMB      0x0080
#define XINPUT_GAMEPAD_LEFT_SHOULDER    0x0100
#define XINPUT_GAMEPAD_RIGHT_SHOULDER   0x0200
#define XINPUT_GAMEPAD_A                0x1000
#define XINPUT_GAMEPAD_B                0x2000
#define XINPUT_GAMEPAD_X                0x4000
#define XINPUT_GAMEPAD_Y                0x8000


//
// Gamepad thresholds
//
#define XINPUT_GAMEPAD_LEFT_THUMB_DEADZONE  7849
#define XINPUT_GAMEPAD_RIGHT_THUMB_DEADZONE 8689
#define XINPUT_GAMEPAD_TRIGGER_THRESHOLD    30

//
// Flags To pass To XInputGetCapabilities
//
#define XINPUT_FLAG_GAMEPAD             0x00000001
End Rem

'
' Flags For XINPUT_CAPABILITIES
'
Const XINPUT_CAPS_VOICE_SUPPORTED%			=$0004

'
' Constants For gamepad buttons
'
Const XINPUT_GAMEPAD_DPAD_UP%          		=$0001
Const XINPUT_GAMEPAD_DPAD_DOWN%        		=$0002
Const XINPUT_GAMEPAD_DPAD_LEFT%        		=$0004
Const XINPUT_GAMEPAD_DPAD_RIGHT%       		=$0008
Const XINPUT_GAMEPAD_START%            		=$0010
Const XINPUT_GAMEPAD_BACK%             		=$0020
Const XINPUT_GAMEPAD_LEFT_THUMB%       		=$0040
Const XINPUT_GAMEPAD_RIGHT_THUMB%      		=$0080
Const XINPUT_GAMEPAD_LEFT_SHOULDER%    		=$0100
Const XINPUT_GAMEPAD_RIGHT_SHOULDER%   		=$0200
Const XINPUT_GAMEPAD_A%                		=$1000
Const XINPUT_GAMEPAD_B%                		=$2000
Const XINPUT_GAMEPAD_X%                		=$4000
Const XINPUT_GAMEPAD_Y%                		=$8000

'
' Gamepad thresholds
'
Const XINPUT_GAMEPAD_LEFT_THUMB_DEADZONE%  	=7849
Const XINPUT_GAMEPAD_RIGHT_THUMB_DEADZONE% 	=8689
Const XINPUT_GAMEPAD_TRIGGER_THRESHOLD%    	=30

'
' Flags To pass To XInputGetCapabilities
'
Const XINPUT_FLAG_GAMEPAD%             		=$00000001

Rem
typedef struct _XINPUT_GAMEPAD
{
    WORD                                wButtons;
    Byte                                bLeftTrigger;
    Byte                                bRightTrigger;
    Short                               sThumbLX;
    Short                               sThumbLY;
    Short                               sThumbRX;
    Short                               sThumbRY;
} XINPUT_GAMEPAD, *PXINPUT_GAMEPAD;

typedef struct _XINPUT_STATE
{
    DWORD                               dwPacketNumber;
    XINPUT_GAMEPAD                      Gamepad;
} XINPUT_STATE, *PXINPUT_STATE;

typedef struct _XINPUT_VIBRATION
{
    WORD                                wLeftMotorSpeed;
    WORD                                wRightMotorSpeed;
} XINPUT_VIBRATION, *PXINPUT_VIBRATION;

typedef struct _XINPUT_CAPABILITIES
{
    Byte                                Type;
    Byte                                SubType;
    WORD                                Flags;
    XINPUT_GAMEPAD                      Gamepad;
    XINPUT_VIBRATION                    Vibration;
} XINPUT_CAPABILITIES, *PXINPUT_CAPABILITIES;
End Rem

Type XINPUT_GAMEPAD

	Field wButtons:Short
	Field bLeftTrigger:Byte
	Field bRightTrigger:Byte
	Field sThumbLX:Short
	Field sThumbLY:Short
	Field sThumbRX:Short
	Field sThumbRY:Short

End Type

Type XINPUT_STATE

	Field dwPacketNumber:Int
	Field Gamepad:XINPUT_GAMEPAD

End Type

Type XINPUT_VIBRATION

	Field wLeftMotorSpeed:Short
	Field wRightMotorSpeed:Short

End Type

Type XINPUT_CAPABILITIES

	Field cType:Byte
	Field SubType:Byte
	Field Flags:Short
	Field Gamepad:XINPUT_GAMEPAD
	Field Vibration:XINPUT_VIBRATION

End Type

Rem
DWORD WINAPI XInputGetState
(
    __in  DWORD         dwUserIndex,  // Index of the gamer associated with the device
    __out XINPUT_STATE* pState        // Receives the Current state
);

DWORD WINAPI XInputSetState
(
    __in DWORD             dwUserIndex,  // Index of the gamer associated with the device
    __in XINPUT_VIBRATION* pVibration    // The vibration information To send To the controller
);

DWORD WINAPI XInputGetCapabilities
(
    __in  DWORD                dwUserIndex,   // Index of the gamer associated with the device
    __in  DWORD                dwFlags,       // Input flags that identify the device Type
    __out XINPUT_CAPABILITIES* pCapabilities  // Receives the capabilities
);

void WINAPI XInputEnable
(
    __in BOOL enable     // [in] Indicates whether xinput is enabled Or disabled. 
);

DWORD WINAPI XInputGetDSoundAudioDeviceGuids
(
    __in  DWORD dwUserIndex,          // Index of the gamer associated with the device
    __out GUID* pDSoundRenderGuid,    // DSound device ID For render
    __out GUID* pDSoundCaptureGuid    // DSound device ID For capture
);
End Rem

Global _xinputLib:Int

Global XInputGetState:Int( userIndex:Int,state:Byte Ptr ) "Win32"
Global XInputSetState:Int( userIndex:Int,vibration:Byte Ptr ) "Win32"
Global XInputGetCapabilities:Int( userIndex:Int,flags:Int,capabilities:Byte Ptr ) "Win32"
Global XInputEnable:Int( enable:Int ) "Win32"
Global XInputGetDSoundAudioDeviceGuids( userIndex:Int,dsoundRenderGuid:Byte Ptr,dsoundCaptureGuid:Byte Ptr ) "Win32"

_xinputLib=LoadLibraryA( "xinput9_1_0.dll" )
If Not _xinputLib Then _xinputLib=LoadLibraryA( "xinput1_3.dll" )

If _xinputLib Then

	XInputGetState=GetProcAddress( _xinputLib,"XInputGetState" )
	XInputSetState=GetProcAddress( _xinputLib,"XInputSetState" )
	XInputGetCapabilities=GetProcAddress( _xinputLib,"XInputGetCapabilities" )
	XInputEnable=GetProcAddress( _xinputLib,"XInputEnable" )
	XInputGetDSoundAudioDeviceGuids=GetProcAddress( _xinputLib,"XInputGetDSoundAudioDeviceGuids" )

End If

Function XInputLoaded:Int()

	Return ( _xinputLib<>0 )

End Function






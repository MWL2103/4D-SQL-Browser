//%attributes = {"invisible":true}
/* Method: Alert2 

  Purpose: Opens a custom Alert dialog.  This function can be overloaded
           to allow support for legacy code.

  Parameters: 
    $1 - {variant} Parameters Object (or message text if legacy)

  Legacy parameters:
    $2 - {longint} Timer value in seconds
    $3 - {text} OK button title
    $4 - {text} Icon name to display

  Version: 2.0 - 09/18/2021 - MWL

  Property: Invisible

  Risk Assessment: 
     LOW - Simple code.

  NOTES: The method supports overloading by testing $1 to be an object or text. 
         If text, it is assumed to be overloaded legacy call.

         The Alert doesn't show on 4D Server or Web Server by default, unless
         "ALrT_Must_Show_b" property is set to True.

/* USAGE EXAMPLES:

   #1:  $Dialog_ob:=New object("ALrT_Msg_t";"This is a test")
        Alert2 ($Dialog_ob)
  ----------------------------------------------------
   #2:  Alert2 (New object("ALrT_Msg_t";"This is a test"))
  ----------------------------------------------------
   OVERLOADED EXAMPLES:

   #3:  Alert2("AlertText")
  ----------------------------------------------------
   #4:  Alert2("AlertText" {;AlertDelay {;"AlertButtonText" {;"IconName"}}})
----------------------------------------------------*/

/* Object Properties:

    "ALrT_Msg_t": Alert message to display (Supports <SPAN> HTML tags)

    "ALrT_Delay_l": Time to wait in seconds before auto-closing (Default 60).
                    Pass 0 in delay to keep dialog up until the user action
                    dismisses the dialog

    "ALrT_OK_Text_t": OK button title on dialog (Default "OK").

    "ALrT_IconName_t": Icon type: (Default Warn_Orange)
                       Error_Red, Error_Orange, Error_Blue, Error_Green
                       Warn_Red, Warn_Orange, Warn_Blue, Warn_Green
                       Info_Red, Info_Orange, Info_Blue, Info_Green

    "ALrT_Must_Show_b": If True, shows on 4D Server or when current user is
                        "Web Server" or "WebServer".

    Return Properties:
       "FORM_Action_t": Returns "ak accept" only when the OK button is clicked,
                        otherwise "ak cancel" if timeout or close box.

       "FORM_Timed_Out_b": True when a timeout condition occurs. The "FORM_Action_t"
                           property is set to "ak cancel".

       "FORM_Close_Box_b": True when user clicks the close box. The "FORM_Action_t"
                           property is set to "ak cancel".
*/
----------------------------------------------------*/

var $1 : Variant
var $2 : Integer  // Optional overloading only
var $3; $4 : Text  // Optional overloading only

var $Dialog_ob : Object
var $J; $Win_Ref_l : Integer

// Set defaults
If (Value type($1)=Is object)
	$Dialog_ob:=$1
	
Else   // Convert legacy values
	$Dialog_ob:=New object("ALrT_Msg_t"; $1+"")  // Add "" to force it's type to text
	For ($J; 2; Count parameters)
		Case of 
			: ($J=2)  // If ALrT_Delay_l
				If ($2<0)  // If negative
					$Dialog_ob.ALrT_Delay_l:=0  //don't allow negatives ... it will mess the timer up if -1 is sent
					
				Else   // Not negative
					$Dialog_ob.ALrT_Delay_l:=$2
				End if 
				
			: ($J=3)  // If ALrT_OK_Text_t
				If (Not($3=""))
					$Dialog_ob.ALrT_OK_Text_t:=$3
				End if 
				
			: ($J=4)  // If ALrT_IconName_t
				If (Not($4=""))
					$Dialog_ob.ALrT_IconName_t:=$4
				End if 
				
			Else   // No more parameter matches
				// Do nothing
		End case 
	End for 
End if 

If (OB Get($Dialog_ob; "ALrT_Must_Show_b"; Is boolean)=False) & \
((Application type=4D Server) | (Current user="WebServer") | (Current user="Web Server"))
	// By default don't show alerts on server
	// Maybe an email could go here for Server Alerts?
	
Else   // Continue processing
	//----------------------------------------------------
	If ($Dialog_ob.ALrT_Msg_t=Null)  // If no message
		$Dialog_ob.ALrT_Msg_t:="N/A"
		
	Else 
		If ($Dialog_ob.ALrT_Msg_t="")  // If <blank> message
			$Dialog_ob.ALrT_Msg_t:="N/A"
		End if 
	End if 
	//----------------------------------------------------
	If ($Dialog_ob.ALrT_Delay_l=Null)
		$Dialog_ob.ALrT_Delay_l:=60  //seconds
		
	Else 
		If ($Dialog_ob.ALrT_Delay_l<0)
			$Dialog_ob.ALrT_Delay_l:=0  //don't allow negatives ... it will mess the timer up if -1 is sent
		End if 
	End if 
	//----------------------------------------------------
	If ($Dialog_ob.ALrT_OK_Text_t=Null)
		$Dialog_ob.ALrT_OK_Text_t:="OK"
		
	Else 
		If ($Dialog_ob.ALrT_OK_Text_t="")
			$Dialog_ob.ALrT_OK_Text_t:="OK"
		End if 
	End if 
	//----------------------------------------------------
	If ($Dialog_ob.ALrT_IconName_t=Null)
		$Dialog_ob.ALrT_IconName_t:="Warn_Orange"
		
	Else 
		If ($Dialog_ob.ALrT_IconName_t="")
			$Dialog_ob.ALrT_IconName_t:="Warn_Orange"
		End if 
	End if 
	//----------------------------------------------------
	If (Is macOS)  // If Mac OS X
		$Win_Ref_l:=Open form window("Alert2"; Choose(Macintosh option down; Movable dialog box; Sheet form window))  // HERE FOR MY CONVENIENCE - MWL
		
	Else   // Windows OS
		$Win_Ref_l:=Open form window("Alert2"; Movable dialog box; Horizontally centered; Vertically centered)
	End if 
	
	SET WINDOW TITLE("Alert")
	DIALOG("Alert2"; $Dialog_ob)
	CLOSE WINDOW($Win_Ref_l)
End if 

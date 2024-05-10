//%attributes = {"invisible":true}
/* Method: Confirm2 
      
  Purpose: Opens a custom Confirm dialog.  This function can be overloaded
           to allow support for legacy code.
      
  Parameters:  
    $0 - {longint} 0 when canceled, else 1
    $1 - {variant} Parameters Object (or message text if legacy)

  Legacy parameters:
    $2 - {text} OK button title
    $3 - {text} Cancel button title
    $4 - {longint} Timer value in seconds
    $5 - {text} Icon name to display

  Version: 2.0 - 09/18/2021 - MWL
      
  Property: Invisible 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: The method supports overloading by testing $1 to be an object or text. 
         If text, it is assumed to be overloaded legacy call.

/* USAGE EXAMPLES:
  ----------------------------------------------------
   #1:  $Dialog_ob:=New object("CoNF_Msg_t"; $Text_t)
        Confirm2($Dialog_ob) -> 1 or 0
  ----------------------------------------------------
   #2:  Confirm2(New object("CoNF_Msg_t"; $Text_t; "CoNF_OK_Text_t"; "Okay")) -> 1 or 0
  ----------------------------------------------------
   OVERLOADED EXAMPLES:

   #3:  Confirm2("Confirmation text") -> 1 or 0

   #4:  Confirm2("Message" {;"YesButton" {;"NoButton" {;Delay {;"IconName"}}}}) -> 1 or 0
----------------------------------------------------*/

/* Object Properties:

    "CoNF_Msg_t": Message to display (Supports <SPAN> HTML tags)

    "CoNF_Delay_l": Time to wait in seconds before auto-closing (Default 60).
                    Pass 0 in delay to keep dialog up until the user action
                    dismisses the dialog

    "CoNF_OK_Text_t": OK button title on dialog (Default "OK").
 
    "CoNF_Cancel_Text_t": Cancel button title on dialog (Default "Cancel").

    "CoNF_AutoClose_Btn_l": Button chosen on timeout; 0 = OK button, 1 = Cancel button.
                            Default is 1.  The value will effect the wording shown in
                            the "CoNF_AutoCloseMsg_t" timeout message.

    "CoNF_Auto_Close_HTML_Tags_t": Optional <SPAN> type HTML tags (e.g. "color:Red"
                                   and/or "font-weight:bold")
                                   Ref: https://www.w3schools.com/colors/colors_names.asp

    "CoNF_IconName_t": Icon type - Default Warn_Orange
                       Error_Red, Error_Orange, Error_Blue, Error_Green
                       Warn_Red, Warn_Orange, Warn_Blue, Warn_Green
                       Info_Red, Info_Orange, Info_Blue, Info_Green

    Return Properties:
       "FORM_Action_t": Returns "ak accept" only when the OK button is clicked,
                        otherwise "ak cancel".

       "FORM_Timed_Out_b": True when a timeout condition occurs. The "FORM_Action_t"
                           property is set to "ak cancel".

       "FORM_Close_Box_b": True when user clicks the close box. The "FORM_Action_t"
                           property is set to "ak cancel".
*/
----------------------------------------------------*/

var $1 : Variant
var $0; $4 : Integer  // Optional overloading only
var $2; $3; $5 : Text  // Optional overloading only

var $Dialog_ob : Object
var $J; $Win_Ref_l : Integer

If (Value type($1)=Is object)
	$Dialog_ob:=$1
	
Else   // Convert legacy values
	$Dialog_ob:=New object("CoNF_Msg_t"; $1+"")  // Add "" to force it's type to text
	For ($J; 2; Count parameters)
		Case of 
			: ($J=2)  // If CoNF_OK_Text_t set button title
				If (Not($2=""))
					$Dialog_ob.CoNF_OK_Text_t:=$2
				End if 
				
			: ($J=3)  // If CoNF_Cancel_Text_t set button title
				If (Not($3=""))
					$Dialog_ob.CoNF_Cancel_Text_t:=$3
				End if 
				
			: ($J=4)  // If CoNF_Delay_l
				If ($4<0)  // If negative
					$Dialog_ob.CoNF_Delay_l:=0  //don't allow negatives ... it will mess the timer up if -1 is sent
					
				Else   // Not negative
					$Dialog_ob.CoNF_Delay_l:=$4
				End if 
				
			: ($J=5)  // If CoNF_IconName_t
				If (Not($5=""))
					$Dialog_ob.CoNF_IconName_t:=$5
				End if 
				
			Else   // No more parameter matches
				// Do nothing
		End case 
	End for 
End if 
//----------------------------------------------------
If ($Dialog_ob.CoNF_OK_Text_t=Null)  // Set OK button title
	$Dialog_ob.CoNF_OK_Text_t:="OK"
	
Else 
	If ($Dialog_ob.CoNF_OK_Text_t="")
		$Dialog_ob.CoNF_OK_Text_t:="OK"
	End if 
End if 
//----------------------------------------------------
If ($Dialog_ob.CoNF_Cancel_Text_t=Null)  // Set Cancel button title
	$Dialog_ob.CoNF_Cancel_Text_t:="Cancel"
	
Else 
	If ($Dialog_ob.CoNF_Cancel_Text_t="")
		$Dialog_ob.CoNF_Cancel_Text_t:="Cancel"
	End if 
End if 
//----------------------------------------------------
If ($Dialog_ob.CoNF_Msg_t=Null)
	$Dialog_ob.CoNF_Msg_t:="N/A"  //seconds
	
Else 
	If ($Dialog_ob.CoNF_Msg_t="")
		$Dialog_ob.CoNF_Msg_t:="N/A"  //seconds
	End if 
End if 
//----------------------------------------------------
If ($Dialog_ob.CoNF_Delay_l=Null)
	$Dialog_ob.CoNF_Delay_l:=60  //seconds
	
Else 
	If ($Dialog_ob.CoNF_Delay_l<0)
		$Dialog_ob.CoNF_Delay_l:=0  //don't allow negatives ... it will mess the timer up if -1 is sent
	End if 
End if 
//----------------------------------------------------
If ($Dialog_ob.CoNF_IconName_t=Null)
	$Dialog_ob.CoNF_IconName_t:="Info_Blue"
	
Else 
	If ($Dialog_ob.CoNF_IconName_t="")
		$Dialog_ob.CoNF_IconName_t:="Info_Blue"
	End if 
End if 
//----------------------------------------------------
If (Is macOS)  // If Mac OS X
	$Win_Ref_l:=Open form window("Confirm2"; Choose(Macintosh option down; Movable dialog box; Sheet form window))  // HERE FOR MY CONVENIENCE - MWL
	
Else   // Windows OS
	$Win_Ref_l:=Open form window("Confirm2"; Movable dialog box; Horizontally centered; Vertically centered)
End if 

SET WINDOW TITLE("Confirm")
DIALOG("Confirm2"; $Dialog_ob)
CLOSE WINDOW($Win_Ref_l)

$0:=Num(OB Get($Dialog_ob; "FORM_Action_t"; Is text)=ak accept)

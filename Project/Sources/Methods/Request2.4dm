//%attributes = {"invisible":true}
/* Method: Request2
      
  Purpose: Displays a request dialog box with a message, a text input area, an OK
           button, and a Cancel Button.  The input area has options that allow for
           a Name/Value popup choice of values.

  Parameters:  
    $0 - {text} User input results
    $1 - {variant} Parameters Object or message text

  Legacy parameters:
    $2 - {text} Default input value to be displayed
    $3 - {text} OK button title
    $4 - {text} Cancel button title
    $5 - {longint} Timer value in seconds

  Version: 2.1 - 03/01/2022 - MWL
      
  Property: Invisible 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: The method supports overloading by testing $1 to be an object or text. 
         If text, it is assumed to be overloaded legacy call.

/* USAGE EXAMPLES:
  ----------------------------------------------------
   #1:  $Response_t:=Request2(New object(
                       "RqST_Msg_t"; "This is the message."; 
                       "RqST_Default_t"; "Text that the user can change."; 
                       "RqST_OK_Text_t"; "OK button text"; 
                       "RqST_Cancel_Text_t"; "Cancel button text"; 
                       "RqST_Delay_l"; 60; 
                       "RqST_IconName_t"; "Warn_Orange"
                       ))
  ----------------------------------------------------
   #2:  $Dialog_ob:=New object(
                       "RqST_Msg_t"; "New message"; 
                       "RqST_RegExp_t"; "RegEx search pattern"; 
                       "RqST_Default_t"; "Default request value"; 
                       "RqST_OK_Text_t"; "Okay"; 
                       "RqST_Cancel_Text_t"; "Cancel This"; 
                       "RqST_Delay_l"; 60; 
                       "RqST_IconName_t"; "Error_Red";
                       "RqST_Auto_Close_HTML_Tags_t"; "color:DarkGreen;font-weight:bold"
                       )

        OB SET($Dialog_ob; "RqST_Auto_Close_HTML_Tags_t"; "color:DarkGreen")
        OB SET ARRAY($Dialog_ob; "RqST_Names_at"; $Names_at)  // Optional popup menu selection

        // Add this array if you need values associated with the names array
        OB SET ARRAY($Dialog_ob; "RqST_Values_at"; $Values_at)  // Additional Optional values

        Request2($Dialog_ob) -> text
             OR
        $Response_t:=OB Get($Dialog_ob; "RqST_Response_t"; Is text)
  ----------------------------------------------------
   OVERLOADED EXAMPLES: 

   NOTE: $0 text is <blank> on close box or timout.

   #3:  Request2 ("Message") -> text

   #4:  Request2 ("Message" {;"Default Response" {;"Okay" {;"Cancel" {;Delay {;"Icon"}}}}}) -> text
----------------------------------------------------*/
/* Object Properties:

        "RqST_Msg_t": Message to Display (Supports <SPAN> HTML tags)

        "RqST_Default_t": Default response value (optional)

        "RqST_Immutable_b": Response value immutability setting. If True, prevents user editing
                            the response value, except from "RqST_Names_at" popup menu.

        "RqST_OK_Text_t"=": OK button title on dialog (Default "OK").

        "RqST_Cancel_Text_t": Cancel button title on dialog (Default "Cancel").

        "RqST_AutoClose_Btn_l": Button chosen on timeout; 0 = OK button, 1 = Cancel button.
                                Default is 1.  The value will effect the wording shown in
                                the "RqST_AutoCloseMsg_t" timeout message.

        "RqST_Delay_l": Time to wait in seconds before auto-closing (Default 0).
                        Any value greater than 0 will keep it open until the user
                        dismisses the dialog or the timeout is reached.

        "RqST_IconName_t": Icon type: (Default Info_Blue)
                           Error_Red, Error_Orange, Error_Blue, Error_Green
                           Warn_Red, Warn_Orange, Warn_Blue, Warn_Green
                           Info_Red, Info_Orange, Info_Blue, Info_Green

        "RqST_Auto_Close_HTML_Tags_t": Optional <SPAN> type HTML tags (e.g. "color:Red"
                                       and/or "font-weight:bold")
                                       Ref: https://www.w3schools.com/colors/colors_names.asp

        "RqST_RegExp_t": Regular expression search string (optional) to be used to filter
                         keyboard entry from user.

        "RqST_Names_at": Popup menu selection (optional) displayed next to the response value.
                         User selection will replace the current response value unless 
                         "RqST_Values_at" is defined.

        "RqST_Values_at": Secondary array (optional) of values mapped to "RqST_Names_at" array.
                          User selection of "RqST_Names_at" will use the mapped value to replace
                          the current response value.

    Return Properties:
       "RqST_Response_t": Value reflecting the user's choice (Also returned in $0). If timeout
                          or closebox condition exists, the value is <blank> unless it is
                          changed by user entry. Excludes user changes from "RqST_Names_at"
                          popup menu selection.

       "RqST_Item_Selected_l": Index of "RqST_Names_at" selection. If 0 then no selection was
                               made.  If NULL, the optional "RqST_Names_at" was not defined.

       "FORM_Action_t": Returns "ak accept" only when the OK button is clicked,
                        otherwise "ak cancel".

       "FORM_Timed_Out_b": True when a timeout condition occurs. The "FORM_Action_t"
                           property is set to "ak cancel".

       "FORM_Close_Box_b": True when user clicks the close box. The "FORM_Action_t"
                           property is set to "ak cancel".
*/
----------------------------------------------------*/

var $1 : Variant
var $0; $2; $3; $4; $6 : Text
var $5 : Integer

var $J; $Win_Ref_l : Integer
var $Dialog_ob : Object

If (Value type:C1509($1)=Is object:K8:27)
	$Dialog_ob:=$1
	
Else   // Convert legacy values
	$Dialog_ob:=New object:C1471("RqST_Msg_t"; $1+"")  // Add "" to force it's type to text
	For ($J; 2; Count parameters:C259)
		Case of 
			: ($J=2)  // If RqST_Default_t value
				If (Not:C34($2=""))
					$Dialog_ob.RqST_Default_t:=$2
				End if 
				
			: ($J=3)  // If RqST_OK_Text_t set OK button title
				If (Not:C34($3=""))
					$Dialog_ob.RqST_OK_Text_t:=$3
				End if 
				
			: ($J=4)  // If RqST_Cancel_Text_t set Cancel button title
				If (Not:C34($4=""))
					$Dialog_ob.RqST_Cancel_Text_t:=$4
				End if 
				
			: ($J=5)  // If RqST_Delay_l
				If ($5<0)  // If negative
					$Dialog_ob.RqST_Delay_l:=0  // Don't allow negatives ... it will mess the timer up if -1 is sent
					
				Else   // Not negative
					$Dialog_ob.RqST_Delay_l:=$5
				End if 
				
			: ($J=6)  // If RqST_IconName_t
				If (Not:C34($6=""))
					$Dialog_ob.RqST_IconName_t:=$6
				End if 
				
			Else   // No more parameter matches
				// Do nothing
		End case 
	End for 
End if 
//----------------------------------------------------
//----------------------------------------------------
If ($Dialog_ob.RqST_OK_Text_t=Null:C1517)  // Set OK button title
	$Dialog_ob.RqST_OK_Text_t:="OK"
	
Else 
	If ($Dialog_ob.RqST_OK_Text_t="")
		$Dialog_ob.RqST_OK_Text_t:="OK"
	End if 
End if 
//----------------------------------------------------
If ($Dialog_ob.RqST_Cancel_Text_t=Null:C1517)  // Set Cancel button title
	$Dialog_ob.RqST_Cancel_Text_t:="Cancel"
	
Else 
	If ($Dialog_ob.RqST_Cancel_Text_t="")
		$Dialog_ob.RqST_Cancel_Text_t:="Cancel"
	End if 
End if 
//----------------------------------------------------
If ($Dialog_ob.RqST_Msg_t=Null:C1517)
	$Dialog_ob.RqST_Msg_t:="N/A"  //seconds
	
Else 
	If ($Dialog_ob.RqST_Msg_t="")
		$Dialog_ob.RqST_Msg_t:="N/A"  //seconds
	End if 
End if 
//----------------------------------------------------
If ($Dialog_ob.RqST_Delay_l=Null:C1517)
	$Dialog_ob.RqST_Delay_l:=60  //seconds
	
Else 
	If ($Dialog_ob.RqST_Delay_l<0)
		$Dialog_ob.RqST_Delay_l:=0  //don't allow negatives ... it will mess the timer up if -1 is sent
	End if 
End if 
//----------------------------------------------------
If ($Dialog_ob.RqST_IconName_t=Null:C1517)
	$Dialog_ob.RqST_IconName_t:="Info_Blue"
	
Else 
	If ($Dialog_ob.RqST_IconName_t="")
		$Dialog_ob.RqST_IconName_t:="Info_Blue"
	End if 
End if 
//----------------------------------------------------
If (Is macOS:C1572)  // If Mac OS X
	$Win_Ref_l:=Open form window:C675("Request2"; Choose:C955(Macintosh option down:C545; Movable dialog box:K34:7; Sheet form window:K39:12))  // HERE FOR MY CONVENIENCE - MWL
	
Else   // Windows OS
	$Win_Ref_l:=Open form window:C675("Request2"; Movable dialog box:K34:7; Horizontally centered:K39:1; Vertically centered:K39:4)
End if 

SET WINDOW TITLE:C213("Request")
DIALOG:C40("Request2"; $Dialog_ob)
CLOSE WINDOW:C154($Win_Ref_l)
//----------------------------------------------------
// For backward compatibility
If ($Dialog_ob.FORM_Action_t=ak accept:K76:37)  // If Accepted
	$0:=OB Get:C1224($Dialog_ob; "RqST_Response_t"; Is text:K8:3)
	
Else   // If canceled, return <blank> for backward compatibility
	$0:=""
End if 

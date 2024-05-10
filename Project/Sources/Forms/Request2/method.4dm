/* Form Method: Request2 
      
  Purpose: Handles all form events 
      
  Parameters: None 

  Version: 1.1 - 09/18/2021 - MWL 
      
  Property: N/A 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $BestHeight_l; $BestWidth_l; $Bottom_l; $Delay_l; $Left_l; $Offset_l : Integer
var $ResizeHeight_l; $ResizeWidth_l; $Right_l; $Tick_Start_l; $TimeRemaining_l; $Top_l : Integer
var $Button_t; $Msg_t : Text

Case of 
	: (Form event code:C388=On Load:K2:1)
		Form:C1466.FORM_Action_t:=ak cancel:K76:36  // Incase user hits the esc key
		
		$Offset_l:=5
		OB SET:C1220(Form:C1466; "RqST_Response_t"; "")  // Set return value to <blank>
		//----------------------------------------------------
		// Set OK and Cancel button text
		OBJECT SET TITLE:C194(*; "RqST_OK_btn_l"; OB Get:C1224(Form:C1466; "RqST_OK_Text_t"; Is text:K8:3))
		OBJECT SET TITLE:C194(*; "RqST_Cancel_btn_l"; OB Get:C1224(Form:C1466; "RqST_Cancel_Text_t"; Is text:K8:3))
		//----------------------------------------------------
		// Get best size for OK button
		OBJECT GET COORDINATES:C663(*; "RqST_OK_btn_l"; $Left_l; $Top_l; $Right_l; $Bottom_l)
		OBJECT GET BEST SIZE:C717(*; "RqST_OK_btn_l"; $BestWidth_l; $BestHeight_l)
		
		$ResizeWidth_l:=$BestWidth_l-($Right_l-$Left_l)+$Offset_l  // Add space on each side of button
		If ($ResizeWidth_l<0)  // If width is smaller than original size
			$ResizeWidth_l:=0  // Don't reduce
		End if 
		
		OBJECT MOVE:C664(*; "RqST_OK_btn_l"; -$ResizeWidth_l; 0; $ResizeWidth_l; 0)  // Move and resize OK button
		OBJECT MOVE:C664(*; "RqST_Cancel_btn_l"; -$ResizeWidth_l; 0; 0; 0)  // Just move Cancel button too
		//----------------------------------------------------
		// Get best size for Cancel button
		OBJECT GET COORDINATES:C663(*; "RqST_Cancel_btn_l"; $Left_l; $Top_l; $Right_l; $Bottom_l)
		OBJECT GET BEST SIZE:C717(*; "RqST_Cancel_btn_l"; $BestWidth_l; $BestHeight_l)
		
		$ResizeWidth_l:=$BestWidth_l-($Right_l-$Left_l)+$Offset_l  //Add space on each side of button
		If ($ResizeWidth_l<0)  // If width is smaller than original size
			$ResizeWidth_l:=0  // Don't reduce
		End if 
		
		OBJECT MOVE:C664(*; "RqST_Cancel_btn_l"; -$ResizeWidth_l; 0; $ResizeWidth_l; 0)  //move and resize Cancel button
		//----------------------------------------------------
		// Get best size for request message text
		OBJECT GET COORDINATES:C663(*; "RqST_Msg_t"; $Left_l; $Top_l; $Right_l; $Bottom_l)
		OBJECT GET BEST SIZE:C717(*; "RqST_Msg_t"; $BestWidth_l; $BestHeight_l; 480)  //max width 400
		
		//If ($BestHeight_l>400)  // FOR SOME REASON, THIS DOES NOT ALLOW THE TEXT TO WRAP
		//OBJECT SET SCROLLBAR(*; "RqST_Msg_t"; False; True)
		//$BestHeight_l:=400
		//End if 
		//----------------------------------------------------
		// Resizing height/width ... divide by 2 so that we can keep window centered
		$ResizeWidth_l:=($BestWidth_l-($Right_l-$Left_l))/2
		If ($ResizeWidth_l<0)
			$ResizeWidth_l:=0
		End if 
		
		$ResizeHeight_l:=($BestHeight_l-($Bottom_l-$Top_l))/2
		If ($ResizeHeight_l<0)
			$ResizeHeight_l:=0
		End if 
		
		//Resize window if necessary - request text box will resize accordingly
		GET WINDOW RECT:C443($Left_l; $Top_l; $Right_l; $Bottom_l)
		SET WINDOW RECT:C444($Left_l-$ResizeWidth_l; $Top_l-$ResizeHeight_l; $Right_l+$ResizeWidth_l; $Bottom_l+$ResizeHeight_l)
		//----------------------------------------------------
		// Adjust request value if needed
		If (OB Is defined:C1231(Form:C1466; "RqST_Names_at")=False:C215)  // If no optional choice array is present
			// Do nothing
			
		Else   // Move request value to the right and reduce horizontal width
			OBJECT MOVE:C664(*; "RqST_Input_t"; 30; 0; -30; 0)
		End if 
		//----------------------------------------------------
		// Set timer delay for form
		If (Form:C1466.RqST_Delay_l=0)  // Disable timer
			Form:C1466.RqST_AutoCloseMsg_t:=""
			
		Else   // Enable timer
			SET TIMER:C645(6)
			$Tick_Start_l:=Tickcount:C458
			OB SET:C1220(Form:C1466; "Tick_End_l"; $Tick_Start_l+($Delay_l*60))
			
			SET TIMER:C645(6)
			Form:C1466.RqST_TickStart_l:=Tickcount:C458
			Form:C1466.RqST_TickEnd_l:=Form:C1466.RqST_TickStart_l+(Form:C1466.RqST_Delay_l*60)
		End if 
		
		GOTO OBJECT:C206(*; "RqST_Input_t")  // Select the input field
		
	: (Form event code:C388=On Timer:K2:25)
		$TimeRemaining_l:=(Form:C1466.RqST_TickEnd_l-Tickcount:C458)/60
		If ($TimeRemaining_l<=0)  // If time has expired
			If (OB Get:C1224(Form:C1466; "RqST_AutoClose_Btn_l"; Is longint:K8:6)=1)  // If OK is auto close button
				ACCEPT:C269
				Form:C1466.FORM_Action_t:=ak accept:K76:37
				//Form.RqST_Response_t:=OBJECT Get value("RqST_Input_t")
				
			Else   // Cancel (default) is the auto close button
				CANCEL:C270
				Form:C1466.FORM_Action_t:=ak cancel:K76:36
			End if 
			
			Form:C1466.FORM_Time_Out_b:=True:C214
			
		Else   // Time has not expired
			If (OB Get:C1224(Form:C1466; "RqST_AutoClose_Btn_l"; Is longint:K8:6)=1)  // If OK is auto close button
				$Button_t:=Ut_Encode_HTML_Entities(OB Get:C1224(Form:C1466; "RqST_OK_Text_t"; Is text:K8:3))  // Must encode here
				
			Else 
				$Button_t:=Ut_Encode_HTML_Entities(OB Get:C1224(Form:C1466; "RqST_Cancel_Text_t"; Is text:K8:3))  // Must encode here
			End if 
			//$Button_t:=Ut_Encode_HTML_Entities(OB Get(Form; "RqST_OK_Text_t"; Is text))  // Must encode here
			If (OB Get:C1224(Form:C1466; "RqST_Auto_Close_HTML_Tags_t"; Is text:K8:3)="")  // If no custom color
				$Msg_t:="<SPAN STYLE='color:DarkGreen'>"  // Set default style
				
			Else   // Set custom style tags
				$Msg_t:="<SPAN STYLE='"+OB Get:C1224(Form:C1466; "RqST_Auto_Close_HTML_Tags_t"; Is text:K8:3)+"'>"
			End if 
			
			$Msg_t:=$Msg_t+"'"+$Button_t+"' will be selected in "+String:C10($TimeRemaining_l)+" seconds.</SPAN>"
			Form:C1466.RqST_AutoCloseMsg_t:=$Msg_t
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		Form:C1466.FORM_Action_t:=ak cancel:K76:36
		Form:C1466.FORM_Close_Box_b:=True:C214  // Only set here if close box was clicked
		CANCEL:C270
		
	: (Form event code:C388=On Unload:K2:2)
		SET TIMER:C645(0)
		Form:C1466.RqST_TickEnd_l:=Tickcount:C458
		
	Else   // Some other event
		// Do nothing
End case 

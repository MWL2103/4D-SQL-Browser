/* Form Method: Confirm2 
      
  Purpose: Handles events and sets form objects on the "Confirm2" form. 
      
  Parameters: None 

  Version: 1.1 - 09/18/2021 - MWL 
      
  Property: N/A 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $BestHeight_l; $BestWidth_l; $Bottom_l; $Left_l; $Offset_l : Integer
var $ResizeHeight_l; $ResizeWidth_l; $Right_l; $TimeRemaining_l; $Top_l : Integer
var $Button_t; $Msg_t : Text

Case of 
	: (Form event code=On Load)
		Form.FORM_Action_t:=ak cancel  // Incase user hits the esc key
		
		$Offset_l:=5  // Button width offset
		//----------------------------------------------------
		// Set OK and Cancel button text
		OBJECT SET TITLE(*; "CoNF_OK_btn_l"; Form.CoNF_OK_Text_t)
		OBJECT SET TITLE(*; "CoNF_Cancel_btn_l"; Form.CoNF_Cancel_Text_t)
		//----------------------------------------------------
		//Get best size for OK button
		OBJECT GET COORDINATES(*; "CoNF_OK_btn_l"; $Left_l; $Top_l; $Right_l; $Bottom_l)
		OBJECT GET BEST SIZE(*; "CoNF_OK_btn_l"; $BestWidth_l; $BestHeight_l)
		
		$ResizeWidth_l:=$BestWidth_l-($Right_l-$Left_l)+$Offset_l  //Add space on each side of button
		If ($ResizeWidth_l<0)  // If width is smaller than original size
			$ResizeWidth_l:=0  // Don't reduce
		End if 
		
		OBJECT MOVE(*; "CoNF_OK_btn_l"; -$ResizeWidth_l; 0; $ResizeWidth_l; 0)  //move and resize OK
		OBJECT MOVE(*; "CoNF_Cancel_btn_l"; -$ResizeWidth_l; 0; 0; 0)  // Just move Cancel button too
		//----------------------------------------------------
		//Get best size for Cancel button
		OBJECT GET COORDINATES(*; "CoNF_Cancel_btn_l"; $Left_l; $Top_l; $Right_l; $Bottom_l)
		OBJECT GET BEST SIZE(*; "CoNF_Cancel_btn_l"; $BestWidth_l; $BestHeight_l)
		$ResizeWidth_l:=$BestWidth_l-($Right_l-$Left_l)+$Offset_l  //Add space on each side of button
		If ($ResizeWidth_l<0)  // If width is smaller than original size
			$ResizeWidth_l:=0  // Don't reduce
		End if 
		
		OBJECT MOVE(*; "CoNF_Cancel_btn_l"; -$ResizeWidth_l; 0; $ResizeWidth_l; 0)  //move and resize Cancel button
		//----------------------------------------------------
		// Get best size for message text
		OBJECT GET COORDINATES(*; "CoNF_Msg_t"; $Left_l; $Top_l; $Right_l; $Bottom_l)
		OBJECT GET BEST SIZE(*; "CoNF_Msg_t"; $BestWidth_l; $BestHeight_l; 400)  //max width 400
		
		If ($BestHeight_l>400)
			OBJECT SET SCROLLBAR(*; "CoNF_Msg_t"; False; True)
			$BestHeight_l:=400
		End if 
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
		
		//Resize window if necessary - alert text box will resize accordingly
		GET WINDOW RECT($Left_l; $Top_l; $Right_l; $Bottom_l)
		SET WINDOW RECT($Left_l-$ResizeWidth_l; $Top_l-$ResizeHeight_l; $Right_l+$ResizeWidth_l; $Bottom_l+$ResizeHeight_l)
		//----------------------------------------------------
		// Set timer delay for form
		If (Form.CoNF_Delay_l=0)  // Disable timer
			Form.CoNF_AutoCloseMsg_t:=""
			
		Else   // Enable timer
			SET TIMER(6)
			Form.CoNF_TickStart_l:=Tickcount
			Form.CoNF_TickEnd_l:=Form.CoNF_TickStart_l+(Form.CoNF_Delay_l*60)
		End if 
		
	: (Form event code=On Timer)
		$TimeRemaining_l:=(Form.CoNF_TickEnd_l-Tickcount)/60
		If ($TimeRemaining_l<=0)  // If time has expired
			If (OB Get(Form; "CoNF_AutoClose_Btn_l"; Is longint)=1)  // If OK is auto close button
				ACCEPT
				Form.FORM_Action_t:=ak accept
				
			Else   // Cancel (default) is the auto close button 
				CANCEL
				Form.FORM_Action_t:=ak cancel
			End if 
			
			Form.FORM_Time_Out_b:=True
			
		Else   // Time has not expired 
			If (OB Get(Form; "CoNF_AutoClose_Btn_l"; Is longint)=1)  // If OK is auto close button
				$Button_t:=Ut_Encode_HTML_Entities(OB Get(Form; "CoNF_OK_Text_t"; Is text))  // Must encode here
				
			Else 
				$Button_t:=Ut_Encode_HTML_Entities(OB Get(Form; "CoNF_Cancel_Text_t"; Is text))  // Must encode here
			End if 
			
			If (OB Get(Form; "CoNF_Auto_Close_HTML_Tags_t"; Is text)="")  // If no custom color
				$Msg_t:="<SPAN STYLE='color:DarkGreen'>"  // Set default style
				
			Else   // Set custom style tags
				$Msg_t:="<SPAN STYLE='"+OB Get(Form; "CoNF_Auto_Close_HTML_Tags_t"; Is text)+"'>"
			End if 
			
			$Msg_t:=$Msg_t+"'"+$Button_t+"' will be selected in "+String($TimeRemaining_l)+" seconds.</SPAN>"
			Form.CoNF_AutoCloseMsg_t:=$Msg_t
			//OBJECT SET VALUE("RqST_AutoCloseMsg_t"; $Msg_t)
			
			//If (OB Get(Form; "CoNF_AutoClose_Btn_l"; Is longint)=1)  // If OK is auto close button
			//Form.CoNF_AutoCloseMsg_t:="'"+Form.CoNF_OK_Text_t+"' will be selected in "+String($TimeRemaining_l)+" seconds."
			
			//Else 
			//Form.CoNF_AutoCloseMsg_t:="'"+Form.CoNF_Cancel_Text_t+"' will be selected in "+String($TimeRemaining_l)+" seconds."
			//End if 
		End if 
		
	: (Form event code=On Close Box)
		Form.FORM_Action_t:=ak cancel
		Form.FORM_Close_Box_b:=True  // Only set here if close box was clicked
		CANCEL
		
	: (Form event code=On Unload)
		SET TIMER(0)
		Form.CoNF_TickEnd_l:=Tickcount
End case 

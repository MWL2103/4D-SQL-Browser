/* Form Method: Alert2
      
  Purpose: Handles events on the "Alert2" form.
      
  Parameters: None

  Version: 1.2 - 09/18/2021 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

var $BestHeight_l; $BestWidth_l; $Bottom_l; $Left_l; $ResizeH_l : Integer
var $ResizeW_l; $Right_l; $TimeRemaining_l; $Top_l : Integer

Case of 
	: (Form event code=On Load)
		Form.FORM_Action_t:=ak cancel  // Incase user hits the esc key
		
		// Set button title
		OBJECT SET TITLE(*; "ALrT_OK_btn_l"; Form.ALrT_OK_Text_t)
		//----------------------------------------------------
		// Get best size for alert button
		OBJECT GET COORDINATES(*; "ALrT_OK_btn_l"; $Left_l; $Top_l; $Right_l; $Bottom_l)
		OBJECT GET BEST SIZE(*; "ALrT_OK_btn_l"; $BestWidth_l; $BestHeight_l)  // Max width 400
		$ResizeW_l:=$BestWidth_l-($Right_l-$Left_l)+20  // Add space on each side of button
		If ($ResizeW_l<0)  // If negative, don't shrink the button width
			$ResizeW_l:=0
		End if 
		
		OBJECT MOVE(*; "ALrT_OK_btn_l"; -$ResizeW_l; 0; $ResizeW_l; 0)
		//----------------------------------------------------
		// Get best size for alert text
		OBJECT GET COORDINATES(*; "ALrT_Msg_t"; $Left_l; $Top_l; $Right_l; $Bottom_l)
		OBJECT GET BEST SIZE(*; "ALrT_Msg_t"; $BestWidth_l; $BestHeight_l; 400)  // Max width 400
		
		If ($BestHeight_l>400)
			OBJECT SET SCROLLBAR(*; "ALrT_Msg_t"; False; True)
			$BestHeight_l:=400
		End if 
		//----------------------------------------------------
		// Find resizing height/width ... divide by 2 so that we can keep window centered
		$ResizeW_l:=($BestWidth_l-($Right_l-$Left_l))/2
		If ($ResizeW_l<0)
			$ResizeW_l:=0
		End if 
		
		$ResizeH_l:=($BestHeight_l-($Bottom_l-$Top_l))/2
		If ($ResizeH_l<0)
			$ResizeH_l:=0
		End if 
		
		// Resize window if necessary - alert text box will resize accordingly
		GET WINDOW RECT($Left_l; $Top_l; $Right_l; $Bottom_l)
		SET WINDOW RECT($Left_l-$ResizeW_l; $Top_l-$ResizeH_l; $Right_l+$ResizeW_l; $Bottom_l+$ResizeH_l)
		//----------------------------------------------------
		// Set timer delay for form to update countdown
		If (Form.ALrT_Delay_l=0)  // Disable timer
			Form.ALrT_AutoCloseMsg_t:=""
			
		Else   // Enable timer
			SET TIMER(6)
			Form.ALrT_TickStart_l:=Tickcount
			Form.ALrT_TickEnd_l:=Form.ALrT_TickStart_l+(Form.ALrT_Delay_l*60)
		End if 
		
	: (Form event code=On Timer)
		$TimeRemaining_l:=(Form.ALrT_TickEnd_l-Tickcount)/60
		If ($TimeRemaining_l<=0)
			CANCEL
			Form.FORM_Action_t:=ak cancel
			Form.FORM_Time_Out_b:=True
			
		Else 
			Form.ALrT_AutoCloseMsg_t:="'"+Form.ALrT_OK_Text_t+"' will be selected in "+String($TimeRemaining_l)+" seconds."
		End if 
		
	: (Form event code=On Close Box)
		Form.FORM_Action_t:=ak cancel
		Form.FORM_Close_Box_b:=True  // Only set here if close box was clicked
		CANCEL
		
	: (Form event code=On Unload)
		SET TIMER(0)
		Form.ALrT_TickEnd_l:=Tickcount
End case 

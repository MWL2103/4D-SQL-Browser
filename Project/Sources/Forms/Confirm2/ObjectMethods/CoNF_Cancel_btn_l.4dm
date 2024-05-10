/* Object Method: Confirm2.CoNF_Cancel_btn_l 
      
  Purpose: Handles the "Cancel" button click on the "Confirm2" form. 
      
  Parameters: None 

  Version: 1.0 - 05/13/2021 - MWL 
      
  Property: N/A 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		Form:C1466.FORM_Action_t:=ak cancel:K76:36
		CANCEL:C270
		
	Else   // Some other event
		// Do nothing
End case 

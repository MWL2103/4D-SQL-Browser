/* Object Method: Confirm2.CoNF_OK_btn_l 
      
  Purpose: Handles the "OK" button click on the "Confirm2" form. 
      
  Parameters: None 

  Version: 1.0 - 05/13/2021 - MWL 
      
  Property: N/A 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		Form:C1466.FORM_Action_t:=ak accept:K76:37
		ACCEPT:C269
		
	Else   // Some other event
		// Do nothing
End case 

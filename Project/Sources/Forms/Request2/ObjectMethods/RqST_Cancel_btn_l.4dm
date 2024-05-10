/* Object Method: Request2.RqST_Cancel_btn_l 
      
  Purpose: Handles the "Cancel" button click on the "Request2" form. 
      
  Parameters: None 

  Version: 1.1 - 03/01/2022 - MWL 
      
  Property: N/A 
      
  Risk Assessment: 
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		OB SET:C1220(Form:C1466; "RqST_Response_t"; OBJECT Get value:C1743("RqST_Input_t"))
		
		Form:C1466.FORM_Action_t:=ak cancel:K76:36
		CANCEL:C270
		
	Else   // Some other event
		// Do nothing
End case 

/* Form Method: Saved_Queries
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 07/14/2022 - MWL
  Version: 1.0 - 07/14/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

Case of 
	: (Form event code=On Load)
		// Do nothing
		
	: (Form event code=On Selection Change)
		//LISTBOX GET CELL POSITION(LB_Saved_Queries;$Column_l;$Row_l)
		$Object_p:=OBJECT Get pointer(Object named; "LB_Saved_Queries")
		$Rows_Selected_l:=Count in array($Object_p->; True)  // Count the number of rows selected
		
		OBJECT SET ENABLED(*; "Delete_b"; $Rows_Selected_l=1)  // Enable/Disable delete button
		
	Else 
		
End case 

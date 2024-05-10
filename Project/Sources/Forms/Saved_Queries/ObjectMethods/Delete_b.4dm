/* Object Method: Saved_Queries.Delete_b
      
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
		OBJECT SET ENABLED(*; "Delete_b"; False)
		
	: (Form event code=On Clicked)
		ARRAY TEXT($ColNames_at; 0)
		ARRAY TEXT($HeaderNames_at; 0)
		
		ARRAY BOOLEAN($ColsVisible_ao; 0)
		
		ARRAY POINTER($ColVars_ap; 0)
		ARRAY POINTER($HeaderVars_ap; 0)
		ARRAY POINTER($Styles_ap; 0)
		
		// Get the List information. This will require twice the memory as it makes a copy of the list data
		LISTBOX GET ARRAYS(*; "LB_Saved_Queries"; $ColNames_at; $HeaderNames_at; $ColVars_ap; $HeaderVars_ap; $ColsVisible_ao; $Styles_ap)
		
		LISTBOX GET CELL POSITION(*; "LB_Saved_Queries"; $Column_l; $Row_l)
		$Query_Name_t:=$ColVars_ap{1}->{$Row_l}
		
		// Cant use SQL here because we already have a SQL connection open
		//SET QUERY DESTINATION(Into variable;$Count_l)
		//QUERY([User_Queries];[User_Queries]Name=Save_As_t)  //;*)
		//  //QUERY([User_Queries];[User_Queries]UserID_fk=[User]ID_pk)
		//SET QUERY DESTINATION(Into current selection)
		
		//If ($Count_l>0)  // If we have a duplicate name
		$OK:=Confirm2("Delete '"+$Query_Name_t+"' query?"; "Cancel"; "Delete")
		//$OK:=OK
		//Else 
		//$OK:=0
		//End if 
		
		If ($OK=0)
			READ WRITE([Queries])
			QUERY([Queries]; [Queries]Name=$Query_Name_t)
			//QUERY([Queries];[Queries]ID_pk=Save_As_t)
			//[Queries]SQL_Query:=tSQL
			DELETE RECORD([Queries])
			READ ONLY([Queries])
			
			
			ALL RECORDS([Queries])
			SELECTION TO ARRAY([Queries]Name; Saved_Queries_Menu_at; [Queries]ID_pk; Saved_Queries_ID_at)
			
			Saved_Queries_Menu_at:=Find in array(Saved_Queries_Menu_at; Save_As_t)  // Set the current selected item
			//UNLOAD RECORD([Queries])
		End if 
	Else   // Some other event
		// Do nothing
End case 
/* Object Method: Saved_Queries.Save_b
      
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
	: (Form event code=On Clicked)
		// Cant use SQL here because we already have a SQL connection open
		SET QUERY DESTINATION(Into variable; $Count_l)
		$Save_As_t:=OBJECT Get value("Save_As_t")
		QUERY([Queries]; [Queries]Name=$Save_As_t)  //;*)
		//QUERY([Queries];[Queries]UserID_fk=[User]ID_pk)
		SET QUERY DESTINATION(Into current selection)
		
		If ($Count_l>0)  // If we have a duplicate name
			$OK:=Confirm2("Replace same name?"; "Cancel"; "Replace")
			//$OK:=OK
		Else 
			$OK:=0
		End if 
		
		If ($OK=0)
			//READ ONLY([User])
			//QUERY([User];[User]ConnectionID_fk=tConnectionIDpk)
			//
			If ($Count_l=0)  // If the name does not already exist
				CREATE RECORD([Queries])
				[Queries]Users_ID_fk:=[Users]ID_pk
				[Queries]Name:=$Save_As_t
				[Queries]SQL_Query:=tSQL  // The SQL query
				SAVE RECORD([Queries])
				
			Else   // Update same named query
				//$tTheID:=Saved_Queries_ID_at{Saved_Queries_Menu_at}
				READ WRITE([Queries])
				QUERY([Queries]; [Queries]Name=$Save_As_t)
				//QUERY([Queries];[Queries]ID_pk=$Save_As_t)
				[Queries]SQL_Query:=tSQL
				SAVE RECORD([Queries])
				UNLOAD RECORD([Queries])
				READ ONLY([Queries])
			End if 
			
			ALL RECORDS([Queries])
			SELECTION TO ARRAY([Queries]Name; Saved_Queries_Menu_at; [Queries]ID_pk; Saved_Queries_ID_at)
			
			Saved_Queries_Menu_at:=Find in array(Saved_Queries_Menu_at; $Save_As_t)  // Set the current selected item
			//UNLOAD RECORD([Queries])
		End if 
	Else   // Some other event
		// Do nothing
End case 

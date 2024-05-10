//%attributes = {"invisible":true}
/* Method: RT_Clck_Delete_Tab
      
  Purpose: Handles right-click requests to delete a tab
      
  Parameters: 
    $1 - {text} Text of menu item
    $2 - {text} Menu reference
    $3 - {text} Sub menu reference

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

#DECLARE($MenuText_t : Text; $Main_Menu_ID_t : Text; $Sub_Menu_ID_t : Text)

If ($MenuText_t="")  // Execute menu item
	DELETE FROM ARRAY(Query_Tab_at; Query_Tab_at)
	DELETE FROM ARRAY(Query_Left_at; Query_Tab_at)
	DELETE FROM ARRAY(Query_Right_at; Query_Tab_at)
	
	//$Path_t:=Get 4D folder(Current resources folder)+serveraddress_t+Folder separator
	
	If (Size of array(Query_Tab_at)=Query_Tab_at)
		//DELETE DOCUMENT($Path_t+"View_"+String(Query_Tab_at;"00")+".sql") ` Delete the document
		Query_Tab_at:=Query_Tab_at-1
		
	Else 
		
	End if 
	
Else   // Setup menu item
	APPEND MENU ITEM($Main_Menu_ID_t; $MenuText_t)  // Set menu item text
	SET MENU ITEM PARAMETER($Main_Menu_ID_t; -1; $MenuText_t)  // Set return value if selected
End if 

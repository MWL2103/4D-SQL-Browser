//%attributes = {"invisible":true}
/* Method: On_Startup
      
  Purpose: This method is called once when you open a database.
      
  Parameters: None

  Created: 06/04/2022 - MWL
  Version: 1.0 - 06/04/2022 - MWL
      
  Property: Invisible
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/


// Database configurations
Use (Storage)
	Storage.DB_ob:=New shared object
	
	Use (Storage.DB_ob)
		Storage.DB_ob.Version_t:="Version 19R2 - 06/04/2022"
		
	End use 
End use 

Open_4D_SQL_Query_Browser  // Open a SQL browser window

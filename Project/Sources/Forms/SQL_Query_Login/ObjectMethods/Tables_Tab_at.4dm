/* Object Method: SQL_Query_Login.Tables_Tab_at
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/05/2022 - MWL
  Version: 1.0 - 06/05/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
----------------------------------------------------*/

$Tab_Cntrl_p:=OBJECT Get pointer:C1124(Object current:K67:2)

Case of 
	: (Form event code:C388=On Load:K2:1)
		//C_TEXT(System_Tables_t; User_Tables_t; Selected_Tables_t)  // Tab names for table views
		//System_Tables_t:="System"
		//User_Tables_t:="Remote"
		//Selected_Tables_t:="Selected"
		
		ARRAY TEXT:C222($Tab_Cntrl_p->; 2)
		$Tab_Cntrl_p->{1}:="System"
		$Tab_Cntrl_p->{2}:="Remote"
		$Tab_Cntrl_p->:=2
		//Tables_Tab_at:=2
		
		//ARRAY TEXT(Selected_Tables_at; 0)  // User selected tables
		
		OBJECT SET HORIZONTAL ALIGNMENT:C706(*; "LB_Tables_Title"; Align center:K42:3)
		OBJECT SET TITLE:C194(*; "LB_Tables_Title"; $Tab_Cntrl_p->{$Tab_Cntrl_p->})
		
	: (Form event code:C388=On Clicked:K2:4)
		$PreviousErrorHandler_t:=Setup_SQL_Error_Handler
		
		Remote("Login")
		
		Case of 
			: ($Tab_Cntrl_p->=1) & (Error_l=0)  // SQL System Tables
				Load_Tables
				Remote("Logout")
				
				OBJECT SET ENABLED:C1123(*; "SQL_Table_Sets_at"; False:C215)
				
			: ($Tab_Cntrl_p->=2) & (Error_l=0)  // Remote User Tables
				Load_Tables
				Remote("Logout")
				
				OBJECT SET ENABLED:C1123(*; "SQL_Table_Sets_at"; True:C214)
				
				//: ($Tab_Cntrl_p->=3)  // Selected User Tables
				//Load_Tables
				
			Else   // An exception has occurred
				BEEP:C151
				OBJECT SET VALUE:C1742("Login__Message_t"; Error_Method_t+"\r\r"+String:C10(Current date:C33; Internal date short:K1:7)+" "+String:C10(Current time:C178; System time long:K7:11))
				FORM GOTO PAGE:C247(1)
		End case 
		
		//$Columns_l:=Size of array(SQL_Tables_at)
		//OBJECT SET TITLE(*;"LB_Tables_Title";Tables_Tab_at{Tables_Tab_at}+" ("+String($Columns_l)+")")
		
	Else   // Some other event
		// Do nothing
End case 

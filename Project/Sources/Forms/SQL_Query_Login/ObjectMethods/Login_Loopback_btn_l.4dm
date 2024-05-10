/* Object Method: SQL_Query_Login.Login_Loopback_btn_l
      
  Purpose: xxXxx
      
  Parameters: None

  Created: 06/25/2022 - MWL
  Version: 1.0 - 06/25/2022 - MWL
      
  Property: N/A
      
  Risk Assessment:
     LOW - Simple code.
      
  NOTES: None.
  ----------------------------------------------------*/

var $Error_l : Integer
var $My_IP_Address_t; $MY_Subnet_Mask_t : Text

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$My_IP_Address_t:=""
		$MY_Subnet_Mask_t:=""
		
		$Error_l:=IT_MyTCPAddr($My_IP_Address_t; $MY_Subnet_Mask_t)
		
		Form:C1466.Username_t:="Designer"
		Form:C1466.Password_t:=""
		Form:C1466.Server_Adrs_t:=$My_IP_Address_t
		//serversqlport_t:="21891"
		Form:C1466.Port_l:=Get database parameter:C643(SQL Server Port ID:K37:74)
		
		OBJECT SET VALUE:C1742("Login_User_t"; Form:C1466.Username_t)
		OBJECT SET VALUE:C1742("Login_Password_t"; Form:C1466.Password_t)
		OBJECT SET VALUE:C1742("Login_Address_t"; Form:C1466.Server_Adrs_t)
		OBJECT SET VALUE:C1742("Login_Port_l"; Form:C1466.Port_l)
		
	Else 
		// Do nothing
End case 
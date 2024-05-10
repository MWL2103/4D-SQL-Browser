//%attributes = {"invisible":true}
// Setup_SQL_Error_Handler

// Description: Returns the current error handler method name, and 
//              installs Err_SQL_Handler unless running in Development mode

// Version: 1.1 - 06/29/2017 - MWL

// Method Property: Invisible

// Risk Assesment:
//    LOW - Simple code

// NOTES: None.
//---------------------------------------------------- 

#DECLARE->$Current_Handler_t : Text

var Error_l : Integer
var Error_Method_t : Text
var Error_Stack_cln : Collection

$Current_Handler_t:=Method called on error  // Return the current error handler

Error_l:=0
Error_Method_t:=""
Error_Stack_cln:=New collection

ON ERR CALL("Error_Handler")

If (False)  // For reference only
	Error_Handler
End if 

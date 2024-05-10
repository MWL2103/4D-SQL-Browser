/* Object Method: SQL_Query_Login.SQL_Export_at

Purpose: Exports the contents of the results listbox to selected destination.

Parameters: None

Created: 06/25/2022 - MWL
Version: 1.0 - 06/25/2022 - MWL

Property: N/A

Risk Assessment:
LOW - Simple code.

NOTES: None.
----------------------------------------------------*/

$Object_p:=OBJECT Get pointer(Object current)

Case of 
	: (Form event code=On Load)
		//TRACE
		ARRAY TEXT($Object_p->; 0)
		APPEND TO ARRAY($Object_p->; "Export CSV...")
		APPEND TO ARRAY($Object_p->; "Export Tab delimited...")
		APPEND TO ARRAY($Object_p->; "Copy to Clipboard")
		APPEND TO ARRAY($Object_p->; "Copy JSON to Clipboard")
		
	: (Form event code=On Clicked)
		Case of 
			: ($Object_p->=1)  // Export CSV...
				List_Export(",")
				
			: ($Object_p->=2)  // Export tab deliminated
				List_Export(Char(Tab))
				
			: ($Object_p->=3)  // Copy to Clipboard
				CopyToClipboard
				
			: ($Object_p->=4)  // Copy JSON to Clipboard
				Copy_As_JSON_2_Clipboard
				
			Else 
				Alert2("Error: Unexpected CASE."; "OK")
		End case 
		
		If (OBJECT Get value("Audible_cb_l")=1)  // If audible events on
			BEEP
		End if 
		
	Else   // Some other event
		// Do nothing
End case 

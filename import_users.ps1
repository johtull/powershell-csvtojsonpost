# CSV example:
# firstname,lastname,displayname,field1,field2,field3,
# "John","Doe","","test","one,two","hello"

# Resulting JSON
# { "firstname":"John","lastname":"Doe","displayname":"John Doe","field1":"test", "field2":["one","two"], "field3":"hello" }

###########################################################################################
###########################################################################################

# Load users
$inputCsv = "users.csv"
$apiUrl = "https://example.com/api/create"

###########################################################################################
cls

$users = Import-Csv $inputCsv

foreach ( $user in $users ) {
	$displayName = $user.firstname + " " + $user.lastname
	$user.displayname = $displayName
	
	$field2Array = @()
	if( $user.field2 ) {
		foreach ( $s in $user.field2 -split "," ) {
			$field2Array += $s
		}
	}
	$user.field2 = $field2Array
	
	$json = ($user | ConvertTo-Json)
	
	Write-Output "Loading record for $displayName"
	
	Invoke-RestMethod -Uri $apiUrl -Method POST -body $json -ContentType "application/json"
}

echo ""
echo "Complete! Check the above lines for load status."

#Tests if the string value is numeric
function Test-WE_StringNumeric ($Value) {
    return $Value -match "^[\d\.]+$"
}
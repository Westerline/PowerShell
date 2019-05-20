#Tests if the string value is numeric
function Is-Numeric ($Value) {
    return $Value -match "^[\d\.]+$"
}
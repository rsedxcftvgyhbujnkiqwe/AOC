::multstr <- function(count,string)
{
	local output = ""
	for(local i=0;i<count;i++)
	{
		output += string
	}
	return output
}

::printl <- function(text)
{
	print(text + "\n")
}

::IsCharNumeric <- function(char)
{
	if (char > 47 && char < 58) return true
	return false
}

::printarr <- function(arr)
{
	local msg = ""
	foreach(v in arr) msg += v + " "
	printl(msg)
}

::intlen <- function(integer)
{
	if(integer==0) return 1
	return floor(log10(integer)) + 1
}

::IsInteger <- function(number)
{
	return floor(number)==number
}

::printTable <- function(table, prefix = "") {
    foreach (key, value in table) {
        if (typeof(value) == "table") {
            printl(prefix + "├── " + key);
            printTable(value, prefix + "│   ");
        } else {
            printl(prefix + "├── " + key);
        }
    }
}
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

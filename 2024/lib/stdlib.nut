::infinity <- pow(2,256)

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

::max <- function(arr)
{
    local largest = arr[0]
    for(local i=1;i<arr.len();i++)
    {
        if(arr[i]>largest) largest=arr[i]
    }
    return largest
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

::generatePermutations <- function(arr, start, end, result) {
    if (start == end) {
        result.append(clone arr);
    } else {
        for (local i = start; i <= end; i++) {
            local temp = arr[start];
            arr[start] = arr[i];
            arr[i] = temp;

            generatePermutations(arr, start + 1, end, result);

            temp = arr[start];
            arr[start] = arr[i];
            arr[i] = temp;
        }
    }
}

::getAllPermutations <- function(arr) {
    local result = [];
    generatePermutations(arr, 0, arr.len() - 1, result);
    return result;
}

// local chars = [1, 2, 3, 4];
// local permutations = getAllPermutations(chars);

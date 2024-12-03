::FileToString <- function(filename)
{
	local fileblob = file(filename, "rb");
	local text = "";
	if (fileblob) {
		local size = fileblob.len();
		local blobData = fileblob.readblob(size);
		for (local i = 0; i < size; i++) {
			text += blobData[i].tochar();
		}
		fileblob.close();
	}
	else
		throw false
	return text;
}

::FileToLineArray <- function(filename)
{
	local fileblob = file(filename, "rb");
	local textarray = [];
	local text = "";
	if (fileblob) {
		local size = fileblob.len();
		local blobData = fileblob.readblob(size);
		for (local i = 0; i < size; i++) {
			local char = blobData[i].tochar();
			if (char=="\n")
			{
				textarray.append(text)
				text = ""
			}
			else
			{
				text += char
			}
		}
		if(text != "") textarray.append(text)
		fileblob.close();
	}
	else
		throw false
	return textarray;
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
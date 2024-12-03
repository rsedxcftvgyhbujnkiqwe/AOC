dofile("../lib/stdlib.nut")
local p1_value = 0
local p2_value = 0
local start_time = time()

local fileblob = file("input/bigboy.txt", "rb");
if (fileblob) {
	local size = fileblob.len();
	local blobData = fileblob.readblob(size);
	local text = "";
	local mul_count = 0;
	local do_count = 0;
	local dont_count = 0;
	local enabled = true;
	local n1 = 0
	for (local i = 0; i < size; i++) {
		local char = blobData[i]
		switch(char)
		{
			case 'm':
			{
				if(mul_count==0)
				{
					mul_count++
				}
				else mul_count = 0

				do_count = 0
				dont_count = 0
				break
			}
			case 'u':
			{
				if(mul_count==1)
				{
					mul_count++
				}
				else mul_count = 0

				do_count = 0
				dont_count = 0
				break
			}
			case 'l':
			{
				if(mul_count==2)
				{
					mul_count++
				}
				else mul_count = 0

				do_count = 0
				dont_count = 0
				break
			}
			case '(':
			{
				if(mul_count==3)
				{
					mul_count++
					text = ""
				}
				else mul_count = 0

				if(do_count==2)
				{
					do_count++
				}
				else do_count = 0

				if(dont_count==5)
				{
					dont_count++
				}
				else dont_count = 0

				break
			}
			case 'd':
			{
				if(do_count==0)
				{
					do_count++
				}
				else do_count = 0
				if(dont_count==0)
				{
					dont_count++
				}
				else dont_count = 0

				mul_count = 0
				break
			}
			case 'o':
			{
				if(do_count==1)
				{
					do_count++
				}
				else do_count = 0

				if(dont_count==1)
				{
					dont_count++
				}
				else dont_count = 0

				mul_count = 0
				break
			}
			case 'n':
			{
				if(dont_count==2)
				{
					dont_count++
				}
				else dont_count = 0

				do_count = 0
				mul_count = 0
				break
			}
			case '\'':
			{
				if(dont_count==3)
				{
					dont_count++
				}
				else dont_count = 0

				do_count = 0
				mul_count = 0
				break
			}
			case 't':
			{
				if(dont_count==4)
				{
					dont_count++
				}
				else dont_count = 0

				do_count = 0
				mul_count = 0
				break
			}
			case ')':
			{
				if(mul_count==4)
				{
					if(text!="")
					{
						local value = text.tointeger() * n1
						p1_value += value
						if(enabled) p2_value += value
					}
					n1 = -1
				}

				if(do_count==3)
				{
					enabled = true
				}

				if(dont_count==6)
				{
					enabled = false
				}
				mul_count = 0
				do_count = 0
				dont_count = 0
				break
			}
			case ',':
			{
				if(mul_count==4 && text!="")
				{
					n1 = text.tointeger()
					text = ""
				}
				else mul_count = 0

				do_count = 0
				dont_count = 0
				break
			}
			case '0':
			case '1':
			case '2':
			case '3':
			case '4':
			case '5':
			case '6':
			case '7':
			case '8':
			case '9':
			{
				if(mul_count==4) text += char.tochar();
				do_count = 0
				dont_count = 0
				break
			}
			default:
			{
				mul_count = 0
				do_count = 0
				dont_count = 0
				break
			}

		}
	}
	fileblob.close();
}
else
	throw false

printl("Part 1:")
printl(p1_value)
printl("Part 2:")
printl(p2_value)
printl("Total time: " + (time() - start_time) + "s")
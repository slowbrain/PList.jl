# PList

A module for reading and writing OS X plist in ASCII format. The binary and XML format is not supported presently.

Example of plist ASCII format:

	{
	  Dogs = (
	    {
	      Name = "Scooby Doo";
	      Age = 43;
	      Colors = (Brown, Black);
	    }
	  );
	}
	
    
The plists can be read and written with `readplist` and `writeplist` which are designed to be similar to be similar to `readcsv` and `writecsv`. Example:

    dict = readplist("example.plist")
    writeplist("file.plist", dict)
    
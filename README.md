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
    
The arrays and dictionaries used need to have elements of type `Any`. E.g. you can store an array defined as:

    ["Brown","Black"]
    
Because that will infer its type as `Array{ASCIIString,1}` But you need the type to be `Array{Any,1}`. You accomplish this by defining the array like this:

    {"Brown","Black"}
    
[![Build Status](https://travis-ci.org/ordovician/PList.jl.png)](https://travis-ci.org/ordovician/PList.jl)

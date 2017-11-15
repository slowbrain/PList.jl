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

[![Build Status](https://travis-ci.org/ordovician/PList.jl.svg?branch=master)](https://travis-ci.org/ordovician/PList.jl)

[![Coverage Status](https://coveralls.io/repos/github/ordovician/PList.jl/badge.svg?branch=master)](https://coveralls.io/github/ordovician/PList.jl?branch=master)

[![codecov.io](http://codecov.io/github/ordovician/PList.jl/coverage.svg?branch=master)](http://codecov.io/github/ordovician/PList.jl?branch=master)

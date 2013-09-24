leading-zeros
=============

Rename files by padding the numbers the chosen files-names start in with leading zeros.

For example these file names

	  002 
	12345.s3 
	    2 
	   11 
	 82aa.ext 

will be converted into

	00002 
	12345.s3 
	    2 				# No vonversion because file 00002 already exists. 
	00011 
	082aa.ext 

Prefixes of user's choice can be added.

The script is **safe to use** -- it will not rename a file if the file-name already exists. Even if it has just been generated with the very same command.

INSTALLATION 

leading-zeros is a bash script. It requires no installation, nor any dependencies but the bash itself, of course.

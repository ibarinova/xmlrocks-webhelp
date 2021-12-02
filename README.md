# Dita-OT xmlrocks-webhelp plug-in
XMLRocks WebHelp plugin extends default DITA-OT HTML5 output with a Bootstrap template, adds a user-friendly interface, table of content, and features for the user to download a pdf version of documentation or upload it on google drive.

Xmlrocks-webhelp supports asynchronous page uploading between topics which decreases page reloading time.

____
## Requirements
The plug-in has been developed for DITA-OT 3.6.1 or newer, but may work with older DITA-OT versions.
____
## Install
1. Run the plug-in installation command:
```
$ dita --install rocks.xml.webhelp
```
____
## Using
Use ```xmlrocks-webhelp``` transtype to generate xmlRocks webHelp output.

----
## Parameters
1. ```'includes-pdf'``` parameter is used for creating output in pdf format and adding 'Download PDF output ' button. Possible values to use this parameter are ```yes``` or ```true```.
2. Use```'organization-name'``` to pass organization name which will be shown in footer. Otherwise first bookmap/organization element will be used.
3. Also ```'args.csspath'``` can be applied to define CSS output directory. Default value is ```css```. Possible value - any string (for example ```styles```, ```resources``` etc.). If an empty string is passed, then CSS files will be located directly in the output directory. 
____
## Extension points
There are two extension points to override plugin templates:
1. ```'rocks.xsl.html5'``` - templates related to topics pages
2. ```'rocks.xsl.html5.cover'``` - main page related templates
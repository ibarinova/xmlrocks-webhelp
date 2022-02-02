# Dita-OT xmlrocks-webhelp plug-in
XMLRocks WebHelp plugin extends default DITA-OT HTML5 output with a Bootstrap template, adds a user-friendly interface, table of content, and features for the user to download a pdf version of documentation or upload it on Google drive.

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
3. `two-col-fig-callouts` - specifies if figure callouts (ordered list items) should be separated into two columns. Allowable values `true` or `yes`. If parameter wasn't specified or any other value was selected - figure ordered list will be processed using default transformation.
4. Also ```'args.csspath'``` can be applied to define CSS output directory. Default value is ```css```. Possible value - any string (for example ```styles```, ```resources``` etc.). If an empty string is passed, then CSS files will be located directly in the output directory. 
5. Use the `save-to-google-drive` parameter for adding the button to save the pdf output of publication to Google Drive. Allowable values are ```yes``` or ```true```, if the parameter wasn't specified or any other values are used, then the 'Save to Google Drive' button will not appear. **Please note:** the 'Save to Google Drive' button may not work on the server with an HTTP connection. Please make sure that you have configured an HTTPS connection if you plan to use this button.
6. Colors of the main elements can be updated without the stylesheets update. Possible value of the following parameters can be HEX-code, RGB-code or the color name (it should be correct CSS3 color value). For example: ```#ffffff```, ```#fff```, ```rgb(255, 255, 255)```, ```black```. List of the color scheme related parameters: 
   1. ```header-bg-color``` - header background color. Default value is #0c213a.
   2. ```accent-bg-color``` - background color of accent elements (buttons, active menu options, hovers, etc.). Default value is #2c74eb.
   3. ```accent-color``` - color of the accent elements (subtitles, active topic in TOC, etc.). Default value is #2c74eb.
   4. ```footer-bg-color``` - footer background color. Default value is #000000.
____
## Extension points
There are two extension points to override plugin templates:
1. ```'rocks.xsl.html5'``` - templates related to topics pages
2. ```'rocks.xsl.html5.cover'``` - main page related templates
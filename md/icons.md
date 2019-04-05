###### Last Updated: Tuesday, April 2, 2019

# Making .icns Icons

### 1. Create your base image.
Create a 1024×1024 pixel document with a transparent background and draw/paint/assemble your icon.

### 2. Export a series of PNG files.

Now, export ten PNG versions of this image, each with its own size and name.

Filename 					| Image Size (in pixels)
-----------------------+---------------
icon_512x512@2x.png 	| 1024 x 1024
icon_512x512.png 		| 512 x 512
icon_256x256@2x.png 	| 512 x 512
icon_256x256.png 		| 256 x 256
icon_128x128@2x.png 	| 256 x 256
icon_128x128.png 		| 128 x 128
icon_32x32@2x.png 		| 64 x 64
icon_32x32.png 			| 32 x 32
icon_16x16@2x.png 		| 32 x 32
icon_16x16.png 			| 16 x 16


### 3. Create an .iconset and preview your work.

Put all ten icons in one folder, then name the folder `<name>.iconset`, where `<name>` is the name of the icon.

### 4. Convert the .iconset folder to an .icns file.

Open the terminal and enter

	iconutils -c icns /path/to/iconset.iconset
	
For example,

	iconutils -c icns ~/Desktop/app_icons.iconset
	
Once you hit return, iconutil will make an .icns file with the same name and location as your iconset.

And you're done!

----

### Sources and Citations:

1. [MacSales Blog: Create Your Own Custom Icons in OS X 10.7.5 or Later][1]

  [1]: [https://blog.macsales.com/28492-create-your-own-custom-icons-in-10-7-5-or-later)]




This is a pod version of 

http://www.raweng.com/blog/2013/03/04/improving-image-compression-what-weve-learned-from-whatsapp/
https://gist.github.com/akshay1188/4749253#file-whatsapp-image-compression

which cuts a UIImage down to about 5% of the size by reducing the resolution to
600x800 and then applying 50% JPEG compression.

This pod includes tests that a handful of image sizes are reduced to the expected size.
It also includes a test app that shows the full image and the low res compressed
version side by side, with their file sizes.  This can be used to make sure
that the low res version more or less looks like the original, and is indeed
smaller on disk.

#import "UIImage+lowres.h"

@implementation UIImage (lowres)

- (UIImage*)lowres
{
    return self.lowResolution.lowQuality;
}

- (UIImage*)lowResolution
{
    //thanks http://www.raweng.com/blog/2013/03/04/improving-image-compression-what-weve-learned-from-whatsapp/
    //thanks https://gist.github.com/akshay1188/4749253#file-whatsapp-image-compression
        
    float actualHeight = self.size.height;
    float actualWidth = self.size.width;
    float maxHeight; float maxWidth;
    if (actualHeight > actualWidth)
    {
        maxHeight = 800.0;
        maxWidth = 600.0;
    }
    else
    {
        maxHeight = 600.0;
        maxWidth = 800.0;
    }
    
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage*)lowQuality
{
    NSData *imageData = UIImageJPEGRepresentation(self, 0.5);
    return [UIImage imageWithData:imageData];
}

@end

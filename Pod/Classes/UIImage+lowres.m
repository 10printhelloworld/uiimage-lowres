#import "UIImage+lowres.h"

@implementation UIImage (lowres)

- (UIImage*)lowres
{
    return self.lowResolution.lowQuality;
}

- (UIImage*)lowResolution
{
    return [self imageNoBiggerThan:600 by:800];
}

- (UIImage*)imageNoBiggerThan:(float)dimension1 by:(float)dimension2
{
    //thanks http://www.raweng.com/blog/2013/03/04/improving-image-compression-what-weve-learned-from-whatsapp/
    //thanks https://gist.github.com/akshay1188/4749253#file-whatsapp-image-compression
        
    float actualHeight = self.size.height;
    float actualWidth = self.size.width;
    float maxHeight; float maxWidth;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wlogical-op-parentheses" //prefer to remind myself of the order of operations, and we have a test making sure this is correct
    if (actualHeight > actualWidth && dimension1 > dimension2 || actualWidth > actualHeight && dimension2 > dimension1)
#pragma clang diagnostic pop
    {
        maxHeight = dimension1;
        maxWidth = dimension2;
    }
    else
    {
        maxHeight = dimension2;
        maxWidth = dimension1;
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
    
    return [self imageWithSize:CGSizeMake(actualWidth, actualHeight)];
}

- (UIImage*)imageWithSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage*)lowQuality
{
    return [self imageWithJPEGCompression:0.5];
}

- (UIImage*)imageWithJPEGCompression:(float)compressionQuality
{
    NSData *imageData = UIImageJPEGRepresentation(self, compressionQuality);
    return [UIImage imageWithData:imageData];
}


@end

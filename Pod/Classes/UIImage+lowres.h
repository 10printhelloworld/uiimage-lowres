#import <UIKit/UIKit.h>

@interface UIImage (lowres)

@property (readonly) UIImage *lowres;

@property (readonly) UIImage *lowResolution;
@property (readonly) UIImage *lowQuality;

- (UIImage*)imageWithJPEGCompression:(float)compressionQuality;


@end

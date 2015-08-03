#import <UIKit/UIKit.h>

@interface UIImage (lowres)

@property (readonly) UIImage *lowres;

@property (readonly) UIImage *lowResolution;
@property (readonly) UIImage *lowQuality;

- (UIImage*)imageWithJPEGCompression:(float)compressionQuality;
- (UIImage*)imageWithSize:(CGSize)size;
- (UIImage*)imageNoBiggerThan:(float)dimension1 by:(float)dimension2;

@end

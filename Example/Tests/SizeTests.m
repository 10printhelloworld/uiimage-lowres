#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UIImage+lowres.h"

@interface SizeTests : XCTestCase

@end

@implementation SizeTests

- (void)testFor800x470resultWithTestImage {
    UIImage *fullSizeImage = [self imageFromFilename:@"testImage.jpg"];
    [self doubleCheck:fullSizeImage existsAndMeasures:4827 by:2833];
    
    NSString *result = [self checkThat:fullSizeImage reducesCorrectlyTo:800 by:470];
    XCTAssertFalse(result, @"%@", result);

}

- (void)testFor750x440resultWithSmallTestImage {
    UIImage *fullSizeImage = [self imageFromFilename:@"testImageSmall.jpg"];

    [self doubleCheck:fullSizeImage existsAndMeasures:750 by:440];
    
    NSString *result = [self checkThat:fullSizeImage reducesCorrectlyTo:750 by:440];
    XCTAssertFalse(result, @"%@", result);
    
}

- (void)testFor600x700resultWithGeneratedImage {
    UIImage *fullSizeImage = [self generateImageWidth:6000 height:7000];
    
    NSString *result = [self checkThat:fullSizeImage reducesCorrectlyTo:600 by:700];
    XCTAssertFalse(result, @"%@", result);
}

- (void)testFor602x600resultWithGeneratedImage {
    UIImage *fullSizeImage = [self generateImageWidth:6020 height:6000];
    
    NSString *result = [self checkThat:fullSizeImage reducesCorrectlyTo:602 by:600];
    XCTAssertFalse(result, @"%@", result);
}

- (void)testFor550x800resultWithGeneratedImage {
    UIImage *fullSizeImage = [self generateImageWidth:5500 height:8000];
    
    NSString *result = [self checkThat:fullSizeImage reducesCorrectlyTo:550 by:800];
    XCTAssertFalse(result, @"%@", result);
}

- (void)testFor500x500resultWithGeneratedImage {
    UIImage *fullSizeImage = [self generateImageWidth:500 height:500];
    
    NSString *result = [self checkThat:fullSizeImage reducesCorrectlyTo:500 by:500];
    XCTAssertFalse(result, @"%@", result);
}

- (void)testImageGenratorHelper
{
    UIImage *image700x800 = [self generateImageWidth:700 height:800];
    XCTAssertEqual(image700x800.size.width, 700);
    XCTAssertEqual(image700x800.size.height, 800);
}

- (UIImage*)generateImageWidth:(int)width height:(int)height
{
    //thanks http://stackoverflow.com/a/16003546
    CGSize imageSize = CGSizeMake(width, height);
    UIColor *fillColor = [UIColor blackColor];
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)doubleCheck:(UIImage*)originalImage existsAndMeasures:(float)expectedWidth by:(float)expectedHeight {
    NSAssert(originalImage, @"no image!");
    NSString *resultOfCheck = [self checkThat:originalImage measures:expectedHeight by:expectedWidth];
    NSAssert(resultOfCheck, @"%@", resultOfCheck);
}

- (NSString*)checkThat:(UIImage*)originalImage reducesCorrectlyTo:(float)expectedWidth by:(float)expectedHeight {
    if (originalImage.scale != 1) return [NSString stringWithFormat:@"this test is not designed for sample images with scale %f - just scale 1", originalImage.scale];
    
    UIImage *lowresImage = originalImage.lowres;

    if (lowresImage.scale != 1 || lowresImage.size.height != expectedHeight || lowresImage.size.width != expectedWidth) {
        return [NSString stringWithFormat:@"expecting width %f height %f scale 1 - got %@ scale %f", expectedWidth, expectedHeight, NSStringFromCGSize(lowresImage.size), lowresImage.scale];
    }
    
    long long originalSize = [self sizeOfImageIfSavedAsHighestQualityJPEG:originalImage];
    long long lowresSize = [self sizeOfImageIfSavedAsHighestQualityJPEG:lowresImage];
    NSString *fileSizeInformation = [NSString stringWithFormat:@"reduced from %@ to %@", [NSByteCountFormatter stringFromByteCount:originalSize countStyle:NSByteCountFormatterCountStyleFile], [NSByteCountFormatter stringFromByteCount:lowresSize countStyle:NSByteCountFormatterCountStyleFile]];
    if (originalSize < lowresSize) {
        return fileSizeInformation;
    }
    NSLog(@"%@", fileSizeInformation);
    
    if (lowresSize > 300*1024) {
        return [NSString stringWithFormat:@"lowres image bigger than expected at %@", [NSByteCountFormatter stringFromByteCount:lowresSize countStyle:NSByteCountFormatterCountStyleFile]];
    }
    
    return nil;
}

- (long long)sizeOfImageIfSavedAsHighestQualityJPEG:(UIImage*)image
{
    return [UIImageJPEGRepresentation(image, 1.0) length];
}

- (NSString*)checkThat:(UIImage*)image measures:(float)expectedWidth by:(float)expectedHeight {
    if (image.scale != 1 || image.size.height != expectedHeight || image.size.width != expectedWidth) {
        return [NSString stringWithFormat:@"expecting width %f height %f scale 1 - got %@ scale %f", expectedWidth, expectedHeight, NSStringFromCGSize(image.size), image.scale];
    }
    return nil;
}

- (UIImage*)imageFromFilename:(NSString*)filename
{
    NSString *path = [self pathFromFilename:filename];
    NSAssert(path, @"couldn't find image");
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSAssert(image, @"couldn't open image at %@", image);
    return image;
}

- (NSString*)pathFromFilename:(NSString*)filename
{
    return [[NSBundle mainBundle] pathForResource:filename.stringByDeletingPathExtension ofType:filename.pathExtension];
}

@end

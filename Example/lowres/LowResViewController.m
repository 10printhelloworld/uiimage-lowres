#import "LowResViewController.h"
#import "UIImage+lowres.h"

@interface LowResViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *fullResImageView;
@property (strong, nonatomic) IBOutlet UIImageView *lowResImageView;
@property (strong, nonatomic) IBOutlet UILabel *fullResInfo;
@property (strong, nonatomic) IBOutlet UILabel *lowResInfo;

@end

@implementation LowResViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *fullImagePath = [[NSBundle mainBundle] pathForResource:@"testImage" ofType:@"jpg"];
    NSAssert(fullImagePath, @"couldn't find image");
    UIImage *fullImage = [UIImage imageWithContentsOfFile:fullImagePath];
    NSAssert(fullImage, @"couldn't open image at %@", fullImagePath);
    self.fullResImageView.image = fullImage;
    self.lowResImageView.image = fullImage.lowres;
    self.fullResInfo.text = [self approximatedDiskSizeStringOf:fullImage];
    self.lowResInfo.text = [self approximatedDiskSizeStringOf:self.lowResImageView.image];
}

- (NSString*)approximatedDiskSizeStringOf:(UIImage*)image
{
    return [NSByteCountFormatter stringFromByteCount:[self sizeOfImageIfSavedAsHighestQualityJPEG:image] countStyle:NSByteCountFormatterCountStyleFile];
}

- (long long)sizeOfImageIfSavedAsHighestQualityJPEG:(UIImage*)image
{
    return [UIImageJPEGRepresentation(image, 1.0) length];
}


@end

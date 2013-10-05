//
//  ImgManager.m
//  AnyToDo.UIProto
//



#import "ImgManager.h"

@implementation ImgManager

+(UIImage*) getImageInDomain:(NSString*) domain subDomain:(NSString*) subDomain imgPath:(NSString*) path
{
    NSString* fullpath;
    if(!subDomain || subDomain.length == 0)
    {
        fullpath = [NSString stringWithFormat:@"%@/%@", domain, path];
    }
    else
    {
        fullpath = [NSString stringWithFormat:@"%@/%@/%@", domain, subDomain, path];
    }
    UIImage* img = [UIImage imageNamed:fullpath];
    if(!img)
    {
        NSLog(@"Error - Not found image : %@", fullpath);
    }
    
    return img;
}

+(UIImage*) get9PatchedImageInDomain:(NSString*) domain subDomain:(NSString*) subDomain imgPath:(NSString*) path
{
    NSString* fullpath;
    if(!subDomain || subDomain.length == 0)
    {
        fullpath = [NSString stringWithFormat:@"%@/%@", domain, path];
    }
    else
    {
        fullpath = [NSString stringWithFormat:@"%@/%@/%@", domain, subDomain, path];
    }
    UIImage* img = [UIImage imageNamed:fullpath];
    if(!img)
    {
        NSLog(@"Error - Not found image : %@", fullpath);
    }
    
    int capH = floor(img.size.height/2.0);
    int capW = floor(img.size.width/2.0);
    UIImage* resizeableImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(capH ,capW, capH,  capW )];
    
    return resizeableImg;
}

+(UIImage*) getOptimizedImage:(UIImage*) sourceImage
{
    double imgWidth = sourceImage.size.width;
    double imgHeight = sourceImage.size.height;
    
    double maxWidth = 1000;
    double maxHeight = 1000;
    
    double aspectHeight = imgWidth/maxWidth;
    double aspectWidth =  imgHeight/maxHeight;
    
    double ratioToScale = 1;
    
    if(aspectHeight > 1 || aspectWidth > 1)
    {
        if(aspectWidth > aspectHeight)
        {
            ratioToScale = 1/aspectWidth;
        }
        else
        {
            ratioToScale = 1 / aspectHeight;
        }
    }
    
    if(ratioToScale == 1)
    {
        return sourceImage;
    }
    
    double nWidth = ratioToScale*imgWidth;
    double nHeight = ratioToScale*imgHeight;
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(nWidth, nHeight));
    [sourceImage drawInRect: CGRectMake(0, 0, nWidth, nHeight)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}
@end

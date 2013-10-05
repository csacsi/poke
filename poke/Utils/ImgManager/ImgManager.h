//
//  ImgManager.h
//  AnyToDo.UIProto
//



//  Global class to help managing images more efficiently
#import <Foundation/Foundation.h>

#define imgiPad @"Images.iPad"
#define imgiPhone @"Images.iPhone"
#define imgCommon @"Images.Common"

#define imgIntro    @"Intro"

#define imgGeneralIcons   @"Icons/General"
#define imgToDoIcons      @"Icons/ToDo"

#define imgPageBackgrounds @"Backgrounds/Page"
#define imgUIElementBackGround @"Backgrounds/UI elements"

@interface ImgManager : NSObject

+(UIImage*) getImageInDomain:(NSString*) domain subDomain:(NSString*) subDomain imgPath:(NSString*) path;
+(UIImage*) get9PatchedImageInDomain:(NSString*) domain subDomain:(NSString*) subDomain imgPath:(NSString*) path;
+(UIImage*) getOptimizedImage:(UIImage*) sourceImage;

@end

//
//  CustomMappingProtocoll.h
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/20/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Parse/PFObject.h>

@class BaseDataObject;

@protocol CustomMappingProtocoll <NSObject>

@required
+(PFObject*)parseObjectFrom:(BaseDataObject*)obj;
+(BaseDataObject*)objectFrom:(PFObject*)obj;
@end

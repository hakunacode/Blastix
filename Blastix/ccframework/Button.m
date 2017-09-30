//
//  Button.m
//  PaperToss
//
//  Created by admin on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Button.h"
#import "ResourceManager2.h"

@implementation Button

+(id) itemFromNormalSprite: (NSString*) strNormal
            selectedSprite: (NSString*) strSelected
                    target:(id)target
                  selector:(SEL)selector
{
    ResourceManager2* resManager = [ResourceManager2 sharedResourceManager];
    
    CCSprite* normalSprite   = [resManager getSpriteWithName: strNormal];
    CCSprite* selectedSprite = [resManager getSpriteWithName: strSelected];
    
    return [self itemFromNormalSprite:normalSprite selectedSprite:selectedSprite disabledSprite:nil target:target selector:selector];
}

@end

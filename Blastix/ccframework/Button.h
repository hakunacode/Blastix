//
//  Button.h
//  PaperToss
//
//  Created by admin on 1/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Button : CCMenuItemSprite
{
    
}

+(id) itemFromNormalSprite: (NSString*) strNormal
            selectedSprite: (NSString*) strSelected
                    target:(id)target
                  selector:(SEL)selector; 

@end

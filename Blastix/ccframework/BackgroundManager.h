//
//  BackgroundManager.h
//  fruitGame
//
//  Created by KCU on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ResourceManager.h"

enum BACKGROUND_TYPE
{
	kBackground_Menu = 0, 
};

@class BackgroundManager;
@class UmbObject;
@interface BackgroundManager : NSObject {
	ResourceManager* resManager;
	NSMutableArray* mAryUmbObject;
}

+ (BackgroundManager*) sharedBackgroundManager;
+ (void) releaseBackgroundManager;

- (id) init;
- (void) draw;
- (void) drawTitle: (float) offsetY;
- (void) drawUmbObjects;
@end

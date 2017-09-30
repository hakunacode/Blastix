//
//  AnimationManager.h
//  towerGame
//
//  Created by KCU on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceManager.h"

@interface AnimationManager : NSObject 
{
	NSDictionary* mDicAnimationGroup;
	NSString* mActiveAnimationName;
	
	BOOL	beginAnimation;
	int		currentFrame;
	ResourceManager* resManager;
	
	CCRenderTexture* renderTexture;
	
	long mCount;
	float mfAngle;
}

- (id) init;
- (void) loadAnimationGroup: (NSString*) plistName;
- (void) beginAnimation: (NSString*) animationName;
- (void) stopAnimation;
- (void) drawFrame: (CGPoint) posCenter;
@end

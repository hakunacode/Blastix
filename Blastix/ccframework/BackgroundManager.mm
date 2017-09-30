//
//  BackgroundManager.m
//  fruitGame
//
//  Created by KCU on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundManager.h"
#import "DeviceSettings.h"
//#import "UmbObject.h"

@implementation BackgroundManager

static BackgroundManager *_sharedBackground = nil;

+ (BackgroundManager*) sharedBackgroundManager 
{
	if (!_sharedBackground) 
	{
		_sharedBackground = [[BackgroundManager alloc] init];
	}
	
	return _sharedBackground;
}

+ (void) releaseBackgroundManager 
{
	if (_sharedBackground) 
	{
		[_sharedBackground release];
		_sharedBackground = nil;
	}
}

- (id) init
{
	if( (self=[super init] )) 
	{
		resManager = [ResourceManager sharedResourceManager];
		
		mAryUmbObject = [[NSMutableArray arrayWithCapacity: 10] retain];
		/*
		for (int i = 0; i < 10; i ++)
		{
			UmbObject* obj = [[UmbObject alloc] init];
			[mAryUmbObject addObject: obj];
			[obj release];
		}
		 */
	}
	
	return self;
}

- (void) draw
{	
	CCSprite* sprite = [resManager getTextureWithName:@"logo"]; 
	[sprite setPosition: ccp(240, 160)];
	[sprite visit];
}

- (void) drawUmbObjects
{
	/*
	for (unsigned int i = 0; i < [mAryUmbObject count]; i ++)
	{
		UmbObject* obj = [mAryUmbObject objectAtIndex: i];
		[obj drawOnTitleScene];
	}
	 */
}

- (void) drawTitle: (float) offsetY
{
	CCSprite*sprite = [resManager getTextureWithName: @"logo_title"];
	[sprite setPosition: ccp(160, 360)];
	[sprite visit];
}

- (void) dealloc
{
	[super dealloc];
//	[mAryUmbObject release];
}

@end


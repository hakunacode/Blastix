//
//  AnimationManager.m
//  towerGame
//
//  Created by KCU on 7/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnimationManager.h"


@implementation AnimationManager

- (void) dealloc
{
	[super dealloc];
	//[renderTexture release];
	if (mDicAnimationGroup != nil)
	{
		//[mDicAnimationGroup release];
		mDicAnimationGroup = nil;
	}	
}

- (id) init
{
	if ( (self=[super init]) )
	{
		mDicAnimationGroup = nil;
		mActiveAnimationName = nil;
		beginAnimation = NO;
		currentFrame = 0;
		resManager = [ResourceManager sharedResourceManager];
		renderTexture = [[CCRenderTexture renderTextureWithWidth:100 height:100] retain]; 
		//[[renderTexture sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
		
		mCount = 0; mfAngle = arc4random()%12;
	}
	
	return self;
}

- (void) loadAnimationGroup: (NSString*) plistName
{
	// load our data data from a plist file inside our app bundle
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* plistPath = [documentsDirectory stringByAppendingPathComponent:plistName];
    if ([fileManager fileExistsAtPath:plistPath] == NO) {
		NSLog(@"not exist animation file");
		return;
    }
	
	if (mDicAnimationGroup != nil)
	{
		[mDicAnimationGroup release];
		mDicAnimationGroup = nil;
	}
	
	mDicAnimationGroup = [[NSDictionary alloc] initWithContentsOfFile: plistPath];
	
}

- (void) beginAnimation: (NSString*) animationName
{
	if (mActiveAnimationName != nil)
	{
		[mActiveAnimationName release];
		mActiveAnimationName = nil;
	}
	
	mActiveAnimationName = [animationName retain];
	beginAnimation = YES;
	currentFrame = 0;
}

- (void) stopAnimation
{
	beginAnimation = NO;
	currentFrame = 0;
}

- (void) drawFrame: (CGPoint) posCenter
{
	if (beginAnimation == NO)
		return;
	NSArray* aryAni = [mDicAnimationGroup objectForKey: mActiveAnimationName];
	if (aryAni == nil)
		return;
	
	int nFrameCount = [aryAni count];
	if ((currentFrame+1) > nFrameCount)
		return;
	
	mfAngle += 0.05f;
	[renderTexture.sprite setRotation: cos(mfAngle)*20];
	//NSLog(@"%f", cos(currentFrame)*20);
	[renderTexture.sprite setPosition: posCenter];
	[renderTexture.sprite visit];
	mCount = (mCount + 1) % 10;
	if (mCount != 0)
		return;
	
	currentFrame = (currentFrame + 1) % nFrameCount;
	
	[renderTexture clear:0 g:0 b:0 a:0];
	[renderTexture begin];
	NSDictionary* dicSprites = [aryAni objectAtIndex:currentFrame];
	NSArray* aryKeys = [dicSprites allKeys];
	for (unsigned int i = 0; i < [aryKeys count]; i ++)
	{
		NSString* strSprite = [aryKeys objectAtIndex:i];
		NSDictionary* dicCoordinate = [dicSprites objectForKey: strSprite];
		float x = [[dicCoordinate objectForKey: @"x"] floatValue];
		float y = [[dicCoordinate objectForKey: @"y"] floatValue];
		
		CCSprite* sprite = [resManager getTextureWithName: strSprite];
		CGSize contentSize = [sprite contentSize];
		[sprite setPosition: ccp(50+x+contentSize.width/2, 100-(50+y+contentSize.height/2))];
		[sprite visit];
	}
	
	[renderTexture end];
}

@end

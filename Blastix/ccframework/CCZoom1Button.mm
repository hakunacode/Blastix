/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 KHS
 * 
 */



#import "CCZoom1Button.h"
#import "CCDirector.h"
#import "CGPointExtension.h"
#import "ccMacros.h"
#import "DeviceSettings.h"

#import <Availability.h>
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import "CCDirectorIOS.h"
#import "CCTouchDispatcher.h"
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
#import "Platforms/Mac/MacGLView.h"
#import "Platforms/Mac/CCDirectorMac.h"
#endif

@implementation CCZoom1Button

- (id) initWithTarget:(id) rec 
			 selector:(SEL) cb 
		  textureName: (NSString*) textureName 
	  selTextureName: (NSString*) selTextureName 
			 position:(CGPoint) position
			afterTime: (float) afterTime
{
	if( (self=[super init]) ) {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
		self.isTouchEnabled = YES;
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
		self.isMouseEnabled = YES;
#endif
		// menu in the center of the screen
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		NSMethodSignature * sig = nil;
		
		if( rec && cb ) {
			sig = [[rec class] instanceMethodSignatureForSelector:cb];
			
			invocation = nil;
			invocation = [NSInvocation invocationWithMethodSignature:sig];
			[invocation setTarget:rec];
			[invocation setSelector:cb];
#if NS_BLOCKS_AVAILABLE
			if ([sig numberOfArguments] == 3) 
#endif
				[invocation setArgument:&self atIndex:2];
			
			[invocation retain];
		}
		
		resManager = [ResourceManager sharedResourceManager];
		mSprite = [[resManager getTextureWithName: textureName] retain];
		mSelSprite = [[resManager getTextureWithName: selTextureName] retain];
		CGSize contentSize = [mSprite contentSize];
	
		mFrame = CGRectMake(position.x,
							position.y,
							contentSize.width,
							contentSize.height);
		
		state = kCCZoom1ButtonUnSelected;
		mbStartZoom = NO;
		mfZoomScale = 0.0f;
		mTimer.SetTimer(TIMER0, afterTime*1000, NO);
	}
	
	return self;
}

- (void) onExit
{
	[super onExit];
}

-(void) dealloc
{
	[super dealloc];
	[invocation release];
	
#if NS_BLOCKS_AVAILABLE
	[block_ release];
#endif
}

#pragma mark CCFontButton - Touches

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return NO;
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	
	touchLocation.x = touchLocation.x * CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y * CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) )
	{
		state = kCCZoom1ButtonSelected;
		return YES;
	}
	
	return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;

	CGPoint touchLocation = [touch locationInView: [touch view]];
	
	touchLocation.x = touchLocation.x * CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y * CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) )
	{
		state = kCCZoom1ButtonUnSelected;
        [invocation invoke];
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;

	state = kCCZoom1ButtonUnSelected;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	
	touchLocation.x = touchLocation.x * CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y * CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) )
	{
		state = kCCZoom1ButtonSelected;
	}
	else 
	{
		state = kCCZoom1ButtonUnSelected;
	}

}

- (void) draw 
{
	float x = (CGRectGetMidX(mFrame));
	float y = (CGRectGetMidY(mFrame));

	if (mSprite == nil)
		return;
	
	CGSize contentSize = [mSprite contentSize];
	[mSprite setPosition: ccp(x, 480-y)];
	[mSelSprite setPosition: ccp(x, 480-y)];
	
	[mSprite setScale: mfZoomScale]; 
	
	if (mbStartZoom)
	{
		if (mfZoomScale > 1.2f)
		{
			mfZoomScale = 1.0f;
			mbStartZoom = NO;
		}
		else
			mfZoomScale += 0.1;
	}

	if (state == kCCZoom1ButtonSelected) 
	{
		[mSelSprite visit];
	}
	else 
	{
		if (mfZoomScale > 0)
		{
			[mSprite visit];
		}
	}
	
	if (mTimer.CallTimerFunc())
	{
		mbStartZoom = YES;
	}	
}

@end

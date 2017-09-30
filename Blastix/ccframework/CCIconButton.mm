/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 KHS
 * 
 */



#import "CCIconButton.h"
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

@implementation CCIconButton
@synthesize mSprite=_mSprite;
@synthesize mSelSprite=_mSelSprite;
@synthesize mIconSprite=_mIconSprite;

- (id) initWithTarget:(id) rec 
			 selector:(SEL) cb 
			textureId: (int) textureId
			selTextureId: (int) selTextureId
			iconTextureId: (int) iconTextureId
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
		self.mSprite = [resManager getTextureWithId: textureId];
		self.mSelSprite  = [resManager getTextureWithId: selTextureId];
		self.mIconSprite  = [resManager getTextureWithId: iconTextureId];
		CGSize contentSize = [self.mSprite contentSize];

		mFrame = CGRectMake( ADJUST_X(position.x),
							ADJUST_Y(position.y),
							contentSize.width,
							contentSize.height);
		
		state = kCCIconButtonUnSelected;
		bNeedReplace = NO;
		mbStartZoom = NO;
		mfZoomScale = 0.0f;
		mTimer.SetTimer(TIMER0, afterTime*1000, NO);
	}
	
	return self;
}

- (id) initWithTarget:(id) rec 
			 selector:(SEL) cb 
		  textureName: (NSString*) textureName 
		  selTextureName: (NSString*) selTextureName 
		  iconTextureName: (NSString*) iconTextureName 
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
		self.mSprite = [resManager getTextureWithName: textureName];
		self.mSelSprite = [resManager getTextureWithName: selTextureName];
		self.mIconSprite = [resManager getTextureWithName: iconTextureName];
		CGSize contentSize = [self.mSprite contentSize];
		
		mFrame = CGRectMake(position.x,
							position.y,
							contentSize.width,
							contentSize.height);
		
		state = kCCIconButtonUnSelected;
		bNeedReplace = NO;
		mbStartZoom = NO;
		mfZoomScale = 0.0f;
		mTimer.SetTimer(TIMER0, afterTime*1000, NO);
	}
	
	return self;
}

- (void) replaceTextureId: (int) textureId
{
	mReplaceTextureId = textureId;
	bNeedReplace = YES;
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
		state = kCCIconButtonSelected;
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
		state = kCCIconButtonUnSelected;
        [invocation invoke];
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;

	state = kCCIconButtonUnSelected;
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
		state = kCCIconButtonSelected;
	}
	else 
	{
		state = kCCIconButtonUnSelected;
	}

}

- (void) draw 
{
	float x = (CGRectGetMidX(mFrame));
	float y = (CGRectGetMidY(mFrame));

	if (self.mSprite == nil)
		return;
	
	[self.mSprite setPosition: ccp(x, 480-y)];
	[self.mSelSprite setPosition: ccp(x, 480-y)];
	[self.mIconSprite setPosition: ccp(x, 480-y)];
	[self.mSprite setScale: mfZoomScale]; 
	[self.mIconSprite setScale: mfZoomScale]; 
	
	if (mbStartZoom)
	{
		if (mfZoomScale >= 1.3f)
		{
			mfZoomScale = 1.0f;
			mbStartZoom = NO;
		}
		else
			mfZoomScale += 0.2;
	}

	if (state == kCCIconButtonSelected) 
	{
		[self.mSelSprite visit];
		[self.mIconSprite visit];
	}
	else 
	{
		if (mfZoomScale > 0)
		{
			[self.mSprite visit];
			[self.mIconSprite visit];
		}
	}
	
	if (bNeedReplace)
	{
		self.mSprite = [resManager getTextureWithId: mReplaceTextureId];
		bNeedReplace = NO;
	}
	
	if (mTimer.CallTimerFunc())
	{
		mbStartZoom = YES;
	}	
}

@end

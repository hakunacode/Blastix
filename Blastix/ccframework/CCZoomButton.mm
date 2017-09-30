/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 KHS
 * 
 */



#import "CCZoomButton.h"
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

@implementation CCZoomButton

- (id) initWithTarget: (id) rec
			 selector: (SEL) cb
		  textureName: (NSString*) textureName
	   selTextureName: (NSString*) selTextureName
			 textName: (NSString*) textName
 			 position: (CGPoint) position
			afterTime: (float) afterTime
{
	if( (self=[super init]) ) {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
		self.isTouchEnabled = YES;
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
		self.isMouseEnabled = YES;
#endif
		// menu in the center of the screen
		
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
		mSprite = [[CCSprite spriteWithFile: textureName] retain];
		mSelSprite = [[CCSprite spriteWithFile: selTextureName] retain];
		CGSize contentSize = [mSprite contentSize];
	
		mFrame = CGRectMake(position.x,
							position.y,
							contentSize.width,
							contentSize.height);
		
		state = kCCZoomButtonUnSelected;
		mbStartZoom = NO;
		mfZoomScale = 0.0f;
		mTimer.SetTimer(TIMER0, afterTime*1000, NO);
		
		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
		
        mButtonLabel = [[CCLabelFX labelWithString:textName 
										   dimensions:CGSizeMake(200, 50) 
											alignment:CCTextAlignmentCenter
											 fontName:@"Arial" 
											 fontSize:22 * SCALE_SCREEN_WIDTH
										 shadowOffset:CGSizeMake(0,0) 
										   shadowBlur:3.0f 
										  shadowColor:shadowColor 
											fillColor:fillColor] retain];
        
		mButtonLabel.position = ccp(100, 100);
	}
	
	return self;
}

- (void) onExit
{
	[super onExit];
}

-(void) dealloc
{
	[invocation release];
	
#if NS_BLOCKS_AVAILABLE
	[block_ release];
#endif
	
	[super dealloc];
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
	
	touchLocation.x = touchLocation.x; //* CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y; // * CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) && mfZoomScale == 1.0f)
	{
		state = kCCZoomButtonSelected;
		return YES;
	}
	
	return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;

	CGPoint touchLocation = [touch locationInView: [touch view]];
	
	touchLocation.x = touchLocation.x;// * CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y;// * CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) && mfZoomScale == 1.0f)
	{
		state = kCCZoomButtonUnSelected;
        [invocation invoke];
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;

	state = kCCZoomButtonUnSelected;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	
	touchLocation.x = touchLocation.x;// * CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y;// * CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) && mfZoomScale == 1.0f)
	{
		state = kCCZoomButtonSelected;
	}
	else 
	{
		state = kCCZoomButtonUnSelected;
	}

}

- (void) draw 
{
	float x = (CGRectGetMidX(mFrame));
	float y = (CGRectGetMidY(mFrame));

	if (mSprite == nil)
		return;
	
	CGSize winSize = [CCDirector sharedDirector].winSize;
	
	[mSprite setPosition: ccp(x, winSize.height - y)];
	[mSelSprite setPosition: ccp(x, winSize.height - y)];
	
	int n = 10;
	
	if(SCALE_SCREEN_WIDTH != 1) {
		n = -20;
	}
	
	[mButtonLabel setPosition:ccp(x, winSize.height - y - n / SCALE_SCREEN_HEIGHT)];
	[mSprite setScale: mfZoomScale]; 
	[mButtonLabel setScale: mfZoomScale];

	
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

	if (state == kCCZoomButtonSelected) 
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
	
	[mButtonLabel visit];
}

@end

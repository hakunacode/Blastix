/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 KHS
 * 
 */



#import "CC3PartButton.h"
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

@implementation CC3PartButton

- (id) initWithTarget:(id) rec 
			 selector:(SEL) cb 
		  textureName: (NSString*) textureName 
	   selTextureName: (NSString*) selTextureName 
				 text: (NSString*) text
			 position:(CGPoint) position
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
		mSpriteHead = [[resManager getTextureWithName: textureName] retain];

		mSelSpriteHead = [[resManager getTextureWithName: selTextureName] retain];

		CGSize contentSizeHead = [mSpriteHead contentSize];
		CGSize contentSize = CGSizeMake(contentSizeHead.width, contentSizeHead.height);		
		
		mFrame = CGRectMake(position.x,
							position.y,
							contentSize.width,
							contentSize.height);
		
		state = kCC3PartButtonUnSelected;

		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
		
        mButtonLabel = [[CCLabelFX labelWithString:text
										dimensions:CGSizeMake(200 * SCALE_SCREEN_WIDTH, 50 * SCALE_SCREEN_HEIGHT) 
										 alignment:CCTextAlignmentCenter
										  fontName:@"Arial" 
										  fontSize:20 * SCALE_SCREEN_WIDTH
									  shadowOffset:CGSizeMake(0,0) 
										shadowBlur:3.0f 
									   shadowColor:shadowColor 
										 fillColor:fillColor] retain];
		
	}
	
	return self;
}

- (void) onExit
{
	[super onExit];
}

-(void) dealloc
{
	[mButtonLabel release];
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
	
	touchLocation.x = touchLocation.x;// * CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y; //* CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) )
	{
		state = kCC3PartButtonSelected;
		return YES;
	}
	
	return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;

	CGPoint touchLocation = [touch locationInView: [touch view]];
	
	touchLocation.x = touchLocation.x; //* CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y; //* CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) )
	{
		state = kCC3PartButtonUnSelected;
        [invocation invoke];
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;

	state = kCC3PartButtonUnSelected;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;
	
	CGPoint touchLocation = [touch locationInView: [touch view]];
	
	touchLocation.x = touchLocation.x;// * CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y;// * CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) )
	{
		state = kCC3PartButtonSelected;
	}
	else 
	{
		state = kCC3PartButtonUnSelected;
	}

}

- (void) draw 
{
	float x = (CGRectGetMidX(mFrame));
	float y = (CGRectGetMidY(mFrame));
	
	if (mSpriteHead == nil)
		return;
	
	CGSize contentSizeHead = [mSpriteHead contentSize];

	CGSize contentSizeHead1 = [mSelSpriteHead contentSize];
	
	CGSize winSize = [CCDirector sharedDirector].winSize;
	[mSpriteHead setPosition: ccp(x, winSize.height-y)];

	[mSelSpriteHead setPosition: ccp(x, winSize.height-y)];

	if (state == kCC3PartButtonSelected) 
	{
		[mSelSpriteHead visit];
	}
	else 
	{
		[mSpriteHead visit];
	}
	
	[mButtonLabel setPosition:ccp(x, winSize.height-y-15*SCALE_SCREEN_HEIGHT)];
	[mButtonLabel visit];

}

@end

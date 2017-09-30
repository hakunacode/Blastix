/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 KHS
 * 
 */



#import "CCButton.h"
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

@implementation CCButton
@synthesize mSprite=_mSprite;
@synthesize mSelSprite=_mSelSprite;

- (id) initWithTarget:(id) rec 
			 selector:(SEL) cb 
			textureId: (int) textureId
			selTextureId: (int) selTextureId
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
		self.mSprite = [resManager getTextureWithId: textureId];
		self.mSelSprite  = [resManager getTextureWithId: selTextureId];
		CGSize contentSize = [self.mSprite contentSize];

		mFrame = CGRectMake( ADJUST_X(position.x),
							ADJUST_Y(position.y),
							contentSize.width,
							contentSize.height);
		
		state = kCCButtonUnSelected;
		bNeedReplace = NO;
		
		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
		
        mButtonLabel = [[CCLabelFX labelWithString:text
										dimensions:CGSizeMake(200, 50) 
										 alignment:CCTextAlignmentCenter
										  fontName:@"Arial" 
										  fontSize:20
									  shadowOffset:CGSizeMake(0,0) 
										shadowBlur:3.0f 
									   shadowColor:shadowColor 
										 fillColor:fillColor] retain];
	}
	
	return self;
}

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
		self.mSprite = [resManager getTextureWithName: textureName];
		self.mSelSprite = [resManager getTextureWithName: selTextureName];
		CGSize contentSize = [self.mSprite contentSize];
		
		mFrame = CGRectMake(position.x,
							position.y,
							contentSize.width,
							contentSize.height);
		
		state = kCCButtonUnSelected;
		bNeedReplace = NO;

		ccColor4B shadowColor = ccc4(0, 0, 255, 255);
		ccColor4B fillColor = ccc4(255, 255, 255,255);
		
        mButtonLabel = [[CCLabelFX labelWithString:text
										dimensions:CGSizeMake(200, 50) 
										 alignment:CCTextAlignmentCenter
										  fontName:@"Arial" 
										  fontSize:15
									  shadowOffset:CGSizeMake(0,0) 
										shadowBlur:3.0f 
									   shadowColor:shadowColor 
										 fillColor:fillColor] retain];
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
	
	touchLocation.x = touchLocation.x * CC_CONTENT_SCALE_FACTOR();
	touchLocation.y = touchLocation.y * CC_CONTENT_SCALE_FACTOR();
	
	if( CGRectContainsPoint( mFrame, touchLocation ) )
	{
		state = kCCButtonSelected;
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
		state = kCCButtonUnSelected;
        [invocation invoke];
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( !visible_ )
		return;

	state = kCCButtonUnSelected;
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
		state = kCCButtonSelected;
	}
	else 
	{
		state = kCCButtonUnSelected;
	}

}

- (void) draw 
{
	float x = (CGRectGetMidX(mFrame));
	float y = (CGRectGetMidY(mFrame));

	if (self.mSprite == nil)
		return;
	
	[self.mSprite setPosition: ccp(x, 320-y)];
	[self.mSelSprite setPosition: ccp(x, 320-y)];

	if (state == kCCButtonSelected) 
	{
		[self.mSelSprite visit];
	}
	else 
	{
		[self.mSprite visit];
	}
	
	if (bNeedReplace)
	{
		self.mSprite = [resManager getTextureWithId: mReplaceTextureId];
		bNeedReplace = NO;
	}
	
	[mButtonLabel setPosition: ccp(x, 320-y-18)];
	[mButtonLabel visit];
}

@end

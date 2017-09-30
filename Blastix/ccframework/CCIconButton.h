/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */


#import "CCLayer.h"
#import "ResourceManager.h"
#include "BBTimer.h"

typedef enum  {
	kCCIconButtonSelected = 0,
	kCCIconButtonUnSelected
} tCCIconButtonState;

/** A CCMenu
 * 
 * Features and Limitation:
 *  - You can add MenuItem objects in runtime using addChild:
 *  - But the only accecpted children are MenuItem objects
 */
@interface CCIconButton : CCLayer <CCRGBAProtocol>
{
	NSInvocation *invocation;
#if NS_BLOCKS_AVAILABLE
	// used for menu items using a block
	void (^block_)(id sender);
#endif
	
	tCCIconButtonState state;
	ResourceManager* resManager;
	CGRect mFrame;
	CCSprite* _mSprite;
	CCSprite* _mSelSprite;
	CCSprite* _mIconSprite;
	
	int mReplaceTextureId;
	BOOL bNeedReplace;	
	
	BOOL mbStartZoom;
	float mfZoomScale;
	BBTimer mTimer;
}

@property (nonatomic, retain) CCSprite *mSprite;
@property (nonatomic, retain) CCSprite *mSelSprite;
@property (nonatomic, retain) CCSprite *mIconSprite;

- (id) initWithTarget:(id) rec 
			 selector:(SEL) cb 
			textureId: (int) textureId
		 selTextureId: (int) selTextureId
		 iconTextureId: (int) iconTextureId
			 position:(CGPoint) position
			afterTime: (float) afterTime;

- (id) initWithTarget:(id) rec 
			 selector:(SEL) cb 
		  textureName: (NSString*) textureName 
	   selTextureName: (NSString*) selTextureName 
	  iconTextureName: (NSString*) iconTextureName
			 position:(CGPoint) position
			afterTime:(float) afterTime;

- (void) replaceTextureId: (int) textureId;
@end

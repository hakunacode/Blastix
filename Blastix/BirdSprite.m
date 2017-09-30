//
//  BirdSprite.m
//  Blastix
//
//  Created by admin on 4/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BirdSprite.h"
#import "MacroDefine.h"

enum {
    kTagItemBirdAni = 1,
    kTagRemoveBirdAni
};


@implementation BirdSprite

-(id) initBirdSprite:(int)nBird {
	self = [super initWithFile:IS_IPAD(@"bird7-iPad.png", @"bird7.png")];
	if (self) {
        [self redrawBird:nBird];
        m_nState = stateShow;
		[self scheduleUpdate];
    }
	return self;
}

-(void) redrawBird:(int)nBird {
    m_nBirdNum = nBird;
    
    [self stopAllActions];
    
    if (m_nBirdNum >= BIRD_ITEM) {
        CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:IS_IPAD(@"bird%d-iPad.png", @"bird%d.png"),nBird]];
        [self setTexture:tex];
        
        CCAnimation * pAni = [CCAnimation animation];
        [pAni addFrameWithFilename:[NSString stringWithFormat:IS_IPAD(@"bird%d-iPad.png", @"bird%d.png"),nBird]];
        [pAni addFrameWithFilename:[NSString stringWithFormat:IS_IPAD(@"bird%d_1-iPad.png", @"bird%d_1.png"),nBird]];
        
        CCAnimate * pAnimate = [CCAnimate actionWithDuration:0.5f animation:pAni restoreOriginalFrame:NO];
        CCRepeatForever * pRepeat = [CCRepeatForever actionWithAction:pAnimate];
        pRepeat.tag = kTagItemBirdAni;
        [self runAction:pRepeat];
    }
    else {
        CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:IS_IPAD(@"bird%d-iPad.png", @"bird%d.png"),nBird]];
        [self setTexture:tex];
    }

    [self setScale:1.0f];
}

-(void) update:(ccTime) delta {
	if (m_nState == stateShow && self.scale != 1) {
		[self setScale:1.0f];
	}
}

-(void) refreshTexture:(int)nBird bEffect:(bool)bEffect{
    m_nState = stateShow;
    
    [self redrawBird:nBird];
    
//	if (tex) {
//		if (m_nStoneType == ITEM_SAMEALL) {
//			[self stopActionByTag:kTagSameAllAction];
//		}
//		if (m_nStoneType == ITEM_ADJALL) {
//			CCNode * node = [self getChildByTag:kTagAdjAllSprite];
//			if (node)
//				[node removeFromParentAndCleanup:YES];
//		}
//		if (m_nStoneType == ITEM_LINEALL) {
//			CCNode * node = [self getChildByTag:kTagLineAllSprite];
//			if (node)
//				[node removeFromParentAndCleanup:YES];
//		}
//		[self setTexture:tex];
//		m_nStoneType = nStoneType;
//		
//		if (bEffect) {
//			CCParticleSystem* m_pEmitter = [[[CCParticleSystemQuad alloc] initWithTotalParticles:10] autorelease];
//			
//			m_pEmitter.duration = 0.3f;
//			m_pEmitter.angle = 90;
//			m_pEmitter.angleVar = 360;
//			
//			m_pEmitter.emitterMode = kCCParticleModeGravity;
//			
//			m_pEmitter.gravity = CGPointMake(0, 0);
//			m_pEmitter.speed = 120;
//			m_pEmitter.speedVar = 60;
//			m_pEmitter.tangentialAccel = 0.0f;
//			m_pEmitter.tangentialAccelVar = 0.0f;
//			m_pEmitter.radialAccel = 0.0f;
//			m_pEmitter.radialAccelVar = 0.0f;
//			
//			m_pEmitter.startSize = 40.0f;
//			m_pEmitter.startSizeVar = 10.0f;
//			m_pEmitter.endSize = kCCParticleStartSizeEqualToEndSize;
//			m_pEmitter.endSizeVar = 20.0f;
//			m_pEmitter.life = 0.25f;
//			m_pEmitter.lifeVar = 0.05f;
//			
//			m_pEmitter.startColor = stoneColor[m_nStoneType - 1];
//			m_pEmitter.startColorVar =(ccColor4F){0.0f, 0.0f, 0.0f, 0};
//			m_pEmitter.endColor = stoneColor[m_nStoneType - 1];
//			m_pEmitter.endColorVar =(ccColor4F){0.0f, 0.0f, 0.0f, 0};
//			m_pEmitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"stars.png"];
//			m_pEmitter.emissionRate = m_pEmitter.totalParticles / m_pEmitter.duration;
//			m_pEmitter.blendAdditive = NO;
//			m_pEmitter.position = [self position];
//			[[self parent] addChild:m_pEmitter z:10 tag:kTagRefreshParticle + g_RefreshParticleIndex];
//			
//		}
//	}
}

-(void) MoveToDown:(CGPoint)ptPos nSteps:(int)nSteps nDelay:(int)nDelay{
	id move = [CCMoveTo actionWithDuration:MOVE_ANI_DURATION * nSteps position:ptPos];
	[self runAction:move];
}

-(void) MoveToDownWithDelay:(CGPoint)ptPos nSteps:(int)nSteps fDelay:(double)fdelay {
	id move = [CCMoveTo actionWithDuration:MOVE_ANI_DURATION * nSteps / 2 position:ptPos];
	id action = [CCSequence actions:[CCDelayTime actionWithDuration:fdelay], move, nil];
	[self runAction:action];
}

-(void) removeAnimation {
    m_nState = stateHide;

    CCAnimation * pAni = [CCAnimation animation];
    [pAni addFrameWithFilename:IS_IPAD(@"strike1-iPad.png", @"strike1.png")];
    [pAni addFrameWithFilename:IS_IPAD(@"strike2-iPad.png", @"strike2.png")];
    [pAni addFrameWithFilename:IS_IPAD(@"strike3-iPad.png", @"strike3.png")];
    CCAnimate * pAnimate = [CCAnimate actionWithDuration:REMOVE_ANI_DURATION animation:pAni restoreOriginalFrame:NO];
    CCRepeatForever * pRepeat = [CCRepeatForever actionWithAction:pAnimate];
    pRepeat.tag = kTagRemoveBirdAni;
    [self runAction:pRepeat];
}

-(int) getBirdNum {
    return m_nBirdNum;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    [self stopAllActions];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end

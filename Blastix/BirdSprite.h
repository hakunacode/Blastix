//
//  BirdSprite.h
//  Blastix
//
//  Created by admin on 4/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define BIRD_ITEM               7

#define		MOVE_ANI_DURATION		0.1
#define		REMOVE_ANI_DURATION		0.3

#define		INVALID_TIME			-1.0

enum stateBird {
	stateShow = 160,
	stateHide,
};

@interface BirdSprite : CCSprite {
    float   m_nCellWidth;
    float   m_nCellHeight;
    int     m_nBirdNum;
    int		m_nState;
}

-(id) initBirdSprite:(int)nBird;
-(void) redrawBird:(int)nBird;
-(void) MoveToDown:(CGPoint)ptPos nSteps:(int)nSteps nDelay:(int)nDelay;
-(void) MoveToDownWithDelay:(CGPoint)ptPos nSteps:(int)nSteps fDelay:(double)fdelay;
-(void) removeAnimation;
-(void) refreshTexture:(int)nBird bEffect:(bool)bEffect;
-(int) getBirdNum;

@end

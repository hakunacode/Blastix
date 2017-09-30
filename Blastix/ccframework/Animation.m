//
//  Animation.m
//  towerGame
//
//  Created by KCU on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Animation.h"

@implementation Animation
@synthesize	m_nFrameSize;
@synthesize	m_nCurFrame;
@synthesize	m_fCurValue;
@synthesize	m_fIncValue;
@synthesize	m_bValid;

- (id) init
{
	if ( (self=[super init]) )
	{
		m_nFrameSize = 0;
		m_nCurFrame = 0;
		m_fCurValue = 0;
		m_fIncValue = 0;
		m_bValid = NO;
	}

	return self;
}

- (void) startAnimation: (int) frameSize curFrame: (int) curFrame curValue: (float) curValue incValue: (float) incValue
{
	m_nFrameSize = frameSize;
	m_nCurFrame = curFrame;
	m_fCurValue = curValue;
	m_fIncValue = incValue;
	m_bValid = YES;
}

- (void) restartAnimation
{
	m_nCurFrame = 0;
	m_fCurValue = 0;
	m_bValid = YES;
}

- (void) stopAnimation
{
	m_bValid = NO;
}

- (BOOL) isValid
{
	return m_bValid;
}

- (void) updateFrame
{
	if (m_bValid == NO)
		return;
	
	m_nCurFrame ++;
	m_fCurValue += m_fIncValue;

	if (m_nFrameSize <= m_nCurFrame)
	{
		m_bValid = NO;
	}
}

@end

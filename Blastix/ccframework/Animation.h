//
//  Animation.h
//  towerGame
//
//  Created by KCU on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animation : NSObject 
{
	int		m_nFrameSize;
	int		m_nCurFrame;
	float	m_fCurValue;
	float	m_fIncValue;
	BOOL	m_bValid;
}
@property(nonatomic) int m_nFrameSize;
@property(nonatomic) int m_nCurFrame;
@property(nonatomic) float m_fCurValue;
@property(nonatomic) float m_fIncValue;
@property(nonatomic) BOOL m_bValid;

- (id) init;
- (void) updateFrame;
- (void) startAnimation: (int) frameSize curFrame: (int) curFrame curValue: (float) curValue incValue: (float) incValue;
- (void) restartAnimation;
- (void) stopAnimation;
- (BOOL) isValid;

@end

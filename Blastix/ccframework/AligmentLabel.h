//
//  AligmentLabel.h
//  FreeMagicTricks
//
//  Created by admin on 2/22/12.
//  Copyright 2012 _OSD Center_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AligmentLabel : CCLabelTTF
{
    CCTextAlignment			m_alignment;
}

- (void) setAligment: (CCTextAlignment) align;

@end

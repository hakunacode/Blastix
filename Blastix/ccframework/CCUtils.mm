//
//  CCUtils.m
//  tarzanGame
//
//  Created by KCU on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCUtils.h"
#import "DeviceSettings.h"

@implementation CCUtils

+ (void) drawFont: (CCLabelBMFont*) font str: (NSString*) str x:(float)x y: (float) y align: (int) align
{
	if (str == nil || font == nil)
		return;
	
	[font setString: str];
	CGSize contentSize = [font contentSize];
	
	if (align == ALIGN_RIGHT)
	{
		x = x - contentSize.width;
	}
	else if (align == ALIGN_CENTER)
	{
		x = x - contentSize.width/2.0f;
	}
	
	CGRect frame = CGRectMake(x,
						y,
						contentSize.width,
						contentSize.height);
	
	float fX = CGRectGetMidX(frame);
	
	[font setPosition: ADJUST_CCP(ccp(fX,480-y))];
	[font visit];
}

@end

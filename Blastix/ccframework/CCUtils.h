//
//  CCUtils.h
//  tarzanGame
//
//  Created by KCU on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
enum CCALIGN
{
	ALIGN_LEFT = 0,
	ALIGN_CENTER,
	ALIGN_RIGHT	
};

@interface CCUtils : NSObject 
{
}

+ (void) drawFont: (CCLabelBMFont*) font str: (NSString*) str x:(float)x y: (float) y align: (int) align;
@end

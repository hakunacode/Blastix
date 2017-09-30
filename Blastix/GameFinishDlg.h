//
//  LevelSuccessDlg.h
//  Blastix
//
//  Created by admin on 4/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SoundManager.h"

@interface GameFinishDlg : CCLayer {
    SoundManager*		m_soundManager;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

@end

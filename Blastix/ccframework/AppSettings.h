//
//  AppSetting.h
//  fruitGame
//
//  Created by KCU on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSettings : NSObject 
{

}

+ (void) defineUserDefaults;
/*
+ (void) setBackgroundVolume: (float) fVolume;
+ (void) setEffectVolume: (float) fVolume;
+ (float) backgroundVolume;
+ (float) effectVolume;
+ (void) setLevelFlag: (int) index flag: (BOOL) flag;
+ (BOOL) getLevelFlag: (int) index;
+ (void) setUseAccelFlag: (BOOL) bFlag;
+ (BOOL) getUseAccelFlag;
+ (void) setFullVersion: (BOOL) bFullVersion;
+ (BOOL) getFullVersion;
*/
+ (void) setStartLevel: (int) index;
+ (int) getStartLevel;
+ (void) setScore: (int64_t) nScore;
+ (int64_t) getScore;
+ (void) setBackgroundMusic: (BOOL) bFullVersion;
+ (BOOL) getBackgroundMusic;
+ (void) setEffectMusic: (BOOL) bFullVersion;
+ (BOOL) getEffectMusic;
+ (bool) setScoreBumper: (int64_t) nScore;
+ (int64_t) getScoreBumper;
@end

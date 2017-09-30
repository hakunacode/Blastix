//
//  SoundManager.h
//  crashGame
//
//  Created by KCU on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"

enum eEffects
{
	soundClickBtn = 0,
	soundDead,
	soundFail,
	soundShoot,
	soundSuccess,
	soundEffectCount
};

enum eBackground
{
	soundMenuBGM = 0,
	soundGameBGM,
	soundBackCount
};

@interface SoundManager : NSObject {
	SimpleAudioEngine *soundEngine;
	CDAudioManager* audioManager;
	
	BOOL mbBackgroundMute;
	BOOL mbEffectMute;
}

+ (SoundManager*) sharedSoundManager;
+ (void) releaseSoundManager;

- (id) init;

- (void) loadData;
- (unsigned int) playEffect: (int) effectId bForce: (BOOL) bForce;
//- (unsigned int) playEffect: (int) effectId loop: (bool) loop;
- (void) stopEffect: (ALuint) soundId;
- (void) playBackgroundMusic:(int) soundId;
- (void) stopBackgroundMusic;
- (void) playRandomBackground;

- (void) setBackgroundMusicMute: (BOOL) bMute;
- (void) setEffectMute: (BOOL) bMute;

- (BOOL) getBackgroundMusicMuted;
- (BOOL) getEffectMuted;

- (void) setBackgroundVolume: (float) fVolume;
- (void) setEffectVolume: (float) fVolume;

- (float) backgroundVolume;
- (float) effectVolume;

-(BOOL) isBackgroundMusicPlaying;
@end

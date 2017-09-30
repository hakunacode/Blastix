//
//  SoundManager.m
//  crashGame
//
//  Created by KCU on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"
#include <sys/time.h>

@implementation SoundManager

static SoundManager *_sharedSound = nil;

static NSString* strEffectFiles[] =
{
	@"click_button.wav",
	@"dead.wav",
	@"fail.wav",
	@"shoot.wav",
	@"success.wav",
};

static NSString* strSoundFiles[] =
{
	@"game_bgm.mp3",
	@"menu_bgm.mp3",
};

+ (SoundManager*) sharedSoundManager 
{
	if (!_sharedSound) 
	{
		_sharedSound = [[SoundManager alloc] init];
	}
	
	return _sharedSound;
}

+ (void) releaseSoundManager 
{
	if (_sharedSound) 
	{
		[_sharedSound release];
		_sharedSound = nil;
	}
}

- (id) init
{
	if ( (self=[super init]) )
	{
		soundEngine = [SimpleAudioEngine sharedEngine];
		//[soundEngine setEffectsVolume: 0.02f];
		//[soundEngine setBackgroundMusicVolume: 0.02f];
		audioManager = [CDAudioManager sharedManager];
		mbEffectMute = NO;
		mbBackgroundMute = NO;
	}
	
	return self;
}

- (void) loadData
{
}

- (void) playRandomBackground
{
	int soundId = arc4random()%soundBackCount;
	[self playBackgroundMusic: soundId];
}
/*
static unsigned int GetCurrentTime()
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	unsigned int ms = tv.tv_sec * 1000L + tv.tv_usec / 1000L;
	return ms;
}
*/
- (unsigned int) playEffect: (int) effectId bForce: (BOOL) bForce
{
	if (effectId < 0 || effectId >= soundEffectCount)
		return 0;
	if (mbEffectMute)
		return 0;
	
	return [soundEngine playEffect:strEffectFiles[effectId]];
}

//- (unsigned int) playEffect: (int) effectId loop: (bool) loop
//{
//	if (effectId < 0 || effectId >= soundEffectCount)
//		return 0;
//	if (mbEffectMute)
//		return 0;
//	
//	return [soundEngine playEffect:strEffectFiles[effectId] loop:loop];
//}

- (void) stopEffect: (ALuint) soundId 
{
	[soundEngine stopEffect:soundId];
}

-(void) playBackgroundMusic:(int) soundId
{
	if (soundId < 0 || soundId >= soundBackCount)
		return;
	if (mbBackgroundMute)
		return;

	[soundEngine playBackgroundMusic:strSoundFiles[soundId] loop:TRUE];
}

-(BOOL) isBackgroundMusicPlaying {
	return [soundEngine isBackgroundMusicPlaying];
}

-(void) stopBackgroundMusic
{
	[soundEngine stopBackgroundMusic];
}

- (void) setBackgroundMusicMute: (BOOL) bMute
{
	mbBackgroundMute = bMute;
}

- (void) setEffectMute: (BOOL) bMute
{
	mbEffectMute = bMute;
}

- (BOOL) getBackgroundMusicMuted
{
	return mbBackgroundMute;
}

- (BOOL) getEffectMuted
{
	return mbEffectMute;
}

- (float) backgroundVolume
{
	return soundEngine.backgroundMusicVolume;
}

- (void) setBackgroundVolume: (float) fVolume
{
	soundEngine.backgroundMusicVolume = fVolume;
}

- (void) setEffectVolume: (float) fVolume
{
	soundEngine.effectsVolume = fVolume;
}

- (float) effectVolume
{
	return soundEngine.effectsVolume;
}

- (void) dealloc
{
	[super dealloc];
}
@end

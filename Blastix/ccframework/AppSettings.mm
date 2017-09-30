//
//  AppSetting.m
//  fruitGame
//
//  Created by KCU on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppSettings.h"
#import "AppDelegate.h"


@implementation AppSettings

+ (void) defineUserDefaults
{
	NSString* userDefaultsValuesPath;
	NSDictionary* userDefaultsValuesDict;
	
	// load the default values for the user defaults
	userDefaultsValuesPath = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"plist"];
	userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile: userDefaultsValuesPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults: userDefaultsValuesDict];
}

+ (void) setScore: (int64_t) nScore
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* score  =	[NSNumber numberWithUnsignedLongLong: nScore];	
	[defaults setObject:score forKey:@"scoreLite"];	
	[NSUserDefaults resetStandardUserDefaults];	
}

+ (int64_t) getScore
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* score = [defaults objectForKey:@"scoreLite"];
    return [score unsignedLongLongValue];
}

+ (bool) setScoreBumper: (int64_t) nScore
{
	NSNumber* score = [[NSUserDefaults standardUserDefaults] objectForKey:@"scoreBumperLite"];
	int64_t preScore = [score unsignedLongLongValue];
	if (preScore >= nScore) {
		return false;
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	score  =	[NSNumber numberWithUnsignedLongLong: nScore];	
	[defaults setObject:score forKey:@"scoreBumperLite"];
	[NSUserDefaults resetStandardUserDefaults];	
	return true;
}

+ (int64_t) getScoreBumper
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* score = [defaults objectForKey:@"scoreBumperLite"];
    return [score unsignedLongLongValue];
}

+ (void) setBackgroundMusic: (BOOL) bFullVersion {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:bFullVersion forKey:@"background musicLite"];	
	[NSUserDefaults resetStandardUserDefaults];
}

+ (BOOL) getBackgroundMusic {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey: @"background musicLite"];
}

+ (void) setEffectMusic: (BOOL) bFullVersion {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:bFullVersion forKey:@"effect musicLite"];	
	[NSUserDefaults resetStandardUserDefaults];
}

+ (BOOL) getEffectMusic {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey: @"effect musicLite"];
}

+(void) setStartLevel: (int) index 
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* level  =	[NSNumber numberWithInt: index];
	AppDelegate* pAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	GameMode nMode = [pAppDelegate getGameMode];
	if (nMode == ModeBlaster) {
		[defaults setObject:level forKey: @"curLevelLite"];	
	}
	else if (nMode == ModeBumper) {
		[defaults setObject:level forKey: @"curLevelBumperLite"];	
	}
	[NSUserDefaults resetStandardUserDefaults];
}

+ (int) getStartLevel
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* level;
	
	AppDelegate* pAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	GameMode nMode = [pAppDelegate getGameMode];
	if (nMode == ModeBlaster) {
		level = [defaults objectForKey:@"curLevelLite"];
	}
	else if (nMode == ModeBumper) {
		level = [defaults objectForKey:@"curLevelBumperLite"];
	}
	
    return [level intValue];
}

/*
+ (void) setFullVersion: (BOOL) bFullVersion
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:bFullVersion forKey:@"full version"];	
	[NSUserDefaults resetStandardUserDefaults];
}

+ (BOOL) getFullVersion
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey: @"full version"];
}

+ (void) setBackgroundVolume: (float) fVolume
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aVolume  =	[[NSNumber alloc] initWithFloat: fVolume];	
	[defaults setObject:aVolume forKey:@"music"];	
	[NSUserDefaults resetStandardUserDefaults];	
}

+ (float) backgroundVolume
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	return [defaults floatForKey:@"music"];
	
}

+ (void) setEffectVolume: (float) fVolume
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aVolume  =	[[NSNumber alloc] initWithFloat: fVolume];	
	[defaults setObject:aVolume forKey:@"effect"];	
	[NSUserDefaults resetStandardUserDefaults];	
}

+ (float) effectVolume
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	return [defaults floatForKey:@"effect"];
	
}

+ (void) setLevelFlag: (int) index flag: (BOOL) flag
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aFlag  =	[NSNumber numberWithFloat: flag];	
	[defaults setObject:aFlag forKey:[NSString stringWithFormat: @"level%d", index]];	
	[NSUserDefaults resetStandardUserDefaults];		
}

+ (BOOL) getLevelFlag: (int) index
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey: [NSString stringWithFormat: @"level%d", index]];	
}

+(void) setUseAccelFlag:(BOOL)bFlag
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aFlag  =	[NSNumber numberWithFloat: bFlag];	
	[defaults setObject:aFlag forKey:@"useAccelFlag"];	
	[NSUserDefaults resetStandardUserDefaults];
}

+(BOOL) getUseAccelFlag
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	return [defaults boolForKey: @"useAccelFlag"];
}
*/
@end

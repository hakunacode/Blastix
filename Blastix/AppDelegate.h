//
//  AppDelegate.h
//  Blastix
//
//  Created by admin on 4/6/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "AppSpecificValues.h"
#import "FBConnect.h"
#import "Session.h"
#import "UserInfo.h"


#define kFBAppId						@"207760805928174"

enum GameMode {
	ModeBlaster = 0,
	ModeBumper,
};

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate,
GameCenterManagerDelegate,
GKAchievementViewControllerDelegate, 
GKLeaderboardViewControllerDelegate,
FBRequestDelegate,FBDialogDelegate,FBSessionDelegate, UserInfoLoadDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
	//GameCenter
	GameCenterManager* gameCenterManager;
	NSString* currentLeaderBoard;
	
	//Facebook
	Session *_session;
	UserInfo *_userInfo;
	Facebook* _facebook;
	NSArray* _permissions;
	NSString* attachment;
	int m_nTopScore;
	
	GameMode		m_GameMode;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) GameCenterManager* gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

//- (BOOL) isIPad;
- (void) setGameMode:(GameMode)nMode;
- (GameMode)  getGameMode;

//Game Center
- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete;
- (void) submitScore: (int) nScore;
- (void) showLeaderboard;

// Facebook
- (void) SendQuoteToFacebook;
- (void) login;
- (void) OnFacebookClicked: (int) topScore;

@end

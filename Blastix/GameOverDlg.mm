//
//  GameOverDlg.m
//  Blastix
//
//  Created by admin on 4/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverDlg.h"
#import "GameLayer.h"
#import "AppSettings.h"
#import "MacroDefine.h"

// GameOverDlg
@interface GameOverDlg()
-(void) drawImages;
-(void) drawButtons;

-(void) onReplayLevel;
-(void) onNewGame;
@end

@implementation GameOverDlg

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverDlg *layer = [GameOverDlg node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		m_soundManager = [SoundManager sharedSoundManager];
		
        [self drawImages];
        [self drawButtons];
	}
	return self;
}

-(void) drawImages {
    // ask director the the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:IS_IPAD(@"game_over_back-iPad.png", @"game_over_back.png") selectedImage:IS_IPAD(@"game_over_back-iPad.png", @"game_over_back.png")];
    CCMenu *menu = [CCMenu menuWithItems:back, nil];
    menu.position = ccp(size.width / 2, size.height / 2);
    [self addChild:menu];
}

-(void) drawButtons {
	AppDelegate* pDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if ([pDelegate getGameMode] == ModeBlaster) {
		CCMenuItemImage *btnOK = [CCMenuItemImage itemFromNormalImage:IS_IPAD(@"btn_replay_1-iPad.png", @"btn_replay_1.png") selectedImage:IS_IPAD(@"btn_replay_2-iPad.png", @"btn_replay_2.png") target:self selector:@selector(onReplayLevel)];
		
		CCMenu *menu = [CCMenu menuWithItems:btnOK, nil];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			menu.position = ccp(160, 130);
		} else {
			menu.position = ccp(384, 260);
		}
		[self addChild:menu];
	}
    else {
		CCMenuItemImage *btnOK = [CCMenuItemImage itemFromNormalImage:IS_IPAD(@"btn_newgame_1-iPad.png", @"btn_newgame_1.png") selectedImage:IS_IPAD(@"btn_newgame_2-iPad.png", @"btn_newgame_2.png") target:self selector:@selector(onNewGame)];
		
		CCMenu *menu = [CCMenu menuWithItems:btnOK, nil];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			menu.position = ccp(160, 130);
		} else {
			menu.position = ccp(384, 260);
		}
		[self addChild:menu];
	}
}

-(void) onReplayLevel {
	[m_soundManager playEffect:soundClickBtn bForce:YES];
	
    GameLayer* parent = (GameLayer*)self.parent;
    [parent onGameOver];
    [self removeFromParentAndCleanup:YES];
}

-(void) onNewGame {
	[m_soundManager playEffect:soundClickBtn bForce:YES];
	
//	[AppSettings setStartLevel:0];
    GameLayer* parent = (GameLayer*)self.parent;
    [parent onGameOver];
    [self removeFromParentAndCleanup:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end

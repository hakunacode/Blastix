//
//  LevelSuccessDlg.m
//  Blastix
//
//  Created by admin on 4/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameFinishDlg.h"
#import "GameLayer.h"
#import "MainMenuLayer.h"
#import "AppSettings.h"
#import "MacroDefine.h"


// LevelSuccessDlg
@interface GameFinishDlg()
-(void) drawImages;
-(void) drawButtons;

-(void) onNewGame;
-(void) onMainMenu;
-(void) onGet;

@end

@implementation GameFinishDlg

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameFinishDlg *layer = [GameFinishDlg node];
	
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
    
    CCMenuItemImage *back = [CCMenuItemImage itemFromNormalImage:IS_IPAD(@"game_finish_back-iPad.png", @"game_finish_back.png") selectedImage:IS_IPAD(@"game_finish_back-iPad.png", @"game_finish_back.png")];
    CCMenu *menu = [CCMenu menuWithItems:back, nil];
    menu.position = ccp(size.width / 2, size.height / 2);
    [self addChild:menu];
}

-(void) drawButtons {
    CCMenuItemImage *btnNewGame = [CCMenuItemImage itemFromNormalImage:IS_IPAD(@"btn_newgame_1-iPad.png", @"btn_newgame_1.png") selectedImage:IS_IPAD(@"btn_newgame_2-iPad.png", @"btn_newgame_2.png") target:self selector:@selector(onNewGame)];
    CCMenuItemImage *btnMainMenu = [CCMenuItemImage itemFromNormalImage:IS_IPAD(@"btn_menu_1-iPad.png", @"btn_menu_1.png") selectedImage:IS_IPAD(@"btn_menu_2-iPad.png", @"btn_menu_2.png") target:self selector:@selector(onMainMenu)];
	CCMenuItemImage *btnGet = [CCMenuItemImage itemFromNormalImage:IS_IPAD(@"btn_get-iPad.png", @"btn_get.png") selectedImage:IS_IPAD(@"btn_get-iPad.png", @"btn_get.png") target:self selector:@selector(onGet)];
	
    CCMenu *menu = [CCMenu menuWithItems:btnGet, btnNewGame, btnMainMenu, nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        menu.position = ccp(160, 120);
		[menu alignItemsVerticallyWithPadding:24];
    } else {
        menu.position = ccp(384, 260);
		[menu alignItemsVerticallyWithPadding:48];
    }
    [self addChild:menu];
}

-(void) onNewGame {
	[m_soundManager playEffect:soundClickBtn bForce:YES];
	
	[AppSettings setStartLevel:0];
	[AppSettings setScore:0];
	
    GameLayer* parent = (GameLayer*)self.parent;
    [parent onLevelSuccess];
    [self removeFromParentAndCleanup:YES];
}

-(void) onMainMenu {
	[m_soundManager playEffect:soundClickBtn bForce:YES];
	
	[[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}

-(void) onGet {
	
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

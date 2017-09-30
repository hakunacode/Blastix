//
//  GameLayer.mm
//  Blastix
//
//  Created by admin on 4/6/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "MainMenuLayer.h"
#import "PauseLayer.h"
#import "LevelSuccessDlg.h"
#import "GameOverDlg.h"
#import "AppSettings.h"
#import "CCLabelFX.h"
#import "GameFinishDlg.h"
#import "MacroDefine.h"

enum {
    kTagPointLabel = 1000
};

#define CELL_WIDTH              36
#define CELL_HEIGHT             48
#define CELL_WIDTH_PAD          84
#define CELL_HEIGHT_PAD         104

#define TOP_LAYER               1000

#define SLINGSHOT_WIDHT         76
#define SLINGSHOT_HEIGHT        82
#define SLINGSHOT_WIDHT_PAD     152
#define SLINGSHOT_HEIGHT_PAD    164

#define THROW_ANI_DURATION      0.5

#define BUMPER_TIME				1.5f

extern Level g_LevelInfo[];

static CGPoint ptBoardStartPos = {34, 448};
static CGPoint ptMenuPos = {56, 100};
static CGPoint ptLevelLabel = {56, 48};
static CGPoint ptTimeLabel = {56, 36};
static CGPoint ptRestLabel = {56, 24};
static CGPoint ptScoreLabel = {20, 72};

static CGPoint ptPadBoardStartPos = {90, 958};
static CGPoint ptPadMenuPos = {130, 235};
static CGPoint ptPadLevelLabel = {138, 100};
static CGPoint ptPadTimeLabel = {138, 75};
static CGPoint ptPadRestLabel = {138, 50};
static CGPoint ptPadScoreLabel = {20, 170};

// GameLayer
@interface GameLayer()
-(void) drawImages;
-(void) drawLabels;
-(void) drawButtons;

-(void) onSound;
-(void) onPause;

-(void) startGame;
-(void) successGame;
-(void) failGame;

-(void) drawGame;
-(void) printGame;

-(void) throwStoneAnimation;
-(void) removeBirdsAnimation;
-(void) moveBirdsAnimation;
-(void) resuffleAnimation;
-(void)	bonusAnimation;
-(void)	earnTimeAnimation;
-(void) startLevelAnimation;

-(CGPoint) getBirdsPosition:(int)nPosX posY:(int)nPosY;
-(void)	releasePointLabel;
@end

// GameLayer implementation
@implementation GameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
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
		[m_soundManager playBackgroundMusic:soundGameBGM];
		
		m_pAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		
//		if ([m_pAppDelegate getGameMode] == ModeBlaster) {
//			m_nLevel = [AppSettings getStartLevel];
//		}
//		else {
//			m_nLevel = 0;
//			[AppSettings setStartLevel:m_nLevel];
//		}		
        
		m_nLevel = [AppSettings getStartLevel];
        m_nGameState = stateIdle;
        m_Duaration = 0;
        m_GameTime = 0;
        m_nShotBird = EMPTY_BIRD;
        m_nPointLabelCount = 0;
		m_nScore = 0;
		
        m_ptCurrentPos = ccp(0, 0);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            m_nCellWidth = CELL_WIDTH;
            m_nCellHeight = CELL_HEIGHT;
            m_nSlingShotWidth = SLINGSHOT_WIDHT;
            m_nSlingShotHeight = SLINGSHOT_HEIGHT;
            m_ptBoardStartPos = ptBoardStartPos;
        } else {
            m_nCellWidth = CELL_WIDTH_PAD;
            m_nCellHeight = CELL_HEIGHT_PAD;
            m_nSlingShotWidth = SLINGSHOT_WIDHT_PAD;
            m_nSlingShotHeight = SLINGSHOT_HEIGHT_PAD;
            m_ptBoardStartPos = ptPadBoardStartPos;
        }
        m_fRatio = (float)m_nCellHeight * (BOARD_HEIGHT - 1) / (float)m_nSlingShotHeight;
        
        self.isTouchEnabled = YES;
        
        [self drawImages];
        [self drawLabels];
        [self drawButtons];
		
		if ([m_pAppDelegate getGameMode] == ModeBumper) {
			m_pTimerBar = [[Timebar alloc] initTimebar];
			[self addChild:m_pTimerBar];
		}
		else {
			m_pTimerBar = nil;
		}

//        [self startGame];
		[self startLevelAnimation];
        [self scheduleUpdate];
		
	}
	return self;
}

-(void) drawImages {
    // ask director the the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    m_sprBack = [CCSprite spriteWithFile:IS_IPAD(@"game_back1-iPad.png", @"game_back1.png")];
    m_sprBack.position = ccp(size.width / 2, size.height / 2);
    [self addChild:m_sprBack];
    
    for (int y = 0; y < BOARD_HEIGHT; y++) {
        for (int x = 0; x < BOARD_WIDTH; x++) {
            m_sprBird[y][x] = [[[BirdSprite alloc] initBirdSprite:0] autorelease];
            m_sprBird[y][x].visible = NO;
            [self addChild:m_sprBird[y][x]];
        }
    }
    
    m_sprSlingShot = [SlingShotSprite spriteWithFile:IS_IPAD(@"slingshot_1-iPad.png", @"slingshot_1.png")];
    m_sprSlingShot.anchorPoint = ccp(0.5, 0);
    m_sprSlingShot.position = ccp(size.width / 2, 0);
    m_sprSlingShot.state = stateNone;
    [self addChild:m_sprSlingShot z:1];
    
    m_sprStone = [CCSprite spriteWithFile:IS_IPAD(@"stone-iPad.png", @"stone.png")];
    m_sprStone.visible = NO;
    [self addChild:m_sprStone z:1];
    
    m_sprArrow = [CCSprite spriteWithFile:IS_IPAD(@"arrow-iPad.png", @"arrow.png")];
    m_sprArrow.anchorPoint = ccp(0.5, 1);
    m_sprArrow.position = ccp(size.width / 2, m_ptBoardStartPos.y - m_nCellHeight * 5);
    [self addChild:m_sprArrow];
    
}

-(void) drawLabels {
	
	if ([m_pAppDelegate getGameMode] == ModeBlaster) {
		m_lblLevel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:10*getScaleFactor()];
		m_lblTime = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:10*getScaleFactor()];
		m_lblRest = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:10*getScaleFactor()];
		m_lblScore = [CCLabelTTF labelWithString:@"" fontName:@"Imagica" fontSize:16*getScaleFactor()];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			m_lblLevel.position = ptLevelLabel;
			m_lblTime.position = ptTimeLabel;
			m_lblRest.position = ptRestLabel;
			m_lblScore.position = ptScoreLabel;
		} else {
			m_lblLevel.position = ptPadLevelLabel;
			m_lblTime.position = ptPadTimeLabel;
			m_lblRest.position = ptPadRestLabel;
			m_lblScore.position = ptPadScoreLabel;
		}
		m_lblLevel.color = ccYELLOW;
		m_lblTime.color = ccYELLOW;
		m_lblRest.color = ccYELLOW;
		m_lblScore.color = ccRED;
		m_lblScore.anchorPoint = ccp(0, 0.5);
		[self addChild:m_lblLevel];
		[self addChild:m_lblTime];
		[self addChild:m_lblRest];
		[self addChild:m_lblScore];
	}
	else {
		m_lblLevel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:10*getScaleFactor()];
		m_lblScore = [CCLabelTTF labelWithString:@"" fontName:@"Imagica" fontSize:16*getScaleFactor()];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			m_lblLevel.position = ptTimeLabel;
			m_lblScore.position = ptScoreLabel;
		} else {
			m_lblLevel.position = ptPadTimeLabel;
			m_lblScore.position = ptPadScoreLabel;
		}
		m_lblLevel.color = ccYELLOW;
		m_lblScore.color = ccRED;
		m_lblScore.anchorPoint = ccp(0, 0.5);
		[self addChild:m_lblLevel];
		[self addChild:m_lblScore];
		m_lblTime = nil;
		m_lblRest = nil;
	}    
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	m_lblReady = [CCLabelFX labelWithString:@"Ready" fontName:@"Imagica" fontSize:30*getScaleFactor() shadowOffset:CGSizeMake(2*getScaleFactor(), -2*getScaleFactor()) shadowBlur:1.0];
	[self addChild:m_lblReady];
	m_lblReady.color = ccORANGE;
	m_lblReady.opacity = 0;
	m_lblReady.position = ccp(size.width / 2, size.height / 2);
	
	m_lblGetStix = [CCLabelFX labelWithString:@"Get Stix" fontName:@"Imagica" fontSize:30*getScaleFactor() shadowOffset:CGSizeMake(2*getScaleFactor(), -2*getScaleFactor()) shadowBlur:1.0];
	[self addChild:m_lblGetStix];
	m_lblGetStix.color = ccORANGE;
	m_lblGetStix.opacity = 0;
	m_lblGetStix.position = ccp(size.width / 2, size.height / 2);
	
	m_lblGoBlast = [CCLabelFX labelWithString:@"Go Blast" fontName:@"Imagica" fontSize:30*getScaleFactor() shadowOffset:CGSizeMake(2*getScaleFactor(), -2*getScaleFactor()) shadowBlur:1.0];
	[self addChild:m_lblGoBlast];
	m_lblGoBlast.color = ccORANGE;
	m_lblGoBlast.opacity = 0;
	m_lblGoBlast.position = ccp(size.width / 2, size.height / 2);
}

-(void) drawButtons {
    m_btnSound = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSound) items:[CCMenuItemImage itemFromNormalImage:IS_IPAD(@"btn_sound_1-iPad.png", @"btn_sound_1.png") selectedImage:IS_IPAD(@"btn_sound_1-iPad.png", @"btn_sound_1.png")], [CCMenuItemImage itemFromNormalImage:IS_IPAD(@"btn_sound_2-iPad.png", @"btn_sound_2.png") selectedImage:IS_IPAD(@"btn_sound_2-iPad.png", @"btn_sound_2.png")], nil];
    m_btnSound.selectedIndex = ([AppSettings getBackgroundMusic] || [AppSettings getEffectMusic]);
    CCMenuItemImage *btnPause = [CCMenuItemImage itemFromNormalImage:IS_IPAD(@"btn_pause_1-iPad.png", @"btn_pause_1.png") selectedImage:IS_IPAD(@"btn_pause_2-iPad.png", @"btn_pause_2.png") target:self selector:@selector(onPause)];
    CCMenu *menu = [CCMenu menuWithItems:m_btnSound, btnPause, nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        menu.position = ptMenuPos;
    }
    else {
        menu.position = ptPadMenuPos;
    }
    [menu alignItemsHorizontallyWithPadding:20*getScaleFactor()];
    [self addChild:menu];
    
}

-(void) onSound {
    [AppSettings setBackgroundMusic:m_btnSound.selectedIndex];
    [AppSettings setEffectMusic:m_btnSound.selectedIndex];
	
	if (![AppSettings getBackgroundMusic]) {
		[m_soundManager setBackgroundMusicMute:YES];
		[m_soundManager setEffectMute:YES];
		
		[m_soundManager stopBackgroundMusic];
	}
	else {
		[m_soundManager setBackgroundMusicMute:NO];
		[m_soundManager setEffectMute:NO];
		
		[m_soundManager playBackgroundMusic:soundGameBGM];
	}
}

-(void) onPause {
	[m_soundManager playEffect:soundClickBtn bForce:YES];
	
    m_nPrevState = m_nGameState;
    m_nGameState = statePause;
    [self addChild:[PauseLayer node] z:TOP_LAYER];
}

-(void) onResume {
	[m_soundManager playEffect:soundClickBtn bForce:YES];
	
    m_nGameState = m_nPrevState;
}

-(void) onMainMenu {
	[m_soundManager playEffect:soundClickBtn bForce:YES];
	[m_soundManager stopBackgroundMusic];
	
    m_nGameState = m_nPrevState;
	[[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}

-(void) startGame {
    m_sprSlingShot.state = stateNone;

    m_gamedata.InitGameData(m_nLevel);
    [self resuffleAnimation];
}

- (void) checkAchievements
{
	NSString* identifier = NULL;
	double percentComplete = 0;
    
    int total_score = [AppSettings getScore];
    if (total_score >= 1000) {
        identifier= kAchievement1000Points;
        percentComplete= 100.0;
    }
	
	if(identifier!= NULL)
	{
		[m_pAppDelegate submitAchievement: identifier percentComplete: percentComplete];
	}
}

-(void) successGame {
    
    if ([m_pAppDelegate getGameMode] == ModeBlaster) {
		[m_pAppDelegate submitScore:[AppSettings getScore]];
        [self checkAchievements];
	}

    m_nGameState = stateSuccessAnimating;
    [self releasePointLabel];
	
	[m_soundManager playEffect:soundSuccess bForce:YES];
	
	m_nLevel++;
    if (m_nLevel >= MAX_LEVEL) {
        [self addChild:[GameFinishDlg node] z:TOP_LAYER];
		if ([m_pAppDelegate getGameMode] == ModeBumper) {
			if([AppSettings setScoreBumper:m_nScore]) {
				[m_pAppDelegate submitScore:m_nScore];
			}
		}
    }
	else {
		[AppSettings setStartLevel:m_nLevel];
		[self addChild:[LevelSuccessDlg node] z:TOP_LAYER];
	}
}

-(void) failGame {
	if ([m_pAppDelegate getGameMode] == ModeBumper) {
		if([AppSettings setScoreBumper:m_nScore]) {
			[m_pAppDelegate submitScore:m_nScore];
		}
	}
	
    m_nGameState = stateFailAnimating;
    [self releasePointLabel];
    [self addChild:[GameOverDlg node] z:TOP_LAYER];
	
	[m_soundManager playEffect:soundFail bForce:YES];
}

-(void) onLevelSuccess {
//    [self startGame];
	[self startLevelAnimation];
}

-(void) onGameOver {
//    [self startGame];
	[self startLevelAnimation];
}

-(void) drawGame {
    for (int y = 0; y < BOARD_HEIGHT; y++) {
        for (int x = 0; x < BOARD_WIDTH; x++) {
            [m_sprBird[y][x] redrawBird:m_gamedata.m_byBoard[y][x]];
        }
    }
}

- (void)printGame {
    CCLOG(@"printGame");
    NSString *str;
    for (int y = 0; y < BOARD_HEIGHT; y++) {
        str = @"";
        for (int x = 0; x < BOARD_WIDTH; x++) {
            str = [NSString stringWithFormat:@"%@ %d", str, m_gamedata.m_byBoard[y][x]];
        }
        str = [NSString stringWithFormat:@"%@\t", str];
        for (int x = 0; x < BOARD_WIDTH; x++) {
            str = [NSString stringWithFormat:@"%@ %d", str, [m_sprBird[y][x] getBirdNum]];
        }
        CCLOG(@"%@", str);
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//Add a new body/atlas sprite at the touched location
    if (m_nGameState != stateIdle) {
        return;
    }
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];		
		location = [[CCDirector sharedDirector] convertToGL: location];
        CGPoint pt = m_sprSlingShot.position;
        CGRect rt = CGRectMake(pt.x - m_nSlingShotWidth / 2, pt.y, m_nSlingShotWidth, m_nSlingShotHeight);
        if (CGRectContainsPoint(rt, location)) {
            if (m_sprSlingShot.state == stateNone) {
                m_sprSlingShot.state = stateLoad;
            } else if (m_sprSlingShot.state == stateLoad){
                m_sprSlingShot.state = stateStretch;
            }
            m_ptCurrentPos = location;
        }
        else {
            m_sprSlingShot.state = stateNone;
            m_ptCurrentPos = ccp(0, 0);
        }
	}
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (m_nGameState != stateIdle) {
        return;
    }
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];		
		location = [[CCDirector sharedDirector] convertToGL: location];
        if (m_sprSlingShot.state == stateLoad) {
            CGPoint ptOff = ccpSub(location, m_ptCurrentPos);
            CGPoint pt = m_sprSlingShot.position;
            m_sprSlingShot.position = ccpAdd(pt, ccp(ptOff.x, 0));
            pt = m_sprArrow.position;
            pt.x += ptOff.x;
            pt.y += ptOff.y * m_fRatio;
            if (pt.y >= m_ptBoardStartPos.y) {
                pt.y = m_ptBoardStartPos.y;
            }
            if (pt.y < m_ptBoardStartPos.y - m_nCellHeight * (BOARD_HEIGHT - 1)) {
                pt.y = m_ptBoardStartPos.y - m_nCellHeight * (BOARD_HEIGHT - 1);
            }
            m_sprArrow.position = pt;
            m_ptCurrentPos = location;
        }
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (m_nGameState != stateIdle) {
        return;
    }
    
    [self printGame];
	
    //Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];		
		location = [[CCDirector sharedDirector] convertToGL: location];
        if (m_sprSlingShot.state == stateStretch) {
            m_sprSlingShot.state = stateNone;            
            m_ptCurrentPos = ccp(0, 0);
            [self throwStoneAnimation];
        }
	}
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	if (m_pTimerBar) {
		[m_pTimerBar release];
	}
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark game  update 

- (void) update:(ccTime) dt {
    switch (m_nGameState) {
        case stateIdle:
        {
			if ([m_pAppDelegate getGameMode] == ModeBumper) {
				if (m_GameTime >= g_LevelInfo[m_nLevel].fLevelTime) {
					m_gamedata.m_nShotBirdCount = 0;
					[self successGame];
					return;
				}
				m_GameTime -= dt * 2;
			}
			else {
				m_GameTime -= dt;
			}

            
			if (m_lblTime) {
				int time = m_GameTime;
				m_lblTime.string = [NSString stringWithFormat:@"Time : %d", time];
			}            
            if (m_GameTime <= 0) {
                [self failGame];
            }
            
            m_Duaration = 0;
        }
            break;
        case stateThrowing:
        {
            if (m_Duaration > THROW_ANI_DURATION + 0.1f) {
                m_nGameState = stateThrowCompleted;
                m_Duaration = 0;
            }
        }
            break;
        case stateThrowCompleted:
        {
            m_sprStone.visible = NO;
            
            CGPoint pt = m_sprArrow.position;
            int x = (pt.x - m_ptBoardStartPos.x + m_nCellWidth / 2) / m_nCellWidth;
            int y = (m_ptBoardStartPos.y - pt.y + m_nCellHeight / 2) / m_nCellHeight;
            m_nShotBird = m_gamedata.m_byBoard[y][x];
            if (m_gamedata.Shoot(x, y) != 0) {
                [self removeBirdsAnimation];  
                [self bonusAnimation];
                if (m_nShotBird == SILVER_BIRD) {
                    [self earnTimeAnimation];
                }
            }
            else {
                m_nShotBird = EMPTY_BIRD;
                m_nGameState = stateIdle;
            }
        }
            break;
        case stateRemoving:
        {
            if (m_Duaration > REMOVE_ANI_DURATION + 0.1f) {
                m_nGameState = stateRemoveCompleted;
                m_Duaration = 0;
            }
        }
            break;
        case stateRemoveCompleted:
        {
			if (m_lblRest) {
				int rest = g_LevelInfo[m_nLevel].nGoal - m_gamedata.m_nShotBirdCount;
				if (rest < 0) {
					rest = 0;
				}
				m_lblRest.string = [NSString stringWithFormat:@"Rest : %d", rest];
			}
			if ([m_pAppDelegate getGameMode] == ModeBlaster) {
				int score = [AppSettings getScore];
				score += m_gamedata.m_nRemoveBirdCount;
				[AppSettings setScore:score];
				m_lblScore.string = [NSString stringWithFormat:@"Score : %d", score];
			}
            else {
				m_nScore += m_gamedata.m_nRemoveBirdCount;
				m_lblScore.string = [NSString stringWithFormat:@"Score : %d", m_nScore];
				[AppSettings setScoreBumper:m_nScore];
			}

            [self moveBirdsAnimation];
			
			if ([m_pAppDelegate getGameMode] == ModeBumper) {
				m_GameTime += m_gamedata.m_nRemoveBirdCount * BUMPER_TIME;
			}
        }
            break;
        case stateMoving:
        {
            if (m_Duaration > MOVE_ANI_DURATION * m_nMaxStep + 0.1f) {
                m_nGameState = stateMoveCompleted;
                m_Duaration = 0;
            }
        }
            break;
        case stateMoveCompleted:
        {
            m_sprSlingShot.state = stateNone;
			if ([m_pAppDelegate getGameMode] == ModeBlaster) {
				if (m_gamedata.IsLevelClear()) {
					[self successGame];
					return;
				}
			}
			
            if (m_nShotBird == BRONZE_BIRD) {
                [self resuffleAnimation];
                m_nShotBird = EMPTY_BIRD;
                return;
            }
            
            if (m_nShotBird == SILVER_BIRD) {
                m_GameTime += g_LevelInfo[m_nLevel].fLevelBonusTime;
				if (m_lblTime) {
					int time = m_GameTime;
					m_lblTime.string = [NSString stringWithFormat:@"Time : %d", time];
				}                
                m_nShotBird = EMPTY_BIRD;
            }
            
            if (!m_gamedata.IsThereThreeFlock()) {
                m_gamedata.ReShuffle();
                [self resuffleAnimation];
            }
            else{
                m_nGameState = stateIdle;
            }
        }
            break;
        case stateResuffling:
        {
            if (m_Duaration > MOVE_ANI_DURATION * m_nMaxStep + 0.1f) {
                m_nGameState = stateResuffleCompleted;
                m_Duaration = 0;
            }
        }
            break;
        case stateResuffleCompleted:
        {
            m_nGameState = stateIdle;
        }
            break;
        default:
            break;
    }
	if (m_pTimerBar) {
		[m_pTimerBar onTimer:m_GameTime levelTime:g_LevelInfo[m_nLevel].fLevelTime];
	}
    m_Duaration += dt;
}

#pragma mark animation methods

-(void) throwStoneAnimation {
	[m_soundManager playEffect:soundShoot bForce:YES];
	
    m_sprStone.position = ccpAdd(m_sprSlingShot.position, ccp(-6, 54));
    m_sprStone.visible = YES;
    
    CGPoint pt = m_sprArrow.position;
    int x = (pt.x - m_ptBoardStartPos.x + m_nCellWidth / 2) / m_nCellWidth;
    int y = (m_ptBoardStartPos.y - pt.y + m_nCellHeight / 2) / m_nCellHeight;
    pt = [self getBirdsPosition:x posY:y];
	id move = [CCMoveTo actionWithDuration:THROW_ANI_DURATION position:pt];
	[m_sprStone runAction:move];
    
    m_nGameState = stateThrowing;
}

-(void) removeBirdsAnimation {
	[m_soundManager playEffect:soundDead bForce:YES];
	
    for (int i = 0; i < m_gamedata.m_nRemoveBirdCount; i++) {
        int x = m_gamedata.m_RemoveBirds[i].nPosX;
        int y = m_gamedata.m_RemoveBirds[i].nPosY;
        BirdSprite* sprRemoveBirds = m_sprBird[y][x];
        [sprRemoveBirds removeAnimation];
    }
    m_nGameState = stateRemoving;
}

-(void) moveBirdsAnimation {
    m_nMaxStep = 0;
    
    for (int i = 0; i < m_gamedata.m_nMoveBirdCount; i++) {
        int x = m_gamedata.m_MoveBirds[i].nPosX;
        int y = m_gamedata.m_MoveBirds[i].nPosY;
        int originX = m_gamedata.m_MoveBirds[i].nOrgPosX;
        int originY = m_gamedata.m_MoveBirds[i].nOrgPosY;
        int nStep = m_gamedata.m_MoveBirds[i].nMoveStep;
        if (m_nMaxStep < nStep) {
			m_nMaxStep = nStep;
		}
        
        if (originY != -1) {
            BirdSprite * spr = m_sprBird[originY][originX];
            m_sprBird[originY][originX] = m_sprBird[y][x];
            m_sprBird[y][x] = spr;
                    
            CGPoint ptToPos = [self getBirdsPosition:x posY:y];
            [m_sprBird[y][x] MoveToDown:ptToPos nSteps:nStep nDelay:0];
        }
        else {
            NSLog(@"top");
            BirdSprite * spr = m_sprBird[y][x];
            CGPoint ptPos = [self getBirdsPosition:x posY:0];
            [spr setPosition:ccpAdd(ptPos, ccp(0, m_nCellHeight * nStep))];
            
            [spr refreshTexture:m_gamedata.m_byBoard[y][x] bEffect:NO];
            
            [spr MoveToDown:[self getBirdsPosition:x posY:y] nSteps:nStep nDelay:0];
        }
    }
    
    m_nGameState = stateMoving;
}

-(void) resuffleAnimation {
    m_nGameState = stateResuffling;
    
    if (m_nShotBird == BRONZE_BIRD) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelFX labelWithString:@"Reshuffle" fontName:@"Imagica" fontSize:30*getScaleFactor() shadowOffset:CGSizeMake(2*getScaleFactor(), -2*getScaleFactor()) shadowBlur:1.0];
        [self addChild:label z:1 tag:kTagPointLabel + m_nPointLabelCount];
        m_nPointLabelCount++;
        label.color = ccORANGE;
        label.position = ccp(size.width / 2, size.height / 2);
        
        id scale1 = [CCScaleTo actionWithDuration:0.3f scale:2];
        id scale2 = [CCScaleTo actionWithDuration:0.3f scale:1];
        id fadeout = [CCFadeOut actionWithDuration:0.3f];
        id action = [CCSequence actions:scale1, scale2, fadeout, nil];
        [label runAction:action];
    }

    m_nMaxStep = BOARD_HEIGHT;
    for (int y = BOARD_HEIGHT - 1; y >= 0; y--) {
        for (int x = 0; x < BOARD_WIDTH; x++) {
            NSLog(@"top");
            BirdSprite * spr = m_sprBird[y][x];
            CGPoint ptPos = [self getBirdsPosition:x posY:0];
            [spr setVisible:YES];
            [spr setPosition:ccpAdd(ptPos, ccp(0, m_nCellHeight * BOARD_HEIGHT))];
            [spr refreshTexture:m_gamedata.m_byBoard[y][x] bEffect:NO];
            [spr MoveToDownWithDelay:[self getBirdsPosition:x posY:y] nSteps:BOARD_HEIGHT fDelay:0.14 * (BOARD_HEIGHT - y)];
        }
    }
}
         
-(void)	bonusAnimation {
    for (int i = 0; i < m_gamedata.m_nRemoveBirdCount; i++) {
        int x = m_gamedata.m_RemoveBirds[i].nPosX;
        int y = m_gamedata.m_RemoveBirds[i].nPosY;
        BirdSprite* sprRemoveBirds = m_sprBird[y][x];
        
        CCLabelTTF * label = [CCLabelFX labelWithString:@"+1" fontName:@"Imagica" fontSize:20*getScaleFactor() shadowOffset:CGSizeMake(2*getScaleFactor(), -2*getScaleFactor()) shadowBlur:1.0];
        [self addChild:label z:1 tag:kTagPointLabel + m_nPointLabelCount];
        
        m_nPointLabelCount++;
        if (m_nShotBird == GOLD_BIRD) {
            label.color = ccYELLOW;
        }
        else {
            label.color = ccRED;
        }
        label.position = sprRemoveBirds.position;
        
        CGPoint ptDest = ccpAdd(sprRemoveBirds.position, ccp(0, 30*getScaleFactor()));
        id move = [CCMoveTo actionWithDuration:0.7f position:ptDest];
        id fadeout = [CCFadeOut actionWithDuration:0.3f];
        id action = [CCSequence actions:move, fadeout, nil];
        [label runAction:action];
    }
}

-(void)	earnTimeAnimation {
    // ask director the the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCLabelTTF * label = [CCLabelFX labelWithString:[NSString stringWithFormat:@"Time +%.0f", g_LevelInfo[m_nLevel].fLevelBonusTime] fontName:@"Imagica" fontSize:30*getScaleFactor() shadowOffset:CGSizeMake(2*getScaleFactor(), -2*getScaleFactor()) shadowBlur:1.0];
    [self addChild:label z:1 tag:kTagPointLabel + m_nPointLabelCount];
    m_nPointLabelCount++;
    label.color = ccc3(200, 200, 200);
    label.position = ccp(size.width / 2, size.height / 2);
    
    id scale1 = [CCScaleTo actionWithDuration:0.3f scale:2];
    id scale2 = [CCScaleTo actionWithDuration:0.3f scale:1];
    id fadeout = [CCFadeOut actionWithDuration:0.3f];
    id action = [CCSequence actions:scale1, scale2, fadeout, nil];
    [label runAction:action];
}

-(void) startLevelAnimation {
	m_nMaxStep = BOARD_HEIGHT;
    for (int y = BOARD_HEIGHT - 1; y >= 0; y--) {
        for (int x = 0; x < BOARD_WIDTH; x++) {
            BirdSprite * spr = m_sprBird[y][x];
            CGPoint ptPos = [self getBirdsPosition:x posY:0];
            [spr setVisible:YES];
            [spr setPosition:ccpAdd(ptPos, ccp(0, m_nCellHeight * BOARD_HEIGHT))];
		}
    }
	
	m_nLevel = [AppSettings getStartLevel];
//	if (m_nLevel == 0) {
//		m_nScore = 0;
//	}
	
	m_nScore = [AppSettings getScoreBumper];
	
    m_lblLevel.string = [NSString stringWithFormat:@"Level : %d", m_nLevel+1];
	
	if ([m_pAppDelegate getGameMode] == ModeBlaster) {
		m_GameTime = g_LevelInfo[m_nLevel].fLevelTime;
		m_lblScore.string = [NSString stringWithFormat:@"Score : %d", [AppSettings getScore]];
	}
	else if ([m_pAppDelegate getGameMode] == ModeBumper) {
		m_GameTime = g_LevelInfo[m_nLevel].fLevelTime / 4;
		m_lblScore.string = [NSString stringWithFormat:@"Score : %d", m_nScore];
		[m_pTimerBar onTimer:m_GameTime levelTime:g_LevelInfo[m_nLevel].fLevelTime];
	}
	
	if (m_lblRest) {
		int time = m_GameTime;
		m_lblTime.string = [NSString stringWithFormat:@"Time : %d", time];
		m_lblRest.string = [NSString stringWithFormat:@"Rest : %d", g_LevelInfo[m_nLevel].nGoal];
	}

	id action1 = [CCSequence actions:[CCDelayTime actionWithDuration:1.0f]
				  , [CCFadeIn actionWithDuration:0.0f]
				  , [CCScaleTo actionWithDuration:0.3f scale:2]
				  , [CCScaleTo actionWithDuration:0.3f scale:1]
				  , [CCFadeOut actionWithDuration:0.3f], nil];
	[m_lblReady runAction:action1];
	
	id action2 = [CCSequence actions:[CCDelayTime actionWithDuration:2.0f]
				  , [CCFadeIn actionWithDuration:0.0f]
				  , [CCScaleTo actionWithDuration:0.3f scale:2]
				  , [CCScaleTo actionWithDuration:0.3f scale:1]
				  , [CCFadeOut actionWithDuration:0.3f], nil];
	[m_lblGetStix runAction:action2];
	
	id action3 = [CCSequence actions:[CCDelayTime actionWithDuration:3.0f]
				  , [CCFadeIn actionWithDuration:0.0f]
				  , [CCScaleTo actionWithDuration:0.3f scale:2]
				  , [CCScaleTo actionWithDuration:0.3f scale:1]
				  , [CCFadeOut actionWithDuration:0.3f]
				  , [CCCallFunc actionWithTarget:self selector:@selector(startGame)], nil];
	[m_lblGoBlast runAction:action3];
	m_nGameState = stateStartAnimating;
}

-(CGPoint) getBirdsPosition:(int)nPosX posY:(int)nPosY {
    CGPoint pt = ccpAdd(m_ptBoardStartPos, ccp(m_nCellWidth * nPosX, -m_nCellHeight * nPosY));
    return pt;
}

-(void)	releasePointLabel {
	for (int i = 0; i < m_nPointLabelCount; i++) {
		CCNode * node = [self getChildByTag:kTagPointLabel + i];
		if (node) {
			[node removeFromParentAndCleanup:YES];
		}
	}
	m_nPointLabelCount = 0;
}

@end

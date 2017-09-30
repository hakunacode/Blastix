//
//  GameLayer.h
//  Blastix
//
//  Created by admin on 4/6/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#include "GameData.h"
#import "BirdSprite.h"
#import "SlingShotSprite.h"
#import "SoundManager.h"
#import "Timebar.h"
#import "AppDelegate.h"

enum UIState {
	stateStartAnimating = 999,
	stateIdle = 1000,
	stateThrowing,
	stateThrowCompleted,
	stateRemoving,
	stateRemoveCompleted,
	stateMoving,
	stateMoveCompleted,
	stateResuffling,
	stateResuffleCompleted,
    
    statePause,
	
	stateSuccessAnimating,
	stateFailAnimating,
	stateGameCompleted,
	stateDisplayResult,
};

// GameLayer
@interface GameLayer : CCLayer
{
	SoundManager*		m_soundManager;
	AppDelegate*		m_pAppDelegate;
	
    GameData    m_gamedata;
    
    BirdSprite*         m_sprBird[BOARD_HEIGHT][BOARD_WIDTH];
    SlingShotSprite*    m_sprSlingShot;
    CCSprite*           m_sprStone;
    CCSprite*           m_sprArrow;
    
	CCSprite*			m_sprBack;
	
    CCLabelTTF*         m_lblLevel;
    CCLabelTTF*         m_lblTime;
    CCLabelTTF*         m_lblRest;
    CCLabelTTF*         m_lblScore;
    
    CCMenuItemToggle*   m_btnSound;
    
    int         m_nCellWidth, m_nCellHeight;
    int         m_nSlingShotWidth, m_nSlingShotHeight;
    float       m_fRatio;
    CGPoint     m_ptBoardStartPos;
    CGPoint     m_ptCurrentPos;
    
    UIState     m_nGameState;
    UIState     m_nPrevState;
    
    double      m_Duaration;
    int         m_nMaxStep;
    
    int         m_nLevel;
    int         m_nShotBird;
    double      m_GameTime;
    
    int         m_nPointLabelCount;
	Timebar*	m_pTimerBar;
	
	int			m_nScore;
	
	CCLabelTTF*			m_lblReady;
	CCLabelTTF*			m_lblGetStix;
	CCLabelTTF*			m_lblGoBlast;
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

-(void) onResume;
-(void) onMainMenu;
-(void) onLevelSuccess;
-(void) onGameOver;

@end

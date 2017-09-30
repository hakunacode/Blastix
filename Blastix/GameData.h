//
//  GameData.h
//  Blastix
//
//  Created by admin on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Blastix_GameData_h
#define Blastix_GameData_h

#define BIRD_KIND           10
#define GOLD_BIRD           7
#define SILVER_BIRD         8
#define BRONZE_BIRD         9
#define EMPTY_BIRD          100

#define BOARD_WIDTH         8
#define BOARD_HEIGHT        6

#define MAX_LEVEL           5

struct Level
{
	int		nTypeNum;
	int		nItemCount;
    
	float	fGoldRate;
	float	fSilverRate;
	float	fBronzeRate;

	float	fLevelTime;
    
	int		nGoal;
	float	fLevelBonusTime;
	//BumperMode
//	float   fRemoveBonusTime;
//	float	fBumperLevelTime;
};

struct Bird {
    int     nOrgPosX;
    int     nOrgPosY;
    
    int     nPosX;
    int     nPosY;
    
    int     nMoveStep;
    
    Bird() {
        nOrgPosX = -1;
        nOrgPosY = -1;
        
        nPosX = -1;
        nPosY = -1;
        nMoveStep = 0;
    }
};

class GameData {
public:
    GameData();
    ~GameData();
    
    void    InitGameData(int nLevel);
    
    bool    IsLevelClear();
    bool    IsThereThreeFlock();
    
    int     Shoot(int x, int y);
    void    ReShuffle();
        
    uint8_t m_byBoard[BOARD_HEIGHT][BOARD_WIDTH];
    int8_t  m_byFlockBoard[BOARD_HEIGHT][BOARD_WIDTH];
    
    int     m_nRemoveBirdCount;
    Bird    m_RemoveBirds[BOARD_HEIGHT * BOARD_WIDTH];
    
    int     m_nMoveBirdCount;
    Bird    m_MoveBirds[BOARD_HEIGHT * BOARD_WIDTH];
    
    int     m_nLevel;
    int     m_nShotBirdCount;
    
private:
    void    initBoard();
    
    void    removeAllSameBirds(int x, int y);
    void    removeBirds(int x, int y);
    void    moveBirds(int x, int y);
    void    refreshFlock();
    
    uint32_t getSameDirection(int x, int y);
    void    markSameColor(int x, int y, int num);
    
    int     generateBird(bool bItem = true);
};

#endif

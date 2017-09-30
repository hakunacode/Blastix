//
//  GameData.cpp
//  Blastix
//
//  Created by admin on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>
#include "GameData.h"

#define ITEM_GENERATE_RATE	150

Level	g_LevelInfo[] = {
	{5, 0, 0.0f, 0.0f, 0.0f, 120, 60,  15},
	{6, 3, 0.0f, 0.0f, 1.0f, 115, 70,  15},
	{6, 6, 0.0f, 0.0f,  1.0f, 95, 110, 12},
	{7, 9, 0.0f, 0.0f, 1.0f, 90, 120, 12},
	{7, 12, 0.0f, 0.0f,  1.0f,  75, 150, 12},
};


GameData::GameData()
{
    for (int i = 0; i < BOARD_HEIGHT; i++) {
        for (int j = 0; j < BOARD_WIDTH; j++) {
            m_byBoard[i][j] = 0;
            m_byFlockBoard[i][j] = -1;
        }
    }
}

GameData::~GameData()
{
    
}

void GameData::InitGameData(int nLevel)
{
    m_nLevel = nLevel;
    m_nShotBirdCount = 0;
    
    initBoard();
    refreshFlock();
}

void GameData::initBoard()
{
    srand(time(NULL));
    do {
        for (int y = 0; y < BOARD_HEIGHT; y++) {
            for (int x = 0; x < BOARD_WIDTH; x++) {
                m_byBoard[y][x] = generateBird();
            }
        }
        refreshFlock();
    } while (!IsThereThreeFlock());
}

void GameData::refreshFlock()
{
    // init flockboard
    for (int y = 0; y < BOARD_HEIGHT; y++) {
        for (int x = 0; x < BOARD_WIDTH; x++) {
            m_byFlockBoard[y][x] = -1;
        }
    }
    
    // mark flockboard
    int num = 0;
    for (int y = 0; y < BOARD_HEIGHT; y++) {
        for (int x = 0; x < BOARD_WIDTH; x++) {
            uint32_t arrow = getSameDirection(x, y);
            if (arrow == 0) {
                continue;
            }
            if (m_byFlockBoard[y][x] != -1) {
                continue;
            }
            num++;
            markSameColor(x, y, num);      
        }
    }
    
    // mark three flockboard
    int count;
    for (int y = 0; y < BOARD_HEIGHT; y++) {
        for (int x = 0; x < BOARD_WIDTH; x++) {
            if (m_byFlockBoard[y][x] == -1) {
                continue;
            }
            
            num = m_byFlockBoard[y][x];
            count = 0;
            for (int y1 = 0; y1 < BOARD_HEIGHT; y1++) {
                for (int x1 = 0; x1 < BOARD_WIDTH; x1++) {
                    if (m_byFlockBoard[y1][x1] == num)
                        count++;
                }
            }
            if (count < 3) {
                for (int y1 = 0; y1 < BOARD_HEIGHT; y1++) {
                    for (int x1 = 0; x1 < BOARD_WIDTH; x1++) {
                        if (m_byFlockBoard[y1][x1] == num)
                            m_byFlockBoard[y1][x1] = -1;
                    }
                }
            }
        }
    }
}

void GameData::markSameColor(int x, int y, int num)
{
    uint32_t arrow = getSameDirection(x, y);
    if (arrow == 0) {
        return;
    }
    
    m_byFlockBoard[y][x] = num;
    if ((arrow & 0x0001) && (m_byFlockBoard[y][x+1] == -1)) { // left
        if (getSameDirection(x+1, y)) {
            markSameColor(x+1, y, num);
        }
        m_byFlockBoard[y][x+1] = num;
    }
    if ((arrow & 0x0010) && (m_byFlockBoard[y+1][x] == -1)) { // down
        if (getSameDirection(x, y+1)) {
            markSameColor(x, y+1, num);
        }
        m_byFlockBoard[y+1][x] = num;
    }
    if ((arrow & 0x0100) && (m_byFlockBoard[y][x-1] == -1)) { // right
        if (getSameDirection(x-1, y)) {
            markSameColor(x-1, y, num);
        }
        m_byFlockBoard[y][x-1] = num;
    }
    if ((arrow & 0x1000) && (m_byFlockBoard[y-1][x] == -1)) { // up
        if (getSameDirection(x, y-1)) {
            markSameColor(x, y-1, num);
        }
        m_byFlockBoard[y-1][x] = num;
    }
}

void GameData::removeAllSameBirds(int x, int y)
{
    m_nRemoveBirdCount = 0;
    
    m_byBoard[y][x] = EMPTY_BIRD;
    m_RemoveBirds[m_nRemoveBirdCount].nPosX = x;
    m_RemoveBirds[m_nRemoveBirdCount].nPosY = y;
    m_nRemoveBirdCount++;
    
    for (int y1 = 0; y1 < BOARD_HEIGHT; y1++) {
        for (int x1 = 0; x1 < BOARD_WIDTH; x1++) {
            if (m_byFlockBoard[y1][x1] != -1) {
                m_byBoard[y1][x1] = EMPTY_BIRD;
                m_RemoveBirds[m_nRemoveBirdCount].nPosX = x1;
                m_RemoveBirds[m_nRemoveBirdCount].nPosY = y1;
                m_nRemoveBirdCount++;
            }
        }
    }
    m_nShotBirdCount += m_nRemoveBirdCount;
}


void GameData::removeBirds(int x, int y) {
    m_nRemoveBirdCount = 0;
    
    int nBird = m_byBoard[y][x];
    
    if (nBird == GOLD_BIRD) {
        removeAllSameBirds(x, y);
        return;
    }

    int num = m_byFlockBoard[y][x];
    if (num == -1) {
        if (nBird < GOLD_BIRD) {        // general bird
            return;
        }
        
        // silver, bronze bird
        m_byBoard[y][x] = EMPTY_BIRD;
        m_RemoveBirds[m_nRemoveBirdCount].nPosX = x;
        m_RemoveBirds[m_nRemoveBirdCount].nPosY = y;
        m_nRemoveBirdCount++;
        return;
    }
    
    for (int y1 = 0; y1 < BOARD_HEIGHT; y1++) {
        for (int x1 = 0; x1 < BOARD_WIDTH; x1++) {
            if (m_byFlockBoard[y1][x1] == num) {
                m_byBoard[y1][x1] = EMPTY_BIRD;
                m_RemoveBirds[m_nRemoveBirdCount].nPosX = x1;
                m_RemoveBirds[m_nRemoveBirdCount].nPosY = y1;
                m_nRemoveBirdCount++;
            }
        }
    }
    
    m_nShotBirdCount += m_nRemoveBirdCount;
}

void GameData::moveBirds(int x, int y) {
    m_nMoveBirdCount = 0;
    int x1, y1;
	for (x1 = 0; x1 < BOARD_WIDTH; x1++)
	{
		for (y1 = BOARD_HEIGHT - 1; y1 >= 0; y1--)
		{
			if (m_byBoard[y1][x1] == EMPTY_BIRD)
			{
				for ( int y2 = y1 - 1; y2 >= 0; y2--)
				{
					if (m_byBoard[y2][x1] != EMPTY_BIRD)
					{
						m_byBoard[y1][x1] = m_byBoard[y2][x1];
						m_byBoard[y2][x1] = EMPTY_BIRD;
                        
                        m_MoveBirds[m_nMoveBirdCount].nPosX = x1;
                        m_MoveBirds[m_nMoveBirdCount].nPosY = y1;
                        m_MoveBirds[m_nMoveBirdCount].nOrgPosX = x1;
                        m_MoveBirds[m_nMoveBirdCount].nOrgPosY = y2;
                        m_MoveBirds[m_nMoveBirdCount].nMoveStep = y1 - y2;
                        m_nMoveBirdCount++;
						break;
					}
				}
			}
		}
		
		int nStep = 0;
		for (y1 = BOARD_HEIGHT - 1; y1 >= 0; y1--)
		{
			if (m_byBoard[y1][x1] == EMPTY_BIRD)
			{
				if (nStep == 0) {
					nStep = y1 + 1;
				}
				m_byBoard[y1][x1] = generateBird();
                
                m_MoveBirds[m_nMoveBirdCount].nPosX = x1;
                m_MoveBirds[m_nMoveBirdCount].nPosY = y1;
                m_MoveBirds[m_nMoveBirdCount].nOrgPosX = x1;
                m_MoveBirds[m_nMoveBirdCount].nOrgPosY = -1;
                m_MoveBirds[m_nMoveBirdCount].nMoveStep = nStep;
                m_nMoveBirdCount++;				
			}
		}
	}
	//m_nEngineState = stateUpdate;
}

int GameData::Shoot(int x, int y)
{
    removeBirds(x, y);
    moveBirds(x, y);
    refreshFlock();
    return m_nRemoveBirdCount;
}

void GameData::ReShuffle()
{
    initBoard();
    refreshFlock();
}

bool GameData::IsLevelClear()
{
	if (m_nShotBirdCount >= g_LevelInfo[m_nLevel].nGoal) {
		m_nShotBirdCount = 0;
		return true;
	}
	return false;
}

bool GameData::IsThereThreeFlock()
{
    for (int y = 0; y < BOARD_HEIGHT; y++) {
        for (int x = 0; x < BOARD_WIDTH; x++) {
            if (m_byFlockBoard[y][x] != -1) {
                return true;
            }
        }
    }
    return false;
}

uint32_t GameData::getSameDirection(int x, int y)
{
    uint32_t arrow = 0;
    if (x < BOARD_WIDTH - 1 && m_byBoard[y][x] == m_byBoard[y][x + 1]) {    // left
        arrow |= 0x0001;
    }
    if (y < BOARD_HEIGHT - 1 && m_byBoard[y][x] == m_byBoard[y + 1][x]) {   // down
        arrow |= 0x0010;
    }
    if (x > 0 && m_byBoard[y][x] == m_byBoard[y][x - 1]) {                  // right
        arrow |= 0x0100;
    }
    if (y > 0 && m_byBoard[y][x] == m_byBoard[y - 1][x]) {                  // up
        arrow |= 0x1000;
    }
    return arrow;
}

int	GameData::generateBird(bool bItem)
{
	int n = rand() % 65536;
	if (bItem && n < ITEM_GENERATE_RATE * g_LevelInfo[m_nLevel].nItemCount)
	{
		float fRate = (rand() % 65536) / 65536.0f;
 		if (fRate <= g_LevelInfo[m_nLevel].fGoldRate)
			return GOLD_BIRD;
		if (fRate <= g_LevelInfo[m_nLevel].fSilverRate)
			return SILVER_BIRD;
		if (fRate <= g_LevelInfo[m_nLevel].fBronzeRate)
			return BRONZE_BIRD;
	}
    
	return abs(rand()) % g_LevelInfo[m_nLevel].nTypeNum;
}


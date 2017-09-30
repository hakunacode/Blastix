/*
 *  BBTimer.h
 *  tarzanGame
 *
 *  Created by KCU on 5/30/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef BBTIMER_H
#define BBTIMER_H

enum TIMER
{
	TIMER_NONE = -1,
	TIMER0,
	TIMER1,
	TIMER2,
	TIMER_COUNT
};

class BBTimer
{
public:
	BBTimer();
	virtual ~BBTimer();
	
public:
	BOOL CallTimerFunc();
	void SetTimer(TIMER nTimerID, unsigned long lInterval, BOOL bRepeat = YES);
	void StopTimer();
	
	TIMER GetTimerID() { return m_nTimerID; }
	void SetInterval(unsigned long lInterval) { m_lInterval = lInterval; }
private:
	unsigned long GetCurrentTime();
	
private:
	TIMER m_nTimerID;
	BOOL m_bRepeat;
	unsigned long m_lInterval;
	unsigned long m_lStartTime;
	unsigned long m_lEndTime;
};

#endif
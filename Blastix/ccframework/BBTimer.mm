/*
 *  BBTimer.cpp
 *  tarzanGame
 *
 *  Created by KCU on 5/30/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "BBTimer.h"
#include <sys/time.h>

BBTimer::BBTimer()
{
	m_bRepeat = YES;
	m_nTimerID = TIMER_NONE;
}

BBTimer::~BBTimer()
{
}

unsigned long BBTimer::GetCurrentTime()
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	unsigned long ms = tv.tv_sec * 1000L + tv.tv_usec / 1000L;
	return ms;
}

BOOL BBTimer::CallTimerFunc()
{
	if (m_nTimerID == TIMER_NONE)
		return NO;
	
	unsigned long lDiff = GetCurrentTime() - m_lStartTime;
	if (lDiff >= m_lInterval)
	{
		m_lStartTime = GetCurrentTime();
		if (!m_bRepeat)
			StopTimer();
		return YES;
	}
	
	return NO;
}

void BBTimer::SetTimer(TIMER nTimerID, unsigned long lInterval, BOOL bRepeat)
{
	if (m_nTimerID != TIMER_NONE)
		return;
	
	m_nTimerID	= nTimerID;
	m_lInterval = lInterval;
	m_bRepeat	= bRepeat;
	m_lStartTime = GetCurrentTime();
}

void BBTimer::StopTimer()
{
	m_nTimerID = TIMER_NONE;
}
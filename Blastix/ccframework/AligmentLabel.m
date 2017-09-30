//
//  AligmentLabel.m
//  FreeMagicTricks
//
//  Created by admin on 2/22/12.
//  Copyright 2012 _OSD Center_. All rights reserved.
//

#import "AligmentLabel.h"


@implementation AligmentLabel

- (void) setAligment: (CCTextAlignment) align
{
    m_alignment = align;
}

- (void) setString:(NSString*)str
{
	[string_ release];
	string_ = [str copy];
    
	CCTexture2D *tex;
    
	if( CGSizeEqualToSize( dimensions_, CGSizeZero ) )
		tex = [[CCTexture2D alloc] initWithString:str
										 fontName:fontName_
										 fontSize:fontSize_];
	else
		tex = [[CCTexture2D alloc] initWithString:str
									   dimensions:dimensions_
										alignment:m_alignment
										 fontName:fontName_
										 fontSize:fontSize_];
    
	[self setTexture:tex];
	[tex release];
    
	CGRect rect = CGRectZero;
	rect.size = [texture_ contentSize];
	[self setTextureRect: rect];
}


@end

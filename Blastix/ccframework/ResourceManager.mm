//
//  ResourceManager.m
//  glideGame
//
//  Created by KCU on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager.h"
#include <mach/mach.h>
#include <mach/machine.h>
@implementation ResourceManager
@synthesize font;
@synthesize font30;
@synthesize shadowFont;

static ResourceManager *_sharedResource = nil;

+ (ResourceManager*) sharedResourceManager 
{
	if (!_sharedResource) 
	{
		_sharedResource = [[ResourceManager alloc] init];
	}
	
	return _sharedResource;
}

+ (void) releaseResourceManager 
{
	if (_sharedResource) 
	{
		[_sharedResource release];
		_sharedResource = nil;
	}
}

- (id) init
{
	if ( (self=[super init]) )
	{
	}
	
	return self;
}

- (void) loadLoadingData 
{	
}

- (void) print_memory_size { 
	mach_port_t host_port; 
	mach_msg_type_number_t host_size; 
	vm_size_t pagesize; 
    
	host_port = mach_host_self(); 
	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t); 
	host_page_size(host_port, &pagesize);         
	
	vm_statistics_data_t vm_stat; 
	
	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) 
		NSLog(@"Failed to fetch vm statistics"); 
	
	/* Stats in bytes */ 
	natural_t mem_used = (vm_stat.active_count + 
						  vm_stat.inactive_count + 
						  vm_stat.wire_count) * pagesize; 
	natural_t mem_free = vm_stat.free_count * pagesize; 
	natural_t mem_total = mem_used + mem_free; 
	NSLog(@"used: %d free: %d total: %d", mem_used, mem_free, mem_total); 
} 

- (void) loadData
{	
	CCDirector* director = [CCDirector sharedDirector];
	if([director enableRetinaDisplay:YES]) {
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"menu@2x.plist"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game@2x.plist"];
		
	} else {
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:SHImageString(@"res1", @"plist")];
		//[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:SHImageString(@"game", @"plist")];
	}

	//	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tex1.plist"];
//	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tex3.plist"];
//	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tex10.plist"];
//	font = [[CCLabelBMFont alloc] initWithString:@"Now" fntFile:@"ShowcardGothic.fnt"];
//	font33 = [[CCLabelBMFont alloc] initWithString:@"Now" fntFile:@"kidfont33.fnt"];
	
	NSLog(@"Resource Manager completed loading");
	[self print_memory_size];
	
	shadowFont = [[CCLabelBMFont alloc] initWithString:@"Now" fntFile:@"shadowFont.fnt"];
	font30 = [[CCLabelBMFont alloc] initWithString:@"Now" fntFile:@"gothic15.fnt"];
}

- (CCSprite*) getTextureWithId: (int) textureId 
{
	return textures[textureId];
}

- (CCSprite*) getTextureWithName: (NSString*) textureName
{
	if([[CCDirector sharedDirector] enableRetinaDisplay: YES]) {
		return [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat: @"%@@2x.png", textureName]];
	} else {
		//return [CCSprite spriteWithSpriteFrameName:SHImageString(textureName, @"png")];
		return [CCSprite spriteWithSpriteFrameName:[textureName stringByAppendingFormat:@".%@", @"png"]];
	}
}

- (void) dealloc 
{
	[super dealloc];
	[font release];
	[font30 release];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	
	for (int i = 0; i < TEXTURE_COUNT; i ++)
	{
		[textures[i] release];
	}
}

@end

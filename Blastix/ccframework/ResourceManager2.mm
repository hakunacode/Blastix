//
//  ResourceManager.m
//  glideGame
//
//  Created by KCU on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager2.h"

#include <mach/mach.h>
#include <mach/machine.h>
@implementation ResourceManager2

static ResourceManager2 *_sharedResource = nil;

+ (ResourceManager2*) sharedResourceManager 
{
	if (!_sharedResource) 
	{
		_sharedResource = [[ResourceManager2 alloc] init];
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

- (void) dealloc 
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	
	for (int i = 0; i < TEXTURE_COUNT; i ++)
	{
		[textures[i] release];
	}
	
	[super dealloc];
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

- (NSString*) makeFileName: (NSString*)name ext: (NSString*) ext
{
	NSString*	strSuffix = nil;
	NSString*	strFile = nil;

	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        if( [[UIScreen mainScreen] scale] == 2.0f )
            strSuffix = @"-iPad3";
        else
            strSuffix = @"-iPad";
	}
//    else if( [[CCDirector sharedDirector] enableRetinaDisplay: YES] )
    else if( [[UIScreen mainScreen] scale] == 2.0f )
    {
		strSuffix = @"@2x";
	}
    else
    {
		strSuffix = @"";
	}
	strFile = [NSString stringWithFormat: @"%@%@.%@", name, strSuffix, ext];

	return strFile;
}

- (void) loadData: (NSString*) strName
{	
	CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	NSString*	strFile = [self makeFileName: strName ext: @"plist"];
	[frameCache addSpriteFramesWithFile: strFile];

//	NSLog(@"Resource Manager completed loading");
//	[self print_memory_size];
}

- (void) unloadData: (NSString*) strName
{
	CCSpriteFrameCache*		frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	NSString*	strFile = [self makeFileName: strName ext: @"plist"];
	[frameCache removeSpriteFramesFromFile: strFile];
	
//	CCLOG(@"Resource Manager completed unloading");
//	[self print_memory_size];
}

- (CCSprite*) getTextureWithName: (NSString*) textureName
{
	NSString*	strFile = [self makeFileName: textureName ext: @"png"];
	CCSprite*	sprite = [CCSprite spriteWithSpriteFrameName: strFile];

	return sprite;
}

-(CCSpriteFrame*) getSpriteFrameWithName:(NSString*) frameName {
	CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	
	NSString*	strFile = [self makeFileName: frameName ext: @"png"];
	CCSpriteFrame*	frame = [frameCache spriteFrameByName: strFile];

	return frame;
}

- (CCSprite*) getSpriteWithName: (NSString*) strSpriteName
{
	NSString*	strFile = [self makeFileName: strSpriteName ext: @"png"];
	CCSprite*	sprite = [CCSprite spriteWithFile: strFile];

	return sprite;
}

- (CCSprite*) getTextureWithId: (int) textureId 
{
	return textures[textureId];
}


@end

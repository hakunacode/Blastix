//
//  SQLDatabase.h
//  Version 1.1
//
//  Created by Morimuraseiichi on 9/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@protocol SQLDatabaseDelegate <NSObject>
@optional
- (void)databaseTableWasUpdated:(NSString *)table;
@end

@interface SQLDatabase : NSObject {
	
	id<SQLDatabaseDelegate> delegate;
	sqlite3 *dbh;
	BOOL dynamic;
}

@property (assign) id<SQLDatabaseDelegate> delegate;
@property sqlite3 *dbh;
@property BOOL dynamic;

- (id)initWithFile:(NSString *)dbFile;
- (id)initWithDynamicFile:(NSString *)dbFile;

- (sqlite3_stmt *)prepare:(NSString *)sql;

- (id)lookupColForSQL:(NSString *)sql;
- (NSDictionary *)lookupRowForSQL:(NSString *)sql;
- (NSArray *)lookupAllForSQL:(NSString *)sql;

- (int)lookupCountWhere:(NSString *)where forTable:(NSString *)table;
- (int)lookupMax:(NSString *)key Where:(NSString *)where forTable:(NSString *)table;
- (int)lookupSum:(NSString *)key Where:(NSString *)where forTable:(NSString *)table;

- (void)insertArray:(NSArray *)dbData forTable:(NSString *)table;
- (void)insertDictionary:(NSDictionary *)dbData forTable:(NSString *)table;

- (void)updateArray:(NSArray *)dbData forTable:(NSString *)table;
- (void)updateArray:(NSArray *)dbData forTable:(NSString *)table where:(NSString *)where;
- (void)updateDictionary:(NSDictionary *)dbData forTable:(NSString *)table;
- (void)updateDictionary:(NSDictionary *)dbData forTable:(NSString *)table where:(NSString *)where;
- (void)updateSQL:(NSString *)sql forTable:(NSString *)table;

- (void)deleteWhere:(NSString *)where forTable:(NSString *)table;

- (BOOL)runDynamicSQL:(NSString *)sql forTable:(NSString *)table;

@end




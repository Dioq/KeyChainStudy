//
//  DBManager.m
//  KeyChainStudy
//
//  Created by Dio Brand on 2022/6/23.
//

#import "DBManager.h"
#import <sqlite3.h>

@implementation DBManager

+ (void) clearKeyChain {
    sqlite3 *database;
    int openResult = sqlite3_open("/var/Keychains/keychain-2.db", &database);
    if (openResult == SQLITE_OK)
    {
        int execResult = sqlite3_exec(database, "DELETE FROM genp WHERE agrp <> 'apple'", NULL, NULL, NULL);
        if (execResult != SQLITE_OK) NSLog(@"Failed to exec DELETE FROM genp WHERE agrp <> 'apple', error %d", execResult);

        execResult = sqlite3_exec(database, "DELETE FROM cert WHERE agrp <> 'lockdown-identities'", NULL, NULL, NULL);
        if (execResult != SQLITE_OK) NSLog(@"Failed to exec DELETE FROM cert WHERE agrp <> 'lockdown-identities', error %d", execResult);

        execResult = sqlite3_exec(database, "DELETE FROM keys WHERE agrp <> 'lockdown-identities'", NULL, NULL, NULL);
        if (execResult != SQLITE_OK) NSLog(@"Failed to exec DELETE FROM keys WHERE agrp <> 'lockdown-identities'', error %d", execResult);

        execResult = sqlite3_exec(database, "DELETE FROM inet", NULL, NULL, NULL);
        if (execResult != SQLITE_OK) NSLog(@"Failed to exec DELETE FROM inet, error %d", execResult);

        execResult = sqlite3_exec(database, "DELETE FROM sqlite_sequence", NULL, NULL, NULL);
        if (execResult != SQLITE_OK) NSLog(@"Failed to exec DELETE FROM sqlite_sequence, error %d", execResult);

        sqlite3_close(database);
    }
}

@end

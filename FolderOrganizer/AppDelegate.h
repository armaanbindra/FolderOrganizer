//
//  AppDelegate.h
//  FolderOrganizer
//
//  Created by Armaan Bindra on 4/18/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate_HelperFunctions.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *rootLabel;
@property (weak) IBOutlet NSTextField *destFolderName;
@property (weak) IBOutlet NSPopUpButton *extensionList;
- (IBAction)updateList:(id)sender;
- (IBAction)OpenTargetFolder:(id)sender;
void populateList();
@end

NSString * rootDirectory;//the chosen directory to organize
NSFileManager *filemgr;//fileManager for all file related operations
//
//  AppDelegate.m
//  FolderOrganizer
//
//  Created by Armaan Bindra on 4/18/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

-(IBAction)didPushCTFButton:(id)sender
{
    NSArray * paths = openDir();
    NSURL * PathURL = [paths objectAtIndex:0];
    NSString * actualPath = [PathURL path];
    rootDirectory = actualPath;
    [_rootLabel setStringValue:actualPath];
    [self populateList];
    //[self displayWithMessage:actualPath];
}

- (IBAction)didPushOTFButton:(id)sender
{
    BOOL isSpecific = NO;
    NSString * specificType;
    specificType = [_extensionList titleOfSelectedItem];
    if (![specificType isEqualToString:@"All Types"]) {
        isSpecific = YES;
    }
    NSLog([NSString stringWithFormat:@"specificType is %@",specificType]);
    NSString *dirName; dirName = [_destFolderName stringValue];
    if ([filemgr changeCurrentDirectoryPath: rootDirectory] == NO)
        NSLog (@"Cannot change directory.");
    if ([dirName isEqualToString:@""]) {
        displayMessage(@"Please first enter a valid Name for the Destination Folder in the Text Field");
        return;
    }
    /*
    if([filemgr fileExistsAtPath:dirName])
    {
        NSString * msg = [NSString stringWithFormat:@"Warning! a Directory/Application with the name %@ already exists in the Target Folder, please choose an alternative name",dirName];
        displayMessage(msg);
        return;
    }*/
    
    NSArray *filelist;
    int count;
    int i;
    NSString *filename;
    NSDate *modTime;
    NSString * myMonthString;
    //NSArray *args = [NSArray arrayWithObject:@"Program Started"];
    int monthNum;
    NSString * year_str;
    
    filelist = [filemgr contentsOfDirectoryAtPath: rootDirectory error: nil];
    
    count = [filelist count];
    NSLog(@"The length of filelist is %d",count);
    if (![filemgr fileExistsAtPath:dirName]) {
        [filemgr createDirectoryAtPath:dirName withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    for (i = 0; i < count; i++)
    {
        filename = [filelist objectAtIndex: i];
        //NSLog (@"File %d: %@",i, filename);
        
        //Checks whether the target file is a Directory or not
        BOOL isDir;
        [filemgr fileExistsAtPath:filename isDirectory:&isDir];
       
        //If the target file is a Directory it is ignored
        if (isDir) {
            continue;
        }
        
        //Check whether user only wants specific files moved
        if (isSpecific)
        {
            NSString * fileType = [filename pathExtension];
            fileType = [NSString stringWithFormat:@".%@",fileType];
            if (![fileType isEqualToString:specificType]) {
                continue;
            }
        }
    
        modTime = [[filemgr attributesOfItemAtPath:filename error:NULL] fileModificationDate];
        monthNum = getMonth(modTime);
        year_str = getYear(modTime);
        
        NSString * try_dir = [NSString stringWithFormat:@"%@/%@-%@",dirName,monthToStr(monthNum),year_str];
        
        if (![filemgr fileExistsAtPath:try_dir]) {
            [filemgr createDirectoryAtPath:try_dir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        //NSLog(@"Month is %d", monthNum);
        NSString * dest = [NSString stringWithFormat:@"%@/%@-%@/%@",dirName,monthToStr(monthNum),year_str,filename];
        NSString * source = [NSString stringWithFormat:@"%@",filename];
        NSLog(@"Trying to move %@ to %@",source,dest);
        //NSLog([NSString stringWithFormat:@"file extension is %@",fileType]);
        //[filemgr copyItemAtPath:source toPath:dest error:nil];
        [filemgr moveItemAtPath:source toPath:dest error:nil];
    }
    
}



-(void) populateList
{
    [_extensionList removeAllItems];
    //[self displayWithMessage:@"populateList was Called"];
    NSArray *filelist;
    int count;
    int i;
    NSString *filename;
    NSMutableArray *listItems;
    listItems = [[NSMutableArray alloc] init];
    //[listItems addObject:@"Select Type"];
    [listItems addObject:@"All Types"];
    filelist = [filemgr contentsOfDirectoryAtPath: rootDirectory error: nil];
    count = [filelist count];
    for (i = 0; i < count; i++)
    {
        filename = [filelist objectAtIndex: i];
        NSString * fileType = [filename pathExtension];
        //NSString * kind = [[filemgr attributesOfItemAtPath:filename error:NULL] fileType];
        fileType = [NSString stringWithFormat:@".%@",fileType];
        if (![listItems containsObject:fileType] && ![fileType isEqualToString:@"."] && ![fileType isEqualToString:@".app"]) {
            //NSLog([NSString stringWithFormat:@"Adding item of kind %@ with extension %@ to list",kind,fileType]);
            [listItems addObject:fileType];
        }
    }
    //[listItems addObject:@"All Types"];
    [_extensionList addItemsWithTitles:listItems];
    //[_extensionList setObjectValue:@"All Types"];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *deskPath = [paths objectAtIndex:0];
    rootDirectory = deskPath;
    filemgr = [NSFileManager defaultManager];
    if ([filemgr changeCurrentDirectoryPath: rootDirectory] == NO)
        NSLog (@"Cannot change directory.");
    [_rootLabel setStringValue:rootDirectory];
    [_extensionList removeAllItems];
    [self populateList];
    }

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application
{
    return YES;
}

- (IBAction)updateList:(id)sender {
    NSString * temp_str = [_extensionList titleOfSelectedItem];
    [self populateList];
    [_extensionList setObjectValue:temp_str];
    [_extensionList setTitle:temp_str];
}

- (IBAction)OpenTargetFolder:(id)sender {
    NSURL *folderURL = [NSURL fileURLWithPath: rootDirectory];
    [[NSWorkspace sharedWorkspace] openURL:folderURL];
}
@end

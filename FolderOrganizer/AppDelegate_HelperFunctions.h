//
//  AppDelegate_HelperFunctions.h
//  FolderOrganizer
//
//  Created by Armaan Bindra on 4/19/14.
//  Copyright (c) 2014 Armaan Bindra. All rights reserved.
//

void displayMessage( NSString *message) {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert setMessageText:@"Information"];
    [alert setInformativeText:message];
    [alert runModal];
}

NSString * monthToStr(int monthNum)
{
    NSString * month_str;
    switch (monthNum) {
        case 1:
            month_str = @"January";
            break;
        case 2:
            month_str = @"February";
            break;
        case 3:
            month_str = @"March";
            break;
        case 4:
            month_str = @"April";
            break;
        case 5:
            month_str = @"May";
            break;
        case 6:
            month_str = @"June";
            break;
        case 7:
            month_str = @"July";
            break;
        case 8:
            month_str = @"August";
            break;
        case 9:
            month_str = @"September";
            break;
        case 10:
            month_str = @"October";
            break;
        case 11:
            month_str = @"November";
            break;
        case 12:
            month_str = @"December";
            break;
        default:
            month_str = @"RandomMonth";
            break;
    }
    return month_str;
}
NSString * getYear(NSDate* date)
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    int year = [components year];
    //int month = [components month];
    //int day = [components day];
    
    NSString * year_str = [NSString stringWithFormat:@"%d",year];
    return year_str;
}

int getMonth(NSDate* date)
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    //int year = [components year];
    int month = [components month];
    //int day = [components day];
    
    return month;
}

static NSArray * openDir()
{
    //NSArray *fileTypes = [NSArray arrayWithObjects:@"jpg",@"jpeg",nil];
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setPrompt:@"Set as Target Folder"];
    [panel setFloatingPanel:YES];
    NSInteger result = [panel runModalForDirectory:NSHomeDirectory() file:nil
                                             types:nil];
    if(result == NSOKButton)
    {
        return [panel URLs];
    }
    return nil;
}
/**
 * Ti.Safaridialog
 *
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"
#import <SafariServices/SafariServices.h>

@interface TiSafaridialogModule :TiModule<SFSafariViewControllerDelegate>{
@private
    SFSafariViewController *_safariController;
    NSString *_url;
    BOOL _isOpen;
}

@end

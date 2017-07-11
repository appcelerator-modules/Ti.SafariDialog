/**
 * Ti.Safaridialog
 *
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiSafaridialogModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation TiSafaridialogModule

#pragma mark Internal

// this is generated for your module, please do not change it
- (id)moduleGUID
{
	return @"c2b0df2f-43e2-4811-aa9e-c0a91c158d33";
}

// this is generated for your module, please do not change it
- (NSString*)moduleId
{
	return @"ti.safaridialog";
}

#pragma mark Lifecycle

- (void)startup
{
    _isOpen = NO;
    [super startup];
}

#pragma mark internal methods

- (void)teardown
{
    if (_safariController != nil) {
        [_safariController setDelegate:nil];
        _safariController = nil;
    }
    
    _isOpen = NO;
    
    if ([self _hasListeners:@"close"]){
        [self fireEvent:@"close" withObject:@{
            @"success": NUMINT(YES),
            @"url": [_url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
        }];
    }
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller
{
    [self teardown];
}

- (SFSafariViewController *)safariController:(NSString*)url withEntersReaderIfAvailable:(BOOL)entersReaderIfAvailable andBarCollapsingEnabled:(BOOL)barCollapsingEnabled
{
    if (_safariController == nil) {
        NSURL *safariURL = [NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#if IS_IOS_11
        if (@available(iOS 11.0, *)) {
            SFSafariViewControllerConfiguration *config = [[SFSafariViewControllerConfiguration alloc] init];
            config.entersReaderIfAvailable = entersReaderIfAvailable;
            config.barCollapsingEnabled = barCollapsingEnabled;
            
            _safariController = [[SFSafariViewController alloc] initWithURL:safariURL
                                                          configuration:config];
        }
#else
        _safariController = [[SFSafariViewController alloc] initWithURL:safariURL
                                            entersReaderIfAvailable:entersReaderIfAvailable];
#endif
        
        [_safariController setDelegate:self];
    }
    
    return _safariController;
}

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully
{
    if ([self _hasListeners:@"load"]) {
        [self fireEvent:@"load" withObject:@{
            @"url": [_url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
            @"success": NUMBOOL(didLoadSuccessfully)
        }];
    }
}

#pragma Public APIs

- (id)opened
{
    DEPRECATED_REPLACED(@"SafariDialog.opened", @"6.2.0", @"SafariDialog.isOpen()");
    return NUMBOOL(_isOpen);
}

- (NSNumber*)isOpen:(id)unused
{
    return NUMBOOL(_isOpen);
}

- (id)supported
{
    DEPRECATED_REPLACED(@"SafariDialog.supported", @"6.2.0", @"SafariDialog.isSupported()");
    return [self isSupported:nil];
}

- (NSNumber *)isSupported:(id)unused
{
    return NUMBOOL([TiUtils isIOS9OrGreater]);
}

- (void)close:(id)unused
{
    ENSURE_UI_THREAD(close,unused);
    
    if(_safariController != nil){
        [[TiApp app] hideModalController:_safariController animated:YES];
        [self teardown];
    }
    _isOpen = NO;
}

- (void)open:(id)args
{
    ENSURE_SINGLE_ARG(args,NSDictionary);
    ENSURE_UI_THREAD(open,args);
    
    if(![args objectForKey:@"url"]){
        NSLog(@"[ERROR] url is required");
        return;
    }
    
    _url = [TiUtils stringValue:@"url" properties:args];
    BOOL animated = [TiUtils boolValue:@"animated" properties:args def:YES];
    BOOL entersReaderIfAvailable = [TiUtils boolValue:@"entersReaderIfAvailable" properties:args def:YES];
    BOOL barCollapsingEnabled = NO;
    
#if IS_IOS_11
    barCollapsingEnabled = [TiUtils boolValue:@"barCollapsingEnabled" properties:args def:YES];
#endif
    
    SFSafariViewController* safari = [self safariController:_url withEntersReaderIfAvailable:entersReaderIfAvailable andBarCollapsingEnabled:barCollapsingEnabled];
    
    if ([args objectForKey:@"title"]) {
        [safari setTitle:[TiUtils stringValue:@"title" properties:args]];
    }
    
    if ([args objectForKey:@"tintColor"]) {
        TiColor *newColor = [TiUtils colorValue:@"tintColor" properties:args];
        
        if ([TiSafaridialogModule isIOS10OrGreater]) {
#if IS_IOS_10
            [safari setPreferredControlTintColor:[newColor _color]];
#endif
        } else {
            [[safari view] setTintColor:[newColor _color]];
        }
    }
    
#if IS_IOS_10
    if ([args objectForKey:@"barColor"]) {
        if ([TiSafaridialogModule isIOS10OrGreater]) {
            [safari setPreferredBarTintColor:[[TiUtils colorValue:@"barColor" properties:args] _color]];
        } else {
            NSLog(@"[ERROR] Ti.SafariDialog: The barColor property is only available in iOS 10 and later");
        }
    }
#endif
    
    
#if IS_IOS_11
    if ([args objectForKey:@"dismissButtonStyle"]) {
        if (@available(iOS 11.0, *)) {
            [safari setDismissButtonStyle:[TiUtils intValue:@"dismissButtonStyle" properties:args def:SFSafariViewControllerDismissButtonStyleDone]];
        } else {
            NSLog(@"[ERROR] Ti.SafariDialog: The dismissButtonStyle property is only available in iOS 11 and later");
        }
    }
#endif
    
    [[TiApp app] showModalController:safari animated:animated];
    
    _isOpen = YES;
    
    if ([self _hasListeners:@"open"]){
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                               NUMINT(YES),@"success",
                               _url,@"url",
                               nil
                               ];
        [self fireEvent:@"open" withObject:event];
    }
}

#pragma mark Constants

#if IS_IOS_11
MAKE_SYSTEM_PROP(DISMISS_BUTTON_STYLE_DONE, SFSafariViewControllerDismissButtonStyleDone);
MAKE_SYSTEM_PROP(DISMISS_BUTTON_STYLE_CLOSE, SFSafariViewControllerDismissButtonStyleClose);
MAKE_SYSTEM_PROP(DISMISS_BUTTON_STYLE_CANCEL, SFSafariViewControllerDismissButtonStyleCancel);
#endif

#pragma mark Utilities

+ (BOOL)isIOS10OrGreater
{
#if IS_IOS_10
    return [[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending;
#else
    return NO;
#endif
}

@end

/**
 * Ti.Safaridialog
 *
 * Copyright (c) 2009-2015 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#if IS_IOS_11

#import "TiSafaridialogAuthenticationSessionProxy.h"
#import "TiUtils.h"

@implementation TiSafaridialogAuthenticationSessionProxy

- (SFAuthenticationSession *)authSession
{
    if (_authSession == nil) {
        _authSession = [[SFAuthenticationSession alloc] initWithURL:[TiUtils toURL:[self valueForKey:@"url"] proxy:self]
                                                  callbackURLScheme:[TiUtils stringValue:[self valueForKey:@"scheme"]]
                                                  completionHandler:^(NSURL *callbackURL, NSError *error) {
                                                      KrollCallback *callback = (KrollCallback *)[self valueForKey:@"callback"];
                                                      NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:@{
                                                          @"success": NUMBOOL(error == nil)
                                                      }];
                                                      
                                                      if (error != nil) {
                                                          [event setObject:[error localizedDescription] forKey:@"error"];
                                                      } else {
                                                          [event setObject:[callbackURL absoluteString] forKey:@"callbackURL"];
                                                      }
                                                      
                                                      [callback call:@[event] thisObject:self];
                                                  }];
    }
}

#pragma mark Public API's

- (void)start:(id)unused
{
    [[self authSession] start];
}

- (void)cancel:(id)unused
{
    [[self authSession] cancel];
}

- (NSNumber *)isSupported:(id)unused
{
    return NUMBOOL([TiUtils isIOSVersionOrGreater:@"11.0"]);
}

@end

#endif

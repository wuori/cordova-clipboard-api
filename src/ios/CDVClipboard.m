#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import "CDVClipboard.h"

@implementation CDVClipboard

- (void)copy:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSMutableDictionary* copyItem = [command argumentAtIndex:0];
        NSString *copyType = copyItem[@"type"];
        NSString *copyData = copyItem[@"data"];
        
        [copyItem setValue:[NSNumber numberWithBool:0] forKey:@"error"];
        
        @try {
            if([copyType isEqualToString:@"image"]){
                NSURL *url = [NSURL URLWithString:copyData];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData: imageData];
                [pasteboard setImage:image];
            }else if([copyType isEqualToString:@"url"]){
                NSURL *url = [NSURL URLWithString:copyData];
                [pasteboard setURL:url];
            }else{
                [pasteboard setString:copyData];
            }
        }
        @catch (NSException* exception){
            [copyItem setValue:exception forKey:@"error"];
        }
        
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:copyItem];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
	}];
}

- (void)paste:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		

        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
        UIImage *image = [pasteboard image];
        NSURL *url = [pasteboard URL];
        NSString *text = [pasteboard string];
        NSString *type;
        
        if(image != nil){
            type = @"image";
            NSString *prefix = @"data:image/png;base64,";
            NSString *imageBase = [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSString *imageText = [NSString stringWithFormat:@"%@%@", prefix, imageBase];
            [result setValue:imageText forKey:@"data"];
        }else if(url != nil){
            type = @"url";
            NSString* urlText = url.absoluteString;
            [result setValue:urlText forKey:@"data"];
        }else{
            type = @"text";
            if (text == nil) {
                text = @"";
            }
            [result setValue:text forKey:@"data"];
        }
        
        [result setValue:type forKey:@"type"];
        
	    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:result];
	    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)clear:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    	[pasteboard setValue:@"" forPasteboardType:UIPasteboardNameGeneral];
	    
	    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
	    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

@end

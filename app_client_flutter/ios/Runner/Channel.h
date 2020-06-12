#import <Flutter/Flutter.h>
//#import <UIKit/UIKit.h>
//
//@interface YZCEventChannel: NSObject<FlutterPlugin>
//
//@end

@interface YZCMethodChannel: NSObject<FlutterPlugin, UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    FlutterResult _result;
}

+ (YZCMethodChannel *) instance;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

-(void)handleMethodCall:(FlutterMethodCall *)methodCall result:(FlutterResult)result;
- (void) processResult:(BOOL) success result:(NSString*) result;

- (void)showAlert:(NSString *)message title:(NSString *)title;
- (void)showAlert:(NSString *)message;

@property (nonatomic, retain) NSString *uuid;

@end

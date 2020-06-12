#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

#import "Channel.h"

#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

//微信的Key
#define WXAppIdKeys        @"wx43029953df89d2ac"
#define WXappSecret        @"aff576c4bfdd65cb10d7f77c1b568c53"
#define WeiXinPartnerId    @"1503466011"
#define WeiXinPartnerKey   @"12AsdAsd88888273hashdjdhASHDSHDD"
#define WXUniversalLink    @"https://prod.h5.jx9n.com"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

  [YZCMethodChannel registerWithRegistrar:[self registrarForPlugin:@"FlutterNativePlugin"]];

    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
        NSLog(@"WeCharSDK: %@", log);
    }];
    
  //向微信注册,发起支付必须注册
  [WXApi registerApp:WXAppIdKeys universalLink:WXUniversalLink];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
//    return [WXApi handleOpenURL:url delegate:self];
//}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url absoluteString] containsString:@"safepay"]) {
        //支付宝
        [self configureForAliPay:url];
        return NO;
    }else if([[url absoluteString] containsString:WXAppIdKeys]){
        //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }else if([[url absoluteString] containsString:@"uppayresult"]){
        return NO;
    }
    return NO;
}

- (BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

/**
 微信支付的代理
 */
#pragma mark -
-(void) onResp:(BaseResp*)resp {
    // 1.分享后回调类
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == 0) {
            [[YZCMethodChannel instance] processResult:true result:@"微信分享成功"];
            [[YZCMethodChannel instance] showAlert:@"分享成功"];
            //NSLog(@"分享成功");
        } else {
            [[YZCMethodChannel instance] processResult:false result:@"微信分享失败"];
            [[YZCMethodChannel instance] showAlert:@"分享失败"];
            //NSLog(@"分享失败");
        }
    } else if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess: {
                [[YZCMethodChannel instance] processResult:true result:@"微信支付成功"];
                //NSLog(@"支付成功");
                //![YKAlipayTool shareInstance].paySuccess ? : [YKAlipayTool shareInstance].paySuccess();
                break;
            }
            default: {
                [[YZCMethodChannel instance] processResult:false result:@"微信支付失败"];
                //![YKAlipayTool shareInstance].payFailed ? : [YKAlipayTool shareInstance].payFailed();
                NSLog(@"支付失败");
                break;
            }
        }
    }
}

/**
 支付宝支付成功后的回调
 */
#pragma mark -
- (void)configureForAliPay:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            if ([[resultDic objectForKey:@"resultStatus"] intValue]==9000) {
                [[YZCMethodChannel instance] processResult:true result:@"支付宝支付成功"];
                //![YKAlipayTool shareInstance].paySuccess ? : [YKAlipayTool shareInstance].paySuccess();
            }else{
                [[YZCMethodChannel instance] processResult:true result:@"支付宝支付失败"];
                //![YKAlipayTool shareInstance].payFailed ? : [YKAlipayTool shareInstance].payFailed();
            }
        }];
    }
}



@end

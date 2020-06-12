#import "Channel.h"
//#import "GeneratedPluginRegistrant.h"

#import "WKHelp.h"
#import "NSString+Regular.h"
#import "RSAEncryptor.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>

#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>

static YZCMethodChannel *sInstance = nil;

@implementation YZCMethodChannel

+ (YZCMethodChannel *) instance {
    if (sInstance == nil) {
        sInstance = [[YZCMethodChannel alloc] init];
    }
    return sInstance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"yzc_method_channel" binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:[YZCMethodChannel instance] channel:methodChannel];
}

-(void)handleMethodCall:(FlutterMethodCall *)methodCall result:(FlutterResult)result {
    NSLog(@"%@:%@", methodCall.method,methodCall.arguments);
    if ([methodCall.method isEqualToString:@"getHttpHeaders"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *timestamp = [NSString getNowTimeTimestamp];
        NSString *headerStr = [NSString stringWithFormat:@"%@%@",timestamp,RSA_CONS_KEY];
        NSString *encryptStr = [RSAEncryptor encryptString:headerStr publicKey:RSA_Public_Key];
        
        [dict setValue:APP_VERSION forKey:@"appVersion"];
        [dict setValue:encryptStr forKey:@"certification"];
        [dict setValue:[NSString getCurrentDeviceModel] forKey:@"osInformation"];
        [dict setValue:@"iOS" forKey:@"plat"];
        [dict setValue:[NSString getNowTimeTimestamp] forKey:@"timestamp"];

        //NSLog(@"getHttpHeaders = %@",[NSString jsonFromNSDictionary:dict]);
        result([NSString jsonFromNSDictionary:dict]);
    } else if ([methodCall.method isEqualToString:@"updateUUID"]) {
        self.uuid = [NSString stringWithString:methodCall.arguments];
        result(@"OK");
    } else if ([methodCall.method isEqualToString:@"getHeadImage"]) { //上传头像点击拍照
        _result = result;
        [self openSystemCamera];
    } else if ([methodCall.method isEqualToString:@"upLoadHeadImage"]) {
        //从相册选择
        _result = result;
        [self openSystemAlbum];
    } else if ([methodCall.method isEqualToString:@"downLoadApp"]) {
        //版本更新页面 点击下载最新版本
        result(@"OK");
    } else if ([methodCall.method isEqualToString:@"placeOrder"]) {
        //支付
        _result = result;
        NSDictionary *dict = (NSDictionary *)methodCall.arguments;
        id payMethod = [dict objectForKey:@"payMethod"];
        if (payMethod) {
            switch ([payMethod intValue]) {
                case 0: {//支付宝
                    NSString *orderString = [dict objectForKey:@"aliPay"];
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"io.dcloud.yunzhichongbusiness" callback:^(NSDictionary *resultDic) {
                        NSLog(@"ali pay reslut = %@",resultDic);
                    }];
                }
                    break;
                case 1: {//微信
                    if (![WXApi isWXAppInstalled]) {
                        [self showAlert:@"请检查是否安装微信."];
                    } else {
                        PayReq *req = [[PayReq alloc] init];
                        req.partnerId = [dict objectForKey:@"partnerid"];
                        req.prepayId = [dict objectForKey:@"prepayid"];
                        req.package = [dict objectForKey:@"package"];
                        req.nonceStr = [dict objectForKey:@"noncestr"];
                        req.timeStamp = [[dict objectForKey:@"timestamp"] intValue];
                        req.sign = [dict objectForKey:@"sign"];
                        [WXApi sendReq:req completion:nil];
                    }
                }
                    break;
            }
        }
        //result(@"OK");
    } else if ([methodCall.method isEqualToString:@"shareWeixin"]) { //分享图片到微信好友
        [self shareImageToWX:(NSString *)methodCall.arguments scene:WXSceneSession];
        result(@"OK");
    } else if ([methodCall.method isEqualToString:@"shareCircle"]) {
        //分享图片到朋友圈
        [self shareImageToWX:(NSString *)methodCall.arguments scene:WXSceneTimeline];
        result(@"OK");
    } else if ([methodCall.method isEqualToString:@"copyUrl"]) {
        //复制链接
        [UIPasteboard generalPasteboard].string = [NSString stringWithString:methodCall.arguments];
        result(@"OK");
    } else if ([methodCall.method isEqualToString:@"saveImg"]) {
        //下载图片
        result(@"OK");
    } else if ([methodCall.method isEqualToString:@"shareWeixinUrl"]) { //分享url到微信好友
        [self shareURLToWX:(NSString *)methodCall.arguments title:@"云智充" desc:@"发放充电券" scene:WXSceneSession];
        result(@"OK");
    } else if ([methodCall.method isEqualToString:@"phoneCilck"]) {
        //联系客服
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", (NSString *)methodCall.arguments]]];
        result(@"OK");
    } else if ([methodCall.method isEqualToString:@"getAppInfo"]) { //获取APP信息
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:0 forKey:@"updateBaseVersion"];
        result([NSString jsonFromNSDictionary:dict]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void) processResult:(BOOL) success result:(NSString*) result {
    if (_result != nil) {
        if (success) _result(result);
        else _result(result);
        _result = nil;
    }
}

- (UIViewController *)topViewController:(UIViewController *)rootVC {
    if (rootVC.presentedViewController == nil) return rootVC;
    if ([rootVC.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootVC.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    UIViewController *presentedViewController = (UIViewController *)rootVC.presentedViewController;
    return [self topViewController: presentedViewController];
}

- (UIViewController *)topViewController {
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
- (void)showAlert:(NSString *)message title:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alert addAction:confirm];
    
    [[self topViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)showAlert:(NSString *)message {
    [self showAlert:message title:@"温馨提示"];
}

#pragma mark 点击相册中的图片 或照相机照完后点击use  后触发的方法 UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //设置image的尺寸
        CGSize imagesize = image.size;
        image = [self imageWithImage:image scaledToSize:imagesize];
        if (_result) {
             _result([self UIImageToBase64Str:image]);
        }
       
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];

        //关闭界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    _result = nil;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (_result) {
         _result(@"Cancel");
        _result = nil;
    }
}

//对图片进行压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);

    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();

    // Return the new image.
    return newImage;
}

//图片转为nsstring
-(NSString *)UIImageToBase64Str:(UIImage *) image {
    CGSize imagesize = image.size;
    image = [self imageWithImage:image scaledToSize:CGSizeMake(imagesize.width/2, imagesize.height/2)];
    
    NSData *data = UIImageJPEGRepresentation(image,0.1);
    
    NSString *encodedImageStr = [NSString stringWithFormat:@"%@",[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    
    return encodedImageStr;
}

/**
 查看是否打开相机权限
 
 @return  YES打开 NO没打开
 */
- (BOOL)isAllowOpenCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

/**打开相机*/
- (void)openSystemCamera {
    //如果没有相机权限 给出提示
    if (![self isAllowOpenCamera]) {
        [self showAlert:@"请在iPhone的'设置-隐私-照片'选项中,允许云智充访问您手机相机"];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [[self topViewController] presentViewController:picker animated:YES completion:nil];
}

/**
 查看是否打开相册权限
 
 @return  YES打开 NO没打开
 */
- (BOOL)isAllowOpenAlbum {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

/**打开相册*/
- (void)openSystemAlbum {
    //如果没有相册权限 给出提示
    if (![self isAllowOpenAlbum]) {
        [self showAlert:@"请在iPhone的'设置-隐私-照片'选项中,允许云智充访问您手机相册"];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [[self topViewController] presentViewController:picker animated:YES completion:nil];
}

/**支付*/

- (void)payOrder {
    
}

#pragma mark 微信分享
- (void)shareTextToWX:(NSString *)text scene:(int)scene {
    if (![WXApi isWXAppInstalled]) {
        [self showAlert:@"请检查是否安装微信."];
    } else {
        WXTextObject *textObj = [WXTextObject object];
        textObj.contentText = text;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = textObj;
        message.description = text;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.message = message;
        req.scene =scene;
        [WXApi sendReq:req completion:nil];
    }
}

- (void)shareImageToWX:(NSString *)imageUrl scene:(int)scene {
    if (![WXApi isWXAppInstalled]) {
        [self showAlert:@"请检查是否安装微信."];
    } else {
        WXImageObject *imageObj = [WXImageObject object];
        imageObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = imageObj;
        [message setThumbImage:[UIImage imageNamed:@"shareIcon"]];
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req completion:nil];
    }
}

- (void)shareURLToWX:(NSString *)url title:(NSString *)title desc:(NSString *)desc scene:(int)scene {
    if (![WXApi isWXAppInstalled]) {
        [self showAlert:@"请检查是否安装微信."];
    } else {
        WXWebpageObject *urlObj = [WXWebpageObject object];
        urlObj.webpageUrl = url;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = urlObj;
        message.title = title;
        message.description = desc;
        [message setThumbImage:[UIImage imageNamed:@"shareIcon"]];
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req completion:nil];
    }
}

@end

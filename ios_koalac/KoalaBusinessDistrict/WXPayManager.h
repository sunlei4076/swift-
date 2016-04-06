//
//  WXPayManager.h
//  
//
//  Created by seekey on 15/10/24.
//
//

#import <Foundation/Foundation.h>
#import "ApiXml.h"
#import "WXUtil.h"
//#import "WXApi.h"

#define APP_ID          @"wx93f71a7c542ea78e"               //APPID
#define APP_SECRET      @"285b5c1d99a3fece56a03bc4a907b099" //appsecret
//商户号，填写商户对应参数
#define MCH_ID          @"1262452701"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"9A0892FA3D844FB5342FBD573250EAD9"
//支付结果回调页面  "http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
//#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
//获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"


@interface WXPayManager : NSObject
//微信给的ID
@property (strong,nonatomic) NSString *appID;
//微信给的秘钥
//商户号，填写商户对应参数
@property (strong,nonatomic) NSString *mchID;
//商户API密钥，填写相应参数
@property (strong,nonatomic) NSString *spKey;
//预支付网关url地址
@property (strong,nonatomic) NSString *payURL;
//var payURL:String = "https://api.mch.weixin.qq.com/pay/unifiedorder"
//debug信息
@property (strong,nonatomic) NSMutableString *debugInfo;
@property (assign,nonatomic) NSInteger lastErrCode;
////接口调用凭证
//var wxAccessToken:String = ""
////用户刷新access_token
//var wxRefreshToken:String = ""
////授权用户唯一标识
//var wxOpenId:String = ""

//初始化函数
-(id)initWithAppID:(NSString*)appID mchID:(NSString*)mchID spKey:(NSString*)key;
//获取当前的debug信息
-(NSString *) getDebugInfo;
//获取预支付订单信息（核心是一个prepayID）
- (NSMutableDictionary*)getPrepayWithOrderName:(NSString*)name orderNum:(NSString*)orderNum price:(NSString*)price device:(NSString*)device notifyURL:(NSString*)notifyURL;


@end

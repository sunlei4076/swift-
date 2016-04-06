//
//  WXPayManager.m
//  
//
//  Created by seekey on 15/10/24.
//
//

#import "WXPayManager.h"

@implementation WXPayManager

//初始化函数
-(id)initWithAppID:(NSString*)appID mchID:(NSString*)mchID spKey:(NSString*)key {
    self = [super init];
    if(self)
    {
        //初始化私有参数，主要是一些和商户有关的参数
        self.payURL = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
        if (self.debugInfo == nil){
            self.debugInfo  = [NSMutableString string];
        }
        [self.debugInfo setString: @""];
        self.appID = appID;//微信分配给商户的appID
        self.mchID = mchID;//
        self.spKey = key;//商户的密钥
    }
    
    return self;
}

//获取当前的debug信息
-(NSString *) getDebugInfo {
    NSString *res = [NSString stringWithString:self.debugInfo];
    [self.debugInfo setString:@""];
    return res;
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //NSLog(@"%@",keys);
    
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //NSLog(@"%@",sortedArray);
    
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //NSLog(@"%@",contentString);
    //添加key字段
    [contentString appendFormat:@"key=%@", self.spKey];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    [self.debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
    return md5Sign;
}

//获取package带参数的签名包
-(NSString *)genPackage:(NSMutableDictionary*)packageParams
{
    //NSLog(@"%@",packageParams);
    
    NSString *sign;
    NSMutableString *reqPars=[NSMutableString string];
    //生成签名
    sign        = [self createMd5Sign:packageParams];
    //生成xml的package
    NSArray *keys = [packageParams allKeys];
    [reqPars appendString:@"<xml>\n"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId]; 
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
    
    return [NSString stringWithString:reqPars];
}

//提交预支付
-(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams
{
    NSString *prepayid = nil;
    
    //获取提交支付
    NSString *send      = [self genPackage:prePayParams];
    //NSLog(@"%@",send);
    //输出Debug Info
    [self.debugInfo appendFormat:@"API链接:%@\n", self.payURL];
    [self.debugInfo appendFormat:@"发送的xml:%@\n", send];
    
    //发送请求post xml数据
    NSData *res = [WXUtil httpSend:self.payURL method:@"POST" data:send];
    
    
    //输出Debug Info
    [self.debugInfo appendFormat:@"服务器返回：\n%@\n\n",[[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding]];
    
    XMLHelper *xml  = [[XMLHelper alloc] init];
    
    //开始解析
    [xml startParse:res];
    
    NSMutableDictionary *resParams = [xml getDict];
    //NSLog(@"%@",resParams);
    
    //判断返回
    NSString *return_code   = [resParams objectForKey:@"return_code"];
    //NSLog(@"%@",return_code);
    
    NSString *result_code   = [resParams objectForKey:@"result_code"];
    //NSLog(@"%@",result_code);
    
    if ( [return_code isEqualToString:@"SUCCESS"] )
    {
        //生成返回数据的签名
        NSString *sign      = [self createMd5Sign:resParams ];
        NSString *send_sign =[resParams objectForKey:@"sign"] ;
        
        //验证签名正确性
        if( [sign isEqualToString:send_sign]){
            if( [result_code isEqualToString:@"SUCCESS"]) {
                //验证业务处理状态
                prepayid    = [resParams objectForKey:@"prepay_id"];
                return_code = 0;
                
                [self.debugInfo appendFormat:@"获取预支付交易标示成功！\n"];
            }
        }else{
            self.lastErrCode = 1;
            [self.debugInfo appendFormat:@"gen_sign=%@\n   _sign=%@\n",sign,send_sign];
            [self.debugInfo appendFormat:@"服务器返回签名验证错误！！！\n"];
        }
    }else{
        self.lastErrCode = 2;
        [self.debugInfo appendFormat:@"接口返回错误！！！\n"];
    }
    
    return prepayid;
}


//获取预支付订单信息（核心是一个prepayID）
//- (NSMutableDictionary*)getPrepayWithOrderName:(NSString*)name orderNum:(NSString*)orderNum price:(NSString*)price device:(NSString*)device notifyURL:(NSString*)notifyURL {

//    //订单标题，展示给用户
//    NSString* orderName = name;
//    //订单号，传给后台；
//    NSString* orderNumber = orderNum;
//    //支付通知的回调地址
//    NSString* notifyUrl = notifyURL;
//    
//    //订单金额,单位（分）
//    NSString* orderPrice = price;//以分为单位的整数
//    //支付设备号或门店号
//    NSString* orderDevice = device;
//    //支付类型，固定为APP
//    NSString* orderType = @"APP";
//    //发器支付的机器ip,暂时没有发现其作用
//    NSString* orderIP = @"196.168.1.1";
//    
//    //随机数串
//    srand( (unsigned)time(0) );
//    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
//    NSString *orderNO   = [NSString stringWithFormat:@"%ld",time(0)];
//
//    //================================
//    //预付单参数订单设置
//    //================================
//    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
//    
//    self.payURL = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
//    if (self.debugInfo == nil){
//        self.debugInfo  = [NSMutableString string];
//    }
//    [self.debugInfo setString: @""];
//    self.appID = APP_ID;//微信分配给商户的appID
//    self.mchID = MCH_ID;//
//    self.spKey = PARTNER_ID;//商户的密钥
//    
//    //NSLog(@"%@",self.appID);
//    
//    [packageParams setObject: self.appID  forKey:@"appid"];       //开放平台appid
//    [packageParams setObject: orderNumber  forKey:@"attach"];       //开放平台appid
//    [packageParams setObject: self.mchID  forKey:@"mch_id"];      //商户号
//    [packageParams setObject: orderDevice  forKey:@"device_info"]; //支付设备号或门店号
//    [packageParams setObject: noncestr     forKey:@"nonce_str"];   //随机串
//    [packageParams setObject: orderType    forKey:@"trade_type"];  //支付类型，固定为APP
//    [packageParams setObject: orderName    forKey:@"body"];        //订单描述，展示给用户
//    [packageParams setObject: notifyUrl  forKey:@"notify_url"];  //支付结果异步通知
//    [packageParams setObject: orderNO      forKey:@"out_trade_no"];//商户订单号
//    [packageParams setObject: orderIP      forKey:@"spbill_create_ip"];//发器支付的机器ip
//    [packageParams setObject: orderPrice   forKey:@"total_fee"];       //订单金额，单位为分
//    
//    //获取prepayId（预支付交易会话标识）
//    NSString *prePayid;
//    prePayid = [self sendPrepay:packageParams];
//    
//    if(prePayid == nil)
//    {
//        [self.debugInfo appendFormat:@"获取prepayid失败！\n"];
//        
//        return nil;
//    }

//    //获取到prepayid后进行第二次签名
//    NSString    *package, *time_stamp, *nonce_str;
//    //设置支付参数
//    time_t now;
//    time(&now);
//    time_stamp  = [NSString stringWithFormat:@"%ld", now];
//    nonce_str = [WXUtil md5:time_stamp];
//    //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
//    //package       = [NSString stringWithFormat:@"Sign=%@",package];
//    package = @"Sign=WXPay";
//===================life====================
    //第二次签名参数列表
//    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
//    [signParams setObject: self.appID  forKey:@"appid"];
//    [signParams setObject: self.mchID  forKey:@"partnerid"];
//    [signParams setObject: nonce_str    forKey:@"noncestr"];
//    [signParams setObject: package      forKey:@"package"];
//    [signParams setObject: time_stamp   forKey:@"timestamp"];
//    [signParams setObject: prePayid     forKey:@"prepayid"];
//
//    //生成签名
//    NSString *sign  = [self createMd5Sign:signParams];
//
//    //添加签名
//    [signParams setObject: sign         forKey:@"sign"];
//    
//    [self.debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
//    
//    //返回参数列表
//    return signParams;
    //=================life===================
//}

@end

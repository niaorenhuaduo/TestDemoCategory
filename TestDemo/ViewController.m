//
//  ViewController.m
//  TestDemo
//
//  Created by guangjianzhou on 15/12/2.
//  Copyright © 2015年 guangjianzhou. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "MJExtension.h"
#import "NSDate+help.h"
#import "CustomKeyboardView.h"
#import <Security/Security.h>
#import "AFNetworking.h"
#import "Status.h"
#import "NetAPIClient.h"
#import "FDRoot.h"
#import "WebViewCosntroller.h"
#import "RACViewController.h"
#import "CustomPopView.h"
#import "MyView.h"
#import "NSTimerViewController.h"
#import "MBProgressHUD.h"
#import "BLEViewController.h"
#import "DataSetObject.h"
#import <SDWebImage/SDWebImageManager.h>
#import "SystemViewController.h"
#import "RongCloudViewController.h"
#import "TSMessage.h"
#import "AnimationViewController.h"
#import "OpenCVViewController.h"
#import "WaterfallViewController.h"
#import "Student.h"
#import "iOS9ViewController.h"
#import "CustomerZGJViewController.h"
#import "ThirdLoginViewController.h"
#import "AppScoreViewController.h"
#import "LimitInputViewController.h"
#import "WordPicViewController.h"
#import "LoadInitiViewContorller.h"
#import "RecordVideoViewController.h"
#import "CustomTableViewController.h"
#import "DesignPatternViewController.h"
#import "DynamicViewController.h"
#import "LocalNotification10ViewController.h"
#import "CollectionVC.h"
#import "CALayerViewController.h"
#import "ProfileHeaderViewController.h"
#import "GesViewController.h"
#import "JSPatchViewController.h"


#define NSNullObjects @[@"",@0,@{},@[]]

@interface NSNull (InternalNullExtention)
@end

@implementation NSNull (InternalNullExtention)

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        for (NSObject *object in NSNullObjects) {
            signature = [object methodSignatureForSelector:selector];
            if (signature) {
                break;
            }
        }
        
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    for (NSObject *object in NSNullObjects) {
        if ([object respondsToSelector:aSelector]) {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self doesNotRecognizeSelector:aSelector];
}
@end


#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds

@interface ViewController ()<NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *pushBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;



//
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) CustomPopView *popView;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) DataSetObject *emptyDataSet;
@property (strong, nonatomic) UIView *subView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self bugTest];
    [self btnStatus];
    
    
    _subView = [[UIView alloc] initWithFrame:CGRectMake(20, 70, 50, 50)];
    _subView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_subView];
    
//    NSString *s1 = [NSString stringWithFormat:@"%@",1]; crash
//    NSLog(@"s1==%@==",s1);
    
    int i = 0;
    while (i<5)
    {
        i++;
        NSLog(@"%lu子view个数:i=%d",(unsigned long)[self.view subviews].count,i);
        [self.view addSubview:_subView];
        NSLog(@"==%lu子view个数:i=%d",(unsigned long)[self.view subviews].count,i);
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *name = dic[@"name"];
    
    NSLog(@"=name=%@======",name);
    
    
    //通知  此object 是用于过滤Notication的，只接收指定Sender所发的Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testNotifi:) name:@"TestNotification" object:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:self userInfo:@{@"name3":@"zgj3"}];
    });
    [self converJsonStrModel];
//    [self customNavigationBar];
    
    _searchBar.tintColor = [UIColor redColor];
    
    UIImageView *imgView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1.jpg"]];
    imgView2.frame=CGRectMake(10,10 , 10, 10);
    _textField.rightView=imgView2;
    _textField.rightViewMode=UITextFieldViewModeAlways;
    
    NSString *testStr = @"撒手机看东方科技就看上对方即可123444test";
    for (int i = 0 ; i< testStr.length; i++)
    {
        NSLog(@"===%i==%c",i,[testStr characterAtIndex:i]);
        
    }
    
    _segmentControl.layer.cornerRadius = 20;
    _segmentControl.layer.masksToBounds = YES;
    
    [self setUpNaivigationItem];
    [self effectVisualView];
    [self test1];
    [self gcdOneQueue];
    [self gcdSerialQueue];
    [self gcdGlobalQueue];
    [self setEmptyView];
//    [self gcdAfterQueue];
    {
        //键盘事件监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNote:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNote:) name:UIKeyboardWillHideNotification object:nil];
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CustomKeyboardView" owner:self options:nil];
        self.inputTextField.inputView = [views lastObject];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar"] forBarMetrics:UIBarMetricsDefault];
}

- (void)setEmptyView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            self.emptyDataSet = [[DataSetObject alloc]initWithSuperScrollView:self.tableView];
            self.emptyDataSet.state = loadingState;
            self.emptyDataSet.reloading = ^{
                
            };
        });
    });
}

- (void)testNotifi:(NSNotification *)notifi
{
    NSLog(@"%@=推送======",notifi.userInfo);
}

- (void)backAction
{
    NSLog(@"======backAction======");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkNetStatus:^(BOOL isHaveNet) {
            NSLog(@"==%d=isHaveNet==",isHaveNet);
        }];
    });
    
    
    
    _dataArray = [NSMutableArray arrayWithObjects:ISULocalizedString(@"webViewUserInterFaced"),ISULocalizedString(@"RACStudy"),ISULocalizedString(@"AVFoundataion"), ISULocalizedString(@"NSTimer"),ISULocalizedString(@"FMDB"),ISULocalizedString(@"UIDynamic"),ISULocalizedString(@"Lock"),ISULocalizedString(@"CoreGraphics"),@"热更新",@"手势",@"运行时",@"FFmpeg",@"Assert和摇一摇 二维码",@"AutoLayout",@"转场动画",@"StatusBar",@"蓝牙",@"延迟调用与取消",@"支付",@"CaseView",@"文件读写",@"AutoHeight",@"3DTouch",@"系统界面",@"ScrollVC",@"融云",@"会话列表",@"自定义弹出框",@"切换主题和语言",@"改变字体",@"IBDesignable",@"毛玻璃",@"CoreAnimation",@"OpenCV",@"瀑布流",@"iOS9",@"滑动view",@"自定义view",@"第三方登录",@"App评分",@"限制字符个数",@"图文混排",@"LoadInitial",@"视频录制",@"表视图",@"设计模式",@"粒子动画",@"ios10通知",@"九宫格",@"CALayer",@"表头拉伸",nil];
    [self configClass];
    
//    _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    _hud.labelText = @"拨打中,请稍等";
    
//    [_hud hide:YES afterDelay:1];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_hud hide:YES];
//        
//        
//        _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        _hud.labelText = @"拨打中,请稍等222222";
//        NSLog(@"pushBtn frame ==%@=",NSStringFromCGRect(_pushBtn.frame));
//    });
}

/**
 *  测试NavigationBar  添加subview
 */
- (void)naviBackView
{
    UIView *navBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kScreenWidth, 64)];
//    navBarBackgroundView.backgroundColor = [UIColor colorWithRed:60.f/255.f green:198.f/255.f blue:253.f/255.f alpha:0.f];
    navBarBackgroundView.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:navBarBackgroundView];
    [self.navigationController.navigationBar addSubview:navBarBackgroundView];
}

- (void)setUpNaivigationItem
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"弹出框" forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)pressRightBtn:(UIButton *)btn
{
    MyView *myView = [[MyView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    [[UIApplication sharedApplication].keyWindow addSubview:myView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [myView removeFromSuperview];
    });
    
    return;
}



- (void)test
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    
}

- (void)converJsonStrModel
{
    // 1.Define a JSONString
    NSString *jsonString = @"{\"name\":\"Jack\", \"icon\":\"lufy.png\", \"age\":20}";
    
    {
        //json 转换dic
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"--%@----",dic);
    }
    
    // 2.JSONString -> User
    User *user = [User mj_objectWithKeyValues:jsonString];
    NSLog(@"--%@--",user);
    
    
    /*************************/
    NSDictionary *dict = @{
                           @"text" : @"Agree!Nice weather!",
                           @"user" : @{
                                   @"name" : @"Jack",
                                   @"icon" : @"lufy.png"
                                   },
                           @"retweetedStatus" : @{
                                   @"text" : @"Nice weather!",
                                   @"user" : @{
                                           @"name" : @"Rose",
                                           @"icon" : @"nami.png"
                                           }
                                   }
                           };
    
    {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"---/jsonStr-%@----",jsonStr);
    }
    
    Status *status = [Status mj_objectWithKeyValues:dict];
    NSLog(@"status=======%@",status);
}


/**
 *  图片压缩
 *  压:文件体积变小，但是像素数不变，长度尺寸不变，那么质量可能下降
 *  缩:文件的尺寸变小，也就是像素数减少，长宽尺寸变小，文件体积同样会减小
 */
- (void)imageCompress
{
//    UIImageJPEGRepresentation(image, 0.0)压功能
//    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)] ; 缩功能
}


- (void)effectVisualView
{
    //实现模糊效果
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = self.imageView.frame;
    visualEffectView.alpha = 1.0;
    [self.imageView addSubview:visualEffectView];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)test1
{
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[@"1450075148" doubleValue]];
    NSString *startTime = [NSDate stringFromDate:startdate withFormat:kDatabaseDateFormat];
    NSLog(@"---startTime = %@-----",startTime);
    
    NSDictionary *dict1 = @{@"key":@"valye1",@"key2":@"value2"};
    NSLog(@"--字典-----%@----",dict1);
    
    if ([dict1 isKindOfClass:[NSArray class]])
    {
        NSLog(@"dic1 是数组");
    }
    else
    {
        NSLog(@"dic1 是字典");
    }
    
    NSDictionary *dict2 = @[@{@"key":@"valye1",@"key2":@"value2"}];
    if ([dict2 isKindOfClass:[NSArray class]])
    {
        NSLog(@"dic2 是数组");
    }
    else
    {
        NSLog(@"dic2 是字典");
    }
    
}

#pragma makr  - 
- (void)configClass
{
    User *user1 = [[User alloc] init];
    user1.name = @"哈哈";
    
    Class user2 = NSClassFromString(@"User");
    User *user3 = [[user2 alloc] init];
    user3.name = @"呵呵";
    NSLog(@"=======");
    
    
}

#pragma mark  - 自定义UINavigationBar
- (void)customNavigationBar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    view.backgroundColor = [UIColor redColor];
    
    [self.navigationController.navigationBar addSubview:view];
}


#pragma mark - Https
- (void)httpsRequest
{
    NSURL *httpURL = [NSURL URLWithString:@"https://www.baidu.com/index.php?tn=monline_3_dg"];
    NSURLRequest *request  = [NSURLRequest requestWithURL:httpURL];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    //1)获取trust object
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    SecTrustResultType result;
    
    //2.SecTrustEvalutate 对trust进行验证
    OSStatus status = SecTrustEvaluate(trust, &result);
    if (status == errSecSuccess && (result == kSecTrustResultProceed ||
                                    result == kSecTrustResultUnspecified))
    {
        
        //3)验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
        NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
        [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
    }
    else
    {
        //5)验证失败，取消这次验证流程
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
}

#pragma mark AFNetworkingHttps
- (void)afnRequest
{
//    NSURL *url = [NSURL URLWithString:@""];
//    AFHTTPRequestOperationManager *requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
//    dispatch_queue_t requestQueue = dispatch_queue_create("kRequestCompletionQueue", DISPATCH_QUEUE_SERIAL);
//    requestOperationManager.completionQueue = requestQueue;
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    
//    //是否允许无效证书(也就是自建的证书)
//    securityPolicy.allowInvalidCertificates = YES;
//    
//    //是否需要验证域名
//    securityPolicy.validatesDomainName = YES;
//    
//    //是否验证整个证书链
//    requestOperationManager.securityPolicy = securityPolicy;
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hgcang" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

- (void)stackViewStudy
{
    
}

#pragma mark - RunLoop
- (void)runLoop
{
    //scheduledTimerWithTimeInterval不需要加到runloop中
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(printMessage) userInfo:nil repeats:YES];
    
    //滚动scrollview,发现上面timer停止打印;在开启一个NSTimer实质上是在当前的runloop中注册了一个新的事件源，而当scrollView滚动时候，当前的mainRunloop处于UITrackingRunLoopModel模式下，这个模式下是不会处理NSDefaultRunLoopMode的消息，要想在scrollView滚动的同时也接受其它runloop的消息，我们需要改变两者之间的runloopmode.
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    /**
     *  5个model
     *
     *  1.KCFRunLoopDefaultModel:App的默认model。通常主线程是在这个mode下运行的
     *  2.UITrackingRunloopModel:界面追踪model，用于scrollView追踪触摸滑动，保证界面滑动时不受其他mode印象
     *  3.UIInitializationRunLoopModel:在刚启动App时进入的第一个mode,启动完成后就不再使用
     *  4.GSEventReceiveRunLoopModel:接受系统事件的内部Mode,通常用不到
     *  5.KCFRunLoopCommonModes:
     */
    
    
    
}

- (void)printMessage
{
    NSLog(@"打印message===");
}

#pragma mark - GCD

/*
同步和异步决定了要不要开启新的线程
同步：在当前线程中执行任务，不具备开启新线程的能力
异步：在新的线程中执行任务，具备开启新线程的能力


并发和串行决定了任务的执行方式
并发：多个任务并发（同时）执行
串行：一个任务执行完毕后，再执行下一个任务
*/



/**
 *  主队列/全局队列
 *
 */

- (void)gcdOneQueue
{
    NSLog(@"gcdOneQueue========");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //耗时操作
        NSLog(@"gcdOneQueue======%@==",[NSThread currentThread]);
       //完成后刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"gcdOneQueue=main完成=====%@==",[NSThread currentThread]);
        });
    });
}


//串行队列:执行完一个任务才会执行下一个任务
//会开启线程，但是只开启一个线程
- (void)gcdSerialQueue
{
    dispatch_queue_t queue = dispatch_queue_create("SerialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"任务开始了哈哈哈哈");
//    任务1-->任务2--->任务3,  任务1 2 3 全部是同一个线程 0x7fc77b4b5130
    dispatch_async(queue, ^{
        
        NSLog(@"queue1 -----%@---",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"queue2 ------%@--",[NSThread currentThread]);
        sleep(3);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"queue3 -----%@---",[NSThread currentThread]);
        sleep(2);
        
    });
    NSLog(@"任务结束了哈哈哈哈");
}


//并发队列 多个任务并发（同时）执行
//同时开启三个子线程
//输出: 任务2--》任务3--》任务1  ==》任务完成
- (void)gcdGlobalQueue
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_group_t group = dispatch_group_create();
    NSLog(@"任务1======begin====");
    dispatch_group_async(group, queue, ^{
        sleep(5);
        NSLog(@"任务1=======");
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        dispatch_group_t group1 = dispatch_group_create();
        dispatch_group_async(group1, queue1, ^{
            sleep(4);
            NSLog(@"任务1后面的任务");
        });
        
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务2-------");
    });
    
    dispatch_group_async(group, queue, ^{
        sleep(1);
        NSLog(@"任务3-------");
    });
    //任务123 全部完成后调用
    NSLog(@"任务1======middle====");
    dispatch_group_notify(group, queue, ^{
        NSLog(@"任务完成-------");
    });
    NSLog(@"任务1======end====");
}

- (void)gcdAfterQueue
{
    NSLog(@"---begin----%@--",[NSThread currentThread]
          );
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //延迟1s执行
        NSLog(@"---after----%@--",[NSThread currentThread]);
    });
    for (int i = 0; i<1000; i++)
    {
        NSLog(@"-----%d,打印-------",i);
    }
}


//不会开启新的线程，并发队列失去了并发的功能
//同步并发队列
- (void)sycGlobalQueue
{
    dispatch_queue_t  queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
    
}


//不会开启新的线程
//同步串行队列
- (void)sycSerialQueue
{
    dispatch_queue_t  queue= dispatch_queue_create("wedding", NULL);
    dispatch_sync(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
    
}





- (void)operationQueue
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
}

#pragma mark - Keyboard
- (void)handleKeyboardWillShowNote:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
    }];
}


/**
 *  NSFileManager 使用
 */

- (void)fileManagerTest
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDiretory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc--Path:%@",documentDiretory);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.inputTextField resignFirstResponder];
}

#pragma mark - 设置
- (void)jumpSystemSetVC
{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
    return;
}

#pragma mark - Action
- (IBAction)requestBtnAction:(UIButton *)sender
{
    [[NetAPIClient sharedClient] requestDataWithDic:nil requestType:NetRequestGet contentType:NetRequestContent_RecordSet finishBlock:^(NSDictionary* responserObj) {
        FDRoot *tag = [[FDRoot alloc] initWithDictionary:responserObj];
        NSLog(@"tag === %@",tag);
        
    } failBlock:^(NSError *error) {
        
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = _dataArray[indexPath.row];
    if ([title isEqualToString:@"网页交互"])
    {
        [self performSegueWithIdentifier:@"WebViewCosntrollerSegue" sender:nil];
    }
    else if ([title isEqualToString:@"RAC学习"])
    {
        [self performSegueWithIdentifier:@"RACViewControllerSegue" sender:nil];
    }
    else if ([title isEqualToString:@"AVFoundataion"])
    {
        [self performSegueWithIdentifier:@"AVFoundationViewControllerSegue" sender:nil];
    }
    else if ([title isEqualToString:@"定时器"])
    {
        [self performSegueWithIdentifier:@"NSTimerViewControllerSegue" sender:nil];
    }
    else if([title isEqualToString:@"数据库"])
    {
        [self performSegueWithIdentifier:@"FMDBSegue" sender:nil];
    }
    else if ([title isEqualToString:@"粒子动画"])
    {
        [self performSegueWithIdentifier:@"UIDynamicSegue" sender:nil];
    }
    else if ([title isEqualToString:@"锁"])
    {
        [self performSegueWithIdentifier:@"LockSegue" sender:nil];
    }
    else if([title isEqualToString:@"绘画"])
    {
        [self performSegueWithIdentifier:@"CoreGraphicsSegue" sender:nil];
    }
    else if([title isEqualToString:@"运行时"])
    {
        [self performSegueWithIdentifier:@"HeadSegue" sender:nil];
    }
    else if ([title isEqualToString:@"FFmpeg"])
    {
        [self performSegueWithIdentifier:@"FFmpegSegue" sender:nil];
    }
    else if ([title isEqualToString:@"Assert和摇一摇 二维码"])
    {
        [self performSegueWithIdentifier:@"AssertSegue" sender:nil];
    }
    else if ([title isEqualToString:@"AutoLayout"])
    {
        [self performSegueWithIdentifier:@"AutoLayoutSegue" sender:nil];
    }
    else if([title isEqualToString:@"转场动画"])
    {
        [self performSegueWithIdentifier:@"TransferSegue" sender:nil];
    }
    else if ([title isEqualToString:@"StatusBar"])
    {
        [self performSegueWithIdentifier:@"StatusBarSegue" sender:nil];
    }
    else if ([title isEqualToString:@"蓝牙"])
    {
        [self performSegueWithIdentifier:@"BLESegue" sender:nil];
    }
    else if([title isEqualToString:@"延迟调用与取消"])
    {
        [self performSegueWithIdentifier:@"DelaySegue" sender:nil];
    }
    else if([title isEqualToString:@"支付"])
    {
        [self performSegueWithIdentifier:@"PaySegue" sender:nil];
    }
    else if([title isEqualToString:@"CaseView"])
    {
        [self performSegueWithIdentifier:@"CaseSegue" sender:nil];
    }
    else if ([title isEqualToString:@"文件读写"])
    {
        [self performSegueWithIdentifier:@"WriteSegue" sender:nil];
    }
    else if ([title isEqualToString:@"AutoHeight"])
    {
        [self performSegueWithIdentifier:@"AutoHeightSegue" sender:nil];
    }
    else if ([title isEqualToString:@"3DTouch"])
    {
        [self performSegueWithIdentifier:@"3DTouchSeuge" sender:nil];
    }
    else if ([title isEqualToString:@"系统界面"])
    {
        SystemViewController *systemVC = [[SystemViewController alloc] init];
        [self.navigationController pushViewController:systemVC animated:YES];
    }
    else if ([title isEqualToString:@"ScrollVC"])
    {
        [self performSegueWithIdentifier:@"ScrollVCSegue" sender:nil];
    }
    else if([title isEqualToString:@"融云"])
    {
        [self performSegueWithIdentifier:@"RongCloudSegue" sender:nil];
    }
    else if ([title isEqualToString:@"会话列表"])
    {
        [self performSegueWithIdentifier:@"RoundListSegue" sender:nil];
    }
    else if([title isEqualToString:@"自定义弹出框"])
    {
        [self performSegueWithIdentifier:@"PopSegue" sender:nil];
    }
    else if([title isEqualToString:@"切换主题和语言"])
    {
        [self performSegueWithIdentifier:@"TheamSegue" sender:nil];
    }
    else if ([title isEqualToString:@"改变字体"])
    {
        [self performSegueWithIdentifier:@"ChangeFontSegue" sender:nil];
    }
    else if([title isEqualToString:@"IBDesignable"])
    {
        [self performSegueWithIdentifier:@"IBDesignableSegue" sender:nil];
    }
    else if ([title isEqualToString:@"毛玻璃"])
    {
        [self performSegueWithIdentifier:@"OpaqueSegue" sender:nil];
    }
    else if ([title isEqualToString:@"CoreAnimation"])
    {
        AnimationViewController *vc = [[AnimationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([title isEqualToString:@"OpenCV"])
    {
        OpenCVViewController *openCV = [[OpenCVViewController alloc] init];
        [self.navigationController pushViewController:openCV animated:YES];
    }
    else if ([title isEqualToString:@"瀑布流"])
    {
        WaterfallViewController *waterfallVC = [[WaterfallViewController alloc] init];
        [self.navigationController pushViewController:waterfallVC animated:YES];
    }
    else if ([title isEqualToString:@"iOS9"])
    {
        iOS9ViewController *iOS9VC = [[iOS9ViewController alloc] init];
        [self.navigationController pushViewController:iOS9VC animated:YES];
    }
    else if ([title isEqualToString:@"滑动view"])
    {
        [self performSegueWithIdentifier:@"CustomScrollViewSegue" sender:nil];
    }
    else if ([title isEqualToString:@"自定义view"]){
        CustomerZGJViewController *vc = [[CustomerZGJViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }
    else if([title isEqualToString:@"第三方登录"]){
        ThirdLoginViewController *vc = [[ThirdLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }else if([title isEqualToString:@"App评分"]){
        AppScoreViewController *vc = [[AppScoreViewController alloc] initWithNibName:@"AppScoreViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:true];
    }else if ([title isEqualToString:@"限制字符个数"]){
        LimitInputViewController *limitVC = [[LimitInputViewController alloc] init];
        [self.navigationController pushViewController:limitVC animated:true];
    }else if([title isEqualToString:@"图文混排"]){
        WordPicViewController *wordPic = [[WordPicViewController alloc] initWithNibName:@"WordPicViewController" bundle:nil];
        [self.navigationController pushViewController:wordPic animated:true];
    }else if ([title isEqualToString:@"LoadInitial"]){
        LoadInitiViewContorller *vc = [[LoadInitiViewContorller alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }else if ([title isEqualToString:@"视频录制"]){
        RecordVideoViewController *videoVC = [[RecordVideoViewController alloc] init];
        [self.navigationController pushViewController:videoVC animated:true];
    }else if ([title isEqualToString:@"表视图"]){
        CustomTableViewController *vc = [[CustomTableViewController alloc] initWithNibName:@"CustomTableViewController" bundle:nil
        ];
        [self.navigationController pushViewController:vc animated:true];
    }else if([title isEqualToString:@"设计模式"]){
        DesignPatternViewController *designPatternVC = [[DesignPatternViewController alloc] init];
        [self.navigationController pushViewController:designPatternVC animated:YES];
    }else if([title isEqualToString:@"粒子动画"]){
        DynamicViewController *dynamicVC = [[DynamicViewController alloc] initWithNibName:@"DynamicViewController" bundle:nil];
        [self.navigationController pushViewController:dynamicVC animated:YES];
    }else if([title isEqualToString:@"ios10通知"])
    {
        LocalNotification10ViewController *vc = [[LocalNotification10ViewController alloc] initWithNibName:@"LocalNotification10ViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title isEqualToString:@"九宫格"])
    {
        CollectionVC *vc = [[CollectionVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title isEqualToString:@"CALayer"]){
        CALayerViewController *vc = [[CALayerViewController alloc] initWithNibName:@"CALayerViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([title isEqualToString:@"表头拉伸"]){
        ProfileHeaderViewController *profileVC = [[ProfileHeaderViewController alloc] initWithNibName:@"ProfileHeaderViewController" bundle:nil];
        [self.navigationController pushViewController:profileVC animated:YES];
    }else if([title isEqualToString:@"手势"]){
        GesViewController *ges = [[GesViewController alloc] initWithNibName:@"GesViewController" bundle:nil];
        [self.navigationController pushViewController:ges animated:YES];
    }else if([title isEqualToString:@"热更新"]){
        JSPatchViewController *vc = [[JSPatchViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BLESegue"])
    {
        BLEViewController *bleVC = segue.destinationViewController;
//        bleVC.dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"124",@"first", nil];
        bleVC.dict = @{@"first":@"124"};
    }
    else if ([segue.identifier isEqualToString:@"RongCloudSegue"])
    {
        RongCloudViewController *rongCloudVC = segue.destinationViewController;
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        rongCloudVC.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        rongCloudVC.targetId = @"zgj";
        rongCloudVC.title = @"私聊";
    }
}

#pragma mark  - BugTest
- (void)dictAndArrayNil
{
    
    //字典赋值
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"zgj",@"name", nil];
    [resultDic setObject:@"" forKey:@"address"];
//    [resultDic setObject:nil forKey:@"age"]; 不允许nil
    
    
    //数组取值
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1",@"121",@"131", nil];
//    NSString *value = [array objectAtIndex:3];
//    NSLog(@"value=====%@",value);
    
    
}


- (void)bugTest
{
    
    [self dictAndArrayNil];
    
    NSArray *numbers = @[@5,@19,@89,@11,@3,@99];
    NSInteger max =  [[numbers valueForKeyPath:@"@max.intValue"] integerValue];  //
    
    
    [numbers enumerateObjectsUsingBlock:^(NSNumber  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"===number=%@===",obj);
    }];
    NSLog(@"---------finish--------");
    
    
    //没问题
    NSMutableArray *array = [NSMutableArray arrayWithArray:nil];
    
    if([@"null" integerValue] == 1)
    {
        NSLog(@"=======等于1====");
    }
    else
    {
        NSLog(@"======不等于1========");
    }
    
    
    [TSMessage showNotificationWithTitle:nil subtitle:nil type:TSMessageNotificationTypeSuccess];
    
    
    
    
    
    
//    id obj = [resultDic objectForKey:@"returnObj"];
    id obj = [NSNull null];
    
    // dataUsingEncoding 不能为nil
    NSArray  *exitClientArray =[NSJSONSerialization JSONObjectWithData:[obj dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    
    
    
    
    NSString *text = @(5);
    
    id num = @5;
    if ([num isKindOfClass:[NSNumber class]])
    {
        NSLog(@"数数字");
    }
    else
    {
        NSLog(@"拼音");
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"个个"];
    
//    -[NSConcreteAttributedString boundingRectWithSize:options:attributes:context:]:
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"哈哈" message:@"呵呵" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    NSArray *subViews = [alertView subviews];
    NSLog(@"=========");
//    [alertView show];
    
//    NSString *urlString = @"https://coding.net/api/project/404854/files/791295/download";//txt
    
//    NSString *urlString = @"http://znmdmtest.zhongnangroup.cn:81/test.docx"; doc
    
     NSString *urlString = @"https://m.vanke.com/appUpdate/aa.html";
    NSURL * url=[[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    

    NSData *pngData = [NSData dataWithContentsOfURL:url];
    NSLog(@"pngData=====%@",pngData);
    
    NSString *result = [[NSString alloc] initWithData:pngData  encoding:NSUTF8StringEncoding];
    NSLog(@"====result=%@====",result);
    
    NSLog(@"url=====%@",url);
}

#pragma mark  - Button状态
- (void)btnStatus
{
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"111" forKey:@"111"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"111" ];
    NSLog(@"str:%@",str);
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userName":@"zgj",@"password":@"1234",@"email":@"zgj6406400@163.com",@"realName":@"哈哈",@"qq":@"1234555"}];
    
    [[NetAPIClient sharedClient]requestDataWithDic:dic requestType:NetRequestPost contentType:NetRequestContent_Test finishBlock:^(id responserObj) {
        NSLog(@"====responserObj%@===",responserObj);
    } failBlock:^(NSError *error) {
        NSLog(@"====error%@===",error);
    } errorBlock:^(NSError *error) {
        NSLog(@"====error%@===",error);
    }];
    
    
    int a = 10.1;
    
    [self.testBtn setTitle:@"helloNormal" forState:UIControlStateNormal];
    [self.testBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    
    //按下状态
    [self.testBtn setTitle:@"呵呵" forState:UIControlStateHighlighted];
    [self.testBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    
    //kvc
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"zgj",@"name",@"98",@"age", nil];
    
    
    [dic1 setValue:@"27" forKey:@"age"];
//    {
//        age = 27;
//        name = zgj;
//    }
    NSLog(@"==%@=",dic1);
    
    Student *student = [[Student alloc] init];
    [student setValue:@"25" forKey:@"age"];    // 没有name crash
    NSLog(@"=====%@=",[student valueForKey:@"age"]); //valueForUndefinedKey: crash
    
}

- (BOOL)isSameString:(NSString *)key
{
    NSMutableArray *array = [NSMutableArray array];
    for (id key in array)
    {
        if ([key isEqualToString:key])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)checkNetStatus:(void (^)(BOOL))block
{
    //网络状态检查
    AFNetworkReachabilityStatus netStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    switch (netStatus)
    {
        case AFNetworkReachabilityStatusUnknown:
        {
            block(NO);
            break;
        }
            
        case AFNetworkReachabilityStatusNotReachable:
        {
            block(NO);
            break;
        }
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
        {
            block(YES);
            break;
        }
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
        {
            block(YES);
            break;
        }
            
        default:
        {
            block(NO);
            break;
        }
    }
}


- (IBAction)testBtn:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"reset" ofType:@"css"];
    NSLog(@"====localPath==%@",path);
    
    
    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&amp;url=https://www.jstxl.cn/groupbook.plist"]];
    
    
}
@end

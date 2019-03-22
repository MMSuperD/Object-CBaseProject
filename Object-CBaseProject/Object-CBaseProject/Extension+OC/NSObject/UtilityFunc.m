/**
 *  公共函数方法 全类通用
 */

#import "UtilityFunc.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreText/CoreText.h>
#import "UIView+WP.h"

@implementation UtilityFunc

#pragma mark 计算出字体的长度已经高度。这里不包括行距
+(CGSize)calculationOfTheText:(NSString *)string withFont:(CGFloat)font withMaxSize:(CGSize)maxSize{
    
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}
#pragma mark 计算出字体的长度已经高度。并且要设置行距。会对Lable进行处理。返回宽度和高度可以不用处理。
+(CGRect)calculationOfTheText:(NSString *)string inLabel:(UILabel *)label withFont:(CGFloat)font withMaxWidth:(CGFloat)width withLineSpacing:(CGFloat)spacing{
    //设置Label最大的宽度
    label.frame = (CGRect){label.frame.origin.x,label.frame.origin.y,width,label.frame.size.width};
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 0;
    CGSize size = [UtilityFunc calculationOfTheText:string withFont:font withMaxSize:CGSizeMake(width, MAXFLOAT)];
    if (size.height < font + 5) {
        label.text = string;
        return (CGRect){label.x, label.y, size.width, size.height};
    }
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [label setAttributedText:attributedString];
    [label sizeToFit];
    
    return (CGRect){label.frame.origin.x,label.frame.origin.y,label.frame.size.width,label.frame.size.height};
}

+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    return [self getSeparatedLinesWithText:text font:font maxWidth:rect.size.width];
}

+ (NSArray *)getSeparatedLinesWithText:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
//    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.lineBreakMode = NSLineBreakByCharWrapping;
    
    //段落
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping; //换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting settings[] = {lineBreakMode};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 1);   //第二个参数为settings的长度
    
    [attStr addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyle range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,maxWidth,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}

#pragma mark 设置导航条的颜色,已经隐藏导航条下面的线了
+(void)setNavigationBarColor:(UIColor *)color withTargetViewController:(id)target{
    
    UIViewController *viewController = (UIViewController *)target;
    //导航条的颜色 以及隐藏导航条的颜色
    viewController.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [viewController.navigationController.navigationBar setBackgroundImage:theImage forBarMetrics:UIBarMetricsDefault];
}
#pragma mark scrollView顶部视图下拉放大
/**
 *  scrollView顶部视图下拉放大
 *
 *  @param imageView  需要放大的图片
 *  @param headerView 图片所在headerView 如果没有则传图片自己本身
 *  @param height     图片的高度
 *  @param offsetY    设置偏移多少开始形变  例如是：offset_y = 64 说明就是y向下偏移64像素开始放大
 *  @param scrollView 对应的scrollView
 */
+(void)setHeaderViewDropDownEnlargeImageView:(UIImageView *)imageView withHeaderView:(UIView *)headerView withImageViewHeight:(CGFloat)height withOffsetY:(CGFloat)offsetY withScrollView:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    //向上偏移量变正  向下偏移量变负
    /**
     *  设置偏移多少开始形变  例如是：offset_y = 64 说明就是y向下偏移64像素开始放大
     宏：k_headerViewHeight 就是header的高度
     */
    CGFloat offset_y = offsetY;
    CGFloat imageHeight = height;
    
    if (yOffset < -offset_y) {
        CGFloat factor = ABS(yOffset)+imageHeight-offset_y;
        CGRect f = CGRectMake(-([[UIScreen mainScreen] bounds].size.width*factor/imageHeight-[[UIScreen mainScreen] bounds].size.width)/2,-ABS(yOffset)+offset_y, [[UIScreen mainScreen] bounds].size.width*factor/imageHeight, factor);
        imageView.frame = f;
    }else {
        CGRect f = headerView.frame;
        f.origin.y = 0;
        headerView.frame = f;
        imageView.frame = CGRectMake(0, f.origin.y, [[UIScreen mainScreen] bounds].size.width, imageHeight);
    }
}
+(UIAlertController *)createAlertViewWithTitle:(NSString *)title withCancleBtnStr:(NSString *)cancelStr withOtherBtnStr:(NSString *)otherBthStr withOtherBtnColor:(UIColor *)otherBtnColor withMessage:(NSString *)message completionCallback:(void (^)(NSInteger index))completionCallback{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionCallback(0);
    }];
    
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherBthStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionCallback(1);
    }];
    [otherAction setValue:otherBtnColor forKey:@"_titleTextColor"];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:otherAction];
    
    return alertVC;
}
#pragma mark 传入当前控制器 获取同一个nav里面的控制器
+(UIViewController *)getTargetViewController:(NSString *)viewControllerName withInTheCurrentController:(UIViewController *)viewController{
    NSArray *viewControllers = viewController.navigationController.viewControllers;
    id object;
    for (int i=0; i!=viewControllers.count; i++) {
        UIViewController *viewController = viewControllers[i];
        NSString *vcName = [NSString stringWithUTF8String:object_getClassName(viewController)];
        if ([vcName isEqualToString:viewControllerName]) {
            object = viewController;
        }
    }
    return (UIViewController *)object;
}

#pragma mark 传入时间戳1296057600和输出格式 yyyy-MM-dd HH:mm:ss
+ (NSString *)dateWithTimeIntervalSince1970:(NSTimeInterval)seconds dateStringWithFormat:(NSString *)format {
    
    // Timestamp conver NSData
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:format];
    return [dateFormatte stringFromDate:date];
}


// 是否4英寸屏幕
+ (BOOL)is4InchScreen
{
    static BOOL bIs4Inch = NO;
    static BOOL bIsGetValue = NO;
    
    if (!bIsGetValue)
    {
        CGRect rcAppFrame = [UIScreen mainScreen].bounds;
        bIs4Inch = (rcAppFrame.size.height == 568.0f);
        
        bIsGetValue = YES;
    }else{}
    
    return bIs4Inch;
}

// 获取屏幕宽度
+ (CGFloat)getScreenWidth
{
    static CGRect rcScreenFrame;
    static BOOL bIsGetScreen = NO;
    
    if (!bIsGetScreen)
    {
        rcScreenFrame = [UIScreen mainScreen].bounds;
        
        bIsGetScreen = YES;
    }else{}
    
    return rcScreenFrame.size.width;
}

// 获取屏幕高度
+ (CGFloat)getScreenHeight
{
    static CGRect rcScreenFrame;
    static BOOL bIsGetScreen = NO;
    
    if (!bIsGetScreen)
    {
        rcScreenFrame = [UIScreen mainScreen].bounds;
        
        bIsGetScreen = YES;
    }else{}
    
    return rcScreenFrame.size.height;
}

// 日期转字符串
+ (NSString *)getStringFromDate:(NSDate *)date byFormat:(NSString *)strFormat
{
    NSString *strRet = nil;
    if (date && strFormat)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        
        [dateFormatter setDateFormat:strFormat];
        strRet = [dateFormatter stringFromDate:date];
    }else{}
    
    return strRet;
}
// 字符串转日期
+ (NSDate *)getDateFromString:(NSString *)strDate byFormat:(NSString *)strDateFormat
{
    NSDate *dateRet = nil;
    if (strDate && strDateFormat && (strDate.length == strDateFormat.length))
    {
        NSDateFormatter *objDateFmt = [[NSDateFormatter alloc] init];
        [objDateFmt setTimeZone:[NSTimeZone defaultTimeZone]];
        [objDateFmt setDateFormat:strDateFormat];
        dateRet = [objDateFmt dateFromString:strDate];
    }else{}
    
    return dateRet;
}

// label设置最小字体大小
+ (void)label:(UILabel *)label setMiniFontSize:(CGFloat)fMiniSize forNumberOfLines:(NSInteger)iLines
{
    if (label)
    {
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = fMiniSize/label.font.pointSize;
    }else{}
}

// 清除PerformRequests和notification
+ (void)cancelPerformRequestAndNotification:(UIViewController *)viewCtrl
{
    if (viewCtrl)
    {
        [[viewCtrl class] cancelPreviousPerformRequestsWithTarget:viewCtrl];
        [[NSNotificationCenter defaultCenter] removeObserver:viewCtrl];
    }else{}
}

#define StatusBarHeight 20
// 重设scroll view的内容区域和滚动条区域
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar
{
    if (sclView)
    {
        UIEdgeInsets inset = sclView.contentInset;
        UIEdgeInsets insetIndicator = sclView.scrollIndicatorInsets;
        CGFloat fTopInset = bHasNaviBar ? 64 : 0.0f;
        CGFloat fTopIndicatorInset = bHasNaviBar ? 64 : 0.0f;
        CGFloat fBottomInset = bHasTabBar ? 49 : 0.0f;
        
        fTopInset += StatusBarHeight;
        fTopIndicatorInset += StatusBarHeight;
        
        insetIndicator.top += fTopIndicatorInset;
        insetIndicator.bottom += fBottomInset;
        [sclView setScrollIndicatorInsets:insetIndicator];
        
        inset.top += fTopInset;
        inset.bottom += fBottomInset;
        [sclView setContentInset:inset];
    }else{}
}

// 按找状态栏高度的倍数来重设scroll view的内容区域和滚动条区域
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetStatusBarTimes:(NSInteger)contentTimes indicatorInsetStatusBarTimes:(NSInteger)indicatorTimes
{
    if (sclView)
    {
        UIEdgeInsets inset = sclView.contentInset;
        UIEdgeInsets insetIndicator = sclView.scrollIndicatorInsets;
        CGPoint ptContentOffset = sclView.contentOffset;
        CGFloat fTopInset = 0.0f;
        CGFloat fTopIndicatorInset = 0.0f;
        
        fTopInset += StatusBarHeight * contentTimes;
        fTopIndicatorInset += StatusBarHeight * indicatorTimes;
        
        inset.top += fTopInset;
        [sclView setContentInset:inset];
        
        insetIndicator.top += fTopIndicatorInset;
        [sclView setScrollIndicatorInsets:insetIndicator];
        
        ptContentOffset.y -= fTopInset;
        [sclView setContentOffset:ptContentOffset];
    }else{}
}
// 指定高度重设内容区域和滚动条区域
+ (void)resetScrlView:(UIScrollView *)sclView contentInset:(CGFloat)contentInset indicatorInset:(CGFloat)indicatorInset
{
    if (sclView)
    {
        UIEdgeInsets inset = sclView.contentInset;
        UIEdgeInsets insetIndicator = sclView.scrollIndicatorInsets;
        CGPoint ptContentOffset = sclView.contentOffset;
        CGFloat fTopInset = 0.0f;
        CGFloat fTopIndicatorInset = 0.0f;
        
        fTopInset += contentInset;
        fTopIndicatorInset += indicatorInset;
        
        inset.top += fTopInset;
        [sclView setContentInset:inset];
        
        insetIndicator.top += fTopIndicatorInset;
        [sclView setScrollIndicatorInsets:insetIndicator];
        
        ptContentOffset.y -= fTopInset;
        [sclView setContentOffset:ptContentOffset];
    }else{}
}

// 从故事版获取VC
+ (id)viewCtrlFormStoryboard:(NSString *)storyboardName viewCtrlID:(NSString *)viewCtrlID
{
    NSParameterAssert(storyboardName && viewCtrlID);
//    APP_ASSERT(storyboardName && viewCtrlID);
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
//    APP_ASSERT(storyBoard);
    NSParameterAssert(storyBoard);
    id ret = [storyBoard instantiateViewControllerWithIdentifier:viewCtrlID];
    
    return  ret;
}
+(id)getControllerWithIdentity:(NSString *)identifier storyboard:(NSString *)title
{
    UIStoryboard *storyBoard = nil;
    if (title==NULL) {
        //应用程序的名称和版本号等信息都保存在mainBundle的一个字典中，用下面代码可以取出来。
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        
        title = [infoDict objectForKey:@"UIMainStoryboardFile"];
        storyBoard = [UIStoryboard storyboardWithName:title bundle:nil];
    }else{
        storyBoard = [UIStoryboard storyboardWithName:title bundle:nil];
    }
    if (storyBoard == NULL) {
        return NULL;
    }
    
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}

id getController(NSString *identifier,NSString *title)
{
    UIStoryboard *storyBoard = nil;
    if (title==NULL) {
        //应用程序的名称和版本号等信息都保存在mainBundle的一个字典中，用下面代码可以取出来。
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        
        title = [infoDict objectForKey:@"UIMainStoryboardFile"];
        storyBoard = [UIStoryboard storyboardWithName:title bundle:nil];
    }else{
        storyBoard = [UIStoryboard storyboardWithName:title bundle:nil];
    }
    if (storyBoard == NULL) {
        return NULL;
    }
    
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:identifier];
    return viewController;
}

//活跃的window
+(UIWindow *)getWindow
{
    //活跃的window
    NSArray *listWindow = [[UIApplication sharedApplication] windows];
    return [listWindow firstObject];
}



// 创建UILabel
+ (UILabel *)createLabelWithFrame:(CGRect)rc fontSize:(CGFloat)fFontSize txtColor:(UIColor *)clrTxt
{
    return [[self class] createLabelWithFrame:rc fontSize:fFontSize txtColor:clrTxt isBoldFont:NO];
}
+ (UILabel *)createLabelWithFrame:(CGRect)rc fontSize:(CGFloat)fFontSize txtColor:(UIColor *)clrTxt isBoldFont:(BOOL)bIsBold
{
    return [[self class] createLabelWithFrame:rc fontSize:fFontSize txtColor:clrTxt isBoldFont:bIsBold txtAlignment:NSTextAlignmentLeft];
}
+ (UILabel *)createLabelWithFrame:(CGRect)rc fontSize:(CGFloat)fFontSize txtColor:(UIColor *)clrTxt isBoldFont:(BOOL)bIsBold txtAlignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:rc];
    label.textColor = clrTxt;
    label.font = bIsBold ? [UIFont boldSystemFontOfSize:fFontSize] : [UIFont systemFontOfSize:fFontSize];
    label.textAlignment = alignment;
    label.backgroundColor = [UIColor clearColor];
    //    label.lineBreakMode = NSLineBreakByCharWrapping;
    
    return label;
}

// 心跳动画
+ (void)heartbeatView:(UIView *)view duration:(CGFloat)fDuration
{
    [[self class] heartbeatView:view duration:fDuration maxSize:1.4f durationPerBeat:0.5f];
}
+ (void)heartbeatView:(UIView *)view duration:(CGFloat)fDuration maxSize:(CGFloat)fMaxSize durationPerBeat:(CGFloat)fDurationPerBeat
{
    if (view && (fDurationPerBeat > 0.1f))
    {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        CATransform3D scale1 = CATransform3DMakeScale(0.9, 0.9, 1);
        CATransform3D scale2 = CATransform3DMakeScale(fMaxSize, fMaxSize, 1);
        CATransform3D scale3 = CATransform3DMakeScale(1.0, 1.0, 1);
        
        NSArray *frameValues = [NSArray arrayWithObjects:
                                [NSValue valueWithCATransform3D:scale1],
                                [NSValue valueWithCATransform3D:scale2],
                                [NSValue valueWithCATransform3D:scale3],
                                nil];
        
        [animation setValues:frameValues];
        
        NSArray *frameTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.1],
                               [NSNumber numberWithFloat:0.5],
                               [NSNumber numberWithFloat:1.0],
                               nil];
        [animation setKeyTimes:frameTimes];
        
        animation.fillMode = kCAFillModeForwards;
        animation.duration = fDurationPerBeat;
        animation.repeatCount = fDuration/fDurationPerBeat;
        
        [view.layer addAnimation:animation forKey:@"heartbeatView"];
    }else{}
}

// Table滚动时TableCell内ImageView视差显示
+ (void)cell:(UITableViewCell *)cell onTableView:(UITableView *)tableView didScrollOnView:(UIView *)view parallaxImgView:(UIImageView *)imgView
{
   // APP_ASSERT(cell && tableView && view && imgView);
    NSParameterAssert(cell && tableView && view && imgView);
    CGRect rectInSuperview = [tableView convertRect:cell.frame toView:tableView];
    rectInSuperview.origin.y -= tableView.contentOffset.y;
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(imgView.frame) - CGRectGetHeight(cell.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = imgView.frame;
    imageRect.origin.y = -(difference/2)+move;
    imgView.frame = imageRect;
}

// 解析出URL的参数
+ (NSDictionary *)paramFromURL:(NSURL *)URL
{
    NSDictionary *dicRet;
    
    if (URL && URL.query)
    {
        NSStringEncoding encoding = NSUTF8StringEncoding;
        
        NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
        NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
        NSScanner* scanner = [[NSScanner alloc] initWithString:URL.query];
        while (![scanner isAtEnd])
        {
            NSString* pairString = nil;
            [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
            if (kvPair.count == 2) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored"-Wdeprecated-declarations"
                NSString* key = [[kvPair objectAtIndex:0]
                                 stringByReplacingPercentEscapesUsingEncoding:encoding];
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                #pragma clang diagnostic pop
                // value中的加号+ 替换为空格
                value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                
                [pairs setObject:value forKey:key];
            }
        }
        
        dicRet = [NSDictionary dictionaryWithDictionary:pairs];
    }else{}
    
    return dicRet;
}

// 创建编辑框
+ (UITextField *)createNormalTextFieldWithFrame:(CGRect)rcFrame placeHolder:(NSString *)strPlaceholder
{
    return [[self class] createNormalTextFieldWithFrame:rcFrame placeHolder:strPlaceholder keyboardType:UIKeyboardTypeDefault];
}
+ (UITextField *)createNormalTextFieldWithFrame:(CGRect)rcFrame placeHolder:(NSString *)strPlaceholder keyboardType:(UIKeyboardType)eKeyboardType
{
    UITextField *txtField;
    txtField = [[UITextField alloc] initWithFrame:rcFrame];
    txtField.placeholder = strPlaceholder;
    txtField.userInteractionEnabled = YES;
    [txtField setBorderStyle:UITextBorderStyleNone]; //外框类型
    txtField.autocorrectionType = UITextAutocorrectionTypeNo;
    txtField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    txtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtField.returnKeyType = UIReturnKeyDone;//返回键的类型
    txtField.keyboardType = eKeyboardType;//键盘类型
    txtField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 30.0f)];
    txtField.leftViewMode = UITextFieldViewModeAlways;
    txtField.font = [UIFont systemFontOfSize:14.0f];
    
    txtField.backgroundColor = [UIColor whiteColor];
    txtField.layer.borderWidth = 1.0f;
    txtField.layer.borderColor = [UIColor whiteColor].CGColor;
    txtField.layer.masksToBounds = NO;
    txtField.layer.cornerRadius = 0;
    
    return txtField;
}

// 下拉选择样式的按钮
+ (void)setDropdownItemBtnStyle:(UIButton *)btn
{
    [[self class] setDropdownItemBtnStyle:btn isContentAlignmentLeft:YES];
}
+ (void)setDropdownItemBtnStyle:(UIButton *)btn isContentAlignmentLeft:(BOOL)bIsAlignmentLeft
{
   // APP_ASSERT(btn);
    NSParameterAssert(btn);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [btn setBackgroundImage:[[UIImage imageNamed:@"select-g"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 15, 15)] forState:UIControlStateNormal];
    
    if (bIsAlignmentLeft)
    {
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 1, 16)];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    else
    {
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(2, 2, 1, 16)];
    }
}

// 视图添加一个光晕
+ (void)viewShowRedShadow:(UIView *)view
{
    [[self class] view:view showShadowWithColor:[UIColor redColor]];
}
+ (void)view:(UIView *)view showShadowWithColor:(UIColor *)color
{
    if (view && color)
    {
        view.layer.shadowColor = color.CGColor;
        view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        view.layer.shadowOpacity = 1;
#pragma mark --- 修改 ---
        
        view.layer.shadowRadius = 3.0;
        
    }else{}
}
+ (void)viewRemoveShadow:(UIView *)view
{
    if (view)
    {
        view.layer.shadowOpacity = 0.0f;
        view.layer.shadowRadius = 0.0f;
    }
}

// 计算两坐标点间的距离
+ (CGFloat)distanceFromLat:(CGFloat)fromLat lng:(CGFloat)fromLng toLat:(CGFloat)toLat lng:(CGFloat)toLng
{
    CLLocation *src = [[CLLocation alloc] initWithLatitude:fromLat longitude:fromLng];
    CLLocation *dest = [[CLLocation alloc] initWithLatitude:toLat longitude:toLng];
    CLLocationDistance distance = [src distanceFromLocation:dest];
    return distance;
}


+(BOOL)judgeNotification
{
    
    BOOL OpenNotification = YES;
    /*
     if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 0){
     OpenNotification = NO;
     }else if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 1){
     OpenNotification = YES;
     }else if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 2){
     OpenNotification = YES;
     }else if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 3){
     OpenNotification = YES;
     }else if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 4){
     OpenNotification = YES;
     }else if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 5){
     OpenNotification = YES;
     }else if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 6){
     OpenNotification = YES;
     }else if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == 7){
     OpenNotification = YES;
     }
     */
    return OpenNotification;
    
}

+ (NSString *)distanceStrFromLat:(CGFloat)fromLat lng:(CGFloat)fromLng toLat:(CGFloat)toLat lng:(CGFloat)toLng
{
    NSString *distanceStr = @"";
    CGFloat distance = [self.class distanceFromLat:fromLat lng:fromLng toLat:toLat lng:toLng];
    if (distance < 1000 * 1000) // 超过这个距离就不显示了
    {
        int iDistance = (int)distance;
        if (iDistance < 1000)
        {// 小于1km，显示m
            distanceStr = [NSString stringWithFormat:@"%dm", iDistance];
        }
        else
        {
            distanceStr = [NSString stringWithFormat:@"%.1fkm", iDistance/1000.0f];
        }
    }else{}
    return distanceStr;
}

// 统一生产UIFont
+ (UIFont *)createFontWithSize:(CGFloat)size
{
    return [UIFont systemFontOfSize:size];
}
+ (UIFont *)createBoldFontWithSize:(CGFloat)size
{
    return [UIFont boldSystemFontOfSize:size];
}

// 十六进制字符串转颜色
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert defaultColor:(UIColor *)defaultClr
{
   // APP_ASSERT(StringNotEmpty(stringToConvert));
    NSParameterAssert(stringToConvert);
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    UIColor *defaultColor = defaultClr ?: [UIColor whiteColor];
    
    if ([cString length] < 6)
    {
        return defaultColor;
    }
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return defaultColor;
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (NSString*)fromDateToAge:(NSDate*)date{
    
    
    NSDate *myDate = date;
    
    
    NSDate *nowDate = [NSDate date];
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    unsigned int unitFlags = NSCalendarUnitYear;
    
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:myDate toDate:nowDate options:0];
    
    
    NSInteger year = [comps year];
    
    
    return [NSString stringWithFormat:@"%ld",(long)year];
    
    
}

+(UILabel *)getNewLabelWithTextColor:(UIColor *)color font:(UIFont *)font{
    
    UILabel *label = [UILabel new];
    label.textColor = color;
    label.font = font;
    return label;
}

+ (BOOL)isAppCameraAccessAuthorized
{
    /* iOS7以上才有相机隐私控制 */
    
//    if (!isIOS7) {
//        return YES;
//    }
    

    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authStatus !=  AVAuthorizationStatusAuthorized) {
        
        return authStatus == AVAuthorizationStatusNotDetermined;
        
    }else{
        
        return YES;
    }
}

//+ (BOOL)isAppPhotoLibraryAccessAuthorized
//{
//    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
//    
//    if (authStatus != ALAuthorizationStatusAuthorized) {
//        
//        return authStatus == ALAuthorizationStatusNotDetermined;
//        
//    }else{
//        
//        return YES;
//    }
//}

//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (NSString *)priceString:(id)object
{
    NSString *priceStr = @"";
    
    if ([object isKindOfClass:[NSString class]]) {
        priceStr = object;
    }else if ([object isKindOfClass:[NSNumber class]]) {
        priceStr = [NSString stringWithFormat:@"%@", object];
    }else {
        return priceStr;
    }
    
    if ([priceStr containsString:@"."]) {
        priceStr = [NSString stringWithFormat:@"%.2f", [object floatValue]];
    }
    priceStr = [NSString stringWithFormat:@"￥%@", priceStr];
    return priceStr;
}

//+ (CGFloat)calculateTotalAmountWithAmount:(NSNumber *)amount rate:(NSNumber *)rate ratio:(NSNumber *)ratio type:(UNTradeType)type{
////    if (type == UNTradeTypeTopUp) {
////        return [amount floatValue] * [rate floatValue] * (1 + [ratio floatValue]);
////    }else {
////        return [amount floatValue] * [rate floatValue] * (1 - [ratio floatValue]);
////    }
//    return 1.0;
//}

/**
 重新解码链接，防止连接中出现中文而出现无法访问的现象
 
 @param urlString 链接
 @return 重新编码的链接
 */
+ (NSString *)encodedStringWithUrlString:(NSString *)urlString{
    if (!urlString.length) {
        return urlString;
    }
    //    NSString *charactersToEscape = @"`#%^{}\"[]|\\<> ";
    //    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    return encodedUrl;
}



@end

//
//  CommonUtils.m
//  WebServiceSample
//
//  Created by LandtoSky on 6/14/16.
//  Copyright © 2016 LandtoSky. All rights reserved.
//

#import "CommonUtils.h"
#import "KGModal.h"




@implementation CommonUtils

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


- (void)moveView:(UIView *)view withMoveX:(float)x withMoveY:(float)y{
    CGRect frame = CGRectZero;
    frame = view.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    view.frame = frame;
    
}
- (void)resizeFrame:(UIView *)object withWidth:(float)width withHeight:(float)height{
    CGRect frame = CGRectZero;
    frame.origin.x = object.frame.origin.x;
    frame.origin.y = object.frame.origin.y;
    frame.size.width = width;
    frame.size.height = height;
    object.frame = frame;
    
}


- (void)showAlert:(NSString *)title withMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)showVAlertSimple:(NSString *)title body:(NSString *)body duration:(float)duration {
    _dicAlertContent = [[NSMutableDictionary alloc] init];
    
    [_dicAlertContent setObject:title forKey:@"title"];
    [_dicAlertContent setObject:body forKey:@"body"];
    [_dicAlertContent setObject:[NSString stringWithFormat:@"%f", duration] forKey:@"duration"];
    
    
}


- (void) removeAllSubViews:(UIView *) view {
    for (long i=view.subviews.count-1; i>=0; i--) {
        [[view.subviews objectAtIndex:i] removeFromSuperview];
    }
}
- (void)setScrollViewOffsetBottom:(UIScrollView *) view {
    CGPoint bottomOffset = CGPointMake(0, view.contentSize.height - view.bounds.size.height);
    [view setContentOffset:bottomOffset animated:YES];
}

- (BOOL)checkKeyInDic:(NSString *)key inDic:(NSMutableDictionary *)dic {
    BOOL success = NO;
    id obj = dic[key];
    if ( obj != nil ) {
        if ( obj != (id)[NSNull null] ) {
            success = YES;
        }
        else {
            NSLog(@"Warning! %@ section is empty.", key);
        }
    }
    //    else {
    //        NSLog(@"Warning! %@ section is not found.", key);
    //    }
    
    return success;
}
- (NSString *)getValueByIdFromArray:(NSMutableArray *)arr idKeyFormat:(NSString *)keyIdStr valKeyFormat:(NSString *)keyValStr idValue:(NSString *)idStr {
    NSString *val = @"";
    for(NSMutableDictionary *dic in arr) {
        if([[dic objectForKey:keyIdStr] isEqualToString:idStr]) {
            val = [dic objectForKey:keyValStr];
            break;
        }
    }
    return val;
}
- (NSMutableArray *) getContentArrayFromIdsString:(NSString *)idsString withSeparator:(NSString *)separator withContentSource:(NSMutableArray *)sourceArray {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *idsArr = [idsString componentsSeparatedByString:separator];
    for(NSString *idStr in idsArr) {
        if(![idStr isEqualToString:@""] && [self checkStringNumeric:idStr]) {
            [arr addObject:[self getValueByIdFromArray:sourceArray idKeyFormat:@"id" valKeyFormat:@"name" idValue:idStr]];
        }
    }
    return arr;
}

- (id)getUserDefault:(NSString *)key {
    id val = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    //    if([val isKindOfClass:[NSMutableArray class]] && val == nil) return @"";
    if([val isKindOfClass:[NSString class]] && (val == nil || val == NULL || [val isEqualToString:@"0"])) val = nil;
    return val;
}
- (void)setUserDefault:(NSString *)key withFormat:(id)val {
    if([val isKindOfClass:[NSString class]] && [val isEqualToString:@""]) val = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:val forKey:key];
}
- (void)removeUserDefault:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (NSMutableDictionary *)getUserDefaultDicByKey:(NSString *)key {
    NSMutableDictionary *dicAll = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for(NSString *dicKey in [dicAll allKeys]) {
        if([dicKey rangeOfString:[key stringByAppendingString:@"_"]].location != NSNotFound) {
            [dic setObject:[dicAll objectForKey:dicKey] forKey:[dicKey substringFromIndex:[[key stringByAppendingString:@"_"] length]]];
        }
    }
    return dic;
}
- (void)setUserDefaultDic:(NSString *)key withDic:(NSMutableDictionary *)dic {
    NSString *newKey = @"";
    for(NSString *dicKey in [dic allKeys]) {
        //if(![[dic objectForKey:dicKey] isKindOfClass:[NSMutableArray class]]) {
        newKey = [[key stringByAppendingString:@"_"] stringByAppendingString:dicKey];
        [self setUserDefault:newKey withFormat:[dic objectForKey:dicKey]];
        //}
    }
}
- (void)removeUserDefaultDic:(NSString *)key {
    NSMutableDictionary *dicAll = (NSMutableDictionary *)[[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for(NSString *dicKey in [dicAll allKeys]) {
        if([dicKey rangeOfString:[key stringByAppendingString:@"_"]].location != NSNotFound) {
            [self removeUserDefault:dicKey];
        }
    }
}

- (NSString *)getBlankString:(NSString *)str {
    if([str isEqualToString:@"0"]) {
        return @"";
    } else {
        return str;
    }
}



- (NSMutableArray *) getPointsFromString:(NSString *)str {
    NSMutableArray *points = [[NSMutableArray alloc] init];
    NSMutableArray *itemArray = [[str componentsSeparatedByString:@","] mutableCopy];
    for(NSString *item in itemArray) {
        NSArray *pointArray = [item componentsSeparatedByString:@";"];
        NSArray *realPointArray = [[pointArray objectAtIndex:0] componentsSeparatedByString:@":"];
        [points addObject:[@{@"latitude" : [realPointArray objectAtIndex:0], @"longitude" : [realPointArray objectAtIndex:1]} mutableCopy]];
    }
    return points;
}


- (BOOL) isFormEmpty:(NSMutableArray *)array {
    BOOL isEmpty = NO;
    for(NSString *str in array) {
        if([str isEqualToString:@""] || [str isEqualToString:@"0"]) {
            isEmpty = YES;
            break;
        }
    }
    return isEmpty;
}
- (void)setFormDic:(NSMutableArray *)array toDic:(NSMutableDictionary *)formDic {
    for(NSDictionary *dic in array) {
        if(!([[dic objectForKey:@"content"] isEqualToString:@""] && [[dic objectForKey:@"content"] isEqualToString:@"0"])) {
            [formDic setObject:[dic objectForKey:@"content"] forKey:[dic objectForKey:@"key"]];
        }
    }
}
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (NSArray *)getSortedArray:(NSArray *)array {
    NSArray *keys = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return keys;
}
- (NSString *)getParamStr:(NSMutableDictionary *) dic {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    keys = [[dic allKeys] mutableCopy];
    NSString *str = @"";
    int i = 0;
    for(NSString *key in keys) {
        if(i > 0) str = [str stringByAppendingString:@"&"];
        str = [str stringByAppendingString:[key stringByAppendingString:[@"=" stringByAppendingString:[dic objectForKey:key]]]];
        i++;
    }
    return str;
}
- (BOOL)isEmptyString:(NSString *)str {
    if([str isEqualToString:@""] || [str isEqualToString:@"0"]) {
        return YES;
    } else {
        return NO;
    }
}

- (UIImage *) getImageFromDic: (NSMutableDictionary *) dic {
    UIImage *image = [[UIImage alloc] init];
    if([[dic objectForKey:@"photo_is_full_url"] isEqualToString:@"1"]) {
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"photo_link"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
    } else {
        image = [UIImage imageNamed:[dic objectForKey:@"photo_link"]];
    }
    return image;
}

- (NSMutableDictionary *)getDictionaryById:(NSMutableArray *)array withIdKey:(NSString *)idField withIdValue:(NSString *)idValue {
    NSMutableDictionary *dicResult = [[NSMutableDictionary alloc] init];
    for(NSMutableDictionary *dic in array) {
        if([[dic objectForKey:idField] isEqualToString:idValue]) {
            dicResult = dic;
            break;
        }
    }
    return dicResult;
}

- (BOOL) checkStringNumeric:(NSString *) str {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:str];
    return !!number; // If the string is not numeric, number will be nil
}
- (NSString *) removeSpaceFromString:(NSString *) str {
    //return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [str stringByReplacingOccurrencesOfString:@"\\s" withString:@""
                                             options:NSRegularExpressionSearch
                                               range:NSMakeRange(0, [str length])];
}
- (NSString *) removeCharactersFromString:(NSString *)str withFormat:(NSArray *) arr {
    NSString *s = str;
    for(NSString *c in arr) {
        s = [s stringByReplacingOccurrencesOfString:c withString:@""];
    }
    return s;
}

- (void) cropCircleImage:(UIImageView *)imageView {
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.clipsToBounds = YES;
    return;
}
- (void) setCircleBorderImage:(UIImageView *)imageView withBorderWidth:(float) width withBorderColor:(UIColor *) color {
    [imageView setClipsToBounds:YES];
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (imageView.frame.size.width), (imageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:imageView.frame.size.width/2];
    [borderLayer setBorderWidth:width];
    [borderLayer setBorderColor:[color CGColor]];
    [imageView.layer addSublayer:borderLayer];
}

- (void) setRoundedRectBorderImage:(UIImageView *)imageView withBorderWidth:(float) width withBorderColor:(UIColor *) color withBorderRadius:(float)radius {
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = radius;
    
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (imageView.frame.size.width), (imageView.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:radius];
    [borderLayer setBorderWidth:width];
    [borderLayer setBorderColor:[color CGColor]];
    [imageView.layer addSublayer:borderLayer];
}


- (void) cropCircleButton:(UIButton *)button {
    button.clipsToBounds = YES;
    button.layer.cornerRadius = button.frame.size.width / 2.0f;
}
- (void) setCircleBorderButton:(UIButton *)button withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color {
    button.clipsToBounds = YES;
    button.layer.cornerRadius = button.frame.size.width / 2.0f;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = borderWidth;
}
- (void) setRoundedRectBorderButton:(UIButton *)button withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color withBorderRadius:(float)radius{
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = borderWidth;
}

- (void) setRoundedRectBorderView:(UIView *)view withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color withBorderRadius:(float)radius{
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = borderWidth;
}

- (void) setRoundedRectView:(UIView *)view withCornerRadius:(float)radius{
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

- (void) setRoundedRectRayer:(CALayer *)layer withCornerRadius:(float)radius withBorderWidth:(float)borderWidth{
    [layer setCornerRadius:radius];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:borderWidth];
}


- (void)setButtonMultiLineText:(UIButton *)button {
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (void) setTextFieldBorder:(UITextField *)textField withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius {
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = width;
    textField.layer.cornerRadius = radius;
    textField.layer.masksToBounds = true;
}
- (void) setTextFieldMargin:(UITextField *)textField valX:(float)x valY:(float)y valW:(float)w valH:(float)h {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}
- (void) setTextViewBorder:(UITextView *)textView withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius {
    textView.layer.borderColor = color.CGColor;
    textView.layer.borderWidth = width;
    textView.layer.cornerRadius = radius;
    textView.layer.masksToBounds = true;
}
- (void) setTextViewMargin:(UITextView *)textView valX:(float)x valY:(float)y valW:(float)w valH:(float)h {
    textView.textContainerInset = UIEdgeInsetsMake(x, y, w, h);
}

- (CGFloat)getHeightForTextContent:(NSString *)text withWidth:(CGFloat)width withFontSize:(CGFloat)fontSize {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    [textView setFont:[UIFont systemFontOfSize:fontSize]];
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [textView setText:text];
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return newSize.height;
}


- (NSString *) trimString:(NSString *)str {
    NSString *str1 = str;
    NSArray* newLineChars = [NSArray arrayWithObjects:@"\\u000a", @"\\u000b",@"\\u000c",@"\\u000d",@"\\u0085",nil];
    
    for( NSString* nl in newLineChars ) {
        str1 = [str1 stringByReplacingOccurrencesOfString: nl withString:@""];
    }
    
    str1 = [str1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str1 = [self removeSpaceFromString:str1];
    return str1;
}

- (NSString *) getCombinedTextByComma:(NSMutableArray *)arr {
    NSString *text = @"";
    BOOL filled = NO;
    for(NSString *str in arr) {
        if(!([str isEqualToString:@""] || [str isEqualToString:@"0"])) {
            if(filled) text = [text stringByAppendingString:@", "];
            text = [text stringByAppendingString:str];
            filled = YES;
        }
    }
    return text;
}

- (NSMutableArray *) sortArrayByInnerDicKey:(NSMutableArray *)array withFormat:(NSString *)innerKey {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:innerKey ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    arr = [[array sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    return arr;
}

- (NSDate *)convertStringToDate:(NSString *)dateStr withFormat:(NSString *)formatStr {
    
    // convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatStr];
    return [dateFormat dateFromString:dateStr];
}

- (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)formatStr {
    
    if(date == nil) {
        return @"";
    }
    // convert date object to string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    
    // optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [formatter stringFromDate:date];
}



// Scale image to the specified size
- (UIImage *)cropImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    double ratio;
    double delta;
    CGPoint offset;
    
    double hRatio = newSize.width / image.size.width;
    double vRatio = newSize.height / image.size.height;
    
    // figure out if scaled image offset
    if (hRatio > vRatio) {
        ratio = hRatio;
        delta = (ratio * image.size.height - newSize.height);
        offset = CGPointMake(0, delta / 2);
    } else {
        ratio = vRatio;
        delta = (ratio * image.size.width - newSize.width);
        offset = CGPointMake(delta / 2, 0);
    }
    
    // make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width),
                                 (ratio * image.size.height));
    
    // start a new context, with scale factor 0.0 so retina displays get
    // high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSString *)getContentTypeForImageData:(NSData *)data {
    
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @".jpeg";
        case 0x89:
            return @".png";
        case 0x47:
            return @".gif";
        case 0x49:
            break;
        case 0x42:
            return @".bmp";
        case 0x4D:
            return @".tiff";
    }
    return nil;
}

- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}




- (NSString *)encodeMediaPathToBase64String:(NSString *)mediaPath {
    NSString *media = @"";
    NSData *data = [NSData dataWithContentsOfFile:mediaPath];
    //    media = [NSString base64StringFromData:data length:[data length]];
    media = [data base64EncodedStringWithOptions:0];
    //    photo = [photo stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    return media;
    //return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (NSString *)getJsonStringFromDic:(NSMutableDictionary *)array {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
- (void)showActivityIndicator:(UIView *)inView {
    if (activityIndicator) {
        return;
        //        [self hideActivityIndicator];
    }
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setHidden:NO];
    activityIndicator.center = inView.center;
    activityIndicator.color = appController.appMainColor;
    [activityIndicator startAnimating];
    [activityIndicator.layer setZPosition:999];
    [inView addSubview:activityIndicator];
    //        [inView setUserInteractionEnabled:NO];
}

- (UIActivityIndicatorView *)showActivityIndicatorInView:(UIView *)inView {
    for (UIView *subView in [inView subviews]) {
        if ([subView isKindOfClass:[UIActivityIndicatorView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    UIActivityIndicatorView * tempActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [tempActivityIndicator setHidden:NO];
//    tempActivityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);
    tempActivityIndicator.center = inView.center;
    tempActivityIndicator.color = [UIColor lightGrayColor];
    [tempActivityIndicator startAnimating];
    [tempActivityIndicator.layer setZPosition:999];
    tempActivityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

    [inView addSubview:tempActivityIndicator];
    return tempActivityIndicator;
}
- (void)hideActivityIndicator:(UIActivityIndicatorView *)tempActivityIndicator {
    [tempActivityIndicator setHidden:YES];
    [tempActivityIndicator removeFromSuperview];
    tempActivityIndicator = nil;
}



- (void)showActivityIndicatorColored:(UIView *)inView {
    //    [[ActivityIndicator currentIndicator] show];
    if (activityIndicator) {
        [self hideActivityIndicator];
    }
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setHidden:NO];
    activityIndicator.center = inView.center;
    activityIndicator.color = appController.appMainColor;
    [activityIndicator startAnimating];
    [activityIndicator.layer setZPosition:999];
    [inView addSubview:activityIndicator];
    //    [inView setUserInteractionEnabled:NO];
}

- (void)showActivityIndicatorThird:(UIView *)inView {
    //    [[ActivityIndicator currentIndicator] show];
    if (activityIndicator) {
        [self hideActivityIndicator];
    }
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setHidden:NO];
    activityIndicator.center = inView.center;
    activityIndicator.color = appController.appMainColor;
    [activityIndicator startAnimating];
    [activityIndicator.layer setZPosition:999];
    [inView addSubview:activityIndicator];
    //    [inView setUserInteractionEnabled:NO];
}

- (void)hideActivityIndicator {
    //    [[ActivityIndicator currentIndicator] hide];
    //    [activityIndicator.superview setUserInteractionEnabled:YES];
    [activityIndicator setHidden:YES];
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
}

- (void)customizeNavigationBar:(UIViewController *)view hideBackButton:(BOOL) option {
    [view.navigationItem setHidesBackButton:option];
    UINavigationController *navController = view.navigationController;
    [navController.navigationItem setHidesBackButton:option];
    
    navController.navigationBar.translucent = YES;
    navController.navigationBar.barTintColor = [UIColor whiteColor];
    navController.navigationBar.tintColor = [UIColor whiteColor];
    //[navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"Arial" size: 21.0f]}];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize: 18.0f]}];
    [navController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

#pragma mark - Common Httl Request Methods

- (NSUInteger) smallerOfTwoValues:(NSUInteger)firstValue withSecondeValue:(NSUInteger)secondValue{
    return firstValue > secondValue ? secondValue: firstValue;
}

- (NSString *)extractYoutubeID:(NSString *)link{
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}


-(NSString *)getCurrentDate{
    
    //Get current date
    NSDate *date = [NSDate date];
    // format it
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    // convert it to a string
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return  dateString;
}
- (NSString *) getDifferenceBetweenTwoDate:(NSString*)startDate toDate:(NSString *)endDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"MMM dd,yyyy hh:mm a"];
    NSDate *startDateFromString = [[NSDate alloc] init];
    NSDate *endDateFromString = [[NSDate alloc] init];
    // voila!
    startDateFromString = [dateFormatter dateFromString:startDate];
    endDateFromString = [dateFormatter dateFromString:endDate];
    
    NSTimeInterval distanceBetweenDates = [endDateFromString timeIntervalSinceDate:startDateFromString];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    return [NSString stringWithFormat:@"%lu", (long)hoursBetweenDates];
}

// Split nsstring as fixed length and add nsarry

-(NSArray *)arrayBySplittingWithMaximumSize:(NSString *)strData withLength:(NSUInteger)size
{
    NSMutableArray *letterArray = [NSMutableArray array];
    [strData enumerateSubstringsInRange:NSMakeRange(0, [strData length])
                                options:(NSStringEnumerationByComposedCharacterSequences)
                             usingBlock:^(NSString *substring,
                                          NSRange substringRange,
                                          NSRange enclosingRange,
                                          BOOL *stop) {
                                 [letterArray addObject:substring];
                             }];
    
    
    NSMutableArray *array = [NSMutableArray array];
    [letterArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx%size == 0) {
            [array addObject: [NSMutableString stringWithCapacity:size]];
        }
        NSMutableString *string = [array objectAtIndex:[array count]-1];
        [string appendString:obj];
        
    }];
    
    return array;
}
- (NSString *) stringToPhoneNumFormat:(NSString *) phoneNumString{
    
    NSString *result;
    
    if ([[phoneNumString substringToIndex:1] isEqualToString:@"1"]) {
        
        phoneNumString = [phoneNumString substringFromIndex:1];
    }
    
    if (phoneNumString.length <= 3) {
        return phoneNumString;
    }
    if ( 3 < phoneNumString.length && phoneNumString.length <= 6){
        
        result = [NSString stringWithFormat: @"%@-%@", [phoneNumString substringWithRange:NSMakeRange(0,3)],[phoneNumString substringWithRange:NSMakeRange(3,phoneNumString.length - 3)]];
    }else{
        
        result = [NSString stringWithFormat: @"%@-%@-%@", [phoneNumString substringWithRange:NSMakeRange(0,3)],[phoneNumString substringWithRange:NSMakeRange(3,3)],
                  [phoneNumString substringWithRange:NSMakeRange(6,phoneNumString.length - 6)]];
    }
    return result;
}

// Compare two url
- (BOOL)isEqualURL:(NSString *)aURLStr compareURL:(NSString *)bURLStr{
    
    NSURL *aURL = [NSURL URLWithString:aURLStr];
    NSURL *bURL = [NSURL URLWithString:bURLStr];
    
    if ([aURL isEqual:bURL]) return YES;
    if ([[aURL scheme] caseInsensitiveCompare:[bURL scheme]] != NSOrderedSame) return NO;
    if ([[aURL host] caseInsensitiveCompare:[bURL host]] != NSOrderedSame) return NO;
    
    // NSURL path is smart about trimming trailing slashes
    // note case-sensitivty here
    if ([[aURL path] compare:[bURL path]] != NSOrderedSame) return NO;
    
    // at this point, we've established that the urls are equivalent according to the rfc
    // insofar as scheme, host, and paths match
    
    // according to rfc2616, port's can weakly match if one is missing and the
    // other is default for the scheme, but for now, let's insist on an explicit match
    if ([aURL port] || [bURL port]) {
        if (![[aURL port] isEqual:[bURL port]]) return NO;
        if (![[aURL query] isEqual:[bURL query]]) return NO;
    }
    
    // for things like user/pw, fragment, etc., seems sensible to be
    // permissive about these.
    
    if (! [[self extractYoutubeID:aURLStr] isEqualToString:[self extractYoutubeID:bURLStr]] ) {
        return NO;
    }
    
    
    return YES;
    
}
- (void) swapTwoElementsInArray:(NSMutableArray*) array index1:(NSUInteger)index1 index2:(NSUInteger)index2{
    
    id tempObject = [array objectAtIndex:index1];
    [array replaceObjectAtIndex:index1 withObject:[array objectAtIndex:index2]];
    [array replaceObjectAtIndex:index2 withObject:tempObject];
    
}

- (NSString *) getYoutubeThumbUrlStr:(NSString*) videoUrlStr{
    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:videoUrlStr options:0 range:NSMakeRange(0,videoUrlStr.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        NSString *res = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",[videoUrlStr substringWithRange:result.range]];
        return res;
    }
    return nil;
    
    
}

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, 20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}




- (NSString *)getDeviceUDID{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *udidString;
    udidString = [defaults objectForKey:@"deviceID"];
    
    if(!udidString)
    {
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        udidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        
        [defaults setObject:udidString forKey:@"deviceID"];
        [defaults synchronize];
    }
    return udidString;
}

- (void) multileButtonActions:(UIButton *)sender inButtons:(NSArray *)btns{
    for (UIButton* btn in btns) {
        if (btn == sender) {
            [btn setBackgroundColor:[UIColor blackColor]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
}

- (void) overlayGradientView:(UIView*) view
{
    // Gradient Background
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[appController.appGradientTopColor CGColor], (id)[appController.appGradientBottomColor CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
    
}



- (void) dropDownShadowInView:(UIView*) view {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    view.layer.shadowOpacity = .7;
    view.layer.shadowRadius = 3.0f;
    view.layer.cornerRadius = 7.0f;
//    view.layer.shouldRasterize = YES;
    view.layer.shadowPath = shadowPath.CGPath;
}


/* Get "$$$$" with different color attribute */
- (NSAttributedString*) getPriceStr:(NSInteger) priceNumber withColor:(UIColor*) color withFontSize:(CGFloat)fontSize
{
    
    NSDictionary *whiteAttrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"DIN-Bold" size:fontSize],
                               NSForegroundColorAttributeName : color
                               };
    
    NSDictionary *grayAttrDict = @{
                                    NSFontAttributeName : [UIFont fontWithName:@"DIN-Bold" size:fontSize],
                                    NSForegroundColorAttributeName : [UIColor lightGrayColor]
                                    };
    
    
    NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc] initWithString:@"$$$$"];
    [resultStr setAttributes:whiteAttrDict range:NSMakeRange(0, priceNumber)];
    [resultStr setAttributes:grayAttrDict range:NSMakeRange(priceNumber,resultStr.length - priceNumber)];
    
    return resultStr;
}


// Get rounded string from distance float value
- (NSString*)getRoundedString:(float) distanceValue
{
    CGFloat nearest = floorf(distanceValue * 10 + 0.5) / 10;
    return [NSString stringWithFormat:@"%.1fmi", nearest];
    
}


- (NSMutableArray*) getKeyArrayFromArray:(NSString*)keyStr fromArray:(NSMutableArray*) fromArray
{
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dic in fromArray) {
        
        if ([dic[@"photo_type"] isEqualToString:keyStr]) {
            [results addObject:dic];
        }
    }
    
    return results;
}

/* Get Array from Whole String with separator as comma */

- (NSMutableArray*) getStringArrayFromWholeString:(NSString*)fromStr withSeparatorStr:(NSString*)separator{
    
    // Remove space from fromStr
    NSString *tempStr = [fromStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *tempArray = [tempStr componentsSeparatedByString:separator];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(NSString *temp in tempArray) {
        if(![temp isEqualToString:@""]) {
            [result addObject:temp];
        }
    }
    return result;
}


- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (BOOL) checkStringIsNull:(NSString*)str {
    
    if ([str isEqual:[NSNull null]] || str.length == 0){
        return NO;
    }
    return YES;
        
}

@end

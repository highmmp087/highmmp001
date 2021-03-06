//
//  CommonUtils.h
//  WebServiceSample
//
//  Created by LandtoSky on 6/14/16.
//  Copyright © 2016 LandtoSky. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonUtils : NSObject{
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) NSMutableDictionary *dicAlertContent;

+ (instancetype)shared;

- (void)moveView:(UIView *)view withMoveX:(float)x withMoveY:(float)y;
- (void) resizeFrame:(UIView *)object withWidth:(float)width withHeight:(float)height;
- (void)showAlert:(NSString *)title withMessage:(NSString *)message;
- (void)showVAlertSimple:(NSString *)title body:(NSString *)body duration:(float)duration;

- (void)removeAllSubViews:(UIView *) view;
- (void)setScrollViewOffsetBottom:(UIScrollView *) view;

- (BOOL)checkKeyInDic:(NSString *)key inDic:(NSMutableDictionary *)dic;
- (NSString *)getValueByIdFromArray:(NSMutableArray *)arr idKeyFormat:(NSString *)keyIdStr valKeyFormat:(NSString *)keyValStr idValue:(NSString *)idStr;
- (NSMutableArray *) getContentArrayFromIdsString:(NSString *)idsString withSeparator:(NSString *)separator withContentSource:(NSMutableArray *)sourceArray;

- (NSString *)getUserDefault:(NSString *)key;
- (void)setUserDefault:(NSString *)key withFormat:(NSString *)val;
- (void)removeUserDefault:(NSString *)key;

- (NSMutableDictionary *)getUserDefaultDicByKey:(NSString *)key;
- (void)setUserDefaultDic:(NSString *)key withDic:(NSMutableDictionary *)dic;
- (void)removeUserDefaultDic:(NSString *)key;

- (NSString *)getBlankString:(NSString *)str;
- (void) cropCircleImage:(UIImageView *)imageView;
- (void) setCircleBorderImage:(UIImageView *)imageView withBorderWidth:(float)width withBorderColor:(UIColor *)color;
- (void) setRoundedRectBorderImage:(UIImageView *)imageView withBorderWidth:(float)width withBorderColor:(UIColor *)color withBorderRadius:(float)radius;

- (void) cropCircleButton:(UIButton *)button;
- (void) setCircleBorderButton:(UIButton *)button withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color;
- (void) setRoundedRectBorderButton:(UIButton *)button withBorderWidth:(float)width withBorderColor:(UIColor *)color withBorderRadius:(float)radius;

- (void) setRoundedRectView:(UIView *)view withCornerRadius:(float)radius;
- (void) setRoundedRectBorderView:(UIView *)view withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color withBorderRadius:(float)radius;
- (void) setRoundedRectRayer:(CALayer *)layer withCornerRadius:(float)radius withBorderWidth:(float)borderWidth;

- (void) setButtonMultiLineText:(UIButton *)button;

- (void) setTextFieldBorder:(UITextField *)textField withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius;
- (void) setTextFieldMargin:(UITextField *)textField valX:(float)x valY:(float)y valW:(float)w valH:(float)h;
- (void) setTextViewBorder:(UITextView *)textView withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius;
- (void) setTextViewMargin:(UITextView *)textView valX:(float)x valY:(float)y valW:(float)w valH:(float)h;

- (NSMutableArray *) getPointsFromString:(NSString *)str;

- (BOOL) checkStringNumeric:(NSString *) str;
- (NSString *) removeSpaceFromString:(NSString *) str;
- (NSString *) removeCharactersFromString:(NSString *)str withFormat:(NSArray *) arr;
- (NSString *) trimString:(NSString *)str;

- (NSString *) getCombinedTextByComma:(NSMutableArray *)arr;

- (CGFloat)getHeightForTextContent:(NSString *)text withWidth:(CGFloat)width withFontSize:(CGFloat)fontSize;

- (BOOL)isFormEmpty:(NSMutableArray *)array;
- (void)setFormDic:(NSMutableArray *)array toDic:(NSMutableDictionary *)formDic;
- (BOOL)validateEmail:(NSString *)emailStr;
- (NSArray *)getSortedArray:(NSArray *)array;

- (BOOL)isEmptyString:(NSString *)str;

- (NSString *)getParamStr:(NSMutableDictionary *) dic;
- (UIImage *) getImageFromDic: (NSMutableDictionary *) dic;
- (NSMutableDictionary *)getDictionaryById:(NSMutableArray *)array withIdKey:(NSString *)idField withIdValue:(NSString *)idValue;

- (NSDate *)convertStringToDate:(NSString *)dateStr withFormat:(NSString *)formatStr;
- (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)formatStr;

- (UIImage *)cropImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (NSString *)getContentTypeForImageData:(NSData *)data;
- (NSString*)base64forData:(NSData*)theData;
- (NSString *)encodeMediaPathToBase64String:(NSString *)mediaPath;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
- (NSString *)getJsonStringFromDic:(NSMutableDictionary *)array;

- (void)showActivityIndicator:(UIView *)inView;
- (void)showActivityIndicatorColored:(UIView *)inView;
- (void)showActivityIndicatorThird:(UIView *)inView;
- (void)hideActivityIndicator;


- (void)customizeNavigationBar:(UIViewController *)view hideBackButton:(BOOL) option;


// Select smaller value of two integer values
- (NSUInteger) smallerOfTwoValues:(NSUInteger)firstValue withSecondeValue:(NSUInteger)secondValue;
- (NSString *)extractYoutubeID:(NSString *)youtubeURL;
- (NSString *) getCurrentDate;
- (NSString *) getDifferenceBetweenTwoDate:(NSString*)startDate toDate:(NSString *)endDate;
-(NSArray *)arrayBySplittingWithMaximumSize:(NSString *)strData withLength:(NSUInteger)size;

// Custom ActivityIndicator

- (UIActivityIndicatorView *)showActivityIndicatorInView:(UIView *)inView ;
- (void)hideActivityIndicator:(UIActivityIndicatorView *)tempActivityIndicator;

// NSString -> Phone number format 23434134123 -> 234-234- 5232
- (NSString *) stringToPhoneNumFormat:(NSString *) phoneNumString;
// Compare two url
- (BOOL)isEqualURL:(NSString *)aURLStr compareURL:(NSString *)bURLStr;
- (void) swapTwoElementsInArray:(NSMutableArray*) array index1:(NSUInteger)index1 index2:(NSUInteger)index2;
- (NSString *) getYoutubeThumbUrlStr:(NSString*) videoUrlStr;
//- (void)activityCreateEditInit;
- (CGFloat)getLabelHeight:(UILabel*)label;

- (NSString *)getDeviceUDID;

@end

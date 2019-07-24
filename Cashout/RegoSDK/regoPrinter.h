//
//  regoPrinter.h
//  PrintSDK_iOS
//
//  Created by Chen Sunny on 16/3/21.
//  Copyright © 2016年 Chen Sunny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "preDefiniation.h"
#import <UIKit/UIKit.h>


@interface regoPrinter : NSObject


{
    CGPDFDocumentRef pdf;
    
}
@property (strong,nonatomic) NSString *stringName;
@property (nonatomic) BOOL isOK;

+(id)shareManager;

/*
 *  初试化打印库
 *
 *  参数:
 *      printType PrintType枚举型实例变量，确定打印机接口类型
 *
 *  返回:
 *      0 操作成功；1 操作失败
 */
-(int) CON_InitLib:(PrintType)printType;

/*
 * 获取SDK支持的页模式下的数据发送类型
 *
 *  返回:
 *      0 操作成功；1 操作失败
 */
- (NSArray *) CON_GetSupportPageMode;

/*
 * 获取SDK支持的打印机类型
 *
 *  返回:
 *      0 操作成功；1 操作失败
 */
- (NSArray *) CON_GetSupportPrinters;

//获取所有打印机名称
- (NSArray *)CON_AllPrinterName DEPRECATED_MSG_ATTRIBUTE("不建议使用，建议使用-(NSArray *) CON_GetSupportPrinters方法替换");

/**
 *  获取无线设备，只针对蓝牙, WIFI有效
 *
 *  @param type 无线设备类型 0 蓝牙(获取当前系统绑定的蓝牙打印机); 1 WIFI(RG-WP200无线打印服务器接入的打印机)
 *
 */
- (void) CON_GetWirelessDevices:(int)type parentObject:(NSObject *)parentObject;

/*
 * 向蓝牙打印机发起连接请求
 *
 * 参数:
 *      parentObject    设置代理，在客户端代理函数”PrinterFound“获取已经搜索到的蓝牙打印机
 *
 */
-(void)CON_GetRemoteBTPrinters:(NSObject *)parentObject;
-(void)CON_GetRemoteWIFIPrinters;


/*
 * 卸载打印库
 *
 *  返回:
 *      0 操作成功；1 操作失败
 */
-(int) CON_FreeLib;


/*
 *  连接打印机
 *
 *  蓝牙单连接，同一系统的两个设备，只能一个和设备连接；只有断开另外一个设备才可以连接；
 *  wifi短连接，长时间不操作wifi会自动断开，建议每单打印流程：连接-打印-关闭
 *  参数:
 *      strNames    连接蓝牙打印机的名称，在代理函数”PrinterFound“获取已经搜索到的蓝牙打印机
 *
 * 返回:
 *      0 发起连接请求失败
 *      1 发起连接请求成功
 */
-(int) CON_ConnectDevices:(NSString *)port mTimeout:(int)timeout;

/*
 * 关闭端口连接,清除连接对象
 *
 * 返回:
 *      0 断开连接失败
 *      1 成功断开连接
 */
-(int)CON_CloseDevice: (int)objCode;


/*
 * 进入打印模式，连接成功后调用本函数去开启打印功能，调用以"ASCII"为前缀的文本打印函数和以"DRAW_"为前缀的绘图打印函数， 最后调用CON_PageEnd() 结束页面打印文本或图形数据
 *
 *   objCode - 某个打开的端口对象
     graphicMode - 是否采用图形模式打印，false采用打印机内置字体打印内容，随后的内容打印应调用文本打印函数; true采用图形方式打印，随后的内容打印可以调用文本打印函数(标签机)或图形打印函数
     width - 图形模式或标签机器的文本模式下最大打印宽度，384(58mm纸宽)或576(80mm纸宽)
     height - 图形模式或标签机器的文本模式下最大打印高度，大小没有限制的，但是当进入图形模式后，高度越高表示缓存的数据量越大，当高度超过1500时可以会引起程序缓存异常

 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int)CON_PageStart:(int)objCode graphicMode:(BOOL)graphicMode mWidth:(int)width mHeight:(int)height;

/**
 *  缓存图像和文本数据
 *
 *  @param objCode  某个打开的端口对象
 *  @param tm       TransferMode 打印传输模式
 *
 *  @return 1 操作失败    0 操作成功
 */
-(int)CON_PageEnd:(int)objCode TM:(TransferMode)tm;

/**
 *  缓存数据的发送，发送完并清除缓存
 *
 *  @param objCode 某个打开的端口对象
 *
 *  @return 1 操作失败    0 操作成功
 */
- (int)CON_PageSend:(int)objCode;

/**
 *  设置打印方向
 *
 *  @param objCode 某个打印端口对象
 *  @param direct   0正向 1反向
 *
 *  @return 1 操作失败    0 操作成功
 */
- (int)CON_SetPrintDirection:(int)objCode direct:(int)direct;

/*
 * 查询SDK版本 对应当前SDK的版本
 *
 * 返回:
 *      SDK版本
 */
-(NSString *)CON_QueryVersion;

/**
 *  查询打印机状态
 *
 *  @param objCode 某个打开的端口对象
 *
 *  @return 0 状态正常，1 打印机缺纸
 */
- (int)CON_QueryStatus:(int)objCode;

/**
 *  得实打印机返回状态
 *
 *  @param objCode 某个打开的端口对象
 *  @param type    查询类型： 0 打印机状态
 *
 *  @return -1 打印服务器连接异常；0 打印机处于联机状态； 1 打印机处于脱机状态；2打印机处于缺纸状态； 3打印机复位（初始化错误）； 4 打印机卡纸
 */
- (int)DS_QueryStatus2:(int)objCode type:(int)type;

/*
 * 页模式下打印机的横向、纵向绝对打印位置
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 *
 */
-(int)CON_AbsolutePosition:(int)objCode nL:(int)nL nH:(int)nH;


#pragma mark  -------    ASCII_:MTP58B,K532,K628   ------
/*
 * 清空打印缓冲区指令和数据
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int) ASCII_CtrlReset:(int) objCode;

/*
 * 直接发送数据缓冲区
 *
 * 参数:
 *      data    十六进制控制命令
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */

-(int) ASCII_PrintBuffer:(int)objCode mData:(NSData*) data mLen:(int)len;

/*
 * 设置打印对齐方式
 *
 * 参数:
 *      alignType   AlignType变量，表示字符打印的左、中、右字符对齐方式
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int)ASCII_CtrlAlignType:(int)objCode mAlignType:(AlignType)alignType;

/*
 * 控制打印机黑标定位
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int) ASCII_CtrlBlackMark:(int) objCode;

/*
 * 发送钱箱检测命令
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 *
 * 注意:
 *      只针对特殊机型
 */
-(int)ASCII_CtrlCashDraw:(int)objCode socketpins:(int)socket time1:(int)time1 time2:(int)time2;

/*
 * 控制打印机切纸
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int) ASCII_CtrlCutPaper:(int) objCode cutWay:(int)cutWay postion:(int)postion;
-(int) ASCII_CtrlCutHalfPaper:(int) objCode cutWay:(int)cutWay;

/*
 * 打印机进纸点行
 *
 * 参数:
 *      lienNum 进纸点行数(1mm=8dot)
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int) ASCII_CtrlFeedLines:(int)objCode mNum:(int)iNum;

/*
 * 设置反色打印
 *
 * 参数:
 *      oppositeColor 是否反色打印
 *
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int)ASCII_CtrlOppositeColor:(int)objCode mOpposite:(Boolean) bOpposite;

/*
 * 打印回车换行符
 *
 * 参数:
 *      iTimes    发送回车换行符个数
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int) ASCII_CtrlPrintCRLF:(int) objCode mTimes:(int)iTimes;

/*
 * 设置打印左边距或宽度
 *
 * 参数:
 *      leftMargin  左边距
 *      printWidth  打印宽度  最终填写的是576/512/384
 * (nL + nH × 256 ) = 576 ［80mm纸宽型号，72mm打印宽度］
 * (nL + nH × 256 ) = 512 ［80mm纸宽型号，64mm打印宽度］
 * (nL + nH × 256 ) = 384 ［58mm纸宽型号］
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int)ASCII_CtrlPrintPosition:(int)objCode mLeftMargin:(int)iLeftMargin mWidth:(int)iWidth;

/*
 * 设置打印字符格式   打印文本，倍宽、倍高、下划线、小字体不同
 */
-(int) ASCII_PrintString:(int) objCode width:(Boolean) width height:(Boolean) height bold:(Boolean) bold underline:(Boolean) underline minifont:(Boolean) minifont mStr:(NSString *)str mEncode:(NSStringEncoding)encode;

/*
 * 格式化打印字符串
 *
 * 参数:
 *      doubleWidth     倍宽打印
 *      doubleHeight    倍高打印
 *      bold            打印加粗
 *      underline       下划线
 *      minifont        是否小字体打印，不能与doubleWidth或doubleHeight同时使用
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int)ASCII_CtrlFormatString:(int)objCode mWidth:(Boolean)width mHeight:(Boolean)height mBold :(Boolean)bold mUnderLine:(Boolean)underLine mMinifont:(Boolean)minifont;


- (int)ASCII_CtrlCharactersize:(int)objCode mWidth:(int)width mHeight:(int)height mStr:(NSString *)str mEncode:(NSStringEncoding)encode;

/*
 * 发送打印字符串至打印机，打印机末尾包含回车换行符或调用ASCII_PrintCRLF()把所有的内容打印出来
 *
 * 参数:
 *      strSend    要打印的字符串
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */

-(int) ASCII_PrintString:(int)objCode mStr:(NSString *)str mEncode:(NSStringEncoding)encode;

/*
 * 制表位打印
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int)ASCII_PrintTabString:(int)objCode ;

/*
 * 设置双重打印模式
 *
 * 参数:
 *      dubPrint    是否为双重打印模式
 * //设置双重打印，yes：选择  no：取消
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int) ASCII_CtrlDuplePrint:(int)objCode mBdup:(Boolean)bdup;


/*
 * 设置打印行高
 *
 * 参数:
 *      lineSpace   行与行之间的距离
 *      最大是10 ，每段与每段之间的距离
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
-(int) ASCII_CtrlSetLineSpace:(int)objCode mLines:(int)iLines;

-(int)ASCII_ChineseFormatString:(int)objCode mWidth:(Boolean)width mHeight:(Boolean)height mBold:(Boolean)bold mUnderLine:(Boolean)underLine mMinifont:(Boolean)minifont;

/*
 * 设置检测标签纸
 *
 * 发送条码标签页指令，通常在打印处理函数后调用本函数进纸到下一个标签位置
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 *
 * 注意:
 *      只针对特殊机型
 */
-(int)ASCII_CtrlLabelPage:(int)objCode;//////

/**
 *  设置相对横向打印位置
 *
 *  @param objCode 某个打开的端口对象
 *  @param pos_x   x轴的起始位置
 *  @param pos_y   y轴的起始位置
 *
 *  @return 1 操作成功  0 操作失败
 */
- (int)ASCII2_RelativePosition:(int)objCode pos_x:(int)pos_x pos_y:(int)pos_y;

/*
 * 打印条形码
 *
 * 参数:
 *      barcodeType     BarcodeType变量，表示打印一维tiaoma类型
 *      barcodeWidth    条码宽度
 *      barcodeHeight   条码高度
 *      textPosition    条码HRI字符打印位置
 *      barcodeString
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */

-(int) ASCII_Print1DBarcode:(int)objCode mBcType:(BarcodeType)bcType mIwidth:(int)iWidth mIHeight:(int)iHeight mHRI:(Barcode1DHRI)hri mStrData:(NSString *)strData;

/*
 * 打印二维条码
 *
 * 参数:
 *      type 条码类型
 *      str      打印条码字符串
 *      size        条码大小
 *      ecc         条码ecc校验等级
 *      version     条码版本号
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */
- (int)ASCII_Print2DBarcode:(int)objCode Type:(BarcodeType)type str:(NSString *)str size:(int)size ECC:(int)ecc version:(int)version;

/*
 * 打印预存储至打印机的图片
 *
 * 参数:
 *      picNum  十六进制控制命令
 *      mode    图片打印模式 0正常 1倍宽 2倍高 3倍宽高
 *
 * 返回:
 *      1 操作失败
 *      0 操作成功
 */

-(int) ASCII_PrintFlashPic:(int)objCode mPicNum:(int )picNum mMode:(int)mode;

#pragma mark   -------------------   图形打印指令 ------------------

-(void)Draw_Circle:(CGContextRef)context rect:(CGRect)rect lineWidth:(int)lineWidth;

-(void)Draw_Line:(CGContextRef)context rect:(CGRect)rect point1:(CGPoint)p1 point2:(CGPoint)p2 lineWidth:(int)lineWidth;

-(void)Draw_Rectangle:(CGContextRef)context rect:(CGRect)rect lineWidth:(int)lineWidth;

-(void)Draw_Text:(NSArray *)array align:(AlignType)align vAlign:(VAlignType)vAlign font:(int)font;

#pragma mark ============= 
-(int)CON_PrintPicture:(UIImage*)image aDensity:(CGFloat)density;

-(void)Draw_Picture:(CGContextRef)context rect:(CGRect)rect aImage:(UIImage*)aImage;

-(void)Draw_Triangle:(CGContextRef)context point1:(CGPoint)p1 point2:(CGPoint)p2 point3:(CGPoint)p3 lineWidth:(int)lineWidth;
-(void)Draw_String:(CGContextRef)context text:(NSString *)text rect:(CGRect)rect lineWidth:(int)lineWidth font:(int)font;
-(CGContextRef)Create_Canvas:(CGRect)rect size:(CGSize)size;

-(UIImage*)Draw_getGrayImage:(UIImage*)sourceImage;

-(void)Draw_Form:(CGContextRef)context width:(int)width lineHeight:(int)lineHeight point_x:(int)pos_x point_y:(int)pos_y array:(NSArray*)array isYes:(NSArray*)isYes align:(AlignType)align vAlign:(VAlignType)vAlign;
- (UIImage*)Draw_rotateImageWithRadian:(float)radius width:(int)width height:(int)height image:(UIImage*)image;

-(int)CON_Pic_start:(int)objCode;
-(int)CON_Pic_end:(int)objCode;

//
//
-(void)Draw_Form:(CGContextRef)context width:(int)width lineHeight:(int)lineHeight point_x:(int)pos_x point_y:(int)pos_y array:(NSArray*)array isYes:(NSArray *)isYes;

#pragma mark =======斑马=====
-(int)ASCII_PrintString:(int)objCode array:(NSArray *)array;
- (int)ASCII_PrintBarcode:(int)objCode type:(BarcodeType)type array:(NSArray *)array;
-(int)ASCII_Init:(int)objCode array:(NSArray *)array;
-(int)ASCII_Enter:(int)objCode array:(NSArray *)array;
-(int)ASCII_End:(int)objCode array:(NSArray *)array;
-(int)ASCII_Area:(int)objCode array:(NSArray *)array;
-(int)ASCII_Position:(int)objCode array:(NSArray *)array;
-(int)Draw_Graphic:(int)objCode array:(NSArray *)array;
-(int)ASCII_Gap:(int)objCode array:(NSArray *)array;

- (int)ASCII_P58A_Print1DBarcode:(int)objCode mBcType:(BarcodeType)bcType mIwidth:(int)iWidth mIHeight:(int)iHeight mHRI:(Barcode1DHRI)hri mStrData:(NSString *)strData;
-(int)ASCII_P58A_CtrlFormatString:(int)objCode mUnderline:(int)underline;
-(int)ASCII_P58A_CtrlFormatString:(int)objCode mHeight:(int)height;
-(int)ASCII_P58A_CtrlFormatString:(int)objCode mWidth:(int)width;

//制表打印指令
-(int)ASCII_PrintTabPosition:(int)objCode array:(NSArray *)array;

#pragma mark -- 增加修改密度
-(void)CON_PrintPDF:(NSString *)pageName pageNumStatr:(int)pageNumStatr pageNumEnd:(int)pageNumEnd width:(int)contentW height:(int)contentH aDensity:(CGFloat)density;

-(void)CON_PrintPDFGen:(NSString *)pageName pageNumStatr:(int)pageNumStatr pageNumEnd:(int)pageNumEnd width:(int)contentW height:(int)contentH aDensity:(CGFloat)density;

-(NSString *)decipher:(NSString *)inBlock;
-(NSString *)backValue;


#pragma mark -----  CPCL指令打印方法  --------

// CPCL以 ！开始接收一条指令
-(int)ASCII_Receive:(int)objCode offset:(NSString *)offset horizontal:(NSString *)H_R vertical:(NSString *)V_R maxHeight:(NSString *)maxH maxPage:(NSString *)maxP;

// CPCL打印格式字符串
-(int)ASCII_Text:(NSString *)font size:(NSString *)size hor_position:(NSString *)h_position ver_position:(NSString *)v_position  connect:(NSString *)data;

// CPCL打印矩形指令
-(int)ASCII_Box:(NSArray *)array;

// CPCL打印线条指令
-(int)ASCII_Line:(NSArray *)array;
// 需要实现及优化
// 建议使用CPCL指令
- (int)CPCL_PrintLine:(NSArray *)array;

// CPCL打印一维条码
-(int)ASCII_Bar:(NSArray *)array;

// CPCL打印BARCODE-TEXT字符
-(int)ASCII_BarText:(NSArray *)array;
-(int)ASCII_BarOff;
// CPCL打印标签标识
-(int)ASCII_form;
// CPCL打印指令
-(int)ASCII_print;
// CPCL打印二维条码
-(int)ASCII_2dBar:(NSArray *)array;
-(int)ASCII_maData:(NSString *)stringData;
-(int)ASCII_2Data:(NSString *)stringData;
-(int)ASCII_endQR;

-(int)ASCII_pageWidth:(NSString *)width;
-(int)ASCII_gap;
// CPCL图形打印指令
-(int)ASCII_Graphice:(NSArray *)array image:(UIImage *)aImage;

// CPCL加粗指令
-(int)ASCII_blod:(NSString *)blod;

// CPCL设置反白属性
-(int)ASCII_lt:(NSString *)inverse;
/**
 *  设置反白属性_CPCl
 *
 *  @param objCode 某个打开的端口对象
 *  @param Inverse false 取消反白 true 反白
 *
 *  @return 1失败 0成功
 */
- (int)CPCL_InverseText:(int)objCode Inverse:(BOOL)Inverse;

-(int)ASCII_inverseline:(NSArray *)array;

// CPCL设置字符间距属性
-(int)ASCII_space:(NSString *)space;

// CPCL下划线指令
-(int)ASCII_underline:(NSString *)underline;

// CPCL居中指令
-(int)ASCII_center;
// CPCL居左指令
-(int)ASCII_left;
// CPCL居友指令
-(int)ASCII_right;
// CPCL打印前先退纸
-(int)ASCII_prefeed:(NSString *)prefeed;

#pragma mark =====  Mpop打印机  增加star相关指令
// 设置加倍宽加倍高 sizeH[0,5]  sizeW[0,5]
-(int)Star_Mpop_doubleWH:(int)sizeH sizeW:(int)sizeW;
// 设置对齐方式  numAlign[0,2]
-(int)Star_Mpop_align:(int)numAlign;
// 设置切纸 numCutter[0,3]
-(int)Star_Mpop_cutter:(int)numCutter;
// 设置开钱箱
-(int)Star_Mpop_openCash:(int)objCode;
// 设置打印条码 {1B 62 n1 n2 n3 n4 d1...dk RS}
// n1 : bcType条码类型[0,13]  n2:[1,14] n3[1,9] n4高度
-(int)Star_Mpop_PrintMpopBarcodeBcType:(MpopBarcodeType)bcType position:(int)bcPosition radio:(int)bcRadio barHeight:(int)barHeight mStrData:(NSString *)strData;




@end

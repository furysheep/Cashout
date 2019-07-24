//
//  preDefiniation.h
//  PrintSDK_iOS
//
//  Created by Chen Sunny on 16/3/21.
//  Copyright © 2016年 Chen Sunny. All rights reserved.
//

#ifndef preDefiniation_h
#define preDefiniation_h


#endif /* preDefiniation_h */

/*
 * 打印文本对齐方式
 */
typedef enum {
    AT_LEFT,
    AT_CENTER,
    AT_RIGHT
}AlignType;

/*
 * 垂直对齐方式
 */
typedef enum {
    VT_TOP,
    VT_MIDDLE,
    VT_BOTTOM
}VAlignType;


/*
 * 条码打印类型
 */
typedef enum  {
    BT_UPCA    = 65,
    BT_UPCE    = 66,
    BT_EAN13   = 67,
    BT_EAN8    = 68,
    BT_CODE39  = 69,
    BT_CODEITF     = 70,
    BT_CODEBAR = 71,
    BT_CODE93  = 72,
    BT_CODE128 = 73,
    BT_QRcode          = 97,
    BT_DATAMATIC  = 98,
    BT_PDF417      = 99
}BarcodeType;

/*
 * Star条码打印类型
 */
typedef enum  {
    MP_UPCE    = 0,
    MP_UPCA    = 1,
    MP_EAN8   = 2,
    MP_EAN13    = 3,
    MP_CODE39  = 4,
    MP_CODEITF     = 5,
    MP_CODE128 = 6,
    MP_CODE93  = 7,
    MP_NW7 = 8,
    MP_GS128 = 9,
    MP_GSOmnidirectional = 10,
    MP_GSTruncated = 11,
    MP_GSLimited = 12,
    MP_GSExpanded = 13
    
}MpopBarcodeType;



/*
 * 条码字符打印位置
 */
typedef enum {
    BH_NO,
    BH_UNDER,
    BH_BLEW
}Barcode1DHRI;

typedef enum {
    BW_1,
    BW_2,
    BW_3,
    BW_4
}Barcode1DWidth;
/*
 *图像选区旋转角度
 */
typedef enum {
    RA_0,
    RA_90,
    RA_180,
    RA_270
} RotatAngle;


/*!
 * 打印速度（打印速度，_PS_SPEED_DEFAULT 由系统决定打印速度快慢）
 * _PS_SPEED_1 最低 _PS_SPEED_5 最高
 */
typedef enum {
    _PS_SPEED_DEFAULT=0,
    _PS_SPEED_1,
    _PS_SPEED_2,
    _PS_SPEED_3,
    _PS_SPEED_4,
    _PS_SPEED_5,
    _PS_SPEED_6,
    _PS_SPEED_7,
    _PS_SPEED_8,
    _PS_SPEED_9,
    _PS_SPEED_10
}PrintSpeed;

/*
 * 打印接口类型
 */
typedef enum {
    _PT_BLUETOOTH,
    _PT_WIFI
}PrintType;

/*
 * 打印机型号，目前就这一种
 */
typedef enum {
    _PM_TP58B,
    _PM_WP200
} PrintModule;
/*
 * 页模式下的打印方式
 */

typedef enum {
    PM_GRAPHIC,
    PM_TEXT
}PageMode;

/*!
 * 打印机状态
 */
typedef enum {
    PS_PRINTER = 1,
    PS_OFFLINE = 2,
    PS_ERROR = 3,
    PS_PAPEROUT = 4,
}PrinterStatus;

typedef enum {
    TM_NONE,
    TM_DT_V1,
    TM_DT_V2
    
}TransferMode;




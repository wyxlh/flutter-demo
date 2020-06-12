package com.yzsh.power.client.net;

public class HttpUtil {
    private static final int NET_DEVELOP_TYPE = 0;//开发环境
    private static final int NET_TEST_TYPE = 1;//测试环境
    private static final int NET_FORMAL_TYPE = 2;//正式环境
    private static int netType = NET_FORMAL_TYPE;//发布前修改环境

    protected static String getURL() {
        switch (netType) {
            case NET_DEVELOP_TYPE:
                return "http://dev.jx9n.cn:10001/";
            case NET_TEST_TYPE:
                return "http://test.jx9n.cn:10001/";
            case NET_FORMAL_TYPE:
                return "https://prod.jx9n.com/";
            default:
                return "";
        }
    }

    protected static String getOldURL() {
        switch (netType) {
            case NET_DEVELOP_TYPE:
                return "http://39.106.62.16:8181/api/";
            case NET_TEST_TYPE:
                return "http://test.old.jx9n.cn/api/";
            case NET_FORMAL_TYPE:
                return "http://yzcapp.jx9n.com/api/";
            default:
                return "";
        }
    }

    public static String getH5URL() {
        switch (netType) {
            case NET_DEVELOP_TYPE:
                return "http://dev.jx9n.cn/yzc_business_h5/page/";
            case NET_TEST_TYPE:
                return "http://test.jx9n.cn/yzc_business_h5/page/";
            case NET_FORMAL_TYPE:
                return "https://prod.h5.jx9n.com/yzc_business_h5/page/";
            default:
                return "";
        }
    }

    public static String getH5MallURL() {
        switch (netType) {
            case NET_DEVELOP_TYPE:
                return "http://dev.jx9n.cn/yzc-union-fe/page/";
            case NET_TEST_TYPE:
                return "http://prod.h5.jx9n.com/yzc-union-fe/page/";
            case NET_FORMAL_TYPE:
                return "http://prod.h5.jx9n.com/yzc-union-fe/page/";
            default:
                return "";
        }
    }
}

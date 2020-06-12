package com.yzsh.power.client.utils;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.HashMap;
import java.util.Map;

import io.reactivex.annotations.NonNull;

public final class SPUtils {
    private static final Map<String, SPUtils> SP_UTILS_MAP = new HashMap<>();
    private SharedPreferences sp;
    //sp对应的各个key
    public static final String isGuideEnter = "isGuideEnter";
    public static final String YZC_USRE_ID = "yzc_uuid";
    public static final String YZC_PASSWORD = "yzc_password";
    public static final String YZC_PHONE = "yzc_phone";
    public static final String LONGITUDE = "longitude";//精度
    public static final String LATITUDE = "latitude";//维度
    public static final String INPUT_CHARGE = "first_input_charge";//第一次打开充电界面
    public static final String MALL_HOME_TIMESTAMP = "mall_home_timestamp";//商城首页的时间戳保存

    public void putKeyValue(String key, Object object) {
        SharedPreferences.Editor editor = sp.edit();

        if (object instanceof String) {
            editor.putString(key, (String) object);
        } else if (object instanceof Integer) {
            editor.putInt(key, (Integer) object);
        } else if (object instanceof Boolean) {
            editor.putBoolean(key, (Boolean) object);
        } else if (object instanceof Float) {
            editor.putFloat(key, (Float) object);
        } else if (object instanceof Long) {
            editor.putLong(key, (Long) object);
        } else {
            editor.putString(key, object.toString());
        }
        editor.apply();
    }

    public Object getValueByKey(String key, Object object) {
        if (object instanceof String) {
            return sp.getString(key, (String) object);
        } else if (object instanceof Integer) {
            return sp.getInt(key, (Integer) object);
        } else if (object instanceof Boolean) {
            return sp.getBoolean(key, (Boolean) object);
        } else if (object instanceof Float) {
            return sp.getFloat(key, (Float) object);
        } else if (object instanceof Long) {
            return sp.getLong(key, (Long) object);
        } else {
            return sp.getString(key, object.toString());
        }
    }

    public String getStringByKey(String key) {
        return sp.getString(key, "");
    }

    public long getLongByKey(String key) {
        return sp.getLong(key, 0);
    }

    public int getIntByKey(String key) {
        return sp.getInt(key, -1);
    }

    public boolean getBooleanByKey(String key) {
        return sp.getBoolean(key, false);
    }

    public static SPUtils getInstance(Context context) {
        String spName = "yzc";//sp的表名
        SPUtils spUtils = SP_UTILS_MAP.get(spName);
        if (spUtils == null) {
            synchronized (SPUtils.class) {
                spUtils = SP_UTILS_MAP.get(spName);
                if (spUtils == null) {
                    spUtils = new SPUtils(spName, context);
                    SP_UTILS_MAP.put(spName, spUtils);
                }
            }
        }
        return spUtils;
    }

    private SPUtils(final String spName, Context context) {
        sp = context.getSharedPreferences(spName, Context.MODE_PRIVATE);
    }

    public void remove(@NonNull final String key) {
        sp.edit().remove(key).apply();
    }

    public void clear() {
        sp.edit().clear().apply();
    }

    private static boolean isSpace(final String s) {
        if (s == null) return true;
        for (int i = 0, len = s.length(); i < len; ++i) {
            //isWhitespace() 方法用于判断指定字符是否为空白字符，空白符包含：空格、tab 键、换行符。
            if (!Character.isWhitespace(s.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    public static void logoutRemoveData(Context context) {
        SPUtils.getInstance(context).remove(SPUtils.YZC_USRE_ID);
        SPUtils.getInstance(context).remove(SPUtils.INPUT_CHARGE);
        SPUtils.getInstance(context).remove(SPUtils.YZC_PASSWORD);
    }
}

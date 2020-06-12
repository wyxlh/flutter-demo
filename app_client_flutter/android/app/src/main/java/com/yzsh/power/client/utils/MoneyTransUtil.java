package com.yzsh.power.client.utils;

import java.text.DecimalFormat;

public class MoneyTransUtil {
    public static String transMoney(int money) {//money以分为单位
        if (money % 100 == 0) {
            return String.valueOf(money / 100);
        } else if (money % 10 == 0) {
            return String.valueOf(money / 100.0);
        } else {
            return String.valueOf(money / 100.00);
        }
    }

    public static String transMoneyDecimal(int money) {//money以分为单位,保留两位小数
        return new DecimalFormat("#0.00").format(money / 100.00);
    }
}
package com.yzsh.power.client.configure.data.resq;

import java.io.Serializable;
import java.util.List;

import com.yzsh.power.client.utils.MoneyTransUtil;

public class HomeResq implements Serializable {

    /**
     * income : 37111.16
     * usage : null
     * dayIncome : 100
     * count : 41
     * list : [{"typeId":1,"title":"我的充电桩","detail":"实时查看充电桩","imgUrl":"http://image.jx9n.com/wuliCdz.png","goUrl":"http://"},{"typeId":2,"title":"我的收入","detail":"收入详情","imgUrl":"http://image.jx9n.com/wuliSr.png","goUrl":"http://"},{"typeId":3,"title":"我的钱包","detail":"了解钱包进账","imgUrl":"http://image.jx9n.com/wuliQb.png","goUrl":"http://"},{"typeId":4,"title":"我的片区","detail":"片区管理一目了然","imgUrl":"http://image.jx9n.com/group.png","goUrl":"原生"},{"typeId":5,"title":"充电桩申请","detail":"充电桩申请情况","imgUrl":"http://image.jx9n.com/shenqing.png","goUrl":"原生"},{"typeId":6,"title":"我的合伙人","detail":"合伙人详情","imgUrl":"http://image.jx9n.com/HHR.png","goUrl":"http://"},{"typeId":7,"title":"资料包","detail":"资料统一管理","imgUrl":"http://image.jx9n.com/ZLB.png","goUrl":"http://"}]
     */

    private int income;
    private String usage;
    private int dayIncome;
    private String count;
    private List<ListBean> list;

    public String getIncome() {
        return MoneyTransUtil.transMoneyDecimal(income);
    }

    public String getUsage() {
        return usage;
    }

    public void setUsage(String usage) {
        this.usage = usage;
    }

    public String getDayIncome() {
        return MoneyTransUtil.transMoneyDecimal(dayIncome);
    }

    public void setDayIncome(int dayIncome) {
        this.dayIncome = dayIncome;
    }

    public String getCount() {
        return count;
    }

    public void setCount(String count) {
        this.count = count;
    }

    public void setIncome(int income) {
        this.income = income;
    }

    public List<ListBean> getList() {
        return list;
    }

    public void setList(List<ListBean> list) {
        this.list = list;
    }

    @Override
    public String toString() {
        return "HomeResq{" +
                "income=" + income +
                ", usage='" + usage + '\'' +
                ", dayIncome=" + dayIncome +
                ", count='" + count + '\'' +
                ", list=" + list +
                '}';
    }

    public static class ListBean implements Serializable{
        /**
         * typeId : 1
         * title : 我的充电桩
         * detail : 实时查看充电桩
         * imgUrl : http://image.jx9n.com/wuliCdz.png
         * goUrl : http://
         */

        private int typeId;
        private String title;
        private String detail;
        private String imgUrl;
        private String goUrl;

        public int getTypeId() {
            return typeId;
        }

        public void setTypeId(int typeId) {
            this.typeId = typeId;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getDetail() {
            return detail;
        }

        public void setDetail(String detail) {
            this.detail = detail;
        }

        public String getImgUrl() {
            return imgUrl;
        }

        public void setImgUrl(String imgUrl) {
            this.imgUrl = imgUrl;
        }

        public String getGoUrl() {
            return goUrl;
        }

        public void setGoUrl(String goUrl) {
            this.goUrl = goUrl;
        }

        @Override
        public String toString() {
            return "ListBean{" +
                    "typeId=" + typeId +
                    ", title='" + title + '\'' +
                    ", detail='" + detail + '\'' +
                    ", imgUrl='" + imgUrl + '\'' +
                    ", goUrl='" + goUrl + '\'' +
                    '}';
        }
    }
}

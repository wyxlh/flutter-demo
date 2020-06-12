package com.yzsh.power.client.configure.data.resq;

import java.util.List;

public class UpdateAppInfoResp {

    /**
     * updateFlag : 1
     * updateMessage : []
     * updateDownloadUrl : https://itunes.apple.com/cn/app/云智充/id1177512364?mt=8
     * updateVersion : 4.0.0
     */

    private String updateFlag;
    private String updateDownloadUrl;
    private String updateVersion;
    private List<String> updateMessage;

    public String getUpdateFlag() {
        return updateFlag;
    }

    public void setUpdateFlag(String updateFlag) {
        this.updateFlag = updateFlag;
    }

    public String getUpdateDownloadUrl() {
        return updateDownloadUrl;
    }

    public void setUpdateDownloadUrl(String updateDownloadUrl) {
        this.updateDownloadUrl = updateDownloadUrl;
    }

    public String getUpdateVersion() {
        return updateVersion;
    }

    public void setUpdateVersion(String updateVersion) {
        this.updateVersion = updateVersion;
    }

    public List<String> getUpdateMessage() {
        return updateMessage;
    }

    public void setUpdateMessage(List<String> updateMessage) {
        this.updateMessage = updateMessage;
    }

    @Override
    public String toString() {
        return "UpdateAppInfoResp{" +
                "updateFlag=" + updateFlag +
                ", updateDownloadUrl='" + updateDownloadUrl + '\'' +
                ", updateVersion='" + updateVersion + '\'' +
                ", updateMessage=" + updateMessage +
                '}';
    }
}

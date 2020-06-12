package com.yzsh.power.client.utils;

import android.Manifest;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Environment;
import android.os.Handler;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.blankj.utilcode.util.AppUtils;
import com.blankj.utilcode.util.FileUtils;
import com.blankj.utilcode.util.NetworkUtils;
import com.blankj.utilcode.util.ToastUtils;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.hss01248.notifyutil.NotifyUtil;
import com.tbruyelle.rxpermissions2.RxPermissions;

import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.x;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import com.yzsh.power.client.R;
import com.yzsh.power.client.base.BaseActivity;
import com.yzsh.power.client.configure.data.ConfigureRepository;
import com.yzsh.power.client.configure.data.resq.UpdateAppInfoResp;
import com.yzsh.power.client.dialog.CenterDialog;
import com.yzsh.power.client.net.BaseSubscriber;

public class AppUpdateUtil {
    public static void checkUpdate(Context context) {
        if (EmptyUtils.isEmpty(context)) return;
        //网络请求得到type（是否强制更新）,message，version，downloadUrl（下载的url）
        ConfigureRepository.getInstance().getAppInfo().subscribe(new BaseSubscriber<UpdateAppInfoResp>() {
            @Override
            protected void onNoNetwork(String msg) {

            }

            @Override
            protected void onFailed(Throwable e, String msg) {

            }

            @Override
            protected void onSucceed(UpdateAppInfoResp responseData) {
                String type = responseData.getUpdateFlag();//"1"强制更新；"2"选择更新
                String versionCode = responseData.getUpdateVersion();
                showUpdateDialog(versionCode, "1".equals(type), responseData.getUpdateMessage(), responseData.getUpdateDownloadUrl(), context);
            }
        });
    }

    //展示更新对话框
    private static void showUpdateDialog(final String versionCode, final boolean forceUpdate, final List<String> message, final String downloadUrl, Context context) {
        Dialog dialog = new CenterDialog(context) {
            @Override
            protected void initData(View view) {
                TextView tvVersionNumber = view.findViewById(R.id.tv_version_number);
                ImageView cancel = view.findViewById(R.id.iv_cancel);
                TextView update = view.findViewById(R.id.tv_update);
                RecyclerView rc = view.findViewById(R.id.rc);
                rc.setLayoutManager(new LinearLayoutManager(context));
                rc.setAdapter(new ContentAdapter(message));
                tvVersionNumber.setText(versionCode);

                //强制更新不显示取消按钮，选择更新显示取消按钮
                cancel.setVisibility(forceUpdate ? View.GONE : View.VISIBLE);
                cancel.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dismiss();
                    }
                });
                update.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        new RxPermissions((BaseActivity)context).request(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                                .subscribe(granted -> {
                                    if (granted) {
                                        dismiss();
                                        updateApp(context, versionCode, downloadUrl, forceUpdate);
                                    }
                                });
                    }
                });
            }

            @Override
            protected int getLayoutId() {
                return R.layout.dialog_app_upload;
            }
        };
        dialog.show();
        dialog.setCancelable(false);
    }

    private static void updateApp(final Context context, String versionCode, final String downloadUrl, final boolean forceUpdate) {
        String path = getDownloadPath();
        if (EmptyUtils.isEmpty(path)) {
            Toast.makeText(context, "手机未安装SD卡,下载失败", Toast.LENGTH_SHORT).show();
            return;
        }
        path += "yzc_client" + versionCode + ".apk";//下载的存储
        if (FileUtils.isFileExists(path)) {
            AppUtils.installApp(path);
        } else if (!NetworkUtils.getWifiEnabled() && NetworkUtils.isAvailableByPing()) {
            final String finalPath = path;
            new AlertDialog.Builder(context).setTitle("下载更新")
                    .setMessage("当前网络不是wifi环境，可能产生流量费用，是否继续下载更新")
                    .setPositiveButton("继续下载", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            download(finalPath, downloadUrl, context);
                        }
                    }).setNegativeButton("取消下载", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if (forceUpdate)
                        AppUtils.exitApp();
                    else dialog.dismiss();
                }
            }).setCancelable(false).create().show();
        } else {
            download(path, downloadUrl, context);
        }
    }

    private static boolean isCanceledDownload;
    private static List<Callback.Cancelable> cancelableList = new ArrayList<>();

    private static void download(final String path, final String url, final Context context) {
        final int notifyId = 11;
        RequestParams params = new RequestParams(url);
        params.setAutoResume(true);
        params.setCancelFast(true);
        params.setMaxRetryCount(2);
        params.setSaveFilePath(path);
        final ProgressDialog progressDialog = new ProgressDialog(context);
        progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
        progressDialog.setCancelable(false);
        progressDialog.setTitle("正在更新");
        progressDialog.setMax(100);
        final Callback.Cancelable cancelable = x.http().get(params, new Callback.ProgressCallback<File>() {
            @Override
            public void onSuccess(File result) {
                if (progressDialog.isShowing()) {
                    progressDialog.dismiss();
                    AppUtils.installApp(path);
                }
            }

            @Override
            public void onError(Throwable ex, boolean isOnCallback) {
                ToastUtils.showShort("网络出错");
                progressDialog.dismiss();
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        if (!isCanceledDownload) {
                            download(path, url, context);
                        }

                    }
                }, 500);

            }

            @Override
            public void onCancelled(CancelledException cex) {
                isCanceledDownload = true;
                progressDialog.dismiss();
                cancelNotify(notifyId);
            }

            @Override
            public void onFinished() {
                progressDialog.dismiss();
                cancelNotify(notifyId);
            }

            @Override
            public void onWaiting() {

            }

            @Override
            public void onStarted() {
                isCanceledDownload = false;
                progressDialog.setMessage("更新中...");
                progressDialog.show();
            }

            @Override
            public void onLoading(long total, long current, boolean isDownloading) {
                progressDialog.setProgress((int) (current * 100 / total));
                showProgressNotify(notifyId, current, total);
            }
        });
        cancelableList.add(cancelable);
    }

    public static void showProgressNotify(int id, long progress, long total) {
          NotifyUtil.buildProgress(id, R.mipmap.logo, "正在下载", (int) progress, (int) total, "下载进度:%d%%").setOnGoing().show();
    }

    public static void cancelNotify(int id) {
        NotifyUtil.cancel(id);
    }

    //下载保存的路径
    private static String getDownloadPath() {
        return Environment.getExternalStorageDirectory().getPath() + File.separator + "yzc" +
                File.separator;
    }

    public static void onDestroy() {
        for (Callback.Cancelable cancelable : cancelableList) {
            if (!cancelable.isCancelled()) cancelable.cancel();
        }
        cancelableList.clear();
    }

    private static class ContentAdapter extends BaseQuickAdapter<String, BaseViewHolder> {
        ContentAdapter(int layoutResId, List<String> data) {
            super(layoutResId, data);
        }

        ContentAdapter(List<String> data) {
            this(R.layout.dialog_app_upload_item, data);
        }

        @Override
        protected void convert(BaseViewHolder helper, String item) {
            ((TextView) helper.itemView).setText(item);
        }
    }
}

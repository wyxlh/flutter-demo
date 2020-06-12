package com.yzsh.power.client.base;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.annotation.IdRes;
import androidx.annotation.LayoutRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

public abstract class BaseFragment extends Fragment {
    protected View mContentView;
    protected BaseActivity mActivity;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mActivity = (BaseActivity) context;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initData(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        mContentView = createContentView(container);
        return mContentView;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initView(view);
    }

    private View createContentView(ViewGroup parent) {
        View contentView = null;
        contentView = getLayoutInflater().inflate(getLayoutRes(), parent, false);
        if (contentView == null) {
            throw new IllegalArgumentException("getContentLayout must be LayoutId");
        }
        return contentView;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initData();
    }

    @LayoutRes
    protected abstract int getLayoutRes();

    protected void initData() {
    }

    protected abstract void initView(View view);

    public void toastShow(String msg) {
        Toast.makeText(mActivity, msg, Toast.LENGTH_SHORT).show();
    }

    /**
     * 初始化数据，包括上个页面传递过来的数据在这个方法做
     */
    protected void initData(Bundle savedInstanceState) {
    }

    // final修饰的函数表示该函数不能被子类的函数覆盖，但可以被继承。
    protected final BaseActivity getCurrentActivity() {
        return mActivity;
    }

    /**
     * 打开Activity
     */
    protected final void startActivity(Class<?> clazz) {
        startActivity(clazz, null);
    }

    /**
     * 打开Activity
     */
    public final void startActivity(Class<?> clazz, @Nullable Bundle options) {
        Intent intent = new Intent(getCurrentActivity(), clazz);
        if (options != null) {
            intent.putExtras(options);
        }
        startActivity(intent);
    }

    //添加fragment
    protected void addFragment(BaseFragment fragment, @IdRes int viewId) {
        if (null != fragment) {
            getCurrentActivity().addFragment(fragment, viewId);
        }
    }

    //移除fragment
    protected void removeFragment() {
        getCurrentActivity().removeFragment();
    }

    protected void finish() {
        if (mActivity != null) {
            mActivity.finish();
        }
    }
}
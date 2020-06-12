package com.yzsh.power.client.net;

public interface BaseView<P extends BasePresenter> {
  void noNetwork(String msg);

  void setPresenter(P presenter);
}
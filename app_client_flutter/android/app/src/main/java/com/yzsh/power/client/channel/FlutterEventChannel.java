package com.yzsh.power.client.channel;

import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

import io.flutter.plugin.common.EventChannel;

public class FlutterEventChannel implements EventChannel.StreamHandler {
    private static final String CHANNEL = "yzc_event_channel";

    public static FlutterEventChannel instance = null;

    static EventChannel _channel;
    private FlutterActivity _activity;

    public EventChannel.EventSink _eventSink;

    public FlutterEventChannel(FlutterActivity activity) {
        _activity = activity;
    }

    public static void registerWith(FlutterActivity activity, FlutterEngine engine) {
        _channel = new EventChannel(engine.getDartExecutor(), CHANNEL);
        instance = new FlutterEventChannel(activity);
        _channel.setStreamHandler(instance);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        _eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        _eventSink = null;
    }

    public void send(boolean success, String content) {
        Log.i("channel event", content);
        if (_eventSink != null) {
            if (success) _eventSink.success(content);
            else _eventSink.error(content, null, null);
        }
    }
}

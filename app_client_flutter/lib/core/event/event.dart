
typedef void EventCallback(arg);

class YZCEvent {
  //单例
  YZCEvent._private();
  static YZCEvent _instance = YZCEvent._private();
  factory YZCEvent() => _instance;

  //保存事件表
  static var _map = new Map<Object, List<EventCallback>>();

  //注册事件
  static void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _map[eventName] ??= new List<EventCallback>();
    _map[eventName].add(f);
  }

  //注销事件
  static void off(eventName, [EventCallback f]) {
    var list = _map[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _map[eventName] = null;
    } else {
      list.remove(f);
      if (list.length < 1) _map[eventName] = null;
    }
  }

  //触发事件
  static void emit(eventName, [arg]) {
    var list = _map[eventName];
    if (list == null) return;
    for (var i = list.length - 1; i > -1; --i) { //反向遍历，防止注册者在回调中注销事件带来的下标错位
      list[i](arg);
    }
  }

  //异步触发事件
  static void emitAsync(eventName, [arg]) {
    Future.delayed(Duration(milliseconds: 1), (){
      emit(eventName, arg);
    });
  }
}

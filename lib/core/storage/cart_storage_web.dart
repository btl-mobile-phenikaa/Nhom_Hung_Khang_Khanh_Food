import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Lưu và đọc giỏ hàng trực tiếp từ `window.localStorage` trên trình duyệt Web,
/// đảm bảo khi bấm F5 / tải lại trang giỏ hàng được giữ nguyên 100% tức thì.
String? readLocalCartJson(String key) {
  try {
    final storage = globalContext['localStorage'] as JSObject?;
    if (storage == null) return null;
    final result = storage.callMethod<JSAny?>('getItem'.toJS, key.toJS);
    if (result == null || result.isUndefinedOrNull) return null;
    return (result as JSString).toDart;
  } catch (_) {
    return null;
  }
}

void writeLocalCartJson(String key, String value) {
  try {
    final storage = globalContext['localStorage'] as JSObject?;
    if (storage == null) return;
    storage.callMethod<JSAny?>('setItem'.toJS, key.toJS, value.toJS);
  } catch (_) {
    // Bỏ qua nếu trình duyệt chặn localStorage
  }
}


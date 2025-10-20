from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QFileSystemWatcher, QObject, QUrl, QTimer
from PySide6.QtQuick import QQuickWindow

from dev.file_manager import list_files
from pathlib import Path

import sys


class HotReloadManager(QObject):
    def __init__(self, qml_entry: str, watch_dpath: str):
        super().__init__()
        self.engine = QQmlApplicationEngine()
        self.qml_entry = Path(qml_entry)
        self.watch_dir = Path(watch_dpath)
        self.watcher = QFileSystemWatcher()
        self.root_windows: list[QQuickWindow] = []
        self._reload_timer = QTimer()
        self._reload_timer.setSingleShot(True)
        self._reload_timer.timeout.connect(self._do_reload)

        # Theo dõi tất cả các file QML
        self._update_watched_paths()
        self.watcher.fileChanged.connect(self.schedule_reload)
        self.watcher.directoryChanged.connect(self.on_directory_change)


    def _update_watched_paths(self):
        """Theo dõi tất cả file QML"""
        if self.watcher.files():
            self.watcher.removePaths(self.watcher.files())
        if self.watcher.directories():
            self.watcher.removePaths(self.watcher.directories())

        qml_files = list_files(self.watch_dir)
        self.watcher.addPaths(qml_files)
        self.watcher.addPath(str(self.watch_dir))
        print(f"[Hot-reload] Watching {len(qml_files)} QML files in {self.watch_dir}")


    def _collect_windows(self):
        """Thu thập tất cả QQuickWindow"""
        self.root_windows.clear()
        for obj in self.engine.rootObjects():
            if isinstance(obj, QQuickWindow):
                self.root_windows.append(obj)
            else:
                raise TypeError("Unknow type of `obj` in engine.rootObjects()")
                # # Dự phòng: nếu root là QObject, thử cast sang QQuickWindow
                # window = QQuickWindow.fromWinId(int(obj.winId())) if hasattr(obj, "winId") else None
                # if window:
                #     self.root_windows.append(window)


    def load_qml(self):
        """Load QML lần đầu"""
        print("[Hot-reload] Loading QML...")
        self.engine.load(QUrl.fromLocalFile(str(self.qml_entry)))
        if not self.engine.rootObjects():
            print("[Hot-reload] Failed to load QML.")
            return

        self._collect_windows()
        for w in self.root_windows:
            w.show()
        print("[Hot-reload] Loaded successfully.")


    def close_old_windows(self):
        """Đóng toàn bộ cửa sổ cũ"""
        for w in self.root_windows:
            if isinstance(w, QQuickWindow):
                print(f"[Hot-reload] Closing window: {w.title() or '[unnamed]'}")
                w.hide()
                w.close()
        self.root_windows.clear()


    def schedule_reload(self):
        """Debounce reload (tránh reload liên tục)"""
        if self._reload_timer.isActive():
            self._reload_timer.stop()
        self._reload_timer.start(300)


    def _do_reload(self):
        """Reload thực sự"""
        print("Reloading QML...")
        self.close_old_windows()

        self.engine = QQmlApplicationEngine()
        self.engine.load(QUrl.fromLocalFile(str(self.qml_entry)))
        
        if self.engine.rootObjects():
            self._collect_windows()
            for w in self.root_windows:
                w.show()
            print("[Hot-reload] Reloaded successfully.")
        else:
            print("[Hot-reload] Reload failed.")


    def on_directory_change(self, path):
        """Theo dõi thay đổi thư mục"""
        print(f"[Hot-reload] Directory changed: {path}")
        self._update_watched_paths()
        self.schedule_reload()


def main():
    app = QGuiApplication(sys.argv)

    qml_main = "gui/main.qml"
    qml_dir = "gui"

    manager = HotReloadManager(qml_main, qml_dir)
    manager.load_qml()

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QDir>
#include <QCoreApplication>

int main(int argc, char *argv[])
{
    // QApplication is required for Qt.labs.platform SystemTrayIcon
    QApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("JustBreak"));
    app.setOrganizationName(QStringLiteral("JustBreak"));
    // Keep process alive while the window is hidden between cycles
    app.setQuitOnLastWindowClosed(false);

    QQuickWindow::setDefaultAlphaBuffer(true);

    QQmlApplicationEngine engine;

    const QString qmlPath = QDir(QCoreApplication::applicationDirPath())
                                .filePath(QStringLiteral("Main.qml"));

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.load(QUrl::fromLocalFile(qmlPath));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

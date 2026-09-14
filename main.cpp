// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Pragalathan M
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QDir>
#include <QCoreApplication>
#include <QUrl>

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
    const bool testMode = app.arguments().contains(QStringLiteral("--test"));
    engine.rootContext()->setContextProperty(QStringLiteral("testMode"), testMode);

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

#ifdef JUSTBREAK_EMBEDDED_RESOURCES
    // Production build: QML and icons embedded via resources.qrc
    engine.load(QUrl(QStringLiteral("qrc:/JustBreak/Main.qml")));
#else
    // Dev build: load Main.qml from beside the binary
    const QString qmlPath = QDir(QCoreApplication::applicationDirPath())
                                .filePath(QStringLiteral("Main.qml"));
    engine.load(QUrl::fromLocalFile(qmlPath));
#endif

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

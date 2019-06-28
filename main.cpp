#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQuickItem>
#include <QObject>
#include <QDebug>
#include <ToolBarController.h>
#include <QScreen>

ToolBarController toolbarController;

void loadUrl(const QUrl url, QGuiApplication& app, QQmlApplicationEngine& engine)
{

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
}

void loadDesktops(QGuiApplication& app, QQmlApplicationEngine& engine)
{
    const QUrl url(QStringLiteral("qrc:///CanvasWindow.qml"));
    for(QScreen* currentScreen : QGuiApplication::screens())
    {
        loadUrl(url, app, engine);

        QObject *desktopWindow = engine.rootObjects()[engine.rootObjects().size()-1];
        QQuickWindow *wnd = qobject_cast<QQuickWindow*>(desktopWindow);
        qDebug() << "Screen detected " << currentScreen->name()
                 << "res " <<  currentScreen->size().width() << "x" << currentScreen->size().height() << " "
                 << "virtual x " << currentScreen->geometry().x() << " "
                 << "virtual y " << currentScreen->geometry().y() << " ";
        wnd->setTitle(currentScreen->name());
        wnd->setX(currentScreen->geometry().x());
        wnd->setY(currentScreen->geometry().y());
        toolbarController.addDesktop(wnd);
    }
}
void loadToolBar(QGuiApplication& app, QQmlApplicationEngine& engine)
{
    const QUrl url("qrc:///ToolBarWindow.qml");
    loadUrl(url, app, engine);
    QObject *toolBarWindow = engine.rootObjects()[engine.rootObjects().size()-1];
    toolbarController.addToolBar(qobject_cast<QQuickWindow*>(toolBarWindow));
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    loadDesktops(app, engine);
    loadToolBar(app, engine);



    return app.exec();
}

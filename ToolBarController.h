#ifndef HANDLEA_H
#define HANDLEA_H

#include <QObject>
#include <QDebug>
#include <QQuickView>
#include <vector>
#include <QColor>

class ToolBarController : public QObject
{
    Q_OBJECT
    QQuickWindow *_toolBarWindow;
    std::vector<QQuickWindow *> _desktops;
public:
    explicit ToolBarController(QObject *parent = 0);
    void addDesktop(QQuickWindow *desktop);
    void addToolBar(QQuickWindow *toolbar);
signals:
    void clearScreens();
    void enablePaint();
    void disablePaint();
    void changeColor(QVariant value);
    void changeSize(QVariant value);
public slots:
    void onClearScreens();
    void onChangeFocus();
    void onChangePaintEnabler(bool value);
    void onColorChanged(QColor value);
    void onSizeChanged(int value);
};

#endif // HANDLEA_H

#include "ToolBarController.h"

ToolBarController::ToolBarController(QObject *parent ):
    QObject(parent){}

void ToolBarController::addDesktop(QQuickWindow *desktop)
{
    _desktops.push_back(desktop);
    QObject::connect(desktop, SIGNAL(released()),
                     this, SLOT(onChangeFocus()));
    QObject::connect(this, SIGNAL(clearScreens()),
                     desktop, SLOT(requestClear()));
    QObject::connect(this, SIGNAL(enablePaint()),
                     desktop, SLOT(enablePaint()));
    QObject::connect(this, SIGNAL(disablePaint()),
                     desktop, SLOT(disablePaint()));
    QObject::connect(this, SIGNAL(changeColor(QVariant)),
                     desktop, SLOT(changeColor(QVariant)));
    QObject::connect(this, SIGNAL(changeSize(QVariant)),
                     desktop, SLOT(changeSize(QVariant)));

}

void ToolBarController::addToolBar(QQuickWindow *toolbar)
{
    _toolBarWindow = toolbar;
    QObject::connect(_toolBarWindow, SIGNAL(clearClicked()),
                     this, SLOT(onClearScreens()));
    QObject::connect(_toolBarWindow, SIGNAL(paintEnableChanged(bool)),
                     this, SLOT(onChangePaintEnabler(bool)));
    QObject::connect(_toolBarWindow, SIGNAL(paintColor(QColor)),
                     this, SLOT(onColorChanged(QColor)));
    QObject::connect(_toolBarWindow, SIGNAL(sizeChanged(int)),
                     this, SLOT(onSizeChanged(int)));
}

void ToolBarController::onClearScreens()
{
    emit clearScreens();
}

void ToolBarController::onChangeFocus()
{
    _toolBarWindow->raise();
}

void ToolBarController::onChangePaintEnabler(bool value)
{
    if(value){
        emit enablePaint();
        std::for_each(std::begin(_desktops),std::end(_desktops),[](const auto& item){item->show();});
    } else {
        emit disablePaint();
        std::for_each(std::begin(_desktops),std::end(_desktops),[](const auto& item){item->hide();});
    }
}

void ToolBarController::onColorChanged(QColor value)
{
    emit changeColor(value);
}

void ToolBarController::onSizeChanged(int value)
{
    emit changeSize(value);
}

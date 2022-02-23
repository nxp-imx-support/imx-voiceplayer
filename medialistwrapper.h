#ifndef MEDIALISTWRAPPER_H
#define MEDIALISTWRAPPER_H

#include <QObject>

class medialistwrapper : public QObject
{
    Q_OBJECT
public:
    explicit medialistwrapper(QObject *parent = nullptr);

signals:

};

#endif // MEDIALISTWRAPPER_H

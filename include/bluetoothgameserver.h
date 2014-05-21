#ifndef BLUETOOTHGAMESERVER_H
#define BLUETOOTHGAMESERVER_H

#include <QObject>
#include <QtBluetooth/QtBluetooth>

class BluetoothGameServer : public QObject
{
    Q_OBJECT
public:
    explicit BluetoothGameServer(QObject *parent = 0);

signals:

public slots:

};

#endif // BLUETOOTHGAMESERVER_H

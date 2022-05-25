///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////

#ifndef DEVICEINTERFACE_H
#define DEVICEINTERFACE_H

#include <QObject>
QT_USE_NAMESPACE

class DeviceInterface : public QObject
{
    Q_OBJECT
public:
   // explicit DeviceInterface(QObject *parent = nullptr);

/*public slots:
    void addDevice(const QBluetoothDeviceInfo&);
    void on_power_clicked(bool clicked);
    void on_discoverable_clicked(bool clicked);
    void displayPairingMenu(const QPoint &pos);
    void pairingDone(const QBluetoothAddress&, QBluetoothLocalDevice::Pairing);
private slots:
    void startScan();
    void scanFinished();
    void setGeneralUnlimited(bool unlimited);
    void hostModeStateChanged(QBluetoothLocalDevice::HostMode);
*/
};

#endif // DEVICEINTERFACE_H

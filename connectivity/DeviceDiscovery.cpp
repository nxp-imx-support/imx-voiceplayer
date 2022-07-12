///////////////////////////////////////////////////////////////////////////////
// Copyright NXP. For more information,
// please see COPYRIGHT file in root of source repository.
///////////////////////////////////////////////////////////////////////////////


#include <QtBluetooth/QBluetoothDeviceDiscoveryAgent>
#include <QDebug>
#include "DeviceDiscovery.h"

DeviceDiscovery::DeviceDiscovery(QObject *parent)
    : LocalDevice(new QBluetoothLocalDevice()), QObject(parent)
{

    LocalDevice->powerOn();
    QBluetoothAddress adapterAddress = LocalDevice->address();
    qDebug() << adapterAddress.toString();

    DiscoveryAgent = new QBluetoothDeviceDiscoveryAgent(adapterAddress);
    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered,
            this, &DeviceDiscovery::addDevice);
    connect(DiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished,
            this, &DeviceDiscovery::scanFinished);
    connect(LocalDevice, &QBluetoothLocalDevice::hostModeStateChanged,
            this, &DeviceDiscovery::hostModeStateChanged);

    hostModeStateChanged(LocalDevice->hostMode());
    connect(LocalDevice, &QBluetoothLocalDevice::pairingFinished,
            this, &DeviceDiscovery::pairingDone);

    //startScan();
    //connect(ui->inquiryType, SIGNAL(toggled(bool)), this, SLOT(setGeneralUnlimited(bool)));
    //connect(ui->scan, SIGNAL(clicked()), this, SLOT(startScan()));

    //connect(discoveryAgent, SIGNAL(finished()), this, SLOT(scanFinished()));

    //connect(ui->list, SIGNAL(itemActivated(QListWidgetItem*)),
    //        this, SLOT(itemActivated(QListWidgetItem*)));

    // add context menu for devices to be able to pair device
    //ui->list->setContextMenuPolicy(Qt::CustomContextMenu);
    //connect(ui->list, SIGNAL(customContextMenuRequested(QPoint)), this, SLOT(displayPairingMenu(QPoint)));
}

DeviceDiscovery::~DeviceDiscovery()
{
    delete DiscoveryAgent;
}

void DeviceDiscovery::addDevice(const QBluetoothDeviceInfo &info)
{
    QBluetoothLocalDevice::Pairing pairingStatus = LocalDevice->pairingStatus(info.address());
    if (pairingStatus == QBluetoothLocalDevice::Paired || pairingStatus == QBluetoothLocalDevice::AuthorizedPaired)
    {
        qDebug() << "Device found: " << info.name() << " addr: " << info.address().toString();
    }
    else
    {
        qDebug() << "No device found!";

    }
}

void DeviceDiscovery::on_power_clicked(bool clicked)
{

}

void DeviceDiscovery::on_discoverable_clicked(bool clicked)
{

}

void DeviceDiscovery::displayPairingMenu(const QPoint &pos)
{

}

void DeviceDiscovery::pairingDone(const QBluetoothAddress &, QBluetoothLocalDevice::Pairing)
{

}

void DeviceDiscovery::startScan()
{
    DiscoveryAgent->start();

}

void DeviceDiscovery::scanFinished()
{

}

void DeviceDiscovery::setGeneralUnlimited(bool unlimited)
{

}

void DeviceDiscovery::hostModeStateChanged(QBluetoothLocalDevice::HostMode)
{

}

# 获取本机的IPv4地址

- 工程名：HostInfoDemo。

- pro：HostInfoDemo.pro。

  ```qmake
  QT -= gui
  QT += network
  
  CONFIG += c++11 console
  CONFIG -= app_bundle
  
  # The following define makes your compiler emit warnings if you use
  # any Qt feature that has been marked deprecated (the exact warnings
  # depend on your compiler). Please consult the documentation of the
  # deprecated API in order to know how to port your code away from it.
  DEFINES += QT_DEPRECATED_WARNINGS
  
  # You can also make your code fail to compile if it uses deprecated APIs.
  # In order to do so, uncomment the following line.
  # You can also select to disable deprecated APIs only up to a certain version of Qt.
  #DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0
  
  SOURCES += \
          main.cpp
  
  # Default rules for deployment.
  qnx: target.path = /tmp/$${TARGET}/bin
  else: unix:!android: target.path = /opt/$${TARGET}/bin
  !isEmpty(target.path): INSTALLS += target
  
  ```

- main.cpp

  ```c++
  #include <QCoreApplication>
  #include <QtNetwork/QHostAddress>
  #include <QtNetwork/QHostInfo>
  #include <QDebug>
  #include <QNetworkInterface>
  
  int main(int argc, char *argv[])
  {
      QCoreApplication a(argc, argv);
  
      qDebug() << "===========================Method 1===========================";
      QHostInfo info = QHostInfo::fromName(QHostInfo::localHostName());
      foreach (QHostAddress address, info.addresses())
      {
          if (address.protocol() == QAbstractSocket::IPv4Protocol)
          {
              qDebug() << "IPv4: " << address.toString();
          }
      }
  
      qDebug() << "";
      qDebug() << "===========================Method 2===========================";
      QList<QHostAddress> hostAddrList = QNetworkInterface::allAddresses();
      foreach (QHostAddress address, hostAddrList)
      {
          if ((address.protocol() == QAbstractSocket::IPv4Protocol)
              && (address != QHostAddress::LocalHost))
          {
              qDebug() << "IPv4: " << address.toString();
          }
      }
  
      return a.exec();
  }
  
  // Output
  // 
  //     ===========================Method 1===========================
  //     IPv4:  "192.168.3.60"
  //     IPv4:  "192.168.34.1"
  //     IPv4:  "192.168.12.1"
  //     IPv4:  "172.20.128.1"
  //     
  //     ===========================Method 2===========================
  //     IPv4:  "192.168.3.60"
  //     IPv4:  "192.168.12.1"
  //     IPv4:  "192.168.34.1"
  //     IPv4:  "172.20.128.1"
  ```

  
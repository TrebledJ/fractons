#include "desktopnotifications.h"

/*
 * QIcon wallet{":/res/wallet.png"};
	app.setWindowIcon(wallet);
	
	
	QSystemTrayIcon sti{wallet};
	sti.setToolTip("Tool tip from Qt.");
	
	QMenu mn;
	mn.addAction("Send Message", [&](){ sti.showMessage("Important!", "Alright soldier, I've got good news and bad news.", wallet, 1000); });
	mn.addAction("Quit", &QApplication::quit);
	
	
	sti.setContextMenu(&mn);
	
//	QThread::sleep(5);
	sti.show();
	
	
	QObject::connect(&sti, &QSystemTrayIcon::messageClicked, [](){ qDebug() << "Message clicked!"; });
	
*/
#include <QMenu>

DesktopNotifications::DesktopNotifications(QObject *parent) :
	QObject(parent),
	systemTray(QIcon(":/assets/vplay-logo.png"))
{
	systemTray.setToolTip("Fratureuns Tray");
	
	QMenu* mn = new QMenu();
	mn->addAction("Ping", [&]() {
		systemTray.showMessage("Pong!", "Slidin' away in 5 seconds.", QIcon(), 5000);
	});
	
	systemTray.setContextMenu(mn);
	systemTray.show();
}

void DesktopNotifications::notify(QString title, QString message, double seconds)
{
	systemTray.showMessage(title, message, QIcon(), seconds * 1000);
}

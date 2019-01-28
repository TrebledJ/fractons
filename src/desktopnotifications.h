#ifndef DESKTOPNOTIFICATIONS_H
#define DESKTOPNOTIFICATIONS_H

#include <QObject>
#include <QSystemTrayIcon>

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



class DesktopNotifications : public QObject
{
	Q_OBJECT
public:
	explicit DesktopNotifications(QObject *parent = nullptr);
	
signals:
	
public slots:
	void notify(QString title, QString message = "", double seconds = 5000);
	
	
private:
	QSystemTrayIcon systemTray;
	
	
};

#endif // DESKTOPNOTIFICATIONS_H

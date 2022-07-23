#ifndef DESKTOPNOTIFICATIONS_H
#define DESKTOPNOTIFICATIONS_H

#include <QObject>
#include <QQueue>
#include <QSystemTrayIcon>
#include <QTimer>

class DesktopNotifications : public QObject
{
	Q_OBJECT
public:
	struct Message
	{
		QString title;
		QString message;
		int seconds;
	};
	
	explicit DesktopNotifications(QObject *parent = nullptr);

public slots:
	void notify(QString title, QString message = "", int seconds = 5);
	
private slots:
	void sendMessage();
	
private:
	QSystemTrayIcon m_systemTray;
	
	QQueue<Message> m_messageQueue;
	
	QTimer m_timer;
	
};

#endif // DESKTOPNOTIFICATIONS_H

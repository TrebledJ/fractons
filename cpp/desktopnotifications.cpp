#include "desktopnotifications.h"

#include <QDebug>

#include <QMenu>

DesktopNotifications::DesktopNotifications(QObject *parent) :
	QObject(parent),
	m_systemTray(QIcon(":/assets/vplay-logo.png"))
{
	m_systemTray.setToolTip("Fratureuns Tray");
	
	QMenu* mn = new QMenu();
	mn->addAction("Ping", [&]() {
//		m_systemTray.showMessage("Pong!", "Slidin' away in 5 seconds.", QIcon(), 5);
		notify("Pong!", "Slidin' away in 5 seconds.", 5);
	});
	
	m_systemTray.setContextMenu(mn);
	m_systemTray.show();
	
	// ======================== //
	
	m_timer.setSingleShot(true);
	QObject::connect(&m_timer, &QTimer::timeout, this, &DesktopNotifications::sendMessage);
	
}

void DesktopNotifications::notify(QString title, QString message, int seconds)
{
	qDebug() << "Notifying (title:" << title << "; message:" << message << "; seconds:" << seconds << ")";
//	systemTray.showMessage(title, message, QIcon(), seconds * 1000);
	
	m_messageQueue.append(Message{title, message, seconds});
	
	if (!m_timer.isActive())
		sendMessage();
}

void DesktopNotifications::sendMessage()
{
	if (m_messageQueue.isEmpty())
		return;
	
	Message msg = m_messageQueue.front();
	m_messageQueue.pop_front();
	
	m_systemTray.showMessage(msg.title, msg.message, QIcon(), msg.seconds * 1000);
	
	m_timer.start((msg.seconds + 3) * 1000);
}

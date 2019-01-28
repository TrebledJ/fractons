#include <QApplication>
#include <VPApplication>

#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <VPLiveClient>

#include <QDebug>

#include "achievement.h"
#include "achievementsmanager.h"
#include "desktopnotifications.h"

int main(int argc, char *argv[])
{
	
	QApplication app(argc, argv);
	
	DesktopNotifications notifications;
//	notifications.notify("Hi", ":P", 20);
//	notifications.notify("Bye", "Saynoara", 5);
	
	
	
	VPApplication vplay;
	
	// QQmlApplicationEngine is the preferred way to start qml projects since Qt 5.2
	// if you have older projects using Qt App wizards from previous QtCreator versions than 3.1, please change them to QQmlApplicationEngine
	QQmlApplicationEngine engine;
	vplay.initialize(&engine);
	
	// use this during development
	// for PUBLISHING, use the entry point below
#ifndef VP_LIVE_CLIENT_MODULE_H
	vplay.setMainQmlFileName(QStringLiteral("qml/Main.qml"));
#endif
	
	// use this instead of the above call to avoid deployment of the qml files and compile them into the binary with qt's resource system qrc
	// this is the preferred deployment option for publishing games to the app stores, because then your qml files and js files are protected
	// to avoid deployment of your qml files and images, also comment the DEPLOYMENTFOLDERS command in the .pro file
	// also see the .pro file for more details
	//  vplay.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml"));
	
//	QString thisMainUrl = "../../../../";
//	qmlRegisterSingletonType(QUrl::fromLocalFile(":/qml/game/Storage.qml"), "JSingletons", 1, 0, "JStorage");
	
	
	qmlRegisterType<Achievement>("fractureuns", 1, 0, "JAchievement");	//	use J to prevent conflict with VPlay's Achievement type
	qmlRegisterType<AchievementsManager>("fractureuns", 1, 0, "JAchievementManager");
	
	
	AchievementsManager manager;
	engine.rootContext()->setContextProperty("achievementsManager", &manager);
	
	QObject::connect(&manager, &AchievementsManager::sendNotification, &notifications, &DesktopNotifications::notify);
	
	// uncomment for publishing
#ifndef VP_LIVE_CLIENT_MODULE_H
	engine.load(QUrl(vplay.mainQmlFileName()));
#else
	VPlayLiveClient liveClient(&engine);
#endif
	
//	QObject* obj = engine.findChild<AchievementsManager*>("jam");
//	AchievementsManager* obj = engine.findChild<AchievementsManager*>("jam");
//	if (obj)
//	{
//		qDebug() << "AchievementsManager was found!";
		
////		AchievementsManager* manager = qobject_cast<AchievementsManager*>(obj);
		
////		QObject::connect(manager, &AchievementsManager::sendNotification, &notifications, &DesktopNotifications::notify);
//		QObject::connect(obj, &AchievementsManager::sendNotification, &notifications, 
//						 [&] (QString a, QString b, double c)
//		{
//			qDebug() << "Sending notification!";
//			notifications.notify(a, b, c);
//		});
//	}
//	else
//	{
//		qDebug() << "AchievementsManager not found...";
//	}
	
	return app.exec();
}

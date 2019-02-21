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
	
	
	qmlRegisterType<Achievement>("Fractureuns", 1, 0, "JAchievement");	//	use J to prevent conflict with VPlay's Achievement type
//	qmlRegisterType<AchievementsManager>("Fractureuns", 1, 0, "JAchievementManager");
	
	
	AchievementsManager manager;
	engine.rootContext()->setContextProperty("jAchievementsManager", &manager);
	
	DesktopNotifications notifications;
	engine.rootContext()->setContextProperty("jNotifications", &notifications);
	
	// uncomment for publishing
#ifndef VP_LIVE_CLIENT_MODULE_H
	engine.load(QUrl(vplay.mainQmlFileName()));
#else
	VPlayLiveClient liveClient(&engine);
#endif
	//	connect notifications sender from AchievementsManager to DesktopNotifications object
	QObject::connect(&manager, &AchievementsManager::sendNotification, &notifications, 
					 &DesktopNotifications::notify);
	
	
	return app.exec();
}

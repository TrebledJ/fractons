#include <QApplication>
#include <FelgoApplication>

#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <FelgoLiveClient>

//#include <QDebug>

#include "achievement.h"
#include "achievementsmanager.h"
//#include "desktopnotifications.h"

int main(int argc, char *argv[])
{
	
	QApplication app(argc, argv);
	
	
	FelgoApplication felgo;
	
	// QQmlApplicationEngine is the preferred way to start qml projects since Qt 5.2
	// if you have older projects using Qt App wizards from previous QtCreator versions than 3.1, please change them to QQmlApplicationEngine
	QQmlApplicationEngine engine;
	felgo.initialize(&engine);
	
	// ** use this during development **
	felgo.setMainQmlFileName(QStringLiteral("qml/Main.qml"));	//	comment for publishing
	// ** for PUBLISHING, use the entry point below **
	
	// use this instead of the above call to avoid deployment of the qml files and compile them into the binary with qt's resource system qrc
	// this is the preferred deployment option for publishing games to the app stores, because then your qml files and js files are protected
	// to avoid deployment of your qml files and images, also comment the DEPLOYMENTFOLDERS command in the .pro file
	// also see the .pro file for more details
	
//	felgo.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml")); // uncomment for publishing
	
	
	qmlRegisterType<Achievement>("Fractons", 1, 0, "JAchievement");	//	use J to prevent conflict with Felgo's Achievement type
//	qmlRegisterType<AchievementsManager>("Fractons", 1, 0, "JAchievementManager");
	
	
	AchievementsManager manager;
	engine.rootContext()->setContextProperty("jAchievementsManager", &manager);
	
//	DesktopNotifications notifications;
//	engine.rootContext()->setContextProperty("jNotifications", &notifications);
	
	//	connect notifications sender from AchievementsManager to DesktopNotifications object
//	QObject::connect(&manager, &AchievementsManager::sendNotification, &notifications, 
//					 &DesktopNotifications::notify);
	
	
//	engine.load(QUrl(felgo.mainQmlFileName()));	// uncomment for publishing
	
	FelgoLiveClient liveClient(&engine);	//	comment to disable live client and/or for publishing

	return app.exec();
}

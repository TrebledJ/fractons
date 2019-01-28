#ifndef ACHIEVEMENTSMANAGER_H
#define ACHIEVEMENTSMANAGER_H


/**
  
  
  Sources and Citations
  
  [1] Intro to Qml List Basic Type: http://doc.qt.io/qt-5/qml-list.html
  [2] QQmlListProperty C++ Class: http://doc.qt.io/qt-5/qqmllistproperty.html
  [3] Q_INVOKABLE Macro:
		http://doc.qt.io/qt-5/qtqml-cppintegration-exposecppattributes.html#exposing-methods-including-qt-slots
  [4] Example Source Code for Implementation of QQmlListProperty (had to add `static` to `appendAchievements`):
		https://stackoverflow.com/questions/37341286/how-to-edit-qqmllistproperty-in-qml
  **/


#include <QObject>
#include <QQmlListProperty>	//	see [1] [2]

#include "achievement.h"


//Q_DECLARE_METATYPE(Achievement)


class AchievementsManager : public QObject
{
	Q_OBJECT
	
	//	see also: [1] [2]
	Q_PROPERTY(QQmlListProperty<Achievement> achievements READ getAchievements NOTIFY achievementsChanged)
	
public:
	explicit AchievementsManager(QObject *parent = nullptr);
	
	QQmlListProperty<Achievement> getAchievements();
	
	//	see [4]; static is used for void*
	static void appendAchievements(QQmlListProperty<Achievement> *list, Achievement *e);
	static int elementsCount(QQmlListProperty<Achievement> *list);
	static Achievement* elementsAt(QQmlListProperty<Achievement> *list, int i);
	static void elementsClear(QQmlListProperty<Achievement> *list);
	
	
	Q_INVOKABLE	//	see [3]
	void debug();
	
	Q_INVOKABLE
	void testNotify();
	
signals:
	void achievementsChanged();
	void sendNotification(QString, QString, double);
	
public slots:
	
private:
	QList<Achievement*> m_achievements;
	
};

#endif // ACHIEVEMENTSMANAGER_H

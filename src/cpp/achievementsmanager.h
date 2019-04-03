#ifndef ACHIEVEMENTSMANAGER_H
#define ACHIEVEMENTSMANAGER_H


/**
  
  
  Sources and Citations
  
  [1] Q_INVOKABLE Macro:
		http://doc.qt.io/qt-5/qtqml-cppintegration-exposecppattributes.html#exposing-methods-including-qt-slots
  **/


#include <QObject>
#include <QMap>

#include "achievement.h"


class AchievementsManager : public QObject
{
	Q_OBJECT
	
public:
	explicit AchievementsManager(QObject *parent = nullptr);
	
	Q_INVOKABLE
	QStringList getNames(const QString &filter = QString()) const;
	
	Q_INVOKABLE
	Achievement* getByName(const QString &name);
	
	Q_INVOKABLE
	void addAchievement(Achievement *achievement);
	
	Q_INVOKABLE
	QString jsonAchievements() const;
	
	Q_INVOKABLE
	void clearAchievements();
	
	Q_INVOKABLE	//	see [1]
	void debug();
	
signals:
	void achievementsChanged();
	void achievementGet(QString name, int reward);
	
public slots:
	
private:
	QMap<QString, Achievement> m_achievements;
	
};

#endif // ACHIEVEMENTSMANAGER_H

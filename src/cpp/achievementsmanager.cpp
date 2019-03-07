#include "achievementsmanager.h"

#include <QDebug>

AchievementsManager::AchievementsManager(QObject *parent) : 
	QObject(parent)
{
	
}

QQmlListProperty<Achievement> AchievementsManager::getAchievements()
{
	return QQmlListProperty<Achievement>(this, 
										 &m_achievements,
	
										 &AchievementsManager::appendAchievements,
										 &AchievementsManager::elementsCount,
										 &AchievementsManager::elementsAt,
										 &AchievementsManager::elementsClear);
}

void AchievementsManager::appendAchievements(QQmlListProperty<Achievement>* list, Achievement* e)
{
	AchievementsManager* manager = qobject_cast<AchievementsManager*>(list->object);
	if (list && e)
	{
		manager->m_achievements.append(e);
		emit manager->achievementsChanged();
		
		QObject::connect(e, &Achievement::achievementChanged, manager, &AchievementsManager::achievementsChanged);
		
		//	send a signal for desktop notification on getting an achievement
		QObject::connect(e, &Achievement::achievementGet, manager,
						 [&,e,manager] ()
		{
			qDebug() << "[C++ AchievementsManager] Achievement Get: " << e->m_name;
			QString msg = QString("You just got %1 and earned %2 Fractons!").arg(e->m_name).arg(e->m_reward);
			
			emit manager->achievementGet(e->m_name, e->m_reward);
			emit manager->sendNotification("Achievment Get!", msg, 3);	//	8 seconds
		});
	}
}

int AchievementsManager::elementsCount(QQmlListProperty<Achievement>* list)
{
	AchievementsManager* manager = qobject_cast<AchievementsManager*>(list->object);
	
	if (list)
		return manager->m_achievements.count();
	
	return 0;
}

Achievement* AchievementsManager::elementsAt(QQmlListProperty<Achievement>* list, int i)
{
	AchievementsManager* manager = qobject_cast<AchievementsManager*>(list->object);
	
	if (list)
		return manager->m_achievements.at(i);
	
	return nullptr;
}

void AchievementsManager::elementsClear(QQmlListProperty<Achievement> *list)
{
	AchievementsManager* manager = qobject_cast<AchievementsManager*>(list->object);
	
	if (list)
	{
		manager->m_achievements.clear();
		emit manager->achievementsChanged();
	}
}

void AchievementsManager::debug()
{
	qDebug() << "Number of Achievements:";
	qDebug() << "  " << m_achievements.count();
	
}

void AchievementsManager::testNotify()
{
	qDebug() << "Notifying!";
	emit sendNotification("Hello", "Hi", 8);
}

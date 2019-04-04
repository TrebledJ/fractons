#include "achievementsmanager.h"

#include <QDebug>
#include <QString>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

AchievementsManager::AchievementsManager(QObject *parent) : 
	QObject(parent)
{
	
}

QStringList AchievementsManager::getNames(const QString& filter) const
{
	QStringList ret;
	QStringList filters = filter.split(' ');
	
	auto passes = [&filters] (Achievement* acvm) -> bool
	{
		if (filters.isEmpty())
			return true;
		
		foreach (const QString &f, filters)
		{
			if (f.startsWith("!") && acvm->m_group == f.mid(1))
				return false;
			if (f.mid(1, 1) != "!" && acvm->m_group != f)
				return false;
		}
		
		return true;
	};
	
	foreach (Achievement* acvm, m_achievements.values())
	{
		if (passes(acvm))
			ret.append(acvm->m_name);
	}
	
	return ret;
}

Achievement* AchievementsManager::getByName(const QString& name)
{
	if (m_achievements.contains(name.toLower()))
		return m_achievements[name.toLower()];
	
	return nullptr;
}

void AchievementsManager::addAchievement(Achievement *achievement)
{
	m_achievements[achievement->m_name.toLower()] = achievement;
	
	emit achievementsChanged();
			
	QObject::connect(achievement, &Achievement::achievementChanged, this, &AchievementsManager::achievementsChanged);
			
	//	send a signal for desktop notification on getting an achievement
	QObject::connect(achievement, &Achievement::achievementGet, this,
					 [=] ()
	{
		qDebug() << "[C++ AchievementsManager] Achievement Get: " << achievement->m_name;
		QString msg = QString("You just got %1 and earned %2 Fractons!").arg(achievement->m_name).arg(achievement->m_reward);
		
		emit achievementGet(achievement->m_name, achievement->m_reward);
	});
}

QString AchievementsManager::jsonAchievements() const
{
	QJsonDocument doc;
	
	QJsonArray arr;
	foreach (Achievement* acvm, m_achievements.values())
		arr.append(QJsonObject::fromVariantMap(acvm->toVariantMap()));
	doc.setArray(arr);
	
	return doc.toJson();
}

void AchievementsManager::clearAchievements()
{
	m_achievements.clear();
	emit achievementsChanged();
}


void AchievementsManager::debug()
{
	qDebug() << "Number of Achievements:";
	qDebug() << "  " << m_achievements.count();
	qDebug() << jsonAchievements();
	
}

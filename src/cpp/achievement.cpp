#include "achievement.h"

#include <QDebug>

Achievement::Achievement(QObject *parent) :
	QObject(parent)
{
	QObject::connect(this, &Achievement::nameChanged, this, &Achievement::achievementChanged);
	QObject::connect(this, &Achievement::descriptionChanged, this, &Achievement::achievementChanged);
	QObject::connect(this, &Achievement::hintChanged, this, &Achievement::achievementChanged);
	QObject::connect(this, &Achievement::groupChanged, this, &Achievement::achievementChanged);
	QObject::connect(this, &Achievement::rewardChanged, this, &Achievement::achievementChanged);
	QObject::connect(this, &Achievement::progressChanged, this, &Achievement::achievementChanged);
	QObject::connect(this, &Achievement::maxProgressChanged, this, &Achievement::achievementChanged);
	QObject::connect(this, &Achievement::isCollectedChanged, this, &Achievement::achievementChanged);
	
	QObject::connect(this, &Achievement::achievementGet, this,
					 [&] ()
	{
		qDebug() << "Achievment Get:" << this->m_name;
		
		
		if (this->m_isCollected == false)
		{
			this->m_isCollected = true;
			emit isCollectedChanged();
		}
	});
}

Achievement::Achievement(const Achievement &other)
{
	m_name = other.m_name;
	m_description = other.m_description;
	m_hint = other.m_hint;
	m_group = other.m_group;
	m_reward = other.m_reward;
	m_progress = other.m_progress;
	m_maxProgress = other.m_maxProgress;
	m_isCollected = other.m_isCollected;
}

Achievement& Achievement::operator= (const Achievement &other)
{
	m_name = other.m_name;
	m_description = other.m_description;
	m_hint = other.m_hint;
	m_group = other.m_group;
	m_reward = other.m_reward;
	m_progress = other.m_progress;
	m_maxProgress = other.m_maxProgress;
	m_isCollected = other.m_isCollected;
	
	return *this;
}

bool Achievement::operator==(const Achievement &other)
{
	return m_name == other.m_name &&
			m_description == other.m_description && 
			m_hint == other.m_hint && 
			m_group == other.m_group && 
			m_reward == other.m_reward && 
			m_progress == other.m_progress && 
			m_maxProgress == other.m_maxProgress && 
			m_isCollected == other.m_isCollected;
			
}

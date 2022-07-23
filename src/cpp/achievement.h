#ifndef ACHIEVEMENT_H
#define ACHIEVEMENT_H

#include <QObject>

/**
 * @brief The Achievement class
 * 
 * Progress is incremented in QML, specifically, in /qml/game/singles/GameAchievements.qml::addProgress.
 * Once the progress exceeds maxProgress, then the achievementGet signal is emitted.
 * The achievementGet signal is connected to a lambda setting isCollected to true.
 * 
 * If the achievement is going to be changed, remember to also modify the string used 
 * to create qml Achievement objects in /qml/games/singles/GameAchievements.qml::addAchievement 
 * and the object used to construct achievement properties in
 * /qml/games/singles/GameAchievements.qml::encodeAchievments
 * Remember to also modify 
 *	+ achievement.cpp with matching expressions.
 *	+ AchievementCard qml for objects
 * 
 */

class Achievement : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString	name		MEMBER m_name			NOTIFY nameChanged)
	Q_PROPERTY(QString	description	MEMBER m_description	NOTIFY descriptionChanged)
	Q_PROPERTY(QString	hint		MEMBER m_hint			NOTIFY hintChanged)
	Q_PROPERTY(QString	group		MEMBER m_group			NOTIFY groupChanged)
	Q_PROPERTY(int		reward		MEMBER m_reward			NOTIFY rewardChanged)
	Q_PROPERTY(int		progress	MEMBER m_progress		NOTIFY progressChanged)
	Q_PROPERTY(int		maxProgress	MEMBER m_maxProgress	NOTIFY maxProgressChanged)
	Q_PROPERTY(bool		isCollected	MEMBER m_isCollected	NOTIFY isCollectedChanged)
	
public:
	explicit Achievement(QObject *parent = nullptr);
	Achievement(const Achievement &other);
	
	QString m_name = "Name.";
	QString m_description = "Description.";
	QString m_hint = "Hint.";
	QString m_group = "Group.";
	int m_reward = 10;
	int m_progress = 0;
	int m_maxProgress = 100;
	bool m_isCollected = false;
	
	
	Achievement& operator= (const Achievement &other);
	bool operator== (const Achievement &other);
	
	QVariantMap toVariantMap() const;
	
signals:
	void nameChanged();
	void descriptionChanged();
	void hintChanged();
	void groupChanged();
	void rewardChanged();
	void progressChanged();
	void maxProgressChanged();
	void isCollectedChanged();
	
	void achievementChanged();
	void achievementGet();
	
};

#endif // ACHIEVEMENT_H

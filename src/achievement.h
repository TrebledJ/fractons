#ifndef ACHIEVEMENT_H
#define ACHIEVEMENT_H

#include <QObject>

/**
 * @brief The Achievement class
 * 
 * Progress is incremented in QML.
 * Once the progress exceeds maxProgress, then the achievementGet signal is emitted.
 * The achievementGet signal is connected to a lambda setting isCollected to true.
 */

class Achievement : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString	name		MEMBER m_name			NOTIFY nameChanged)
	Q_PROPERTY(QString	description	MEMBER m_description	NOTIFY descriptionChanged)
	Q_PROPERTY(int		reward		MEMBER m_reward			NOTIFY rewardChanged)
	Q_PROPERTY(bool		isSecret	MEMBER m_isSecret		NOTIFY isSecretChanged)
	Q_PROPERTY(int		progress	MEMBER m_progress		NOTIFY progressChanged)
	Q_PROPERTY(int		maxProgress	MEMBER m_maxProgress	NOTIFY maxProgressChanged)
	Q_PROPERTY(bool		isCollected	MEMBER m_isCollected	NOTIFY isCollectedChanged)
	
public:
	explicit Achievement(QObject *parent = nullptr);
	Achievement(const Achievement &other);
	
	QString m_name = "Name.";
	QString m_description = "Description.";
	int m_reward = 30;
	bool m_isSecret = false;
	int m_progress = 0;
	int m_maxProgress = 100;
	bool m_isCollected = false;
	
	
	Achievement& operator= (const Achievement &other);
	bool operator== (const Achievement &other);
	
signals:
	void nameChanged();
	void descriptionChanged();
	void rewardChanged();
	void isSecretChanged();
	void progressChanged();
	void maxProgressChanged();
	void isCollectedChanged();
	
	void achievementChanged();
	void achievementGet();
	
public slots:
	
private:
	
};

#endif // ACHIEVEMENT_H

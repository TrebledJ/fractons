#ifndef QUESTENGINE_H
#define QUESTENGINE_H

#include <QObject>
#include <QTimer>
#include <QDateTime>

/**
 * @brief The QuestEngine class
 * 
 * How Quests Work
 * + All possible are stored in storage (via QML).
 * + The selected daily quests are stored in storage.
 * + The datetime of the last quest purge is stored in storage.
 * + 
 * + 
 */

class QuestEngine : public QObject
{
	Q_OBJECT
public:
	explicit QuestEngine(QObject *parent = nullptr);
	
	Q_INVOKABLE
	void checkLastPurge(const QString &lastPurge);
	
	Q_INVOKABLE
	void setLastPurge(const QDateTime &dt);
	
	Q_INVOKABLE
	QString getLastPurge() const;
	
signals:
	void loadNewQuests();
	
public slots:
	void purgeTimer();
	QString getRemainingTime() const;
	
private:
	QTimer m_timer;
	QDateTime lastPurge;
	
};

#endif // QUESTENGINE_H

#ifndef QUESTENGINE_H
#define QUESTENGINE_H

#include <QObject>
#include <QTimer>
#include <QDateTime>

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

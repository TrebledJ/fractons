#ifndef QUESTENGINE_H
#define QUESTENGINE_H

#include <QObject>
#include <QTimer>

class QuestEngine : public QObject
{
	Q_OBJECT
public:
	explicit QuestEngine(QObject *parent = nullptr);
	
signals:
	void loadNewQuests();
	
public slots:
	void purgeTimer();
	QString getRemainingTime() const;
	
private:
	QTimer m_timer;
	
};

#endif // QUESTENGINE_H

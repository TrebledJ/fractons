#include "questengine.h"

#include <QDebug>

#include <QTime>
#include <QDateTime>

QuestEngine::QuestEngine(QObject *parent) : 
	QObject(parent)
{
	m_timer.setSingleShot(true);
	connect(&m_timer, &QTimer::timeout, this, &QuestEngine::loadNewQuests);
	purgeTimer();
	connect(&m_timer, &QTimer::timeout, this, &QuestEngine::purgeTimer);
}

void QuestEngine::purgeTimer()
{
	auto current = QDateTime::currentDateTime();
	auto midnight = current.addDays(1);
	midnight.setTime(QTime::fromString("00:00:00"));
	
	
	auto interval = current.msecsTo(midnight);
	m_timer.start(interval);
	
	qDebug() << "Quest Timer set to" << interval << "ms.";
	
}

QString QuestEngine::getRemainingTime() const
{
	auto msecs = m_timer.remainingTime();
	QTime time = QTime::fromMSecsSinceStartOfDay(msecs);
	
//	time.toString("h%1, ")
	
	QString hour = QString("%1 %2").arg(time.hour()).arg(time.hour() == 1 ? "hour" : "hours");
	QString minute = QString("%1 %2").arg(time.minute()).arg(time.minute() == 1 ? "minute" : "minutes");
	
	if (time.hour() == 0)
		return minute;
	
	if (time.minute() == 0)
		return hour;
	
	return hour + " and " + minute;
	
}

#include "questengine.h"

#include <QDebug>

#include <QTime>

QuestEngine::QuestEngine(QObject *parent) : 
	QObject(parent)
{
	m_timer.setSingleShot(true);
	purgeTimer();
	connect(&m_timer, &QTimer::timeout, this, &QuestEngine::loadNewQuests);
	connect(&m_timer, &QTimer::timeout, this, &QuestEngine::purgeTimer);
	
	connect(this, &QuestEngine::loadNewQuests, [&]()
	{
		lastPurge = QDateTime::currentDateTime();
	});
}

void QuestEngine::checkLastPurge(const QString& lastPurge)
{
	qDebug() << "[C++] Checking last purge..." << lastPurge;
	auto lastDateTime = QDateTime::fromString(lastPurge, "yyyy-MM-dd hh:mm:ss");
	auto todayMidnight = QDateTime::currentDateTime();
	todayMidnight.setTime(QTime::fromString("00:00:00"));
//	todayMidnight.setTime(QTime::fromString("19:00:00"));
	
	if (lastDateTime < todayMidnight)
	{
		qDebug() << "[C++] Quests needs to be updated.";
		loadNewQuests();
		purgeTimer();
	}
}

void QuestEngine::setLastPurge(const QDateTime& dt)
{
	lastPurge = dt;
}

QString QuestEngine::getLastPurge() const
{
	return lastPurge.toString("yyyy-MM-dd hh:mm:ss");
}

void QuestEngine::purgeTimer()
{
	qDebug() << "[C++] Purging quest engine timer...";
	
	auto current = QDateTime::currentDateTime();
	auto midnight = current.addDays(1);
	midnight.setTime(QTime::fromString("00:00:00"));
	
//	auto midnight = current;
//	midnight.setTime(QTime::fromString("19:00:00"));
	
	
	auto interval = current.msecsTo(midnight);
	m_timer.start(interval);
	
	qDebug() << "[C++] Quest Timer set to" << interval << "ms.";
}

QString QuestEngine::getRemainingTime() const
{
	auto msecs = m_timer.remainingTime();
	QTime time = QTime::fromMSecsSinceStartOfDay(msecs);
	
	qDebug() << "Requesting remaining time:" << msecs << "ms on time" << time;
	
//	time.toString("h%1, ")
	
	QString hour = QString("%1 %2").arg(time.hour()).arg(time.hour() == 1 ? "hour" : "hours");
	QString minute = QString("%1 %2").arg(time.minute()).arg(time.minute() == 1 ? "minute" : "minutes");
	
	if (time.hour() == 0)
		return minute;
	
	if (time.minute() == 0)
		return hour;
	
	return hour + " and " + minute;
	
}

/*
 * FilenameManipulator.h
 *
 *  Created on: Apr 5, 2014
 *      Author: bingo
 */

#ifndef FILENAMEMANIPULATOR_H_
#define FILENAMEMANIPULATOR_H_


#include <QObject>
#include <QFileInfo>
#include <QStringList>

class FilenameManipulator {
public:
	FilenameManipulator(QStringList l);
	virtual ~FilenameManipulator();
	bool doRename(void);
	void addTag(QString tagText);
	void removeTag(QString tagText);
	QString getCurrentNames();
	QString getPreview();
	QStringList getRecentTags();
private:
	QString makeTagString();
	QStringList fileList;
	QStringList fileListNew;
	QStringList tagList;
	QStringList recentTagList;
};


#endif /* FilenameManipulator_H_ */

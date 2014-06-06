/*
 * FilenameManipulator.cpp
 *
 *  Created on: Apr 5, 2014
 *      Author: bingo
 */

#include "FilenameManipulator.hpp"
#include <QDebug>

FilenameManipulator::FilenameManipulator(QStringList l) {
	// TODO Auto-generated constructor stub

	for (int i=0; i<l.length(); i++)
	{
		fileList.append(l.at(i));
		fileListNew.append(l.at(i));

		recentTagList.append("Ottawa");
		recentTagList.append("Shop");
		recentTagList.append("Sej");
	}
	//TODO initialise a QFileInfo array to rep all the files
}

FilenameManipulator::~FilenameManipulator() {
	// TODO Auto-generated destructor stub
}

QStringList FilenameManipulator::getRecentTags()
{
	return recentTagList;
}
void FilenameManipulator::addTag(QString tagText)
{
	tagList.append(tagText);
}

QString FilenameManipulator::makeTagString()
{
	// Append all tag's to each other to create a single string
	QString tagString = "";
	for (int i=0; i<tagList.length(); i++)
	{
		//if (i!=0)
			tagString = tagString + " " + tagList.at(i);
		//else
			//tagString = tagList.at(i);

	}

	return tagString;
}

QString FilenameManipulator::getPreview()
{
	QString previewText;
	QFileInfo f[fileList.length()];
	QString tagString = makeTagString();
	for (int i=0; i<fileList.length(); i++)
	{
		f[i] = (fileList.at(i));
		QString newName = f[i].baseName() + tagString + "." + f[i].completeSuffix();
		//fileListNew.replace(i, (f[i].absolutePath() + "/" + newName));
		if (i==0)
			previewText = "\"" + newName + "\"";
		else
			previewText = previewText + ", " + "\"" + newName + "\"";
	}

	return previewText;
}

QString FilenameManipulator::getCurrentNames(){
	QString nameText;
	QFileInfo f[fileList.length()];
	for (int i=0; i<fileList.length(); i++)
	{
		f[i] = (fileList.at(i));
		if (i==0)
		{
			nameText = "\"" + f[i].fileName() + "\"";
		}
		else
		{
			nameText = nameText + ", " + "\"" +  f[i].fileName() + "\"";
		}
	}
	return nameText;
}

bool FilenameManipulator::doRename()
{
	bool renameSucceeded = false;

	// Generate new filename list
	QFileInfo f[fileList.length()];
	QString tagString = makeTagString();
	for (int i=0; i<fileList.length(); i++)
	{
		f[i] = (fileList.at(i));
		QString newName = f[i].baseName() + tagString + "." + f[i].completeSuffix();
		fileListNew.replace(i, (f[i].absolutePath() + "/" + newName));
	}


	for (int i=0; i<fileList.length(); i++)
	{
		QFile f(fileList.at(i));
		renameSucceeded = f.rename(fileListNew.at(i));
		if (renameSucceeded == false)
			break;
	}

	return renameSucceeded;
}

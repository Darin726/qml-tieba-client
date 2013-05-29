/**
 * Copyright (c) 2011 Nokia Corporation and/or its subsidiary(-ies).
 * All rights reserved.
 *
 * For the applicable distribution terms see the license.txt -file, included in
 * the distribution.
 */

#include "drmfile.h"
#include "drmfile_p.h"

DRMFile::DRMFile(QObject *parent) :
        QObject(parent), d_ptr(new DRMFilePrivate())
{
	
}

DRMFile::~DRMFile()
{

}

int DRMFile::open(const QString & name)
{
    Q_D(DRMFile);
    return d->open(name);
}

int DRMFile::read(uchar*& data)
{
    Q_D(DRMFile);
    return d->read(data);
}

void DRMFile::close()
{
    Q_D(DRMFile);
    d->close();
}

int DRMFile::size()
{
    Q_D(DRMFile);
    return d->size();
}

#ifdef SYMBIAN_ENABLE_64_BIT_FILE_SERVER_API
qint64 DRMFile::size64()
{
    Q_D(DRMFile);
    return d->size64();
}
#endif

bool DRMFile::isDRMError(int error)
{
    return (DRMFilePrivate::isDRMError(error));
}

/**
 * Copyright (c) 2011 Nokia Corporation and/or its subsidiary(-ies).
 * All rights reserved.
 *
 * For the applicable distribution terms see the license.txt -file, included in
 * the distribution.
 */

#ifndef DRMFILE_H
#define DRMFILE_H

#include <QObject>

class DRMFilePrivate;

/**
 * @class DRMFile class
 *
 * @brief Utility API intended to demonstrate and facilitate access to DRM protected
 * content.
 *
 * The API has two private implementations, one Symbian specific - using the
 * Content Access Framework (CAF) API - and an empty one which enables the API
 * to be used (more like compiled) in the simulator
 */
class DRMFile : public QObject
{
    Q_OBJECT
    Q_DECLARE_PRIVATE(DRMFile)

public:
    /**
     * @brief Constructor
     *
     * @param parent
     */
    explicit DRMFile(QObject *parent = 0);

    /**
     * @brief Destructor
     *
     */
    virtual ~DRMFile();

public:

    /**
     * @brief Read only open method for the specified file
     *
     * const QString & name - fully cualified file name and path.
     *
     * Will return a negative error code if the file opening fails. The error
     * code should be checked with *isDRMError* in order to understand
     *
     * @param name
     */
    int open(const QString & name);

    /**
     * @brief Allocates memory buffer and reads the whole file content into 
     * that. Allocated buffer is returned to client via reference pointer 'data'
     * parameter. Client is responcible for allocated memory release
     *
     * Will return a negative error code or the read data length.
     *
     * @param data
     */
    int read(uchar*& data);

    /**
     * @brief Close the file.
     *
     */
    void close();

    /**
     * @brief Returns a 32b value size of the amount of available (uncompressed) data.
     *
     */
    int size();

#ifdef SYMBIAN_ENABLE_64_BIT_FILE_SERVER_API

    /**
     * @brief Returns a 64b value size of the amount of available (uncompressed) data.
     * Only supported starting with Symbian^3
     */
    qint64 size64();
#endif

    /**
     * @brief Returns true if the error code returned by the *open* method is a DRM
     * specific error
     *
     * @param error
     */
    static bool isDRMError(int error);

protected:
    /**
     * @variable Private implementation of the API
     */
    DRMFilePrivate* const d_ptr;
};

#endif // DRMFILE_H

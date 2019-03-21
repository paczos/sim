/*
Copyright 2005 - 2017 by Paolo Brandoli/Binarno s.p.

Imebra is available for free under the GNU General Public License.

The full text of the license is available in the file license.rst
 in the project root folder.

If you do not want to be bound by the GPL terms (such as the requirement
 that your application must also be GPL), you may purchase a commercial
 license for Imebra from the Imebra’s website (http://imebra.com).
*/

#include "imebra_bridgeStructures.h"


@implementation ImebraDicomDirEntry

-(id)initWithImebraDicomDirEntry:(imebra::DicomDirEntry*)pDicomDirEntry
{
    m_pDicomDirEntry = 0;
    self = [super init];
    if(self)
    {
        m_pDicomDirEntry = pDicomDirEntry;
    }
    else
    {
        delete pDicomDirEntry;
    }
    return self;
}

-(void)dealloc
{
    delete m_pDicomDirEntry;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(ImebraDataSet*)getEntryDataSet
{
    return [[ImebraDataSet alloc] initWithImebraDataSet:m_pDicomDirEntry->getEntryDataSet()];
}

-(ImebraDicomDirEntry*)getNextEntry
{
    std::unique_ptr<imebra::DicomDirEntry> pEntry(m_pDicomDirEntry->getNextEntry());
    if(pEntry == nullptr)
    {
        return nil;
    }
    return [[ImebraDicomDirEntry alloc] initWithImebraDicomDirEntry:pEntry.release()];
}

-(ImebraDicomDirEntry*)getFirstChildEntry
{
    std::unique_ptr<imebra::DicomDirEntry> pEntry(m_pDicomDirEntry->getFirstChildEntry());
    if(pEntry == nullptr)
    {
        return nil;
    }
    return [[ImebraDicomDirEntry alloc] initWithImebraDicomDirEntry:pEntry.release()];
}

-(void)setNextEntry:(ImebraDicomDirEntry*)pNextEntry error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pDicomDirEntry->setNextEntry(*(pNextEntry->m_pDicomDirEntry));

    OBJC_IMEBRA_FUNCTION_END();
}

-(void)setFirstChildEntry:(ImebraDicomDirEntry*)pFirstChildEntry error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pDicomDirEntry->setFirstChildEntry(*(pFirstChildEntry->m_pDicomDirEntry));

    OBJC_IMEBRA_FUNCTION_END();
}

-(NSArray*)getFileParts:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    NSMutableArray* pFileParts = [[NSMutableArray alloc] init];

    imebra::fileParts_t fileParts = m_pDicomDirEntry->getFileParts();
    for(const std::string& part: fileParts)
    {
        [pFileParts addObject: imebra::stringToNSString(part)];
    }

    return pFileParts;

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)setFileParts:(NSArray*)pFileParts error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    imebra::fileParts_t fileParts;

    size_t partsCount = [pFileParts count];
    for(size_t scanParts(0); scanParts != partsCount; ++scanParts)
    {
        fileParts.push_back(imebra::NSStringToString([pFileParts objectAtIndex:scanParts]));
    }

    m_pDicomDirEntry->setFileParts(fileParts);

    OBJC_IMEBRA_FUNCTION_END();
}


-(ImebraDirectoryRecordType_t)getType:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return (ImebraDirectoryRecordType_t)m_pDicomDirEntry->getType();

    OBJC_IMEBRA_FUNCTION_END_RETURN(ImebraDicomDirPatient);
}

-(NSString*)getTypeString:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return imebra::stringToNSString(m_pDicomDirEntry->getTypeString());

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

@end



@implementation ImebraDicomDir

-(id)initWithImebraDicomDir:(imebra::DicomDir*)pDicomDir
{
    m_pDicomDir = 0;
    self = [super init];
    if(self)
    {
        m_pDicomDir = pDicomDir;
    }
    return self;
}

-(id)init
{
    m_pDicomDir = 0;
    self = [super init];
    if(self)
    {
        m_pDicomDir = new imebra::DicomDir();
    }
    return self;
}

-(id)initWithDataSet:(ImebraDataSet*)pDataSet error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pDicomDir = 0;
    self = [super init];
    if(self)
    {
        m_pDicomDir = new imebra::DicomDir(*(pDataSet->m_pDataSet));
    }
    return self;

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)dealloc
{
    delete m_pDicomDir;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif

}

-(ImebraDicomDirEntry*)getNewEntry:(ImebraDirectoryRecordType_t)recordType error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraDicomDirEntry alloc] initWithImebraDicomDirEntry:m_pDicomDir->getNewEntry((imebra::directoryRecordType_t)recordType)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(ImebraDicomDirEntry*)getFirstRootEntry:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraDicomDirEntry alloc] initWithImebraDicomDirEntry:m_pDicomDir->getFirstRootEntry()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)setFirstRootEntry:(ImebraDicomDirEntry*)firstEntryRecord error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    m_pDicomDir->setFirstRootEntry(*(firstEntryRecord->m_pDicomDirEntry));

    OBJC_IMEBRA_FUNCTION_END();
}

-(ImebraDataSet*)updateDataSet:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [[ImebraDataSet alloc] initWithImebraDataSet:m_pDicomDir->updateDataSet()];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

@end

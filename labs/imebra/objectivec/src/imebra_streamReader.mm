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


@implementation ImebraStreamReader

-(id)initWithImebraStreamReader:(imebra::StreamReader*)pStreamReader
{
    self->m_pReader = 0;
    self = [super init];
    if(self)
    {
        self->m_pReader = pStreamReader;
    }
    else
    {
        delete pStreamReader;
    }
    return self;

}

-(id)initWithInputStream:(ImebraBaseStreamInput*)pInput
{
    self->m_pReader = 0;
    self = [super init];
    if(self)
    {
        self->m_pReader= new imebra::StreamReader(*(pInput->m_pBaseStreamInput));
    }
    return self;

}

-(id)initWithInputStream:(ImebraBaseStreamInput*)pInput virtualStart:(unsigned int)virtualStart virtualEnd:(unsigned int)virtualEnd
{
    self->m_pReader = 0;
    self = [super init];
    if(self)
    {
        self->m_pReader= new imebra::StreamReader(*(pInput->m_pBaseStreamInput), virtualStart, virtualEnd);
    }
    return self;

}

-(void)dealloc
{
    delete self->m_pReader;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(ImebraStreamReader*)getVirtualStream:(unsigned int)virtualSize error:(NSError**)pError
{
    OBJC_IMEBRA_FUNCTION_START();

    return [ [ImebraStreamReader alloc] initWithImebraStreamReader:self->m_pReader->getVirtualStream(virtualSize)];

    OBJC_IMEBRA_FUNCTION_END_RETURN(nil);
}

-(void)terminate
{
    self->m_pReader->terminate();
}

@end

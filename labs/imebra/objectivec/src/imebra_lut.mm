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

@implementation ImebraLUT

-(id)initWithImebraLut:(imebra::LUT*)pLUT
{
    m_pLUT = 0;
    self =  [super init];
    if(self)
    {
        m_pLUT = pLUT;
    }
    else
    {
        delete pLUT;
    }
    return self;

}

-(void)dealloc
{
    delete m_pLUT;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(ImebraReadingDataHandlerNumeric*) getReadingDataHandler
{
    return [[ImebraReadingDataHandlerNumeric alloc] initWithImebraReadingDataHandler:m_pLUT->getReadingDataHandler()];
}

-(unsigned int)getMappedValue:(int)index
{
    return (unsigned int)m_pLUT->getMappedValue((std::int32_t)index);
}

-(NSString*)description
{
    return imebra::stringToNSString(m_pLUT->getDescription());
}

-(unsigned int) bits
{
    return (unsigned int)m_pLUT->getBits();
}

-(unsigned int) size
{
    return (unsigned int)m_pLUT->getSize();
}

-(int) firstMappedValue
{
    return (int)m_pLUT->getFirstMapped();
}

@end



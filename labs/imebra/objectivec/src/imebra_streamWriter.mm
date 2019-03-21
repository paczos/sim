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

@implementation ImebraStreamWriter: NSObject

-(id)initWithImebraStreamWriter:(imebra::StreamWriter*)pStreamWriter
{
    self->m_pWriter = 0;
    self = [super init];
    if(self)
    {
        self->m_pWriter = pStreamWriter;
    }
    else
    {
        delete pStreamWriter;
    }
    return self;
}

-(id)initWithOutputStream:(ImebraBaseStreamOutput*)pOutput
{
    self->m_pWriter = 0;
    self = [super init];
    if(self)
    {
        self->m_pWriter = new imebra::StreamWriter(*(pOutput->m_pBaseStreamOutput));
    }
    return self;
}

-(id)initWithInputOutputStream:(ImebraBaseStreamInputOutput*)pInputOutput
{
    self->m_pWriter = 0;
    self = [super init];
    if(self)
    {
        self->m_pWriter = new imebra::StreamWriter(*(dynamic_cast<imebra::BaseStreamOutput*>(pInputOutput->m_pBaseStreamInput)));
    }
    return self;
}

-(void)dealloc
{
    delete self->m_pWriter;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif

}

@end




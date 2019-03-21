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

@implementation ImebraModalityVOILUT


-(id)initWithDataSet:(ImebraDataSet*)pDataSet
{
    m_pTransform = 0;
    self = [super init];
    if(self)
    {
        m_pTransform = new imebra::ModalityVOILUT(*(pDataSet->m_pDataSet));
    }
    return self;
}

@end



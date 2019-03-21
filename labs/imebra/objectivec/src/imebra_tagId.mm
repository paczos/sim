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

///
/// \brief Specifies an age, in days, weeks, months or years.
///
///////////////////////////////////////////////////////////////////////////////
@implementation ImebraTagId

-(id)init
{
    self = [super init];
    if(self)
    {
        self->m_pTagId = new imebra::TagId();
    }
    return self;
}


-(id)initWithId:(ImebraTagId_t)tagId
{
    self = [super init];
    if(self)
    {
        self->m_pTagId = new imebra::TagId((imebra::tagId_t)tagId);
    }
    return self;
}


-(id)initWithGroup:(unsigned short)groupId tag:(unsigned short)tagId
{
    self = [super init];
    if(self)
    {
        self->m_pTagId = new imebra::TagId(groupId, tagId);
    }
    return self;

}

-(id)initWithGroup:(unsigned short)groupId groupOrder:(unsigned int)groupOrder tag:(unsigned short)tagId
{
    self = [super init];
    if(self)
    {
        self->m_pTagId = new imebra::TagId(groupId, groupOrder, tagId);
    }
    return self;

}

-(void)dealloc
{
    delete m_pTagId;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(unsigned short) groupId
{
    return m_pTagId->getGroupId();
}

-(unsigned int) groupOrder
{
    return m_pTagId->getGroupOrder();
}

-(unsigned short) tagId
{
    return m_pTagId->getTagId();
}

@end


/*
 Kvalobs - Free Quality Control Software for Meteorological Observations 

 Copyright (C) 2010 met.no

 Contact information:
 Norwegian Meteorological Institute
 Box 43 Blindern
 0313 OSLO
 NORWAY
 email: kvalobs-dev@met.no

 This file is part of KVALOBS

 KVALOBS is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License as 
 published by the Free Software Foundation; either version 2 
 of the License, or (at your option) any later version.
 
 KVALOBS is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 General Public License for more details.
 
 You should have received a copy of the GNU General Public License along 
 with KVALOBS; if not, write to the Free Software Foundation Inc., 
 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

#ifndef KVALOBSDATAACCESS_H_
#define KVALOBSDATAACCESS_H_

#include "DataAccess.h"

namespace kvservice
{

class KvalobsDataAccess: public kvservice::DataAccess
{
public:
	KvalobsDataAccess();
	virtual ~KvalobsDataAccess();

    virtual void getData( KvDataList &data, int station,
                  const miutil::miTime &from, const miutil::miTime &to,
                  int paramid, int type, int sensor, int lvl ) const;

    /// station==0 means all stations
    void getAllData(KvDataList & data, const miutil::miTime &from, const miutil::miTime &to, int station = 0) const;

    virtual CKvalObs::CDataSource::Result_var sendData( const KvDataList & data );
};

}

#endif /* KVALOBSDATAACCESS_H_ */

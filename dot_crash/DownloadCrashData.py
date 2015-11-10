#!/usr/bin/env python
# DownloadCrashData.py
# author:  John Reiser <jreiser@njgeo.org>
# purpose: Downloads and extracts the NJ DOT Crash Data.
# license: GPLv3, Copyright (C) 2015, John Reiser
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# ---------------------------------------------------------------------------

import urllib, os, sys, zipfile

def download(url,name=""):
    if(name == ""):
        name = url.split('/')[-1]
    webFile = urllib.urlopen(url)
    localFile = open(name, 'w')
    fname = localFile.name
    localFile.write(webFile.read())
    webFile.close()
    localFile.close()
    return fname


years = [str(x) for x in range(2001,2015)]
counties = ["Atlantic", "Bergen", "Burlington", "Camden", "CapeMay", "Cumberland", "Gloucester", "Hudson", "Hunterdon", "Mercer", "Monmouth", "Morris", "Ocean", "Passaic", "Salem", "Somerset", "Sussex", "Union", "Warren"]
types = ["{0}.zip".format(x) for x in ('Accidents', 'Drivers', 'Vehicles', 'Occupants', 'Pedestrians')]
baseurl = "http://www.state.nj.us/transportation/refdata/accident/{0}/{1}{2}"

for year in years:
    for county in counties:
        cy = county + year
        for type in types:
            url = baseurl.format(year, cy, type)
            zfn = "{0}_{1}_{2}".format(year, county, type) # ZIP file name
            if(os.path.exists(zfn)):
                print zfn, "already downloaded."
            else:
                print "Downloading", url
                fn = download(url, zfn)
                zipf = zipfile.ZipFile(fn, "r")
                names = zipf.namelist()
                if(len(names)==1):
                    if(not os.path.exists(names[0])):
                        outz = open(names[0], "wb")
                        outz.write(zipf.read(names[0]))
                        outz.close()
                        print names[0], "extracted."
                    else:
                        print names[0], "already exists. Skipped."

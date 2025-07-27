DEBRECEN PHOTOHELIOGRAPHIC DATA (DPD)
 
Explanations to the types of state of DPD volumes

Incomplete:  There are some days with missing observations. 
Complete:    The year has full daily coverage of sunspot data.
Preliminary: The dataset has already undergone some quality control but some further 
	     systematic checks and improvements of data are still needed. 
	     Mainly the grouping of sunspots requires revision but the area and position 
	     data also need to be looked for outliers.
Final:       The revision of the data is completed by Tünde Baranyi. 
             No further systematic quality control is planned. However, some improvements 
             may be done if errors or outliers are found in an unexpected way.
 
 

I N T R O D U C T I O N


   The Debrecen Photoheliographic Data (DPD) is a catalogue of positions
and areas of sunspots for all days compiled by using white-light full disc 
observations taken at the Heliophysical Observatory of the 
Hungarian Academy of Sciences (Debrecen, Hungary) and its Gyula Observing 
Station as well as at some other observatories. The contributing observatories 
are: Abastumani Astrophysical Observatory (Georgia), Ebro Observatory (Spain), 
Helwan Observatory (Egypt), Kanzelhoehe Solar Observatory (Austria), Kiev 
University Observatory (Ukraine), Kislovodsk Observing Station of Pulkovo 
Observatory (Russia), Kodaikanal Observatory (India) and Tashkent Observatory (Uzbekistan). 

When no ground-based observation was found, space-born quasi-continuum images
obtained by the Michelson Doppler Imager (MDI) on the board of 
Solar and Heliospheric Observatory (SOHO) were used.


   In some cases, when there were gaps in our observations but when no spots 
were reported by the observatories involved in the Solar Geophysical Data, we 
decided that there was no need to request plates for these spotless days. 
In these cases we refer to the station (Boulder, Holloman or Ramey) and time 
of observation indicated in the SGD as reporting on a spotless disc. 

   Each data file contains or will contain the results of a whole year.  
An occasional "i" letter in the filename designates a temporarily incomplete 
material in some sense (missing days and/or unchecked data).

   The DPD catalogues are divided into two parts. The numerical part contains
the measured position and area data. It is important to note that a new
method of area measurement was used for the plates of 1988 and after that.
The second part contains the CCD scans of all the active regions that were
found on the photographic plates. Every measured spot is marked with the
same number in the picture as in the numerical catalogue. The images
along with the measured data allow more complex analysis, morphological
studies and comparison with magnetic, H-alpha and other observations.
The CCD scans for 1986-87 were published in The Journal of Astronomical Data
(http://www.vub.ac.be/STER/JAD/jad.htm). The papers (Győri et al. 1998b, 2000)
with the FITS images published in the JAD are reproduced on our site from
JAD 4, 2 (1998)and JAD 6, 1 (2000) with permission. The printed volumes are
published in the Publication of Debrecen Observatory Heliographic Series
with a CD supplement (Győri et al. 1996, 1998a, 2001).

THE NUMERICAL CATALOGUE

   The positions and areas of sunspot groups for every day were published
at Greenwich (Greenwich Photoheliographic Results) until 1976. After that
date Debrecen Heliophysical Observatory took over this task.
The history and description of the Debrecen Observatory as well as its
observational material can be found in the volume of Debrecen
Photoheliographic Results 1977 (Dezső et al. 1987).
For general information see also the papers of Dezső L. (1967,1982).

   The daily photospheric observations are taken both in Debrecen and at the
Gyula Observing Station (150 km from Debrecen) which officially belongs to
the Debrecen Observatory. The Debrecen-Gyula archive comprises about 100,000
plates covering four decades. The DPD catalogue is compiled on the basis of
these archives. For those days in which no observations were obtained in
Hungary we use the observations of the cooperating observatories. At our
observatory several serii of observations are taken each day, a series
usually consisting of three photographic plates exposed within a time
interval of 15 minutes. We choose the best triplet (the best pair or single
plate if no complete triplet is available) for every day. From the other
observatories we received plate for a day, and from Kodaikanal only
the contact copies of the original plates were sent.


OBSERVATIONS AND DATA

   The method of position measurements is based on the software and procedure 
developed by L. Győri, which is basically similar to that used by Dezső et 
al. (1987). The time of observations and the positions measured on the used 
plates are averaged. The mean precision of the positions in DPD is 0.1
heliographic degrees. The precision of the positions is usually better than 
0.1 heliographic degrees in case of Gyula and it is slightly less accurate 
in the case of the other observatories. The position of a spot means the 
position of the centre of the umbra if we could separate the umbra from the 
penumbra. If we could not identify any umbrae in the penumbra, we measured 
the position of the centre of the penumbra. We measured every spot which 
could have been recognized as such, depending on the quality of the observation. 
The numbering of spots was made arbitrarily on each series of observation, 
thus, the number of a specific spot usually changes from one day to the next. 

   Since 1988 the area measurements have been based on the CCD scans of the 
best of the plates. This new method of area measurements is described in the 
paper by Győri (1998). In this automatic method of area measurements the 
"spot" means a local intensity maximum on the negative image of a sunspot 
group. In some cases the umbra contains several "spots" which cannot be 
separated with intensity contour lines without lost area. In these cases the 
"spots" share a common umbra. The area of the umbra is indicated at one of 
these "spots" and the appropriate columns of the other ones contain only a 
reference to its No. with negative sign. The situation is similar 
to the case when several umbrae share a common penumbra.

  Concerning the basic data, differences between the new and old procedures do
not result in significant inconsistencies between the volumes of the catalogue.
The development of the measuring procedure and devices may result in some slight 
systematic differences (see e.g. Baranyi et al. 2001). 


   The DPD is published as an ASCII file on the CD-ROM and it contains the
area and position of each spot, the total areas and the mean positions of
the sunspot groups, and the daily sums of the area of groups. The following
data are available for each spot: time of observation, the NOAA number of
its group, the measured (projected) and the corrected (for foreshortening)
areas of umbrae (U) and the whole spot (WS), latitude (B), longitude (L),
distance in longitude from the central meridian (LCM or CMD), position angle
(measured eastward from the north pole of the Sun's axis) and distance from
the disc's center expressed in solar radii.


   The total area is the sum of the areas of each spot in a group. The mean
positions of the group were calculated by multiplying the positions of all
separately measured components of the group by their corrected W areas,
and by dividing the sums of these products by the sum of the areas. When
there were more than one umbrae in a penumbra, the position of the centre of
gravity of this component was computed by weighting the positions of the
umbrae with the corrected U areas before calculating the mean position of
the whole group. If a group was intermittent then zero areas are indicated
and no position is given.

   The Julian Date is also included in the table in order to facilitate the
usage of the long time-series. We appended the values of P (position angle
of the northern extremity of the axis of rotation, measured eastwards from
the north point of the disk) and B0 (heliographic latitude of the central
point of the disk) at the time of observation to the row of the daily data.
The value of L0 (heliographic longitude of the central point of the disk)
can be easily calculated as L-LCM.

   For numbering the groups we used the NOAA/USAF sunspot group numbers
published in the tables of the Solar Geophysical Data (Coffey: SGD).
If there was no data in the SGD for a group found by us, we created a
new number by attaching the letters m, n,... to a NOAA number existing at
about the same time.

   As we do not investigate the magnetic polarities of spots, it may
sometimes happen that the separation of nearby groups does not exactly
correspond to the polarity conditions. However, we try to avoid that case
in which a spot of a group "leaves" its group and "joins" another
one. This means that we try to find the separating line between the same
spots of two nearby groups on each day. This intention sometimes causes
deviation from the NOAA numbering. For example two nearby groups rotated
onto the disc on April 6, 1987: NOAA 4787 and 4790.
Because of the evolution of NOAA 4787, the large single spot of NOAA 4790
got into the common penumbra of several umbrae of NOAA 4787 by April 11,
and they cannot be separated since that time. Thus, we decided to indicate
the whole complex as NOAA 4787 since April 6. However, there was another case
when we had to follow another strategy. On December 21, 1993 the complex
of NOAA 7640+7641+7644 rotated onto the disc in which mainly the separation
of the following part of 7640 and the preceding part of 7644 was hardly determinable.
During the first few days it seemed to be better not to separate them, but after that
the complex became too large, and the separation was unavoidable. Thus, we had to
separate them at the most probable separation line from December 21.  However,
the preceding part of 7644 got into a common penumbra with the following part
of 7640 on December 30, and the separation can not be made in the necessary form.
We had no choice, we had to regroup this part of the complex, and
all the spots in this penumbra were group to the NOAA 7640 causing a sudden jump
in its whole area.

   The following examples show further types of problematic numberings. 
For instance the same group was indicated as NOAA 5227 by some
stations, and as NOAA 5236 by the others on 7 and 8 November, 1988. A new
group appeared close to this group on 11. Some stations separated these
groups, and the new one was observed as NOAA 5236 between 11 and 14. The
others indicated the whole complex as NOAA 5227 at the same time. After that
time every station numbered this complex as 5227 till 17. We indicated it as
NOAA 5227 from 7 to 17.

   The group 5080 was observed between 18-20 July, 1988. On 26 July a group
was seen again at about the same location. Five stations indicated this group
as 5091, but two stations found that the group 5080 reappeared after its
intermittent state. We indicated the new group as 5091.

   When the groups were relatively close to each other, and most stations did
not separate them, we usually indicated them as one group, and chose the
number used by most of the stations (e.g. 5025 and 5025A). When the groups were
at relatively large distance, we usually decided to separate them
independently from the number of separating stations (e.g. 4990 and 4990A).

   We cannot list all the problematic numberings, but these examples show
that some kinds of comparative studies need the investigations of the
specific cases. For instance, comparison of areas of sunspot groups of
different observatories, and study of motion and evolution of groups may
demand the special investigation of positions, areas, magnetograms and CCD
scans of groups.

   It is important to note that the sporadic spots of a region of weak
magnetic field usually is indicated as spots of the same group. This means
that different spots of the group may be seen on consecutive days, which can
cause apparent jumps of several degrees in the position (e.g. 5124a).

   In special cases the position of a larger group can also show such
apparent jumps. For example the group 4720 was seen between 24-27 March, 1986.
On 28 March this group was intermittent, but another group appeared near it
on this day, and this new group was still seen next day. On 30 March the new
group died out but the old one appeared again. The SGD indicated them as 4720
during the whole time, thus, we insisted on this number. These cases should be
selected out in the case of studying of motion of spots.

THE IMAGES

   We want to put all information contained by our observations at the
disposal of any interested member of the solar community. This is why we also
publish the CCD scans of the sunspot groups with the marks of the measured
spots. This part of the publication allows the supplementation of our data
with additional observational data (magnetic polarities, etc.) from other
sources.

   The images are given in FITS format. Each file name is created from the
NOAA sunspot group number as well as the date and time of observation
in the form of NOAA_YYYYMMDD_HHMMSS. 
For example 8009_19970105_092335 means that the file contains the image of 
the group 8009 on 1st of January 1997 at 9 hour 23 min. 35 sec.


   The header contains the size of the image, the date (day/month/year) and
the time of the observation (hour:min:sec), the NOAA number of the group,
the name of the observing station, the resolution in the sky in arcsec/pixel
in the directions of the rows and columns.

   Since 1988 these data have also been depicted in the image with the
exception of the resolution. To orientate the images the heliographic North
and West directions belonging to the disc's centre are indicated. The lengths
of the bars mean 1 heliographic degree in the directions of rows and columns
of the image belonging to the centre of the image centre. The date is written
as usual: month/day/year.

   For 1986-87 the vertical edges of the images are oriented to the North
direction within one degree. More precisely, the columns of the arrays are in
the geocentric North direction to within a few tenths of a degree. To
orientate the images to the direction of the Sun's axis of rotation the
values of "P" have to be taken into account.

   To create the FITS images sine 1988 we usually used those scans which were
measured with the automatic method. The original CCD scans usually have
16-bit gray level resolution but they are transformed to 8-bit FITS images.
In some cases we had to use a camera of 8-bit gray level. On account of the
limit of 256 gray levels the dynamics of the original images cannot be
maintained. Thus, the quality of the FITS image may be lower than that of
the original observation.

   The scans are filtered and the limb darkening is extracted from them
in the most cases, which usually improves the quality and helps to find
the spots. However sometimes these procedures give an unusual outlook
to the images containing the limb or other special feature (drawing or defect).
The larger umbrae may be overexposed in order to make the smaller spots
more prominent. Sometimes there are some features in the pictures which
do not belong to the Sun. These are the cross-wires or their filtered paths,
the segment of the second exposure (which helps to measure the geocentric
North direction) and inhomogeneities or plate defects. These should be ignored.

   The images for 1986-87 are simple scans of the photographic plates, thus
the photosphere is dark and the spots are light. Since 1988 we have created
inverse images so that the appearance will be more familiar and the marks will
be better seen.

The resolution of SOHO/MDI images was increased with a special method which
results in a 3 times enlargement of the original image. In spite of this,
the area data may have an about 10 percent systematic deviation from that of
the ground-based observations because of the relatively small plate scale
(Győri et al. 2002, 2004).

The images in jpg format are the conversions of FITS images. They make the 
quick browsing possible between the sunspot groups. 
While creating these jpg images, we tried to find optimal settings
of brightness, contrast, and gamma providing good overall appearance on the 
monitor but in lots of cases we could not avoid the saturation of umbrae 
if we wanted the small spots to remain noticeable.

ACKNOWLEDGMENTS

Thanks are due to everyone participating in the daily routine observations
and helping us in this work.

We express our deepest gratitude to the collaborating observatories and 
the colleagues there for putting the necessary material at our disposal:
Kislovodsk Observing Station of Pulkovo Observatory: Dr. V.I. Makarov, Dr. A. Tlatov,
Abastumani Astrophysical Observatory: Dr. T. Zaqarashvili, Dr. E. Khutsishvili, Dr. V. Kulijanishvili,
Ebro Observatory: Dr. L.F. Alberca, Dr. J.J. Curto, Dr. G. Sole
NRIAG Helwan Observatory: Dr. M.A. Soliman, Dr. A.A. Galal, Dr. E. Bebars,
Kanzelhoehe Solar Observatory: Dr. T. Pettauer, W. Otruba,
Kodaikanal Observatory of the Indian Institute of Astrophysics: Dr. S.P. Bagare,
Kiev University Observatory: Dr. V.G. Lozitsky, 
Mount Wilson Observatory: Dr. R. Ulrich, L. Webster,  
Tashkent Observatory of Ulugh Beg Astronomical Institute: Dr. I. Sattarov.

SOHO is a mission of international cooperation between ESA and NASA. We gratefully
acknowledge the past and ongoing effort of the MDI team.

   We highly appreciate the generous permission of Dr. C. Sterken and The
Journal of Astronomical Data. The papers (Győri et al. 1998b, 2000) with the 
FITS images published in the JAD are reproduced on our site from JAD 4, 2 (1998) 
and JAD 6, 1 (2000) with permission.

   The DPD 1996 was supported by grants of the Hungarian National Foundation
for Scientific Research Nos. OTKA T037725 and T025640 as well as by 
SCOSTEP as supplemental STEP project entitled " Sunspot Blocking Database". 

   The DPD 1995 was supported by grant of the Hungarian National Foundation
for Scientific Research No. OTKA T037725.   

   The DPD 1993 and 1994 was supported by grants of the Hungarian National Foundation
for Scientific Research Nos. OTKA T037725, T025640, T026165, F019829 as well as by
U.S.-Hungarian Joint Fund for Science and Technology under contract No. 95a-524.

   The DPD 1988 was supported by grants of the Hungarian National Foundation
for Scientific Research Nos. OTKA T025640, T026165, F019829 as well as by
U.S.-Hungarian Joint Fund for Science and Technology under contract No. 95a-524.

  The DPD 1987 was supported by grants of the Hungarian National Foundation
for Scientific Research Nos. OTKA T025640, F019829, P31104 as well as by
U.S.-Hungarian Joint Fund for Science and Technology under contract No. 95a-524.

  The DPD 1986 was supported by grants of the Hungarian National Foundation
for Scientific Research Nos. OTKA T007422, T014036, F4142 and U21342.




REFERENCES

Baranyi, T., Győri,L., Ludmány,A., Coffey, H.E., 2001, Comparison of sunspot
   area data bases, MNRAS, 323, 223.
Coffey, H.E.(ed.) Solar-Geophysical Data
Dezső, L. 1967, Debrecen Heliophysical Observatory (Report from Solar Institute)
   Solar Physics 2, 129.
Dezső, L. 1982, Debrecen Heliophysical Observatory (Report from a Solar Observatory)
   Solar Physics 79, 195.
Dezső, L. Kovács ő., Gerlei, O. 1987, Debrecen Photoheliographic Results for the year 1977,
   Publ. Debrecen Obs. Heliographic Series No. 1.
Győri, L.: 1998, Automation of area measurement of sunspots, Solar Physics 180, 109.
Győri, L, Baranyi, T., Csepura, G., Gerlei, O., Ludmány, A. 1996,
   Debrecen Photoheliographic Data for the year 1986,
   Publ. Debrecen Obs. Heliographic Series No. 10.
Győri, L, Baranyi, T., Csepura, G., Gerlei, O., Ludmány, A. 1998a,
   Debrecen Photoheliographic Data for the year 1987,
   Publ. Debrecen Obs. Heliographic Series No. 11.
Győri L., Baranyi T., Csepura G., Gerlei O., Ludmány A. 1998b,
   Debrecen Photoheliographic Data for 1986 with image supplements,
   Journ. Astron. Data, 4, 2.
Győri, L., Baranyi, T., Csepura, G., Gerlei, O., Ludmány, A. 2000,
   Debrecen Photoheliographic Data for 1987 with image supplements,
   Journ. Astron. Data, 6, 1.
Győri, L, Baranyi, T., Ludmány, A., Gerlei, O., Csepura, G., 2001,
   Debrecen Photoheliographic Data for the year 1988,
   Publ. Debrecen Obs. Heliographic Series No. 12.
Győri, L., Baranyi, T., Turmon, M., Pap, J.M.: 2002, Comparison of image-processing 
   methods to extract solar features, ESA SP-508 (Proc. SOHO-11, Davos, 2002), 203-208.
Győri, L., Baranyi, T., Turmon, M., Pap, J.M.: 2004, Study of differences between 
   sunspot area data determined from ground-based and space-borne observations, 
   Adv. Space Res.,34, 269-273. 
Győri, L., Baranyi, T., Ludmány, A., Csepura, G., Gerlei, O., Mező, G.: 2004
   Debrecen Photoheliographic Data for the years 1993-95,
   Publ. Debrecen Obs. Heliographic Series No. 17-19.

THE NUMBER OF OBSERVATIONS PER OBSERVING STATION IN THE CATALOGUES AND THE NAMES OF THE OBSERVERS IF IT IS KNOWN:

1986: Gyula          257 (L. Győri, Z. Lengyelné, F. Seres, I. Lengyel)
      Debrecen        52 (A. Kovács, L. Gesztelyi, I. Nagy, A. Ludmány, G. Csepura, T. Baranyi, O. Gerlei)
      Kislovodsk      30 (V.V. Makarova, V.V. Valentinovna, E.I. Davydova, and many others)
      Boulder         18
      Ramey            5
      Holloman         3

1987: Gyula          245 (Z. Lengyelné, I. Lengyel, F. Seres, L. Győri)
      Debrecen        53 (A. Ludmány, A. Kovács, I. Nagy, G. Csepura, L. Gesztelyi, T. Baranyi, O. Gerlei,)
      Kislovodsk      46 (V.V. Makarova, V.V. Valentinovna, E.I. Davydova, and many others)
      Boulder          7
      Kodaikanal       3
      Ramey            3
      Tashkent         3
      Ebro             2 (J. Cid)
      Kiev             2
      Abastumani       1 (A. Tskhovrebadze) 

1988: Gyula          243 (Z. Lengyelné, I. Lengyel, L. Győri, F. Seres)
      Debrecen        61 (G. Csepura, A. Kovács, J. Csepurané, A. Ludmány, L. Gesztelyi, O. Gerlei, I. Nagy, T. Baranyi)
      Kislovodsk      52 (V.V. Makarova, V.V. Valentinovna, E.I. Davydova, and many others)
      Kodaikanal       3
      Tashkent         3
      Abastumani       2 (A. Tskhovrebadze) 
      Ebro             2 (J. Cid)

1989: Gyula          248 (Z. Lengyelné, I. Lengyel, L. Győri)
      Kislovodsk      59 (V.V. Makarova, V.V. Valentinovna, E.I. Davydova, and many others)
      Debrecen        38 (A. Ludmány, I. Nagy, G. Csepura, J. Csepurané, O. Gerlei)
      Helwan          15 (M. Khaleel, M. Quassim, M. Gareeb, M. El sayed)
      Kiev             2 (T. Redyuk) 
      Kodaikanal       2
      Ebro             1 (J. Cid)


1993: Gyula          178 (Z. Lengyelné, I. Lengyel, L. Győri, A. Ludányi)
      Debrecen       128 (A. Ludmány, A. Kovács, G. Csepura, J. Kiss, G. Makó, T. Baranyi, O. Gerlei, I. Nagy)
      Kislovodsk      49 (V.V. Makarova, V.V. Valentinovna, E.I. Davydova, and many others)
      Kanzelhoehe      7 (H. Freislich, W. Otruba, T. Pettauer, A. Schroll)
      Helwan           2 (E. Bebars, M. Khaleel)
      Kiev             1 (O. Lushnikova)

1994: Gyula          258 (A. Ludányi, I. Lengyel, L. Győri)
      Debrecen        42 (A. Ludmány, G. Csepura, A. Kovács, G. Makó, J. Kiss, T. Baranyi)
      Kislovodsk      31 (V.V. Makarova, V.V. Valentinovna, E.I. Davydova, and many others)
      Kanzelhoehe     29 (H. Freislich, W. Otruba, T. Pettauer, A. Schroll)
      Ramey            4
      Kiev             1

1995: Gyula          197 (A. Ludányi, I. Lengyel, L. Győri)
      Debrecen        78 (A. Kovács, A. Ludmány, J. Kiss, O. Gerlei, G. Csepura, G. Makó, T. Baranyi)
      Kanzelhoehe     55 (H. Freislich, W. Otruba, T. Pettauer, A. Schroll)
      Kislovodsk      26 (V.V. Makarova, V.V. Valentinovna, E.I. Davydova, and many others)
      Ramey            4
      Helwan           2 (S. El gezerry)
      Ebro             1 (J. Cid)
      Kodaikanal       1
      Mount Wilson     1 (N. Johnson)

1996: Debrecen       144 (A. Ludmány, J. Kiss, G. Makó, A. Kovács, L. Tóth, G. Csepura, O. Gerlei)
      Gyula          125 (A. Ludányi, I. Lengyel, L. Győri)
      Kanzelhoehe     44 (H. Freislich, W. Otruba, T. Pettauer, A. Schroll)
      Ramey           24
      Kislovodsk      23 (V.V. Makarova, V.V. Valentinovna, E.I. Davydova, and many others)
      Helwan           3 (M. Khaleel, S. El gezerry)
      Ebro             1 (J. Cid)
      Kodaikanal       1
      SOHO/MDI         1

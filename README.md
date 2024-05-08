Harris Lines Tool
======

The Harris lines tool has been developed in oder to semi-automatically detect and analyze Harris lines in digital X-ray images of tibiae of large populations. With the contribution of this tool, the authors intended to standardize the error-prone and observer-dependent manual Harris lines detection process. The main benefits from the tool are (a) the semi-automatic detection of Harris lines, (b) the digital measuring of the bones as well as the automated computation of the age-at-formation of each Harris line according to different methods / authors and (c) the generation of a table listing all analyzed data for direct statistical analysis (excel sheet). Furthermore, the reliability of the tool has been tested on radiographs of tibiae of a late Medieval Swiss population (Suter et al., 2008, and Papageorgopoulou et al., 2011).

The copyright is regulated under the LICENSE file. By using this code you agree to give credit to the original authors and their work in any work that results from using the Harris lines tool:

### Presentations

* [GfA Kongress in Freiburg, September 2007](hl_freiburg.pdf)
* [Harris Lines Workshop, December 2007](hl_workshop2.pdf)


### Journal Articles

* Papageorgopoulou C, Suter SK, Ruhli FJ, Siegmund F. [Harris Lines Revisited: Prevalence, Comorbidities, and Possible Etiologies](http://onlinelibrary.wiley.com/doi/10.1002/ajhb.21155/full). Am  J Hum Biol. May 2011; 23(3),381-391.

* Suter S, Harders M, Papageorgopoulou C, Kuhn G, Szekely G, Ruhli FJ. [Technical note: standardized and semiautomated Harris lines detection.](http://onlinelibrary.wiley.com/doi/10.1002/ajpa.20901/abstract ) Am J Phys Anthropol. 2008 Nov;137(3):362-6.


## More Information

* Slides and publications: http://harrislinestool.com/index.php/Publications/Publications

* User guide: http://harrislinestool.com/index.php/UserGuide/UserGuide

## Download
The Harris lines tool (HL Tool) may be used for scientific research and evaluation purposes only. You agree to give credit to the original authors (Suter et al., 2008, and Papageorgopoulou et al., 2011) in any work that results from using the Harris lines tool.

Windows (Win2000 +):
* [[Attach:HLTool20090630-1.zip | HL Tool]] (2009-06-30)
* [[Attach:CropDicomTool_win_20110420.zip | Crop Dicom Tool]] (2011-04-20)
* [[Attach:CropDicomTool_win_20090630.zip | Crop Dicom Tool]] (2009-06-30)


Mac OS X (Intel):
* [[Attach:HLTool20090630_osx.zip | HL Tool (mac os x)]] (2009-06-30), works but has some problems with the export. [[Contact/Contact]] the authors if you intend to use the export functionality.
* [[Attach:CropDicomTool20110420_osx.zip | Crop Dicom Tool (mac os x)]] (2011-04-20)
* [[Attach:CropDicomTool20090630_osx.zip | Crop Dicom Tool (mac os x)]] (2009-06-30)



#### MCR Libraries

* ftp-server: ftp.harrislinestool.com
* user: mcr@harrislinestool.com
* password: hltool2008


#### Sample Data
* [[Attach:DCMsamples.zip | sample data (2 dcm) ]]
* [[Attach:DCMsamples4.zip | sample data (4 dcm) ]]
* [[Attach:DCMsamples11.zip | sample data (11 dcm) ]]




## Installation Guidelines for the Harris Lines Tool 


### MatLab Standalone Application

The application runs as MatLab standalone application. This allows the user to run the tool without having installed a MatLab. No MatLab licence is needed. But there are some steps that need to be installed before running the Harris lines tool (You need administrator privileges). 

#### Steps for installation
- Install MCR libraries (MCRInstaller (exe, bin or dmg)
- perform the steps described in the [readme](install_readme.txt) file
- [[Download | download]] the Harris lines tool and double click on the executable of the application

For further help on installing and running a MatLab standalone application, visit the documentation website of MatLab: [[ http://www.mathworks.com/access/helpdesk/help/helpdesk.html| MatLab documentation]].


## Requirements

* MATLAB
* MATLAB Image Processing Toolbox

## User Guide
* [user guide crop dicom tool](Harris%20Lines%20Tool%20_%20UserGuide%20_%20CropDicom.pdf) (2011-04-20)

### Output of age-at-formation for the different methods:
The four different age-at-formation methods suggest and use different age categories for the final output. An overview is given here (for details see original publications):

* Maat, 1984: min-max age-at-formation: 0-18 (males), 0-16 (females) (steps between two age categories are smaller than 1 year, from the age-at-formation at the age of 1 year, there is an accuracy of 0.5 years per age-at-formation interval)

* Clarke, 1982: min-max age-at-formation: 0-16 (males+females) (steps between two age categories correspond continuously to 1 year)

* Byers, 1991: min-max age-at-formation: 1-17 (males), 1-16 (females) (steps between two age categories correspond continuously to 1 year)

* Hummert & van Gerven, 1985, only method for juveniles implemented: age-at-formation groups: 1, 2, 3, 4, 5, 6-7, 8-9, 10-11, 12-13, 14-16, the output of the tool is 1, 2, 3, 4, 5, 6, 8, 10, 12, 14, respectively.




## Known Issues

### Further Improvement

* Manually add and remove Harris lines
* Import format: DICOM. Tiff ? others?
* Combining two lines on the screen
* Add field to choose pixel/cm conversion (currently it numpix / resolution * 2.54)


### Other problems
* Case that one individual has only one epiphyses? Age computation method?
* What if you only have half of a tibia. E.g. only distal or proximal part?
* Calculation of age for unsexed individuals (tables only for either males or females)

Note: this repository is not actively improved (nor supported), but the code is available such that it can be reused.



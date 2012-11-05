The application contains following classes:

RootViewController:
- start updating GPS locations and shows it to the user (by CoreLocation class)
- if the updating fails, the sample values are loaded (but we can change them) and proceed
- the data from the foursquare is obtained by Foursquare class and parsed by JSONkit

FTableView:
- parses the results from foursquare and shows it in UITableViewController

Foursquare:
- Singleton class to obtain data form foursquare.com via http

CoreLoc:
- class to controll and proceed with GPS location 
- contains implementation in case of lack og GPS signal

JSONkit:
- downloaded class to help parsing JSon data

Constants.h
- some constant parameters, e.g sample latitude and longitude, GPS timeouts. 


Short manual:
- When the location is updated, press OK
- If the location is not updated, custom values appear, you can edit them and proceed with OK
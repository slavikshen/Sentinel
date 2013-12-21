# Sentinel 

## Description

Sentinel is an autmotatic UI log system.
It is designed to implement log for important ui activities without modification on the original ui code.

By default, the following events will be logged.

1. UIViewController
  * view did appear
  * view did disappear

2. UITableView
  * cell selected
  * cell deselected
  
3. UICollectionView
  * item selected
  * item deselected
  
I hope there will be a data mining system to support the studying of the log.
That will helps the devs to learn how the user behavior without adding log manually.

# Usage

Drag the folder Sentinel/Hack into the XCode project, then build.  :P That's all.

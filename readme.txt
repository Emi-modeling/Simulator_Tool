Transport_App_Kusel Executable

1. Prerequisites for Deployment 

Verify that MATLAB Runtime(R2025b) is installed.   
If not, you can run the MATLAB Runtime installer.
To find its location, enter
  
    >>mcrinstaller
      
at the MATLAB prompt.
NOTE: You will need administrator rights to run the MATLAB Runtime installer. 

Alternatively, download and install the Windows version of the MATLAB Runtime for R2025b 
from the following link on the MathWorks website:

    https://www.mathworks.com/products/compiler/mcr/index.html
   
For more information about the MATLAB Runtime and the MATLAB Runtime installer, see 
"Distribute Applications" in the MATLAB Compiler documentation  
in the MathWorks Documentation Center.


Folder Standalone Application

In the folder Standalone_Application you can find all the files I need to run the MATLAB App and which would be necessary to run it as a standalone app on your computer. 
Biking_files = This is a folder of pictures downloaded from the Web from which I use one for my App.
Co2_files = This is a folder of pictures downloaded from the Web from which I use one for my App.
Release = This folder contains all the necessary files to run the App as a standalone application.
ABM = A Matlab file containing code for the agent-based model I need for my App.
ABMTransportApp = A Matlab file containing code for the agent-based model I need for my App.
ADN2l = A Matlab file containing the simulation of the agent-based model I need for my App.
AllData = A cft file containing all the data I need for my App.
Calibration_Social_Inaction = A Matlab file containing the data preparation I need for my App.
Rmvnrnd = A Matlab file containing a function of the agent-based model I need for my App.
Screenshot (1-4) = Just some screenshots how the App should look in the end, maybe as evaluation for you to make sure it worked properly.
Transport_App_Kusel = A Matlab App file containing the actual code for the App.
Release folder contains:
C:\... WebApp_Lenze\Standalone_Application\release\package
Here you can find the App Installer that you need to run if you would like to install the App on your Laptop.
C:\... WebApp_Lenze\Standalone_Application\release\build
And here you find the actual Transport_App_Prototyp that you need to open after you install the App Installer to actually run the App.

Folder Web Application

This is the more important folder which contains the necessary files for an App which would run through a web application. 
MATLABWebAppServer = The MATLAB application website through which my App runs.
Readme = An own documentation from MATLAB about the App deployment.
Splash = MATLAB Logo
Transport_App.mltbx = Toolbox for my App
In the file build you can find Transport_App_Kusel.ctf = The actual file containing the code of my App.
In addition, the Transport_App_Prototyp.ctf file is also stored at my computer under C:\ProgramData\MathWorks\webapps\R2025b\apps. This is necessary to access the App through the MATLAB Web App Server in the end. I assume that it would need to be stored at a similar place from your hosting computer. 









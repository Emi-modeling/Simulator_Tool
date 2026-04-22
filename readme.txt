App_Climate_Policy Executable

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


Folder MATLAB-Code

In the folder MATLAB Code you can find all the files I need to run the MATLAB App in Matlab itself on your computer. 

ABM = A Matlab file containing code for the agent-based model I need for my App.
App_Climate_Policy = A Matlab file containing code for the agent-based model I need for my App.
ADN2l = A Matlab file containing the simulation of the agent-based model I need for my App.
AllData = A cft file containing all the data I need for my App.
Calibration_Social_Inaction = A Matlab file containing the data preparation I need for my App.
Rmvnrnd = A Matlab file containing a function of the agent-based model I need for my App.


Folder StandaloneApplication

This folder contains all the files necessary to run the App as a standalone application on a local computer.

When you manually export the code from Matlab the Code will be orgnaized as follows:
Release = This folder contains all the necessary files to run the App as a standalone application.
Folder Web Application
Release folder contains:
C:\... WebApp_Lenze\Standalone_Application\release\package
Here you can find the MyAppInstaller that you need to run if you would like to install the App on your Laptop. Igonore the other file that named after arbitrary letters. You need to do nothing with it.

C:\... WebApp_Lenze\Standalone_Application\release\build
And here you find the actual App_Climate_Policy that you need to open after you install the App Installer to actually run the App.
You further find 
- buildresult
- includedSupportPackages
- mccExcludedFiles
- readme
- requiredMCRProducts
- splash
- unresolvedSymbols
Igonore these other files. You need to do nothing with them.

Folder WebApplication

Also the code for the WebApplication can be found in the release folder which contains the necessary files for an App which would run through a web application. 

C:\... WebApp_Lenze\Standalone_Application\release\build

In the file build you can find App_Climate_Policy.ctf = The actual file containing the code of my App.
All other files can be ignored.

In addition, the App_Climate_Policy.ctf file is also stored at your computer under C:\ProgramData\MathWorks\webapps\R2025b\apps such as C:\Program Files\MATLAB\MATLABWebAppServer\R2025b\application. This is necessary to access the App through the MATLAB Web App Server in the end. It should be stored at a similar place from your hosting computer. 









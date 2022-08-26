[![Python application test with Github Actions](https://github.com/imhofmi/flask-sklearn/actions/workflows/python-app.yml/badge.svg)](https://github.com/imhofmi/flask-sklearn/actions/workflows/python-app.yml)

# Agile Development with Azure Project: Building a CI/CD Pipeline

## Overview
This project demonstrates the advantages of automating DevOps with CI/CD pipelines.
A Machine Learning web application is built, test, and deployed using Github Actions and Azure pipelines.

The [project plan](#project-plan) is followed by [instructions](#instructions) that detail the following steps:

   * [Cloning and testing locallcy](#cloning-and-testing-locally)

   * [Deploying to Azure App Services](#deploying-to-azure-app-services)

   * [Setting up CI/CD using Azure Pipelines](#setting-up-cicd-using-azure-pipelines)

Further improvements to the project are discussed in [enhancements](#enhancements).

A short [demo](#demo) concludes the documentation.

## Status

[![Python application test with Github Actions](https://github.com/imhofmi/flask-sklearn/actions/workflows/python-app.yml/badge.svg)](https://github.com/imhofmi/flask-sklearn/actions/workflows/python-app.yml)

<!---
[![Build Status](https://dev.azure.com/daimler-mic/ddpdev-azure-devops/_apis/build/status/imhofmi.flask-sklearn?branchName=main)](https://dev.azure.com/daimler-mic/ddpdev-azure-devops/_build/latest?definitionId=7205&branchName=main)
-->

## Project Plan

The [yearly project plan](https://docs.google.com/spreadsheets/d/1sBpBvsHc10Ye5TirvqN2-NznjpvUYs74U5Rk04GktDU/edit?pli=1#gid=1348135932) depicts that DevOps automation is one essential step in the context of the overall project planned for Q2.

The [quarterly project plan](https://docs.google.com/spreadsheets/d/1sBpBvsHc10Ye5TirvqN2-NznjpvUYs74U5Rk04GktDU/edit?pli=1#gid=1348135932) details the steps necessary for building the CI-CD pipeline and estimates the week by week deliverables as well as the effort associated to each deliverable in T-Shirt-Sizes (S,M,L).

The [Trello board](https://trello.com/b/Ey9sWsqr/ci-cd-pipeline-operational-procedure) is then used for task planning and tracking.


## Instructions

The overall architecture of this project is as follows:

![Architecture](architecture/Architecture.png "Architecture")

The code resides in a GitHub repo together with test cases that can be used for quality assurance.

A manual code checkout allows for local integration and testing, see [Cloning and testing locally](#cloning-and-testing-locally).

Continuous Integration (CI) of the code is performed upon each commit via GitHub Actions, see [Setting up CI using Github Actions](#setting-up-ci-using-github-actions).

The code can be executed in the cloud as a webapp in Azure App Services, see [Deploying to Azure App Services](#deploying-to-azure-app-services).

Finally, the combination of Continuous integration and Continuous Delivery (CI/CD) via Azure Pipelines is used to automatically reflect all comitted changes in the running webapp, see [Setting up CI/CD using Azure Pipelines](#setting-up-cicd-using-azure-pipelines).

### Cloning and Testing Locally

Head to https://github.com and clone the repo https://github.com/imhofmi/flask-sklearn.
The following instructions will use the original repo, you should replace them with your cloned repo.

Login to Azure and open the Azure cloud shell.

Clone this project from github and change to the project directory:
```bash
azureuser@Azure:~$ git clone https://github.com/imhofmi/flask-sklearn.git
azureuser@Azure:~$ cd flask-sklearn
```

Create a virtual environment and source it:
```bash
azureuser@Azure:~/flask-sklearn$ make setup
azureuser@Azure:~/flask-sklearn$ source ~/.flask-sklearn/bin/activate
```

![Clone repo / Create virtual environment](screenshots/S1-clone-make-source.PNG "Clone repo / Create virtual environment")


Build locally using 'make all' which will install all dependencies, perform linting and testing:
```bash
azureuser@Azure:~/flask-sklearn$ make all
```

![Build project](screenshots/S2-make-all.PNG "Build project")


Run the application locally:
```bash
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ flask run
```

![Run project](screenshots/S3-flask-run.PNG "Run project")

Test it locally in a new Azure cloud shell (as your first shell is blocked by 'flask run') :
```bash
azureuser@Azure:~$ source .flask-sklearn/bin/activate
(.flask-sklearn) azureuser@Azure:~$ cd flask-sklearn/
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ ./make_prediction.sh
```

![Test locally](screenshots/S4-make_prediction.sh.PNG "Test locally")

Close the second cloud shell and stop flask by hitting CRTL-C in the first cloud shell.


### Setting up CI using Github Actions
If you directly jumped to this section: Clone the repo:
```bash
azureuser@Azure:~$ git clone git@github.com:imhofmi/flask-sklearn.git
```
![Clone repo](screenshots/01_Cloud_Shell_Project_Cloned.PNG "Clone Repo")
Setup a virtual environment and activate it:
```bash
azureuser@Azure:~/flask-sklearn$ make setup
azureuser@Azure:~/flask-sklearn$ source ~/.flask-sklearn/bin/activate
```

Ensure that all tests pass locally:
```bash
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ make all
```
![Passing tests locally](screenshots/02_Cloud_Shell_make_all_passing_tests.PNG "Passing tests locally")

Enable Github Actions by clicking on 'Actions', then click on "set up a workflow yourself' and use the GitHub Actions yaml file [.github/workflows/python-app.yml](.github/workflows/python-app.yml) as a template.

Once the workflow is created it is automatically triggered and should show a passing build:
![Passing build](screenshots/03_GitHub_Actions_passing_build.PNG "Passing build")


### Deploying to Azure App Services
Install the app to Azure app services using the free tier:
```bash
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ az webapp up -n flask-sklearn --sku F1
```

![Install to Azure app services](screenshots/S5-az-webapp-up.PNG "Install to Azure app services")

Check if the app is up and running by opening the URL containing the webapp name provided in the previous step: https://flask-sklearn.azurewebsites.net/

![Running webapp](screenshots/S6-webapp-running.PNG "Running webapp")

Edit file 'make_predict_azure_app.sh' and replace '< yourappname >' with your webapp name (e.g. flask-sklearn).

Test the remote webapp:
```bash
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ ./make_predict_azure_app.sh
```
![Test remotely](screenshots/S7-make_predict_azure_app.sh.PNG "Test remotely")

Logs of your running webapp can be accessed in two ways:

A. Via the public endpoint by appending '/api/logs/docker': https://flask-sklearn.scm.azurewebsites.net/api/logs/docker

B. Via your cloud shell as a stream:
```bash
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ az webapp log tail
```
![Streamed webapp logs](screenshots/S13-webapp-logs.PNG "Streamed webapp logs")

Performance validation of the webapp can be performed via a load test using [locust](https://locust.io).
Replace '< yourappname >' in the provided configuration and call locust:
```bash
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ nano locustfile.py
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ locust -f locustfile.py --headless -u 20 -r 5 -t 20s
```
Using the parameters above locust will use 20 users with a spawn rate of 5 users per second and run for 20 seconds:
![Load test using locust](screenshots/S14-load-test-locust.PNG "Load test using locust")


### Setting up CI/CD using Azure Pipelines
At the time of writing the following steps were sufficient to setup a pipeline.
As things change quite fast in a cloud environment please consult the [official documentation provided by Microsoft](https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python-webapp?view=azure-devops) in case of unclarities.

Open Azure devops in a browser https://dev.azure.com.

Create a new project or selecting an existing project.

Head to Pipelines and click on 'New pipeline'.

When you are asked 'Where is your code?' select Github and choose your cloned repo.

Configure your pipeline as a "Python to Linux Web App on Azure", select your subscription and the webapp name you used to deploy the webapp earlier (e.g. flask-sklearn).
Click on 'Validate and configure'.

![Created pipeline](screenshots/S8-pipeline-created.PNG "Created pipeline")

Under 'Pipelines' you should now see a first successfull run of the pipeline including the 'Build stage' and the 'Deploy Web App' stage:

![First pipeline run](screenshots/S9-first-pipeline-run.PNG "First pipeline run")

From now on every change to your code will trigger the CI/CD pipeline and update your webapp accordingly:

Change the application name in app.py from 'Sklearn Prediction Home' to 'Sklearn Prediction Home via Azure CI/CD Pipeline' and commit it:
```bash
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ nano app.py
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ git add app.py
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ git commit -m "Changed application name"
(.flask-sklearn) azureuser@Azure:~/flask-sklearn$ git push
```
![Change application name](screenshots/S10-change-application-name.PNG "Change application name")

The pipeline is triggered by the commit:
![Next pipeline run](screenshots/S11-next-pipeline-run.PNG "Next pipeline run")

After the pipeline run completed successfully the changed application name is visible:
![Updated webapp](screenshots/S12-webapp-running-new-name.PNG "Updated webapp")


## Enhancements
Future improvements include but are not limited to:
* Additional testing using pytest: Testcases could be added that are automatically checked by a Makefile target.
* Code coverage using pytest-cov: In addition to testing code coverage could be checked in an automated way via a Makefile target.
* Automation of the load testing using locust: While the instructions in the [Deploying to Azure App Services](#deploying-to-azure-app-services) section depict the initial use of locust for load testing it could be included as an additional target in the Makefile.


## Demo

A short demo demonstrates the main steps of the project:
[Demo Video](../../raw/main/demo/demo.mp4)

The demo covers the following steps:
> Welcome to the demo of our agile development project.
> We built a machine learning application and automated testing and provisioning by continuous integration and continuous deployment using pipelines.
>
> As shown in the project architecture the source code is maintained in Github.
> The project can be manually checked out in cloud shell and tested by calling 'make all'.
>
> GitHub Actions are used for Continuous Integration to check the project build status upon every commit.
>
> Azure Pipelines are used for Continuous Integration and Continuous Deployment of our machine learning application to App Services.
> The application can be accessed via a public endpoint.
> The logs are accessible via that endpoint or can be streamed in the cloud shell.
> The main functionality of the application is exposed via an API and can be accessed from the cloud shell.
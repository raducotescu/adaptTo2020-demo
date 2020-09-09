Paving the way to a native Sling - AEM Demo
====

This project, based on the [AEM Project Archetype](https://github.com/adobe/aem-project-archetype),
provides a demo on how developers can work with precompiled HTL components for their AEM as a Cloud Service projects.
 
## Modules

The following modules provide this demo's functionality:

* `core`: OSGi bundle containing the precompiled HTL component (a variation of the Image component) and its associated Sling Model.
* `ui.apps`: contains the `/apps` part of the project, in this case the components' dialogs and client libraries
* `ui.content`: contains some sample content using the components from the `ui.apps` module

## How to build & run

### Prerequisites 

Make sure you have a running AEMaaCS SDK instance. If you need to download one, head over to https://experience.adobe.com/#/downloads/content/software-distribution/en/aemcloud.html.

More details are available at https://docs.adobe.com/content/help/en/experience-manager-cloud-service/implementing/developing/aem-as-a-cloud-service-sdk.html.

### Build

To build all the modules run in the project root directory the following command with Maven 3:

    mvn clean install

If you have a running AEM instance you can build and package the whole project and deploy into AEM with

    mvn clean install -PautoInstallPackage

Or to deploy it to a publish instance, run

    mvn clean install -PautoInstallPackagePublish

Or alternatively

    mvn clean install -PautoInstallPackage -Daem.port=4503

Or to deploy only the bundle to the author, run

    mvn clean install -PautoInstallBundle

## Maven settings

The project comes with the auto-public repository configured. To setup the repository in your Maven settings, refer to:

    http://helpx.adobe.com/experience-manager/kb/SetUpTheAdobeMavenRepository.html

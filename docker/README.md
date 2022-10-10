Daas-MLOPs 'Admisión de crédito'                 
============================

## Project & Folder structure               

### Top-level directory layout  

    

    ├── docker                    # Docker configurations
        ├── consuming             # Inference files to be edited by the user to implement scoring
            ├── Dockerfile
            ├── score.py    
        ├── mlops                # CI/CD Inference purpose not required to be editable by the user
            ├── Dockerfile
            ├── load.py 
            ├── register.py
            ├── save.py
        ├── training             # Training files to be edited by the user to implement train
            ├── Dockerfile
            ├── Readme.md 
            ├── train.py
    ├── pipelines                # Pipelines configuration for deployment
        ├── config               # User pipeline parameters configuration for training and inference
            ├── consuming              
                ├── inference.yml
            ├── training
                ├── hyperparameters.yml
                ├── training.yml  
        ├── scripts              # CI/CD purpose not required to be editable by the user
            ├── azureml_utils.py
            ├── azureml_utils.sh
            ├── azureml-cli-config.sh
            ├── env-scripts-config.sh
            ├── mlflow-cli-config.sh 
        ├── pipeline-deploy-batch.yml
        ├── pipeline-train.yml                     
    ├── workspace                 # Notebook for developing by stages: discovery, featuring & assesment
        ├── nb-application-admision-credito-discovery.ipynb # Notebook for raw data discovery
        ├── nb-applicacion-admision-credito-featuring.ipynb # Notebook for the generation of features that allow generating the training datasets
        ├── nb-applicacion-admision-credito-model-assesment.ipynb  # Notebook for the evaluation of the trained models and approval for the QA stage
        ├── nb-applicacion-admision-credito-discovery-inference.ipynb  # Notebook for the evaluation of inference predictions
    └── README.md                 # Root Project documentation



## INSTRUCTIONS TO WORK WITH DaaS-MLOPs

### 1.  RUN ASIGNED COMPUTE INSTANCES (CI)*

    A.  Go to Azure ML Portal and click at "Compute" option.
    B.  Start the CI. Click at "Start" for initilizing the CI.
    C.  Click at "VS Code" (On the 'Applications' Column) to launch Visual Studio Code application (You need to 'trust' the connection).


> *Note: CIs ending witg 'D' (Development) are assigned to users to run notebooks. CIs ending with 'T' (Training) are assigned to users to launch trainings. 

> *Note: Every user has an asigned CI. Each CI is individual and an unshared resource to work with. 

### 2.  WORKING WITH VISUAL STUDIO CODE (VS Code)

    A.  Inside of "VS Code":

>   Go to "View" (Upper side) -> 'Command Palette'->'Git Clone'-> Insert':

>   https://{add you user ID}:{add you password}@github.alm.europe.cloudcenter.corp/scq-daas/scf-daas-ai-ac-aml-001.git' 

    B.  Link with your working path:

>   /home/azureuser/cloudfiles/code/Users/{select you user ID}

    Click at 'OK'.(The project will be automatically cloned). 

    C.  A new box will appear with this message:
>   "Would you like to open the cloned repository, or add it to the current workspace?"

    Select 'Open in a New Window'. 

    D. After a while, your project will appear. Now, we need to choose our git branch to work properly. On left side, select 'Git Icon' (The third one). You will see git options and on the right side of 'SOURCE CONTROL', click at '...'. Click at 'Source Control Repositories' to visualize git branches. Then, select your working branch:

>   (e.g.'Feature/migration-tests-ci'). 

    Any time that modify anything in your code will appear inside of 'Changes'. 
    D.  To promote changes, you need to 'stage' your changes and add a 'message' in order to commit your changes. Then, you can pull-push to the remote repository of your project.



### 3.  LAUNCH A TRAINING


1. Edit training configuracion

Edit he training file configuration on the application project. You can locate at: **"[ROOT_PROJECT]/pipelines/training/training.yml"**.
Set the following propierties:

    ```yaml
    # Dataset version and name to be provided during training
    dataset: 
      version: 1
      train: daas-wkb-admision-credito-train
      test: daas-wkb-admision-credito-test
      evaluation: daas-wkb-admision-credito-evaluation
    # Model name and description to be registered when the trainings ends
    model:
      name: valor-residual
      description:  >
                    Modelo de valor residual.
    #Training information
    training:
        # Set type of training to single
        type: single
        # Set here the name of the compute instance
        cluster_name: [Name of the compute Instance]
        # Set cluster_type to "ci" value
        cluster_type: "ci"
        # Other staff
    ```

2. Increase version at 'version.json'

    ```{
    "version":"1.0.8-SNAPSHOT"
    }
    ```

3. Commit & Push your changes into mlops/training to run an attended training

>   Check at 'Jobs' funtionality your training status 

![image](https://github.alm.europe.cloudcenter.corp/storage/user/15472/files/2458e86c-18bf-46d8-80a9-bb88c8de89e6)


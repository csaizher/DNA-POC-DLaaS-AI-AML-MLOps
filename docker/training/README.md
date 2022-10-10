# Introduction 
This is the code to train the model. The training generates a model.  The code includes an evaluation of the model against a test dataset.
Trhe training code is executed inside a compute unit as a container.

# Getting Started
1.	**Installation process**

    Download the copy and execute the code using a Python 3.x environment.

2.	**Software dependencies**

    In order to execute the code in a local or separate environment you need to install the following dependencies using pip:
    - pandas: datascientist library to work with data/dataframes
    - sklearn: datascinetist library containing ML algorithms implementations
    - termcolor: Specific library to enrich logged messages

    Additionally, the training code uses Azure ML Python SDK and MLFlow. Both frameworks give support to metrics registration and model persistence. These frameworks requires extra packages:
    - azureml-mlflow 
    - mlflow
    - azureml-sdk
    - azureml-core

    The standard installation of these libraries can be done using the pip command:

    ```shell
    pip install pandas sklearn termcolor azureml-mlflow mlflow azureml-sdk
    ```

3.	Latest releases

    None.

4.	API references

    None.

# Build and Test

N/A

# Contribute

N/A 

# Help

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)


